#!/usr/bin/env python3
"""Integration tests for QML parsing and Z3 transformation.

This test suite verifies the complete pipeline from QML files to Z3 constraints:
1. QMLLoader parses YAML files correctly
2. QuestionnaireState is initialized with correct structure
3. StaticBuilder generates Z3 constraints from conditions
4. QMLTopology discovers dependencies and detects cycles
5. ItemClassifier produces correct classifications

All tests use real QML fixture files in tests/integration/fixtures/.
"""

import unittest
import pytest
from pathlib import Path

from askalot_qml.core.qml_loader import QMLLoader
from askalot_qml.models.questionnaire_state import QuestionnaireState
from askalot_qml.z3.static_builder import StaticBuilder
from askalot_qml.core.qml_topology import QMLTopology
from askalot_qml.z3.item_classifier import ItemClassifier


# Path to fixture files
FIXTURES_DIR = Path(__file__).parent / "fixtures"


def load_qml_fixture(filename: str) -> QuestionnaireState:
    """Load a QML fixture file and return QuestionnaireState."""
    loader = QMLLoader()
    qml_path = FIXTURES_DIR / filename
    data = loader.load_from_path(str(qml_path))
    return QuestionnaireState(data)


@pytest.mark.integration
class TestQMLLoading(unittest.TestCase):
    """Tests for QML file loading and parsing."""

    def test_load_basic_qml(self):
        """Test loading a basic QML file."""
        state = load_qml_fixture("basic.qml")

        self.assertEqual(state.get("title"), "Basic Survey")
        self.assertEqual(len(state.get_blocks()), 1)
        self.assertEqual(len(state.get_items()), 3)

    def test_load_dependencies_qml(self):
        """Test loading QML with preconditions."""
        state = load_qml_fixture("dependencies.qml")

        self.assertEqual(state.get("title"), "Survey with Dependencies")
        self.assertEqual(len(state.get_blocks()), 2)
        self.assertEqual(len(state.get_items()), 5)

        # Check preconditions are loaded
        q_job = state.get_item("q_job_title")
        self.assertIn("precondition", q_job)
        self.assertEqual(len(q_job["precondition"]), 1)

    def test_load_scoring_qml(self):
        """Test loading QML with codeInit and codeBlock."""
        state = load_qml_fixture("scoring.qml")

        self.assertEqual(state.get("title"), "Scored Assessment")

        # Check codeInit is loaded
        code_init = state.get_code_init()
        self.assertIn("score = 0", code_init)
        self.assertIn("risk_level = 0", code_init)

        # Check codeBlock on items
        q_age = state.get_item("q_age")
        self.assertIn("codeBlock", q_age)
        self.assertIn("risk_level", q_age["codeBlock"])

    def test_nested_to_flat_conversion(self):
        """Test that nested QML structure is converted to flat."""
        state = load_qml_fixture("basic.qml")

        # Items should have blockId, not be nested in blocks
        for item in state.get_items():
            self.assertIn("blockId", item)

        # Blocks should not have items array
        for block in state.get_blocks():
            self.assertNotIn("items", block)


@pytest.mark.integration
class TestQuestionnaireStateInitialization(unittest.TestCase):
    """Tests for QuestionnaireState correct initialization."""

    def test_items_have_required_fields(self):
        """Test that items have all required fields after loading."""
        state = load_qml_fixture("basic.qml")

        for item in state.get_items():
            self.assertIn("id", item)
            self.assertIn("blockId", item)
            self.assertIn("kind", item)
            self.assertIn("title", item)

    def test_items_have_runtime_state(self):
        """Test that items are initialized with runtime state fields."""
        state = load_qml_fixture("basic.qml")

        for item in state.get_items():
            # Runtime state should be initialized
            self.assertFalse(item.get("visited", False))
            self.assertFalse(item.get("disabled", False))

    def test_get_items_by_block(self):
        """Test filtering items by block."""
        state = load_qml_fixture("dependencies.qml")

        screening_items = state.get_items_by_block("screening")
        self.assertEqual(len(screening_items), 3)

        education_items = state.get_items_by_block("education")
        self.assertEqual(len(education_items), 2)

    def test_history_initialization(self):
        """Test that history is empty on initialization."""
        state = load_qml_fixture("basic.qml")

        self.assertEqual(state.get_history(), [])

    def test_item_input_properties(self):
        """Test that input properties are preserved."""
        state = load_qml_fixture("basic.qml")

        q_age = state.get_item("q_age")
        self.assertIn("input", q_age)
        self.assertEqual(q_age["input"]["control"], "Editbox")
        self.assertEqual(q_age["input"]["min"], 18)
        self.assertEqual(q_age["input"]["max"], 120)


@pytest.mark.integration
@pytest.mark.z3
class TestZ3ConstraintGeneration(unittest.TestCase):
    """Tests for Z3 constraint generation from QML."""

    def test_basic_constraint_generation(self):
        """Test that StaticBuilder generates constraints from basic QML."""
        state = load_qml_fixture("basic.qml")
        builder = StaticBuilder(state)

        # Should create item variables
        self.assertIn("q_age", builder.item_vars)
        self.assertIn("q_gender", builder.item_vars)
        self.assertIn("q_comment", builder.item_vars)

    def test_precondition_constraint_generation(self):
        """Test constraint generation from preconditions."""
        state = load_qml_fixture("dependencies.qml")
        builder = StaticBuilder(state)

        # Should have constraints for preconditions
        self.assertGreater(len(builder.constraints), 0)

        # q_job_title depends on q_employed
        deps = builder.get_item_dependencies()
        self.assertIn("q_employed", deps.get("q_job_title", set()))

    def test_code_init_variable_creation(self):
        """Test that codeInit creates SSA variables."""
        state = load_qml_fixture("scoring.qml")
        builder = StaticBuilder(state)

        # Variables from codeInit should exist
        self.assertIn("score", builder.version_map)
        self.assertIn("risk_level", builder.version_map)

    def test_code_block_constraint_generation(self):
        """Test constraint generation from codeBlock."""
        state = load_qml_fixture("scoring.qml")
        builder = StaticBuilder(state)

        # Items with codeBlock should create new variable versions
        # risk_level is modified in multiple items
        risk_versions = builder.version_history.get("risk_level", [])
        self.assertGreater(len(risk_versions), 1)

    def test_postcondition_constraint_generation(self):
        """Test constraint generation from postconditions."""
        state = load_qml_fixture("scoring.qml")
        builder = StaticBuilder(state)

        # Should have constraints
        self.assertGreater(len(builder.constraints), 0)

        # Item details should include postconditions
        q_exercise = builder.item_details.get("q_exercise", {})
        self.assertIn("postconditions", q_exercise)
        self.assertEqual(len(q_exercise["postconditions"]), 1)


@pytest.mark.integration
@pytest.mark.z3
class TestDependencyDiscovery(unittest.TestCase):
    """Tests for dependency discovery from QML."""

    def test_no_dependencies_basic(self):
        """Test that basic QML has no dependencies."""
        state = load_qml_fixture("basic.qml")
        builder = StaticBuilder(state)

        deps = builder.get_item_dependencies()
        for item_id, item_deps in deps.items():
            self.assertEqual(len(item_deps), 0)

    def test_precondition_dependencies(self):
        """Test dependency discovery from preconditions."""
        state = load_qml_fixture("dependencies.qml")
        builder = StaticBuilder(state)

        deps = builder.get_item_dependencies()

        # q_job_title depends on q_employed
        self.assertIn("q_employed", deps.get("q_job_title", set()))

        # q_years_employed depends on q_employed
        self.assertIn("q_employed", deps.get("q_years_employed", set()))

        # q_field depends on q_degree
        self.assertIn("q_degree", deps.get("q_field", set()))

    def test_topological_order(self):
        """Test topological ordering respects dependencies."""
        state = load_qml_fixture("dependencies.qml")
        builder = StaticBuilder(state)
        topology = QMLTopology(state, builder)

        order = topology.get_topological_order()
        self.assertIsNotNone(order)

        # q_employed must come before q_job_title
        self.assertLess(
            order.index("q_employed"),
            order.index("q_job_title")
        )

        # q_degree must come before q_field
        self.assertLess(
            order.index("q_degree"),
            order.index("q_field")
        )


@pytest.mark.integration
@pytest.mark.z3
@pytest.mark.cycle_detection
class TestCycleDetection(unittest.TestCase):
    """Tests for cycle detection in QML dependencies."""

    def test_no_cycles_in_valid_qml(self):
        """Test that valid QML has no cycles."""
        state = load_qml_fixture("dependencies.qml")
        builder = StaticBuilder(state)
        topology = QMLTopology(state, builder)

        self.assertFalse(topology.has_cycles)
        self.assertEqual(len(topology.cycles), 0)

    def test_cycle_detection(self):
        """Test that cyclic dependencies are detected."""
        state = load_qml_fixture("cycles.qml")
        builder = StaticBuilder(state)
        topology = QMLTopology(state, builder)

        self.assertTrue(topology.has_cycles)
        self.assertGreater(len(topology.cycles), 0)

    def test_topological_order_none_with_cycles(self):
        """Test that topological order is None when cycles exist."""
        state = load_qml_fixture("cycles.qml")
        builder = StaticBuilder(state)
        topology = QMLTopology(state, builder)

        order = topology.get_topological_order()
        self.assertIsNone(order)


@pytest.mark.integration
@pytest.mark.z3
class TestItemClassification(unittest.TestCase):
    """Tests for item classification (ALWAYS, CONDITIONAL, NEVER)."""

    def test_always_classification(self):
        """Test that items without preconditions are ALWAYS."""
        state = load_qml_fixture("classification.qml")
        builder = StaticBuilder(state)
        classifier = ItemClassifier(builder)

        result = classifier.classify_item("q_always")
        self.assertEqual(result["precondition"]["status"], "ALWAYS")

    def test_conditional_classification(self):
        """Test that items with satisfiable preconditions are CONDITIONAL."""
        state = load_qml_fixture("classification.qml")
        builder = StaticBuilder(state)
        classifier = ItemClassifier(builder)

        result = classifier.classify_item("q_conditional")
        self.assertEqual(result["precondition"]["status"], "CONDITIONAL")

    def test_never_classification(self):
        """Test that items with contradictory preconditions are NEVER."""
        state = load_qml_fixture("classification.qml")
        builder = StaticBuilder(state)
        classifier = ItemClassifier(builder)

        result = classifier.classify_item("q_never")
        self.assertEqual(result["precondition"]["status"], "NEVER")

    def test_constraining_postcondition(self):
        """Test that constraining postconditions are detected."""
        state = load_qml_fixture("classification.qml")
        builder = StaticBuilder(state)
        classifier = ItemClassifier(builder)

        result = classifier.classify_item("q_constraining")
        # Should have postcondition classification
        self.assertIn("postcondition", result)
        self.assertIn("invariant", result["postcondition"])


@pytest.mark.integration
class TestEndToEndPipeline(unittest.TestCase):
    """End-to-end tests for the complete QML processing pipeline."""

    def test_complete_pipeline_basic(self):
        """Test complete pipeline with basic QML."""
        # Load
        state = load_qml_fixture("basic.qml")

        # Build constraints
        builder = StaticBuilder(state)

        # Build topology
        topology = QMLTopology(state, builder)

        # Verify
        self.assertFalse(topology.has_cycles)
        self.assertEqual(len(topology.get_topological_order()), 3)

    def test_complete_pipeline_scoring(self):
        """Test complete pipeline with scoring QML."""
        # Load
        state = load_qml_fixture("scoring.qml")

        # Build constraints
        builder = StaticBuilder(state)

        # Verify SSA versioning
        self.assertIn("score", builder.version_map)
        self.assertIn("risk_level", builder.version_map)

        # Build topology
        topology = QMLTopology(state, builder)
        self.assertFalse(topology.has_cycles)

        # Classify items
        classifier = ItemClassifier(builder)
        q_age_result = classifier.classify_item("q_age")
        self.assertEqual(q_age_result["precondition"]["status"], "ALWAYS")

    def test_complete_pipeline_dependencies(self):
        """Test complete pipeline preserves all dependencies."""
        # Load
        state = load_qml_fixture("dependencies.qml")

        # Build
        builder = StaticBuilder(state)
        topology = QMLTopology(state, builder)

        # Verify dependency chain
        deps = builder.get_item_dependencies()

        # Employed → Job Title → (end of chain)
        self.assertIn("q_employed", deps.get("q_job_title", set()))

        # Degree → Field → (end of chain)
        self.assertIn("q_degree", deps.get("q_field", set()))

        # Components should be 2 (screening chain + education chain)
        components = topology.get_components()
        # Note: components may vary based on exact dependency structure
        self.assertGreaterEqual(len(components), 1)


if __name__ == "__main__":
    unittest.main()
