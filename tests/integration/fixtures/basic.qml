questionnaire:
  title: "Basic Survey"
  blocks:
    - id: demographics
      title: "Demographics"
      items:
        - id: q_age
          kind: Question
          title: "What is your age?"
          input:
            control: Editbox
            min: 18
            max: 120
        - id: q_gender
          kind: Question
          title: "What is your gender?"
          input:
            control: Radio
            labels:
              1: Male
              2: Female
              3: Other
        - id: q_comment
          kind: Comment
          title: "Thank you for participating."
