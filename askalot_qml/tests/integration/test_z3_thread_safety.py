#!/usr/bin/env python3
"""Integration tests for Z3 thread safety under concurrent GC pressure.

Reproduces the Z3 assertion violation at ast.cpp:388 that occurs in production
when background threads (watchdog Observer, IPC threads) trigger Python's garbage
collector while the main thread is running Z3 analysis.

The root cause: Z3's global context (main_ctx()) is not thread-safe. When Python's
cyclic GC runs in a background thread and collects Z3 wrapper objects, their C-level
destructors race with Z3 operations on the main thread, corrupting AST reference counts.

Production scenario (Armiger):
- Main thread: Gunicorn sync worker running ValidationProcessor (Z3 classification)
- Background thread: watchdog Observer monitoring QML file changes
- The Observer thread triggers Python GC → collects Z3 wrappers → C destructors
  race with main thread's Z3 solver operations → ast.cpp:388 assertion violation

The fix: use a separate z3.Context() per analysis instead of the global main_ctx().
Objects on different contexts are fully isolated at the C level.

Reference: https://github.com/Z3Prover/z3/issues/5666
Reference: https://github.com/Z3Prover/z3/issues/4768
"""

import gc
import threading
import time
import unittest
from pathlib import Path

import pytest
from z3 import Context, Int, BoolVal, Solver, And, Not, Implies, sat, unsat

from askalot_qml.core.qml_loader import QMLLoader
from askalot_qml.core.validation_processor import ValidationProcessor
from askalot_qml.models.qml_state import QMLState

# Path to fixture files
FIXTURES_DIR = Path(__file__).parent.parent / "fixtures"


def load_qml_fixture(filename: str) -> QMLState:
    """Load a QML fixture file and return QMLState."""
    loader = QMLLoader(schema_path=None)
    qml_path = FIXTURES_DIR / filename
    data = loader.load_from_path(str(qml_path))
    return QMLState(data)


# ---------------------------------------------------------------------------
# Helpers: GC pressure using the GLOBAL context (reproduces the crash)
# ---------------------------------------------------------------------------

def _create_and_discard_z3_objects_global(count: int = 100):
    """Create Z3 objects on the GLOBAL context and let them become garbage."""
    for i in range(count):
        x = Int(f"_gc_pressure_{i}")
        y = Int(f"_gc_pressure_{i}_b")
        _ = And(x > 0, y < 100, x + y == 50)
        s = Solver()
        s.add(x >= 0, y >= 0)


def _gc_pressure_thread_global(stop_event: threading.Event, intensity: int = 50):
    """Background thread creating GC pressure on the GLOBAL Z3 context."""
    while not stop_event.is_set():
        _create_and_discard_z3_objects_global(intensity)
        gc.collect()
        time.sleep(0.001)


# ---------------------------------------------------------------------------
# Helpers: GC pressure using a DEDICATED context (the fix)
# ---------------------------------------------------------------------------

def _create_and_discard_z3_objects_isolated(count: int = 100):
    """Create Z3 objects on a DEDICATED context — isolated from other threads."""
    ctx = Context()
    for i in range(count):
        x = Int(f"_gc_pressure_{i}", ctx)
        y = Int(f"_gc_pressure_{i}_b", ctx)
        _ = And(x > 0, y < 100, x + y == 50)
        s = Solver(ctx=ctx)
        s.add(x >= 0, y >= 0)


def _gc_pressure_thread_isolated(stop_event: threading.Event, intensity: int = 50):
    """Background thread creating GC pressure on its OWN Z3 context."""
    while not stop_event.is_set():
        _create_and_discard_z3_objects_isolated(intensity)
        gc.collect()
        time.sleep(0.001)


# ===========================================================================
# SECTION A: Known-broken tests (global context, expected to crash/fail)
# ===========================================================================

@pytest.mark.integration
@pytest.mark.z3
class TestZ3GlobalContextRace(unittest.TestCase):
    """Demonstrate that the GLOBAL Z3 context is NOT thread-safe.

    These tests are expected to fail (segfault or assertion violation)
    when Z3 objects on the global context are accessed from multiple threads.
    """

    @pytest.mark.skip(reason="Z3 global context is not thread-safe — segfault kills the process (not catchable)")
    def test_concurrent_solvers_global_context_crashes(self):
        """Z3 solver ops on global context + background GC thread → crash.

        This reproduces the production ast.cpp:388 assertion violation.
        """
        stop_event = threading.Event()
        gc_thread = threading.Thread(
            target=_gc_pressure_thread_global,
            args=(stop_event, 100),
            daemon=True,
        )
        gc_thread.start()

        errors = []
        try:
            for iteration in range(50):
                try:
                    items = [Int(f"item_{j}_{iteration}") for j in range(10)]
                    domain = And(*[And(v >= 1, v <= 5) for v in items])

                    P = items[0] == 1
                    s1 = Solver()
                    s1.add(domain, P)
                    result1 = s1.check()
                    self.assertEqual(result1, sat)

                    s2 = Solver()
                    s2.add(domain, Not(P))
                    s2.check()

                    Q = items[1] <= items[0]
                    s3 = Solver()
                    s3.add(domain, P, Not(Q))
                    s3.check()

                    F = And(domain, Implies(P, Q))
                    s4 = Solver()
                    s4.add(F)
                    s4.check()
                except Exception as e:
                    errors.append((iteration, str(e)))
        finally:
            stop_event.set()
            gc_thread.join(timeout=5)

        if errors:
            self.fail(
                f"Z3 crashed under GC pressure in {len(errors)}/{50} iterations "
                f"(expected — global context is not thread-safe).\n"
                + "\n".join(f"  iteration {i}: {e}" for i, e in errors[:3])
            )


# ===========================================================================
# SECTION B: Fixed tests — explicit z3.Context() per analysis
# ===========================================================================

@pytest.mark.integration
@pytest.mark.z3
class TestZ3ExplicitContextIsolation(unittest.TestCase):
    """Prove that per-analysis z3.Context() eliminates the thread-safety crash.

    Each analysis creates its own Context and passes it to all Int(), Solver()
    etc. calls. Background threads use their own Context. Since Z3 contexts
    are isolated at the C level, there is no race condition.
    """

    def test_solvers_with_explicit_context_under_gc_pressure(self):
        """Z3 solver ops on a dedicated context + background GC thread → safe.

        Same workload as test_concurrent_solvers_global_context_crashes,
        but using explicit z3.Context() per iteration.
        """
        stop_event = threading.Event()
        gc_thread = threading.Thread(
            target=_gc_pressure_thread_isolated,
            args=(stop_event, 100),
            daemon=True,
        )
        gc_thread.start()

        errors = []
        try:
            for iteration in range(50):
                try:
                    # Each iteration gets its own isolated context
                    ctx = Context()

                    items = [Int(f"item_{j}", ctx) for j in range(10)]
                    domain = And(*[And(v >= 1, v <= 5) for v in items])

                    P = items[0] == 1
                    s1 = Solver(ctx=ctx)
                    s1.add(domain, P)
                    result1 = s1.check()
                    self.assertEqual(result1, sat)

                    s2 = Solver(ctx=ctx)
                    s2.add(domain, Not(P))
                    result2 = s2.check()
                    self.assertEqual(result2, sat)

                    Q = items[1] <= items[0]
                    s3 = Solver(ctx=ctx)
                    s3.add(domain, P, Not(Q))
                    s3.check()

                    F = And(domain, Implies(P, Q))
                    s4 = Solver(ctx=ctx)
                    s4.add(F)
                    result4 = s4.check()
                    self.assertEqual(result4, sat)
                except Exception as e:
                    errors.append((iteration, str(e)))
        finally:
            stop_event.set()
            gc_thread.join(timeout=5)

        self.assertEqual(
            errors, [],
            f"Z3 with explicit context should NOT crash under GC pressure.\n"
            f"Errors:\n"
            + "\n".join(f"  iteration {i}: {e}" for i, e in errors[:5])
        )

    def test_parallel_solvers_with_explicit_contexts(self):
        """Multiple threads running Z3 solvers, each with its own context → safe.

        Simulates Portor's threads=2 or any multi-threaded scenario.
        Each thread creates its own z3.Context(), so there is no shared state.
        """
        errors = []
        lock = threading.Lock()

        def solver_work(thread_id: int, iterations: int):
            for i in range(iterations):
                try:
                    ctx = Context()
                    items = [Int(f"item_{j}", ctx) for j in range(10)]
                    domain = And(*[And(v >= 1, v <= 5) for v in items])

                    P = items[0] == 1
                    Q = items[1] <= items[0]

                    s = Solver(ctx=ctx)
                    s.add(domain, Implies(P, Q))
                    result = s.check()
                    assert result == sat, f"Expected sat, got {result}"
                except Exception as e:
                    with lock:
                        errors.append((thread_id, i, str(e)))

        threads = [
            threading.Thread(target=solver_work, args=(tid, 20))
            for tid in range(4)
        ]
        for t in threads:
            t.start()
        for t in threads:
            t.join(timeout=60)

        self.assertEqual(
            errors, [],
            f"Parallel Z3 with explicit contexts should NOT crash.\n"
            f"Errors:\n"
            + "\n".join(f"  thread {tid} iter {i}: {e}" for tid, i, e in errors[:5])
        )

    def test_explicit_context_produces_correct_results(self):
        """Verify that explicit context gives identical classification results.

        Manually runs the same Z3 checks as ItemClassifier using an explicit
        context, and verifies the results match the baseline.
        """
        ctx = Context()

        # Simulate classification.qml items
        q_always = Int("item_q_always", ctx)
        q_conditional = Int("item_q_conditional", ctx)
        q_never = Int("item_q_never", ctx)

        # Domain constraints B: Radio labels {1, 2}
        domain = And(
            And(q_always >= 1, q_always <= 2),
            And(q_conditional >= 1, q_conditional <= 2),
            And(q_never >= 1, q_never <= 2),
        )

        # q_always: no precondition → ALWAYS
        # UNSAT(B ∧ ¬True) → UNSAT(B ∧ False) → always UNSAT
        s = Solver(ctx=ctx)
        s.add(domain, BoolVal(False, ctx))
        self.assertEqual(s.check(), unsat)

        # q_conditional: precondition q_always.outcome == 1 → CONDITIONAL
        P_cond = q_always == 1
        s1 = Solver(ctx=ctx)
        s1.add(domain, P_cond)
        self.assertEqual(s1.check(), sat)  # SAT(B ∧ P)

        s2 = Solver(ctx=ctx)
        s2.add(domain, Not(P_cond))
        self.assertEqual(s2.check(), sat)  # SAT(B ∧ ¬P)

        # q_never: precondition q_always == 1 AND q_always == 2 → NEVER
        P_never = And(q_always == 1, q_always == 2)
        s3 = Solver(ctx=ctx)
        s3.add(domain, P_never)
        self.assertEqual(s3.check(), unsat)  # UNSAT(B ∧ P) → NEVER


# ===========================================================================
# SECTION C: Baseline (single-threaded, no GC pressure)
# ===========================================================================

@pytest.mark.integration
@pytest.mark.z3
class TestZ3Baseline(unittest.TestCase):
    """Baseline: ValidationProcessor works correctly without concurrency."""

    def test_validation_without_gc_pressure(self):
        """ValidationProcessor produces correct results in single-threaded mode."""
        state = load_qml_fixture("classification.qml")

        for _ in range(10):
            processor = ValidationProcessor(state)
            classifications = processor.get_item_classifications()

            self.assertIn("q_always", classifications)
            self.assertEqual(
                classifications["q_always"]["precondition"]["status"],
                "ALWAYS",
            )
            self.assertEqual(
                classifications["q_conditional"]["precondition"]["status"],
                "CONDITIONAL",
            )
            self.assertEqual(
                classifications["q_never"]["precondition"]["status"],
                "NEVER",
            )
