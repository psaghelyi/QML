questionnaire:
  title: "Survey with Dependencies"
  blocks:
    - id: screening
      title: "Screening"
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
        - id: q_years_employed
          kind: Question
          title: "How many years have you been employed?"
          precondition:
            - predicate: "q_employed.outcome == 1"
          input:
            control: Editbox
            min: 0
            max: 50
    - id: education
      title: "Education"
      items:
        - id: q_degree
          kind: Question
          title: "What is your highest degree?"
          input:
            control: Radio
            labels:
              1: High School
              2: Bachelor
              3: Master
              4: PhD
        - id: q_field
          kind: Question
          title: "What was your field of study?"
          precondition:
            - predicate: "q_degree.outcome >= 2"
          input:
            control: Editbox
