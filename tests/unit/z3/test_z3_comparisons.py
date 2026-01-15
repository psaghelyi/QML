#!/usr/bin/env python3
"""Granular tests for Python to Z3 comparison conversion.

This test suite provides comprehensive coverage of comparison operations in the
PragmaticZ3Compiler, ensuring accurate translation from Python comparison
expressions to Z3 boolean constraints.

## Coverage Areas:

### Equality (==) Tests (6 tests)
- Integer equality: equal and unequal values
- Boolean equality: True==True, True==False
- Zero equality
- Negative number equality
- Reflexivity: x == x always True

### Inequality (!=) Tests (3 tests)
- Integer inequality: different and same values
- Boolean inequality
- Symmetry properties

### Less Than (<) Tests (5 tests)
- Basic less than: 5 < 10
- Equal values: 5 < 5 → False
- Negative numbers: -10 < -5
- Comparison with zero: -5 < 0
- Variable comparisons

### Less Than or Equal (<=) Tests (3 tests)
- Strictly less: 5 <= 10
- Equal values: 5 <= 5
- Greater values: 10 <= 5 → False

### Greater Than (>) Tests (4 tests)
- Basic greater than: 10 > 5
- Equal values: 5 > 5 → False
- Negative numbers: -5 > -10
- Variable comparisons

### Greater Than or Equal (>=) Tests (3 tests)
- Strictly greater: 10 >= 5
- Equal values: 5 >= 5
- Less values: 5 >= 10 → False

### Mixed Type Comparisons (2 tests)
- Boolean to integer comparison (True ≡ 1, False ≡ 0)
- Explicit casting in comparisons

### Complex Comparison Scenarios (11 tests)
- Comparisons in boolean context: (a < b) and (c > d)
- Comparison with OR operations
- Negated comparisons: not (a > b)
- Multiple independent comparisons
- Comparisons with arithmetic: (a + b) > 7
- Arithmetic on both sides: (a + b) >= (c * d)
- Comparisons after variable reassignment
- Transitivity verification
- Symmetry of equality
- Note: Chained comparisons (1 < x < 10) not yet supported

Total: 37 tests covering all comparison scenarios in QML preconditions.
"""

import unittest
import pytest
import ast
from z3 import *

from askalot_qml.z3.pragmatic_compiler import PragmaticZ3Compiler


def compile_and_solve(code: str, predefined=None):
    """Helper to compile code and return solver with constraints."""
    compiler = PragmaticZ3Compiler(predefined or {}, 'test')
    tree = ast.parse(code)
    compiler.visit(tree)

    solver = Solver()
    solver.add(compiler.constraints)

    return solver, compiler


@pytest.mark.unit
@pytest.mark.z3
class TestPythonToZ3Comparisons(unittest.TestCase):
    """Granular tests for comparison operations in Python to Z3 conversion."""

    # ========== Equality Tests ==========

    def test_equal_integers_true(self):
        """Test equality of equal integers."""
        solver, compiler = compile_and_solve("""
a = 5
b = 5
result = a == b
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertTrue(is_true(model.eval(compiler.env['result'])))

    def test_equal_integers_false(self):
        """Test equality of different integers."""
        solver, compiler = compile_and_solve("""
a = 5
b = 10
result = a == b
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertTrue(is_false(model.eval(compiler.env['result'])))

    def test_equal_booleans_true(self):
        """Test equality of equal booleans."""
        solver, compiler = compile_and_solve("""
a = True
b = True
result = a == b
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertTrue(is_true(model.eval(compiler.env['result'])))

    def test_equal_booleans_false(self):
        """Test equality of different booleans."""
        solver, compiler = compile_and_solve("""
a = True
b = False
result = a == b
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertTrue(is_false(model.eval(compiler.env['result'])))

    def test_equal_zero(self):
        """Test equality with zero."""
        solver, compiler = compile_and_solve("""
a = 0
b = 0
result = a == b
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertTrue(is_true(model.eval(compiler.env['result'])))

    def test_equal_negative(self):
        """Test equality with negative numbers."""
        solver, compiler = compile_and_solve("""
a = -5
b = -5
result = a == b
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertTrue(is_true(model.eval(compiler.env['result'])))

    # ========== Inequality Tests ==========

    def test_not_equal_integers_true(self):
        """Test inequality of different integers."""
        solver, compiler = compile_and_solve("""
a = 5
b = 10
result = a != b
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertTrue(is_true(model.eval(compiler.env['result'])))

    def test_not_equal_integers_false(self):
        """Test inequality of equal integers."""
        solver, compiler = compile_and_solve("""
a = 5
b = 5
result = a != b
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertTrue(is_false(model.eval(compiler.env['result'])))

    def test_not_equal_booleans(self):
        """Test inequality of different booleans."""
        solver, compiler = compile_and_solve("""
a = True
b = False
result = a != b
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertTrue(is_true(model.eval(compiler.env['result'])))

    # ========== Less Than Tests ==========

    def test_less_than_true(self):
        """Test less than with true condition."""
        solver, compiler = compile_and_solve("""
a = 5
b = 10
result = a < b
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertTrue(is_true(model.eval(compiler.env['result'])))

    def test_less_than_false(self):
        """Test less than with false condition."""
        solver, compiler = compile_and_solve("""
a = 10
b = 5
result = a < b
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertTrue(is_false(model.eval(compiler.env['result'])))

    def test_less_than_equal(self):
        """Test less than with equal values."""
        solver, compiler = compile_and_solve("""
a = 5
b = 5
result = a < b
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertTrue(is_false(model.eval(compiler.env['result'])))

    def test_less_than_negative(self):
        """Test less than with negative numbers."""
        solver, compiler = compile_and_solve("""
a = -10
b = -5
result = a < b
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertTrue(is_true(model.eval(compiler.env['result'])))

    def test_less_than_zero(self):
        """Test less than with zero."""
        solver, compiler = compile_and_solve("""
a = -5
b = 0
result = a < b
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertTrue(is_true(model.eval(compiler.env['result'])))

    # ========== Less Than or Equal Tests ==========

    def test_less_equal_true_less(self):
        """Test <= with less than condition."""
        solver, compiler = compile_and_solve("""
a = 5
b = 10
result = a <= b
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertTrue(is_true(model.eval(compiler.env['result'])))

    def test_less_equal_true_equal(self):
        """Test <= with equal values."""
        solver, compiler = compile_and_solve("""
a = 5
b = 5
result = a <= b
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertTrue(is_true(model.eval(compiler.env['result'])))

    def test_less_equal_false(self):
        """Test <= with greater than condition."""
        solver, compiler = compile_and_solve("""
a = 10
b = 5
result = a <= b
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertTrue(is_false(model.eval(compiler.env['result'])))

    # ========== Greater Than Tests ==========

    def test_greater_than_true(self):
        """Test greater than with true condition."""
        solver, compiler = compile_and_solve("""
a = 10
b = 5
result = a > b
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertTrue(is_true(model.eval(compiler.env['result'])))

    def test_greater_than_false(self):
        """Test greater than with false condition."""
        solver, compiler = compile_and_solve("""
a = 5
b = 10
result = a > b
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertTrue(is_false(model.eval(compiler.env['result'])))

    def test_greater_than_equal(self):
        """Test greater than with equal values."""
        solver, compiler = compile_and_solve("""
a = 5
b = 5
result = a > b
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertTrue(is_false(model.eval(compiler.env['result'])))

    def test_greater_than_negative(self):
        """Test greater than with negative numbers."""
        solver, compiler = compile_and_solve("""
a = -5
b = -10
result = a > b
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertTrue(is_true(model.eval(compiler.env['result'])))

    # ========== Greater Than or Equal Tests ==========

    def test_greater_equal_true_greater(self):
        """Test >= with greater than condition."""
        solver, compiler = compile_and_solve("""
a = 10
b = 5
result = a >= b
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertTrue(is_true(model.eval(compiler.env['result'])))

    def test_greater_equal_true_equal(self):
        """Test >= with equal values."""
        solver, compiler = compile_and_solve("""
a = 5
b = 5
result = a >= b
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertTrue(is_true(model.eval(compiler.env['result'])))

    def test_greater_equal_false(self):
        """Test >= with less than condition."""
        solver, compiler = compile_and_solve("""
a = 5
b = 10
result = a >= b
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertTrue(is_false(model.eval(compiler.env['result'])))

    # ========== Mixed Type Comparisons ==========

    def test_compare_boolean_integer_equality(self):
        """Test equality between boolean and integer."""
        solver, compiler = compile_and_solve("""
a = True
b = 1
result = int(a) == b
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertTrue(is_true(model.eval(compiler.env['result'])))

    def test_compare_false_zero(self):
        """Test comparison of False with 0."""
        solver, compiler = compile_and_solve("""
a = False
b = 0
result = int(a) == b
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertTrue(is_true(model.eval(compiler.env['result'])))

    # ========== Complex Comparisons ==========

    def test_comparison_in_boolean_context(self):
        """Test comparison result used in boolean operation."""
        solver, compiler = compile_and_solve("""
a = 5
b = 10
c = 7
result = (a < b) and (c > a)
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertTrue(is_true(model.eval(compiler.env['result'])))  # (5<10) and (7>5) = True

    def test_comparison_or_operation(self):
        """Test comparison results with OR."""
        solver, compiler = compile_and_solve("""
a = 5
b = 10
c = 3
result = (a > b) or (c < a)
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertTrue(is_true(model.eval(compiler.env['result'])))  # (5>10) or (3<5) = False or True = True

    def test_negated_comparison(self):
        """Test NOT with comparison."""
        solver, compiler = compile_and_solve("""
a = 5
b = 10
result = not (a > b)
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertTrue(is_true(model.eval(compiler.env['result'])))  # not (5>10) = not False = True

    def test_multiple_comparisons(self):
        """Test multiple independent comparisons."""
        solver, compiler = compile_and_solve("""
a = 5
b = 10
c = 15
result1 = a < b
result2 = b < c
result3 = a < c
final = result1 and result2 and result3
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertTrue(is_true(model.eval(compiler.env['final'])))

    # ========== Edge Cases ==========

    def test_comparison_with_arithmetic(self):
        """Test comparison with arithmetic expression."""
        solver, compiler = compile_and_solve("""
a = 5
b = 3
result = (a + b) > 7
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertTrue(is_true(model.eval(compiler.env['result'])))  # (5+3) > 7 = 8 > 7 = True

    def test_comparison_both_sides_arithmetic(self):
        """Test comparison with arithmetic on both sides."""
        solver, compiler = compile_and_solve("""
a = 5
b = 3
c = 2
d = 4
result = (a + b) >= (c * d)
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertTrue(is_true(model.eval(compiler.env['result'])))  # (5+3) >= (2*4) = 8 >= 8 = True

    def test_comparison_with_variable_reassignment(self):
        """Test comparison after variable reassignment."""
        solver, compiler = compile_and_solve("""
a = 5
b = 10
a = a + 3
result = a < b
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertTrue(is_true(model.eval(compiler.env['result'])))  # 8 < 10 = True

    def test_comparison_chain_not_supported(self):
        """Document that chained comparisons are not yet supported."""
        # Note: This would fail if we tried to compile "1 < x < 10"
        # Instead we must use: (1 < x) and (x < 10)
        solver, compiler = compile_and_solve("""
x = 5
result = (1 < x) and (x < 10)
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertTrue(is_true(model.eval(compiler.env['result'])))

    def test_comparison_transitivity(self):
        """Test transitivity of comparisons."""
        solver, compiler = compile_and_solve("""
a = 5
b = 10
c = 15
result1 = a < b
result2 = b < c
# If a < b and b < c, then a < c
result3 = a < c
all_true = result1 and result2 and result3
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertTrue(is_true(model.eval(compiler.env['all_true'])))

    def test_comparison_reflexivity(self):
        """Test reflexivity of equality."""
        solver, compiler = compile_and_solve("""
a = 42
result = a == a
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertTrue(is_true(model.eval(compiler.env['result'])))

    def test_comparison_symmetry(self):
        """Test symmetry of equality."""
        solver, compiler = compile_and_solve("""
a = 5
b = 5
result1 = a == b
result2 = b == a
both = result1 and result2
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertTrue(is_true(model.eval(compiler.env['both'])))


if __name__ == '__main__':
    unittest.main()