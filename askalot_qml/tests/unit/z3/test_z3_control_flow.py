#!/usr/bin/env python3
"""Granular tests for Python to Z3 control flow conversion.

This test suite provides comprehensive coverage of control flow structures in the
PragmaticZ3Compiler, ensuring accurate translation from Python conditionals to
Z3 constraints with proper path satisfaction.

## Coverage Areas:

### Simple If Statements (4 tests)
- If with true condition → branch executed
- If with false condition → branch skipped
- If with comparison condition: if x > 5
- If with complex boolean: if (a > b) and c

### If-Else Statements (4 tests)
- True branch execution
- False branch execution
- If-else with arithmetic in branches
- Multiple assignments in each branch

### Elif Chains (4 tests)
- First condition true → first branch
- Middle condition true → middle branch
- All false → else branch
- Elif without else clause

### Nested If Statements (4 tests)
- Nested if with inner condition true
- Nested if with inner condition false
- Nested if-else combinations
- Deeply nested conditionals (3+ levels)

### Complex Control Flow Patterns (11 tests)
- Variable updates inside conditionals
- Boolean flag toggling
- Conditional accumulation (score += 10 if condition)
- Arithmetic conditions: if (a + b) > (c * 3)
- Max/min patterns using if-else
- Absolute value pattern
- Clamp/bound pattern (limit value between min/max)
- Empty if branches (pass statements)
- Multiple conditions in single if
- NOT operator in conditions

Total: 27 tests covering all control flow scenarios in QML code blocks and preconditions.

Note: These tests verify that Z3 can model different execution paths and that
the correct path is satisfied based on the condition values.
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
class TestPythonToZ3ControlFlow(unittest.TestCase):
    """Granular tests for control flow structures in Python to Z3 conversion."""

    # ========== Simple If Statements ==========

    def test_if_true_condition(self):
        """Test simple if statement with true condition."""
        solver, compiler = compile_and_solve("""
condition = True
result = 0
if condition:
    result = 42
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 42)

    def test_if_false_condition(self):
        """Test simple if statement with false condition."""
        solver, compiler = compile_and_solve("""
condition = False
result = 99
if condition:
    result = 42
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 99)

    def test_if_comparison_condition(self):
        """Test if statement with comparison condition."""
        solver, compiler = compile_and_solve("""
x = 10
result = 0
if x > 5:
    result = 100
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 100)

    def test_if_complex_condition(self):
        """Test if statement with complex boolean condition."""
        solver, compiler = compile_and_solve("""
a = 10
b = 5
c = True
result = 0
if (a > b) and c:
    result = 200
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 200)

    # ========== If-Else Statements ==========

    def test_if_else_true_branch(self):
        """Test if-else taking true branch."""
        solver, compiler = compile_and_solve("""
condition = True
if condition:
    result = 42
else:
    result = 99
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 42)

    def test_if_else_false_branch(self):
        """Test if-else taking false branch."""
        solver, compiler = compile_and_solve("""
condition = False
if condition:
    result = 42
else:
    result = 99
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 99)

    def test_if_else_with_arithmetic(self):
        """Test if-else with arithmetic in branches."""
        solver, compiler = compile_and_solve("""
x = 7
if x > 5:
    result = x * 2
else:
    result = x + 10
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 14)  # 7 * 2

    def test_if_else_multiple_assignments(self):
        """Test if-else with multiple assignments in branches."""
        solver, compiler = compile_and_solve("""
x = 10
if x >= 10:
    a = 1
    b = 2
    result = a + b
else:
    a = 5
    b = 6
    result = a + b
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 3)

    # ========== Elif Chains ==========

    def test_elif_first_true(self):
        """Test elif chain with first condition true."""
        solver, compiler = compile_and_solve("""
x = 5
if x < 0:
    result = -1
elif x < 10:
    result = 0
elif x < 20:
    result = 1
else:
    result = 2
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 0)

    def test_elif_middle_true(self):
        """Test elif chain with middle condition true."""
        solver, compiler = compile_and_solve("""
x = 15
if x < 0:
    result = -1
elif x < 10:
    result = 0
elif x < 20:
    result = 1
else:
    result = 2
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 1)

    def test_elif_else_branch(self):
        """Test elif chain reaching else branch."""
        solver, compiler = compile_and_solve("""
x = 25
if x < 0:
    result = -1
elif x < 10:
    result = 0
elif x < 20:
    result = 1
else:
    result = 2
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 2)

    def test_elif_no_else(self):
        """Test elif chain without else branch."""
        solver, compiler = compile_and_solve("""
x = 15
result = 100  # default value
if x < 0:
    result = -1
elif x < 10:
    result = 0
elif x < 20:
    result = 1
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 1)

    # ========== Nested If Statements ==========

    def test_nested_if_inner_true(self):
        """Test nested if with inner condition true."""
        solver, compiler = compile_and_solve("""
x = 10
y = 5
result = 0
if x > 5:
    if y > 3:
        result = 100
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 100)

    def test_nested_if_inner_false(self):
        """Test nested if with inner condition false."""
        solver, compiler = compile_and_solve("""
x = 10
y = 2
result = 0
if x > 5:
    if y > 3:
        result = 100
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 0)

    def test_nested_if_else(self):
        """Test nested if-else statements."""
        solver, compiler = compile_and_solve("""
x = 10
y = 5
if x > 5:
    if y > 3:
        result = 100
    else:
        result = 50
else:
    if y > 3:
        result = 25
    else:
        result = 10
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 100)

    def test_deeply_nested_conditionals(self):
        """Test deeply nested conditional statements."""
        solver, compiler = compile_and_solve("""
a = 10
b = 5
c = 3
if a > 8:
    if b > 4:
        if c > 2:
            result = 1000
        else:
            result = 500
    else:
        result = 250
else:
    result = 100
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 1000)

    # ========== Complex Control Flow ==========

    def test_if_with_variable_update(self):
        """Test if statement that updates variables."""
        solver, compiler = compile_and_solve("""
x = 5
y = 10
if x < y:
    x = x + 10
    y = y - 5
result = x + y
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 20)  # (5+10) + (10-5) = 15 + 5

    def test_if_with_boolean_toggle(self):
        """Test if statement toggling boolean values."""
        solver, compiler = compile_and_solve("""
flag = True
value = 10
if flag:
    flag = False
    value = value * 2
if not flag:
    value = value + 5
result = value
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 25)  # (10*2) + 5

    def test_conditional_accumulation(self):
        """Test conditional accumulation pattern."""
        solver, compiler = compile_and_solve("""
score = 0
has_car = True
has_house = True
has_insurance = False

if has_car:
    score = score + 10
if has_house:
    score = score + 20
if has_insurance:
    score = score + 5

result = score
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 30)  # 10 + 20

    def test_conditional_with_arithmetic_condition(self):
        """Test conditional with arithmetic expression in condition."""
        solver, compiler = compile_and_solve("""
a = 5
b = 3
c = 2
if (a + b) > (c * 3):
    result = 100
else:
    result = 50
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 100)  # (5+3) > (2*3) = 8 > 6 = True

    def test_max_pattern(self):
        """Test max pattern using if-else."""
        solver, compiler = compile_and_solve("""
a = 15
b = 10
if a > b:
    maximum = a
else:
    maximum = b
result = maximum
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 15)

    def test_min_pattern(self):
        """Test min pattern using if-else."""
        solver, compiler = compile_and_solve("""
a = 15
b = 10
if a < b:
    minimum = a
else:
    minimum = b
result = minimum
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 10)

    def test_abs_pattern(self):
        """Test absolute value pattern using if-else."""
        solver, compiler = compile_and_solve("""
x = -7
if x < 0:
    abs_x = -x
else:
    abs_x = x
result = abs_x
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 7)

    def test_clamp_pattern(self):
        """Test clamp/bound pattern using if-elif-else."""
        solver, compiler = compile_and_solve("""
x = 15
min_val = 0
max_val = 10
if x < min_val:
    clamped = min_val
elif x > max_val:
    clamped = max_val
else:
    clamped = x
result = clamped
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 10)

    # ========== Edge Cases ==========

    def test_empty_if_branch(self):
        """Test if statement with pass (no-op)."""
        solver, compiler = compile_and_solve("""
x = 5
result = 100
if x > 10:
    pass  # Empty branch
result = result  # Result unchanged
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 100)

    def test_single_branch_multiple_conditions(self):
        """Test single if with complex combined conditions."""
        solver, compiler = compile_and_solve("""
a = 5
b = 10
c = 15
d = True
result = 0
if (a < b) and (b < c) and d and (a + b == c):
    result = 1000
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 1000)

    def test_if_condition_with_not(self):
        """Test if condition with NOT operator."""
        solver, compiler = compile_and_solve("""
x = 5
y = 10
if not (x > y):
    result = 42
else:
    result = 99
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 42)


if __name__ == '__main__':
    unittest.main()