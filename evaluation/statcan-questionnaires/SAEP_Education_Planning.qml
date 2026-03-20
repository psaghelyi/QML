# Survey of Approaches to Educational Planning (SAEP) - QML Conversion
# Source: Statistics Canada, Catalogue 8-5300-368.1 (1999), 49 pages
# Converted from imperative GOTO-based CATI routing to declarative QML preconditions.
#
# Conversion notes:
#   - Original PDF has Sections B/C/D (identical modules for Child 1/2/3).
#     QML models ONE child path since B/C/D are structurally identical carbon copies.
#   - Section E (remaining children in 4+ child households) omitted -- edge case.
#   - G4/G5 (ethnic ancestry -- MARK ALL THAT APPLY with 17+ options) omitted -- no routing impact.
#   - G7 (other languages -- MARK ALL THAT APPLY) omitted -- no routing impact.
#   - Interviewer logistics (A2, call records, final status) omitted.
#
# Primary routing hub: child_age drives the age-gate split at B4 (p4):
#   age 0-4  -> skip school experience, go directly to B20 (post-secondary planning)
#   age 5-8  -> B6 (school attendance), then post-secondary planning
#   age 9+   -> B5 (education expectations) + B6 + school experience + post-secondary planning
#
# Key routing variables set by codeBlocks:
#   child_age, attended_school, not_attend_reason, grade_enrolled,
#   has_saved, planning_to_save, has_postsec_plan, live_away,
#   has_loans, has_resp, has_savings_plan, has_outside_savings,
#   saving_outside_children, all_children_under_5

qmlVersion: "1.0"

questionnaire:
  title: "Survey of Approaches to Educational Planning (SAEP) - Statistics Canada"

  codeInit: |
    child_age = 0
    attended_school = 0
    not_attend_reason = 0
    grade_enrolled = 0
    has_saved = 0
    planning_to_save = 0
    has_postsec_plan = 0
    live_away = 0
    has_loans = 0
    has_resp = 0
    has_savings_plan = 0
    has_outside_savings = 0
    saving_outside_children = 0
    all_children_under_5 = 0

  blocks:
    # =========================================================================
    # CHILD DEMOGRAPHICS (Child header, p3)
    # Source: PDF p3 -- CHILD 1 header with First Name, Sex, Age
    # =========================================================================
    - id: b_child_demographics
      title: "Child Demographics"
      items:
        - id: child_age_q
          kind: Question
          title: "What is the child's age? (If less than 1 year, enter 00)"
          input:
            control: Editbox
            min: 0
            max: 18
            right: "years"
          codeBlock: |
            child_age = child_age_q.outcome
            if child_age <= 4:
                all_children_under_5 = 1
            else:
                all_children_under_5 = 0

        - id: child_sex_q
          kind: Question
          title: "What is the child's sex?"
          input:
            control: Radio
            labels:
              1: "Male"
              2: "Female"

    # =========================================================================
    # SECTION B - GENERAL QUESTIONS (B1-B3)
    # Source: PDF p3
    # All respondents answer B1-B3 regardless of age.
    # =========================================================================
    - id: b_general
      title: "Section B - General Questions"
      items:
        - id: b1_relationship
          kind: Question
          title: "What is the child's relationship to you?"
          input:
            control: Radio
            labels:
              1: "Son/daughter (biological, adoptive, stepchild)"
              2: "Foster child"
              3: "Grandchild"
              4: "Brother/sister"
              5: "Other family member or relative"
              6: "Unrelated"

        - id: b2_health_condition
          kind: Question
          title: "Does the child have any long-term conditions or health problems which prevent or limit his/her participation in school, at play, or in any other activity for a child of his/her age?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: b3_education_hope
          kind: Question
          title: "How far do the child's parents/guardians hope that he/she will go in school?"
          input:
            control: Radio
            labels:
              1: "Primary school"
              2: "Secondary or high school"
              3: "Community college, technical college or CEGEP"
              4: "University"
              5: "Learn a trade"

    # =========================================================================
    # B4 CHECK ITEM + B5 EDUCATION EXPECTATIONS (p4)
    # B4: age 0-4 -> B20 (p11); age 5-8 -> B6; age 9+ -> B5
    # B5: education expectations (age 9+ only)
    # =========================================================================
    - id: b_education_expectations
      title: "Education Expectations"
      items:
        - id: b5_education_expect
          kind: Question
          title: "How far do the child's parents/guardians expect that he/she will go in school?"
          precondition:
            - predicate: child_age >= 9
          input:
            control: Radio
            labels:
              1: "Primary school"
              2: "Secondary or high school"
              3: "Community college, technical college or CEGEP"
              4: "University"
              5: "Learn a trade"

    # =========================================================================
    # SCHOOL ATTENDANCE (B6-B9)
    # Source: PDF p4-6
    # B6: age 5+ only. Yes -> B9 (p6); No -> B7; DK/Refused -> B20 (p11)
    # B7: reasons 1-2 -> B20; reasons 3-5 -> B8
    # B8: grade last enrolled (didn't attend, left/graduated/other) -> B20
    # B9: grade enrolled last year. Jr K/K (34-35) -> B20; others -> B10
    # =========================================================================
    - id: b_school_attendance
      title: "School Attendance"
      items:
        - id: b6_attended_school
          kind: Question
          title: "Did the child attend school last year? (include home schooling)"
          precondition:
            - predicate: child_age >= 5
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
          codeBlock: |
            if b6_attended_school.outcome == 1:
                attended_school = 1
            else:
                attended_school = 0

        - id: b7_not_attend_reason
          kind: Question
          title: "Why did the child not attend school last year?"
          precondition:
            - predicate: child_age >= 5
            - predicate: b6_attended_school.outcome == 2
          input:
            control: Radio
            labels:
              1: "Too young for school"
              2: "Physical, mental, emotional or behavioral problem"
              3: "Left school before graduating"
              4: "Graduated from school"
              5: "Other"
          codeBlock: |
            not_attend_reason = b7_not_attend_reason.outcome

        - id: b8_grade_last_enrolled
          kind: Question
          title: "In what grade was the child last enrolled?"
          precondition:
            - predicate: child_age >= 5
            - predicate: b6_attended_school.outcome == 2
            - predicate: not_attend_reason >= 3
          input:
            control: Dropdown
            labels:
              1: "Junior kindergarten"
              2: "Kindergarten"
              3: "Grade 1"
              4: "Grade 2"
              5: "Grade 3"
              6: "Grade 4"
              7: "Grade 5"
              8: "Grade 6"
              9: "Grade 7 (Quebec: Secondary 1)"
              10: "Grade 8 (Quebec: Secondary 2)"
              11: "Grade 9 (Quebec: Secondary 3)"
              12: "Grade 10 (Quebec: Secondary 4)"
              13: "Grade 11 (Quebec: Secondary 5)"
              14: "Grade 12"
              15: "OAC Grade 13 (Ontario)"
              16: "Ungraded"
              17: "CEGEP technical program"
              18: "CEGEP academic program (pre-university)"
              19: "University or college"
              20: "Apprenticeship"
              21: "Trades-technology training"
              22: "Other"

        - id: b9_grade_enrolled
          kind: Question
          title: "In what grade was the child enrolled last year?"
          precondition:
            - predicate: child_age >= 5
            - predicate: attended_school == 1
          input:
            control: Dropdown
            labels:
              1: "Junior kindergarten"
              2: "Kindergarten"
              3: "Grade 1"
              4: "Grade 2"
              5: "Grade 3"
              6: "Grade 4"
              7: "Grade 5"
              8: "Grade 6"
              9: "Grade 7 (Quebec: Secondary 1)"
              10: "Grade 8 (Quebec: Secondary 2)"
              11: "Grade 9 (Quebec: Secondary 3)"
              12: "Grade 10 (Quebec: Secondary 4)"
              13: "Grade 11 (Quebec: Secondary 5)"
              14: "Grade 12"
              15: "OAC Grade 13 (Ontario)"
              16: "Ungraded"
              17: "CEGEP technical program"
              18: "CEGEP academic program (pre-university)"
              19: "University or college"
              20: "Apprenticeship"
              21: "Trades-technology training"
              22: "Other"
          codeBlock: |
            grade_enrolled = b9_grade_enrolled.outcome

    # =========================================================================
    # SCHOOL EXPERIENCE (B10-B16)
    # Source: PDF p7-8
    # Only shown if child attended school AND grade >= Grade 1 (code 3+)
    # PDF p6: B9 Jr K/K -> Go to B20. Grade 1+ -> continue to B10.
    # =========================================================================
    - id: b_school_experience
      title: "School Experience"
      items:
        - id: b10_school_performance
          kind: Question
          title: "Based on your knowledge of the child's schoolwork, including report cards, how did he/she do overall in school?"
          precondition:
            - predicate: attended_school == 1
            - predicate: grade_enrolled >= 3
          input:
            control: Radio
            labels:
              1: "Above average"
              2: "Average"
              3: "Below average"

        - id: b11_school_feelings
          kind: Question
          title: "How did the child feel about his/her schoolwork?"
          precondition:
            - predicate: attended_school == 1
            - predicate: grade_enrolled >= 3
          input:
            control: Radio
            labels:
              1: "Liked it very much"
              2: "Liked it"
              3: "Neither liked nor disliked it"
              4: "Disliked it"
              5: "Disliked it very much"

        - id: b12_friends_schoolwork
          kind: Question
          title: "Overall, did the child's close friends do well in their schoolwork?"
          precondition:
            - predicate: attended_school == 1
            - predicate: grade_enrolled >= 3
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: b13_teacher_contact
          kind: Question
          title: "How often were the child's parents/guardians in contact with his/her teachers to discuss his/her academic performance or behaviour?"
          precondition:
            - predicate: attended_school == 1
            - predicate: grade_enrolled >= 3
          input:
            control: Radio
            labels:
              1: "Often"
              2: "A few times"
              3: "Once"
              4: "Never"

        - id: b14_study_place
          kind: Question
          title: "Did the child's parents/guardians set aside a place in the home for him/her to use for studying or doing homework?"
          precondition:
            - predicate: attended_school == 1
            - predicate: grade_enrolled >= 3
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: b15_outside_activities
          kind: QuestionGroup
          title: "In a typical week during the last school year, how often did the child participate in organized activities that were NOT run by the school:"
          precondition:
            - predicate: attended_school == 1
            - predicate: grade_enrolled >= 3
          questions:
            - "Sports or physical activities (e.g., Little League, swim club, hockey league)"
            - "Social club activities (e.g., scouts, girl guides, boys and girls clubs, church groups)"
            - "Cultural activities (e.g., music lessons, art lessons, dance lessons, drama lessons)"
          input:
            control: Radio
            labels:
              1: "More than once a week"
              2: "About once a week"
              3: "Less than once a week"
              4: "Never"

        - id: b16_school_activities
          kind: Question
          title: "In a typical week during the last school year, how often did the child participate in organized activities run by the school outside of school hours? (e.g., sports teams, social clubs, music, band, school plays)"
          precondition:
            - predicate: attended_school == 1
            - predicate: grade_enrolled >= 3
          input:
            control: Radio
            labels:
              1: "More than once a week"
              2: "About once a week"
              3: "Less than once a week"
              4: "Never"

    # =========================================================================
    # PARENTAL INVOLVEMENT (B17-B19)
    # Source: PDF p9-10
    # Same gate as B10-B16: attended school AND grade >= Grade 1
    # =========================================================================
    - id: b_parental_involvement
      title: "Parental Involvement"
      items:
        - id: b17_parental_actions
          kind: QuestionGroup
          title: "How often did the child's parents/guardians do each of the following?"
          precondition:
            - predicate: attended_school == 1
            - predicate: grade_enrolled >= 3
          questions:
            - "Praise the child if he/she did well in school"
            - "Praise the child for trying in school, even if he/she did not succeed"
            - "Help the child with homework when he/she did not understand"
            - "Remind the child to begin or complete homework"
            - "Help the child plan his/her time for getting homework done"
            - "Decide how much television the child could watch on school days"
            - "Tell or remind the child that he/she was not working to his/her full potential or ability"
          input:
            control: Radio
            labels:
              1: "Very often"
              2: "Often"
              3: "Sometimes"
              4: "Never"

        - id: b18_homework_time
          kind: Question
          title: "In general, how much time did the child spend doing homework?"
          precondition:
            - predicate: attended_school == 1
            - predicate: grade_enrolled >= 3
          input:
            control: Radio
            labels:
              1: "A lot"
              2: "A fair amount"
              3: "Very little"
              4: "None at all"

        - id: b19_leisure_time
          kind: Question
          title: "How much leisure time did the child's parents/guardians usually spend with him/her in a week? (Leisure time means doing things together like playing a game, going shopping together, or other activities.)"
          precondition:
            - predicate: attended_school == 1
            - predicate: grade_enrolled >= 3
          input:
            control: Radio
            labels:
              1: "A lot"
              2: "A fair amount"
              3: "Very little"
              4: "None at all"

    # =========================================================================
    # PLANNING FOR POST-SECONDARY EDUCATION (B20-B29)
    # Source: PDF p11-13
    # ALL respondents reach this section. Key routing:
    #   B20: Yes -> B22; No/DK/Refused -> B21
    #   B21: Yes -> B22; No/DK/Refused -> B42 (p15)
    #   B22: Yes -> B23; No/DK/Refused -> B24
    #   B23 -> B25; B24 -> B25
    #   B25d (loans) drives B26 check item
    #   B26: B25d=Yes -> B27; otherwise -> B28
    # =========================================================================
    - id: b_postsec_planning
      title: "Planning for Post-Secondary Education"
      items:
        - id: b20_saved_money
          kind: Question
          title: "Have you or anyone else living in your household ever saved money for the child's post-secondary education? (Post-secondary includes college, university, apprenticeships, trade-vocational programs, CEGEPs or any other type of formal education after high school.)"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
          codeBlock: |
            if b20_saved_money.outcome == 1:
                has_saved = 1
                has_postsec_plan = 1
            else:
                has_saved = 0

        - id: b21_planning_to_save
          kind: Question
          title: "Are you or anyone else living in your household planning to save or pay for the child's post-secondary education?"
          precondition:
            - predicate: has_saved == 0
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
          codeBlock: |
            if b21_planning_to_save.outcome == 1:
                planning_to_save = 1
                has_postsec_plan = 1
            else:
                planning_to_save = 0
                has_postsec_plan = 0

        - id: b22_live_away
          kind: Question
          title: "If the child were to go on to post-secondary education, do his/her parents/guardians expect that he/she will live away from home?"
          precondition:
            - predicate: has_postsec_plan == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
          codeBlock: |
            if b22_live_away.outcome == 1:
                live_away = 1
            else:
                live_away = 0

        - id: b23_cost_away
          kind: Question
          title: "Assuming that the child lives away from home, how much do his/her parents/guardians expect that the total cost of his/her education and living expenses would be?"
          precondition:
            - predicate: has_postsec_plan == 1
            - predicate: live_away == 1
          input:
            control: Editbox
            min: 0
            max: 999999
            left: "$"

        - id: b24_cost_home
          kind: Question
          title: "Assuming that the child lives at home, how much do his/her parents/guardians expect that the total cost of his/her education would be?"
          precondition:
            - predicate: has_postsec_plan == 1
            - predicate: live_away == 0
          input:
            control: Editbox
            min: 0
            max: 999999
            left: "$"

        - id: b25_self_pay
          kind: QuestionGroup
          title: "Do the child's parents/guardians expect that he/she will pay for any part of his/her education costs himself/herself in the following ways?"
          precondition:
            - predicate: has_postsec_plan == 1
          questions:
            - "He/she will work before starting his/her post-secondary studies (includes part-time jobs while in high school)"
            - "He/she will work during his/her post-secondary studies (includes part-time jobs, summer jobs, co-op work programs)"
            - "He/she will interrupt his/her studies to work"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: b25d_take_loans
          kind: Question
          title: "He/she will take out loans that will be repaid after his/her studies are finished"
          precondition:
            - predicate: has_postsec_plan == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
          codeBlock: |
            if b25d_take_loans.outcome == 1:
                has_loans = 1
            else:
                has_loans = 0

        # B26 Interviewer Check Item (p12): If B25d = "Yes", go to B27. Otherwise, go to B28.
        - id: b27_loan_types
          kind: QuestionGroup
          title: "Are the loans expected to be from:"
          precondition:
            - predicate: has_loans == 1
          questions:
            - "Government student loans (federal or provincial)"
            - "Non-student loans from a financial institution (e.g., bank, trust company, credit union)"
            - "Loans from family or friends"
            - "Other loans"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: b28_parent_pay
          kind: QuestionGroup
          title: "Do the child's parents/guardians expect that they will pay for any part of his/her education costs in the following ways?"
          precondition:
            - predicate: has_postsec_plan == 1
          questions:
            - "Savings or investments they make before the child starts post-secondary studies"
            - "Income they earn while the child is attending post-secondary"
            - "Loans they take out and pay back after the child finishes post-secondary studies (not including student loans)"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: b29_other_funding
          kind: QuestionGroup
          title: "Do the child's parents/guardians expect that any part of his/her post-secondary education will be paid for by the following sources?"
          precondition:
            - predicate: has_postsec_plan == 1
          questions:
            - "Scholarships or awards based on academic performance"
            - "Grants or bursaries based on financial need"
            - "Gifts or inheritances"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

    # =========================================================================
    # SAVINGS FOR POST-SECONDARY EDUCATION (B31-B41)
    # Source: PDF p13-15
    # B30 Check Item (p13): If B20 = "Yes", go to B31. Otherwise, go to B42 (p15).
    # Only shown if respondent has saved (B20 = Yes / has_saved == 1)
    # =========================================================================
    - id: b_savings_details
      title: "Savings for Post-Secondary Education"
      items:
        - id: b31_age_started_saving
          kind: Question
          title: "How old was the child when these savings were first started? (If less than 1 year, enter 00)"
          precondition:
            - predicate: has_saved == 1
          input:
            control: Editbox
            min: 0
            max: 18
            right: "years old"

        - id: b32_saved_1998
          kind: Question
          title: "How much money was saved for the child's post-secondary education in 1998? Do not include any earnings or interest."
          precondition:
            - predicate: has_saved == 1
          input:
            control: Editbox
            min: 0
            max: 999999
            left: "$"

        - id: b33_saved_1999
          kind: Question
          title: "How much money has been saved for the child's post-secondary education so far in 1999? Do not include any earnings or interest."
          precondition:
            - predicate: has_saved == 1
          input:
            control: Editbox
            min: 0
            max: 999999
            left: "$"

        - id: b34_save_rest_1999
          kind: Question
          title: "How much money will be saved for the child in the rest of 1999?"
          precondition:
            - predicate: has_saved == 1
          input:
            control: Editbox
            min: 0
            max: 999999
            left: "$"

        - id: b35_total_saved
          kind: Question
          title: "Since starting to save for the child, how much in total has been saved for his/her post-secondary education? Do not include any earnings or interest."
          precondition:
            - predicate: has_saved == 1
          input:
            control: Editbox
            min: 0
            max: 999999
            left: "$"

        - id: b36_expected_total
          kind: Question
          title: "How much do you expect to have saved for the child's education by the time he/she starts post-secondary studies? Include all earnings and interest."
          precondition:
            - predicate: has_saved == 1
          input:
            control: Editbox
            min: 0
            max: 999999
            left: "$"

        # B37: Savings plan types (p14). Each sub-item asked individually for routing.
        # If ALL B37a,b,c,d are No/DK/Refused -> go to B42 (p15)
        - id: b37a_resp
          kind: Question
          title: "What types of savings plans are being used? - RESPs (Registered Education Savings Plans)"
          precondition:
            - predicate: has_saved == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
          codeBlock: |
            if b37a_resp.outcome == 1:
                has_resp = 1
            else:
                has_resp = 0

        - id: b37b_rrsp
          kind: Question
          title: "RRSPs (Registered Retirement Savings Plans)"
          precondition:
            - predicate: has_saved == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: b37c_trust
          kind: Question
          title: "In-trust-for accounts"
          precondition:
            - predicate: has_saved == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: b37d_other_plan
          kind: Question
          title: "Other savings plans"
          precondition:
            - predicate: has_saved == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
          codeBlock: |
            if b37a_resp.outcome == 1 or b37b_rrsp.outcome == 1 or b37c_trust.outcome == 1 or b37d_other_plan.outcome == 1:
                has_savings_plan = 1
            else:
                has_savings_plan = 0

        # B38: Investment types (p14). Only if has any savings plan.
        - id: b38_investments
          kind: QuestionGroup
          title: "Within these plans, how are the savings invested?"
          precondition:
            - predicate: has_savings_plan == 1
          questions:
            - "Mutual funds"
            - "Shares of corporations"
            - "Savings or chequing accounts"
            - "Savings bonds"
            - "Other"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # B39 Check Item (p14): If B37a = "Yes", go to B40. Otherwise, go to B42.
        # B40: RESP total contributions (only if has RESP)
        - id: b40_resp_total
          kind: Question
          title: "For the RESP only, how much money in total has been contributed to RESPs for the child by people living in your household?"
          precondition:
            - predicate: has_resp == 1
          input:
            control: Editbox
            min: 0
            max: 999999
            left: "$"

        # B41: RESP types (only if has RESP)
        - id: b41_resp_types
          kind: QuestionGroup
          title: "Which types of RESPs are being used?"
          precondition:
            - predicate: has_resp == 1
          questions:
            - "Individual plan (includes individual non-family and family RESPs)"
            - "Group plan (education scholarship trust or foundation)"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

    # =========================================================================
    # OUTSIDE HOUSEHOLD SAVINGS (B42-B43)
    # Source: PDF p15
    # All respondents reach B42.
    # B42: Yes -> B43; No/DK/Refused -> B44 check item
    # =========================================================================
    - id: b_outside_savings
      title: "Savings from Outside the Household"
      items:
        - id: b42_outside_savings
          kind: Question
          title: "Does anyone who does not live in your household have savings put aside for the child's post-secondary education?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
          codeBlock: |
            if b42_outside_savings.outcome == 1:
                has_outside_savings = 1
            else:
                has_outside_savings = 0

        - id: b43_outside_amount
          kind: Question
          title: "How much money in total have the people who don't live in your household put aside for the child's post-secondary education?"
          precondition:
            - predicate: has_outside_savings == 1
          input:
            control: Editbox
            min: 0
            max: 999999
            left: "$"

    # =========================================================================
    # SECTION F - CHILDREN OUTSIDE THE HOUSEHOLD
    # Source: PDF p47-48
    # F1: Yes -> F2; No -> Section G (p49)
    # F2-F7: savings details for outside children
    # F8: savings plan types. If ALL No/DK/Refused -> Section G
    # F9: If F8a = Yes -> F10; otherwise -> Section G
    # F10-F12: RESP details
    # =========================================================================
    - id: b_outside_children
      title: "Section F - Children Outside the Household"
      items:
        - id: f1_saving_outside
          kind: Question
          title: "Are you or anyone else living in your household saving for the post-secondary education of any children 18 years of age or younger who do not live in your household?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
          codeBlock: |
            if f1_saving_outside.outcome == 1:
                saving_outside_children = 1
            else:
                saving_outside_children = 0

        - id: f2_how_many_outside
          kind: Question
          title: "For how many children outside your household is money being saved?"
          precondition:
            - predicate: saving_outside_children == 1
          input:
            control: Editbox
            min: 1
            max: 20

        - id: f3_relationship_outside
          kind: Question
          title: "What is the relationship of these children to the people saving money for them?"
          precondition:
            - predicate: saving_outside_children == 1
          input:
            control: Checkbox
            labels:
              1: "Son"
              2: "Daughter"
              4: "Grandson"
              8: "Granddaughter"
              16: "Brother"
              32: "Sister"
              64: "Niece"
              128: "Nephew"
              256: "Other family member or relative"
              512: "Unrelated"

        - id: f4_saved_1998_outside
          kind: Question
          title: "How much money was saved for these children's education in 1998 by you or anyone living in your household? Do not include any earnings or interest."
          precondition:
            - predicate: saving_outside_children == 1
          input:
            control: Editbox
            min: 0
            max: 999999
            left: "$"

        - id: f5_saved_1999_outside
          kind: Question
          title: "How much money was saved for these children's education so far in 1999 by you or anyone living in your household? Do not include any earnings or interest."
          precondition:
            - predicate: saving_outside_children == 1
          input:
            control: Editbox
            min: 0
            max: 999999
            left: "$"

        - id: f6_save_rest_1999_outside
          kind: Question
          title: "How much money will you or anyone else in your household save for these children in the rest of 1999?"
          precondition:
            - predicate: saving_outside_children == 1
          input:
            control: Editbox
            min: 0
            max: 999999
            left: "$"

        - id: f7_total_saved_outside
          kind: Question
          title: "Since starting to save for these children, how much money in total has been saved by you or anyone else living in your household for their education? Do not include any earnings or interest."
          precondition:
            - predicate: saving_outside_children == 1
          input:
            control: Editbox
            min: 0
            max: 999999
            left: "$"

    # =========================================================================
    # SECTION G - GENERAL HOUSEHOLD INFORMATION
    # Source: PDF p49-52
    # G1 Check Item (p49):
    #   - Ages of ALL children 0-4 -> go to G4 (skip G2/G3)
    #   - Otherwise -> G2
    # G2/G3: school-age children only (at least one child age 5+)
    # G6: language; G8: financial priority; G9: income sources; G10: income
    # G11: data sharing consent
    # G12: If no children 0-18 -> END; otherwise -> G13
    # G13: school records linkage consent (children in household only)
    # =========================================================================
    - id: b_household
      title: "Section G - General Household Information"
      items:
        - id: g2_computer
          kind: Question
          title: "Is there a computer available in your household that the children can use to do their school work or assignments?"
          precondition:
            - predicate: all_children_under_5 == 0
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: g3_books
          kind: Question
          title: "Are there books or other reading materials in the home for the children to use to do school work or assignments? (e.g., encyclopaedias, reference books, CD ROMs)"
          precondition:
            - predicate: all_children_under_5 == 0
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: g6_language
          kind: Question
          title: "What is the language spoken most often in your household?"
          input:
            control: Dropdown
            labels:
              1: "English"
              2: "French"
              3: "Arabic"
              4: "Chinese"
              5: "German"
              6: "Italian"
              7: "Polish"
              8: "Portuguese"
              9: "Punjabi"
              10: "Spanish"
              11: "Tagalog (Filipino)"
              12: "Vietnamese"
              13: "Other"

        - id: g8_financial_priority
          kind: Question
          title: "From the following list, what is your household's highest financial priority?"
          input:
            control: Radio
            labels:
              1: "Everyday budget"
              2: "Savings for post-secondary education"
              3: "Retirement savings"
              4: "Other savings"

        - id: g9_income_sources
          kind: Question
          title: "Thinking about your total household income, from which of the following sources did your household receive any income in the past 12 months?"
          input:
            control: Checkbox
            labels:
              1: "Wages and salaries"
              2: "Income from self-employment"
              4: "Dividends and interest (e.g., on bonds, deposits)"
              8: "Employment insurance"
              16: "Workers' compensation"
              32: "Benefits from Canada or Quebec Pension Plan"
              64: "Retirement pensions, superannuation and annuities"
              128: "Old Age Security and Guaranteed Income Supplement"
              256: "Child Tax Benefit"
              512: "Provincial or municipal social assistance or welfare"
              1024: "Child support"
              2048: "Alimony"
              4096: "Other"

        - id: g10_household_income
          kind: Question
          title: "What is your best estimate of the total income before taxes and deductions of all household members from all sources in the past 12 months?"
          input:
            control: Radio
            labels:
              1: "Less than $5,000"
              2: "$5,000 to less than $10,000"
              3: "$10,000 to less than $15,000"
              4: "$15,000 to less than $20,000"
              5: "$20,000 to less than $30,000"
              6: "$30,000 to less than $40,000"
              7: "$40,000 to less than $50,000"
              8: "$50,000 to less than $60,000"
              9: "$60,000 to less than $80,000"
              10: "$80,000 or more"
              11: "No income"

        - id: g11_data_sharing
          kind: Question
          title: "Statistics Canada has entered into a data sharing agreement with Human Resources Development Canada. Do you agree to let Statistics Canada share your information? (Your name and other identifiers will not be shared.)"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: g13_school_records
          kind: Question
          title: "As part of a related statistical study, the information you provide during this interview, in future, may be combined with post-secondary school records about the children in your household. Do you agree to let Statistics Canada combine this information?"
          precondition:
            - predicate: all_children_under_5 == 0
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
