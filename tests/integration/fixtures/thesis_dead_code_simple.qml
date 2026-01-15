# Thesis Example: Global Validity Does Not Guarantee All Items Reachable
# Reference: comprehensive_validation.tex, Theorem 2.5
#
# I_1: S_1 ∈ [1, 100], P_1 = true, Q_1 = (S_1 > 80)
# I_2: S_2 ∈ {0, 1}, P_2 = (S_1 < 50), Q_2 = true
#
# Expected results:
# - Per-item:
#   - P_2 = (S_1 < 50) is CONDITIONAL: SAT(B ∧ S_1 < 50) with S_1 = 25
#   - Q_1 = (S_1 > 80) is CONSTRAINING: SAT(W_1) with S_1 = 25
# - Global: SAT(F) with S_1 = 90 (since (S_1 < 50) => true is vacuously true)
# - Path-based: I_2 is DEAD CODE
#   - Any path including I_2 requires: B ∧ (S_1 > 80) ∧ (S_1 < 50) = UNSAT
#   - I_2 is CONDITIONAL per-item but unreachable under accumulated constraints

qmlVersion: "1.0"

questionnaire:
  title: "Survey with Dead Code"

  blocks:
    - id: block1
      title: "Rating Block"
      items:
        - id: q_rating
          kind: Question
          title: "Rate this item (1-100)"
          input:
            control: Editbox
            min: 1
            max: 100
          postcondition:
            - predicate: q_rating.outcome > 80
              hint: "Rating must be above 80"

        - id: q_feedback
          kind: Question
          title: "Would you like to provide feedback?"
          input:
            control: RadioButton
            options:
              - value: 0
                label: "No"
              - value: 1
                label: "Yes"
          precondition:
            - predicate: q_rating.outcome < 50
