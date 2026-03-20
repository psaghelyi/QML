# Converting GOTO-Based Questionnaires to Declarative QML

## Table of Contents

1. [The Fundamental Shift](#the-fundamental-shift)
2. [Pattern 1: Simple GOTO → Precondition](#pattern-1-simple-goto--precondition)
3. [Pattern 2: PATH Variable Routing](#pattern-2-path-variable-routing)
4. [Pattern 3: Section Skips → Block Preconditions](#pattern-3-section-skips--block-preconditions)
5. [Pattern 4: Cross-Checks → Postconditions](#pattern-4-cross-checks--postconditions)
6. [Pattern 5: Converging Paths](#pattern-5-converging-paths)
7. [Pattern 6: Chain Dependencies](#pattern-6-chain-dependencies)
8. [Pattern 7: Intermediate Filter Gates](#pattern-7-intermediate-filter-gates)
9. [Pattern 8: Roster/Loop Structures](#pattern-8-rosterloop-structures)
10. [Pattern 9: Composite Score Gates](#pattern-9-composite-score-gates)
11. [Variable Feedback Loops](#variable-feedback-loops)
12. [Common Pitfalls](#common-pitfalls)
13. [Real-World Examples](#real-world-examples)

---

## The Fundamental Shift

Imperative questionnaires (CATI, paper) specify **where to go next**:
```
Q1: "Do you smoke?" → If Yes, go to Q3. If No, go to Q5.
```

Declarative QML specifies **when each question is relevant**:
```yaml
q_cigarettes:
  precondition: q_smoke.outcome == 1    # "I'm relevant when they smoke"
q_exercise:
  # No precondition — I'm always relevant
```

The key insight: in the imperative version, the logic lives at the SOURCE question
("from Q1, go to..."). In the declarative version, the logic lives at the TARGET
question ("Q3 appears when..."). This inversion is the core of every conversion.

## Pattern 1: Simple GOTO → Precondition

### Single-branch skip

```
IMPERATIVE:
Q10: "Are you employed?" If No, go to Q20.
Q11: "What is your job title?"
Q12: "Years at current job?"
...
Q20: "What is your education level?"
```

```yaml
- id: q_employed
  kind: Question
  title: "Are you employed?"
  input:
    control: Switch
    off: "No"
    on: "Yes"

- id: q_job_title
  kind: Question
  title: "What is your job title?"
  precondition:
    - predicate: q_employed.outcome == 1
  input:
    control: Dropdown
    labels:
      1: "Manager"
      2: "Professional"
      3: "Technician"
      4: "Clerical"
      5: "Other"

- id: q_years_at_job
  kind: Question
  title: "Years at current job?"
  precondition:
    - predicate: q_employed.outcome == 1
  input:
    control: Editbox
    min: 0
    max: 50

- id: q_education    # Q20 — no precondition, shown to everyone
  kind: Question
  title: "What is your education level?"
  input:
    control: Dropdown
    labels:
      1: "High School"
      2: "Bachelor's"
      3: "Master's"
      4: "Doctorate"
```

Note: Q11 and Q12 each need their OWN precondition. Items don't inherit preconditions
from siblings — each must carry its own complete condition.

### Multi-branch routing

```
IMPERATIVE:
Q5: "Employment status?"
  1=Full-time → go to Q10
  2=Part-time → go to Q10
  3=Unemployed → go to Q20
  4=Retired → go to Q30
  5=Student → go to Q40
```

```yaml
- id: q_employment_status
  kind: Question
  title: "What is your employment status?"
  input:
    control: Radio
    labels:
      1: "Full-time"
      2: "Part-time"
      3: "Unemployed"
      4: "Retired"
      5: "Student"

# Q10 section — for employed (full-time or part-time)
- id: q_employer_size
  precondition:
    - predicate: q_employment_status.outcome in [1, 2]
  ...

# Q20 section — for unemployed
- id: q_months_unemployed
  precondition:
    - predicate: q_employment_status.outcome == 3
  ...

# Q30 section — for retired
- id: q_retirement_age
  precondition:
    - predicate: q_employment_status.outcome == 4
  ...

# Q40 section — for students
- id: q_school_type
  precondition:
    - predicate: q_employment_status.outcome == 5
  ...
```

## Pattern 2: PATH Variable Routing

Many CATI systems use a classification variable (often called PATH, STATUS, or TYPE) that
gets set early and controls routing for the rest of the survey. This maps to codeInit +
codeBlock + preconditions.

### The basic pattern

```
IMPERATIVE:
Q100: "Did you work last week?" If Yes, PATH=1, go to Q110.
Q101: "Did you have a job?" If Yes, PATH=2, go to Q130.
Q103: "Were you on temporary layoff?" If Yes, PATH=3, go to Q132.
Q170: "Did you look for work?" If Yes, PATH=4, go to Q171.
  Otherwise PATH=6, go to Q500.
```

```yaml
questionnaire:
  codeInit: |
    path = 0

  blocks:
    - id: b_classification
      items:
        - id: q100_worked
          kind: Question
          title: "Did you work at a job or business last week?"
          input:
            control: Switch
            off: "No"
            on: "Yes"
          codeBlock: |
            if q100_worked.outcome == 1:
                path = 1

        - id: q101_had_job
          kind: Question
          title: "Did you have a job or business from which you were absent?"
          precondition:
            - predicate: q100_worked.outcome == 0
          input:
            control: Switch
            off: "No"
            on: "Yes"
          codeBlock: |
            if q101_had_job.outcome == 1:
                path = 2

        - id: q103_layoff
          kind: Question
          title: "Were you on temporary layoff?"
          precondition:
            - predicate: q100_worked.outcome == 0
            - predicate: q101_had_job.outcome == 0
          input:
            control: Switch
            off: "No"
            on: "Yes"
          codeBlock: |
            if q103_layoff.outcome == 1:
                path = 3

    - id: b_employed_details
      title: "Employment Details"
      precondition:
        - predicate: path == 1
      items:
        - id: q110_class_of_worker
          kind: Question
          title: "In this job, is the person an employee or self-employed?"
          input:
            control: Radio
            labels:
              1: "Employee"
              2: "Self-employed"
```

### When the PATH variable gets complex

In the real Statistics Canada LFS, the PATH variable (values 1-7) serves as both a
classification AND a routing mechanism. This dual use can create problems:

- **Undefined intermediate states**: If no classification branch fires, PATH stays at 0.
  In imperative GOTO, this is fine — the GOTO carries the respondent forward. In QML,
  blocks with `path == 3 or path == 4` won't match path=0.

- **Cross-block writes**: Multiple items across different blocks write to the same PATH
  variable, creating potential dependency cycles (see below).

**Solution**: Initialize the variable with a clear default and ensure every classification
branch sets it:

```yaml
codeInit: |
  path = 0    # 0 = unclassified (handle explicitly in preconditions)
```

## Pattern 3: Section Skips → Block Preconditions

When the GOTO says "skip this entire section":

```
IMPERATIVE:
"If age < 16 or age > 65, skip Labour Force section."
```

```yaml
- id: b_labour_force
  title: "Labour Force"
  precondition:
    - predicate: q_age.outcome >= 16
    - predicate: q_age.outcome <= 65
  items:
    - ...    # entire block skipped if age outside range
```

Use block-level preconditions when ALL items in the block share the same gate condition.
Use item-level preconditions when items within the block have different conditions.

## Pattern 4: Cross-Checks → Postconditions

CATI systems often have "edit checks" — validation rules that fire after an answer:

```
IMPERATIVE:
CATI CHECK at Q136: "If Q136 > 52, display error: layoff cannot exceed 52 weeks"
CATI CHECK at Q155: "If Q153 + Q154 + Q155 > Q152, display error"
```

```yaml
- id: q136_weeks_layoff
  postcondition:
    - predicate: q136_weeks_layoff.outcome <= 52
      hint: "Layoff duration cannot exceed 52 weeks"
  input:
    control: Editbox
    min: 0
    max: 100

- id: q155_unpaid_extra
  postcondition:
    - predicate: q153_paid_overtime.outcome + q154_unpaid_overtime.outcome + q155_unpaid_extra.outcome <= q152_actual_hours.outcome
      hint: "Overtime and extra hours cannot exceed total actual hours worked"
  input:
    control: Editbox
    min: 0
    max: 80
```

### "Hard edit" vs "Soft edit"

CATI systems distinguish hard edits (must fix) from soft edits (warning only):
- **Hard edits** → postconditions (the item won't accept the answer until valid)
- **Soft edits** → generally omit from QML, or convert to postconditions if the
  constraint is important for data quality

### Contradictory state prevention

Some CATI systems allow contradictory answers and resolve them via interviewer intervention:

```
CATI: V11="Were you assaulted?" → Yes
CATI: V15="How were you assaulted?" → option (n) "Not attacked/assaulted"
CATI HARD EDIT: "Earlier you said you were attacked but..."
```

In QML, PREVENT the contradiction with a postcondition instead of allowing and correcting:

```yaml
- id: v15_how_assaulted
  precondition:
    - predicate: v11_assaulted.outcome == 1
  postcondition:
    - predicate: v15_how_assaulted.outcome != 8    # 8 = "Not attacked"
      hint: "You indicated an assault occurred. Please select how you were assaulted."
  input:
    control: Radio
    labels:
      1: "Punched/kicked"
      2: "Hit with object"
      3: "Pushed/grabbed"
      8: "Not attacked/assaulted"
```

Or better: simply remove the contradictory option from the labels if it's always
invalid when the precondition is met.

## Pattern 5: Converging Paths

When multiple GOTO branches converge at the same question, the conversion depends on
whether ALL paths or SOME paths reach it:

### All paths converge (no precondition needed)

```
IMPERATIVE:
Q3: If Yes → Q5. If No → Q5. (Both go to Q5)
```

```yaml
- id: q5    # No precondition — everyone reaches this
  ...
```

### Some paths converge (OR precondition)

```
IMPERATIVE:
PATH=1: go to Q200
PATH=2: go to Q200
PATH=3: go to Q300 (different section)
PATH=4: go to Q200
```

```yaml
- id: q200
  precondition:
    - predicate: path == 1 or path == 2 or path == 4
  ...
```

### Extra routing variable for special cases

Sometimes a GOTO bypasses the normal PATH routing:

```
IMPERATIVE:
Q178: If "Believes no work available" → go to Q190 (regardless of PATH)
```

This requires an additional variable because `path` alone can't express it:

```yaml
codeInit: |
  path = 0
  discouraged_worker = 0

- id: q178_reason
  codeBlock: |
    if q178_reason.outcome == 5:    # "Believes no work available"
        discouraged_worker = 1

- id: q190_availability
  precondition:
    - predicate: path == 3 or path == 4 or path == 5 or discouraged_worker == 1
```

## Pattern 6: Chain Dependencies

When a sequence of GOTOs creates a chain where each question gates the next:

```
IMPERATIVE:
Q130: "Why absent?" → If temp layoff → Q132
Q132: "Reason for layoff?" → If business conditions → Q133
Q133: "Expect return?" → If yes → Q134
Q134: "Given return date?" → If yes → Q136
```

In QML, each item gets its own precondition referencing the prior item:

```yaml
- id: q132_layoff_reason
  precondition:
    - predicate: q130_reason_absent.outcome == 8    # temp layoff
  ...

- id: q133_expect_return
  precondition:
    - predicate: q132_layoff_reason.outcome == 6    # business conditions
  ...

- id: q134_return_date
  precondition:
    - predicate: q133_expect_return.outcome == 1    # yes
  ...
```

Each precondition only references its IMMEDIATE predecessor — the Z3 solver handles
transitivity automatically.

## Pattern 7: Intermediate Filter Gates

One of the most commonly missed patterns during conversion. CATI questionnaires often have
"filter" or "screener" questions that gate access to a detailed sub-section. These are easy
to miss because the GOTO instruction appears as just another routing step, but the filter
embodies an important logical constraint.

### Symptom-count gates

Health surveys frequently ask a series of symptom questions, then only proceed to a
diagnostic section if enough symptoms were reported:

```
IMPERATIVE (CCHS Depression Module):
Q1-Q8: "In the past 2 weeks, have you experienced..." (8 symptom questions)
CHECK: Count symptoms where answer = Yes. If count < 5, skip to next module.
Q9: "How much did these symptoms interfere with your life?"
```

In QML, you need an explicit counter variable and a precondition on the detailed section:

```yaml
codeInit: |
  dep_symptom_count = 0

- id: q_dep_sad
  kind: Question
  title: "Have you felt sad or empty nearly every day for 2 weeks?"
  input:
    control: Switch
    off: "No"
    on: "Yes"
  codeBlock: |
    if q_dep_sad.outcome == 1:
        dep_symptom_count = dep_symptom_count + 1

- id: q_dep_interest
  kind: Question
  title: "Have you lost interest in most activities?"
  input:
    control: Switch
    off: "No"
    on: "Yes"
  codeBlock: |
    if q_dep_interest.outcome == 1:
        dep_symptom_count = dep_symptom_count + 1

# ... more symptom questions, each incrementing dep_symptom_count ...

# Gate: only ask severity if enough symptoms
- id: q_dep_severity
  kind: Question
  title: "How much did these symptoms interfere with your daily life?"
  precondition:
    - predicate: dep_symptom_count >= 5
  input:
    control: Radio
    labels:
      1: "Not at all"
      2: "A little"
      3: "A lot"
      4: "Extremely"
```

Remember: `sum()` is not available in codeBlocks. You must increment a counter variable
in each symptom question's codeBlock individually.

### Severity gates

Similar to symptom counts, but gate on a single severity answer rather than a count:

```
IMPERATIVE (NPHS):
Q1: "Rate your health" → If "Excellent" or "Very Good", skip chronic conditions module.
```

```yaml
- id: q_health_rating
  kind: Question
  title: "In general, would you say your health is..."
  input:
    control: Radio
    labels:
      1: "Excellent"
      2: "Very Good"
      3: "Good"
      4: "Fair"
      5: "Poor"

- id: b_chronic_conditions
  title: "Chronic Health Conditions"
  precondition:
    - predicate: q_health_rating.outcome >= 3
  items:
    - ...
```

### The key insight

When converting, look for ANY GOTO that says "if [condition], skip to [distant question]"
where the skipped section is a detailed follow-up. This is almost always a filter gate.
Model it as: screening question → codeBlock updates counter/flag → detailed section has
precondition on that counter/flag.

## Pattern 8: Roster/Loop Structures

CATI questionnaires frequently loop over household members, children, or other repeating
entities. QML has no native loop construct, so these must be "unrolled" into flat structure.

### Fixed-size roster (known maximum)

When the survey has a known maximum number of entities (e.g., "up to 4 children"):

```
IMPERATIVE:
"For each child (up to 4): Ask Q10-Q15."
```

**Approach 1: QuestionGroup** (when all sub-questions share the same control)

```yaml
- id: qg_child_ages
  kind: QuestionGroup
  title: "What is the age of each child?"
  questions:
    - "Child 1"
    - "Child 2"
    - "Child 3"
    - "Child 4"
  precondition:
    - predicate: q_num_children.outcome >= 1
  input:
    control: Editbox
    min: 0
    max: 17
```

Use item-level preconditions to show only the relevant number of sub-questions? No —
QuestionGroup shows all sub-questions as a unit. If you need per-child gating, use
separate Question items instead.

**Approach 2: Separate items with indexed preconditions**

```yaml
- id: q_child1_age
  kind: Question
  title: "Age of first child?"
  precondition:
    - predicate: q_num_children.outcome >= 1
  input:
    control: Editbox
    min: 0
    max: 17

- id: q_child2_age
  kind: Question
  title: "Age of second child?"
  precondition:
    - predicate: q_num_children.outcome >= 2
  input:
    control: Editbox
    min: 0
    max: 17

# ... up to the maximum
```

### Variable-size roster (unknown count)

When the roster size depends on an answer (e.g., "How many jobs do you have?"), define
items up to a reasonable maximum and gate each with a precondition:

```yaml
- id: q_num_jobs
  kind: Question
  title: "How many jobs do you currently hold?"
  input:
    control: Editbox
    min: 0
    max: 5

# Job 1 details (shown if at least 1 job)
- id: q_job1_type
  precondition:
    - predicate: q_num_jobs.outcome >= 1
  ...

# Job 2 details (shown if at least 2 jobs)
- id: q_job2_type
  precondition:
    - predicate: q_num_jobs.outcome >= 2
  ...
```

### Limitations

QML's flat structure means you cannot model truly dynamic rosters (e.g., "for each of
the N household members, ask these 20 questions"). For surveys with large or unbounded
rosters, choose a practical maximum (e.g., 5 household members, 3 jobs) and document
the limitation. This covers 95%+ of real-world cases.

## Pattern 9: Composite Score Gates

Some questionnaires compute a composite score from multiple questions and use it to
route respondents to different follow-up sections. This is common in health instruments
(depression scales, pain indices) and risk assessments.

### The pattern

```
IMPERATIVE:
Q1-Q10: Rate these symptoms (1-5 each)
SCORE = Q1 + Q2 + ... + Q10
If SCORE < 15, go to Low Risk section.
If SCORE 15-30, go to Medium Risk section.
If SCORE > 30, go to High Risk section.
```

```yaml
codeInit: |
  risk_score = 0
  risk_level = 0

# After the last scored question, compute the total and classify
- id: q_symptom_10
  kind: Question
  title: "Rate symptom 10"
  input:
    control: Slider
    min: 1
    max: 5
  codeBlock: |
    risk_score = q_symptom_1.outcome + q_symptom_2.outcome + q_symptom_3.outcome + q_symptom_4.outcome + q_symptom_5.outcome + q_symptom_6.outcome + q_symptom_7.outcome + q_symptom_8.outcome + q_symptom_9.outcome + q_symptom_10.outcome
    if risk_score < 15:
        risk_level = 1
    elif risk_score <= 30:
        risk_level = 2
    else:
        risk_level = 3

- id: b_low_risk
  title: "Low Risk Follow-up"
  precondition:
    - predicate: risk_level == 1
  items: [...]

- id: b_medium_risk
  title: "Medium Risk Follow-up"
  precondition:
    - predicate: risk_level == 2
  items: [...]

- id: b_high_risk
  title: "High Risk Follow-up"
  precondition:
    - predicate: risk_level == 3
  items: [...]
```

For long sums, use a `for` loop with `range()` if outcomes are in a QuestionGroup:

```yaml
codeBlock: |
  risk_score = 0
  for i in range(10):
      risk_score = risk_score + qg_symptoms.outcome[i]
```

### Important: compute the score in ONE codeBlock

Place the summation in the LAST scored question's codeBlock, not spread across multiple
items. This keeps the dependency graph simple and avoids partial-sum variables that
complicate precondition reasoning.

## Variable Feedback Loops

This is the most subtle and dangerous conversion pitfall.

### What causes a cycle

A cycle occurs when:
1. Item A reads variable `v` in its precondition
2. Item B (which depends on A) writes to `v` in its codeBlock
3. This creates: `v` → A → ... → B → `v` (cycle)

### Real-world example (Statistics Canada LFS)

```
Q132 precondition: path != 7        (reads path)
Q132 → Q133 → Q134 → Q136         (chain dependency)
Q136 codeBlock: path = 3            (writes path)
```

Cycle: `path → Q132 → Q133 → Q134 → Q136 → path`

### Why this works in imperative but fails in declarative

In GOTO-based execution:
- Q132 reads `path_v1` (set earlier by Q100)
- Q136 creates `path_v2` (a new value)
- These are implicitly two DIFFERENT temporal snapshots

In QML's dependency graph:
- There is ONE `path` node, not versioned snapshots
- Q132 depends on `path` (reads it)
- `path` depends on Q136 (Q136 writes it)
- Q136 depends on Q132 (through the chain)
- Result: CYCLE detected by Z3

### Solutions

**Solution 1: Use separate variables for different phases**

```yaml
codeInit: |
  initial_path = 0    # Set during classification
  detailed_path = 0   # Set during detailed assessment

# Classification phase
- id: q100_worked
  codeBlock: |
    if q100_worked.outcome == 1:
        initial_path = 1

# Items that gate on initial classification
- id: q132_layoff_reason
  precondition:
    - predicate: initial_path != 7    # reads initial_path

# Downstream refinement writes to different variable
- id: q136_weeks
  codeBlock: |
    if q134_return_date.outcome == 1:
        detailed_path = 3    # writes detailed_path (no cycle)
```

**Solution 2: Restructure the precondition to avoid reading the variable**

Instead of `path != 7`, check the ORIGINAL condition that set path=7:

```yaml
# Instead of: precondition: path != 7
# Use the original condition:
- id: q132_layoff_reason
  precondition:
    - predicate: q105_permanently_unable.outcome != 1    # the condition that sets path=7
```

This breaks the cycle because Q132 no longer depends on the `path` variable.

**Solution 3: Accept the cycle and document it**

If the cycle is inherent to the questionnaire design, document it. The Z3 validator
will flag it but the questionnaire can still function at runtime (FlowProcessor doesn't
use Z3 during navigation). However, per-item classification analysis will be incomplete.

## Common Pitfalls

### Pitfall 1: Forgetting to repeat preconditions

In GOTO, "go to Q5" routes the respondent to Q5 AND ALL following questions until the
next branch. In QML, each item needs its OWN precondition:

```yaml
# WRONG: only q_job_title has a precondition
- id: q_job_title
  precondition:
    - predicate: q_employed.outcome == 1
- id: q_years_at_job    # BUG: shown to everyone!
  input: ...

# CORRECT: each item has its own precondition
- id: q_job_title
  precondition:
    - predicate: q_employed.outcome == 1
- id: q_years_at_job
  precondition:
    - predicate: q_employed.outcome == 1
```

### Pitfall 2: Don't Know / Refused options

CATI systems often have DK/RF options that route to specific questions. QML uses integer
outcomes, so you have two approaches:

**Option A: Include DK/RF as label values**
```yaml
labels:
  1: "Yes"
  3: "No"
  8: "Don't know"
  9: "Refused"
```

Then handle in preconditions: `q_answer.outcome in [1, 3]` (excluding DK/RF).

**Option B: Omit DK/RF** (simpler, if they don't affect routing)

### Pitfall 3: Implicit GOTO falls through

In CATI, if no GOTO fires, execution falls through to the next question. In QML, this
is the default — no precondition means always shown. But watch for cases where the
imperative version has no explicit GOTO because "falling through" IS the routing:

```
IMPERATIVE:
Q10: "Are you male or female?"
Q11: "Are you pregnant?" [CATI: females only]
Q12: "Do you exercise?"
```

The CATI note "[females only]" is not a GOTO but is a routing constraint. Convert it:

```yaml
- id: q_pregnant
  precondition:
    - predicate: q_sex.outcome == 2    # female
```

### Pitfall 4: Parallel sections with hidden divergences

When an imperative questionnaire has near-identical sections (e.g., spousal abuse report
and ex-partner abuse report), don't assume they're truly identical. Check each section's
GOTO instructions independently — they often differ in subtle ways (different variable
names, slightly different skip conditions, different DK/RF routing).

### Pitfall 5: Age gate off-by-one errors

CATI questionnaires are inconsistent about boundary ages. One section might say "aged 15-64"
while another says "aged 16 and over". When converting, check every age gate against the
source specification. Common mistakes:

- Using `>= 16` when the source says "15 and over" (should be `>= 15`)
- Using `<= 64` when retirement questions use "65 and over" (should be `< 65`)
- Mixing inclusive and exclusive boundaries within the same questionnaire

When in doubt, use the exact phrasing from the source questionnaire:
```yaml
# Source says "persons aged 15 to 64"
precondition:
  - predicate: q_age.outcome >= 15
  - predicate: q_age.outcome <= 64
```

### Pitfall 6: Missing proxy/respondent-type exclusions

Many CATI questionnaires have questions that are asked only when the respondent answers
for themselves (not via a proxy). These gates appear as interviewer instructions like
"ASK ONLY IF SELF-RESPONSE" or "IF PROXY, GO TO Q50". They're easy to miss because
they're not part of the question logic itself.

Model proxy status as a classification variable:

```yaml
codeInit: |
  is_proxy = 0

- id: q_response_type
  kind: Question
  title: "Is this a self-response or proxy interview?"
  input:
    control: Radio
    labels:
      1: "Self-response"
      2: "Proxy"
  codeBlock: |
    if q_response_type.outcome == 2:
        is_proxy = 1

# Self-response only questions
- id: q_subjective_health
  precondition:
    - predicate: is_proxy == 0
  title: "How would you describe your own mental health?"
  ...
```

### Pitfall 7: Open-text follow-ups to "Other (specify)"

When a Radio or Dropdown includes an "Other" option, the source questionnaire almost always
has a follow-up "Please specify" text field. These are frequently omitted during conversion.
Always add a Textarea follow-up with a precondition:

```yaml
- id: q_transport
  kind: Question
  title: "How do you usually get to work?"
  input:
    control: Radio
    labels:
      1: "Car"
      2: "Bus"
      3: "Bicycle"
      4: "Walk"
      5: "Other"

- id: q_transport_other
  kind: Question
  title: "Please specify your mode of transportation:"
  precondition:
    - predicate: q_transport.outcome == 5
  input:
    control: Textarea
    placeholder: "Describe your transportation..."
    maxLength: 200
```

### Pitfall 8: PATH variable snapshot pattern

When a classification variable (PATH) is set during an initial screening phase and read
by a later detailed phase, but the detailed phase also needs to REFINE the classification,
use separate variables for the initial and refined classifications. This is the most
reliable way to prevent dependency cycles:

```yaml
codeInit: |
  initial_class = 0    # Set during screening (Q1-Q10)
  detailed_class = 0   # Set during detailed assessment (Q50-Q80)

# Screening sets initial_class
- id: q_screener
  codeBlock: |
    if q_screener.outcome == 1:
        initial_class = 1

# Detailed section reads initial_class, writes detailed_class
- id: q_detail
  precondition:
    - predicate: initial_class == 1
  codeBlock: |
    if q_detail.outcome == 3:
        detailed_class = 2    # refines, doesn't overwrite initial_class

# Later sections can read either variable without cycles
- id: q_followup
  precondition:
    - predicate: detailed_class == 2
```

The rule: **a variable that is READ in preconditions should NOT be WRITTEN in codeBlocks
of items that are downstream of those preconditions.** If you need both read and write,
use two variables — one for the "before" state and one for the "after" state.

### Pitfall 9: Waterfall cascade with shared routing variable

When the source has a "first YES wins" cascade — a sequence of checks where the first
positive answer routes to a specific section and skips all subsequent checks — do NOT
model it with a shared routing variable. This creates N×(N-1)/2 dependency cycles.

```
IMPERATIVE (e.g., emergency dispatch ABCDE assessment):
Check A: "Breathing difficulty?" → If YES, go to Breathing page
Check B: "Behavior change?" → If YES, go to Neuro page
Check C: "Seizures?" → If YES, go to Seizure page
Check D: "Pain?" → If YES, go to Pain page
```

```yaml
# WRONG: shared routing variable creates cycles
codeInit: |
  routed = 0

- id: q_breathing_diff
  precondition:
    - predicate: routed == 0    # reads routed
  codeBlock: |
    if q_breathing_diff.outcome == 1:
        routed = 1               # writes routed → CYCLE with all other items

- id: q_behavior
  precondition:
    - predicate: routed == 0    # reads routed → depends on q_breathing_diff
  codeBlock: |
    if q_behavior.outcome == 1:
        routed = 1               # writes routed → q_breathing_diff depends on this
# → q_breathing_diff ↔ q_behavior CYCLE
```

```yaml
# CORRECT: direct outcome references (cycle-free)
- id: q_breathing_diff
  kind: Question
  title: "Breathing difficulty?"
  input:
    control: Switch
    off: "No"
    on: "Yes"

- id: q_behavior
  precondition:
    - predicate: q_breathing_diff.outcome == 0    # references earlier item directly
  ...

- id: q_seizures
  precondition:
    - predicate: q_breathing_diff.outcome == 0
    - predicate: q_behavior.outcome == 0          # references all earlier items
  ...

- id: q_pain
  precondition:
    - predicate: q_breathing_diff.outcome == 0
    - predicate: q_behavior.outcome == 0
    - predicate: q_seizures.outcome == 0
  ...
```

The correct approach creates a DAG (directed acyclic graph) because each item only
references EARLIER items' outcomes. The preconditions grow longer for items later in
the cascade, but this faithfully models the "first YES wins" logic without cycles.

This pattern was discovered during conversion of a 66-page Hungarian emergency dispatch
protocol (ICS Kérdezési Protokoll) where the ABCDE assessment cascade of 11 items
produced 44 cycles when modeled with a shared `abcde_routed` variable.

## Real-World Examples

These examples come from converting 10 Statistics Canada CATI questionnaires to QML.
They illustrate recurring patterns and pitfalls at scale.

### LFS Labour Force Survey

**Scale**: 83 items, 13 blocks, 77 preconditions, 10 global variables
**Z3 validation**: FAIL (3 dependency cycles)

**Key patterns used**:
- PATH variable (values 1-7) for respondent classification
- Block-level preconditions for section gating
- Chain dependencies for layoff detail questions (Pattern 6)
- Additional variables (`discouraged_worker`, `past_job_path7`) for special routing

**Cycle found**: PATH variable feedback loop in Q132-Q136 chain. The PATH variable is
both read (in preconditions) and written (in codeBlocks) by downstream items, creating
3 cycles. Fix: use the snapshot pattern (Pitfall 8) with `initial_path` and `detailed_path`.

**Lessons**: Age cutoff contradiction (15 vs 16 in different sections), undefined
intermediate states (PATH=0), discouraged workers breaking the PATH taxonomy.

### GSS Victimization Survey

**Scale**: 252 items, 12 blocks, 138 preconditions, 11 global variables
**Z3 validation**: PASS

**Key patterns used**:
- Write-once screening variables (`spousal_abuse`, `ex_spousal_abuse`, etc.)
- Section-gating via screening flags
- Converging paths with OR preconditions (Pattern 5)
- Postconditions for contradictory state prevention (Pattern 4)

**No cycles**: Clean separation between write-once screening variables and read-only
report sections. This is the ideal architecture for avoiding feedback loops.

**Lessons**: Implicit marital status gates (easy to miss), parallel sections for
spousal vs. ex-partner abuse that look identical but have subtle differences (Pitfall 4),
contradictory answer states needing postcondition prevention.

### CCHS Health Survey

**Scale**: 231 items, 16 blocks, ~200 preconditions
**Z3 validation**: PASS

**Key patterns**: Composite score gates (Pattern 9) for depression screening — 9 symptom
questions feeding a count that gates a severity section. The CIDI-SF depression module
is the canonical example of Pattern 7 (intermediate filter gate).

**Lessons**: Symptom-count gates are invisible in the GOTO flow because they're
embedded in interviewer instructions ("IF count < 5, GOTO next module"). Always look for
conditional counts that gate detailed follow-ups.

### NPHS Population Health Survey

**Scale**: 233 items, 14 blocks
**Z3 validation**: PASS

**Key patterns**: Multi-level health classification (HSTAT → chronic conditions → risk
factors), with severity gates at each level. Heavy use of composite scoring for the
Health Utilities Index.

**Lessons**: Self-assessment ratings that gate entire modules (Pattern 7 severity gate),
derived health index computed across 8 attributes using QuestionGroups. Watch for
Z3-subset compliance — original conversion used `any()`, ternary expressions, and bitwise
`&`, all of which are NOT supported and silently return 0.

### PALS Activity Limitation Survey

**Scale**: 219 items, 13 blocks
**Z3 validation**: PASS

**Key patterns**: Born-after-threshold gate (Pattern 7 — only ask education questions
if respondent could plausibly have that level of education based on birth year),
extensive use of QuestionGroups for parallel disability domains.

**Lessons**: Age/birth-year gates need careful boundary handling. The original used
`for i in range(N)` loops in 6 codeBlocks — these work in the Z3 subset but only if
N ≤ 20.

### SHS Household Spending Survey

**Scale**: 225 items, 19 blocks
**Z3 validation**: PASS (cleanest of all 10)

**Key patterns**: Purely hierarchical category→subcategory structure, minimal cross-block
dependencies. Block-level preconditions gate spending categories.

**Lessons**: When the source questionnaire is already well-structured with clear sections,
the conversion is straightforward. This is the "easy case" — no PATH variables, no
feedback loops, no composite scores. Focus on getting control types right (Editbox with
proper min/max for dollar amounts).

### Common findings across all 10 conversions

| Issue | Frequency | Relevant Pattern/Pitfall |
|-------|-----------|--------------------------|
| Missing filter/severity gates | 6/10 | Pattern 7 |
| DK/Refused options omitted | 8/10 | Pitfall 2 |
| PATH variable feedback loops | 2/10 | Variable Feedback Loops, Pitfall 8 |
| Waterfall cascade with shared variable | 1/11 | Pitfall 9 |
| Age boundary off-by-one | 4/10 | Pitfall 5 |
| Missing "Other (specify)" follow-ups | 7/10 | Pitfall 7 |
| Proxy exclusion gates missing | 3/10 | Pitfall 6 |
| Roster/loop flattening needed | 4/10 | Pattern 8 |
| Z3-subset violations in codeBlocks | 3/10 | Code Blocks (SKILL.md) |
