# Thesis Documentation - CLAUDE.md

This directory contains the LaTeX source for the thesis: **"Formal Verification of Questionnaire Logic: Designing and Checking Surveys with SMT-Based Analysis"**

## Purpose

Provides the **mathematical foundations** for Askalot's questionnaire validation. Demonstrates how SMT solving guarantees survey correctness through formal methods inspired by Hoare Logic - treating questionnaires as items with preconditions and postconditions rather than traditional sequential flows.

## Academic Context

- **Institution**: Eötvös Loránd University (ELTE), Faculty of Informatics
- **Department**: Dept. of Software Technology and Methodology
- **Author**: Péter Sághelyi
- **Supervisor**: Péter Bereczky (Assistant Lecturer)
- **Year**: 2025

## Directory Structure

- [fpx3h0_en.tex](fpx3h0_en.tex) - Main thesis document
- [fpx3h0.bib](fpx3h0.bib) - Bibliography references
- [chapters/](chapters/) - Individual chapter files
- [Makefile](Makefile) - Build automation (run `make help` for targets)

## Thesis Chapters

### [Abstract](chapters/abstract.tex)
Declarative questionnaire model with preconditions/postconditions, Z3 SMT solver for mathematical correctness guarantees.

### [Introduction](chapters/intro.tex)
- Key concepts: preconditions, skip logic, accessibility, postconditions (edit rules), contradictions
- Problem: AI-generated questionnaires need formal verification beyond human capacity
- History: Picard (1965) → Willenborg's NP-completeness (1995) → Feeney (2019)
- Shift from imperative (mutable state) to declarative paradigm (constraint-based)

### [Related Work](chapters/related_work.tex)
- SMT technology: SAT, DPLL(T) architecture, theory combination
- Z3 Theorem Prover and its Python API
- Prior approaches: TADEQ (graph-based), Feeney (path enumeration), Fellegi-Holt (edit rules)

### [Questionnaire Definition](chapters/definitions.tex)
- Building blocks: items, outcome variables, domain constraints, preconditions, postconditions
- Formal questionnaire tuple structure
- Reachability classification: ALWAYS, NEVER, CONDITIONAL
- Postcondition classification: VACUOUS, TAUTOLOGICAL, CONSTRAINING, INFEASIBLE
- Dependency graph via Kahn's algorithm, cycle detection
- Complex types: scalar, vector, matrix with ranking/allocation constraints

### [Questionnaire Compilation](chapters/compilation.tex)
- SSA transformation for Z3's immutable variables
- Phi functions for conditional branching
- Bounded loop unrolling (max 20 iterations)
- Pragmatic compiler: questionnaire-first validation, graceful degradation
- Z3 array theory for vectors/matrices

### [Comprehensive Questionnaire Validation](chapters/comprehensive_validation.tex)
- Global satisfiability formula and witness formula
- Key theorems: soundness of per-item validity, local vs global validity relationships
- Path-based validation for dead code detection
- Validation hierarchy: per-item → global → path-based

### [Conclusion](chapters/closing.tex)
- Contributions: formal framework, QML language, validation algorithms
- Impact: enabling AI-aided generation through separation of concerns
- Limitations: Python subset, bounded analysis, scalability
- Future: extended language support, dynamic analysis, incremental validation

### [Appendix](chapters/appendix.tex)
Practical QML examples: employee satisfaction (vectors), product comparison (matrices), market research (combined types).

## Key References

**Foundational**: De Moura & Bjørner (Z3), Hoare (axiomatic programming), King (symbolic execution), Cytron (SSA)

**SMT/Formal Methods**: Barrett (CVC4), Clarke (bounded model checking), Nieuwenhuis (DPLL(T))

**Questionnaire**: Willenborg (NP-completeness), Fellegi-Holt (edit rules), Bethlehem (TADEQ), Feeney (path enumeration)

## Building

Run `make help` for available targets. Key commands: `make` (full build), `make draft` (quick), `make clean`.

## Core Mathematical Concepts

**Questionnaire structure**: Tuple of items, outcome variables, domain constraints, preconditions, postconditions, start item.

**Validation approach**: Global satisfiability checks whether domain constraints combined with all precondition-implies-postcondition implications are satisfiable.

**Classifications**: Items classified by reachability (always/never/conditional) and postcondition behavior (vacuous/tautological/constraining/infeasible).

## Integration with Askalot

- [askalot_qml/](../../askalot_qml/) - Implements thesis algorithms
- Dependency graph analysis → [qml_topology.py](../../askalot_qml/core/qml_topology.py)
- Python-to-Z3 compilation → [pragmatic_compiler.py](../../askalot_qml/z3/pragmatic_compiler.py)
- Validation hierarchy → [item_classifier.py](../../askalot_qml/z3/item_classifier.py), [global_formula.py](../../askalot_qml/z3/global_formula.py), [path_based_validation.py](../../askalot_qml/z3/path_based_validation.py)
- QML schema → [qml-schema.json](../../askalot_qml/schema/qml-schema.json)

## Key Insights for Claude Code

1. **Mathematical Rigor**: All claims are formally proven
2. **Declarative Paradigm**: Emphasizes declarative over imperative - guides platform design
3. **Hoare Logic Inspiration**: Preconditions/postconditions are central concepts
4. **Validation Hierarchy**: Know when per-item, global, or path-based validation applies
5. **Complex Types**: Vector/matrix questions require special Z3 handling
