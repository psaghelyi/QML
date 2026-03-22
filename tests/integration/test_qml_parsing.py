#!/usr/bin/env python3
"""Integration tests for QML parsing, block precondition propagation, and Z3 transformation.

Tests the complete pipeline from QML files to Z3 constraints:
- QMLLoader parses YAML files and flattens nested block/item structure
- Block-level preconditions propagate to enclosed items during flattening
- Items with existing preconditions receive block preconditions prepended
- Scalar predicates (bool, int, float) at block level are normalized to strings
- QMLState is initialized with correct flat structure and blockId references
- StaticBuilder generates Z3 constraints including inherited block preconditions
- QMLTopology discovers dependencies from block-inherited preconditions
- ItemClassifier produces correct classifications for block-conditioned items

These integration tests use real QML fixture files and inline QML strings to verify
that block precondition inheritance works correctly through the entire pipeline, from
YAML parsing through Z3 constraint generation to item classification.
"""

import unittest
import pytest
from pathlib import Path

from askalot_qml.core.qml_loader import QMLLoader
from askalot_qml.models.qml_state import QMLState
from askalot_qml.z3.static_builder import StaticBuilder
from askalot_qml.core.qml_topology import QMLTopology
from askalot_qml.z3.item_classifier import ItemClassifier


# Path to fixture files
FIXTURES_DIR = Path(__file__).parent.parent / "fixtures"


def load_qml_fixture(filename: str) -> QMLState:
    """Load a QML fixture file and return QMLState."""
    loader = QMLLoader(schema_path=None)
    qml_path = FIXTURES_DIR / filename
    data = loader.load_from_path(str(qml_path))
    return QMLState(data)


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

    def test_scalar_predicate_normalization(self):
        """Test that YAML scalar predicates are converted to strings.

        YAML parses certain values as non-string types, but predicates must be
        strings for ast.parse(). The loader should normalize scalars (bool, int, float).
        """
        loader = QMLLoader(schema_path=None)

        # QML with various scalar predicates (YAML will parse as non-string)
        qml_content = """
questionnaire:
  title: Scalar Predicate Test
  blocks:
    - id: main
      items:
        - id: q1
          kind: Question
          title: Boolean true
          precondition:
            - predicate: true
        - id: q2
          kind: Question
          title: Boolean false
          postcondition:
            - predicate: false
              hint: This always fails
        - id: q3
          kind: Question
          title: Integer predicate
          precondition:
            - predicate: 1
        - id: q4
          kind: Question
          title: Float predicate
          precondition:
            - predicate: 1.5
        - id: q5
          kind: Question
          title: String predicate
          precondition:
            - predicate: "q1.outcome > 0"
"""
        data = loader.load_from_string(qml_content)
        state = QMLState(data)

        # Check that boolean predicates were converted to strings
        q1 = state.get_item("q1")
        self.assertEqual(q1["precondition"][0]["predicate"], "True")
        self.assertIsInstance(q1["precondition"][0]["predicate"], str)

        q2 = state.get_item("q2")
        self.assertEqual(q2["postcondition"][0]["predicate"], "False")
        self.assertIsInstance(q2["postcondition"][0]["predicate"], str)

        # Check that int predicate was converted
        q3 = state.get_item("q3")
        self.assertEqual(q3["precondition"][0]["predicate"], "1")
        self.assertIsInstance(q3["precondition"][0]["predicate"], str)

        # Check that float predicate was converted
        q4 = state.get_item("q4")
        self.assertEqual(q4["precondition"][0]["predicate"], "1.5")
        self.assertIsInstance(q4["precondition"][0]["predicate"], str)

        # String predicates should remain unchanged
        q5 = state.get_item("q5")
        self.assertEqual(q5["precondition"][0]["predicate"], "q1.outcome > 0")

    def test_complex_predicate_raises_error(self):
        """Test that complex type predicates (list, dict) raise ValueError."""
        loader = QMLLoader(schema_path=None)

        # QML with list predicate (likely a mistake)
        qml_content = """
questionnaire:
  title: Invalid Predicate Test
  blocks:
    - id: main
      items:
        - id: q1
          kind: Question
          title: Invalid predicate
          precondition:
            - predicate:
                - item1
                - item2
"""
        with self.assertRaises(ValueError) as ctx:
            loader.load_from_string(qml_content)

        self.assertIn("Invalid predicate type", str(ctx.exception))
        self.assertIn("list", str(ctx.exception))


@pytest.mark.integration
class TestQMLStateInitialization(unittest.TestCase):
    """Tests for QMLState correct initialization."""

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

    def test_topological_order_complete_with_cycles(self):
        """Topological order includes all items even when cycles exist."""
        state = load_qml_fixture("cycles.qml")
        builder = StaticBuilder(state)
        topology = QMLTopology(state, builder)

        order = topology.get_topological_order()
        self.assertIsNotNone(order)
        self.assertTrue(topology.has_cycles)
        # All items appear in the order
        all_item_ids = {item['id'] for item in state.get_all_items() if item.get('id')}
        self.assertEqual(set(order), all_item_ids)


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


@pytest.mark.integration
class TestBlockPreconditionPropagation(unittest.TestCase):
    """Tests for block-level precondition inheritance by enclosed items."""

    def _load_from_string(self, qml_content: str) -> QMLState:
        loader = QMLLoader(schema_path=None)
        data = loader.load_from_string(qml_content)
        return QMLState(data)

    def test_block_precondition_inherited_by_items_without_preconditions(self):
        """Items without their own preconditions inherit the block's preconditions."""
        state = self._load_from_string("""
questionnaire:
  title: Block Inheritance Test
  blocks:
    - id: conditional_block
      precondition:
        - predicate: "q_gate.outcome == 1"
      items:
        - id: q_a
          kind: Question
          title: Question A
        - id: q_b
          kind: Question
          title: Question B
""")
        q_a = state.get_item("q_a")
        q_b = state.get_item("q_b")

        self.assertEqual(len(q_a["precondition"]), 1)
        self.assertEqual(q_a["precondition"][0]["predicate"], "q_gate.outcome == 1")

        self.assertEqual(len(q_b["precondition"]), 1)
        self.assertEqual(q_b["precondition"][0]["predicate"], "q_gate.outcome == 1")

    def test_block_precondition_prepended_to_item_preconditions(self):
        """Block preconditions are prepended before item's own preconditions."""
        state = self._load_from_string("""
questionnaire:
  title: Prepend Test
  blocks:
    - id: filtered_block
      precondition:
        - predicate: "q_gate.outcome == 1"
          hint: Block-level gate
      items:
        - id: q_detail
          kind: Question
          title: Detail question
          precondition:
            - predicate: "q_other.outcome > 5"
              hint: Item-level filter
""")
        q_detail = state.get_item("q_detail")

        # Block precondition first, then item precondition
        self.assertEqual(len(q_detail["precondition"]), 2)
        self.assertEqual(q_detail["precondition"][0]["predicate"], "q_gate.outcome == 1")
        self.assertEqual(q_detail["precondition"][0]["hint"], "Block-level gate")
        self.assertEqual(q_detail["precondition"][1]["predicate"], "q_other.outcome > 5")
        self.assertEqual(q_detail["precondition"][1]["hint"], "Item-level filter")

    def test_block_without_precondition_does_not_affect_items(self):
        """Items in blocks without preconditions are unchanged."""
        state = self._load_from_string("""
questionnaire:
  title: No Block Precondition Test
  blocks:
    - id: plain_block
      items:
        - id: q_plain
          kind: Question
          title: Plain question
        - id: q_with_own
          kind: Question
          title: Has own precondition
          precondition:
            - predicate: "q_plain.outcome > 0"
""")
        q_plain = state.get_item("q_plain")
        q_with_own = state.get_item("q_with_own")

        # No precondition added
        self.assertFalse(q_plain.get("precondition"))

        # Item's own precondition preserved, no extras
        self.assertEqual(len(q_with_own["precondition"]), 1)
        self.assertEqual(q_with_own["precondition"][0]["predicate"], "q_plain.outcome > 0")

    def test_multiple_blocks_mixed_preconditions(self):
        """Only items in blocks with preconditions inherit them."""
        state = self._load_from_string("""
questionnaire:
  title: Mixed Blocks Test
  blocks:
    - id: open_block
      items:
        - id: q_open
          kind: Question
          title: Open question
    - id: gated_block
      precondition:
        - predicate: "q_open.outcome == 1"
      items:
        - id: q_gated
          kind: Question
          title: Gated question
""")
        q_open = state.get_item("q_open")
        q_gated = state.get_item("q_gated")

        self.assertFalse(q_open.get("precondition"))
        self.assertEqual(len(q_gated["precondition"]), 1)
        self.assertEqual(q_gated["precondition"][0]["predicate"], "q_open.outcome == 1")

    def test_multiple_block_preconditions_all_propagated(self):
        """All block-level preconditions propagate to each item."""
        state = self._load_from_string("""
questionnaire:
  title: Multi Precondition Test
  blocks:
    - id: multi_gate
      precondition:
        - predicate: "q_gate1.outcome == 1"
        - predicate: "q_gate2.outcome == 1"
      items:
        - id: q_inner
          kind: Question
          title: Inner question
""")
        q_inner = state.get_item("q_inner")

        self.assertEqual(len(q_inner["precondition"]), 2)
        self.assertEqual(q_inner["precondition"][0]["predicate"], "q_gate1.outcome == 1")
        self.assertEqual(q_inner["precondition"][1]["predicate"], "q_gate2.outcome == 1")

    def test_block_scalar_predicate_normalization(self):
        """Block-level scalar predicates (bool) are normalized to strings."""
        state = self._load_from_string("""
questionnaire:
  title: Block Normalization Test
  blocks:
    - id: always_block
      precondition:
        - predicate: true
      items:
        - id: q_always
          kind: Question
          title: Always shown
""")
        q_always = state.get_item("q_always")

        self.assertEqual(len(q_always["precondition"]), 1)
        self.assertEqual(q_always["precondition"][0]["predicate"], "True")
        self.assertIsInstance(q_always["precondition"][0]["predicate"], str)

    def test_block_preconditions_stripped_from_block_metadata(self):
        """Flattened block metadata retains preconditions but not items."""
        state = self._load_from_string("""
questionnaire:
  title: Block Metadata Test
  blocks:
    - id: gated
      title: Gated Block
      precondition:
        - predicate: "x == 1"
      items:
        - id: q1
          kind: Question
          title: Q1
""")
        blocks = state.get_blocks()
        self.assertEqual(len(blocks), 1)

        block = blocks[0]
        self.assertNotIn("items", block)
        self.assertEqual(block["id"], "gated")
        self.assertIn("precondition", block)


@pytest.mark.integration
@pytest.mark.z3
class TestBlockPreconditionPipeline(unittest.TestCase):
    """Tests that block preconditions flow through to Z3 constraints and classification."""

    def test_block_precondition_creates_dependencies(self):
        """Block-inherited preconditions create item dependencies in StaticBuilder."""
        state = load_qml_fixture("block_preconditions.qml")
        builder = StaticBuilder(state)

        deps = builder.get_item_dependencies()

        # q_employed inherits block precondition referencing q_age
        self.assertIn("q_age", deps.get("q_employed", set()))

        # q_job_title has block precondition (q_age) + own precondition (q_employed)
        q_job_deps = deps.get("q_job_title", set())
        self.assertIn("q_age", q_job_deps)
        self.assertIn("q_employed", q_job_deps)

        # q_retired inherits block precondition referencing q_age
        self.assertIn("q_age", deps.get("q_retired", set()))

        # q_country in screening block has no preconditions → no deps
        self.assertEqual(len(deps.get("q_country", set())), 0)

    def test_block_precondition_topological_order(self):
        """Block-inherited dependencies are respected in topological order."""
        state = load_qml_fixture("block_preconditions.qml")
        builder = StaticBuilder(state)
        topology = QMLTopology(state, builder)

        order = topology.get_topological_order()
        self.assertFalse(topology.has_cycles)

        # q_age must come before all employment and retirement items
        age_idx = order.index("q_age")
        self.assertLess(age_idx, order.index("q_employed"))
        self.assertLess(age_idx, order.index("q_job_title"))
        self.assertLess(age_idx, order.index("q_retired"))

        # q_employed must come before q_job_title (item-level dep)
        self.assertLess(order.index("q_employed"), order.index("q_job_title"))

    def test_block_precondition_item_classification(self):
        """Items with block-inherited preconditions are classified as CONDITIONAL."""
        state = load_qml_fixture("block_preconditions.qml")
        builder = StaticBuilder(state)
        classifier = ItemClassifier(builder)

        # Screening items (no block precondition) → ALWAYS
        result_age = classifier.classify_item("q_age")
        self.assertEqual(result_age["precondition"]["status"], "ALWAYS")

        result_country = classifier.classify_item("q_country")
        self.assertEqual(result_country["precondition"]["status"], "ALWAYS")

        # Employment items (block precondition: q_age.outcome <= 2) → CONDITIONAL
        result_employed = classifier.classify_item("q_employed")
        self.assertEqual(result_employed["precondition"]["status"], "CONDITIONAL")

        # Retirement item (block precondition: q_age.outcome == 3) → CONDITIONAL
        result_retired = classifier.classify_item("q_retired")
        self.assertEqual(result_retired["precondition"]["status"], "CONDITIONAL")

    def test_block_precondition_merged_item_has_combined_preconditions(self):
        """q_job_title has both block and item preconditions in the loaded state."""
        state = load_qml_fixture("block_preconditions.qml")

        q_job = state.get_item("q_job_title")
        self.assertEqual(len(q_job["precondition"]), 2)
        # Block precondition first
        self.assertEqual(q_job["precondition"][0]["predicate"], "q_age.outcome <= 2")
        # Item precondition second
        self.assertEqual(q_job["precondition"][1]["predicate"], "q_employed.outcome == 1")


if __name__ == "__main__":
    unittest.main()
