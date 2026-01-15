#!/usr/bin/env python3
"""Unit tests for QMLTopology - Dependency graph and cycle detection.

This test suite verifies the QMLTopology class which handles:
1. Building dependency graphs from questionnaire items
2. Detecting cycles using dual approach (Z3 + Kahn's algorithm)
3. Computing topological order for navigation
4. Analyzing dependency layers and connected components

## Coverage Areas:

### Dependency Graph Building (4 tests)
- Empty questionnaire (no items)
- Linear dependencies (A → B → C)
- Multiple independent items (no dependencies)
- Complex dependencies (diamond pattern)

### Cycle Detection (5 tests)
- No cycles in linear dependencies
- Simple cycle (A → B → A)
- Complex cycle (A → B → C → A)
- Multiple cycles
- Self-referencing item

### Topological Ordering (4 tests)
- Correct order for linear dependencies
- Order preserves QML file order for independent items
- Order respects all dependencies
- Fallback when cycles exist

### Dependency Analysis (3 tests)
- Connected components identification
- Dependency layers grouping
- Reachability analysis

Total: 16 tests covering QMLTopology functionality.
"""

import unittest
import pytest
from askalot_qml.models.questionnaire_state import QuestionnaireState
from askalot_qml.core.qml_topology import QMLTopology
from askalot_qml.z3.static_builder import StaticBuilder


def create_questionnaire(items_data: list) -> QuestionnaireState:
    """Helper to create QuestionnaireState from item definitions."""
    return QuestionnaireState({
        'title': 'Test Questionnaire',
        'blocks': [{'id': 'b1', 'title': 'Block 1'}],
        'items': [
            {
                'id': item['id'],
                'blockId': 'b1',
                'kind': 'Question',
                'title': f"Question {item['id']}",
                **{k: v for k, v in item.items() if k != 'id'}
            }
            for item in items_data
        ]
    })


@pytest.mark.unit
@pytest.mark.topology
class TestQMLTopologyDependencyGraph(unittest.TestCase):
    """Tests for dependency graph building."""

    def test_empty_questionnaire(self):
        """Test topology with no items."""
        state = QuestionnaireState({
            'title': 'Empty',
            'blocks': [],
            'items': []
        })
        builder = StaticBuilder(state)
        topology = QMLTopology(state, builder)

        self.assertEqual(len(topology.items), 0)
        self.assertFalse(topology.has_cycles)
        self.assertEqual(topology.topological_order, [])

    def test_linear_dependencies(self):
        """Test linear dependency chain: q1 → q2 → q3."""
        state = create_questionnaire([
            {'id': 'q1'},
            {'id': 'q2', 'precondition': [{'predicate': 'q1.outcome == 1'}]},
            {'id': 'q3', 'precondition': [{'predicate': 'q2.outcome == 1'}]}
        ])
        builder = StaticBuilder(state)
        topology = QMLTopology(state, builder)

        # Check dependencies
        self.assertIn('q1', topology.dependencies.get('q2', set()))
        self.assertIn('q2', topology.dependencies.get('q3', set()))
        self.assertEqual(len(topology.dependencies.get('q1', set())), 0)

    def test_independent_items(self):
        """Test items with no dependencies."""
        state = create_questionnaire([
            {'id': 'q1'},
            {'id': 'q2'},
            {'id': 'q3'}
        ])
        builder = StaticBuilder(state)
        topology = QMLTopology(state, builder)

        # No dependencies between items
        for item_id in ['q1', 'q2', 'q3']:
            self.assertEqual(len(topology.dependencies.get(item_id, set())), 0)

        self.assertFalse(topology.has_cycles)

    def test_diamond_dependencies(self):
        """Test diamond pattern: q1 → q2, q1 → q3, q2 → q4, q3 → q4."""
        state = create_questionnaire([
            {'id': 'q1'},
            {'id': 'q2', 'precondition': [{'predicate': 'q1.outcome == 1'}]},
            {'id': 'q3', 'precondition': [{'predicate': 'q1.outcome == 2'}]},
            {'id': 'q4', 'precondition': [{'predicate': 'q2.outcome == 1 or q3.outcome == 1'}]}
        ])
        builder = StaticBuilder(state)
        topology = QMLTopology(state, builder)

        # Check diamond structure
        self.assertIn('q1', topology.dependencies.get('q2', set()))
        self.assertIn('q1', topology.dependencies.get('q3', set()))
        self.assertIn('q2', topology.dependencies.get('q4', set()))
        self.assertIn('q3', topology.dependencies.get('q4', set()))

        self.assertFalse(topology.has_cycles)


@pytest.mark.unit
@pytest.mark.topology
@pytest.mark.cycle_detection
class TestQMLTopologyCycleDetection(unittest.TestCase):
    """Tests for cycle detection (Z3 + Kahn's algorithm verification)."""

    def test_no_cycles_linear(self):
        """Test no cycles in linear dependencies."""
        state = create_questionnaire([
            {'id': 'q1'},
            {'id': 'q2', 'precondition': [{'predicate': 'q1.outcome == 1'}]},
            {'id': 'q3', 'precondition': [{'predicate': 'q2.outcome == 1'}]}
        ])
        builder = StaticBuilder(state)
        topology = QMLTopology(state, builder)

        self.assertFalse(topology.has_cycles)
        self.assertEqual(len(topology.cycles), 0)

    def test_simple_cycle(self):
        """Test detection of simple cycle: q1 → q2 → q1."""
        state = create_questionnaire([
            {'id': 'q1', 'precondition': [{'predicate': 'q2.outcome == 1'}]},
            {'id': 'q2', 'precondition': [{'predicate': 'q1.outcome == 1'}]}
        ])
        builder = StaticBuilder(state)
        topology = QMLTopology(state, builder)

        self.assertTrue(topology.has_cycles)
        self.assertGreater(len(topology.cycles), 0)

    def test_complex_cycle(self):
        """Test detection of complex cycle: q1 → q2 → q3 → q1."""
        state = create_questionnaire([
            {'id': 'q1', 'precondition': [{'predicate': 'q3.outcome == 1'}]},
            {'id': 'q2', 'precondition': [{'predicate': 'q1.outcome == 1'}]},
            {'id': 'q3', 'precondition': [{'predicate': 'q2.outcome == 1'}]}
        ])
        builder = StaticBuilder(state)
        topology = QMLTopology(state, builder)

        self.assertTrue(topology.has_cycles)

    def test_multiple_cycles(self):
        """Test detection with multiple independent cycles."""
        state = create_questionnaire([
            # Cycle 1: q1 → q2 → q1
            {'id': 'q1', 'precondition': [{'predicate': 'q2.outcome == 1'}]},
            {'id': 'q2', 'precondition': [{'predicate': 'q1.outcome == 1'}]},
            # Cycle 2: q3 → q4 → q3
            {'id': 'q3', 'precondition': [{'predicate': 'q4.outcome == 1'}]},
            {'id': 'q4', 'precondition': [{'predicate': 'q3.outcome == 1'}]}
        ])
        builder = StaticBuilder(state)
        topology = QMLTopology(state, builder)

        self.assertTrue(topology.has_cycles)

    def test_self_reference(self):
        """Test detection of self-referencing item."""
        state = create_questionnaire([
            {'id': 'q1', 'precondition': [{'predicate': 'q1.outcome == 1'}]}
        ])
        builder = StaticBuilder(state)
        topology = QMLTopology(state, builder)

        # Self-reference creates a cycle
        self.assertTrue(topology.has_cycles)


@pytest.mark.unit
@pytest.mark.topology
class TestQMLTopologyTopologicalOrder(unittest.TestCase):
    """Tests for topological ordering."""

    def test_linear_order(self):
        """Test correct order for linear dependencies."""
        state = create_questionnaire([
            {'id': 'q1'},
            {'id': 'q2', 'precondition': [{'predicate': 'q1.outcome == 1'}]},
            {'id': 'q3', 'precondition': [{'predicate': 'q2.outcome == 1'}]}
        ])
        builder = StaticBuilder(state)
        topology = QMLTopology(state, builder)

        order = topology.get_topological_order()
        self.assertIsNotNone(order)

        # q1 must come before q2, q2 must come before q3
        self.assertLess(order.index('q1'), order.index('q2'))
        self.assertLess(order.index('q2'), order.index('q3'))

    def test_preserves_qml_order_for_independent(self):
        """Test that QML file order is preserved for independent items."""
        state = create_questionnaire([
            {'id': 'q1'},
            {'id': 'q2'},
            {'id': 'q3'}
        ])
        builder = StaticBuilder(state)
        topology = QMLTopology(state, builder)

        order = topology.get_topological_order()
        self.assertIsNotNone(order)

        # Should preserve original order: q1, q2, q3
        self.assertEqual(order, ['q1', 'q2', 'q3'])

    def test_respects_all_dependencies(self):
        """Test that order respects all dependencies in diamond pattern."""
        state = create_questionnaire([
            {'id': 'q1'},
            {'id': 'q2', 'precondition': [{'predicate': 'q1.outcome == 1'}]},
            {'id': 'q3', 'precondition': [{'predicate': 'q1.outcome == 2'}]},
            {'id': 'q4', 'precondition': [{'predicate': 'q2.outcome == 1 and q3.outcome == 1'}]}
        ])
        builder = StaticBuilder(state)
        topology = QMLTopology(state, builder)

        order = topology.get_topological_order()
        self.assertIsNotNone(order)

        # q1 must come before q2 and q3
        self.assertLess(order.index('q1'), order.index('q2'))
        self.assertLess(order.index('q1'), order.index('q3'))
        # q2 and q3 must come before q4
        self.assertLess(order.index('q2'), order.index('q4'))
        self.assertLess(order.index('q3'), order.index('q4'))

    def test_returns_none_with_cycles(self):
        """Test that topological order returns None when cycles exist."""
        state = create_questionnaire([
            {'id': 'q1', 'precondition': [{'predicate': 'q2.outcome == 1'}]},
            {'id': 'q2', 'precondition': [{'predicate': 'q1.outcome == 1'}]}
        ])
        builder = StaticBuilder(state)
        topology = QMLTopology(state, builder)

        order = topology.get_topological_order()
        self.assertIsNone(order)


@pytest.mark.unit
@pytest.mark.topology
class TestQMLTopologyAnalysis(unittest.TestCase):
    """Tests for dependency analysis features."""

    def test_connected_components_independent(self):
        """Test identification of independent components."""
        state = create_questionnaire([
            # Component 1: q1 → q2
            {'id': 'q1'},
            {'id': 'q2', 'precondition': [{'predicate': 'q1.outcome == 1'}]},
            # Component 2: q3 → q4
            {'id': 'q3'},
            {'id': 'q4', 'precondition': [{'predicate': 'q3.outcome == 1'}]}
        ])
        builder = StaticBuilder(state)
        topology = QMLTopology(state, builder)

        components = topology.get_components()
        self.assertEqual(len(components), 2)

    def test_dependency_layers(self):
        """Test grouping items into dependency layers."""
        state = create_questionnaire([
            {'id': 'q1'},
            {'id': 'q2'},
            {'id': 'q3', 'precondition': [{'predicate': 'q1.outcome == 1'}]},
            {'id': 'q4', 'precondition': [{'predicate': 'q3.outcome == 1'}]}
        ])
        builder = StaticBuilder(state)
        topology = QMLTopology(state, builder)

        layers = topology.get_dependency_layers()

        # Layer 0: q1, q2 (no dependencies)
        # Layer 1: q3 (depends on q1)
        # Layer 2: q4 (depends on q3)
        self.assertEqual(len(layers), 3)
        self.assertIn('q1', layers[0])
        self.assertIn('q2', layers[0])
        self.assertIn('q3', layers[1])
        self.assertIn('q4', layers[2])

    def test_reachability(self):
        """Test reachability analysis between items."""
        state = create_questionnaire([
            {'id': 'q1'},
            {'id': 'q2', 'precondition': [{'predicate': 'q1.outcome == 1'}]},
            {'id': 'q3', 'precondition': [{'predicate': 'q2.outcome == 1'}]},
            {'id': 'q4'}  # Independent
        ])
        builder = StaticBuilder(state)
        topology = QMLTopology(state, builder)

        # q3 can reach q1 through dependencies
        self.assertTrue(topology.can_reach('q3', 'q1'))
        self.assertTrue(topology.can_reach('q3', 'q2'))

        # q4 cannot reach q1 (independent)
        self.assertFalse(topology.can_reach('q4', 'q1'))

        # Self-reachability
        self.assertTrue(topology.can_reach('q1', 'q1'))


if __name__ == '__main__':
    unittest.main()
