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

### Regression Tests (8 tests)
- AugAssign (+=) dependency tracking
- Outcome assignment (item.outcome = expr) dependency tracking
- NotIn operator classification
- Non-integer min/max defensive handling
- If-condition dependency tracking
- Multiple augmented assignments to same variable
- Outcome augmented assignment (item.outcome += expr)
- Complex code block with if/elif/else and AugAssign

Total: 31 tests covering StaticBuilder functionality.
"""

import unittest
import pytest
from z3 import *
from askalot_qml.models.qml_state import QMLState
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
        # CodeBlock constraints are now stored in codeblock_constraints
        self.assertGreater(len(builder.codeblock_constraints), 0)

    def test_init_code_generates_unconditional_constraint(self):
        """Test that init code generates unconditional constraints."""
        state = create_questionnaire([
            {'id': 'q1'}
        ], code_init='x = 10')
        builder = StaticBuilder(state)

        # Verify constraint is satisfiable and x_0 == 10
        # CodeBlock constraints are now stored in codeblock_constraints
        solver = Solver(ctx=builder.ctx)
        solver.add(builder.codeblock_constraints)
        self.assertEqual(solver.check(), sat)

        model = solver.model()
        x_0 = builder.z3_vars.get('x_0')
        if x_0 is not None:
            self.assertEqual(model.eval(x_0, model_completion=True).as_long(), 10)

    def test_arithmetic_expression_constraint(self):
        """Test arithmetic expression generates correct constraint."""
        state = create_questionnaire([
            {'id': 'q1'}
        ], code_init='x = 5 + 3')
        builder = StaticBuilder(state)

        # CodeBlock constraints are now stored in codeblock_constraints
        solver = Solver(ctx=builder.ctx)
        solver.add(builder.codeblock_constraints)
        self.assertEqual(solver.check(), sat)

        model = solver.model()
        x_0 = builder.z3_vars.get('x_0')
        if x_0 is not None:
            self.assertEqual(model.eval(x_0, model_completion=True).as_long(), 8)


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

    def test_domain_constraints_from_labels_schema_format(self):
        """Test domain constraints from labels (schema format: Radio, labels dict)."""
        state = create_questionnaire([
            {
                'id': 'q1',
                'input': {'control': 'Radio', 'labels': {1: 'Yes', 2: 'No'}}
            }
        ])
        builder = StaticBuilder(state)

        self.assertGreater(len(builder.domain_constraints), 0)


@pytest.mark.unit
@pytest.mark.z3
class TestStaticBuilderASTToZ3(unittest.TestCase):
    """Tests for AST to Z3 conversion."""

    def test_integer_constant_conversion(self):
        """Test integer constant conversion to Z3."""
        state = create_questionnaire([{'id': 'q1'}], code_init='x = 42')
        builder = StaticBuilder(state)

        # CodeBlock constraints are now stored in codeblock_constraints
        solver = Solver(ctx=builder.ctx)
        solver.add(builder.codeblock_constraints)
        self.assertEqual(solver.check(), sat)

        model = solver.model()
        self.assertEqual(model.eval(builder.z3_vars['x_0'], model_completion=True).as_long(), 42)

    def test_boolean_constant_conversion(self):
        """Test boolean constant conversion to Z3 (as integer)."""
        state = create_questionnaire([{'id': 'q1'}], code_init='x = True')
        builder = StaticBuilder(state)

        # CodeBlock constraints are now stored in codeblock_constraints
        solver = Solver(ctx=builder.ctx)
        solver.add(builder.codeblock_constraints)
        self.assertEqual(solver.check(), sat)

        model = solver.model()
        # Boolean True is converted to IntVal(1)
        self.assertEqual(model.eval(builder.z3_vars['x_0'], model_completion=True).as_long(), 1)

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


@pytest.mark.unit
@pytest.mark.z3
@pytest.mark.dependency_graph
class TestStaticBuilderDependencyGraph(unittest.TestCase):
    """Tests for comprehensive dependency graph functionality.

    The dependency graph tracks all dependency types:
    - Item → Item (via preconditions)
    - Variable → Item (via codeBlock assignments)
    - Item → Variable (via preconditions/postconditions referencing variables)
    - Variable → Variable (via codeBlock assignments)
    """

    # Variable → Item Dependencies

    def test_variable_depends_on_item_outcome(self):
        """Test that score = q1.outcome creates var:score → q1."""
        state = create_questionnaire([
            {'id': 'q1', 'codeBlock': 'score = q1.outcome'}
        ])
        builder = StaticBuilder(state)
        graph = builder.get_dependency_graph()

        self.assertIn('var:score', graph)
        self.assertIn('q1', graph['var:score'])

    def test_variable_depends_on_multiple_items(self):
        """Test that total = q1.outcome + q2.outcome creates var:total → {q1, q2}."""
        state = create_questionnaire([
            {'id': 'q1'},
            {'id': 'q2', 'codeBlock': 'total = q1.outcome + q2.outcome'}
        ])
        builder = StaticBuilder(state)
        graph = builder.get_dependency_graph()

        self.assertIn('var:total', graph)
        self.assertIn('q1', graph['var:total'])
        self.assertIn('q2', graph['var:total'])

    def test_variable_depends_on_defining_item(self):
        """Test that variable assignment in q1's codeBlock makes var depend on q1."""
        state = create_questionnaire([
            {'id': 'q1', 'codeBlock': 'x = 5'}
        ])
        builder = StaticBuilder(state)
        graph = builder.get_dependency_graph()

        self.assertIn('var:x', graph)
        # Variable defined in q1's codeBlock depends on q1
        self.assertIn('q1', graph['var:x'])

    # Item → Item Dependencies (via precondition)

    def test_item_depends_on_item_via_precondition(self):
        """Test that precondition: q1.outcome > 5 creates q2 → q1."""
        state = create_questionnaire([
            {'id': 'q1'},
            {'id': 'q2', 'precondition': [{'predicate': 'q1.outcome > 5'}]}
        ])
        builder = StaticBuilder(state)
        graph = builder.get_dependency_graph()

        self.assertIn('q1', graph['q2'])

    # Item → Item Dependencies (via postcondition)

    def test_item_depends_on_item_via_postcondition(self):
        """Test that postcondition: q1.outcome + q2.outcome > 10 creates q2 → q1."""
        state = create_questionnaire([
            {'id': 'q1'},
            {'id': 'q2', 'postcondition': [{'predicate': 'q1.outcome + q2.outcome > 10'}]}
        ])
        builder = StaticBuilder(state)
        graph = builder.get_dependency_graph()

        self.assertIn('q1', graph['q2'])

    # Item → Variable Dependencies (via precondition)

    def test_item_depends_on_variable_in_precondition(self):
        """Test that precondition: score > 5 creates q2 → var:score."""
        state = create_questionnaire([
            {'id': 'q1', 'codeBlock': 'score = q1.outcome'},
            {'id': 'q2', 'precondition': [{'predicate': 'score > 5'}]}
        ])
        builder = StaticBuilder(state)
        graph = builder.get_dependency_graph()

        self.assertIn('var:score', graph['q2'])

    # Item → Variable Dependencies (via postcondition)

    def test_item_depends_on_variable_in_postcondition(self):
        """Test that postcondition: var1 > 10 creates q2 → var:var1."""
        state = create_questionnaire([
            {'id': 'q1', 'codeBlock': 'var1 = q1.outcome'},
            {'id': 'q2', 'postcondition': [{'predicate': 'var1 > 10'}]}
        ])
        builder = StaticBuilder(state)
        graph = builder.get_dependency_graph()

        self.assertIn('var:var1', graph['q2'])

    # Variable → Variable Dependencies

    def test_variable_depends_on_variable(self):
        """Test that total = score + bonus creates var:total → {var:score, var:bonus}."""
        state = create_questionnaire([
            {'id': 'q1', 'codeBlock': 'score = 10'},
            {'id': 'q2', 'codeBlock': 'bonus = 5'},
            {'id': 'q3', 'codeBlock': 'total = score + bonus'}
        ])
        builder = StaticBuilder(state)
        graph = builder.get_dependency_graph()

        self.assertIn('var:total', graph)
        self.assertIn('var:score', graph['var:total'])
        self.assertIn('var:bonus', graph['var:total'])


@pytest.mark.unit
@pytest.mark.z3
@pytest.mark.dependency_graph
class TestStaticBuilderTransitiveResolution(unittest.TestCase):
    """Tests for transitive dependency resolution through variables."""

    def test_transitive_simple_chain(self):
        """Test q2 → var:score → q1 resolves to q2 → q1."""
        state = create_questionnaire([
            {'id': 'q1', 'codeBlock': 'score = q1.outcome'},
            {'id': 'q2', 'precondition': [{'predicate': 'score > 5'}]}
        ])
        builder = StaticBuilder(state)
        deps = builder.get_item_dependencies()

        self.assertIn('q1', deps['q2'])

    def test_transitive_scoring_pattern(self):
        """Test q_result depends on all items that modify risk_level."""
        state = create_questionnaire([
            {'id': 'q_age', 'codeBlock': 'risk_level = risk_level + 1'},
            {'id': 'q_smoker', 'codeBlock': 'risk_level = risk_level + 2'},
            {'id': 'q_exercise', 'codeBlock': 'risk_level = risk_level - 1'},
            {'id': 'q_result', 'precondition': [{'predicate': 'risk_level >= 0'}]}
        ], code_init='risk_level = 0')
        builder = StaticBuilder(state)
        deps = builder.get_item_dependencies()

        # q_result should depend on all items that modify risk_level
        self.assertIn('q_age', deps['q_result'])
        self.assertIn('q_smoker', deps['q_result'])
        self.assertIn('q_exercise', deps['q_result'])

    def test_transitive_multi_hop(self):
        """Test q3 → var:total → var:score → q1 resolves to q3 → q1."""
        state = create_questionnaire([
            {'id': 'q1', 'codeBlock': 'score = q1.outcome'},
            {'id': 'q2', 'codeBlock': 'total = score + 10'},
            {'id': 'q3', 'precondition': [{'predicate': 'total > 20'}]}
        ])
        builder = StaticBuilder(state)
        deps = builder.get_item_dependencies()

        # q3 depends on q1 through the chain: q3 → var:total → var:score → q1
        self.assertIn('q1', deps['q3'])
        # q3 also depends on q2 because var:total depends on q2 (the defining item)
        self.assertIn('q2', deps['q3'])

    def test_transitive_postcondition_chain(self):
        """Test postcondition-based transitive dependencies."""
        state = create_questionnaire([
            {'id': 'q1', 'codeBlock': 'total = q1.outcome'},
            {'id': 'q2', 'postcondition': [{'predicate': 'total > 0'}]}
        ])
        builder = StaticBuilder(state)
        deps = builder.get_item_dependencies()

        # q2 depends on q1 through var:total
        self.assertIn('q1', deps['q2'])


@pytest.mark.unit
@pytest.mark.z3
@pytest.mark.dependency_graph
class TestStaticBuilderDependencyGraphEdgeCases(unittest.TestCase):
    """Tests for edge cases in dependency graph handling."""

    def test_codeInit_variable_no_item_dependency(self):
        """Test that variables defined in codeInit have no item dependencies."""
        state = create_questionnaire([{'id': 'q1'}], code_init='score = 0')
        builder = StaticBuilder(state)
        graph = builder.get_dependency_graph()

        self.assertIn('var:score', graph)
        # Variable defined in __init__ should not depend on any item
        item_deps = [d for d in graph['var:score'] if not d.startswith('var:')]
        self.assertEqual(len(item_deps), 0)

    def test_undefined_variable_not_tracked(self):
        """Test that undefined variable reference doesn't crash or create edge."""
        state = create_questionnaire([
            {'id': 'q1', 'precondition': [{'predicate': 'undefined_var > 5'}]}
        ])
        # Should not raise
        builder = StaticBuilder(state)

        # undefined_var not in version_map, so not added to graph
        self.assertIn('q1', builder.dependency_graph)
        self.assertNotIn('var:undefined_var', builder.dependency_graph.get('q1', set()))

    def test_get_item_dependencies_returns_items_only(self):
        """Test that get_item_dependencies() returns item IDs, not var: nodes."""
        state = create_questionnaire([
            {'id': 'q1', 'codeBlock': 'score = q1.outcome'},
            {'id': 'q2', 'precondition': [{'predicate': 'score > 5'}]}
        ])
        builder = StaticBuilder(state)
        deps = builder.get_item_dependencies()

        # All dependencies should be item IDs, not var: nodes
        for item_id, item_deps in deps.items():
            for dep in item_deps:
                self.assertFalse(dep.startswith('var:'),
                    f"Found var: node in item dependencies: {dep}")

    def test_self_referencing_variable_update(self):
        """Test variable self-reference like x = x + 1."""
        state = create_questionnaire([
            {'id': 'q1', 'codeBlock': 'x = x + 1'}
        ], code_init='x = 0')
        builder = StaticBuilder(state)
        graph = builder.get_dependency_graph()

        # var:x should depend on itself (previous version) and on q1
        self.assertIn('var:x', graph)
        self.assertIn('q1', graph['var:x'])

    def test_multiple_items_modify_same_variable(self):
        """Test that multiple items modifying same variable creates correct deps."""
        state = create_questionnaire([
            {'id': 'q1', 'codeBlock': 'counter = counter + 1'},
            {'id': 'q2', 'codeBlock': 'counter = counter + 2'},
            {'id': 'q3', 'precondition': [{'predicate': 'counter > 3'}]}
        ], code_init='counter = 0')
        builder = StaticBuilder(state)
        deps = builder.get_item_dependencies()

        # q3 should depend on both q1 and q2 transitively through var:counter
        self.assertIn('q1', deps['q3'])
        self.assertIn('q2', deps['q3'])


@pytest.mark.unit
@pytest.mark.z3
class TestStaticBuilderRegressions(unittest.TestCase):
    """Regression tests for bugs found during Z3 compilation audit.

    Covers:
    - AugAssign (+=, -=) dependency tracking (was silently skipped)
    - Outcome assignment (item.outcome = expr) dependency tracking (was silently skipped)
    - NotIn operator in preconditions (was silently treated as True)
    - Non-integer min/max defensive handling (was crashing with Z3Exception)
    - If-condition dependency tracking for nested assignments
    - Multiple augmented assignments to the same variable
    - Outcome augmented assignment (item.outcome += expr)
    - Complex code blocks with if/elif/else and AugAssign patterns
    """

    def test_augassign_creates_dependency(self):
        """Test that score += q1.outcome creates dependency from var:score to q1."""
        state = create_questionnaire([
            {'id': 'q1'},
            {'id': 'q2', 'codeBlock': 'score += q1.outcome'},
            {'id': 'q3', 'precondition': [{'predicate': 'score > 5'}]}
        ], code_init='score = 0')
        builder = StaticBuilder(state)

        deps = builder.get_item_dependencies()
        # q3 depends on q1 transitively through var:score
        self.assertIn('q1', deps.get('q3', set()),
                       "AugAssign dependency q3 → q1 through var:score was not tracked")

    def test_outcome_assignment_creates_dependency(self):
        """Test that q_total.outcome = q1.outcome + q2.outcome creates dependency."""
        state = create_questionnaire([
            {'id': 'q1'},
            {'id': 'q2'},
            {'id': 'q_total', 'codeBlock': 'q_total.outcome = q1.outcome + q2.outcome'}
        ])
        builder = StaticBuilder(state)

        deps = builder.get_item_dependencies()
        # q_total depends on q1 and q2
        self.assertIn('q1', deps.get('q_total', set()),
                       "Outcome assignment dependency q_total → q1 was not tracked")
        self.assertIn('q2', deps.get('q_total', set()),
                       "Outcome assignment dependency q_total → q2 was not tracked")

    def test_not_in_operator_classified_correctly(self):
        """Test that 'not in' operator produces a valid Z3 constraint (not None)."""
        state = create_questionnaire([
            {'id': 'q1', 'input': {'control': 'Editbox', 'min': 1, 'max': 10}},
            {'id': 'q2', 'precondition': [{'predicate': 'q1.outcome not in [1, 2, 3]'}]}
        ])
        builder = StaticBuilder(state)

        # The precondition should generate a constraint (not return None)
        self.assertGreater(len(builder.constraints), 0,
                           "NotIn operator failed to generate Z3 constraint")

        # Verify the constraint is satisfiable (q1.outcome in 4..10)
        solver = Solver(ctx=builder.ctx)
        solver.add(builder.get_domain_base())
        solver.add(builder.constraints)
        self.assertEqual(solver.check(), sat,
                         "NotIn constraint should be satisfiable for values outside the list")

    def test_non_integer_min_max_handled_gracefully(self):
        """Test that non-integer min/max values don't crash but are skipped."""
        state = create_questionnaire([
            {
                'id': 'q1',
                'input': {'control': 'Editbox', 'min': "abc", 'max': "xyz"}
            }
        ])
        # Should not raise
        builder = StaticBuilder(state)

        # No domain constraints should be generated for invalid min/max
        self.assertEqual(len(builder.domain_constraints), 0,
                         "Non-integer min/max should be skipped, not crash")

    def test_if_condition_dependency_tracked(self):
        """Test that assignments inside if-blocks track condition dependencies."""
        state = create_questionnaire([
            {'id': 'q1'},
            {'id': 'q2', 'codeBlock': 'if q1.outcome == 1:\n    flag = True'},
            {'id': 'q3', 'precondition': [{'predicate': 'flag'}]}
        ], code_init='flag = False')
        builder = StaticBuilder(state)

        graph = builder.get_dependency_graph()
        # var:flag should depend on q1 (from the if-condition)
        self.assertIn('q1', graph.get('var:flag', set()),
                       "If-condition dependency var:flag → q1 was not tracked")

    def test_multiple_augassign_same_variable(self):
        """Test multiple += to same variable across items."""
        state = create_questionnaire([
            {'id': 'q1', 'codeBlock': 'total += q1.outcome'},
            {'id': 'q2', 'codeBlock': 'total += q2.outcome'},
            {'id': 'q3', 'precondition': [{'predicate': 'total > 10'}]}
        ], code_init='total = 0')
        builder = StaticBuilder(state)

        deps = builder.get_item_dependencies()
        # q3 should depend on both q1 and q2 through var:total
        self.assertIn('q1', deps.get('q3', set()),
                       "Multiple AugAssign: q3 → q1 through var:total was not tracked")
        self.assertIn('q2', deps.get('q3', set()),
                       "Multiple AugAssign: q3 → q2 through var:total was not tracked")

    def test_outcome_augassign_creates_dependency(self):
        """Test that item.outcome += expr creates dependency."""
        state = create_questionnaire([
            {'id': 'q1'},
            {'id': 'q_score', 'codeBlock': 'q_score.outcome += q1.outcome'}
        ])
        builder = StaticBuilder(state)

        deps = builder.get_item_dependencies()
        # q_score should depend on q1
        self.assertIn('q1', deps.get('q_score', set()),
                       "Outcome AugAssign dependency q_score → q1 was not tracked")

    def test_complex_if_elif_else_with_augassign(self):
        """Test complex code block with if/elif/else and AugAssign patterns."""
        code = (
            "if q1.outcome == 1:\n"
            "    score += 10\n"
            "elif q1.outcome == 2:\n"
            "    score += 20\n"
            "else:\n"
            "    score += 5\n"
        )
        state = create_questionnaire([
            {'id': 'q1'},
            {'id': 'q2', 'codeBlock': code},
            {'id': 'q3', 'precondition': [{'predicate': 'score > 15'}]}
        ], code_init='score = 0')
        builder = StaticBuilder(state)

        deps = builder.get_item_dependencies()
        # q3 should depend on q1 transitively (score depends on q1 via the if-condition)
        self.assertIn('q1', deps.get('q3', set()),
                       "Complex if/elif/else: q3 → q1 through var:score was not tracked")


if __name__ == '__main__':
    unittest.main()
