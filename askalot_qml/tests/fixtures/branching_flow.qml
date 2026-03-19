questionnaire:
  title: "Branching Flow Survey"
  codeInit: |
    score = 0
  blocks:
    - id: intro
      title: "Introduction"
      items:
        - id: q_start
          kind: Question
          title: "Would you like to start the survey?"
          input:
            control: Radio
            labels:
              1: Yes
              2: No
    - id: path_selection
      title: "Path Selection"
      items:
        - id: q_path
          kind: Question
          title: "Which topic interests you more?"
          precondition:
            - predicate: "q_start.outcome == 1"
              hint: "Shown when user agrees to start"
          input:
            control: Radio
            labels:
              1: Technology
              2: Nature
    - id: tech_path
      title: "Technology Questions"
      items:
        - id: q_tech_interest
          kind: Question
          title: "What area of technology interests you?"
          precondition:
            - predicate: "q_path.outcome == 1"
              hint: "Shown when user selects Technology"
          input:
            control: Radio
            labels:
              1: AI
              2: Web
              3: Mobile
          codeBlock: |
            score = score + q_tech_interest.outcome
        - id: q_tech_experience
          kind: Question
          title: "How many years of experience do you have?"
          precondition:
            - predicate: "q_path.outcome == 1"
              hint: "Shown when user selects Technology"
          input:
            control: Slider
            min: 0
            max: 20
            step: 1
          codeBlock: |
            if q_tech_experience.outcome >= 5:
              score = score + 10
    - id: nature_path
      title: "Nature Questions"
      items:
        - id: q_nature_interest
          kind: Question
          title: "What aspect of nature interests you?"
          precondition:
            - predicate: "q_path.outcome == 2"
              hint: "Shown when user selects Nature"
          input:
            control: Radio
            labels:
              1: Wildlife
              2: Plants
              3: Geology
          codeBlock: |
            score = score + q_nature_interest.outcome
        - id: q_nature_frequency
          kind: Question
          title: "How often do you visit nature areas?"
          precondition:
            - predicate: "q_path.outcome == 2"
              hint: "Shown when user selects Nature"
          input:
            control: Radio
            labels:
              1: Daily
              2: Weekly
              3: Monthly
              4: Rarely
          codeBlock: |
            if q_nature_frequency.outcome <= 2:
              score = score + 5
    - id: conclusion
      title: "Conclusion"
      items:
        - id: q_final
          kind: Question
          title: "Would you recommend this survey?"
          precondition:
            - predicate: "q_start.outcome == 2 or q_tech_experience.outcome is not None or q_nature_frequency.outcome is not None"
              hint: "Shown when declined or after completing either path"
          input:
            control: Radio
            labels:
              1: Yes
              2: No
