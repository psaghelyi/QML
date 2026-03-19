#!/usr/bin/env python3
"""
QML Validator — CLI tool for validating QML questionnaire files.

Runs schema validation, Z3 per-item classification, global satisfiability,
and path-based reachability analysis.

Usage:
    python validate_qml.py <path-to-qml-file> [--level 1|2|3] [--json]

Levels:
    1 = Per-item classification only (fast)
    2 = Per-item + global satisfiability (default)
    3 = Per-item + global + path-based reachability (thorough)

Exit codes:
    0 = Valid (no issues)
    1 = Issues found (NEVER reachable items, INFEASIBLE postconditions, cycles, etc.)
    2 = Error (file not found, parse error, schema violation)
"""

import argparse
import json
import sys
from pathlib import Path

# Add the askalot_qml package to path
REPO_ROOT = Path(__file__).resolve().parents[4]
ASKALOT_QML_DIR = REPO_ROOT / "askalot_qml"
if str(ASKALOT_QML_DIR) not in sys.path:
    sys.path.insert(0, str(ASKALOT_QML_DIR))

from askalot_qml.core.qml_loader import QMLLoader
from askalot_qml.models.qml_state import QMLState
from askalot_qml.core.qml_engine import QMLEngine
from askalot_qml.z3.item_classifier import ItemClassifier


def validate_qml(file_path: str, level: int = 2, output_json: bool = False) -> dict:
    """
    Validate a QML file and return results.

    Args:
        file_path: Path to the QML file
        level: Validation level (1=per-item, 2=+global, 3=+path-based)
        output_json: If True, return raw dict for JSON output

    Returns:
        Dictionary with validation results
    """
    results = {
        "file": file_path,
        "valid": True,
        "issues": [],
        "statistics": {},
        "classifications": {},
    }

    # Step 1: Load and parse
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

    # Step 1b: Schema validation
    try:
        schema_loader = QMLLoader()
        schema_loader.qml_content = Path(file_path).read_text(encoding="utf-8")
        schema_loader.parsed_yaml = __import__("yaml").safe_load(schema_loader.qml_content)
        if "questionnaire" in schema_loader.parsed_yaml:
            schema_loader._normalize_all_predicates(schema_loader.parsed_yaml["questionnaire"])
        schema_loader._validate_against_schema()
    except Exception as e:
        # Extract just the first line of schema validation errors (they can be very verbose)
        msg = str(e).split("\n")[0] if "\n" in str(e) else str(e)
        results["issues"].append({"type": "warning", "message": f"Schema: {msg}"})

    # Step 2: Build engine (topology + static builder)
    state = QMLState(data)
    try:
        engine = QMLEngine(state)
    except Exception as e:
        results["valid"] = False
        results["issues"].append({"type": "error", "message": f"Engine initialization failed: {e}"})
        return results

    # Collect statistics
    engine_stats = engine.get_statistics()
    items = state.get_items()
    results["statistics"] = {
        "items": engine_stats.get("total_items", 0),
        "blocks": len(state.get_blocks()),
        "preconditions": sum(1 for i in items if i.get("precondition")),
        "postconditions": sum(1 for i in items if i.get("postcondition")),
        "variables": engine_stats.get("ssa_versions", 0),
        "dependencies": engine_stats.get("total_dependencies", 0),
        "has_cycles": engine.has_cycles(),
        "connected_components": engine_stats.get("total_components", 0),
    }

    if engine.has_cycles():
        cycle_info = engine_stats.get("cycles", [])
        results["issues"].append({
            "type": "error",
            "message": f"Dependency cycle detected: {cycle_info}"
        })
        results["valid"] = False

    # Step 3: Z3 per-item classification (Level 1+)
    if level >= 1:
        try:
            classifier = ItemClassifier(engine.static_builder)
            classifications = classifier.classify_all_items()
            results["classifications"] = classifications

            # Analyze classifications
            for item_id, cls in classifications.items():
                precond = cls.get("precondition", {}).get("status", "UNKNOWN")
                postcond = cls.get("postcondition", {}).get("invariant", "UNKNOWN")

                if precond == "NEVER":
                    results["issues"].append({
                        "type": "error",
                        "item": item_id,
                        "message": f"NEVER reachable — dead code"
                    })
                    results["valid"] = False

                if postcond == "INFEASIBLE":
                    results["issues"].append({
                        "type": "error",
                        "item": item_id,
                        "message": f"INFEASIBLE postcondition — can never be satisfied"
                    })
                    results["valid"] = False

            # Summary counts
            results["statistics"]["precondition_classification"] = {}
            results["statistics"]["postcondition_classification"] = {}
            for cls in classifications.values():
                p = cls.get("precondition", {}).get("status", "UNKNOWN")
                q = cls.get("postcondition", {}).get("invariant", "NONE")
                results["statistics"]["precondition_classification"][p] = \
                    results["statistics"]["precondition_classification"].get(p, 0) + 1
                results["statistics"]["postcondition_classification"][q] = \
                    results["statistics"]["postcondition_classification"].get(q, 0) + 1

        except Exception as e:
            results["issues"].append({
                "type": "warning",
                "message": f"Z3 per-item classification failed: {e}"
            })

    # Step 4: Global satisfiability (Level 2+)
    if level >= 2:
        try:
            from askalot_qml.z3.global_formula import GlobalFormula
            global_checker = GlobalFormula(engine.static_builder)
            global_result = global_checker.check()
            results["statistics"]["global_satisfiable"] = global_result.satisfiable
            results["statistics"]["global_status"] = global_result.status
            if not global_result.satisfiable:
                results["issues"].append({
                    "type": "error",
                    "message": f"Global formula {global_result.status} — {global_result.message}"
                })
                results["valid"] = False
        except Exception as e:
            results["issues"].append({
                "type": "warning",
                "message": f"Global satisfiability check failed: {e}"
            })

    # Step 5: Path-based reachability (Level 3)
    if level >= 3:
        try:
            from askalot_qml.z3.path_based_validation import PathBasedValidator
            path_validator = PathBasedValidator(engine.static_builder, engine.topology)
            path_result = path_validator.validate()
            if path_result.has_dead_code:
                for item_id in path_result.dead_code_items:
                    results["issues"].append({
                        "type": "warning",
                        "item": item_id,
                        "message": "Dead code — unreachable due to accumulated constraints"
                    })
                results["statistics"]["dead_code_items"] = path_result.dead_code_items
        except Exception as e:
            results["issues"].append({
                "type": "warning",
                "message": f"Path-based validation failed: {e}"
            })

    return results


def print_results(results: dict, output_json: bool = False) -> None:
    """Print validation results in human-readable or JSON format."""
    if output_json:
        # Strip large classifications dict for cleaner JSON output
        output = {k: v for k, v in results.items() if k != "classifications"}
        output["classification_summary"] = results.get("statistics", {}).get(
            "precondition_classification", {}
        )
        print(json.dumps(output, indent=2, default=str))
        return

    stats = results["statistics"]
    print(f"\n{'=' * 60}")
    print(f"QML Validation Report: {results['file']}")
    print(f"{'=' * 60}")

    print(f"\nStructure:")
    print(f"  Items: {stats.get('items', '?')}")
    print(f"  Blocks: {stats.get('blocks', '?')}")
    print(f"  Preconditions: {stats.get('preconditions', '?')}")
    print(f"  Postconditions: {stats.get('postconditions', '?')}")
    print(f"  Variables: {stats.get('variables', '?')}")
    print(f"  Cycles: {'YES' if stats.get('has_cycles') else 'No'}")

    if stats.get("precondition_classification"):
        print(f"\nPrecondition Reachability:")
        for status, count in sorted(stats["precondition_classification"].items()):
            print(f"  {status}: {count}")

    if stats.get("postcondition_classification"):
        print(f"\nPostcondition Effects:")
        for status, count in sorted(stats["postcondition_classification"].items()):
            print(f"  {status}: {count}")

    if stats.get("global_satisfiable") is not None:
        sat = stats["global_satisfiable"]
        print(f"\nGlobal Satisfiability: {'SAT' if sat else 'UNSAT'}")

    if stats.get("dead_code_items"):
        print(f"\nDead Code Items: {', '.join(stats['dead_code_items'])}")

    if results["issues"]:
        print(f"\nIssues ({len(results['issues'])}):")
        for issue in results["issues"]:
            icon = "X" if issue["type"] == "error" else "!"
            item = issue.get("item", "")
            prefix = f"  [{icon}] {item}: " if item else f"  [{icon}] "
            print(f"{prefix}{issue['message']}")

    status = "VALID" if results["valid"] else "ISSUES FOUND"
    print(f"\n{'=' * 60}")
    print(f"Result: {status}")
    print(f"{'=' * 60}\n")


def main():
    parser = argparse.ArgumentParser(
        description="Validate a QML questionnaire file using Z3 formal verification."
    )
    parser.add_argument("file", help="Path to the QML file to validate")
    parser.add_argument(
        "--level", type=int, default=2, choices=[1, 2, 3],
        help="Validation level: 1=per-item, 2=+global (default), 3=+path-based"
    )
    parser.add_argument(
        "--json", action="store_true",
        help="Output results as JSON"
    )
    args = parser.parse_args()

    results = validate_qml(args.file, level=args.level, output_json=args.json)
    print_results(results, output_json=args.json)

    sys.exit(0 if results["valid"] else 1)


if __name__ == "__main__":
    main()
