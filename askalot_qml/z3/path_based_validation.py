"""
PathBasedValidator - Path-Based Validation for QML Questionnaires

Implements accumulated reachability analysis from the thesis:
    A_i := B ∧ ∧{j∈Pred(i)}(P_j ⇒ Q_j)

Where:
- B: Base constraints (domain constraints for all outcome variables)
- Pred(i): Set of predecessor items in the topological order
- P_j, Q_j: Precondition and postcondition for predecessor item I_j

An item is accumulated-reachable if SAT(A_i ∧ P_i).
If UNSAT(A_i ∧ P_i) for a CONDITIONAL item, it is dead code.

This is the third and most thorough level of the validation hierarchy:
1. Per-item validation - checks each item independently
2. Global validation - checks if any valid completion exists
3. Path-based validation - detects dead code from accumulated constraints

Reference: docs/thesis/chapters/comprehensive_validation.tex, Definition 2.5
"""

import logging
from dataclasses import dataclass, field
from typing import Dict, Any, List, Set, Optional, TYPE_CHECKING

from z3 import Solver, Implies, And, BoolVal, sat, unsat

from askalot_qml.z3.static_builder import StaticBuilder

if TYPE_CHECKING:
    from askalot_qml.core.qml_topology import QMLTopology


@dataclass
class ItemReachabilityResult:
    """Result of accumulated reachability check for a single item."""
    item_id: str
    per_item_status: str  # ALWAYS, CONDITIONAL, NEVER (from per-item check)
    accumulated_reachable: bool
    is_dead_code: bool  # True if CONDITIONAL per-item but not accumulated-reachable
    predecessors: List[str] = field(default_factory=list)
    message: str = ""


@dataclass
class PathValidationResult:
    """Result of path-based validation for entire questionnaire."""
    has_dead_code: bool
    dead_code_items: List[str] = field(default_factory=list)
    item_results: Dict[str, ItemReachabilityResult] = field(default_factory=dict)
    message: str = ""


class PathBasedValidator:
    """
    Path-based validation for detecting dead code in questionnaires.

    Detects items that are CONDITIONAL per-item (precondition can be satisfied
    in isolation) but become unreachable due to accumulated postconditions
    from predecessor items.

    Example from thesis:
        I_1: postcondition Q_1 = (S_1 > 50)
        I_2: precondition P_2 = (S_1 < 30)

        Per-item: P_2 is CONDITIONAL (SAT for S_1 < 30)
        Accumulated: A_2 ∧ P_2 = B ∧ (S_1 > 50) ∧ (S_1 < 30) is UNSAT
        Result: I_2 is dead code

    Theorem (Global Necessary): If UNSAT(F), then all paths are invalid.
    Theorem (Global Not Sufficient): SAT(F) doesn't guarantee all items reachable.
    """

    def __init__(self, builder: StaticBuilder, topology: "QMLTopology"):
        """
        Initialize path-based validator.

        Args:
            builder: StaticBuilder with compiled constraints and item details
            topology: QMLTopology with dependency graph and topological order
        """
        self.logger = logging.getLogger(__name__)
        self.builder = builder
        self.topology = topology

    def validate(self) -> PathValidationResult:
        """
        Perform path-based validation on all items.

        For each item with CONDITIONAL precondition:
        1. Compute Pred(i) = predecessors in topological order
        2. Build A_i = B ∧ ∧{j∈Pred(i)}(P_j ⇒ Q_j)
        3. Check SAT(A_i ∧ P_i)
        4. If UNSAT, item is dead code

        Returns:
            PathValidationResult with dead code detection results
        """
        item_results = {}
        dead_code_items = []
        topological_order = self.topology.get_topological_order() or []

        # Build predecessor map from topological order
        predecessors_map = self._build_predecessors_map(topological_order)

        for item_id in topological_order:
            result = self._check_item_reachability(item_id, predecessors_map)
            item_results[item_id] = result

            if result.is_dead_code:
                dead_code_items.append(item_id)

        has_dead_code = len(dead_code_items) > 0
        message = (
            f"Found {len(dead_code_items)} dead code items."
            if has_dead_code
            else "No dead code detected. All conditional items are reachable."
        )

        return PathValidationResult(
            has_dead_code=has_dead_code,
            dead_code_items=dead_code_items,
            item_results=item_results,
            message=message
        )

    def _build_predecessors_map(self, topological_order: List[str]) -> Dict[str, List[str]]:
        """
        Build map of predecessors for each item based on dependency graph.

        Pred(i) includes only items that are actual dependencies (direct or transitive),
        not all items that come before in topological order.

        Args:
            topological_order: Items in topological order

        Returns:
            Dict mapping item_id to list of predecessor item_ids
        """
        predecessors = {}

        # Get transitive dependencies for each item
        for item_id in topological_order:
            deps = self._get_transitive_dependencies(item_id)
            # Filter to only include items that come before in topological order
            item_idx = topological_order.index(item_id)
            predecessors[item_id] = [
                dep for dep in topological_order[:item_idx]
                if dep in deps
            ]

        return predecessors

    def _get_transitive_dependencies(self, item_id: str) -> Set[str]:
        """
        Get all transitive dependencies for an item.

        Args:
            item_id: The item to get dependencies for

        Returns:
            Set of all items this item depends on (directly or transitively)
        """
        visited = set()
        to_visit = list(self.topology.dependencies.get(item_id, set()))

        while to_visit:
            dep = to_visit.pop()
            if dep not in visited:
                visited.add(dep)
                to_visit.extend(self.topology.dependencies.get(dep, set()))

        return visited

    def _check_item_reachability(
        self,
        item_id: str,
        predecessors_map: Dict[str, List[str]]
    ) -> ItemReachabilityResult:
        """
        Check accumulated reachability for a single item.

        Args:
            item_id: The item to check
            predecessors_map: Map of item_id to predecessor list

        Returns:
            ItemReachabilityResult for this item
        """
        details = self.builder.item_details.get(item_id)
        if not details:
            return ItemReachabilityResult(
                item_id=item_id,
                per_item_status="UNKNOWN",
                accumulated_reachable=True,
                is_dead_code=False,
                message="Item not found in builder details"
            )

        predecessors = predecessors_map.get(item_id, [])

        # First, get per-item precondition status
        P_i = self.builder.compile_conditions(item_id, details["preconditions"])
        # Use domain-only base constraint B as defined in thesis
        base = self.builder.get_domain_base()

        # Check per-item reachability: SAT(B ∧ P_i)?
        s_per_item = Solver()
        s_per_item.add(base, P_i)
        per_item_reachable = s_per_item.check() == sat

        # Determine per-item status
        if not per_item_reachable:
            per_item_status = "NEVER"
        else:
            # Check if always reachable: UNSAT(B ∧ ¬P_i)?
            from z3 import Not
            s_always = Solver()
            s_always.add(base, Not(P_i))
            always_reachable = s_always.check() == unsat
            per_item_status = "ALWAYS" if always_reachable else "CONDITIONAL"

        # If per-item is NEVER, no need to check accumulated (already unreachable)
        if per_item_status == "NEVER":
            return ItemReachabilityResult(
                item_id=item_id,
                per_item_status=per_item_status,
                accumulated_reachable=False,
                is_dead_code=False,  # NEVER is a per-item issue, not dead code
                predecessors=predecessors,
                message="Item is NEVER reachable (per-item check)"
            )

        # If per-item is ALWAYS, check accumulated reachability for completeness
        # but it cannot be dead code (ALWAYS items are always reachable)
        if per_item_status == "ALWAYS" and not predecessors:
            return ItemReachabilityResult(
                item_id=item_id,
                per_item_status=per_item_status,
                accumulated_reachable=True,
                is_dead_code=False,
                predecessors=predecessors,
                message="Item is ALWAYS reachable with no dependencies"
            )

        # Build accumulated formula: A_i = B ∧ ∧{j∈Pred(i)}(P_j ⇒ Q_j)
        # where B is domain-only base constraint
        solver = Solver()
        solver.add(base)  # base is already domain-only from above

        # Add implications from all predecessors
        for pred_id in predecessors:
            pred_details = self.builder.item_details.get(pred_id)
            if pred_details:
                P_j = self.builder.compile_conditions(pred_id, pred_details["preconditions"])
                Q_j = self.builder.compile_conditions(pred_id, pred_details["postconditions"])
                solver.add(Implies(P_j, Q_j))

        # Check SAT(A_i ∧ P_i)
        solver.add(P_i)
        accumulated_reachable = solver.check() == sat

        # Dead code: CONDITIONAL per-item but not accumulated-reachable
        is_dead_code = (per_item_status == "CONDITIONAL" and not accumulated_reachable)

        if is_dead_code:
            message = (
                f"Dead code: Precondition is CONDITIONAL but becomes "
                f"unreachable due to accumulated postconditions from: "
                f"{', '.join(predecessors)}"
            )
        elif not accumulated_reachable and per_item_status == "ALWAYS":
            message = (
                f"Warning: ALWAYS reachable per-item but accumulated constraints "
                f"make it unreachable. This may indicate conflicting postconditions."
            )
        else:
            message = "Item is reachable under accumulated constraints"

        return ItemReachabilityResult(
            item_id=item_id,
            per_item_status=per_item_status,
            accumulated_reachable=accumulated_reachable,
            is_dead_code=is_dead_code,
            predecessors=predecessors,
            message=message
        )

    def get_dead_code_items(self) -> List[str]:
        """
        Get list of dead code items.

        Convenience method that returns only the dead code item IDs.

        Returns:
            List of item IDs that are dead code
        """
        result = self.validate()
        return result.dead_code_items

    def debug_dump(self) -> str:
        """Generate debug output."""
        result = self.validate()

        lines = []
        lines.append("=" * 60)
        lines.append("PATH-BASED VALIDATION (Accumulated Reachability)")
        lines.append("=" * 60)
        lines.append(f"\nStatus: {'DEAD CODE DETECTED' if result.has_dead_code else 'ALL REACHABLE'}")
        lines.append(f"Message: {result.message}")

        if result.dead_code_items:
            lines.append(f"\nDead Code Items:")
            for item_id in result.dead_code_items:
                item_result = result.item_results.get(item_id)
                if item_result:
                    lines.append(f"  - {item_id}: {item_result.message}")

        lines.append(f"\nItem Reachability Summary:")
        for item_id, item_result in result.item_results.items():
            status = "DEAD" if item_result.is_dead_code else "OK"
            acc = "✓" if item_result.accumulated_reachable else "✗"
            preds = f" (deps: {', '.join(item_result.predecessors)})" if item_result.predecessors else ""
            lines.append(
                f"  {item_id}: per-item={item_result.per_item_status}, "
                f"accumulated={acc}, status={status}{preds}"
            )

        return "\n".join(lines)
