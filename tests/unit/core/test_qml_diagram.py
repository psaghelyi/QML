#!/usr/bin/env python3
"""Unit tests for QMLDiagram - Graph IR generation and validation reporting.

This test suite verifies the QMLDiagram class which generates JSON graph IR
and text validation reports for QML questionnaires.

## Coverage Areas:

### Base Graph Generation (6 tests)
- Empty questionnaire (no items)
- Single item graph
- Multiple items with dependencies
- Variable nodes generation
- Precondition nodes generation
- Postcondition nodes generation

### Graph Coloring (1 test)
- Validation coloring with classification

### Special Cases (2 tests)
- Text truncation
- Cycle highlighting

### Validation Report (3 tests)
- Report contains summary
- Report shows cycle status
- Report shows flow order

Total: 12 tests covering QMLDiagram functionality.
"""

import unittest
import pytest
from askalot_qml.models.qml_state import QMLState
from askalot_qml.core.qml_topology import QMLTopology
from askalot_qml.core.qml_diagram import QMLDiagram
from askalot_qml.z3.static_builder import StaticBuilder


def create_questionnaire(items_data: list, code_init: str = '') -> QMLState:
    """Helper to create QMLState from item definitions."""
    return QMLState({
        'title': 'Test Questionnaire',
        'codeInit': code_init,
        'blocks': [{'id': 'b1', 'title': 'Block 1'}],
        'items': [
            {
                'id': item['id'],
                'blockId': 'b1',
                'kind': 'Question',
                'title': item.get('title', f"Question {item['id']}"),
                **{k: v for k, v in item.items() if k not in ('id', 'title')}
            }
            for item in items_data
        ]
    })


def create_diagram(state: QMLState) -> QMLDiagram:
    """Helper to create QMLDiagram from QMLState."""
    builder = StaticBuilder(state)
    topology = QMLTopology(state, builder)
    return QMLDiagram(topology, state)


@pytest.mark.unit
@pytest.mark.diagram
class TestQMLDiagramBaseGeneration(unittest.TestCase):
    """Tests for base graph generation."""

    def test_empty_questionnaire(self):
        """Test graph generation with no items."""
        state = QMLState({
            'title': 'Empty',
            'blocks': [],
            'items': []
        })
        diagram = create_diagram(state)
        graph = diagram.generate_base_graph()

        self.assertIn('nodes', graph)
        self.assertIn('edges', graph)
        self.assertIn('metadata', graph)
        self.assertEqual(graph['nodes'], [])
        self.assertEqual(graph['edges'], [])

    def test_single_item(self):
        """Test graph with single item."""
        state = create_questionnaire([
            {'id': 'q1', 'title': 'First Question'}
        ])
        diagram = create_diagram(state)
        graph = diagram.generate_base_graph()

        item_nodes = [n for n in graph['nodes'] if n['type'] == 'item']
        self.assertEqual(len(item_nodes), 1)
        self.assertEqual(item_nodes[0]['id'], 'q1')
        self.assertIn('First Question', item_nodes[0]['label'])

    def test_multiple_items_with_dependencies(self):
        """Test graph with dependencies."""
        state = create_questionnaire([
            {'id': 'q1'},
            {'id': 'q2', 'precondition': [{'predicate': 'q1.outcome == 1'}]},
            {'id': 'q3', 'precondition': [{'predicate': 'q2.outcome == 1'}]}
        ])
        diagram = create_diagram(state)
        graph = diagram.generate_base_graph()

        item_ids = {n['id'] for n in graph['nodes'] if n['type'] == 'item'}
        self.assertEqual(item_ids, {'q1', 'q2', 'q3'})

        topo_edges = [e for e in graph['edges'] if e['type'] == 'topological']
        self.assertTrue(len(topo_edges) >= 2)

    def test_variable_nodes(self):
        """Test variable node generation from codeBlock."""
        state = create_questionnaire([
            {'id': 'q1', 'codeBlock': 'score = 10'},
            {'id': 'q2', 'codeBlock': 'score = score + 5'}
        ], code_init='score = 0')
        diagram = create_diagram(state)
        graph = diagram.generate_base_graph()

        var_nodes = [n for n in graph['nodes'] if n['type'] == 'variable']
        var_ids = {n['id'] for n in var_nodes}
        self.assertIn('var_score', var_ids)

    def test_precondition_nodes(self):
        """Test precondition node generation."""
        state = create_questionnaire([
            {'id': 'q1'},
            {'id': 'q2', 'precondition': [{'predicate': 'q1.outcome == 1'}]}
        ])
        diagram = create_diagram(state)
        graph = diagram.generate_base_graph()

        precond_nodes = [n for n in graph['nodes'] if n['type'] == 'precondition']
        self.assertEqual(len(precond_nodes), 1)
        self.assertEqual(precond_nodes[0]['id'], 'q2_precond_0')
        self.assertEqual(precond_nodes[0]['owner'], 'q2')
        self.assertIn('q1.outcome == 1', precond_nodes[0]['label'])

    def test_postcondition_nodes(self):
        """Test postcondition node generation."""
        state = create_questionnaire([
            {'id': 'q1', 'postcondition': [{'predicate': 'q1.outcome > 0', 'hint': 'Must be positive'}]}
        ])
        diagram = create_diagram(state)
        graph = diagram.generate_base_graph()

        postcond_nodes = [n for n in graph['nodes'] if n['type'] == 'postcondition']
        self.assertEqual(len(postcond_nodes), 1)
        self.assertEqual(postcond_nodes[0]['id'], 'q1_postcond_0')
        self.assertEqual(postcond_nodes[0]['owner'], 'q1')


@pytest.mark.unit
@pytest.mark.diagram
class TestQMLDiagramColoring(unittest.TestCase):
    """Tests for diagram coloring."""

    def test_validation_coloring_with_classifier(self):
        """Test validation coloring uses classifier results."""
        state = create_questionnaire([
            {'id': 'q1'},  # Should be ALWAYS (no precondition)
            {'id': 'q2', 'precondition': [{'predicate': 'q1.outcome == 1'}]}  # CONDITIONAL
        ])

        from askalot_qml.z3.item_classifier import ItemClassifier
        builder = StaticBuilder(state)
        topology = QMLTopology(state, builder)
        diagram = QMLDiagram(topology, state)
        classifier = ItemClassifier(builder)
        classifications = classifier.classify_all_items()

        graph = diagram.generate_base_graph()
        colored = diagram.apply_validation_coloring(graph, classifications=classifications)

        self.assertEqual(colored['classes']['q1'], 'always')
        self.assertEqual(colored['classes']['q2'], 'conditional')


@pytest.mark.unit
@pytest.mark.diagram
class TestQMLDiagramSpecialCases(unittest.TestCase):
    """Tests for special cases and edge conditions."""

    def test_text_truncation(self):
        """Test that long text is truncated."""
        long_predicate = 'a' * 100
        state = create_questionnaire([
            {'id': 'q1', 'precondition': [{'predicate': long_predicate}]}
        ])
        diagram = create_diagram(state)

        truncated = diagram._truncate_text(long_predicate, 50)
        self.assertEqual(len(truncated), 50)
        self.assertTrue(truncated.endswith('...'))

    def test_cycle_highlighting(self):
        """Test cycle highlighting in graph — includes chain edges for vertical layout."""
        state = create_questionnaire([
            {'id': 'q1', 'precondition': [{'predicate': 'q2.outcome == 1'}]},
            {'id': 'q2', 'precondition': [{'predicate': 'q1.outcome == 1'}]}
        ])
        diagram = create_diagram(state)
        graph = diagram.generate_base_graph()

        self.assertTrue(graph['metadata']['has_cycles'])
        cycle_edges = [e for e in graph['edges'] if e['type'] == 'cycle']
        self.assertTrue(len(cycle_edges) > 0)

        # Chain edges must exist even with cycles (for vertical layout)
        chain_edges = [e for e in graph['edges'] if e['type'] == 'topological']
        self.assertTrue(len(chain_edges) > 0)


@pytest.mark.unit
@pytest.mark.diagram
class TestQMLDiagramValidationReport(unittest.TestCase):
    """Tests for validation report generation."""

    def test_report_contains_summary(self):
        """Test report contains summary section."""
        state = create_questionnaire([
            {'id': 'q1'},
            {'id': 'q2', 'precondition': [{'predicate': 'q1.outcome == 1'}]}
        ])
        diagram = create_diagram(state)
        report = diagram.generate_validation_report()

        self.assertIn('Summary', report)
        self.assertIn('Items: 2', report)

    def test_report_shows_cycle_status(self):
        """Test report shows cycle status."""
        state = create_questionnaire([{'id': 'q1'}])
        diagram = create_diagram(state)
        report = diagram.generate_validation_report()

        self.assertIn('No cycles', report)

    def test_report_shows_flow_order(self):
        """Test report shows flow order."""
        state = create_questionnaire([
            {'id': 'q1'},
            {'id': 'q2'},
            {'id': 'q3'}
        ])
        diagram = create_diagram(state)
        report = diagram.generate_validation_report()

        self.assertIn('Flow', report)
        self.assertIn('Order', report)


if __name__ == '__main__':
    unittest.main()
