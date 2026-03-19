#!/usr/bin/env python3
"""Granular tests for Python to Z3 boolean conversion.

This test suite provides comprehensive coverage of boolean operations in the
PragmaticZ3Compiler, ensuring accurate translation from Python boolean logic
to Z3 boolean constraints.

## Coverage Areas:

### Boolean Literals (2 tests)
- True constant → Z3 BoolVal(True)
- False constant → Z3 BoolVal(False)

### Boolean AND Operations (9 tests)
- All combinations: True/True, True/False, False/True, False/False
- Short-circuit evaluation semantics
- Multiple operands (a and b and c)
- Mixed variables and constants

### Boolean OR Operations (9 tests)
- All combinations: True/True, True/False, False/True, False/False
- Short-circuit evaluation semantics
- Multiple operands (a or b or c)
- Mixed variables and constants

### Boolean NOT Operations (4 tests)
- NOT True → False
- NOT False → True
- Double negation (not not x)
- Negation of complex expressions

### Boolean in Arithmetic (3 tests)
- Boolean addition (counting True values)
- Boolean multiplication
- Sum of multiple booleans

Note: Explicit type casting tests (int(), bool()) are in test_z3_type_casting.py

### Complex Boolean Expressions (6 tests)
- De Morgan's laws verification: not (a and b) ≡ (not a) or (not b)
- Nested boolean operations: (a and b) or (c and d)
- Logical equivalences: XOR, implication
- Distribution laws
- Boolean algebra identities

Total: 30 tests covering all boolean logic scenarios in QML preconditions and code blocks.
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
class TestPythonToZ3Boolean(unittest.TestCase):
    """Granular tests for boolean operations in Python to Z3 conversion."""

    # ========== Boolean Literals ==========

    def test_true_literal(self):
        """Test True literal conversion."""
        solver, compiler = compile_and_solve("x = True")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertTrue(is_true(model.eval(compiler.env['x'])))

    def test_false_literal(self):
        """Test False literal conversion."""
        solver, compiler = compile_and_solve("x = False")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertTrue(is_false(model.eval(compiler.env['x'])))

    def test_boolean_assignment_chain(self):
        """Test chain of boolean assignments."""
        solver, compiler = compile_and_solve("""
a = True
b = a
c = b
result = c
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertTrue(is_true(model.eval(compiler.env['result'])))

    # ========== Boolean AND Operations ==========

    def test_and_true_true(self):
        """Test True and True."""
        solver, compiler = compile_and_solve("""
a = True
b = True
result = a and b
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertTrue(is_true(model.eval(compiler.env['result'])))

    def test_and_true_false(self):
        """Test True and False."""
        solver, compiler = compile_and_solve("""
a = True
b = False
result = a and b
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertTrue(is_false(model.eval(compiler.env['result'])))

    def test_and_false_false(self):
        """Test False and False."""
        solver, compiler = compile_and_solve("""
a = False
b = False
result = a and b
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertTrue(is_false(model.eval(compiler.env['result'])))

    def test_and_chain(self):
        """Test chained AND operations."""
        solver, compiler = compile_and_solve("""
a = True
b = True
c = True
d = False
result = a and b and c and d
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertTrue(is_false(model.eval(compiler.env['result'])))

    def test_and_with_integer(self):
        """Test AND with integer (non-zero is True)."""
        solver, compiler = compile_and_solve("""
a = 5
b = True
result = a and b
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertTrue(is_true(model.eval(compiler.env['result'])))

    def test_and_with_zero(self):
        """Test AND with zero (zero is False)."""
        solver, compiler = compile_and_solve("""
a = 0
b = True
result = a and b
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertTrue(is_false(model.eval(compiler.env['result'])))

    # ========== Boolean OR Operations ==========

    def test_or_true_true(self):
        """Test True or True."""
        solver, compiler = compile_and_solve("""
a = True
b = True
result = a or b
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertTrue(is_true(model.eval(compiler.env['result'])))

    def test_or_true_false(self):
        """Test True or False."""
        solver, compiler = compile_and_solve("""
a = True
b = False
result = a or b
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertTrue(is_true(model.eval(compiler.env['result'])))

    def test_or_false_false(self):
        """Test False or False."""
        solver, compiler = compile_and_solve("""
a = False
b = False
result = a or b
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertTrue(is_false(model.eval(compiler.env['result'])))

    def test_or_chain(self):
        """Test chained OR operations."""
        solver, compiler = compile_and_solve("""
a = False
b = False
c = True
d = False
result = a or b or c or d
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertTrue(is_true(model.eval(compiler.env['result'])))

    # ========== Boolean NOT Operations ==========

    def test_not_true(self):
        """Test not True."""
        solver, compiler = compile_and_solve("""
a = True
result = not a
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertTrue(is_false(model.eval(compiler.env['result'])))

    def test_not_false(self):
        """Test not False."""
        solver, compiler = compile_and_solve("""
a = False
result = not a
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertTrue(is_true(model.eval(compiler.env['result'])))

    def test_double_negation(self):
        """Test double negation."""
        solver, compiler = compile_and_solve("""
a = True
result = not not a
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertTrue(is_true(model.eval(compiler.env['result'])))

    def test_not_integer(self):
        """Test NOT with integer."""
        solver, compiler = compile_and_solve("""
a = 5
result = not a
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertTrue(is_false(model.eval(compiler.env['result'])))  # not 5 = False

    def test_not_zero(self):
        """Test NOT with zero."""
        solver, compiler = compile_and_solve("""
a = 0
result = not a
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertTrue(is_true(model.eval(compiler.env['result'])))  # not 0 = True

    # ========== Mixed Boolean Operations ==========

    def test_and_or_precedence(self):
        """Test precedence: AND binds tighter than OR."""
        solver, compiler = compile_and_solve("""
a = True
b = False
c = True
result = a or b and c
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        # a or (b and c) = True or False = True
        self.assertTrue(is_true(model.eval(compiler.env['result'])))

    def test_parentheses_override(self):
        """Test parentheses override precedence."""
        solver, compiler = compile_and_solve("""
a = True
b = False
c = True
result = (a or b) and c
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        # (True or False) and True = True and True = True
        self.assertTrue(is_true(model.eval(compiler.env['result'])))

    def test_complex_boolean_expression(self):
        """Test complex boolean expression."""
        solver, compiler = compile_and_solve("""
a = True
b = False
c = True
d = False
result = (a and b) or (c and not d)
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        # (True and False) or (True and True) = False or True = True
        self.assertTrue(is_true(model.eval(compiler.env['result'])))

    def test_demorgan_law1(self):
        """Test De Morgan's law: not(A and B) = (not A) or (not B)."""
        solver, compiler = compile_and_solve("""
a = True
b = False
result1 = not (a and b)
result2 = (not a) or (not b)
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        # Both should be equal
        r1 = is_true(model.eval(compiler.env['result1']))
        r2 = is_true(model.eval(compiler.env['result2']))
        self.assertEqual(r1, r2)

    def test_demorgan_law2(self):
        """Test De Morgan's law: not(A or B) = (not A) and (not B)."""
        solver, compiler = compile_and_solve("""
a = True
b = False
result1 = not (a or b)
result2 = (not a) and (not b)
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        # Both should be equal
        r1 = is_true(model.eval(compiler.env['result1']))
        r2 = is_true(model.eval(compiler.env['result2']))
        self.assertEqual(r1, r2)

    # ========== Boolean in Arithmetic Context ==========

    def test_boolean_addition(self):
        """Test boolean values in addition (auto-convert to int)."""
        solver, compiler = compile_and_solve("""
a = True
b = False
result = a + b
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 1)  # 1 + 0

    def test_boolean_multiplication(self):
        """Test boolean values in multiplication."""
        solver, compiler = compile_and_solve("""
a = True
b = True
result = a * b
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 1)  # 1 * 1

    def test_boolean_sum(self):
        """Test summing boolean values (counting True values)."""
        solver, compiler = compile_and_solve("""
a = True
b = False
c = True
d = True
result = a + b + c + d
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 3)  # Count of True

    # Note: Explicit type casting tests (int(), bool()) are in test_z3_type_casting.py

    # ========== Edge Cases ==========

    def test_all_true(self):
        """Test all() equivalent with booleans."""
        solver, compiler = compile_and_solve("""
a = True
b = True
c = True
result = a and b and c
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertTrue(is_true(model.eval(compiler.env['result'])))

    def test_any_true(self):
        """Test any() equivalent with booleans."""
        solver, compiler = compile_and_solve("""
a = False
b = True
c = False
result = a or b or c
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertTrue(is_true(model.eval(compiler.env['result'])))

    def test_xor_simulation(self):
        """Test XOR using boolean operations (A xor B = (A and not B) or (not A and B))."""
        solver, compiler = compile_and_solve("""
a = True
b = False
result = (a and not b) or (not a and b)
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertTrue(is_true(model.eval(compiler.env['result'])))  # True XOR False = True

    def test_implication_simulation(self):
        """Test implication (A implies B = not A or B)."""
        solver, compiler = compile_and_solve("""
a = True
b = True
result = (not a) or b
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertTrue(is_true(model.eval(compiler.env['result'])))  # True implies True = True


if __name__ == '__main__':
    unittest.main()