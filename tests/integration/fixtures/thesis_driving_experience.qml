# Thesis Example: Local Invalidity Does Not Imply Global Unsatisfiability
# Reference: comprehensive_validation.tex, Theorem 2.2
#
# I_1: "What is your age?" with S_1 ∈ [0, 120], P_1 = true, Q_1 = true
# I_2: "Years of driving experience?" with S_2 ∈ [0, 100], P_2 = (S_1 >= 16), Q_2 = (S_2 <= S_1 - 16)
#
# Expected results:
# - Per-item: Q_2 is CONSTRAINING (SAT(W_2) with S_1=20, S_2=10)
# - Global: SAT(F) - valid completion exists (e.g., S_1=30, S_2=5)
# - Path-based: No dead code

qmlVersion: "1.0"

questionnaire:
  title: "Driving Experience Survey"

  blocks:
    - id: block1
      title: "Demographics"
      items:
        - id: q_age
          kind: Question
          title: "What is your age?"
          input:
            control: Editbox
            min: 0
            max: 120

        - id: q_experience
          kind: Question
          title: "Years of driving experience?"
          input:
            control: Editbox
            min: 0
            max: 100
          precondition:
            - predicate: q_age.outcome >= 16
          postcondition:
            - predicate: q_experience.outcome <= q_age.outcome - 16
              hint: "Driving experience cannot exceed years since turning 16"
