qmlVersion: "1.0"
questionnaire:
  title: "National Longitudinal Survey of Children and Youth (NLSCY) - Children's Questionnaire"
  codeInit: |
    # Child age in years (0-11) - the primary routing variable
    child_age = 0
    # Child age in months (0-47) for Motor/Social Development
    child_age_months = 0
    # Respondent relationship to child (from DVS-Q1)
    is_birth_parent = 0
    is_step_parent = 0
    is_adoptive_parent = 0
    is_foster_parent = 0
    is_parent_type = 0
    # Whether respondent is PMK (Person Most Knowledgeable)
    is_pmk = 1
    # Whether parents lived together at birth
    parents_together = 0
    # Whether parents broke up
    parents_broke_up = 0
    # Family status
    is_married_or_partner = 0
    is_female_bio_parent = 0
    # Section completed flags
    section_completed_another = 0
    # Has siblings in household
    has_siblings = 0
    # Vision routing
    vision_done = 0
    # Hearing routing
    hearing_done = 0
    # Smoking daily
    smokes_daily = 0
    # Alcohol consumed
    drinks_alcohol = 0
    # Binge drinking count
    binge_count = 0
    # Custody section routing
    custody_section_reached = 0
    # Parent death tracking
    parent_died = 0
    both_parents_died = 0

  blocks:
    # =========================================================================
    # BLOCK 1: CHILD DEMOGRAPHICS (DVS) - p43
    # =========================================================================
    - id: b_child_demographics
      title: "Child Demographics Verification"
      items:
        - id: dvs_intro
          kind: Comment
          title: "I need to confirm some of the information that we collected earlier, since it is important in determining which questions we need to ask you about the child."

        - id: dvs_q1
          kind: Question
          title: "What is your relationship to the child?"
          codeBlock: |
            if dvs_q1.outcome == 1:
                is_birth_parent = 1
                is_parent_type = 1
            elif dvs_q1.outcome == 2:
                is_step_parent = 1
                is_parent_type = 1
            elif dvs_q1.outcome == 3:
                is_adoptive_parent = 1
                is_parent_type = 1
            elif dvs_q1.outcome == 4:
                is_foster_parent = 1
                is_parent_type = 1
            else:
                is_parent_type = 0
          input:
            control: Radio
            labels:
              1: "Birth parent"
              2: "Step parent (including common-law parent)"
              3: "Adoptive parent"
              4: "Foster parent"
              5: "Sister/Brother"
              6: "Grandparent"
              7: "In-law"
              8: "Other related"
              9: "Unrelated"

        - id: dvs_child_age
          kind: Question
          title: "What is the child's age in years? (0 for under 1 year)"
          codeBlock: |
            child_age = dvs_child_age.outcome
          input:
            control: Editbox
            min: 0
            max: 11

        - id: dvs_child_age_months
          kind: Question
          title: "What is the child's age in months? (For children under 4 years)"
          precondition:
            - predicate: child_age < 4
          codeBlock: |
            child_age_months = dvs_child_age_months.outcome
          input:
            control: Editbox
            min: 0
            max: 47

        - id: dvs_child_sex
          kind: Question
          title: "What is the child's sex?"
          input:
            control: Radio
            labels:
              1: "Male"
              2: "Female"

        - id: dvs_has_siblings
          kind: Question
          title: "Does the child have brothers or sisters living in the household?"
          codeBlock: |
            if dvs_has_siblings.outcome == 1:
                has_siblings = 1
            else:
                has_siblings = 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # =========================================================================
    # BLOCK 2: CHILD HEALTH (HLT) - p44-57
    # NOTE p44: Age-tiered routing:
    #   AGE 0-1: HLT-Q1-Q4; HLT-QI37-Q45; HLT-Q45B-Q51E
    #   AGE 2-3: HLT-Q1-Q5; HLT-QI37-Q45; HLT-Q45B-Q51E
    #   AGE 4-5: HLT-Q1-Q5; HLT-Q6A,Q7A; HLT-Q8-Q19; HLT-Q20A,Q21,Q22A;
    #            HLT-Q23-Q45; HLT-Q45B; HLT-Q48A-Q52B
    #   AGE 6-11: HLT-Q1-HLT-Q5; HLT-Q6,Q7; HLT-Q8-Q19; HLT-Q20,Q21,Q22;
    #             HLT-Q23-Q44; HLT-Q45A,Q45B; HLT-Q48A-Q52B
    # =========================================================================
    - id: b_child_health
      title: "Child Health"
      items:
        - id: hlt_q1
          kind: Question
          title: "In general, would you say the child's health is:"
          input:
            control: Radio
            labels:
              1: "Excellent"
              2: "Very good"
              3: "Good"
              4: "Fair"
              5: "Poor"

        - id: hlt_q2
          kind: Question
          title: "Over the past few months, how often has he/she been in good health?"
          input:
            control: Radio
            labels:
              1: "Almost all the time"
              2: "Often"
              3: "About half of the time"
              4: "Sometimes"
              5: "Almost never"

        - id: hlt_q3
          kind: Question
          title: "What is his/her height in feet and inches or in metres/centimetres (without shoes on)?"
          input:
            control: Editbox
            min: 1
            max: 200

        - id: hlt_q4
          kind: Question
          title: "What is his/her weight in kilograms (and grams) or in pounds (and ounces)?"
          input:
            control: Editbox
            min: 1
            max: 200

        # HLT-C5 p45: IF AGE < 2 YEARS --> GO TO HLT-I37, OTHERWISE --> GO TO HLT-Q5
        - id: hlt_q5
          kind: Question
          title: "In your opinion, how physically active is the child compared to other children the same age and sex?"
          precondition:
            - predicate: child_age >= 2
          input:
            control: Radio
            labels:
              1: "Much more"
              2: "Moderately more"
              3: "Equally"
              4: "Moderately less"
              5: "Much less"

        # HLT-C6 p45: IF AGE = 0-3 --> GO TO HLT-I37, OTHERWISE --> GO TO HLT-I6
        # HEALTH STATUS section - ages 4+
        - id: hlt_i6
          kind: Comment
          title: "The next set of questions ask about the child's day to day health. The questions are not about illnesses like colds that affect people for short periods of time. They are concerned with his/her abilities relative to other children the same age."
          precondition:
            - predicate: child_age >= 4

        # VISION - p45-46
        # HLT-C6A: IF AGE > 6 --> GO TO HLT-Q6A, OTHERWISE --> GO TO HLT-Q6
        - id: hlt_q6
          kind: Question
          title: "Is he/she usually able to see well enough to read ordinary newsprint without glasses or contact lenses?"
          precondition:
            - predicate: child_age >= 6
          codeBlock: |
            if hlt_q6.outcome == 1:
                vision_done = 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # HLT-Q6A p46 - for ages 4-5
        - id: hlt_q6a
          kind: Question
          title: "Is he/she usually able to see clearly, and without distortion, the words in a story book without glasses or contact lenses?"
          precondition:
            - predicate: child_age >= 4 and child_age <= 5
          codeBlock: |
            if hlt_q6a.outcome == 1:
                vision_done = 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: hlt_q7
          kind: Question
          title: "Is he/she usually able to see well enough to read ordinary newsprint with glasses or contact lenses?"
          precondition:
            - predicate: child_age >= 6 and hlt_q6.outcome == 2
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Doesn't wear glasses or contact lenses"

        # HLT-Q7A p46 - for ages 4-5
        - id: hlt_q7a
          kind: Question
          title: "Is he/she usually able to see clearly, and without distortion, the words in a story book with glasses or contact lenses?"
          precondition:
            - predicate: child_age >= 4 and child_age <= 5 and hlt_q6a.outcome == 2
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Doesn't wear glasses or contact lenses"

        - id: hlt_q8
          kind: Question
          title: "Is he/she able to see at all?"
          precondition:
            - predicate: child_age >= 4 and vision_done == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: hlt_q9
          kind: Question
          title: "Is he/she able to see well enough to recognize a friend on the other side of the street without glasses or contact lenses?"
          precondition:
            - predicate: child_age >= 4 and vision_done == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: hlt_q10
          kind: Question
          title: "Is he/she usually able to see well enough to recognize a friend on the other side of the street with glasses or contact lenses?"
          precondition:
            - predicate: child_age >= 4 and hlt_q9.outcome == 0
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Doesn't wear glasses or contacts"

        # HEARING - p47
        - id: hlt_q11
          kind: Question
          title: "Is the child usually able to hear what is said in a group conversation with at least three other people without a hearing aid?"
          precondition:
            - predicate: child_age >= 4
          codeBlock: |
            if hlt_q11.outcome == 1:
                hearing_done = 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: hlt_q12
          kind: Question
          title: "Is he/she usually able to hear what is said in a group conversation with at least three other people with a hearing aid?"
          precondition:
            - predicate: child_age >= 4 and hlt_q11.outcome == 0
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Doesn't wear a hearing aid"

        - id: hlt_q13
          kind: Question
          title: "Is he/she able to hear at all?"
          precondition:
            - predicate: child_age >= 4 and hlt_q11.outcome == 0 and hlt_q12.outcome != 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: hlt_q14
          kind: Question
          title: "Is he/she usually able to hear what is said in a conversation with one other person in a quiet room without a hearing aid?"
          precondition:
            - predicate: child_age >= 4 and hearing_done == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: hlt_q15
          kind: Question
          title: "Is he/she usually able to hear what is said in a conversation with one other person in a quiet room with a hearing aid?"
          precondition:
            - predicate: child_age >= 4 and hlt_q14.outcome == 0
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Doesn't wear a hearing aid"

        # SPEECH - p48
        - id: hlt_q16
          kind: Question
          title: "Is the child usually able to be understood completely when speaking with strangers in his/her own language?"
          precondition:
            - predicate: child_age >= 4
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: hlt_q17
          kind: Question
          title: "Is he/she able to be understood partially when speaking with strangers in his/her own language?"
          precondition:
            - predicate: child_age >= 4 and hlt_q16.outcome == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: hlt_q18
          kind: Question
          title: "Is he/she able to be understood completely when speaking with those who know him/her well?"
          precondition:
            - predicate: child_age >= 4 and hlt_q16.outcome == 0 and hlt_q17.outcome == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: hlt_q19
          kind: Question
          title: "Is he/she able to be understood partially when speaking with those who know him/her well?"
          precondition:
            - predicate: child_age >= 4 and hlt_q16.outcome == 0 and hlt_q17.outcome == 0 and hlt_q18.outcome == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # GETTING AROUND - p49-50
        # HLT-C20 p49: IF AGE < 6 --> GO TO HLT-Q20A, OTHERWISE --> GO TO HLT-Q20
        - id: hlt_q20
          kind: Question
          title: "Is the child usually able to walk around the neighbourhood without difficulty and without mechanical support such as braces, a cane or crutches?"
          precondition:
            - predicate: child_age >= 6
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: hlt_q20a
          kind: Question
          title: "Is he/she usually able to walk without difficulty and without mechanical support such as braces, a cane or crutches?"
          precondition:
            - predicate: child_age >= 4 and child_age <= 5
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: hlt_q21
          kind: Question
          title: "Is he/she able to walk at all?"
          precondition:
            - predicate: child_age >= 4 and ((child_age >= 6 and hlt_q20.outcome == 0) or (child_age <= 5 and hlt_q20a.outcome == 0))
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # HLT-C22 p49: IF AGE < 6 --> GO TO HLT-Q22A, OTHERWISE --> GO TO HLT-Q22
        - id: hlt_q22
          kind: Question
          title: "Does he/she require mechanical support such as braces, a cane or crutches to be able to walk around the neighbourhood?"
          precondition:
            - predicate: child_age >= 6 and hlt_q21.outcome == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: hlt_q22a
          kind: Question
          title: "Does he/she require mechanical support such as braces, a cane or crutches to be able to walk?"
          precondition:
            - predicate: child_age >= 4 and child_age <= 5 and hlt_q21.outcome == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: hlt_q23
          kind: Question
          title: "Does he/she require the help of another person to be able to walk?"
          precondition:
            - predicate: child_age >= 4 and hlt_q21.outcome == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: hlt_q24
          kind: Question
          title: "Does he/she require a wheelchair to get around?"
          precondition:
            - predicate: child_age >= 4 and hlt_q21.outcome == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: hlt_q25
          kind: Question
          title: "How often does he/she use a wheelchair?"
          precondition:
            - predicate: child_age >= 4 and hlt_q24.outcome == 1
          input:
            control: Radio
            labels:
              1: "Always"
              2: "Often"
              3: "Sometimes"
              4: "Never"

        - id: hlt_q26
          kind: Question
          title: "Does he/she need the help of another person to get around in the wheelchair?"
          precondition:
            - predicate: child_age >= 4 and hlt_q24.outcome == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # HANDS AND FINGERS - p51
        - id: hlt_q27
          kind: Question
          title: "Is the child usually able to grasp and handle small objects such as a pencil or scissors?"
          precondition:
            - predicate: child_age >= 4
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: hlt_q28
          kind: Question
          title: "Does he/she require the help of another person because of limitations in the use of hands or fingers?"
          precondition:
            - predicate: child_age >= 4 and hlt_q27.outcome == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: hlt_q29
          kind: Question
          title: "Does he/she require the help of another person with:"
          precondition:
            - predicate: child_age >= 4 and hlt_q28.outcome == 1
          input:
            control: Radio
            labels:
              1: "Some tasks"
              2: "Most tasks"
              3: "Almost all tasks"
              4: "All tasks"

        - id: hlt_q30
          kind: Question
          title: "Does he/she require special equipment, for example, devices to assist in dressing because of limitations in the use of hands or fingers?"
          precondition:
            - predicate: child_age >= 4 and hlt_q27.outcome == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CHRONIC CONDITIONS - p52 (HLT-Q31 onwards)
        - id: hlt_q31
          kind: Question
          title: "Does the child have any of the following long-term conditions that have been diagnosed by a health professional: Asthma?"
          precondition:
            - predicate: child_age >= 4
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: hlt_q32
          kind: Question
          title: "Allergies (food/other)?"
          precondition:
            - predicate: child_age >= 4
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: hlt_q33
          kind: Question
          title: "Bronchitis?"
          precondition:
            - predicate: child_age >= 4
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: hlt_q34
          kind: Question
          title: "Heart condition or disease?"
          precondition:
            - predicate: child_age >= 4
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: hlt_q35
          kind: Question
          title: "Epilepsy?"
          precondition:
            - predicate: child_age >= 4
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: hlt_q36
          kind: Question
          title: "Cerebral palsy?"
          precondition:
            - predicate: child_age >= 4
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # INJURY AND MEDICAL - HLT-I37 onwards - ALL AGES
        - id: hlt_i37
          kind: Comment
          title: "The next questions are about injuries and medical conditions."

        - id: hlt_q37
          kind: Question
          title: "Since birth/in the past 12 months, has the child been injured seriously enough to require medical attention?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: hlt_q38
          kind: Question
          title: "How many times?"
          precondition:
            - predicate: hlt_q37.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 20

        - id: hlt_q39
          kind: Question
          title: "Thinking of the most recent injury, what type of injury was it?"
          precondition:
            - predicate: hlt_q37.outcome == 1
          input:
            control: Radio
            labels:
              1: "Broken bone/fracture"
              2: "Burn/scald"
              3: "Accidental poisoning"
              4: "Other"

    # =========================================================================
    # BLOCK 3: BEHAVIOUR (BEH) - p109-116
    # NOTE p109: Age-tiered:
    #   AGE 0-11 MONTHS: BEH-Q1-4, BEH-Q5A
    #   AGE 1 YEAR: BEH-Q1-Q5
    #   AGE 2-3 YEARS: BEH-Q1-Q5, BEH-I8A-Q8UU
    #   AGE 4-9 YEARS: BEH-I6A-Q6UU
    #   AGE 10-11 YEARS: BEH-I6A-Q7F
    # =========================================================================
    - id: b_behaviour
      title: "Child Behaviour"
      items:
        # BEH-C1 p109: IF AGE > 3 --> GO TO BEH-I6A, OTHERWISE --> GO TO BEH-Q1

        # AGE 0-3 YEARS: Sleep patterns
        - id: beh_q1
          kind: Question
          title: "The following questions relate to the child's sleep patterns. When you put him/her to bed, how often does he/she have trouble falling asleep?"
          precondition:
            - predicate: child_age <= 3
          input:
            control: Radio
            labels:
              1: "Almost every time"
              2: "Often"
              3: "About half of the time"
              4: "Sometimes"
              5: "Almost never"

        - id: beh_q2
          kind: Question
          title: "Does he/she have a particular and long routine (more than 30 minutes) to go to bed that he/she cannot go to sleep without?"
          precondition:
            - predicate: child_age <= 3
          input:
            control: Radio
            labels:
              1: "Almost every time"
              2: "Often"
              3: "About half of the time"
              4: "Sometimes"
              5: "Almost never"

        - id: beh_q3
          kind: Question
          title: "Does the child wake up several times during his/her sleep?"
          precondition:
            - predicate: child_age <= 3
          input:
            control: Radio
            labels:
              1: "Almost every time"
              2: "Often"
              3: "About half of the time"
              4: "Sometimes"
              5: "Almost never"

        - id: beh_q4
          kind: Question
          title: "Does he/she have a restless sleep?"
          precondition:
            - predicate: child_age <= 3
          input:
            control: Radio
            labels:
              1: "Almost every time"
              2: "Often"
              3: "About half of the time"
              4: "Sometimes"
              5: "Almost never"

        # BEH-C5 p110: IF AGE < 1 --> GO TO BEH-Q5A, OTHERWISE --> GO TO BEH-Q5
        - id: beh_q5
          kind: Question
          title: "How does the child react to new foods (orange juice, apple puree, porridge, vegetables, etc.)?"
          precondition:
            - predicate: child_age >= 1 and child_age <= 3
          input:
            control: Radio
            labels:
              1: "Swallows everything without complaining"
              2: "Made faces first but after a few tries, got used to it"
              3: "Continued to refuse most of the new foods"

        - id: beh_q5a
          kind: Question
          title: "How often do you find him/her difficult to feed?"
          precondition:
            - predicate: child_age == 0
          input:
            control: Radio
            labels:
              1: "Almost every time"
              2: "Often"
              3: "About half of the time"
              4: "Sometimes"
              5: "Almost never"

        # AGE 4-11 YEARS: Behaviour scale (BEH-I6A/Q6A-Q6UU) p111-113
        - id: beh_i6a
          kind: Comment
          title: "Now I'd like to ask you questions about how the child seems to feel or act."
          precondition:
            - predicate: child_age >= 4

        - id: beh_q6_behaviour
          kind: QuestionGroup
          title: "Using the answers never or not true, sometimes or somewhat true, or often or very true, how often would you say that the child:"
          precondition:
            - predicate: child_age >= 4
          questions:
            - "Shows sympathy to someone who has made a mistake"
            - "Can't sit still, is restless, or hyperactive"
            - "Destroys his/her own things"
            - "Will try to help someone who has been hurt"
            - "Steals at home"
            - "Seems to be unhappy, sad, or depressed"
            - "Gets into many fights"
            - "Volunteers to help clear up a mess someone else has made"
            - "Is distractible, has trouble sticking to any activity"
            - "When mad at someone, tries to get others to dislike that person"
            - "Is not as happy as other children"
            - "Destroys things belonging to his/her family, or other children"
            - "If there is a quarrel or dispute, will try to stop it"
            - "Fidgets"
            - "Is disobedient at school"
            - "Can't concentrate, can't pay attention for long"
            - "Is too fearful or anxious"
            - "When mad at someone, becomes friends with another as revenge"
            - "Is impulsive, acts without thinking"
            - "Tells lies or cheats"
          input:
            control: Radio
            labels:
              1: "Never or not true"
              2: "Sometimes or somewhat true"
              3: "Often or very true"

        - id: beh_q6_prosocial
          kind: QuestionGroup
          title: "How often would you say the child:"
          precondition:
            - predicate: child_age >= 4
          questions:
            - "Offers to help other children who are having difficulty with a task"
            - "Is worried"
            - "Has difficulty awaiting turn in games or groups"
            - "Assumes another child meant to hurt when it was accidental, reacts with anger"
            - "Tends to do things on his/her own - is rather solitary"
            - "Says bad things about others behind their back"
            - "Physically attacks people"
            - "Comforts a child who is crying or upset"
            - "Cries a lot"
            - "Vandalizes"
            - "Gives up easily"
            - "Threatens people"
            - "Spontaneously helps to pick up objects dropped by others"
            - "Cannot settle to anything for more than a few moments"
            - "Appears miserable, unhappy, tearful, or distressed"
            - "Is cruel, bullies or is mean to others"
            - "Stares into space"
          input:
            control: Radio
            labels:
              1: "Never or not true"
              2: "Sometimes or somewhat true"
              3: "Often or very true"

        - id: beh_q6_ext
          kind: QuestionGroup
          title: "How often would you say the child:"
          precondition:
            - predicate: child_age >= 4
          questions:
            - "When mad at someone, says: let's not be with him/her"
            - "Is nervous, highstrung or tense"
            - "Kicks, bites, hits other children"
            - "Will invite bystanders to join in a game"
            - "Steals outside the home"
            - "Is inattentive"
            - "Has trouble enjoying him/herself"
            - "Helps other children who are feeling sick"
            - "When mad at someone, tells the other one's secrets to a third person"
            - "Takes the opportunity to praise the work of less able children"
          input:
            control: Radio
            labels:
              1: "Never or not true"
              2: "Sometimes or somewhat true"
              3: "Often or very true"

        # BEH-C7A p113: IF AGE < 10 --> GO TO MOTOR AND SOCIAL DEVELOPMENT SECTION
        # OTHERWISE --> GO TO BEH-I7A
        # AGE 10-11: Difficult behaviours
        - id: beh_i7a
          kind: Comment
          title: "Now I'd like to ask you about certain difficult behaviours which some children may show at this age."
          precondition:
            - predicate: child_age >= 10

        - id: beh_q7_difficult
          kind: QuestionGroup
          title: "In the past year, about how many times has the child:"
          precondition:
            - predicate: child_age >= 10
          questions:
            - "Stayed out later than you said he/she should"
            - "Stayed out all night without permission"
            - "Skipped a day of school without permission"
            - "Gotten drunk"
            - "Been questioned by the police"
          input:
            control: Radio
            labels:
              1: "Never"
              2: "Once"
              3: "Twice"
              4: "More than twice"

        - id: beh_q7f
          kind: Question
          title: "Has he/she ever run away from home?"
          precondition:
            - predicate: child_age >= 10
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # AGE 2-3 YEARS: Toddler behaviour scale (BEH-I8A/Q8B-Q8UU) p114-116
        - id: beh_i8a
          kind: Comment
          title: "Now I'd like to ask you questions about how the child seems to feel or act."
          precondition:
            - predicate: child_age >= 2 and child_age <= 3

        - id: beh_q8_toddler
          kind: QuestionGroup
          title: "Using the answers never or not true, sometimes or somewhat true, or often or very true, how often would you say that the child:"
          precondition:
            - predicate: child_age >= 2 and child_age <= 3
          questions:
            - "Can't sit still, is restless, or hyperactive"
            - "Will try to help someone who has been hurt"
            - "Is defiant"
            - "Seems to be unhappy, sad, or depressed"
            - "Gets into many fights"
            - "Is distractible, has trouble sticking to any activity"
            - "Doesn't seem to feel guilty after misbehaving"
            - "Is not as happy as other children"
            - "Fidgets"
            - "Can't concentrate, can't pay attention for long"
            - "Is too fearful or anxious"
            - "Punishment doesn't change his/her behaviour"
            - "Is impulsive, acts without thinking"
            - "Has temper tantrums or hot temper"
          input:
            control: Radio
            labels:
              1: "Never or not true"
              2: "Sometimes or somewhat true"
              3: "Often or very true"

        - id: beh_q8_toddler2
          kind: QuestionGroup
          title: "How often would you say the child:"
          precondition:
            - predicate: child_age >= 2 and child_age <= 3
          questions:
            - "Offers to help other children having difficulty with a task"
            - "Is worried"
            - "Has difficulty awaiting turn in games or groups"
            - "Assumes accidental hurt was intentional, reacts with anger"
            - "Has angry moods"
            - "Comforts a child who is crying or upset"
            - "Cries a lot"
            - "Clings to adults or is too dependent"
            - "Gives up easily"
            - "Cannot settle to anything for more than a few moments"
            - "Stares into space"
            - "Constantly seeks help"
            - "Is nervous, highstrung or tense"
            - "Kicks, bites, hits other children"
            - "Doesn't want to sleep alone"
            - "Is inattentive"
            - "Has trouble enjoying him/herself"
            - "Helps other children who are feeling sick"
            - "Gets too upset when separated from parents"
            - "Takes the opportunity to praise the work of less able children"
          input:
            control: Radio
            labels:
              1: "Never or not true"
              2: "Sometimes or somewhat true"
              3: "Often or very true"

    # =========================================================================
    # BLOCK 4: MOTOR AND SOCIAL DEVELOPMENT (MSD) - p117-121
    # NOTE p117: Asked for children 0 to 47 months only
    # Age-tiered by month ranges with progressive milestones
    # =========================================================================
    - id: b_motor_social_dev
      title: "Motor and Social Development"
      items:
        # MSD-C1 p117: IF AGE > 3 YEARS --> GO TO RELATIONSHIPS SECTION
        - id: msd_i1
          kind: Comment
          title: "The following questions are about the child's motor and social development."
          precondition:
            - predicate: child_age <= 3

        # AGE 0-3 MONTHS: MSD-Q1 to Q15
        - id: msd_q_0_3
          kind: QuestionGroup
          title: "Has the child ever done the following?"
          precondition:
            - predicate: child_age_months <= 3 and child_age <= 3
          questions:
            - "Turned his/her head from side to side when lying on stomach"
            - "Eyes followed a moving object"
            - "Lifted head off the surface when on stomach"
            - "Eyes followed moving object all the way from one side to the other"
            - "Smiled at someone when that person talked to or smiled at him/her"
            - "Raised head and chest from surface while resting on lower arms or hands"
            - "Turned his/her head around to look at something"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # AGE 4-6 MONTHS: MSD-Q8 to Q22
        - id: msd_q_4_15
          kind: QuestionGroup
          title: "Has the child ever done the following?"
          precondition:
            - predicate: child_age_months >= 4 and child_age_months <= 15 and child_age <= 3
          questions:
            - "Held head steady when pulled to sitting position"
            - "Laughed out loud without being tickled or touched"
            - "Held in one hand a moderate size object such as a block or a rattle"
            - "Rolled over on his/her own on purpose"
            - "Seemed to enjoy looking in the mirror at him/herself"
            - "Pulled from sitting to standing and supported own weight"
            - "Looked around for a toy which was lost or not nearby"
            - "Sat alone with no help"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # AGE 7-12 MONTHS: MSD-Q12 to Q32
        - id: msd_q_7_21
          kind: QuestionGroup
          title: "Has the child ever done the following?"
          precondition:
            - predicate: child_age_months >= 7 and child_age_months <= 21 and child_age <= 3
          questions:
            - "Sat for 10 minutes without any support at all"
            - "Pulled him/herself to standing position without help"
            - "Crawled when left lying on his/her stomach"
            - "Said any recognizable words such as mama or dada"
            - "Picked up small objects using only thumb and first finger"
            - "Walked at least 2 steps with one hand held or holding on to something"
            - "Waved good-bye without help from another person"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # AGE 10-21 MONTHS additional milestones
        - id: msd_q_10_32
          kind: QuestionGroup
          title: "Has the child ever done the following?"
          precondition:
            - predicate: child_age_months >= 10 and child_age_months <= 32 and child_age <= 3
          questions:
            - "Shown by behavior that he/she knows the names of common objects"
            - "Shown wanting something by pointing, pulling, or making pleasant sounds"
            - "Stood alone on feet for 10 seconds or more without holding on"
            - "Walked at least 2 steps without holding on to anything"
            - "Crawled up at least 2 stairs or steps"
            - "Said 2 recognizable words besides mama or dada"
            - "Run"
            - "Said the name of a familiar object, such as a ball"
            - "Made a line with a crayon or pencil"
            - "Walked up at least 2 stairs with one hand held or holding the railing"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # AGE 13-47 MONTHS advanced milestones
        - id: msd_q_13_48
          kind: QuestionGroup
          title: "Has the child ever done the following?"
          precondition:
            - predicate: child_age_months >= 13 and child_age_months <= 47 and child_age <= 3
          questions:
            - "Fed him/herself with a spoon or fork without spilling much"
            - "Let someone know wearing wet pants or diapers bothered him/her"
            - "Spoken a partial sentence of 3 words or more"
            - "Walked up stairs by him/herself without holding on to a rail"
            - "Washed and dried his/her hands without any help except for turning the water"
            - "Counted 3 objects correctly"
            - "Gone to the toilet alone"
            - "Walked upstairs by him/herself with no help stepping on each step with one foot"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # AGE 19-47 MONTHS advanced milestones
        - id: msd_q_19_48
          kind: QuestionGroup
          title: "Has the child ever done the following?"
          precondition:
            - predicate: child_age_months >= 19 and child_age_months <= 47 and child_age <= 3
          questions:
            - "Knows his/her own age and sex"
            - "Said the names of at least 4 colors"
            - "Pedaled a tricycle at least 10 feet"
            - "Done a somersault without help from anybody"
            - "Dressed him/herself without any help except for tying shoes and buttoning backs"
            - "Said his/her first and last name together without someone's help"
            - "Counted out loud up to 10"
            - "Drawn a picture of a person with at least 2 parts of the body besides head"
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # =========================================================================
    # BLOCK 5: RELATIONSHIPS (REL) - p122-124
    # NOTE p122: Asked of children 4-11 only
    # Age-tiered: 4-5, 6-7, 8-11
    # =========================================================================
    - id: b_relationships
      title: "Relationships"
      items:
        # REL-C1 p122: IF AGE < 4 --> GO TO PARENTING SECTION
        - id: rel_i1
          kind: Comment
          title: "The next few questions are about the child's relationships with friends, family and others."
          precondition:
            - predicate: child_age >= 4

        - id: rel_q1
          kind: Question
          title: "About how many days a week does he/she do things with friends?"
          precondition:
            - predicate: child_age >= 4
          input:
            control: Radio
            labels:
              1: "Never"
              2: "1 day a week"
              3: "2-3 days a week"
              4: "4-5 days a week"
              5: "6-7 days a week"

        # REL-C2 p122: IF AGE < 6 --> GO TO REL-Q6, OTHERWISE --> GO TO REL-Q2
        - id: rel_q2
          kind: Question
          title: "About how many close friends does he/she have?"
          precondition:
            - predicate: child_age >= 6
          input:
            control: Radio
            labels:
              1: "None"
              2: "1"
              3: "2 or 3"
              4: "4 or 5"
              5: "6 or more"

        # REL-C3 p123: IF AGE < 8 --> GO TO REL-Q6
        - id: rel_q3
          kind: Question
          title: "How many of his/her close friends do you know by sight and by first and last name?"
          precondition:
            - predicate: child_age >= 8
          input:
            control: Radio
            labels:
              1: "All"
              2: "Most"
              3: "About half"
              4: "Only a few"
              5: "None"

        # REL-C4 p123: IF AGE < 8 --> GO TO REL-Q6
        - id: rel_q4
          kind: Question
          title: "When it comes to meeting new children and making new friends is he/she:"
          precondition:
            - predicate: child_age >= 8
          input:
            control: Radio
            labels:
              1: "Somewhat shy"
              2: "About average"
              3: "Very outgoing - makes friends easily"

        - id: rel_q5
          kind: Question
          title: "How often does he/she hang around with kids you think are frequently in trouble?"
          precondition:
            - predicate: child_age >= 8
          input:
            control: Radio
            labels:
              1: "Often"
              2: "Sometimes"
              3: "Seldom"
              4: "Never"

        - id: rel_q6
          kind: Question
          title: "During the past 6 months, how well has the child gotten along with other kids, such as friends or classmates (excluding brothers or sisters)?"
          precondition:
            - predicate: child_age >= 4
          input:
            control: Radio
            labels:
              1: "Very well, no problems"
              2: "Quite well, hardly any problems"
              3: "Pretty well, occasional problems"
              4: "Not too well, frequent problems"
              5: "Not well at all, constant problems"
              6: "Not applicable"

        - id: rel_q7
          kind: Question
          title: "Since starting school in the fall, how well has he/she gotten along with his/her teacher(s) at school?"
          precondition:
            - predicate: child_age >= 4
          input:
            control: Radio
            labels:
              1: "Very well, no problems"
              2: "Quite well, hardly any problems"
              3: "Pretty well, occasional problems"
              4: "Not too well, frequent problems"
              5: "Not well at all, constant problems"
              6: "Not applicable"

        - id: rel_q8
          kind: Question
          title: "During the past 6 months, how well has he/she gotten along with his/her parent(s)?"
          precondition:
            - predicate: child_age >= 4
          input:
            control: Radio
            labels:
              1: "Very well, no problems"
              2: "Quite well, hardly any problems"
              3: "Pretty well, occasional problems"
              4: "Not too well, frequent problems"
              5: "Not well at all, constant problems"

        # REL-C9 p124: IF NO BROTHERS OR SISTERS IN HOUSEHOLD --> GO TO PARENTING
        - id: rel_q9
          kind: Question
          title: "During the past 6 months, how well has the child gotten along with his/her brother(s)/sister(s)?"
          precondition:
            - predicate: child_age >= 4 and has_siblings == 1
          input:
            control: Radio
            labels:
              1: "Very well, no problems"
              2: "Quite well, hardly any problems"
              3: "Pretty well, occasional problems"
              4: "Not too well, frequent problems"
              5: "Not well at all, constant problems"

    # =========================================================================
    # BLOCK 6: PARENTING (PAR) - p125-129
    # NOTE p125: Only if respondent is birth, step or adoptive parent
    # AGE 0-23 MONTHS: PAR-I1-Q7A
    # AGE 2-11 YEARS: PAR-I1-Q28
    # =========================================================================
    - id: b_parenting
      title: "Parenting"
      items:
        # PAR-C1 p125: IF FOSTER PARENT --> GO TO CUSTODY SECTION
        # ELSE IF PMK OR SPOUSE/PARTNER --> GO TO PAR-I1
        # OTHERWISE --> GO TO CUSTODY SECTION
        - id: par_i1
          kind: Comment
          title: "The following questions have to do with things that the child does and ways that you react to him/her."
          precondition:
            - predicate: is_parent_type == 1 and is_foster_parent == 0

        - id: par_q1
          kind: Question
          title: "How often do you praise the child, by saying something like 'Good for you!' or 'That's good going!'?"
          precondition:
            - predicate: is_parent_type == 1 and is_foster_parent == 0
          input:
            control: Radio
            labels:
              1: "Never"
              2: "About once a week or less"
              3: "A few times a week"
              4: "One or two times a day"
              5: "Many times each day"

        - id: par_q2
          kind: Question
          title: "How often do you and he/she talk or play with each other, focusing attention on each other for five minutes or more, just for fun?"
          precondition:
            - predicate: is_parent_type == 1 and is_foster_parent == 0
          input:
            control: Radio
            labels:
              1: "Never"
              2: "About once a week or less"
              3: "A few times a week"
              4: "One or two times a day"
              5: "Many times each day"

        - id: par_q3
          kind: Question
          title: "How often do you and he/she laugh together?"
          precondition:
            - predicate: is_parent_type == 1 and is_foster_parent == 0
          input:
            control: Radio
            labels:
              1: "Never"
              2: "About once a week or less"
              3: "A few times a week"
              4: "One or two times a day"
              5: "Many times each day"

        - id: par_q4
          kind: Question
          title: "How often do you get annoyed with the child for saying or doing something he/she is not supposed to?"
          precondition:
            - predicate: is_parent_type == 1 and is_foster_parent == 0
          input:
            control: Radio
            labels:
              1: "Never"
              2: "About once a week or less"
              3: "A few times a week"
              4: "One or two times a day"
              5: "Many times each day"

        - id: par_q5
          kind: Question
          title: "How often do you tell him/her that he/she is bad or not as good as others?"
          precondition:
            - predicate: is_parent_type == 1 and is_foster_parent == 0
          input:
            control: Radio
            labels:
              1: "Never"
              2: "About once a week or less"
              3: "A few times a week"
              4: "One or two times a day"
              5: "Many times each day"

        - id: par_q6
          kind: Question
          title: "How often do you do something special with him/her that he/she enjoys?"
          precondition:
            - predicate: is_parent_type == 1 and is_foster_parent == 0
          input:
            control: Radio
            labels:
              1: "Never"
              2: "About once a week or less"
              3: "A few times a week"
              4: "One or two times a day"
              5: "Many times each day"

        # PAR-C7 p126: IF AGE < 3 --> GO TO PAR-Q7A, OTHERWISE --> GO TO PAR-Q7
        - id: par_q7
          kind: Question
          title: "How often do you play sports, hobbies or games with him/her?"
          precondition:
            - predicate: is_parent_type == 1 and is_foster_parent == 0 and child_age >= 3
          input:
            control: Radio
            labels:
              1: "Never"
              2: "About once a week or less"
              3: "A few times a week"
              4: "One or two times a day"
              5: "Many times each day"

        - id: par_q7a
          kind: Question
          title: "How often do you play games with him/her?"
          precondition:
            - predicate: is_parent_type == 1 and is_foster_parent == 0 and child_age < 3
          input:
            control: Radio
            labels:
              1: "Never"
              2: "About once a week or less"
              3: "A few times a week"
              4: "One or two times a day"
              5: "Many times each day"

        # PAR-C8 p126: IF AGE < 2 --> GO TO CUSTODY SECTION, OTHERWISE --> GO TO PAR-I8A
        - id: par_i8a
          kind: Comment
          title: "Now, we know that when parents spend time together with their children, some of the time things go well and some of the time they don't go well. For the following questions, I would like you to tell me what proportion of the time things turn out in different ways."
          precondition:
            - predicate: is_parent_type == 1 and is_foster_parent == 0 and child_age >= 2

        - id: par_q8
          kind: Question
          title: "Of all the times that you talk to the child about his/her behaviour, what proportion is praise?"
          precondition:
            - predicate: is_parent_type == 1 and is_foster_parent == 0 and child_age >= 2
          input:
            control: Radio
            labels:
              1: "Never"
              2: "Less than half the time"
              3: "About half the time"
              4: "More than half the time"
              5: "All the time"

        - id: par_q9
          kind: Question
          title: "Of all the times that you talk to him/her about his/her behaviour, what proportion is disapproval?"
          precondition:
            - predicate: is_parent_type == 1 and is_foster_parent == 0 and child_age >= 2
          input:
            control: Radio
            labels:
              1: "Never"
              2: "Less than half the time"
              3: "About half the time"
              4: "More than half the time"
              5: "All the time"

        - id: par_q10
          kind: Question
          title: "When you give him/her a command or order to do something, what proportion of the time do you make sure that he/she does it?"
          precondition:
            - predicate: is_parent_type == 1 and is_foster_parent == 0 and child_age >= 2
          input:
            control: Radio
            labels:
              1: "Never"
              2: "Less than half the time"
              3: "About half the time"
              4: "More than half the time"
              5: "All the time"

        # PAR-I19A p128: Discipline methods
        - id: par_i19a
          kind: Comment
          title: "Just about all children break the rules or do things that they are not supposed to. Also, parents react in different ways. Please tell me how often you do each of the following when the child breaks the rules."
          precondition:
            - predicate: is_parent_type == 1 and is_foster_parent == 0 and child_age >= 2

        - id: par_discipline
          kind: QuestionGroup
          title: "How often do you:"
          precondition:
            - predicate: is_parent_type == 1 and is_foster_parent == 0 and child_age >= 2
          questions:
            - "Tell him/her to stop"
            - "Ignore it, do nothing"
            - "Raise your voice, scold or yell at him/her"
            - "Calmly discuss the problem"
            - "Use physical punishment"
            - "Describe alternative ways of behaving that are acceptable"
            - "Take away privileges or put in room"
          input:
            control: Radio
            labels:
              1: "Always"
              2: "Often"
              3: "Sometimes"
              4: "Rarely"
              5: "Never"

        # PAR-Q26A p128 - Food security
        - id: par_q26a
          kind: Question
          title: "Has he/she ever experienced being hungry because the family has run out of food or money to buy food?"
          precondition:
            - predicate: is_parent_type == 1 and is_foster_parent == 0 and child_age >= 2
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: par_q26b
          kind: Question
          title: "How often?"
          precondition:
            - predicate: is_parent_type == 1 and is_foster_parent == 0 and child_age >= 2 and par_q26a.outcome == 1
          input:
            control: Radio
            labels:
              1: "Regularly, end of the month"
              2: "More often than end of each month"
              3: "Every few months"
              4: "Occasionally, not a regular occurrence"

        # PAR-Q27 p129 - Violence exposure
        - id: par_q27
          kind: Question
          title: "How often does he/she see television shows or movies that have a lot of violence in them?"
          precondition:
            - predicate: is_parent_type == 1 and is_foster_parent == 0 and child_age >= 2
          input:
            control: Radio
            labels:
              1: "Often"
              2: "Sometimes"
              3: "Seldom"
              4: "Never"

        - id: par_q28
          kind: Question
          title: "How often does he/she see adults or teenagers in your house physically fighting, hitting or otherwise trying to hurt others?"
          precondition:
            - predicate: is_parent_type == 1 and is_foster_parent == 0 and child_age >= 2
          input:
            control: Radio
            labels:
              1: "Often"
              2: "Sometimes"
              3: "Seldom"
              4: "Never"

    # =========================================================================
    # BLOCK 7: FAMILY AND CUSTODY HISTORY (CUS) - p130-151
    # NOTE p130: Only if respondent is biological, step or adoptive parent
    # CUS-C1: IF FOSTER PARENT --> GO TO CHILD CARE SECTION
    # Complex routing based on whether parents were together at birth
    # =========================================================================
    - id: b_custody
      title: "Family and Custody History"
      items:
        # CUS-C1 p130: IF FOSTER PARENT (DVS-Q1=4) --> GO TO CHILD CARE
        # ELSE IF PMK OR SPOUSE/PARTNER --> GO TO CUS-I1
        - id: cus_i1
          kind: Comment
          title: "I would now like to ask you some questions about the family history of the child."
          precondition:
            - predicate: is_parent_type == 1 and is_foster_parent == 0

        - id: cus_q1a
          kind: Question
          title: "Did the child live with you when he/she was born?"
          precondition:
            - predicate: is_parent_type == 1 and is_foster_parent == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: cus_q2
          kind: Question
          title: "When the child was born/adopted, were his/her parents (biological/adoptive) living together?"
          precondition:
            - predicate: is_parent_type == 1 and is_foster_parent == 0
          codeBlock: |
            if cus_q2.outcome == 1:
                parents_together = 1
            else:
                parents_together = 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # PARENTS WERE TOGETHER: Information on union (p134)
        - id: cus_q3a
          kind: Question
          title: "When the child was born/adopted, were his/her parents married, were they living together in a common-law relationship, or were they living together and eventually got married?"
          precondition:
            - predicate: is_parent_type == 1 and is_foster_parent == 0 and parents_together == 1
          codeBlock: |
            if cus_q3a.outcome == 1 or cus_q3a.outcome == 3:
                is_married_or_partner = 1
            else:
                is_married_or_partner = 0
          input:
            control: Radio
            labels:
              1: "Married"
              2: "Common law"
              3: "Common-law, but married later"

        # PARENTS NOT TOGETHER: Living arrangement at birth (p135)
        - id: cus_q4
          kind: Question
          title: "Did the child live with his/her:"
          precondition:
            - predicate: is_parent_type == 1 and is_foster_parent == 0 and parents_together == 0
          input:
            control: Radio
            labels:
              1: "Mother alone"
              2: "Father alone"
              3: "Mother and other"
              4: "Father and other"
              5: "Other"

        - id: cus_q5a
          kind: Question
          title: "Have the child's parents ever lived together as a couple?"
          precondition:
            - predicate: is_parent_type == 1 and is_foster_parent == 0 and parents_together == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: cus_q5b
          kind: Question
          title: "Was that before or after his/her birth?"
          precondition:
            - predicate: is_parent_type == 1 and is_foster_parent == 0 and parents_together == 0 and cus_q5a.outcome == 1
          input:
            control: Radio
            labels:
              1: "Before"
              2: "After"
              3: "Both before and after"

        # Mother's previous unions - CUS-Q6A (p136)
        - id: cus_q6a
          kind: Question
          title: "Had the child's mother been in any common-law relationships or been married before the union with the child's father?"
          precondition:
            - predicate: is_parent_type == 1 and is_foster_parent == 0
          input:
            control: Radio
            labels:
              1: "Yes, common-law"
              2: "Yes, marriage"
              3: "Yes, common law which resulted in marriage"
              4: "No"

        # Death of parent - CUS-Q9A (p141)
        - id: cus_q9a
          kind: Question
          title: "Between the child's birth and now, has one of his/her parents died?"
          precondition:
            - predicate: is_parent_type == 1 and is_foster_parent == 0
          codeBlock: |
            if cus_q9a.outcome == 1 or cus_q9a.outcome == 2:
                parent_died = 1
            elif cus_q9a.outcome == 3:
                parent_died = 1
                both_parents_died = 1
            else:
                parent_died = 0
          input:
            control: Radio
            labels:
              1: "Yes, mother"
              2: "Yes, father"
              3: "Yes, both"
              4: "No"

        # Whether parents broke up - CUS-Q10B (p143)
        - id: cus_q10b
          kind: Question
          title: "Since the child's birth, did his/her parents break up and stop living together?"
          precondition:
            - predicate: is_parent_type == 1 and is_foster_parent == 0 and parent_died == 0
          codeBlock: |
            if cus_q10b.outcome == 1:
                parents_broke_up = 1
            else:
                parents_broke_up = 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # PARENTS BROKE UP - Information on separation (p143)
        - id: cus_q11d
          kind: Question
          title: "Was there a court order concerning the child's custody when his/her parents separated or divorced?"
          precondition:
            - predicate: is_parent_type == 1 and is_foster_parent == 0 and parents_broke_up == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "Yes, in progress"
              3: "No"

        - id: cus_q11e
          kind: Question
          title: "Did the court order him/her to be put into:"
          precondition:
            - predicate: is_parent_type == 1 and is_foster_parent == 0 and parents_broke_up == 1 and cus_q11d.outcome == 1
          input:
            control: Radio
            labels:
              1: "Sole custody of mother"
              2: "Sole custody of father"
              3: "Shared physical custody of both parents"
              4: "Other"

        - id: cus_q11f
          kind: Question
          title: "What type of agreement was made regarding support/maintenance payments when the child's parents separated or divorced?"
          precondition:
            - predicate: is_parent_type == 1 and is_foster_parent == 0 and parents_broke_up == 1
          input:
            control: Radio
            labels:
              1: "None"
              2: "Private agreement between spouses"
              3: "Court-ordered agreement in progress"
              4: "Court-ordered agreement"

        - id: cus_q19c
          kind: Question
          title: "Between the child's parents, has the question of living arrangements or visiting rights been:"
          precondition:
            - predicate: is_parent_type == 1 and is_foster_parent == 0 and parents_broke_up == 1
          input:
            control: Radio
            labels:
              1: "A great source of tension"
              2: "Some source of tension"
              3: "Very little source of tension"
              4: "No source of tension at all"

    # =========================================================================
    # BLOCK 8: ACTIVITIES (ACT) - p105-108
    # NOTE p105: Age-tiered:
    #   AGE 0-3: ACT-Q1-Q2B
    #   AGE 4-5: ACT-Q1-Q3D1, ACT-Q3E-Q5
    #   AGE 6-7: ACT-Q3A-Q3C, ACT-Q3D2, ACT-Q3E-Q5, ACT-Q7A-Q8B
    #   AGE 8-9: ACT-Q3A-Q3C, ACT-Q3D2, ACT-Q3E-Q5, ACT-Q7A-Q8B
    #   AGE 10-11: ACT-Q3A-Q3C, ACT-Q3D3-Q8B
    # =========================================================================
    - id: b_activities
      title: "Activities"
      items:
        - id: act_i1
          kind: Comment
          title: "The next few questions are about the child's interests and activities."

        # ACT-C1 p105: IF AGE > 5 --> GO TO ACT-Q3A, OTHERWISE --> GO TO ACT-Q1
        - id: act_q1
          kind: Question
          title: "Does he/she currently attend any nursery school, play group or other early childhood program or activity?"
          precondition:
            - predicate: child_age <= 5
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: act_q2b
          kind: Question
          title: "For about how many hours a week does he/she attend these in total?"
          precondition:
            - predicate: child_age <= 5 and act_q1.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 60

        # ACT-C3: IF AGE < 4 YEARS --> GO TO BEHAVIOUR SECTION
        # Sports and activities - ages 4+
        - id: act_q3a
          kind: Question
          title: "In the last 12 months, outside of school hours, how often has the child taken part in any sports which involved coaching or instruction?"
          precondition:
            - predicate: child_age >= 4
          input:
            control: Radio
            labels:
              1: "Most days"
              2: "A few times a week"
              3: "About once a week"
              4: "About once a month"
              5: "Almost never"

        - id: act_q3b
          kind: Question
          title: "Taken part in unorganized sports or physical activities?"
          precondition:
            - predicate: child_age >= 4
          input:
            control: Radio
            labels:
              1: "Most days"
              2: "A few times a week"
              3: "About once a week"
              4: "About once a month"
              5: "Almost never"

        - id: act_q3c
          kind: Question
          title: "Taken lessons or instruction in music, dance, art or other non-sport activities?"
          precondition:
            - predicate: child_age >= 4
          input:
            control: Radio
            labels:
              1: "Most days"
              2: "A few times a week"
              3: "About once a week"
              4: "About once a month"
              5: "Almost never"

        # ACT-C3D: Age-specific club question
        # IF AGE 4-5 --> ACT-Q3D1 (Beavers/Sparks)
        # IF AGE 6-9 --> ACT-Q3D2 (Brownies/Cubs)
        # IF AGE 10-11 --> ACT-Q3D3 (Boys and Girls Clubs/Scouts/Guides)
        - id: act_q3d1
          kind: Question
          title: "Taken part in any clubs, groups or community programs with leadership, such as Beavers, Sparks or church groups?"
          precondition:
            - predicate: child_age >= 4 and child_age <= 5
          input:
            control: Radio
            labels:
              1: "Most days"
              2: "A few times a week"
              3: "About once a week"
              4: "About once a month"
              5: "Almost never"

        - id: act_q3d2
          kind: Question
          title: "Taken part in any clubs, groups or community programs with leadership, such as Brownies, Cubs or church groups?"
          precondition:
            - predicate: child_age >= 6 and child_age <= 9
          input:
            control: Radio
            labels:
              1: "Most days"
              2: "A few times a week"
              3: "About once a week"
              4: "About once a month"
              5: "Almost never"

        - id: act_q3d3
          kind: Question
          title: "Taken part in any clubs, groups or community programs with leadership, such as Boys and Girls Clubs, Scouts, Guides or church groups?"
          precondition:
            - predicate: child_age >= 10
          input:
            control: Radio
            labels:
              1: "Most days"
              2: "A few times a week"
              3: "About once a week"
              4: "About once a month"
              5: "Almost never"

        - id: act_q3e
          kind: Question
          title: "Played computer or video games?"
          precondition:
            - predicate: child_age >= 4
          input:
            control: Radio
            labels:
              1: "Most days"
              2: "A few times a week"
              3: "About once a week"
              4: "About once a month"
              5: "Almost never"

        - id: act_q4a
          kind: Question
          title: "About how many days a week on average does the child watch T.V. or videos at home?"
          precondition:
            - predicate: child_age >= 4
          input:
            control: Editbox
            min: 0
            max: 7

        - id: act_q4b
          kind: Question
          title: "On those days, how many hours on average does he/she spend watching T.V. or videos?"
          precondition:
            - predicate: child_age >= 4 and act_q4a.outcome >= 1
          input:
            control: Editbox
            min: 1
            max: 16

        - id: act_q5
          kind: Question
          title: "How often does he/she play alone (e.g., riding a bike, doing a craft or hobby, playing ball)?"
          precondition:
            - predicate: child_age >= 4
          input:
            control: Radio
            labels:
              1: "Often"
              2: "Sometimes"
              3: "Seldom"
              4: "Never"

        # ACT-C6 p107: IF AGE < 6 --> GO TO BEHAVIOUR SECTION
        # IF AGE 6-9 --> GO TO ACT-Q7A
        # OTHERWISE --> GO TO ACT-Q6A
        # Home responsibilities - ages 10-11
        - id: act_responsibilities
          kind: QuestionGroup
          title: "How often does he/she:"
          precondition:
            - predicate: child_age >= 10
          questions:
            - "Make his/her own bed"
            - "Clean his/her own room"
            - "Pick up after him/herself"
            - "Help keep shared living areas clean and straight"
            - "Do routine chores such as mow the lawn, help with dinner, wash dishes, etc."
            - "Help manage his/her own time (get up on time, be ready for school, etc.)"
          input:
            control: Radio
            labels:
              1: "Often"
              2: "Sometimes"
              3: "Seldom"
              4: "Never"

        # Camps - ages 6+
        - id: act_q7a
          kind: Question
          title: "Did the child attend an overnight camp last summer?"
          precondition:
            - predicate: child_age >= 6
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: act_q7b
          kind: Question
          title: "For how many days?"
          precondition:
            - predicate: child_age >= 6 and act_q7a.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 90

        - id: act_q8a
          kind: Question
          title: "Last summer, did the child attend a day camp or recreational or skill-building activity that ran for half days or full days?"
          precondition:
            - predicate: child_age >= 6
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: act_q8b
          kind: Question
          title: "For how many days?"
          precondition:
            - predicate: child_age >= 6 and act_q8a.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 90

    # =========================================================================
    # BLOCK 9: ADULT HEALTH (CHLT) - p29-32
    # NOTE p29: Asked for the PMK about the selected child,
    # and the spouse/partner of that person (if applicable)
    # =========================================================================
    - id: b_adult_health
      title: "Adult Health (Person Most Knowledgeable)"
      items:
        - id: chlt_q1
          kind: Question
          title: "In general, would you say your/his/her health is:"
          input:
            control: Radio
            labels:
              1: "Excellent"
              2: "Very good"
              3: "Good"
              4: "Fair"
              5: "Poor"

        - id: chlt_q2
          kind: Question
          title: "At the present time do you/does ... smoke cigarettes daily, occasionally or not at all?"
          codeBlock: |
            if chlt_q2.outcome == 1:
                smokes_daily = 1
            else:
                smokes_daily = 0
          input:
            control: Radio
            labels:
              1: "Daily"
              2: "Occasionally"
              3: "Not at all"

        - id: chlt_q3
          kind: Question
          title: "How many cigarettes do you/does ... smoke each day now?"
          precondition:
            - predicate: smokes_daily == 1
          input:
            control: Editbox
            min: 1
            max: 97

        # Alcohol section - CHLT-I4 p30
        - id: chlt_i4
          kind: Comment
          title: "Now, some questions about alcohol consumption."

        - id: chlt_q4
          kind: Question
          title: "During the past 12 months, have you/has ... had a drink of beer, wine, liquor or any other alcoholic beverage?"
          codeBlock: |
            if chlt_q4.outcome == 1:
                drinks_alcohol = 1
            else:
                drinks_alcohol = 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: chlt_q5
          kind: Question
          title: "During the past 12 months, how often did you/he/she drink alcoholic beverages?"
          precondition:
            - predicate: drinks_alcohol == 1
          input:
            control: Radio
            labels:
              1: "Every day"
              2: "4-6 times a week"
              3: "2-3 times a week"
              4: "Once a week"
              5: "2-3 times a month"
              6: "Once a month"
              7: "Less than once a month"

        - id: chlt_q6
          kind: Question
          title: "How many times in the past 12 months have you/has he/she had 5 or more drinks on one occasion?"
          precondition:
            - predicate: drinks_alcohol == 1
          codeBlock: |
            binge_count = chlt_q6.outcome
          input:
            control: Editbox
            min: 0
            max: 365

        - id: chlt_q7
          kind: Question
          title: "In the past 12 months, what is the highest number of drinks you/he/she had on one occasion?"
          precondition:
            - predicate: drinks_alcohol == 1 and binge_count >= 1
          input:
            control: Editbox
            min: 5
            max: 50

        # Maternal history - CHLT-C8 p31
        # IF female biological parent with children < 2 years, non-proxy --> pregnancy questions
        - id: chlt_q8
          kind: Question
          title: "How many times throughout your life have you been pregnant including any pregnancies which did not go full term?"
          precondition:
            - predicate: is_female_bio_parent == 1 and child_age < 2
          input:
            control: Editbox
            min: 0
            max: 20

        - id: chlt_q9
          kind: Question
          title: "How many babies have you had?"
          precondition:
            - predicate: is_female_bio_parent == 1 and child_age < 2
          input:
            control: Editbox
            min: 0
            max: 20

        - id: chlt_q11
          kind: Question
          title: "At what age did you have your first baby?"
          precondition:
            - predicate: is_female_bio_parent == 1 and child_age < 2
          input:
            control: Editbox
            min: 10
            max: 60

        # Depression scale - CHLT-Q12A-L p32 (if PMK)
        - id: chlt_i12
          kind: Comment
          title: "The next set of statements describe feelings or behaviours. For each one, please tell me how often you felt or behaved this way during the past week."

        - id: chlt_depression
          kind: QuestionGroup
          title: "How often have you felt or behaved this way during the past week:"
          questions:
            - "I did not feel like eating; my appetite was poor."
            - "I felt that I could not shake off the blues even with help from my family or friends."
            - "I had trouble keeping my mind on what I was doing."
            - "I felt depressed."
            - "I felt that everything I did was an effort."
            - "I felt hopeful about the future."
            - "My sleep was restless."
            - "I was happy."
            - "I felt lonely."
            - "I enjoyed life."
            - "I had crying spells."
            - "I felt that people disliked me."
          input:
            control: Radio
            labels:
              1: "Rarely or none of the time (less than 1 day)"
              2: "Some or a little of the time (1-2 days)"
              3: "Occasionally or a moderate amount of time (3-4 days)"
              4: "Most or all of the time (5-7 days)"

    # =========================================================================
    # BLOCK 10: FAMILY FUNCTIONING (FNC) - p33-34
    # NOTE p33: Asked only of PMK or spouse/partner
    # FNC-C1: If already completed for another household member --> skip
    # =========================================================================
    - id: b_family_functioning
      title: "Family Functioning"
      items:
        - id: fnc_i1
          kind: Comment
          title: "The following statements are about families and family relationships. For each one, please indicate which response best describes your family: strongly agree, agree, disagree or strongly disagree."

        - id: fnc_family_scale
          kind: QuestionGroup
          title: "Please indicate how much you agree or disagree:"
          questions:
            - "Planning family activities is difficult because we misunderstand each other."
            - "In times of crisis we can turn to each other for support."
            - "We cannot talk to each other about sadness we feel."
            - "Individuals (in the family) are accepted for what they are."
            - "We avoid discussing our fears or concerns."
            - "We express feelings to each other."
            - "There are lots of bad feelings in our family."
            - "We feel accepted for what we are."
            - "Making decisions is a problem for our family."
            - "We are able to make decisions about how to solve problems."
            - "We don't get along well together."
            - "We confide in each other."
            - "Drinking is a source of tension or disagreement in our family."
          input:
            control: Radio
            labels:
              1: "Strongly agree"
              2: "Agree"
              3: "Disagree"
              4: "Strongly disagree"

        # FNC-C2 p33: IF married/common-law/living with partner --> FNC-Q2
        - id: fnc_q2
          kind: Question
          title: "All things considered, how satisfied or dissatisfied are you with your marriage or relationship with your partner?"
          precondition:
            - predicate: is_married_or_partner == 1
          input:
            control: Slider
            min: 1
            max: 11
            labels:
              1: "Completely dissatisfied"
              6: "Neutral"
              11: "Completely satisfied"

    # =========================================================================
    # BLOCK 11: NEIGHBOURHOOD (SAF) - p35-37
    # =========================================================================
    - id: b_neighbourhood
      title: "Neighbourhood"
      items:
        - id: saf_q1
          kind: Question
          title: "How many years have you lived at this address? (Enter 0 if less than 1 year.)"
          input:
            control: Editbox
            min: 0
            max: 99

        - id: saf_q2
          kind: Question
          title: "How do you feel about your neighbourhood as a place to bring up children? Is it..."
          input:
            control: Radio
            labels:
              1: "Excellent"
              2: "Good"
              3: "Average"
              4: "Poor"
              5: "Very poor"

        - id: saf_q3
          kind: Question
          title: "Are you involved in any local voluntary organizations such as school groups, church groups, community or ethnic associations?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: saf_neighbourhood_safety
          kind: QuestionGroup
          title: "Please tell me whether you strongly agree, agree, disagree, or strongly disagree with these statements about your neighbourhood."
          questions:
            - "It is safe to walk alone in this neighbourhood after dark."
            - "It is safe for children to play outside during the day."
            - "There are good parks, playgrounds and play spaces in this neighbourhood."
          input:
            control: Radio
            labels:
              1: "Strongly agree"
              2: "Agree"
              3: "Disagree"
              4: "Strongly disagree"

        - id: saf_neighbours
          kind: QuestionGroup
          title: "Please tell me whether you strongly agree, agree, disagree, or strongly disagree about the following when thinking of your neighbours."
          questions:
            - "If there is a problem around here, the neighbours get together to deal with it."
            - "There are adults in the neighbourhood that children can look up to."
            - "People around here are willing to help their neighbours."
            - "You can count on adults in this neighbourhood to watch out that children are safe."
            - "When I'm away from home, I know that my neighbours will keep their eyes open for possible trouble."
          input:
            control: Radio
            labels:
              1: "Strongly agree"
              2: "Agree"
              3: "Disagree"
              4: "Strongly disagree"

        - id: saf_problems
          kind: QuestionGroup
          title: "How much of a problem is the following in this neighbourhood:"
          questions:
            - "Litter, broken glass or garbage in the street or road, on the sidewalk, or in yards"
            - "Selling or using drugs"
            - "Alcoholics and excessive drinking in public"
            - "Groups of young people who cause trouble"
            - "Burglary of homes and apartments"
            - "Unrest due to ethnic or religious differences"
          input:
            control: Radio
            labels:
              1: "A big problem"
              2: "Somewhat of a problem"
              3: "No problem"

    # =========================================================================
    # BLOCK 12: SOCIAL SUPPORT (SUP) - p38-39
    # =========================================================================
    - id: b_social_support
      title: "Social Support"
      items:
        - id: sup_i1
          kind: Comment
          title: "The following statements are about relationships and the support which you get from others. For each of the following, please tell me whether you strongly disagree, disagree, agree, or strongly agree."

        - id: sup_support_scale
          kind: QuestionGroup
          title: "Please indicate how much you agree or disagree:"
          questions:
            - "If something went wrong, no one would help me."
            - "I have family and friends who help me feel safe, secure and happy."
            - "There is someone I trust whom I would turn to for advice if I were having problems."
            - "There is no one I feel comfortable talking about problems with."
            - "I lack a feeling of closeness with another person."
            - "There are people I can count on in an emergency."
          input:
            control: Radio
            labels:
              1: "Strongly disagree"
              2: "Disagree"
              3: "Agree"
              4: "Strongly agree"

        - id: sup_q2a
          kind: Question
          title: "Besides your friends and family, did any of the following help with your personal problems during the past 12 months: Community or social service professionals?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: sup_help_sources
          kind: QuestionGroup
          title: "Did the following help with your personal problems during the past 12 months:"
          questions:
            - "Health professionals"
            - "Religious or spiritual leaders or communities"
            - "Books or magazines"
          input:
            control: Switch
            on: "Yes"
            off: "No"
