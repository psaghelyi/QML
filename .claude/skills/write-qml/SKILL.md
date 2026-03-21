---
name: write-qml
description: >
  Write QML (Questionnaire Markup Language) files for the Askalot survey platform.
  Use this skill whenever the user wants to create, write, generate, design, or convert
  a survey or questionnaire in QML format. This includes: designing new questionnaires
  from requirements or specifications, converting imperative GOTO-based questionnaires
  (CATI, paper surveys, legacy systems) into declarative QML, modifying or extending
  existing QML files, and translating regulations or compliance rules into survey form.
  Trigger on mentions of: QML, questionnaire creation, survey design, CATI conversion,
  skip patterns, branching logic, Askalot platform, or any request to build a survey
  with conditional logic.
---

# Writing QML Questionnaires

QML is a declarative, YAML-based language for formally verified questionnaires. A Z3 SMT
solver validates all logic automatically. Your job is to translate requirements into
constraints — the solver handles consistency checking.

## Core Philosophy: Declare Constraints, Not Flow

This is the single most important concept. Do NOT think in terms of "if the user answers X,
go to question Y." Instead think:

- **Preconditions**: "Question Y is relevant when X is true"
- **Postconditions**: "Answer Z must satisfy this constraint"
- **Code blocks**: "After this answer, update this classification variable"

The Z3 solver verifies that all paths are reachable, all constraints are satisfiable, and
there are no logical contradictions. You define **what must be true**, not **how to get there**.

## QML Structure

Every QML file follows this skeleton:

```yaml
qmlVersion: "1.0"
questionnaire:
  title: "Survey Title"
  codeInit: |
    # Initialize ALL global variables here
    score = 0
    category = 0
  blocks:
    - id: b_section_name
      title: "Section Title"
      items:
        - id: q_item_id
          kind: Question
          title: "Question text?"
          input:
            control: Radio
            labels:
              1: "Option A"
              2: "Option B"
```

Key structural rules:
- `qmlVersion: "1.0"` is required at root level
- At least one block, each block has at least one item
- All IDs must be unique across the entire questionnaire
- Convention: block IDs start with `b_`, question IDs with `q_`

## Item Kinds

| Kind | Purpose | Requires | Outcome Type |
|------|---------|----------|-------------|
| Comment | Display text, no response | Nothing extra | None |
| Question | Single answer | `input` block | Single integer |
| QuestionGroup | List of same-type questions | `questions` list + `input` | Vector of integers |
| MatrixQuestion | Grid of answers | `rows`, `columns` + `input` | Matrix of integers |

For QuestionGroup and MatrixQuestion details with examples, see `references/qml-full-reference.md`.

## Input Controls

Choose the right control for the data type:

| Use Case | Control | Required Properties |
|----------|---------|-------------------|
| Yes/No binary | Switch | `on`, `off` (label strings) |
| Precise number (age, count) | Editbox | `min`, `max` (integers) |
| Subjective scale (1-10) | Slider | `min`, `max`, optional `step` |
| Numeric interval (price range) | Range | `min`, `max`, optional `step` |
| Multiple selection | Checkbox | `labels` with **power-of-2 keys** |
| Single choice, 2-5 options | Radio | `labels` (int-to-string map) |
| Single choice, 6+ options | Dropdown | `labels` (int-to-string map) |
| Open-ended text | Textarea | optional `placeholder`, `maxLength` |

Critical rules:
- Checkbox keys MUST be powers of 2: `1, 2, 4, 8, 16, 32...` (bit mask encoding)
- Editbox/Slider/Range MUST have `min` and `max`
- Radio/Dropdown/Checkbox MUST have `labels`
- For MatrixQuestion cells: use Radio for 2-3 options, Dropdown for 4+
- All `labels` maps use integer keys, string values: `{1: "Yes", 2: "No"}`

Optional properties: `default` (preset value), `left`/`right` (prefix/suffix text for
Editbox, Slider, Dropdown).

## Conditional Logic

### Preconditions — When to Show an Item

```yaml
precondition:
  - predicate: q_age.outcome >= 18
  - predicate: q_consent.outcome == 1
```

Multiple predicates are AND-ed — all must be true. Use `and`/`or` within a single
predicate for complex logic:

```yaml
precondition:
  - predicate: q_age.outcome >= 18 and (q_employed.outcome == 1 or q_student.outcome == 1)
```

Blocks can also have preconditions — use this when an entire section should be skipped.

### Postconditions — Validation After Response

```yaml
postcondition:
  - predicate: q_children.outcome < q_household.outcome
    hint: "Number of children must be less than total household size"
  - predicate: q_end_date.outcome >= q_start_date.outcome
    hint: "End date must be on or after start date"
```

The `hint` is shown to the respondent when validation fails. Make hints specific and helpful.

## Code Blocks

### codeInit — Global Variable Setup

Runs once before the questionnaire starts. Initialize ALL variables here:

```yaml
questionnaire:
  codeInit: |
    total_score = 0
    risk_level = 0
    path = 0
    is_eligible = 0
```

### codeBlock — Per-Item Logic

Runs after an item's postcondition passes. Updates global variables:

```yaml
- id: q_smoking
  kind: Question
  title: "Do you smoke?"
  input:
    control: Switch
    off: "No"
    on: "Yes"
  codeBlock: |
    if q_smoking.outcome == 1:
        risk_level = risk_level + 3
```

### Z3-Verifiable Python Subset

Code blocks are analyzed by the Z3 SMT solver. Only use these features:

**Allowed:**
- Arithmetic: `+`, `-`, `*`, `//`, `%`
- Comparisons: `<`, `<=`, `>`, `>=`, `==`, `!=`
- Boolean: `and`, `or`, `not`
- Control: `if`/`elif`/`else`, `for` with `range(n)` where n <= 20
- Assignment: `=`, `+=`, `-=`, `*=`, `//=`
- Membership: `in`, `not in` with literal containers like `[1, 2, 3]`
- Built-ins: `range()`, `int()`, `bool()` only
- Outcome access: `q_item.outcome`, `qg_item.outcome[i]`, `mq_item.outcome[i][j]`

**NOT allowed — these silently return 0 in the solver, creating unverifiable logic:**
- `len()`, `sum()`, `max()`, `min()`, `abs()` — all return 0
- `list.append()`, any method calls — return 0
- List comprehensions, lambda, dict literals
- String methods, subscript on regular variables
- `while` loops, `break`, `continue`
- Functions, classes, imports

Instead of `sum()`, add values explicitly:
```yaml
codeBlock: |
  total = qg_ratings.outcome[0] + qg_ratings.outcome[1] + qg_ratings.outcome[2]
```

### Execution Order (Important)

For each item, processing happens in this strict sequence:
1. **Precondition** evaluated — can reference prior outcomes and variables
2. **Outcome collected** — respondent answers
3. **Postcondition** evaluated — can reference current item's outcome, but variables
   still hold values from BEFORE this item's codeBlock
4. **CodeBlock** executed — updates variables for subsequent items

This means: a postcondition on the same item whose codeBlock updates a variable will see
the variable's OLD value, not the updated one.

## Converting GOTO-Based Questionnaires to QML

Many legacy questionnaires use imperative "If X, go to Y" patterns. Here are the five
core conversion patterns. For detailed examples with real Statistics Canada questionnaires,
see `references/goto-conversion-guide.md`.

### Pattern 1: "If X, go to Y" becomes a Precondition on Y

The most common pattern. Instead of routing FROM the gate question, put a precondition ON
the target question:

```
IMPERATIVE: Q1 "Do you smoke?" → If Yes, go to Q3. If No, go to Q5.
```

```yaml
- id: q_smoke
  kind: Question
  title: "Do you smoke?"
  input:
    control: Switch
    off: "No"
    on: "Yes"

- id: q_cigarettes    # was Q3 — only for smokers
  precondition:
    - predicate: q_smoke.outcome == 1
  ...

- id: q_exercise      # was Q5 — shown to everyone
  ...
```

### Pattern 2: PATH/Classification Variable Routing

When the original uses a routing variable to direct respondents to different sections,
model it with `codeInit` + `codeBlock` + preconditions:

```yaml
codeInit: |
  path = 0

# Classification question sets the path
- id: q_employment
  codeBlock: |
    if q_employment.outcome == 1:
        path = 1    # employed
    elif q_looking.outcome == 1:
        path = 2    # job seeker
    else:
        path = 3    # not in labour force

# Later items reference the path variable
- id: q_employer_details
  precondition:
    - predicate: path == 1
```

**Warning — variable feedback loops:** If item A reads variable `path` in its precondition,
and a downstream item B (that depends on A) writes back to `path` in its codeBlock, the Z3
validator will detect a dependency cycle. This is a real problem in the original questionnaire
design — see `references/goto-conversion-guide.md` for solutions.

### Pattern 3: "Skip to end of section" becomes Block-Level Precondition

```yaml
- id: b_employment_details
  title: "Employment Details"
  precondition:
    - predicate: q_age.outcome >= 16
    - predicate: q_age.outcome <= 65
  items:
    - ...  # entire block skipped if age outside range
```

### Pattern 4: Cross-Checks become Postconditions

```
IMPERATIVE: "CATI CHECK: Q5 must be <= Q3. If not, return to Q3."
```

```yaml
- id: q5_experience
  postcondition:
    - predicate: q5_experience.outcome <= q3_age.outcome - 16
      hint: "Work experience cannot exceed years since age 16"
  ...
```

### Pattern 5: Converging Paths Need No Special Handling

When multiple GOTO branches converge at the same question:
- If the question applies to everyone → no precondition needed
- If it applies to a subset → use an OR combining the path conditions:

```yaml
precondition:
  - predicate: path == 1 or path == 2 or discouraged_worker == 1
```

### Pattern 6: Intermediate Filter Gates (Commonly Missed)

CATI questionnaires often have hidden "filter" checks — e.g., "if fewer than 5 symptoms
reported, skip the diagnostic section." These appear as interviewer instructions, not as
GOTO statements, making them easy to miss. Model them with a counter variable:

```yaml
codeInit: |
  symptom_count = 0

# Each symptom question increments the counter in its codeBlock
- id: q_symptom_1
  codeBlock: |
    if q_symptom_1.outcome == 1:
        symptom_count = symptom_count + 1

# Gate the detailed section on the count
- id: q_severity
  precondition:
    - predicate: symptom_count >= 5
```

For more examples including severity gates, roster/loop structures, and composite score
routing, see `references/goto-conversion-guide.md`.

## Validation Checklist

Before outputting the QML, verify every point:

1. Every Question, QuestionGroup, MatrixQuestion has an `input` block
2. Every Editbox, Slider, Range has `min` and `max`
3. Every Radio, Dropdown, Checkbox has `labels`
4. Every Checkbox uses power-of-2 keys (1, 2, 4, 8, 16...)
5. All item and block IDs are unique
6. All variables referenced in predicates are initialized in `codeInit` or prior codeBlocks
7. Producer items appear before consumer items (items that set a variable come before items
   that reference it in preconditions)
8. No unsupported Python features in code blocks (no len, sum, max, min, append, etc.)
9. Postcondition hints are specific and user-friendly
10. Multiple precondition predicates correctly express AND logic (use `or` within a single
    predicate for OR logic)
11. Filter/screener gates are modeled — if the source has "if count < N, skip section",
    add a counter variable and precondition (see Pattern 6)
12. "Other (specify)" options have a Textarea follow-up with a precondition
13. PATH-like variables are not both read in preconditions AND written in downstream
    codeBlocks (use separate variables for initial and refined classification)
14. Age boundaries match the source exactly (watch for off-by-one: >= 15 vs >= 16)
15. Waterfall/cascade patterns ("first YES wins") use direct outcome references in
    preconditions, NOT a shared routing variable. A shared variable that's both read in
    preconditions and written in codeBlocks by items in the same cascade creates dependency
    cycles (see Pitfall 9 below)

## Workflow

1. **Understand requirements** — Ask clarifying questions about the survey's purpose,
   target audience, and conditional logic
2. **Build question inventory** (for large sources, 20+ pages) — Before writing any QML,
   read the entire source document and build a structured inventory of every question node.
   For each question, record: ID/number, section, question text, response options with codes,
   skip/routing instruction, and any interviewer notes. Count total substantive questions —
   this count is your completeness target. Write the inventory to a file (e.g.,
   `question_inventory.md`) so it can be referenced during QML generation. This step is
   critical for sources with 50+ questions — it prevents missed questions and ensures the
   block structure reflects the source's organization.
3. **Design block structure** — Group related questions into logical sections
4. **Choose controls** — Match each question to the right input control type
5. **Write items** — Create each item with appropriate kind and input
6. **Add preconditions** — Define when each conditional question appears
7. **Add postconditions** — Define validation constraints with helpful hints
8. **Add code blocks** — Implement scoring, classification, or routing variables
9. **Initialize variables** — Ensure all variables are declared in `codeInit`
10. **Validate** — Run through the checklist above
11. **Save** — Use `save_qml_file` (Askalot MCP) or write the file locally

## Validation

### Local Validation Script

After writing a QML file, validate it using the bundled script. It runs all four formal
verification steps from the thesis validation hierarchy:

```bash
cd /root/QML && \
uv run python .claude/skills/write-qml/scripts/validate_qml.py <path-to-qml-file> [--json]
```

The four verification steps (always run in order):

1. **Per-item classification** — Witness formula W_i = B ∧ P_i ∧ ¬Q_i
   Classifies each item's precondition reachability (ALWAYS/CONDITIONAL/NEVER) and
   postcondition invariant (TAUTOLOGICAL/CONSTRAINING/INFEASIBLE/NONE).
   Detects NEVER reachable items and INFEASIBLE postconditions.

2. **Global satisfiability** — F = B ∧ ∧(P_i ⇒ Q_i)
   Checks whether at least one valid questionnaire completion exists.
   UNSAT means accumulated postconditions conflict — no execution path is valid.

3. **Dependency loops** — QMLTopology with stable Kahn's algorithm
   Builds the dependency graph and detects cycles via Z3 ordering constraints
   and Kahn's algorithm. Cycles indicate variable feedback loops.

4. **Path-based reachability** — A_i = B ∧ ∧{j∈Pred(i)}(P_j ⇒ Q_j)
   For each CONDITIONAL item, checks accumulated reachability under predecessor
   postconditions. Detects dead code that per-item and global checks miss.

Use `--json` for machine-readable output. Exit code 0 = valid, 1 = issues found, 2 = error.

Always run validation after writing a QML file.

### Platform Validation via MCP

When working with the Askalot platform:

- `list_qml_files` — See available QML definitions
- `inspect_qml_file` — Quick summary of a QML file
- `get_qml_content` — Read the full YAML source
- `save_qml_file` — Save a new or updated QML file
- `validate_qml_file` — Run Z3 validation to check for structural problems
- `publish_qml_file` / `unpublish_qml_file` — Control questionnaire availability

## Reference Files

For detailed information beyond what's covered here:

- **`references/qml-full-reference.md`** — Complete syntax reference with all control
  properties, QuestionGroup/MatrixQuestion examples, and the full JSON schema summary.
  Read this when working with complex item types or unusual control configurations.

- **`references/goto-conversion-guide.md`** — Detailed GOTO-to-declarative conversion
  patterns with real-world examples from 10 Statistics Canada CATI questionnaires. Read this
  when converting an existing imperative questionnaire to QML. Covers 9 conversion patterns
  (including intermediate filter gates, roster/loop structures, composite score routing),
  variable feedback loops with the snapshot solution, and 8 common pitfalls with frequencies
  observed across real conversions.
