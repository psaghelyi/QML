#!/usr/bin/env python3
"""Unit tests for QMLDiagram - Mermaid diagram generation.

This test suite verifies the QMLDiagram class which generates Mermaid
diagrams for QML questionnaires.

## Coverage Areas:

### Base Diagram Generation (6 tests)
- Empty questionnaire (no items)
- Single item diagram
- Multiple items with dependencies
- Variable nodes generation
- Precondition nodes generation
- Postcondition nodes generation

### Mermaid Syntax (4 tests)
- Valid flowchart declaration
- Item node syntax
- Edge/connection syntax
- Class definition syntax

### Coloring (4 tests)
- Flow coloring with visited items
- Flow coloring with current item
- Analysis coloring with classification
- Coloring markers (BEGIN/END_ITEM_STYLING)

### Special Cases (3 tests)
- Character escaping for Mermaid
- Text truncation
- Cycle highlighting

Total: 17 tests covering QMLDiagram functionality.
"""

import unittest
import pytest
from askalot_qml.models.questionnaire_state import QuestionnaireState
from askalot_qml.core.qml_topology import QMLTopology
from askalot_qml.core.qml_diagram import QMLDiagram
from askalot_qml.z3.static_builder import StaticBuilder


def create_questionnaire(items_data: list, code_init: str = '') -> QuestionnaireState:
    """Helper to create QuestionnaireState from item definitions."""
    return QuestionnaireState({
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


def create_diagram(state: QuestionnaireState) -> QMLDiagram:
    """Helper to create QMLDiagram from QuestionnaireState."""
    builder = StaticBuilder(state)
    topology = QMLTopology(state, builder)
    return QMLDiagram(topology, state)


@pytest.mark.unit
@pytest.mark.diagram
class TestQMLDiagramBaseGeneration(unittest.TestCase):
    """Tests for base diagram generation."""

    def test_empty_questionnaire(self):
        """Test diagram generation with no items."""
        state = QuestionnaireState({
            'title': 'Empty',
            'blocks': [],
            'items': []
        })
        diagram = create_diagram(state)
        base = diagram.generate_base_diagram()

        # Should still have flowchart declaration
        self.assertIn('flowchart TD', base)
        # Should have CSS definitions
        self.assertIn('classDef default', base)

    def test_single_item(self):
        """Test diagram with single item."""
        state = create_questionnaire([
            {'id': 'q1', 'title': 'First Question'}
        ])
        diagram = create_diagram(state)
        base = diagram.generate_base_diagram()

        # Item node should be present
        self.assertIn('q1', base)
        self.assertIn('First Question', base)

    def test_multiple_items_with_dependencies(self):
        """Test diagram with dependencies."""
        state = create_questionnaire([
            {'id': 'q1'},
            {'id': 'q2', 'precondition': [{'predicate': 'q1.outcome == 1'}]},
            {'id': 'q3', 'precondition': [{'predicate': 'q2.outcome == 1'}]}
        ])
        diagram = create_diagram(state)
        base = diagram.generate_base_diagram()

        # All items should be present
        self.assertIn('q1', base)
        self.assertIn('q2', base)
        self.assertIn('q3', base)

        # Topological chain edges should be present (animated edges)
        self.assertIn('==>', base)

    def test_variable_nodes(self):
        """Test variable node generation from codeBlock."""
        state = create_questionnaire([
            {'id': 'q1', 'codeBlock': 'score = 10'},
            {'id': 'q2', 'codeBlock': 'score = score + 5'}
        ], code_init='score = 0')
        diagram = create_diagram(state)
        base = diagram.generate_base_diagram()

        # Variable node should be present
        self.assertIn('var_score', base)
        # Variable should have variable class
        self.assertIn('var_score:::variable', base)

    def test_precondition_nodes(self):
        """Test precondition node generation."""
        state = create_questionnaire([
            {'id': 'q1'},
            {'id': 'q2', 'precondition': [{'predicate': 'q1.outcome == 1'}]}
        ])
        diagram = create_diagram(state)
        base = diagram.generate_base_diagram()

        # Precondition section markers
        self.assertIn('%% BEGIN_PRECONDITIONS', base)
        self.assertIn('%% END_PRECONDITIONS', base)

        # Precondition node (rounded shape uses parentheses)
        self.assertIn('q2_precond_0', base)
        self.assertIn('q1.outcome == 1', base)

    def test_postcondition_nodes(self):
        """Test postcondition node generation."""
        state = create_questionnaire([
            {'id': 'q1', 'postcondition': [{'predicate': 'q1.outcome > 0', 'hint': 'Must be positive'}]}
        ])
        diagram = create_diagram(state)
        base = diagram.generate_base_diagram()

        # Postcondition section markers
        self.assertIn('%% BEGIN_POSTCONDITIONS', base)
        self.assertIn('%% END_POSTCONDITIONS', base)

        # Postcondition node (hexagon shape uses double braces)
        self.assertIn('q1_postcond_0', base)


@pytest.mark.unit
@pytest.mark.diagram
class TestQMLDiagramMermaidSyntax(unittest.TestCase):
    """Tests for valid Mermaid syntax generation."""

    def test_flowchart_declaration(self):
        """Test valid flowchart declaration."""
        state = create_questionnaire([{'id': 'q1'}])
        diagram = create_diagram(state)
        base = diagram.generate_base_diagram()

        lines = base.split('\n')
        self.assertEqual(lines[0], 'flowchart TD')

    def test_item_node_syntax(self):
        """Test item node syntax with brackets."""
        state = create_questionnaire([
            {'id': 'q1', 'title': 'Test Question'}
        ])
        diagram = create_diagram(state)
        base = diagram.generate_base_diagram()

        # Item nodes use square brackets
        self.assertIn('q1["q1: Test Question"]', base)

    def test_edge_syntax(self):
        """Test edge connection syntax."""
        state = create_questionnaire([
            {'id': 'q1'},
            {'id': 'q2', 'precondition': [{'predicate': 'q1.outcome == 1'}]}
        ])
        diagram = create_diagram(state)
        base = diagram.generate_base_diagram()

        # Should have animated edge in topological chain
        self.assertIn('@==>', base)

    def test_class_definitions(self):
        """Test CSS class definitions."""
        state = create_questionnaire([{'id': 'q1'}])
        diagram = create_diagram(state)
        base = diagram.generate_base_diagram()

        # All required class definitions
        self.assertIn('classDef default', base)
        self.assertIn('classDef current', base)
        self.assertIn('classDef visited', base)
        self.assertIn('classDef pending', base)
        self.assertIn('classDef always', base)
        self.assertIn('classDef conditional', base)
        self.assertIn('classDef never', base)
        self.assertIn('classDef variable', base)
        self.assertIn('classDef precondition', base)
        self.assertIn('classDef postcondition', base)


@pytest.mark.unit
@pytest.mark.diagram
class TestQMLDiagramColoring(unittest.TestCase):
    """Tests for diagram coloring."""

    def test_flow_coloring_visited_items(self):
        """Test flow coloring marks visited items."""
        state = create_questionnaire([
            {'id': 'q1'},
            {'id': 'q2'},
            {'id': 'q3'}
        ])
        # Mark q1 as visited
        state.get_item('q1')['visited'] = True

        diagram = create_diagram(state)
        base = diagram.generate_base_diagram()
        colored = diagram.apply_flow_coloring(base)

        self.assertIn('q1:::visited', colored)
        self.assertIn('q2:::pending', colored)
        self.assertIn('q3:::pending', colored)

    def test_flow_coloring_current_item(self):
        """Test flow coloring highlights current item."""
        state = create_questionnaire([
            {'id': 'q1'},
            {'id': 'q2'},
            {'id': 'q3'}
        ])

        diagram = create_diagram(state)
        base = diagram.generate_base_diagram()
        colored = diagram.apply_flow_coloring(base, current_item_id='q2')

        self.assertIn('q2:::current', colored)
        self.assertIn('q1:::pending', colored)
        self.assertIn('q3:::pending', colored)

    def test_analysis_coloring_with_classifier(self):
        """Test analysis coloring uses classifier results."""
        state = create_questionnaire([
            {'id': 'q1'},  # Should be ALWAYS (no precondition)
            {'id': 'q2', 'precondition': [{'predicate': 'q1.outcome == 1'}]}  # CONDITIONAL
        ])

        from askalot_qml.z3.item_classifier import ItemClassifier
        builder = StaticBuilder(state)
        topology = QMLTopology(state, builder)
        diagram = QMLDiagram(topology, state)
        classifier = ItemClassifier(builder)

        base = diagram.generate_base_diagram()
        colored = diagram.apply_analysis_coloring(base, classifier)

        # q1 should be always (no precondition = always reachable)
        self.assertIn('q1:::always', colored)
        # q2 should be conditional (has precondition)
        self.assertIn('q2:::conditional', colored)

    def test_coloring_markers_present(self):
        """Test that coloring markers are in base diagram."""
        state = create_questionnaire([{'id': 'q1'}])
        diagram = create_diagram(state)
        base = diagram.generate_base_diagram()

        self.assertIn('%% BEGIN_ITEM_STYLING', base)
        self.assertIn('%% END_ITEM_STYLING', base)


@pytest.mark.unit
@pytest.mark.diagram
class TestQMLDiagramSpecialCases(unittest.TestCase):
    """Tests for special cases and edge conditions."""

    def test_character_escaping(self):
        """Test that special characters are escaped."""
        state = create_questionnaire([
            {'id': 'q1', 'title': 'Is age > 18?'}
        ])
        diagram = create_diagram(state)
        base = diagram.generate_base_diagram()

        # > should be escaped to &gt;
        self.assertIn('&gt;', base)
        self.assertNotIn('> 18', base)

    def test_text_truncation(self):
        """Test that long text is truncated."""
        long_predicate = 'a' * 100
        state = create_questionnaire([
            {'id': 'q1', 'precondition': [{'predicate': long_predicate}]}
        ])
        diagram = create_diagram(state)

        # Truncate helper should shorten text
        truncated = diagram._truncate_text(long_predicate, 50)
        self.assertEqual(len(truncated), 50)
        self.assertTrue(truncated.endswith('...'))

    def test_cycle_highlighting(self):
        """Test cycle highlighting in diagram."""
        state = create_questionnaire([
            {'id': 'q1', 'precondition': [{'predicate': 'q2.outcome == 1'}]},
            {'id': 'q2', 'precondition': [{'predicate': 'q1.outcome == 1'}]}
        ])
        diagram = create_diagram(state)
        base = diagram.generate_base_diagram()

        # Cycle detection comment
        self.assertIn('%% Cycle Detection', base)
        # Cycle edge notation
        self.assertIn('CYCLE', base)
        # Cycle node styling
        self.assertIn('cycleNode', base)


@pytest.mark.unit
@pytest.mark.diagram
class TestQMLDiagramAnalysisReport(unittest.TestCase):
    """Tests for analysis report generation."""

    def test_report_contains_summary(self):
        """Test report contains summary section."""
        state = create_questionnaire([
            {'id': 'q1'},
            {'id': 'q2', 'precondition': [{'predicate': 'q1.outcome == 1'}]}
        ])
        diagram = create_diagram(state)
        report = diagram.generate_analysis_report()

        self.assertIn('Summary', report)
        self.assertIn('Items: 2', report)

    def test_report_shows_cycle_status(self):
        """Test report shows cycle status."""
        state = create_questionnaire([{'id': 'q1'}])
        diagram = create_diagram(state)
        report = diagram.generate_analysis_report()

        self.assertIn('No cycles', report)

    def test_report_shows_flow_order(self):
        """Test report shows flow order."""
        state = create_questionnaire([
            {'id': 'q1'},
            {'id': 'q2'},
            {'id': 'q3'}
        ])
        diagram = create_diagram(state)
        report = diagram.generate_analysis_report()

        self.assertIn('Flow', report)
        self.assertIn('Order', report)


if __name__ == '__main__':
    unittest.main()
