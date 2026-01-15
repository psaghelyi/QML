questionnaire:
  title: "Survey with Malformed Precondition"
  blocks:
    - id: main
      title: "Main"
      items:
        - id: q_first
          kind: Question
          title: "First question"
          input:
            control: Radio
            labels:
              1: Yes
              2: No
        - id: q_malformed
          kind: Question
          title: "This has a malformed precondition"
          precondition:
            - predicate: "undefined_function(q_first.outcome)"
              hint: "This precondition uses an undefined function"
          input:
            control: Radio
            labels:
              1: A
              2: B
        - id: q_last
          kind: Question
          title: "Last question"
          input:
            control: Radio
            labels:
              1: Done
              2: Not done
