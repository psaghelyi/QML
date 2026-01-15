questionnaire:
  title: "Scored Assessment"
  codeInit: |
    score = 0
    risk_level = 0
  blocks:
    - id: assessment
      title: "Risk Assessment"
      items:
        - id: q_age
          kind: Question
          title: "What is your age?"
          input:
            control: Editbox
            min: 18
            max: 100
          codeBlock: |
            if q_age.outcome >= 65:
                risk_level = risk_level + 2
            elif q_age.outcome >= 45:
                risk_level = risk_level + 1
        - id: q_smoker
          kind: Question
          title: "Do you smoke?"
          input:
            control: Radio
            labels:
              1: Yes
              2: No
          codeBlock: |
            if q_smoker.outcome == 1:
                risk_level = risk_level + 3
                score = score + 10
        - id: q_exercise
          kind: Question
          title: "How often do you exercise per week?"
          input:
            control: Radio
            labels:
              1: Never
              2: "1-2 times"
              3: "3-4 times"
              4: "5+ times"
          codeBlock: |
            if q_exercise.outcome == 1:
                risk_level = risk_level + 2
            elif q_exercise.outcome >= 3:
                risk_level = risk_level - 1
          postcondition:
            - predicate: "q_exercise.outcome >= 1 and q_exercise.outcome <= 4"
              hint: "Please select a valid exercise frequency"
        - id: q_result
          kind: Comment
          title: "Assessment complete"
          precondition:
            - predicate: "risk_level >= 0"
