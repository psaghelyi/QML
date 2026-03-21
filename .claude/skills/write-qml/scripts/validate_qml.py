#!/usr/bin/env python3
"""
QML Validator — CLI tool for formally verifying QML questionnaire files.

Runs all four validation steps from the thesis validation hierarchy
(see docs/thesis/chapters/comprehensive_validation.tex):

  Step 1: Per-item classification with witness formula W_i = B ∧ P_i ∧ ¬Q_i
  Step 2: Global satisfiability F = B ∧ ∧(P_i ⇒ Q_i)
  Step 3: Dependency loop detection via QMLTopology (stable Kahn's algorithm)
  Step 4: Path-based reachability with accumulated constraints A_i = B ∧ ∧{j∈Pred(i)}(P_j ⇒ Q_j)

Usage:
    python validate_qml.py <path-to-qml-file> [--json]

Exit codes:
    0 = Valid (no issues)
    1 = Issues found (NEVER reachable items, INFEASIBLE postconditions, cycles, dead code)
    2 = Error (file not found, parse error, schema violation)
"""

import argparse
import json
import sys
from pathlib import Path

# Add the repo root to path so askalot_qml is importable
REPO_ROOT = Path(__file__).resolve().parents[4]
if str(REPO_ROOT) not in sys.path:
    sys.path.insert(0, str(REPO_ROOT))

from askalot_qml.core.qml_loader import QMLLoader
from askalot_qml.core.qml_engine import QMLEngine
from askalot_qml.models.qml_state import QMLState
from askalot_qml.z3.item_classifier import ItemClassifier
from askalot_qml.z3.global_formula import GlobalFormula
from askalot_qml.z3.path_based_validation import PathBasedValidator


def validate_qml(file_path: str) -> dict:
    """
    Validate a QML file through all four verification steps.

    Returns a dict with per-step results, aggregate statistics, and issues.
    """
    results = {
        "file": file_path,
        "valid": True,
        "issues": [],
        "statistics": {},
        "steps": {},
    }

    # --- Load and parse QML ---
    try:
        loader = QMLLoader(schema_path=None)
        data = loader.load_from_path(file_path)
    except FileNotFoundError:
        results["valid"] = False
        results["issues"].append({"type": "error", "message": f"File not found: {file_path}"})
        return results
    except Exception as e:
        results["valid"] = False
        results["issues"].append({"type": "error", "message": f"Parse error: {e}"})
        return results

    # --- Schema validation (structural check before formal verification) ---
    try:
        schema_loader = QMLLoader()
        schema_loader.qml_content = Path(file_path).read_text(encoding="utf-8")
        schema_loader.parsed_yaml = __import__("yaml").safe_load(schema_loader.qml_content)
        if "questionnaire" in schema_loader.parsed_yaml:
            schema_loader._normalize_all_predicates(schema_loader.parsed_yaml["questionnaire"])
        schema_loader._validate_against_schema()
    except Exception as e:
        msg = str(e).split("\n")[0] if "\n" in str(e) else str(e)
        results["issues"].append({"type": "warning", "message": f"Schema: {msg}"})

    # --- Build engine (StaticBuilder + QMLTopology) ---
    state = QMLState(data)
    try:
        engine = QMLEngine(state)
    except Exception as e:
        results["valid"] = False
        results["issues"].append({"type": "error", "message": f"Engine initialization failed: {e}"})
        return results

    items = state.get_items()
    engine_stats = engine.get_statistics()
    results["statistics"] = {
        "items": engine_stats.get("total_items", 0),
        "blocks": len(state.get_blocks()),
        "preconditions": sum(1 for i in items if i.get("precondition")),
        "postconditions": sum(1 for i in items if i.get("postcondition")),
        "variables": engine_stats.get("ssa_versions", 0),
        "dependencies": engine_stats.get("total_dependencies", 0),
        "connected_components": engine_stats.get("total_components", 0),
    }

    # ================================================================
    # Step 1: Per-item classification with witness formula
    #         W_i = B ∧ P_i ∧ ¬Q_i
    #
    # For each item, classifies:
    #   Precondition reachability: ALWAYS | CONDITIONAL | NEVER
    #   Postcondition invariant:   TAUTOLOGICAL | CONSTRAINING | INFEASIBLE | NONE
    #
    # NEVER reachable → dead code (precondition unsatisfiable under domain B)
    # INFEASIBLE      → design error (postcondition can never hold when reached)
    # SAT(W_i)        → witness exists where item is reached but postcondition fails
    # ================================================================
    step1 = {"name": "per_item_classification", "status": "skipped", "detail": {}}
    try:
        classifier = ItemClassifier(engine.static_builder)
        classifications = classifier.classify_all_items()

        precond_counts = {}
        postcond_counts = {}

        for item_id, cls in classifications.items():
            precond = cls.get("precondition", {}).get("status", "UNKNOWN")
            postcond = cls.get("postcondition", {}).get("invariant", "NONE")

            precond_counts[precond] = precond_counts.get(precond, 0) + 1
            postcond_counts[postcond] = postcond_counts.get(postcond, 0) + 1

            if precond == "NEVER":
                results["issues"].append({
                    "type": "error",
                    "step": 1,
                    "item": item_id,
                    "message": "NEVER reachable — precondition unsatisfiable under domain constraints B"
                })
                results["valid"] = False

            if postcond == "INFEASIBLE":
                results["issues"].append({
                    "type": "error",
                    "step": 1,
                    "item": item_id,
                    "message": "INFEASIBLE postcondition — UNSAT(B ∧ P_i ∧ Q_i), can never be satisfied when reached"
                })
                results["valid"] = False

        step1["status"] = "completed"
        step1["detail"] = {
            "precondition_reachability": precond_counts,
            "postcondition_invariant": postcond_counts,
            "classifications": classifications,
        }

    except Exception as e:
        step1["status"] = "failed"
        step1["detail"] = {"error": str(e)}
        results["issues"].append({
            "type": "warning",
            "step": 1,
            "message": f"Per-item classification failed: {e}"
        })

    results["steps"]["step1_per_item"] = step1

    # ================================================================
    # Step 2: Global satisfiability
    #         F = B ∧ ∧(P_i ⇒ Q_i)
    #
    # Checks whether at least one valid questionnaire completion exists.
    # SAT(F)   → some assignment satisfies all domain + postcondition constraints
    # UNSAT(F) → accumulated postconditions conflict (Theorem: Accumulated Constraints)
    #            By Theorem (Global Necessary), no execution path is valid either.
    #
    # Note: per-item passes ⇒ global passes (Theorem: Soundness).
    # If all W_i are UNSAT (all postconditions TAUTOLOGICAL), this step is
    # guaranteed SAT but still run as confirmation.
    # ================================================================
    step2 = {"name": "global_satisfiability", "status": "skipped", "detail": {}}
    try:
        global_checker = GlobalFormula(engine.static_builder)
        global_result = global_checker.check()

        step2["status"] = "completed"
        step2["detail"] = {
            "satisfiable": global_result.satisfiable,
            "z3_status": global_result.status,
            "message": global_result.message,
        }

        if global_result.satisfiable and global_result.witness:
            step2["detail"]["witness"] = global_result.witness

        if not global_result.satisfiable:
            results["issues"].append({
                "type": "error",
                "step": 2,
                "message": f"Global formula UNSAT — {global_result.message}"
            })
            results["valid"] = False

    except Exception as e:
        step2["status"] = "failed"
        step2["detail"] = {"error": str(e)}
        results["issues"].append({
            "type": "warning",
            "step": 2,
            "message": f"Global satisfiability check failed: {e}"
        })

    results["steps"]["step2_global"] = step2

    # ================================================================
    # Step 3: Dependency loop detection via QMLTopology
    #         Stable Kahn's algorithm with min-heap priority
    #
    # Builds the dependency graph from StaticBuilder's constraint analysis
    # and computes topological order. Two complementary cycle detectors:
    #   1. Z3 ordering constraints: UNSAT means no valid ordering exists
    #   2. Kahn's algorithm: items remaining after processing indicate cycles
    #
    # Cycles indicate variable feedback loops (item A reads variable X in
    # precondition, downstream item B writes X in codeBlock).
    # ================================================================
    step3 = {"name": "dependency_loops", "status": "skipped", "detail": {}}
    try:
        has_cycles = engine.has_cycles()
        cycles = engine.get_cycles()
        topo_order = engine.get_topological_order()

        step3["status"] = "completed"
        step3["detail"] = {
            "has_cycles": has_cycles,
            "cycles": cycles,
            "topological_order": topo_order,
            "total_dependencies": engine_stats.get("total_dependencies", 0),
        }

        if has_cycles:
            for cycle in cycles:
                cycle_str = " → ".join(cycle + [cycle[0]])
                results["issues"].append({
                    "type": "error",
                    "step": 3,
                    "message": f"Dependency cycle: {cycle_str}"
                })
            results["valid"] = False

    except Exception as e:
        step3["status"] = "failed"
        step3["detail"] = {"error": str(e)}
        results["issues"].append({
            "type": "warning",
            "step": 3,
            "message": f"Dependency loop detection failed: {e}"
        })

    results["steps"]["step3_dependency_loops"] = step3

    # ================================================================
    # Step 4: Path-based reachability and accumulated postcondition satisfiability
    #         A_i = B ∧ ∧{j∈Pred(i)}(P_j ⇒ Q_j)
    #
    # For each CONDITIONAL item, checks SAT(A_i ∧ P_i) where Pred(i) are
    # predecessor items in the topological order.
    #
    # Detects dead code: items whose preconditions are satisfiable in
    # isolation (CONDITIONAL per step 1) but become unreachable when
    # accumulated postconditions from predecessors are considered.
    #
    # Example: Q1 postcond S1 > 50, Q2 precond S1 < 30 → Q2 is dead code
    # because A_2 ∧ P_2 = B ∧ (S1 > 50) ∧ (S1 < 30) is UNSAT.
    #
    # Theorem (Global Not Sufficient): SAT(F) does NOT guarantee all items
    # reachable — this step catches what global validation misses.
    # ================================================================
    step4 = {"name": "path_based_reachability", "status": "skipped", "detail": {}}
    try:
        path_validator = PathBasedValidator(engine.static_builder, engine.topology)
        path_result = path_validator.validate()

        step4["status"] = "completed"
        step4["detail"] = {
            "has_dead_code": path_result.has_dead_code,
            "dead_code_items": path_result.dead_code_items if path_result.has_dead_code else [],
            "message": path_result.message,
        }

        if path_result.has_dead_code:
            for item_id in path_result.dead_code_items:
                item_detail = path_result.item_results.get(item_id)
                preds = item_detail.predecessors if item_detail else []
                pred_str = f" (predecessors: {', '.join(preds)})" if preds else ""
                results["issues"].append({
                    "type": "warning",
                    "step": 4,
                    "item": item_id,
                    "message": f"Dead code — CONDITIONAL but UNSAT(A_i ∧ P_i) under accumulated constraints{pred_str}"
                })

    except Exception as e:
        step4["status"] = "failed"
        step4["detail"] = {"error": str(e)}
        results["issues"].append({
            "type": "warning",
            "step": 4,
            "message": f"Path-based reachability check failed: {e}"
        })

    results["steps"]["step4_path_based"] = step4

    return results


def print_results(results: dict, output_json: bool = False) -> None:
    """Print validation results in human-readable or JSON format."""
    if output_json:
        output = dict(results)
        # Strip verbose per-item classifications from JSON output
        step1 = output.get("steps", {}).get("step1_per_item", {})
        if "detail" in step1 and "classifications" in step1["detail"]:
            del step1["detail"]["classifications"]
        print(json.dumps(output, indent=2, default=str))
        return

    stats = results["statistics"]
    steps = results["steps"]

    print(f"\n{'=' * 70}")
    print(f"  QML Formal Verification Report")
    print(f"  {results['file']}")
    print(f"{'=' * 70}")

    # Structure summary
    print(f"\n  Structure")
    print(f"  {'─' * 40}")
    print(f"  Items: {stats.get('items', '?')}  |  Blocks: {stats.get('blocks', '?')}  |  Components: {stats.get('connected_components', '?')}")
    print(f"  Preconditions: {stats.get('preconditions', '?')}  |  Postconditions: {stats.get('postconditions', '?')}")
    print(f"  Variables (SSA): {stats.get('variables', '?')}  |  Dependencies: {stats.get('dependencies', '?')}")

    # Step 1: Per-item classification
    s1 = steps.get("step1_per_item", {})
    print(f"\n  Step 1: Per-Item Classification  W_i = B ∧ P_i ∧ ¬Q_i")
    print(f"  {'─' * 40}")
    if s1.get("status") == "completed":
        detail = s1.get("detail", {})
        precond = detail.get("precondition_reachability", {})
        postcond = detail.get("postcondition_invariant", {})
        if precond:
            parts = [f"{status}: {count}" for status, count in sorted(precond.items())]
            print(f"  Reachability:  {' | '.join(parts)}")
        if postcond:
            parts = [f"{status}: {count}" for status, count in sorted(postcond.items())]
            print(f"  Invariant:     {' | '.join(parts)}")
    else:
        print(f"  Status: {s1.get('status', 'skipped')}")

    # Step 2: Global satisfiability
    s2 = steps.get("step2_global", {})
    print(f"\n  Step 2: Global Satisfiability  F = B ∧ ∧(P_i ⇒ Q_i)")
    print(f"  {'─' * 40}")
    if s2.get("status") == "completed":
        detail = s2.get("detail", {})
        sat = detail.get("satisfiable")
        status_str = "SAT" if sat else "UNSAT"
        print(f"  Result: {status_str}")
        if detail.get("message"):
            print(f"  Detail: {detail['message']}")
    else:
        print(f"  Status: {s2.get('status', 'skipped')}")

    # Step 3: Dependency loops
    s3 = steps.get("step3_dependency_loops", {})
    print(f"\n  Step 3: Dependency Loops  (Kahn's algorithm)")
    print(f"  {'─' * 40}")
    if s3.get("status") == "completed":
        detail = s3.get("detail", {})
        has_cycles = detail.get("has_cycles", False)
        deps = detail.get("total_dependencies", 0)
        print(f"  Dependencies: {deps}  |  Cycles: {'YES' if has_cycles else 'None'}")
        if has_cycles:
            for cycle in detail.get("cycles", []):
                print(f"  Cycle: {' → '.join(cycle + [cycle[0]])}")
    else:
        print(f"  Status: {s3.get('status', 'skipped')}")

    # Step 4: Path-based reachability
    s4 = steps.get("step4_path_based", {})
    print(f"\n  Step 4: Path-Based Reachability  A_i = B ∧ ∧{{Pred}}(P_j ⇒ Q_j)")
    print(f"  {'─' * 40}")
    if s4.get("status") == "completed":
        detail = s4.get("detail", {})
        dead = detail.get("dead_code_items", [])
        if dead:
            print(f"  Dead code: {', '.join(dead)}")
        else:
            print(f"  Result: All conditional items are accumulated-reachable")
    else:
        print(f"  Status: {s4.get('status', 'skipped')}")

    # Issues
    issues = results["issues"]
    if issues:
        errors = [i for i in issues if i["type"] == "error"]
        warnings = [i for i in issues if i["type"] == "warning"]

        print(f"\n  Issues ({len(errors)} errors, {len(warnings)} warnings)")
        print(f"  {'─' * 40}")
        for issue in issues:
            icon = "X" if issue["type"] == "error" else "!"
            step = f"[Step {issue['step']}] " if "step" in issue else ""
            item = f"{issue['item']}: " if issue.get("item") else ""
            print(f"  [{icon}] {step}{item}{issue['message']}")

    # Final verdict
    status = "VALID" if results["valid"] else "ISSUES FOUND"
    print(f"\n{'=' * 70}")
    print(f"  Result: {status}")
    print(f"{'=' * 70}\n")


def main():
    parser = argparse.ArgumentParser(
        description="Formally verify a QML questionnaire file using Z3 SMT solving."
    )
    parser.add_argument("file", help="Path to the QML file to validate")
    parser.add_argument(
        "--json", action="store_true",
        help="Output results as JSON"
    )
    args = parser.parse_args()

    results = validate_qml(args.file)
    print_results(results, output_json=args.json)

    sys.exit(0 if results["valid"] else 1)


if __name__ == "__main__":
    main()
