"""
GlobalFormula - Global Satisfiability Check for QML Questionnaires

Implements the global satisfiability formula from the thesis:
    F := B ∧ ∧(P_i ⇒ Q_i)

Where:
- B: Base constraints (domain constraints for all outcome variables)
- P_i: Precondition for item I_i
- Q_i: Postcondition for item I_i

SAT(F) indicates that at least one valid questionnaire completion exists.
UNSAT(F) indicates accumulated postconditions conflict - no valid completion possible.

Reference: docs/thesis/chapters/comprehensive_validation.tex, Definition 2.1
"""

import logging
from dataclasses import dataclass
from typing import Dict, Any, List, Optional

from z3 import Solver, Implies, And, BoolVal, sat, unsat, unknown

from askalot_qml.z3.static_builder import StaticBuilder


@dataclass
class GlobalFormulaResult:
    """Result of global satisfiability check."""
    satisfiable: bool
    status: str  # "SAT", "UNSAT", "UNKNOWN"
    witness: Optional[Dict[str, Any]] = None  # Example valid assignment if SAT
    message: str = ""


class GlobalFormula:
    """
    Global satisfiability check for questionnaire validation.

    Verifies that at least one valid questionnaire completion exists by checking:
        SAT(F) where F := B ∧ ∧(P_i ⇒ Q_i)

    This is the second level of the validation hierarchy:
    1. Per-item validation (ItemClassifier) - checks each item independently
    2. Global validation (GlobalFormula) - checks if any valid completion exists
    3. Path-based validation (PathBasedValidator) - checks for dead code

    Theorem (Soundness): If all W_i are UNSAT (per-item), then SAT(F) is guaranteed.
    Theorem (Accumulated Conflicts): UNSAT(F) can occur even when no item is INFEASIBLE.
    """

    def __init__(self, builder: StaticBuilder):
        """
        Initialize global formula checker.

        Args:
            builder: StaticBuilder with compiled constraints and item details
        """
        self.logger = logging.getLogger(__name__)
        self.builder = builder

    def check(self) -> GlobalFormulaResult:
        """
        Check global satisfiability: SAT(F) where F := B ∧ ∧(P_i ⇒ Q_i).

        Returns:
            GlobalFormulaResult with satisfiability status and optional witness
        """
        solver = Solver()

        # Add base constraints B (domain-only constraints as per thesis)
        # B := ∧_i D_i(S_i) where D_i are domain constraints (min/max, enumeration)
        base = self.builder.get_domain_base()
        solver.add(base)

        # Build ∧(P_i ⇒ Q_i) for all items
        implications = []
        for item_id in self.builder.item_order:
            details = self.builder.item_details.get(item_id)
            if not details:
                continue

            # Compile P_i and Q_i
            P_i = self.builder.compile_conditions(item_id, details["preconditions"])
            Q_i = self.builder.compile_conditions(item_id, details["postconditions"])

            # Add implication P_i ⇒ Q_i
            implication = Implies(P_i, Q_i)
            implications.append(implication)
            solver.add(implication)

        self.logger.debug(f"Global formula built with {len(implications)} implications")

        # Check satisfiability
        result = solver.check()

        if result == sat:
            # Extract witness (example valid completion)
            model = solver.model()
            witness = self._extract_witness(model)
            return GlobalFormulaResult(
                satisfiable=True,
                status="SAT",
                witness=witness,
                message="At least one valid questionnaire completion exists."
            )
        elif result == unsat:
            return GlobalFormulaResult(
                satisfiable=False,
                status="UNSAT",
                message="No valid questionnaire completion exists. "
                        "Accumulated postconditions conflict."
            )
        else:
            return GlobalFormulaResult(
                satisfiable=False,
                status="UNKNOWN",
                message="Z3 solver returned unknown. "
                        "The formula may be too complex or require different tactics."
            )

    def _extract_witness(self, model) -> Dict[str, Any]:
        """
        Extract a witness (example valid assignment) from Z3 model.

        Args:
            model: Z3 model from satisfiable check

        Returns:
            Dictionary mapping variable names to values
        """
        witness = {}

        # Extract item outcome values
        for item_id, z3_var in self.builder.item_vars.items():
            value = model.eval(z3_var, model_completion=True)
            try:
                witness[f"{item_id}.outcome"] = value.as_long()
            except (AttributeError, ValueError):
                witness[f"{item_id}.outcome"] = str(value)

        # Extract SSA variable values
        for var_name, z3_var in self.builder.z3_vars.items():
            value = model.eval(z3_var, model_completion=True)
            try:
                witness[var_name] = value.as_long()
            except (AttributeError, ValueError):
                witness[var_name] = str(value)

        return witness

    def get_conflicting_items(self) -> List[str]:
        """
        If UNSAT, attempt to find which items' postconditions conflict.

        Uses incremental solving to identify the minimal set of implications
        that cause unsatisfiability.

        Returns:
            List of item IDs whose postconditions contribute to the conflict
        """
        # First verify that the formula is indeed UNSAT
        result = self.check()
        if result.satisfiable:
            return []

        conflicting = []
        solver = Solver()
        solver.add(self.builder.get_domain_base())

        # Add implications one by one to find which causes UNSAT
        for item_id in self.builder.item_order:
            details = self.builder.item_details.get(item_id)
            if not details:
                continue

            P_i = self.builder.compile_conditions(item_id, details["preconditions"])
            Q_i = self.builder.compile_conditions(item_id, details["postconditions"])

            solver.push()
            solver.add(Implies(P_i, Q_i))

            if solver.check() == unsat:
                conflicting.append(item_id)
                solver.pop()
            else:
                solver.pop()
                solver.add(Implies(P_i, Q_i))

        return conflicting

    def debug_dump(self) -> str:
        """Generate debug output."""
        result = self.check()

        lines = []
        lines.append("=" * 60)
        lines.append("GLOBAL FORMULA CHECK (F := B ∧ ∧(P_i ⇒ Q_i))")
        lines.append("=" * 60)
        lines.append(f"\nStatus: {result.status}")
        lines.append(f"Message: {result.message}")

        if result.witness:
            lines.append(f"\nWitness (example valid completion):")
            for var, value in sorted(result.witness.items()):
                lines.append(f"  {var} = {value}")

        if not result.satisfiable:
            conflicting = self.get_conflicting_items()
            if conflicting:
                lines.append(f"\nConflicting items: {', '.join(conflicting)}")

        return "\n".join(lines)
