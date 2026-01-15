## Overview

The **askalot_qml** module provides Z3-driven questionnaire analysis capabilities with two distinct processors:

- **FlowProcessor**: Runtime questionnaire traversal for conducting interviews
- **AnalysisProcessor**: Offline static analysis for questionnaire validation

Both processors share a common pipeline through QMLEngine that handles dependency graph construction and topological sorting.

## Module Structure

```
askalot_qml/
├── api/                           # Flask blueprints for web services
│   ├── analysis_blueprint.py     # Static analysis endpoints
│   └── flow_blueprint.py         # Flow navigation endpoints
├── core/                          # Core processing engines
│   ├── analysis_processor.py     # Static analysis with Z3 classification
│   ├── flow_processor.py         # Runtime navigation
│   ├── python_runner.py          # Safe Python code execution
│   ├── qml_diagram.py            # Mermaid diagram generation
│   ├── qml_engine.py             # Common pipeline orchestrator
│   ├── qml_loader.py             # QML file loading
│   └── qml_topology.py           # Dependency graph and topological sort
├── models/                        # Data models
│   ├── item_proxy.py             # Runtime item wrapper for code blocks
│   ├── questionnaire_state.py    # Survey state management
│   └── table.py                  # Matrix question support
└── z3/                           # Z3 constraint solving
    ├── global_formula.py         # Global satisfiability check (Level 2)
    ├── item_classifier.py        # Per-item Z3 classification (Level 1)
    ├── path_based_validation.py  # Accumulated reachability / dead code (Level 3)
    ├── pragmatic_compiler.py     # AST to Z3 constraint compilation
    └── static_builder.py         # SSA versioning and constraint generation
```

## Formal Foundation

The module implements formal verification concepts from the thesis [docs/thesis/chapters/comprehensive_validation.tex](docs/thesis/chapters/comprehensive_validation.tex):

### Questionnaire Definition

A questionnaire is a tuple G = (I, S, D, P, Q, I_start) where:
- **I**: Finite set of items
- **S**: Vector of outcome variables
- **D**: Domain constraints for each outcome
- **P**: Preconditions (Boolean formulas determining item visibility)
- **Q**: Postconditions (Boolean formulas constraining valid responses)

### Base Constraint

B := conjunction of all domain constraints D_i(S_i)

### Validation Hierarchy

Three levels of increasing thoroughness, implemented in the `z3/` module:

| Level | Formula | Implementation | Purpose |
|-------|---------|----------------|---------|
| **Per-item** | W_i = B ∧ P_i ∧ ¬Q_i | [item_classifier.py](askalot_qml/z3/item_classifier.py) | Detect NEVER reachable and INFEASIBLE items |
| **Global** | F = B ∧ ∧(P_i ⇒ Q_i) | [global_formula.py](askalot_qml/z3/global_formula.py) | Detect conflicting postconditions |
| **Path-based** | A_i = B ∧ ∧{j∈Pred(i)}(P_j ⇒ Q_j) | [path_based_validation.py](askalot_qml/z3/path_based_validation.py) | Detect dead code (unreachable items) |

**Relationships between levels:**
- **Per-item passes → Global passes**: If all W_i are UNSAT, then SAT(F) is guaranteed (Theorem: Soundness)
- **Global fails → Path-based fails**: If UNSAT(F), no execution path is valid (Theorem: Global Necessary)
- **Global passes ↛ All paths valid**: SAT(F) doesn't guarantee all items reachable (Theorem: Global Not Sufficient)

**When each level suffices:**
- **Per-item** suffices when all postconditions are TAUTOLOGICAL
- **Global** suffices when you only need to verify some valid completion exists
- **Path-based** is needed to detect dead code (CONDITIONAL items made unreachable by accumulated constraints)

## FlowProcessor - Runtime Navigation

**Purpose**: Conduct interactive interviews by traversing the questionnaire graph.

**File**: [core/flow_processor.py](askalot_qml/core/flow_processor.py)

### Responsibilities

1. **Initialize questionnaire state** - Execute codeInit, create ItemProxy instances, set up navigation path
2. **Navigate forward/backward** - Follow topological order, evaluate preconditions, track history
3. **Process item responses** - Validate postconditions, execute code blocks, propagate state
4. **Generate flow diagrams** - Visualize current position with visited/pending coloring

### State Management Architecture

The QuestionnaireState ([models/questionnaire_state.py](askalot_qml/models/questionnaire_state.py)) maintains:

- **items[]**: Flat list of all questionnaire items
- **history[]**: Navigation history (item IDs visited in order)
- **navigation_path[]**: Pre-computed topological order from Z3 analysis
- **Per-item context**: Variable state AFTER each item's execution

Each item stores:
- **outcome**: User's response value
- **visited**: Whether item has been completed
- **disabled**: Whether item is skipped
- **context**: Dictionary of Python variables at this execution point

This architecture enables **pause/resume** of interviews: by storing the context at each item, we can restore the exact Python state when resuming a survey.

### Navigation Strategy

**Forward Navigation** (no Z3 at runtime):
1. Iterate through pre-computed navigation_path (topological order)
2. Skip disabled and visited items (unless last in path)
3. Evaluate preconditions via Python eval (NOT Z3)
4. Return first item with satisfied preconditions
5. Track item in history for backward navigation

**Backward Navigation**:
1. Pop current item from history stack
2. Mark item as unvisited
3. Restore previous item's context
4. Return to previous item

**Item Processing**:
1. Clone current item's context
2. Populate context with ItemProxy instances for all items
3. Validate postcondition - return hint message if failed
4. Execute codeBlock via PythonRunner
5. Update outcomes for modified items
6. Propagate variables to subsequent items' contexts

### Performance Characteristics

- Z3 used **once** at initialization for dependency graph
- Preconditions evaluated via Python eval (fast)
- No Z3 classification during navigation
- Base diagram cached for reuse

## AnalysisProcessor - Static Analysis

**Purpose**: Validate questionnaire design by detecting structural problems before deployment.

**File**: [core/analysis_processor.py](askalot_qml/core/analysis_processor.py)

### Responsibilities

1. **Per-item classification** - Determine reachability and postcondition effects
2. **Global formula check** - Verify at least one valid completion exists
3. **Path-based analysis** - Detect dead code from accumulated constraints
4. **Generate analysis diagrams** - Visualize classification results with semantic coloring

### Per-Item Classification

The ItemClassifier ([z3/item_classifier.py](askalot_qml/z3/item_classifier.py)) computes:

**Precondition Reachability**:
| Status | Condition | Meaning |
|--------|-----------|---------|
| ALWAYS | UNSAT(B ∧ ¬P) | Item always shown |
| CONDITIONAL | SAT(B ∧ P) and SAT(B ∧ ¬P) | Item sometimes shown |
| NEVER | UNSAT(B ∧ P) | Item never reachable (dead code) |

**Postcondition Invariant** (relative to precondition P):
| Status | Condition | Meaning |
|--------|-----------|---------|
| TAUTOLOGICAL | UNSAT(B ∧ P ∧ ¬Q) | Postcondition always holds when reached |
| CONSTRAINING | Both SAT for (B ∧ P ∧ Q) and (B ∧ P ∧ ¬Q) | Postcondition filters some responses |
| INFEASIBLE | UNSAT(B ∧ P ∧ Q) | Postcondition can never be satisfied (design error) |
| NONE | No postcondition defined | No validation constraints |

### Analysis Diagram Coloring

| Color | Class | Meaning |
|-------|-------|---------|
| Green | always | ALWAYS reachable |
| Yellow | conditional | CONDITIONAL reachability |
| Red | never | NEVER reachable |
| Purple | infeasible | INFEASIBLE postcondition |
| Blue | tautological | TAUTOLOGICAL postcondition |

## Common Pipeline

Both processors share the QMLEngine ([core/qml_engine.py](askalot_qml/core/qml_engine.py)) which provides:

### StaticBuilder

**File**: [z3/static_builder.py](askalot_qml/z3/static_builder.py)

- Parses preconditions, postconditions, and code blocks
- Generates Z3 constraints using SSA (Static Single Assignment) versioning
- Discovers item dependencies through constraint analysis
- Creates frozen base constraint (B) for classification

### QMLTopology

**File**: [core/qml_topology.py](askalot_qml/core/qml_topology.py)

- Builds dependency graph from StaticBuilder's constraint analysis
- Computes topological order via Kahn's algorithm with priority queue
- Provides dependency layers and connected components

**Stable Topological Ordering**: Uses a min-heap keyed by original QML file index. When multiple items are available (in_degree = 0), the one appearing earliest in the QML file is always processed first. This ensures deterministic ordering that respects the author's intended item sequence.

**Dual Cycle Detection**: Uses two complementary methods for robustness:

1. **Z3 satisfiability check** - Creates ordering variables for each item with constraints `order(A) > order(B)` for each dependency A→B. If UNSAT, no valid ordering exists (cycles present).

2. **Kahn's algorithm verification** - If the algorithm doesn't process all items, cycles exist. This serves as a fallback verification.

When cycles are detected, DFS is used to find the actual cycle paths for error reporting.

### QMLDiagram

**File**: [core/qml_diagram.py](askalot_qml/core/qml_diagram.py)

Implements separated diagram generation:
1. **Base diagram** (cacheable): Structure only - items, variables, preconditions, postconditions
2. **Dynamic coloring**: Applied at runtime based on mode (flow or analysis)

## QML Language

QML files are YAML-based questionnaire specifications. See [docs/thesis/presentation/slides.md](docs/thesis/presentation/slides.md) for examples.

Key elements:
- **codeInit**: Global initialization code block
- **blocks**: Logical groupings of items
- **items**: Questions, comments, or groups with:
  - **precondition**: List of predicates determining visibility
  - **postcondition**: List of predicates with hints for validation
  - **codeBlock**: Python code executed after response

## API Endpoints

### Flow Blueprint

- `GET /api/flow/current-item` - Get current item in navigation
- `POST /api/flow/evaluate-item` - Process user response
- `GET /api/flow/previous-item` - Navigate backward
- `GET /api/flow/diagram` - Get flow diagram with current item highlighted
- `GET /api/flow/navigation-path` - Get complete navigation path

### Analysis Blueprint

- `GET /api/qml/analysis` - Full analysis with Z3 classification
- `GET /api/qml/validate` - Validate QML structure
- `GET /api/qml/files` - List available QML files

## Security

The PythonRunner ([core/python_runner.py](askalot_qml/core/python_runner.py)) provides sandboxed code execution:

- **Allowed modules**: math, random, statistics, itertools, functools, collections, re
- **Forbidden constructs**: Import, AsyncFunctionDef, ClassDef, eval, exec, compile, open, os, sys
- **AST validation**: Code is validated before execution

## Testing

Test files are located in `tests/unit/` and `tests/integration/`. Run with:

```bash
make test           # All tests
make test-unit      # Unit tests only
make test-integration  # Integration tests only
```

## Development Notes

### Import Patterns

```python
# Top-level imports (recommended)
from askalot_qml import FlowProcessor, AnalysisProcessor, QuestionnaireState

# Explicit imports
from askalot_qml.core import FlowProcessor, AnalysisProcessor
from askalot_qml.z3 import StaticBuilder, ItemClassifier
```

### Debugging

Both processors provide `debug_dump()` methods for diagnostic output.
