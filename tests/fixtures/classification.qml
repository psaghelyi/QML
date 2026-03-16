questionnaire:
  title: "Classification Test"
  blocks:
    - id: main
      title: "Classification Scenarios"
      items:
        - id: q_always
          kind: Question
          title: "Always shown (no precondition)"
          input:
            control: Radio
            labels:
              1: Yes
              2: No
        - id: q_conditional
          kind: Question
          title: "Conditionally shown"
          precondition:
            - predicate: "q_always.outcome == 1"
          input:
            control: Radio
            labels:
              1: Option A
              2: Option B
        - id: q_never
          kind: Question
          title: "Never reachable (contradictory precondition)"
          precondition:
            - predicate: "q_always.outcome == 1 and q_always.outcome == 2"
          input:
            control: Radio
            labels:
              1: X
              2: Y
        - id: q_tautological
          kind: Question
          title: "With tautological postcondition"
          postcondition:
            - predicate: "q_tautological.outcome >= 1 or q_tautological.outcome < 1"
              hint: "This always holds"
          input:
            control: Radio
            labels:
              1: A
              2: B
        - id: q_constraining
          kind: Question
          title: "With constraining postcondition"
          postcondition:
            - predicate: "q_constraining.outcome == 1"
              hint: "Must select option 1"
          input:
            control: Radio
            labels:
              1: Required
              2: Not allowed
