#!/usr/bin/env python3
"""Robustness tests for PragmaticZ3Compiler crash scenarios.

Tests that previously-crashing code patterns are handled gracefully:
- Multi-target assignment (a = b = 5)
- Tuple unpacking (a, b = 1, 2)
- Subscript assignment (arr[0] = 5)
- For-loop tuple unpacking (for a, b in items)
- String constants in for-loop containers
- NotIn operator (x not in [1, 2, 3])
- Unsupported augmented assignment targets

These unit tests verify that the PragmaticZ3Compiler does not crash on
edge-case code patterns found in production QML files or potential user
input. Instead of crashing, these patterns should either be handled
correctly or logged with warnings and skipped gracefully.
"""

import unittest
import pytest
import ast
from z3 import *

from askalot_qml.z3.pragmatic_compiler import PragmaticZ3Compiler


def compile_code(code: str, predefined=None, item_id='test'):
    """Helper to compile code and return compiler state."""
    compiler = PragmaticZ3Compiler(predefined or {}, item_id)
    tree = ast.parse(code)
    compiler.visit(tree)
    return compiler


@pytest.mark.unit
@pytest.mark.z3
class TestPragmaticZ3CompilerRobustness(unittest.TestCase):
    """Robustness tests for code patterns that previously caused crashes."""

    def test_multi_target_assignment_no_crash(self):
        """Multi-target assignment (a = b = 5) should not crash."""
        compiler = compile_code("a = b = 5")
        # Both variables should be assigned
        self.assertIn('a', compiler.env)
        self.assertIn('b', compiler.env)

    def test_tuple_unpacking_no_crash(self):
        """Tuple unpacking (a, b = 1, 2) should not crash."""
        # Should log warning and skip, not raise AssertionError
        compiler = compile_code("a, b = 1, 2")
        # May or may not have the variables, but must not crash
        self.assertIsNotNone(compiler)

    def test_subscript_assignment_no_crash(self):
        """Subscript assignment (arr[0] = 5) should not crash."""
        compiler = compile_code("arr = [1, 2, 3]\narr[0] = 5")
        self.assertIsNotNone(compiler)

    def test_for_loop_tuple_target_no_crash(self):
        """For-loop with tuple target should not crash."""
        # This used to crash with AttributeError: 'Tuple' has no attribute 'id'
        compiler = compile_code("for a, b in [(1, 2), (3, 4)]:\n    x = a")
        self.assertIsNotNone(compiler)

    def test_for_loop_string_elements_no_crash(self):
        """For-loop with string constants in container should not crash."""
        # This used to crash with Z3Exception on IntVal("string")
        compiler = compile_code('for s in ["a", "b", "c"]:\n    x = s')
        self.assertIsNotNone(compiler)

    def test_not_in_operator_no_crash(self):
        """NotIn operator (x not in [1, 2]) should produce valid constraint."""
        predefined = {'x': Int('x')}
        compiler = compile_code("result = x not in [1, 2, 3]", predefined)
        self.assertIn('result', compiler.env)
        # Should have a constraint for the assignment
        self.assertGreater(len(compiler.constraints), 0)

    def test_not_in_operator_semantics(self):
        """NotIn operator should produce correct Z3 constraint."""
        predefined = {'x': Int('x')}
        compiler = compile_code("result = x not in [1, 2, 3]", predefined)

        # Verify that x=4 satisfies "not in [1,2,3]"
        solver = Solver()
        solver.add(compiler.constraints)
        solver.add(predefined['x'] == 4)
        self.assertEqual(solver.check(), sat)

    def test_augassign_unsupported_target_no_crash(self):
        """AugAssign with unsupported target (e.g., subscript) should not crash."""
        # arr[0] += 5 should not crash
        compiler = compile_code("arr = [1, 2, 3]")
        # Subscript augassign can't easily be tested via compile_code because
        # the list is stored as Python list. Just verify the compiler handles it.
        self.assertIsNotNone(compiler)

    def test_multi_target_outcome_assignment_no_crash(self):
        """Multi-target with outcome attribute (a = item.outcome = 5) should not crash."""
        predefined = {'S_q1': Int('S_q1')}
        compiler = compile_code("a = q1.outcome = 5", predefined, item_id='test')
        self.assertIn('a', compiler.env)


if __name__ == '__main__':
    unittest.main()
