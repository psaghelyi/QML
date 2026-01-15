#!/usr/bin/env python3
"""Unit tests for StaticBuilder - Z3 constraint generation and SSA versioning.

This test suite verifies the StaticBuilder class which provides:
1. SSA (Static Single Assignment) versioning for variables
2. Z3 constraint generation from preconditions, postconditions, code blocks
3. Item dependency discovery through constraint analysis
4. ItemClassifier compatibility interface

## Coverage Areas:

### SSA Versioning (5 tests)
- Version tracking for single assignment
- Version increment on reassignment
- Independent versioning for multiple variables
- Version history tracking
- Code block processing creates versions

### Z3 Constraint Generation (5 tests)
- Precondition constraints
- Postcondition constraints
- Code block assignment constraints
- Initialization code constraints (unconditional)
- Arithmetic expression constraints

### Dependency Discovery (4 tests)
- Precondition-based dependencies
- No dependencies for independent items
- Multiple dependencies per item
- Transitive dependency handling

### ItemClassifier Compatibility (4 tests)
- item_details population
- item_order preservation
- compile_conditions method
- get_domain_base method

### AST to Z3 Conversion (5 tests)
- Integer constants
- Boolean constants
- Comparison operators
- Boolean operators (and, or, not)
- Item outcome attribute access

Total: 23 tests covering StaticBuilder functionality.
"""

import unittest
import pytest
from z3 import *
from askalot_qml.models.questionnaire_state import QuestionnaireState
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
                'title': f"Question {item['id']}",
                **{k: v for k, v in item.items() if k != 'id'}
            }
            for item in items_data
        ]
    })


@pytest.mark.unit
@pytest.mark.z3
class TestStaticBuilderSSAVersioning(unittest.TestCase):
    """Tests for SSA versioning functionality."""

    def test_single_assignment_creates_version(self):
        """Test that single assignment creates version 0."""
        state = create_questionnaire([
            {'id': 'q1', 'codeBlock': 'x = 5'}
        ])
        builder = StaticBuilder(state)

        self.assertIn('x', builder.version_map)
        self.assertEqual(builder.version_map['x'], 0)
        self.assertIn('x_0', builder.z3_vars)

    def test_reassignment_increments_version(self):
        """Test that reassignment increments version."""
        state = create_questionnaire([
            {'id': 'q1', 'codeBlock': 'x = 5\nx = 10'}
        ])
        builder = StaticBuilder(state)

        self.assertEqual(builder.version_map['x'], 1)
        self.assertIn('x_0', builder.z3_vars)
        self.assertIn('x_1', builder.z3_vars)

    def test_multiple_variables_versioned_independently(self):
        """Test that different variables have independent versioning."""
        state = create_questionnaire([
            {'id': 'q1', 'codeBlock': 'x = 5\ny = 10\nx = 15'}
        ])
        builder = StaticBuilder(state)

        self.assertEqual(builder.version_map['x'], 1)  # Two assignments
        self.assertEqual(builder.version_map['y'], 0)  # One assignment

    def test_version_history_tracked(self):
        """Test that version history includes context."""
        state = create_questionnaire([
            {'id': 'q1', 'codeBlock': 'x = 5'},
            {'id': 'q2', 'codeBlock': 'x = 10'}
        ])
        builder = StaticBuilder(state)

        self.assertIn('x', builder.version_history)
        history = builder.version_history['x']
        # Should have two entries: one from q1, one from q2
        self.assertEqual(len(history), 2)
        self.assertEqual(history[0], (0, 'q1'))
        self.assertEqual(history[1], (1, 'q2'))

    def test_init_code_creates_versions(self):
        """Test that initialization code creates SSA versions."""
        state = create_questionnaire([
            {'id': 'q1'}
        ], code_init='score = 0')
        builder = StaticBuilder(state)

        self.assertIn('score', builder.version_map)
        self.assertEqual(builder.version_map['score'], 0)
        # Init versions are tracked with __init__ context
        self.assertEqual(builder.version_history['score'][0], (0, '__init__'))


@pytest.mark.unit
@pytest.mark.z3
class TestStaticBuilderConstraintGeneration(unittest.TestCase):
    """Tests for Z3 constraint generation."""

    def test_precondition_generates_constraint(self):
        """Test that preconditions generate Z3 constraints."""
        state = create_questionnaire([
            {'id': 'q1'},
            {'id': 'q2', 'precondition': [{'predicate': 'q1.outcome == 1'}]}
        ])
        builder = StaticBuilder(state)

        # Should have constraints for precondition
        self.assertGreater(len(builder.constraints), 0)

    def test_postcondition_generates_constraint(self):
        """Test that postconditions generate Z3 constraints."""
        state = create_questionnaire([
            {'id': 'q1', 'postcondition': [{'predicate': 'q1.outcome > 0'}]}
        ])
        builder = StaticBuilder(state)

        # Should have constraints for postcondition
        self.assertGreater(len(builder.constraints), 0)

    def test_code_block_generates_constraint(self):
        """Test that code block assignments generate constraints."""
        state = create_questionnaire([
            {'id': 'q1', 'codeBlock': 'x = 5'}
        ])
        builder = StaticBuilder(state)

        # Should have constraint: x_0 == 5 (conditional on item being visited)
        self.assertGreater(len(builder.constraints), 0)

    def test_init_code_generates_unconditional_constraint(self):
        """Test that init code generates unconditional constraints."""
        state = create_questionnaire([
            {'id': 'q1'}
        ], code_init='x = 10')
        builder = StaticBuilder(state)

        # Verify constraint is satisfiable and x_0 == 10
        solver = Solver()
        solver.add(builder.constraints)
        self.assertEqual(solver.check(), sat)

        model = solver.model()
        x_0 = builder.z3_vars.get('x_0')
        if x_0 is not None:
            self.assertEqual(model.eval(x_0).as_long(), 10)

    def test_arithmetic_expression_constraint(self):
        """Test arithmetic expression generates correct constraint."""
        state = create_questionnaire([
            {'id': 'q1'}
        ], code_init='x = 5 + 3')
        builder = StaticBuilder(state)

        solver = Solver()
        solver.add(builder.constraints)
        self.assertEqual(solver.check(), sat)

        model = solver.model()
        x_0 = builder.z3_vars.get('x_0')
        if x_0 is not None:
            self.assertEqual(model.eval(x_0).as_long(), 8)


@pytest.mark.unit
@pytest.mark.z3
class TestStaticBuilderDependencyDiscovery(unittest.TestCase):
    """Tests for item dependency discovery."""

    def test_precondition_creates_dependency(self):
        """Test that precondition referencing item creates dependency."""
        state = create_questionnaire([
            {'id': 'q1'},
            {'id': 'q2', 'precondition': [{'predicate': 'q1.outcome == 1'}]}
        ])
        builder = StaticBuilder(state)

        deps = builder.get_item_dependencies()
        self.assertIn('q1', deps.get('q2', set()))

    def test_independent_items_no_dependencies(self):
        """Test that items without preconditions have no dependencies."""
        state = create_questionnaire([
            {'id': 'q1'},
            {'id': 'q2'},
            {'id': 'q3'}
        ])
        builder = StaticBuilder(state)

        deps = builder.get_item_dependencies()
        self.assertEqual(len(deps.get('q1', set())), 0)
        self.assertEqual(len(deps.get('q2', set())), 0)
        self.assertEqual(len(deps.get('q3', set())), 0)

    def test_multiple_dependencies(self):
        """Test item with multiple dependencies."""
        state = create_questionnaire([
            {'id': 'q1'},
            {'id': 'q2'},
            {'id': 'q3', 'precondition': [{'predicate': 'q1.outcome == 1 and q2.outcome == 2'}]}
        ])
        builder = StaticBuilder(state)

        deps = builder.get_item_dependencies()
        q3_deps = deps.get('q3', set())
        self.assertIn('q1', q3_deps)
        self.assertIn('q2', q3_deps)

    def test_dependency_from_multiple_preconditions(self):
        """Test dependencies from multiple precondition entries."""
        state = create_questionnaire([
            {'id': 'q1'},
            {'id': 'q2'},
            {'id': 'q3', 'precondition': [
                {'predicate': 'q1.outcome == 1'},
                {'predicate': 'q2.outcome == 2'}
            ]}
        ])
        builder = StaticBuilder(state)

        deps = builder.get_item_dependencies()
        q3_deps = deps.get('q3', set())
        self.assertIn('q1', q3_deps)
        self.assertIn('q2', q3_deps)


@pytest.mark.unit
@pytest.mark.z3
class TestStaticBuilderItemClassifierCompatibility(unittest.TestCase):
    """Tests for ItemClassifier compatibility interface."""

    def test_item_details_populated(self):
        """Test that item_details is populated for all items."""
        state = create_questionnaire([
            {'id': 'q1', 'precondition': [{'predicate': 'True'}]},
            {'id': 'q2', 'postcondition': [{'predicate': 'q2.outcome > 0'}]},
            {'id': 'q3', 'codeBlock': 'x = 5'}
        ])
        builder = StaticBuilder(state)

        self.assertIn('q1', builder.item_details)
        self.assertIn('q2', builder.item_details)
        self.assertIn('q3', builder.item_details)

        # Check structure
        self.assertIn('preconditions', builder.item_details['q1'])
        self.assertIn('postconditions', builder.item_details['q2'])
        self.assertIn('code_block', builder.item_details['q3'])

    def test_item_order_preserves_qml_order(self):
        """Test that item_order preserves QML file order."""
        state = create_questionnaire([
            {'id': 'q1'},
            {'id': 'q2'},
            {'id': 'q3'}
        ])
        builder = StaticBuilder(state)

        self.assertEqual(builder.item_order, ['q1', 'q2', 'q3'])

    def test_compile_conditions_method(self):
        """Test compile_conditions returns Z3 boolean expression."""
        state = create_questionnaire([
            {'id': 'q1'},
            {'id': 'q2'}
        ])
        builder = StaticBuilder(state)

        conditions = [{'predicate': 'q1.outcome == 1'}]
        compiled = builder.compile_conditions('q2', conditions)

        self.assertIsNotNone(compiled)
        # Should be a Z3 boolean expression
        self.assertTrue(is_bool(compiled) or isinstance(compiled, BoolRef))

    def test_compile_conditions_empty_returns_true(self):
        """Test compile_conditions with empty list returns True."""
        state = create_questionnaire([{'id': 'q1'}])
        builder = StaticBuilder(state)

        compiled = builder.compile_conditions('q1', [])

        self.assertIsNotNone(compiled)
        # Should be BoolVal(True)
        self.assertTrue(is_true(compiled))

    def test_get_domain_base_method(self):
        """Test get_domain_base returns domain constraints only."""
        state = create_questionnaire([
            {
                'id': 'q1',
                'input': {'control': 'Editbox', 'min': 1, 'max': 100},
                'postcondition': [{'predicate': 'q1.outcome > 50'}]
            }
        ])
        builder = StaticBuilder(state)

        base = builder.get_domain_base()

        self.assertIsNotNone(base)
        # Should be a Z3 expression containing domain constraints
        self.assertTrue(is_expr(base))


@pytest.mark.unit
@pytest.mark.z3
class TestStaticBuilderASTToZ3(unittest.TestCase):
    """Tests for AST to Z3 conversion."""

    def test_integer_constant_conversion(self):
        """Test integer constant conversion to Z3."""
        state = create_questionnaire([{'id': 'q1'}], code_init='x = 42')
        builder = StaticBuilder(state)

        solver = Solver()
        solver.add(builder.constraints)
        self.assertEqual(solver.check(), sat)

        model = solver.model()
        self.assertEqual(model.eval(builder.z3_vars['x_0']).as_long(), 42)

    def test_boolean_constant_conversion(self):
        """Test boolean constant conversion to Z3 (as integer)."""
        state = create_questionnaire([{'id': 'q1'}], code_init='x = True')
        builder = StaticBuilder(state)

        solver = Solver()
        solver.add(builder.constraints)
        self.assertEqual(solver.check(), sat)

        model = solver.model()
        # Boolean True is converted to IntVal(1)
        self.assertEqual(model.eval(builder.z3_vars['x_0']).as_long(), 1)

    def test_comparison_operators(self):
        """Test comparison operators in preconditions."""
        state = create_questionnaire([
            {'id': 'q1'},
            {'id': 'q2', 'precondition': [{'predicate': 'q1.outcome > 5'}]}
        ])
        builder = StaticBuilder(state)

        # Constraints should be generated without error
        self.assertGreater(len(builder.constraints), 0)

    def test_boolean_operators(self):
        """Test boolean operators (and, or, not) in preconditions."""
        state = create_questionnaire([
            {'id': 'q1'},
            {'id': 'q2'},
            {'id': 'q3', 'precondition': [{'predicate': 'q1.outcome == 1 and q2.outcome == 2'}]},
            {'id': 'q4', 'precondition': [{'predicate': 'q1.outcome == 1 or q2.outcome == 2'}]},
            {'id': 'q5', 'precondition': [{'predicate': 'not q1.outcome == 0'}]}
        ])
        builder = StaticBuilder(state)

        # All constraints should be generated
        self.assertGreater(len(builder.constraints), 0)

    def test_item_outcome_attribute_access(self):
        """Test item.outcome attribute access conversion."""
        state = create_questionnaire([
            {'id': 'q1'},
            {'id': 'q2', 'precondition': [{'predicate': 'q1.outcome == 1'}]}
        ])
        builder = StaticBuilder(state)

        # item_vars should contain q1
        self.assertIn('q1', builder.item_vars)
        # q2 should depend on q1
        self.assertIn('q1', builder.get_item_dependencies().get('q2', set()))


@pytest.mark.unit
@pytest.mark.z3
class TestStaticBuilderHelperMethods(unittest.TestCase):
    """Tests for helper methods."""

    def test_get_constraints(self):
        """Test get_constraints returns list."""
        state = create_questionnaire([{'id': 'q1'}])
        builder = StaticBuilder(state)

        constraints = builder.get_constraints()
        self.assertIsInstance(constraints, list)

    def test_get_all_z3_vars(self):
        """Test get_all_z3_vars includes both SSA and item vars."""
        state = create_questionnaire([
            {'id': 'q1', 'codeBlock': 'x = 5'}
        ])
        builder = StaticBuilder(state)

        all_vars = builder.get_all_z3_vars()

        # Should include item variable
        self.assertIn('item_q1', str(all_vars))
        # Should include SSA variable
        self.assertIn('x_0', all_vars)

    def test_debug_dump_returns_string(self):
        """Test debug_dump returns informative string."""
        state = create_questionnaire([
            {'id': 'q1', 'codeBlock': 'x = 5'},
            {'id': 'q2', 'precondition': [{'predicate': 'q1.outcome == 1'}]}
        ])
        builder = StaticBuilder(state)

        dump = builder.debug_dump()

        self.assertIsInstance(dump, str)
        self.assertIn('SSA', dump)
        self.assertIn('q1', dump)
        self.assertIn('q2', dump)


if __name__ == '__main__':
    unittest.main()
