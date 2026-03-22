questionnaire:
  title: "Block Precondition Survey"
  blocks:
    - id: screening
      title: "Screening"
      items:
        - id: q_age
          kind: Question
          title: "What is your age group?"
          input:
            control: Radio
            labels:
              1: "18-30"
              2: "31-50"
              3: "51+"
        - id: q_country
          kind: Question
          title: "What country do you live in?"
          input:
            control: Radio
            labels:
              1: USA
              2: Canada
              3: Other
    - id: employment
      title: "Employment"
      precondition:
        - predicate: "q_age.outcome <= 2"
          hint: "Employment block only for working-age respondents"
      items:
        - id: q_employed
          kind: Question
          title: "Are you currently employed?"
          input:
            control: Radio
            labels:
              1: Yes
              2: No
        - id: q_job_title
          kind: Question
          title: "What is your job title?"
          precondition:
            - predicate: "q_employed.outcome == 1"
          input:
            control: Editbox
    - id: retirement
      title: "Retirement"
      precondition:
        - predicate: "q_age.outcome == 3"
          hint: "Retirement block only for 51+"
      items:
        - id: q_retired
          kind: Question
          title: "Are you retired?"
          input:
            control: Radio
            labels:
              1: Yes
              2: No
