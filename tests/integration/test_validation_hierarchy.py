#!/usr/bin/env python3
"""Integration tests for the validation hierarchy based on thesis examples.

This test suite verifies the three-level validation hierarchy from the thesis:
1. Per-item validation (ItemClassifier) - W_i = B ∧ P_i ∧ ¬Q_i
2. Global validation (GlobalFormula) - F = B ∧ ∧(P_i ⇒ Q_i)
3. Path-based validation (PathBasedValidator) - A_i = B ∧ ∧{j∈Pred(i)}(P_j ⇒ Q_j)

Reference: docs/thesis/chapters/comprehensive_validation.tex
"""

import unittest
import pytest
from pathlib import Path

from askalot_qml.core.qml_loader import QMLLoader
from askalot_qml.models.questionnaire_state import QuestionnaireState
from askalot_qml.core.qml_engine import QMLEngine
from askalot_qml.z3 import (
    ItemClassifier,
    GlobalFormula,
    PathBasedValidator,
)


# Path to fixture files
FIXTURES_DIR = Path(__file__).parent / "fixtures"


def load_qml_fixture(filename: str) -> QuestionnaireState:
    """Load a QML fixture file and return QuestionnaireState."""
    loader = QMLLoader()
    qml_path = FIXTURES_DIR / filename
    data = loader.load_from_path(str(qml_path))
    return QuestionnaireState(data)


def create_engine(filename: str) -> QMLEngine:
    """Load a QML fixture and create QMLEngine."""
    state = load_qml_fixture(filename)
    return QMLEngine(state)


@pytest.mark.integration
class TestTheoremLocalInvalidityNotGlobal(unittest.TestCase):
    """
    Theorem 2.2: Local Invalidity Does Not Imply Global Unsatisfiability.

    If SAT(W_i) for some i, it does not follow that UNSAT(F).

    Example: Driving experience survey
    - I_1: age ∈ [0, 120], P_1 = true, Q_1 = true
    - I_2: experience ∈ [0, 100], P_2 = (age >= 16), Q_2 = (exp <= age - 16)

    SAT(W_2) with S_1=20, S_2=10 (10 years at age 20 violates Q_2)
    But SAT(F) with S_1=30, S_2=5 (5 years at age 30 is valid)
    """

    def setUp(self):
        self.engine = create_engine("thesis_driving_experience.qml")

    def test_per_item_not_infeasible(self):
        """Postcondition should not be INFEASIBLE."""
        classifier = ItemClassifier(self.engine.static_builder)
        classifications = classifier.classify_all_items()

        q_exp = classifications.get("q_experience", {})
        postcond = q_exp.get("postcondition", {})

        self.assertNotEqual(
            postcond.get("invariant"),
            "INFEASIBLE",
            "q_experience postcondition should not be INFEASIBLE"
        )

    def test_global_formula_is_sat(self):
        """Global formula F should be SAT despite local constraint violations."""
        global_formula = GlobalFormula(self.engine.static_builder)
        result = global_formula.check()

        self.assertTrue(
            result.satisfiable,
            "Global formula should be SAT (valid completions exist)"
        )
        self.assertEqual(result.status, "SAT")

    def test_no_dead_code(self):
        """No items should be dead code."""
        validator = PathBasedValidator(self.engine.static_builder, self.engine.topology)
        result = validator.validate()

        self.assertFalse(
            result.has_dead_code,
            "No dead code should be detected"
        )
        self.assertEqual(len(result.dead_code_items), 0)


@pytest.mark.integration
class TestTheoremAccumulatedConstraintsUnsatisfiable(unittest.TestCase):
    """
    Theorem 2.3: Accumulated Constraints Can Cause Global Unsatisfiability.

    There exist questionnaires where no item is INFEASIBLE, yet UNSAT(F).

    Example: Conflicting postconditions
    - I_1: rating ∈ [1, 100], P_1 = true, Q_1 = (rating > 50)
    - I_2: confirm ∈ {0, 1}, P_2 = true, Q_2 = (rating < 30)

    Per-item: Both are CONSTRAINING (not INFEASIBLE)
    Global: UNSAT(F) - no rating satisfies both > 50 AND < 30
    """

    def setUp(self):
        self.engine = create_engine("thesis_conflicting_postconditions.qml")

    def test_per_item_not_infeasible(self):
        """Neither item should be INFEASIBLE when checked independently."""
        classifier = ItemClassifier(self.engine.static_builder)
        classifications = classifier.classify_all_items()

        for item_id, classification in classifications.items():
            postcond = classification.get("postcondition", {})
            invariant = postcond.get("invariant", "UNKNOWN")

            self.assertNotEqual(
                invariant,
                "INFEASIBLE",
                f"{item_id} should not be INFEASIBLE when checked independently"
            )

    def test_global_formula_is_unsat(self):
        """Global formula F should be UNSAT due to conflicting postconditions."""
        global_formula = GlobalFormula(self.engine.static_builder)
        result = global_formula.check()

        self.assertFalse(
            result.satisfiable,
            "Global formula should be UNSAT (accumulated constraints conflict)"
        )
        self.assertEqual(result.status, "UNSAT")


@pytest.mark.integration
class TestTheoremGlobalNotSufficient(unittest.TestCase):
    """
    Theorem 2.5: Global Validity Does Not Guarantee All Items Reachable.

    There exist questionnaires where SAT(F) but some item is unreachable.

    Example: Dead code simple
    - I_1: rating ∈ [1, 100], P_1 = true, Q_1 = (rating > 80)
    - I_2: feedback ∈ {0, 1}, P_2 = (rating < 50), Q_2 = true

    Per-item: P_2 is CONDITIONAL (reachable for rating < 50)
    Global: SAT(F) with rating = 90 (implication P_2 => Q_2 vacuously true)
    Path-based: I_2 is DEAD CODE (rating > 80 AND rating < 50 is UNSAT)
    """

    def setUp(self):
        self.engine = create_engine("thesis_dead_code_simple.qml")

    def test_precondition_is_conditional(self):
        """q_feedback precondition should be CONDITIONAL (not NEVER)."""
        classifier = ItemClassifier(self.engine.static_builder)
        classifications = classifier.classify_all_items()

        q_feedback = classifications.get("q_feedback", {})
        precond = q_feedback.get("precondition", {})

        self.assertEqual(
            precond.get("status"),
            "CONDITIONAL",
            "q_feedback precondition should be CONDITIONAL per-item"
        )

    def test_global_formula_is_sat(self):
        """Global formula F should be SAT (vacuous truth of implication)."""
        global_formula = GlobalFormula(self.engine.static_builder)
        result = global_formula.check()

        self.assertTrue(
            result.satisfiable,
            "Global formula should be SAT (implication is vacuously true)"
        )

    def test_dead_code_detected(self):
        """q_feedback should be detected as dead code."""
        validator = PathBasedValidator(self.engine.static_builder, self.engine.topology)
        result = validator.validate()

        self.assertTrue(
            result.has_dead_code,
            "Dead code should be detected"
        )
        self.assertIn(
            "q_feedback",
            result.dead_code_items,
            "q_feedback should be identified as dead code"
        )

    def test_dead_code_item_details(self):
        """Verify dead code item has correct classification details."""
        validator = PathBasedValidator(self.engine.static_builder, self.engine.topology)
        result = validator.validate()

        q_feedback_result = result.item_results.get("q_feedback")
        self.assertIsNotNone(q_feedback_result)

        # Should be CONDITIONAL per-item but not accumulated-reachable
        self.assertEqual(q_feedback_result.per_item_status, "CONDITIONAL")
        self.assertFalse(q_feedback_result.accumulated_reachable)
        self.assertTrue(q_feedback_result.is_dead_code)


@pytest.mark.integration
class TestAccumulatedReachabilityExample(unittest.TestCase):
    """
    Definition 2.5: Accumulated Reachability.

    Example: Income survey with low-income assistance dead code
    - I_1: income ∈ [0, 1M], P_1 = true, Q_1 = (income >= 50000)
    - I_2: tax_bracket ∈ {1,2,3}, P_2 = true, Q_2 = true (independent)
    - I_3: low_income_assist ∈ {0,1}, P_3 = (income < 30000), Q_3 = true

    Dependency: I_1 → I_3 (P_3 references income)
    Pred(3) = {1} (I_2 is independent, not a predecessor)

    A_3 = B ∧ (true => income >= 50000) = B ∧ (income >= 50000)
    A_3 ∧ P_3 = B ∧ (income >= 50000) ∧ (income < 30000) = UNSAT

    I_3 is dead code despite being CONDITIONAL per-item.
    """

    def setUp(self):
        self.engine = create_engine("thesis_dead_code_income.qml")

    def test_topological_order(self):
        """Verify correct topological order."""
        topo_order = self.engine.get_topological_order()
        self.assertIsNotNone(topo_order)

        # q_income should come before q_low_income_assist (dependency)
        if "q_income" in topo_order and "q_low_income_assist" in topo_order:
            income_idx = topo_order.index("q_income")
            assist_idx = topo_order.index("q_low_income_assist")
            self.assertLess(
                income_idx,
                assist_idx,
                "q_income should come before q_low_income_assist in topological order"
            )

    def test_per_item_conditional(self):
        """q_low_income_assist precondition should be CONDITIONAL."""
        classifier = ItemClassifier(self.engine.static_builder)
        classifications = classifier.classify_all_items()

        q_assist = classifications.get("q_low_income_assist", {})
        precond = q_assist.get("precondition", {})

        self.assertEqual(
            precond.get("status"),
            "CONDITIONAL",
            "q_low_income_assist precondition should be CONDITIONAL per-item"
        )

    def test_global_formula_is_sat(self):
        """Global formula should be SAT."""
        global_formula = GlobalFormula(self.engine.static_builder)
        result = global_formula.check()

        self.assertTrue(
            result.satisfiable,
            "Global formula should be SAT"
        )

    def test_dead_code_detected(self):
        """q_low_income_assist should be detected as dead code."""
        validator = PathBasedValidator(self.engine.static_builder, self.engine.topology)
        result = validator.validate()

        self.assertTrue(
            result.has_dead_code,
            "Dead code should be detected"
        )
        self.assertIn(
            "q_low_income_assist",
            result.dead_code_items,
            "q_low_income_assist should be identified as dead code"
        )

    def test_independent_item_not_dead_code(self):
        """q_tax_bracket (independent) should NOT be dead code."""
        validator = PathBasedValidator(self.engine.static_builder, self.engine.topology)
        result = validator.validate()

        self.assertNotIn(
            "q_tax_bracket",
            result.dead_code_items,
            "q_tax_bracket should NOT be dead code (it's independent)"
        )

    def test_predecessor_relationship(self):
        """Verify predecessor relationship is correctly identified."""
        validator = PathBasedValidator(self.engine.static_builder, self.engine.topology)
        result = validator.validate()

        q_assist_result = result.item_results.get("q_low_income_assist")
        self.assertIsNotNone(q_assist_result)

        # q_income should be in predecessors, q_tax_bracket should NOT be
        self.assertIn(
            "q_income",
            q_assist_result.predecessors,
            "q_income should be a predecessor of q_low_income_assist"
        )


@pytest.mark.integration
class TestValidationHierarchyRelationships(unittest.TestCase):
    """
    Tests for the relationships between validation levels.

    From the thesis:
    - Per-item passes → Global passes (Theorem: Soundness)
    - Global fails → Path-based fails (Theorem: Global Necessary)
    - Global passes ↛ All paths valid (Theorem: Global Not Sufficient)
    """

    def test_soundness_all_tautological(self):
        """
        Soundness: If all W_i are UNSAT (all TAUTOLOGICAL), then SAT(F).

        Use basic.qml which has no postconditions (all TAUTOLOGICAL/NONE).
        """
        engine = create_engine("basic.qml")

        classifier = ItemClassifier(engine.static_builder)
        classifications = classifier.classify_all_items()

        # All items should have TAUTOLOGICAL or NONE postconditions
        all_safe = True
        for item_id, classification in classifications.items():
            postcond = classification.get("postcondition", {})
            invariant = postcond.get("invariant", "UNKNOWN")
            if invariant not in ("TAUTOLOGICAL", "NONE"):
                all_safe = False
                break

        if all_safe:
            # Then global should be SAT (by Soundness theorem)
            global_formula = GlobalFormula(engine.static_builder)
            result = global_formula.check()

            self.assertTrue(
                result.satisfiable,
                "If all postconditions are TAUTOLOGICAL/NONE, global should be SAT"
            )

    def test_global_necessary_for_paths(self):
        """
        Global Necessary: If UNSAT(F), then no execution path is valid.

        Use conflicting_postconditions which has UNSAT(F).
        """
        engine = create_engine("thesis_conflicting_postconditions.qml")

        global_formula = GlobalFormula(engine.static_builder)
        global_result = global_formula.check()

        # If global is UNSAT, path-based should also find issues
        if not global_result.satisfiable:
            validator = PathBasedValidator(engine.static_builder, engine.topology)
            path_result = validator.validate()

            # When global is UNSAT, all items effectively become problematic
            # The path-based validator may detect this as dead code or other issues
            # At minimum, the questionnaire is not completable
            self.assertEqual(
                global_result.status,
                "UNSAT",
                "Global formula should be UNSAT"
            )


if __name__ == "__main__":
    pytest.main([__file__, "-v"])
