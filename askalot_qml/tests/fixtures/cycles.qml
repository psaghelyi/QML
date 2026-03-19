questionnaire:
  title: "Survey with Cycles (Invalid)"
  blocks:
    - id: main
      title: "Cyclic Questions"
      items:
        - id: q_a
          kind: Question
          title: "Question A"
          precondition:
            - predicate: "q_c.outcome == 1"
          input:
            control: Radio
            labels:
              1: Yes
              2: No
        - id: q_b
          kind: Question
          title: "Question B"
          precondition:
            - predicate: "q_a.outcome == 1"
          input:
            control: Radio
            labels:
              1: Yes
              2: No
        - id: q_c
          kind: Question
          title: "Question C"
          precondition:
            - predicate: "q_b.outcome == 1"
          input:
            control: Radio
            labels:
              1: Yes
              2: No
