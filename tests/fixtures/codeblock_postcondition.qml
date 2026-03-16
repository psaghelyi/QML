# Test: Postcondition referencing codeBlock-computed variable
#
# This tests the Z3 classifier's handling of postconditions that reference
# variables computed in codeBlocks, not just item outcomes directly.
#
# Setup:
#   - q1: outcome in [0, 10]
#   - q2: outcome in [10, 20]
#   - codeInit: var1 = 0
#   - q1.codeBlock: var1 = q1.outcome
#   - q2.codeBlock: var1 = var1 + q2.outcome
#   - Therefore: var1 = q1.outcome + q2.outcome, so var1 in [10, 30]
#
# Postcondition on q4: var1 - 1000 > q2.outcome
#   - max(var1 - 1000) = 30 - 1000 = -970
#   - min(q2.outcome) = 10
#   - -970 > 10 is always FALSE
#
# Expected: q4 postcondition should be INFEASIBLE (never satisfiable)
#
# Bug scenario: If Z3 doesn't track var1's relationship to q1+q2 outcomes,
# it treats var1 as unconstrained and reports CONSTRAINING instead.

qmlVersion: "1.0"

questionnaire:
  title: "CodeBlock Postcondition Test"

  codeInit: |
    var1 = 0

  blocks:
    - id: block1
      title: "Test Block"
      items:
        - id: q1
          kind: Question
          title: "First number (0-10)"
          input:
            control: Editbox
            min: 0
            max: 10
          codeBlock: |
            var1 = q1.outcome

        - id: q2
          kind: Question
          title: "Second number (10-20)"
          input:
            control: Editbox
            min: 10
            max: 20
          codeBlock: |
            var1 = var1 + q2.outcome

        - id: q3
          kind: Question
          title: "Third question (no conditions)"
          input:
            control: Editbox
            min: 0
            max: 100

        - id: q4
          kind: Question
          title: "Question with impossible postcondition"
          input:
            control: Editbox
            min: 50
            max: 100
          postcondition:
            - predicate: var1 - 1000 > q2.outcome
              hint: "This postcondition can never be satisfied"

        - id: q5
          kind: Question
          title: "Final question"
          input:
            control: Editbox
            min: 0
            max: 100
