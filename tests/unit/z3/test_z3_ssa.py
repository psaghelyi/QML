#!/usr/bin/env python3
"""Granular tests for Python to Z3 SSA (Static Single Assignment) conversion.

This test suite provides comprehensive coverage of SSA form generation in the
PragmaticZ3Compiler, ensuring accurate variable versioning when translating
Python code with reassignments to Z3 constraints.

## Coverage Areas:

### Basic SSA Versioning (5 tests)
- Single assignment: x = 5 creates x_0
- Reassignment: x = 10 creates x_1
- Multiple reassignments: x = 5; x = 10; x = 15; x = 20
- Self-referencing: x = x + 3 (reads x_0, writes x_1)
- Chain of updates: x = 1; x = x + 1; x = x * 2; x = x - 1

### SSA in Control Flow (4 tests)
- SSA inside if branch
- SSA inside else branch
- Conditional assignment with branching
- Nested conditionals with SSA

### Multiple Variables SSA (5 tests)
- Independent variables: x and y versioned separately
- Dependent assignments: y = x + 3; x = y * 2
- Variable swap pattern: temp = a; a = b; b = temp
- Parallel assignment simulation
- Complex dependency chains

### SSA with Type Changes (3 tests)
- Variable changes from int to bool: x = 5; x = x > 3
- Variable changes from bool to int: x = True; x = int(x) + 5
- Mixed type assignments with SSA versioning

### SSA in Complex Patterns (8 tests)
- Accumulator: sum = 0; sum = sum + 5; sum = sum + 10
- Factorial simulation (unrolled loop)
- Fibonacci sequence steps
- Conditional updates in branches
- Unused intermediate versions
- Same value reassignment
- Complex expression assignments
- Variable shadowing in branches
- Version independence (old_x captures earlier version)

Total: 25 tests covering all SSA scenarios in QML code blocks.

Key Concept: SSA ensures each variable assignment creates a new Z3 variable
with a unique version number, allowing Z3 to track all variable states and
reason about sequential code execution.
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
class TestPythonToZ3SSA(unittest.TestCase):
    """Granular tests for SSA form in Python to Z3 conversion."""

    # ========== Basic SSA Versioning ==========

    def test_single_assignment(self):
        """Test single assignment creates SSA variable."""
        solver, compiler = compile_and_solve("""
x = 5
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        # Check that x_0 exists and has correct value
        self.assertEqual(model.eval(compiler.env['x']).as_long(), 5)

    def test_reassignment_creates_new_version(self):
        """Test reassignment creates new SSA version."""
        solver, compiler = compile_and_solve("""
x = 5
x = 10
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        # Latest version should be 10
        self.assertEqual(model.eval(compiler.env['x']).as_long(), 10)

    def test_multiple_reassignments(self):
        """Test multiple reassignments create sequential versions."""
        solver, compiler = compile_and_solve("""
x = 5
x = 10
x = 15
x = 20
result = x
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 20)

    def test_reassignment_with_self_reference(self):
        """Test reassignment that references itself."""
        solver, compiler = compile_and_solve("""
x = 5
x = x + 3
result = x
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 8)

    def test_chain_of_self_references(self):
        """Test chain of self-referencing reassignments."""
        solver, compiler = compile_and_solve("""
x = 1
x = x + 1
x = x * 2
x = x - 1
result = x
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        # ((1 + 1) * 2) - 1 = (2 * 2) - 1 = 4 - 1 = 3
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 3)

    # ========== SSA in Control Flow ==========

    def test_ssa_in_if_branch(self):
        """Test SSA versioning inside if branch."""
        solver, compiler = compile_and_solve("""
x = 5
if True:
    x = 10
result = x
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 10)

    def test_ssa_in_else_branch(self):
        """Test SSA versioning inside else branch."""
        solver, compiler = compile_and_solve("""
x = 5
if False:
    x = 10
else:
    x = 20
result = x
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 20)

    def test_ssa_conditional_assignment(self):
        """Test SSA with conditional assignment."""
        solver, compiler = compile_and_solve("""
x = 5
condition = True
if condition:
    x = x * 2
else:
    x = x + 3
result = x
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 10)  # 5 * 2

    def test_ssa_nested_conditionals(self):
        """Test SSA in nested conditionals."""
        solver, compiler = compile_and_solve("""
x = 1
if True:
    x = x + 1
    if True:
        x = x + 1
    else:
        x = x - 1
else:
    x = 0
result = x
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 3)  # 1 + 1 + 1

    # ========== Multiple Variables SSA ==========

    def test_multiple_variables_independent(self):
        """Test SSA with multiple independent variables."""
        solver, compiler = compile_and_solve("""
x = 5
y = 10
x = 7
y = 12
result = x + y
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 19)  # 7 + 12

    def test_multiple_variables_dependent(self):
        """Test SSA with dependent variable assignments."""
        solver, compiler = compile_and_solve("""
x = 5
y = x + 3
x = y * 2
y = x - 4
result = x + y
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        # x = 5, y = 8, x = 16, y = 12
        # result = 16 + 12 = 28
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 28)

    def test_swap_pattern(self):
        """Test variable swap pattern with SSA."""
        solver, compiler = compile_and_solve("""
a = 5
b = 10
temp = a
a = b
b = temp
result_a = a
result_b = b
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result_a']).as_long(), 10)
        self.assertEqual(model.eval(compiler.env['result_b']).as_long(), 5)

    def test_parallel_assignment_simulation(self):
        """Test simulated parallel assignment using SSA."""
        solver, compiler = compile_and_solve("""
x = 5
y = 10
# Simulate x, y = y, x
temp_x = y
temp_y = x
x = temp_x
y = temp_y
result_x = x
result_y = y
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result_x']).as_long(), 10)
        self.assertEqual(model.eval(compiler.env['result_y']).as_long(), 5)

    # ========== SSA with Type Changes ==========

    def test_ssa_type_change_int_to_bool(self):
        """Test SSA when variable changes from int to bool."""
        solver, compiler = compile_and_solve("""
x = 5
x = x > 3
result = x
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertTrue(is_true(model.eval(compiler.env['result'])))

    def test_ssa_type_change_bool_to_int(self):
        """Test SSA when variable changes from bool to int."""
        solver, compiler = compile_and_solve("""
x = True
x = int(x) + 5
result = x
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 6)

    def test_ssa_mixed_types(self):
        """Test SSA with mixed type assignments."""
        solver, compiler = compile_and_solve("""
x = 10
is_large = x > 5
x = int(is_large) * 100
result = x
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 100)

    # ========== SSA in Complex Patterns ==========

    def test_ssa_accumulator_pattern(self):
        """Test SSA in accumulator pattern."""
        solver, compiler = compile_and_solve("""
sum = 0
sum = sum + 5
sum = sum + 10
sum = sum + 15
result = sum
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 30)

    def test_ssa_factorial_simulation(self):
        """Test SSA simulating factorial calculation."""
        solver, compiler = compile_and_solve("""
n = 5
result = 1
# Unrolled factorial
result = result * 1
result = result * 2
result = result * 3
result = result * 4
result = result * 5
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 120)

    def test_ssa_fibonacci_step(self):
        """Test SSA simulating Fibonacci sequence step."""
        solver, compiler = compile_and_solve("""
a = 0
b = 1
# One Fibonacci step
temp = a + b
a = b
b = temp
# Another step
temp = a + b
a = b
b = temp
# Another step
temp = a + b
a = b
b = temp
result = b
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        # Sequence: 0, 1, 1, 2, 3
        # Initial: a=0, b=1
        # Step 1: temp=1, a=1, b=1
        # Step 2: temp=2, a=1, b=2
        # Step 3: temp=3, a=2, b=3
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 3)

    def test_ssa_conditional_update(self):
        """Test SSA with conditional variable updates."""
        solver, compiler = compile_and_solve("""
x = 10
y = 5
if x > y:
    x = x - y
    y = y * 2
else:
    x = x * 2
    y = y - x
result_x = x
result_y = y
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result_x']).as_long(), 5)  # 10 - 5
        self.assertEqual(model.eval(compiler.env['result_y']).as_long(), 10)  # 5 * 2

    # ========== SSA Edge Cases ==========

    def test_ssa_unused_variable(self):
        """Test SSA with unused intermediate versions."""
        solver, compiler = compile_and_solve("""
x = 5
x = 10  # This version is never used
x = 15
result = x
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 15)

    def test_ssa_same_value_reassignment(self):
        """Test SSA when reassigning same value."""
        solver, compiler = compile_and_solve("""
x = 5
x = 5  # Same value, but new version
result = x
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 5)

    def test_ssa_complex_expression_assignment(self):
        """Test SSA with complex expression assignments."""
        solver, compiler = compile_and_solve("""
a = 2
b = 3
c = 4
x = (a + b) * c
x = x + (a * b * c)
x = x - (a + b + c)
result = x
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        # ((2+3)*4) + (2*3*4) - (2+3+4) = 20 + 24 - 9 = 35
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 35)

    def test_ssa_shadowing_in_branches(self):
        """Test SSA with variable shadowing in different branches."""
        solver, compiler = compile_and_solve("""
x = 5
if True:
    x = 10
    y = x + 5
else:
    x = 20
    y = x + 10
result = y
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 15)  # 10 + 5

    def test_ssa_version_independence(self):
        """Test that SSA versions are independent."""
        solver, compiler = compile_and_solve("""
x = 5
old_x = x
x = 10
# old_x should still be 5
result = old_x + x
""")
        self.assertEqual(solver.check(), sat)
        model = solver.model()
        self.assertEqual(model.eval(compiler.env['result']).as_long(), 15)  # 5 + 10


if __name__ == '__main__':
    unittest.main()