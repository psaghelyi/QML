# QML Full Syntax Reference

## Table of Contents

1. [Root Structure](#root-structure)
2. [Blocks](#blocks)
3. [Item Kinds](#item-kinds)
   - [Comment](#comment)
   - [Question](#question)
   - [QuestionGroup](#questiongroup)
   - [MatrixQuestion](#matrixquestion)
4. [Input Controls](#input-controls)
   - [Switch](#switch)
   - [Radio](#radio)
   - [Dropdown](#dropdown)
   - [Checkbox](#checkbox)
   - [Editbox](#editbox)
   - [Slider](#slider)
   - [Range](#range)
   - [Textarea](#textarea)
5. [Conditional Logic](#conditional-logic)
6. [Code Blocks](#code-blocks)
7. [Outcome Access Patterns](#outcome-access-patterns)

---

## Root Structure

```yaml
qmlVersion: "1.0"
questionnaire:
  title: "Survey Title"           # Required
  codeInit: |                     # Optional — global variable initialization
    variable = 0
  precondition:                   # Optional — questionnaire-level gate
    - predicate: condition
  postcondition:                  # Optional — questionnaire-level validation
    - predicate: condition
      hint: "message"
  blocks:                         # Required — at least one block
    - id: b_section
      items:
        - ...
```

## Blocks

```yaml
blocks:
  - id: b_demographics            # Required — unique identifier
    title: "Demographics"         # Optional — section heading
    precondition:                 # Optional — skip entire block
      - predicate: q_consent.outcome == 1
    postcondition:                # Optional — block-level validation
      - predicate: condition
        hint: "message"
    items:                        # Required — at least one item
      - ...
```

Multiple block preconditions are AND-ed.

## Item Kinds

### Comment

Display informational text without collecting a response:

```yaml
- id: q_welcome
  kind: Comment
  title: "Welcome to our survey. Your responses are confidential."

- id: q_parent_notice
  kind: Comment
  title: "The following questions are about your children."
  precondition:
    - predicate: q_has_children.outcome == 1
```

Comments can have preconditions and codeBlocks, but no `input`, no postconditions
(no outcome to validate).

### Question

Single-outcome question — produces one integer value:

```yaml
- id: q_age
  kind: Question
  title: "What is your age?"
  precondition:                   # Optional
    - predicate: condition
  postcondition:                  # Optional
    - predicate: q_age.outcome >= 18
      hint: "You must be 18 or older"
  codeBlock: |                    # Optional
    if q_age.outcome >= 65:
        is_senior = 1
  input:                          # REQUIRED
    control: Editbox
    min: 0
    max: 120
    right: "years old"
```

Outcome access: `q_age.outcome` (single integer)

### QuestionGroup

Vector of outcomes — multiple sub-questions sharing the same input control:

```yaml
- id: qg_family_ages
  kind: QuestionGroup
  title: "Enter the age of each family member:"
  questions:                      # REQUIRED — list of sub-question labels
    - "Yourself"
    - "Spouse"
    - "First child"
    - "Second child"
  precondition:
    - predicate: q_household.outcome >= 2
  postcondition:
    - predicate: qg_family_ages.outcome[0] >= 18
      hint: "Primary respondent must be 18 or older"
  codeBlock: |
    total_age = qg_family_ages.outcome[0] + qg_family_ages.outcome[1]
  input:                          # REQUIRED — shared by all sub-questions
    control: Editbox
    min: 0
    max: 120
    right: "years"
```

Outcome access: `qg_family_ages.outcome[0]`, `qg_family_ages.outcome[1]`, etc.

### MatrixQuestion

Matrix of outcomes — rows x columns grid:

```yaml
- id: mq_proficiency
  kind: MatrixQuestion
  title: "Rate language proficiency for each family member:"
  rows:                           # REQUIRED — row labels
    - "English"
    - "Spanish"
    - "French"
  columns:                        # REQUIRED — column labels
    - "Yourself"
    - "Spouse"
    - "Child"
  input:                          # REQUIRED — shared by all cells
    control: Dropdown
    labels:
      0: "None"
      1: "Beginner"
      2: "Intermediate"
      3: "Advanced"
      4: "Native"
```

Outcome access: `mq_proficiency.outcome[row][col]`
- `mq_proficiency.outcome[0][1]` = English proficiency of Spouse
- This example produces a 3x3 matrix = 9 individual outcomes

Use Dropdown for 4+ options per cell (prevents horizontal overflow in the grid).

## Input Controls

### Switch

Binary choice (0 = off, 1 = on):

```yaml
input:
  control: Switch
  off: "No"                       # Required — label for 0
  on: "Yes"                       # Required — label for 1
  default: 0                      # Optional — 0 or 1
```

### Radio

Single selection from labeled options:

```yaml
input:
  control: Radio
  labels:                         # Required
    1: "Strongly Disagree"
    2: "Disagree"
    3: "Neutral"
    4: "Agree"
    5: "Strongly Agree"
  default: 3                      # Optional — must be a key from labels
```

### Dropdown

Single selection from a longer list, with optional prefix/suffix:

```yaml
input:
  control: Dropdown
  labels:                         # Required
    1: "United States"
    2: "Canada"
    3: "United Kingdom"
    4: "Germany"
    5: "France"
    6: "Japan"
    7: "Other"
  left: "I live in"              # Optional — prefix text
  right: ""                       # Optional — suffix text
  default: 1                      # Optional — must be a key from labels
```

### Checkbox

Multiple selection using bit mask encoding:

```yaml
input:
  control: Checkbox
  labels:                         # Required — keys MUST be powers of 2
    1: "Reading"                  # Bit 0: 2^0 = 1
    2: "Sports"                   # Bit 1: 2^1 = 2
    4: "Music"                    # Bit 2: 2^2 = 4
    8: "Travel"                   # Bit 3: 2^3 = 8
    16: "Cooking"                 # Bit 4: 2^4 = 16
  default: 0                      # Optional — bit mask of pre-selected options
```

Selecting "Reading" + "Music" produces outcome: `1 | 4 = 5`

To check if a specific option was selected in predicates, use bitwise logic:
- Check if "Sports" (bit 1 = 2) selected: `q_hobbies.outcome % 4 >= 2`
- Or more simply, use the outcome value directly in codeBlocks

### Editbox

Free-form integer input with bounds:

```yaml
input:
  control: Editbox
  min: 0                          # Required
  max: 120                        # Required
  left: "I am"                   # Optional — prefix text
  right: "years old"             # Optional — suffix text
  default: 25                     # Optional — must be between min and max
```

### Slider

Visual integer selection on a scale:

```yaml
input:
  control: Slider
  min: 0                          # Required
  max: 10                         # Required
  step: 1                         # Optional — increment size
  left: "Not satisfied"          # Optional — left endpoint label
  right: "Very satisfied"        # Optional — right endpoint label
  labels:                         # Optional — tick mark labels
    0: "0"
    5: "5"
    10: "10"
  default: 5                      # Optional
```

### Range

Interval selection (two integers encoded as one via Szudzik pairing):

```yaml
input:
  control: Range
  min: 0                          # Required
  max: 1000                       # Required
  step: 50                        # Optional
  left: "$"                      # Optional
  right: ""                       # Optional
  labels:                         # Optional
    0: "$0"
    500: "$500"
    1000: "$1000"
```

### Textarea

Open-ended free text (outcome is a string, NOT an integer — ignored by Z3):

```yaml
input:
  control: Textarea
  placeholder: "Type your answer here..."   # Optional
  maxLength: 500                             # Optional
```

Use Textarea for qualitative feedback that doesn't affect survey routing or scoring.
Do not reference Textarea outcomes in preconditions, postconditions, or codeBlocks.

## Conditional Logic

### Precondition Predicate Syntax

Predicates are Python expressions that evaluate to True/False:

```yaml
# Simple outcome check
- predicate: q_employed.outcome == 1

# Comparison
- predicate: q_age.outcome >= 18

# Boolean combination
- predicate: q_age.outcome >= 18 and q_consent.outcome == 1

# OR logic (within a single predicate)
- predicate: q_path.outcome == 1 or q_path.outcome == 2

# Variable reference
- predicate: risk_level >= 3

# Membership test
- predicate: q_region.outcome in [1, 2, 3]

# Negation
- predicate: not (q_declined.outcome == 1)
```

Multiple precondition entries are AND-ed:
```yaml
precondition:
  - predicate: q_age.outcome >= 16       # AND
  - predicate: q_age.outcome <= 65       # AND
  - predicate: q_consent.outcome == 1    # all three must be true
```

### Postcondition with Hints

```yaml
postcondition:
  - predicate: q_experience.outcome <= q_age.outcome - 16
    hint: "Work experience cannot exceed years since age 16"
  - predicate: q_experience.outcome >= 0
    hint: "Experience must be non-negative"
```

Each postcondition is checked independently. All must pass for the item to be accepted.

## Code Blocks

### Allowed Python Subset

```python
# Arithmetic
total = q1.outcome + q2.outcome * 2
remainder = total % 3

# Conditionals (nested OK)
if q_age.outcome >= 65:
    category = "senior"
    risk = risk + 2
elif q_age.outcome >= 18:
    category = "adult"
else:
    category = "minor"

# For loops (range max 20, or literal containers)
count = 0
for i in range(5):
    count = count + i

total = 0
for val in [10, 20, 30]:
    total = total + val

# Membership tests
if q_choice.outcome in [1, 2, 3]:
    group = "low"
elif q_choice.outcome in [4, 5]:
    group = "high"

# Augmented assignment
score += 10
risk -= 1

# Setting outcomes programmatically (advanced)
if skip_section == 1:
    q_optional.outcome = 0
```

### Forbidden Features

These either raise validation errors or silently return 0:

```python
# VALIDATION ERRORS:
import math              # No imports
def calculate(): pass    # No function definitions
class MyClass: pass      # No class definitions

# SILENTLY RETURN 0 (dangerous — creates unverifiable logic):
len(my_list)             # Returns 0
sum(values)              # Returns 0
max(a, b)                # Returns 0
min(a, b)                # Returns 0
my_list.append(val)      # Returns 0
[x*2 for x in range(5)] # Not supported
data = {}                # No dictionaries
name.upper()             # No string methods

# UNSUPPORTED CONTROL FLOW:
while condition: pass    # No while loops
break                    # No break
continue                 # No continue
try/except               # No exception handling
```

## Outcome Access Patterns

| Item Kind | Access Pattern | Example |
|-----------|---------------|---------|
| Question | `item.outcome` | `q_age.outcome` |
| QuestionGroup | `item.outcome[index]` | `qg_ratings.outcome[0]` |
| MatrixQuestion | `item.outcome[row][col]` | `mq_skills.outcome[2][1]` |

Indices are 0-based and follow the order of `questions` (QuestionGroup) or
`rows`/`columns` (MatrixQuestion) as defined in the YAML.

### Aggregating QuestionGroup Outcomes

Since `sum()` is NOT available, add values explicitly:

```yaml
codeBlock: |
  total = qg_ratings.outcome[0] + qg_ratings.outcome[1] + qg_ratings.outcome[2]
  if total >= 12:
      satisfaction = "excellent"
  elif total >= 9:
      satisfaction = "good"
  else:
      satisfaction = "needs_improvement"
```

For longer lists, use a for loop with range:

```yaml
codeBlock: |
  total = 0
  for i in range(5):
      total = total + qg_scores.outcome[i]
```
