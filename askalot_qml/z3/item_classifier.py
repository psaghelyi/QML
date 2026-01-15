import logging
from typing import Dict, Any

from z3 import (
    BoolRef,
    Solver,
    Not,
    unsat,
)

from askalot_qml.z3.static_builder import StaticBuilder

# Import profiling - graceful fallback if not available
try:
    from askalot_common import profile_block, add_profiling_tags, remove_profiling_tags
except ImportError:
    from contextlib import contextmanager
    @contextmanager
    def profile_block(name, tags=None):
        yield
    def add_profiling_tags(tags):
        pass
    def remove_profiling_tags(keys):
        pass


class ItemClassifier:
    """
    Computes separate classifications for each item:
    - Precondition reachability: ALWAYS | CONDITIONAL | NEVER
    - Postcondition invariant (relative to P): TAUTOLOGICAL | CONSTRAINING | INFEASIBLE
    - Global Q flags: q_globally_true | q_globally_false
    """

    def __init__(self, builder: StaticBuilder):
        self.logger = logging.getLogger(__name__)
        self.builder = builder

    def classify_item(self, item_id: str) -> Dict[str, Any]:
        """Classify a single item using Z3 SMT solver."""
        with profile_block('z3_classify_item', {'item_id': item_id}):
            if item_id not in self.builder.item_details:
                return {
                    "precondition": {"status": "UNKNOWN"},
                    "postcondition": {
                        "invariant": "UNKNOWN",
                        "vacuous": False,
                        "global": {"q_globally_true": False, "q_globally_false": False},
                    },
                }

            details = self.builder.item_details[item_id]

            # Check if item has postconditions
            has_postconditions = bool(details["postconditions"])

            # Compile precondition and postcondition using the shared helper
            with profile_block('z3_compile_conditions', {'item_id': item_id}):
                P_form: BoolRef = self.builder.compile_conditions(item_id, details["preconditions"])  # type: ignore
                Q_form: BoolRef = self.builder.compile_conditions(item_id, details["postconditions"])  # type: ignore

            # Use domain-only base constraint B as defined in thesis
            # B := ∧_i D_i(S_i) where D_i are domain constraints (min/max, enumeration)
            base = self.builder.get_domain_base()

            # ------------------------------
            # Precondition reachability
            # ALWAYS  iff  UNSAT(base ∧ ¬P)
            # NEVER   iff  UNSAT(base ∧ P)
            # else CONDITIONAL
            # ------------------------------
            with profile_block('z3_precondition_check', {'item_id': item_id}):
                s_always = Solver()
                s_always.add(base, Not(P_form))
                precondition_always = s_always.check() == unsat

                s_never = Solver()
                s_never.add(base, P_form)
                precondition_never = s_never.check() == unsat

            if precondition_always:
                pre_status = "ALWAYS"
            elif precondition_never:
                pre_status = "NEVER"
            else:
                pre_status = "CONDITIONAL"

            # ------------------------------
            # Postcondition invariants (relative to P)
            # Only items with postconditions can have TAUTOLOGICAL/INFEASIBLE/CONSTRAINING classifications
            # TAUTOLOGICAL: UNSAT(base ∧ P ∧ ¬Q)  i.e., B ∧ P ⊨ Q
            # INFEASIBLE:   UNSAT(base ∧ P ∧ Q)
            # CONSTRAINING: otherwise (both SAT for P∧Q and P∧¬Q)
            # ------------------------------
            vacuous = pre_status == "NEVER"

            # Compute postcondition classification only for items with postconditions
            if not has_postconditions:
                # Items without postconditions should not have these classifications
                post_invariant = "NONE"
            elif not vacuous:
                # Item has postconditions and is reachable
                with profile_block('z3_postcondition_check', {'item_id': item_id}):
                    s_impl = Solver()
                    s_impl.add(base, P_form, Not(Q_form))
                    tautological_under_P = s_impl.check() == unsat

                    s_feas = Solver()
                    s_feas.add(base, P_form, Q_form)
                    infeasible_under_P = s_feas.check() == unsat

                if tautological_under_P:
                    post_invariant = "TAUTOLOGICAL"
                elif infeasible_under_P:
                    post_invariant = "INFEASIBLE"
                else:
                    post_invariant = "CONSTRAINING"
            else:
                # Vacuous w.r.t. P (NEVER reachable); keep label informative
                post_invariant = "TAUTOLOGICAL"

            # ------------------------------
            # Global Q flags (only meaningful for items with postconditions)
            # q_globally_false: UNSAT(base ∧ Q)
            # q_globally_true:  UNSAT(base ∧ ¬Q)
            # ------------------------------
            if has_postconditions:
                with profile_block('z3_global_flags_check', {'item_id': item_id}):
                    s_q_false = Solver()
                    s_q_false.add(base, Q_form)
                    q_globally_false = s_q_false.check() == unsat

                    s_q_true = Solver()
                    s_q_true.add(base, Not(Q_form))
                    q_globally_true = s_q_true.check() == unsat
            else:
                # Items without postconditions have no global Q flags
                q_globally_false = False
                q_globally_true = False

            return {
                "precondition": {"status": pre_status},
                "postcondition": {
                    "invariant": post_invariant,
                    "vacuous": vacuous,
                    "global": {
                        "q_globally_true": q_globally_true,
                        "q_globally_false": q_globally_false,
                    },
                },
            }

    def classify_all_items(self) -> Dict[str, Any]:
        """Classify all items using Z3 SMT solver."""
        with profile_block('z3_classify_all_items', {'item_count': len(self.builder.item_order)}):
            results: Dict[str, Any] = {}
            for item_id in self.builder.item_order:
                results[item_id] = self.classify_item(item_id)
            return results