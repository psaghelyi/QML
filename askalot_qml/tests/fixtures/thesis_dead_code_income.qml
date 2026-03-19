# Thesis Example: Accumulated Reachability Detection
# Reference: comprehensive_validation.tex, Definition 2.5
#
# I_1: "Annual income" with S_1 ∈ [0, 1000000], P_1 = true, Q_1 = (S_1 >= 50000)
# I_2: "Tax bracket" with S_2 ∈ {1, 2, 3}, P_2 = true, Q_2 = true
# I_3: "Low-income assistance" with S_3 ∈ {0, 1}, P_3 = (S_1 < 30000), Q_3 = true
#
# Dependency graph: I_1 → I_3 (since P_3 references S_1), I_2 is independent
#
# Expected results:
# - Per-item:
#   - P_3 = (S_1 < 30000) is CONDITIONAL: SAT(B ∧ S_1 < 30000) holds
# - Accumulated reachability for I_3:
#   - Pred(3) = {1} (only I_1 precedes I_3 in dependency order; I_2 is independent)
#   - A_3 = B ∧ (true => S_1 >= 50000) = B ∧ (S_1 >= 50000)
#   - A_3 ∧ P_3 = B ∧ (S_1 >= 50000) ∧ (S_1 < 30000) = UNSAT
# - I_3 is DEAD CODE: Designer intended low-income assistance for S_1 < 30000,
#   but Q_1 requires S_1 >= 50000 to proceed

qmlVersion: "1.0"

questionnaire:
  title: "Income Survey with Dead Code"

  blocks:
    - id: block1
      title: "Financial Information"
      items:
        - id: q_income
          kind: Question
          title: "What is your annual income?"
          input:
            control: Editbox
            min: 0
            max: 1000000
          postcondition:
            - predicate: q_income.outcome >= 50000
              hint: "Income must be at least $50,000"

        - id: q_tax_bracket
          kind: Question
          title: "Select your tax bracket"
          input:
            control: RadioButton
            options:
              - value: 1
                label: "Low"
              - value: 2
                label: "Medium"
              - value: 3
                label: "High"

        - id: q_low_income_assist
          kind: Question
          title: "Would you like information about low-income assistance programs?"
          input:
            control: RadioButton
            options:
              - value: 0
                label: "No"
              - value: 1
                label: "Yes"
          precondition:
            - predicate: q_income.outcome < 30000
