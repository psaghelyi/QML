# Thesis Example: Accumulated Constraints Cause Global Unsatisfiability
# Reference: comprehensive_validation.tex, Theorem 2.3
#
# I_1: "Rate your experience (1-100)" with S_1 ∈ [1, 100], P_1 = true, Q_1 = (S_1 > 50)
# I_2: "Confirm your rating" with S_2 ∈ {0, 1}, P_2 = true, Q_2 = (S_1 < 30)
#
# Expected results:
# - Per-item: Both items are CONSTRAINING (not INFEASIBLE)
#   - W_1 = B ∧ true ∧ (S_1 <= 50) is SAT (e.g., S_1 = 25)
#   - W_2 = B ∧ true ∧ (S_1 >= 30) is SAT (e.g., S_1 = 50)
# - Global: UNSAT(F) - no value of S_1 satisfies both S_1 > 50 AND S_1 < 30
# - This demonstrates accumulated constraints conflict

qmlVersion: "1.0"

questionnaire:
  title: "Rating Survey with Conflicting Postconditions"

  blocks:
    - id: block1
      title: "Rating"
      items:
        - id: q_rating
          kind: Question
          title: "Rate your experience (1-100)"
          input:
            control: Editbox
            min: 1
            max: 100
          postcondition:
            - predicate: q_rating.outcome > 50
              hint: "Rating must be above 50"

        - id: q_confirm
          kind: Question
          title: "Confirm your rating"
          input:
            control: RadioButton
            options:
              - value: 0
                label: "No"
              - value: 1
                label: "Yes"
          postcondition:
            - predicate: q_rating.outcome < 30
              hint: "Rating must be below 30 to confirm"
