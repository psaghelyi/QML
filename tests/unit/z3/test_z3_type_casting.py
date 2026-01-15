#!/usr/bin/env python3
"""Granular tests for explicit type casting in Python to Z3 conversion.

This test suite verifies that the PragmaticZ3Compiler correctly handles explicit
type conversions using int() and bool() functions, as well as implicit type
preservation in variable assignments.

## Coverage Areas:

### Explicit Integer Casting (2 tests)
- int(True) → 1
- int(False) → 0
- Conversion of boolean variables to integers
- Use in arithmetic: int(has_car) + int(has_house)

### Explicit Boolean Casting (2 tests)
- bool(0) → False
- bool(non-zero) → True
- Conversion of integer variables to booleans
- Use in conditions and boolean operations

### Type Preservation in Variables (1 test)
- Boolean variables remain Bool type: flag = True
- Integer variables remain Int type: count = 5
- Type determined by RHS expression, not forced conversion
- Verifies Python semantics: types preserved unless explicitly cast

### Mixed Explicit and Implicit Conversions (1 test)
- Combination of explicit casting and implicit coercion
- Example: score = int(has_insurance) + int(has_car)
- Verifies both mechanisms work together correctly

### Real-World Scenario (1 test - questionnaire scoring)
- Practical use case from QML questionnaires
- Boolean outcomes converted to scores
- Multiple items combined into final score
- Example: score = int(q1.outcome) + int(q2.outcome) + int(q3.outcome)

Total: 6 tests covering explicit type casting scenarios.

Key Design Decision: Variables preserve their type based on the RHS expression.
Arithmetic operations automatically convert booleans to integers (Python behavior).
Explicit int() and bool() functions provide manual type control when needed.
"""

import unittest
import pytest
import ast
from z3 import *

from askalot_qml.z3.pragmatic_compiler import PragmaticZ3Compiler


def parse_code(code: str):
    """Parse Python code into AST."""
    return ast.parse(code)


@pytest.mark.unit
@pytest.mark.z3
class TestExplicitTypeCasting(unittest.TestCase):
    """Test explicit type casting functions int() and bool()."""

    def test_explicit_int_casting_from_bool(self):
        """Test explicit int() casting of boolean values."""
        compiler = PragmaticZ3Compiler({}, 'test')
        code = """
b = True
i = int(b)
"""
        tree = parse_code(code)
        compiler.visit(tree)

        solver = Solver()
        solver.add(compiler.constraints)
        self.assertEqual(solver.check(), sat)

        model = solver.model()
        # b should be boolean
        self.assertTrue(is_true(model.evaluate(compiler.env['b'])))
        # i should be 1 (explicit cast)
        self.assertEqual(int(str(model.evaluate(compiler.env['i']))), 1)

    def test_explicit_bool_casting_from_int(self):
        """Test explicit bool() casting of integer values."""
        compiler = PragmaticZ3Compiler({}, 'test')
        code = """
i = 5
b = bool(i)
"""
        tree = parse_code(code)
        compiler.visit(tree)

        solver = Solver()
        solver.add(compiler.constraints)
        self.assertEqual(solver.check(), sat)

        model = solver.model()
        # i should be integer
        self.assertEqual(int(str(model.evaluate(compiler.env['i']))), 5)
        # b should be True (non-zero int)
        self.assertTrue(is_true(model.evaluate(compiler.env['b'])))

    def test_explicit_bool_casting_zero(self):
        """Test bool(0) returns False."""
        compiler = PragmaticZ3Compiler({}, 'test')
        code = """
i = 0
b = bool(i)
"""
        tree = parse_code(code)
        compiler.visit(tree)

        solver = Solver()
        solver.add(compiler.constraints)
        self.assertEqual(solver.check(), sat)

        model = solver.model()
        self.assertEqual(int(str(model.evaluate(compiler.env['i']))), 0)
        self.assertTrue(is_false(model.evaluate(compiler.env['b'])))

    def test_mixed_explicit_and_implicit_conversion(self):
        """Test mixing explicit casting with Python's implicit conversion."""
        compiler = PragmaticZ3Compiler({}, 'test')
        code = """
has_insurance = True
has_car = False
# Explicit casting for clarity
score = int(has_insurance) + int(has_car)
# Python's implicit conversion in arithmetic
score2 = has_insurance + has_car + 10
"""
        tree = parse_code(code)
        compiler.visit(tree)

        solver = Solver()
        solver.add(compiler.constraints)
        self.assertEqual(solver.check(), sat)

        model = solver.model()
        # score = 1 + 0 = 1
        self.assertEqual(int(str(model.evaluate(compiler.env['score']))), 1)
        # score2 = 1 + 0 + 10 = 11 (implicit conversion)
        self.assertEqual(int(str(model.evaluate(compiler.env['score2']))), 11)

    def test_preserving_types_in_variables(self):
        """Test that variables preserve their types unless explicitly converted."""
        compiler = PragmaticZ3Compiler({}, 'test')
        code = """
is_adult = True
age = 25
# Variables preserve types
x = is_adult  # x is boolean
y = age       # y is integer
# Explicit conversion
z = int(is_adult)  # z is integer
w = bool(age)      # w is boolean
"""
        tree = parse_code(code)
        compiler.visit(tree)

        solver = Solver()
        solver.add(compiler.constraints)
        self.assertEqual(solver.check(), sat)

        model = solver.model()
        # x preserves boolean type
        self.assertTrue(is_true(model.evaluate(compiler.env['x'])))
        # y preserves integer type
        self.assertEqual(int(str(model.evaluate(compiler.env['y']))), 25)
        # z is explicitly converted to int
        self.assertEqual(int(str(model.evaluate(compiler.env['z']))), 1)
        # w is explicitly converted to bool
        self.assertTrue(is_true(model.evaluate(compiler.env['w'])))

    def test_questionnaire_outcome_scoring(self):
        """Test realistic questionnaire scoring with mixed boolean/integer operations."""
        # Simulate questionnaire items as predefined
        q1_outcome = Int('S_q1')  # Integer outcome
        q2_outcome = Int('S_q2')  # Integer outcome
        predefined = {'S_q1': q1_outcome, 'S_q2': q2_outcome}

        compiler = PragmaticZ3Compiler(predefined, 'scoring')
        code = """
# Check conditions
has_high_score = S_q1 > 50
has_bonus = S_q2 == 100

# Calculate final score
# Python automatically converts booleans to 0/1 in arithmetic
final_score = S_q1 + S_q2 + has_high_score * 10 + has_bonus * 20

# Alternative with explicit casting
final_score_explicit = S_q1 + S_q2 + int(has_high_score) * 10 + int(has_bonus) * 20
"""
        tree = parse_code(code)
        compiler.visit(tree)

        solver = Solver()
        solver.add(compiler.constraints)
        solver.add(q1_outcome == 60)  # Above threshold
        solver.add(q2_outcome == 100) # Bonus condition met

        self.assertEqual(solver.check(), sat)

        model = solver.model()
        # has_high_score = True, has_bonus = True
        # final_score = 60 + 100 + 1*10 + 1*20 = 190
        self.assertEqual(int(str(model.evaluate(compiler.env['final_score']))), 190)
        self.assertEqual(int(str(model.evaluate(compiler.env['final_score_explicit']))), 190)


if __name__ == '__main__':
    unittest.main()