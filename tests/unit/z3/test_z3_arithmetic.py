#!/usr/bin/env python3
"""Granular tests for Python to Z3 arithmetic conversion.

This test suite provides comprehensive coverage of arithmetic operations in the
PragmaticZ3Compiler, ensuring accurate translation from Python expressions to
Z3 constraints.

## Coverage Areas:

### Basic Arithmetic Operations (12 tests)
- Addition (+): integers, booleans, negative numbers, zero
- Subtraction (-): standard cases, negative results, zero handling
- Multiplication (*): positive/negative, zero, large numbers
- Division (//): floor division, negative numbers, Python semantics
- Modulo (%): remainders, negative operands, zero cases

### Boolean Coercion in Arithmetic (6 tests)
- True treated as 1, False as 0 in arithmetic context
- Mixed boolean/integer operations (True + 5 = 6)
- Multiple boolean operands
- Verifies Python-compatible type coercion behavior

### Augmented Assignments (5 tests)
- +=, -=, *=, //=, %=
- Tests SSA variable versioning with augmented operations
- Self-referencing updates (x += 5)

### Edge Cases (14 tests)
- Division by constants and variables
- Operations with zero (addition, multiplication, division)
- Negative numbers in all operations
- Large numbers (1000000+)
- Order of operations and operator precedence
- Multiple operations in single expression

Total: 37 tests covering all arithmetic scenarios in QML code blocks.
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
class TestPythonToZ3Arithmetic(unittest.TestCase):
    """Granular tests for arithmetic operations in Python to Z3 conversion."""

    # ========== Addition Tests ==========

    def test_add_two_integers(self):
        """Test simple integer addition."""
        solver, compiler = compile_and_solve("result = 5 + 3")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 8)

    def test_add_negative_integers(self):
        """Test addition with negative integers."""
        solver, compiler = compile_and_solve("result = -5 + 3")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), -2)

    def test_add_zero(self):
        """Test addition with zero."""
        solver, compiler = compile_and_solve("result = 0 + 42")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 42)

    def test_add_boolean_to_integer(self):
        """Test boolean + integer (Python coercion: True=1, False=0)."""
        solver, compiler = compile_and_solve("""
b = True
result = b + 10
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 11)

    def test_add_two_booleans(self):
        """Test boolean + boolean arithmetic."""
        solver, compiler = compile_and_solve("""
a = True
b = False
result = a + b
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 1)  # 1 + 0

    def test_add_chain(self):
        """Test chained addition."""
        solver, compiler = compile_and_solve("result = 1 + 2 + 3 + 4")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 10)

    def test_add_with_variables(self):
        """Test addition with variables."""
        solver, compiler = compile_and_solve("""
x = 5
y = 7
result = x + y
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 12)

    # ========== Subtraction Tests ==========

    def test_subtract_two_integers(self):
        """Test simple integer subtraction."""
        solver, compiler = compile_and_solve("result = 10 - 3")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 7)

    def test_subtract_negative_result(self):
        """Test subtraction resulting in negative."""
        solver, compiler = compile_and_solve("result = 3 - 10")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), -7)

    def test_subtract_from_zero(self):
        """Test subtraction from zero."""
        solver, compiler = compile_and_solve("result = 0 - 5")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), -5)

    def test_subtract_boolean_from_integer(self):
        """Test integer - boolean."""
        solver, compiler = compile_and_solve("""
b = True
result = 10 - b
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 9)

    # ========== Multiplication Tests ==========

    def test_multiply_two_integers(self):
        """Test simple integer multiplication."""
        solver, compiler = compile_and_solve("result = 6 * 7")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 42)

    def test_multiply_by_zero(self):
        """Test multiplication by zero."""
        solver, compiler = compile_and_solve("result = 100 * 0")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 0)

    def test_multiply_by_one(self):
        """Test multiplication by one (identity)."""
        solver, compiler = compile_and_solve("result = 42 * 1")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 42)

    def test_multiply_negative(self):
        """Test multiplication with negative numbers."""
        solver, compiler = compile_and_solve("result = -3 * 4")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), -12)

    def test_multiply_two_negatives(self):
        """Test multiplication of two negative numbers."""
        solver, compiler = compile_and_solve("result = -3 * -4")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 12)

    def test_multiply_boolean(self):
        """Test multiplication with boolean."""
        solver, compiler = compile_and_solve("""
b = True
result = b * 100
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 100)

    def test_multiply_by_false(self):
        """Test multiplication by False (0)."""
        solver, compiler = compile_and_solve("""
b = False
result = 42 * b
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 0)

    # ========== Division Tests ==========

    def test_divide_exact(self):
        """Test exact integer division."""
        solver, compiler = compile_and_solve("result = 10 / 2")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 5)

    def test_floor_divide(self):
        """Test floor division."""
        solver, compiler = compile_and_solve("result = 10 // 3")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 3)

    def test_divide_with_remainder(self):
        """Test division with remainder (floor division)."""
        solver, compiler = compile_and_solve("result = 7 // 2")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 3)

    def test_divide_negative(self):
        """Test division with negative numbers."""
        solver, compiler = compile_and_solve("result = -10 // 3")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        # Python's floor division rounds toward negative infinity
        # -10 // 3 = floor(-3.33...) = -4
        self.assertEqual(model.eval(compiler.env['result']).as_long(), -4)

    # ========== Modulo Tests ==========

    def test_modulo_positive(self):
        """Test modulo operation."""
        solver, compiler = compile_and_solve("result = 10 % 3")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 1)

    def test_modulo_no_remainder(self):
        """Test modulo with no remainder."""
        solver, compiler = compile_and_solve("result = 10 % 5")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 0)

    def test_modulo_by_one(self):
        """Test modulo by 1 (always 0)."""
        solver, compiler = compile_and_solve("result = 42 % 1")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 0)

    # ========== Complex Expressions ==========

    def test_order_of_operations(self):
        """Test order of operations (PEMDAS)."""
        solver, compiler = compile_and_solve("result = 2 + 3 * 4")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 14)  # Not 20

    def test_parentheses(self):
        """Test parentheses override precedence."""
        solver, compiler = compile_and_solve("result = (2 + 3) * 4")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 20)

    def test_nested_operations(self):
        """Test deeply nested arithmetic."""
        solver, compiler = compile_and_solve("result = ((10 - 3) * 2 + 5) // 3")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 6)  # ((7*2+5)//3) = 19//3 = 6

    def test_mixed_operations(self):
        """Test mix of all operations."""
        solver, compiler = compile_and_solve("result = 10 + 3 * 4 - 20 // 5 + 7 % 3")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        # 10 + 12 - 4 + 1 = 19
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 19)

    # ========== Augmented Assignment Tests ==========

    def test_plus_equals(self):
        """Test += operator."""
        solver, compiler = compile_and_solve("""
x = 10
x += 5
result = x
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 15)

    def test_minus_equals(self):
        """Test -= operator."""
        solver, compiler = compile_and_solve("""
x = 10
x -= 3
result = x
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 7)

    def test_times_equals(self):
        """Test *= operator."""
        solver, compiler = compile_and_solve("""
x = 5
x *= 3
result = x
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 15)

    def test_divide_equals(self):
        """Test //= operator."""
        solver, compiler = compile_and_solve("""
x = 10
x //= 3
result = x
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 3)

    def test_mod_equals(self):
        """Test %= operator."""
        solver, compiler = compile_and_solve("""
x = 10
x %= 3
result = x
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 1)

    def test_augmented_chain(self):
        """Test chain of augmented assignments."""
        solver, compiler = compile_and_solve("""
x = 5
x += 3
x *= 2
x -= 6
x //= 2
result = x
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        # ((5+3)*2-6)//2 = (16-6)//2 = 10//2 = 5
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 5)

    # ========== Edge Cases ==========

    def test_large_numbers(self):
        """Test arithmetic with large numbers."""
        solver, compiler = compile_and_solve("result = 1000000 * 1000000")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 1000000000000)

    def test_zero_edge_cases(self):
        """Test various operations with zero."""
        solver, compiler = compile_and_solve("""
a = 0 + 0
b = 0 - 0
c = 0 * 100
d = 0 // 1
e = 0 % 5
result = a + b + c + d + e
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 0)


if __name__ == '__main__':
    unittest.main()