qmlVersion: "1.0"
questionnaire:
  title: "Participation and Activity Limitation Survey (PALS) 2001 - Children Under 15"
  codeInit: |
    # Age-based routing: child born AFTER May 15, 1996 = under 5 years old at survey time
    # born_after_1996 is set by the interviewer based on date of birth (page 1)
    # 1 = child born after May 15, 1996 (under ~5 years), 0 = born on or before
    born_after_1996 = 0

    # Profile sheet flags - track limitation/aid/need across disability domains
    limitation_general = 0
    limitation_hearing = 0
    use_aid_hearing = 0
    need_aid_hearing = 0
    limitation_seeing = 0
    use_aid_seeing = 0
    need_aid_seeing = 0
    limitation_communicating = 0
    use_aid_communicating = 0
    need_aid_communicating = 0
    limitation_walking = 0
    use_aid_walking = 0
    need_aid_walking = 0
    limitation_hands = 0
    use_aid_hands = 0
    need_aid_hands = 0
    limitation_learning = 0
    use_aid_learning = 0
    need_aid_learning = 0
    limitation_developmental = 0
    limitation_emotional = 0
    limitation_chronic = 0
    use_aid_chronic = 0
    need_aid_chronic = 0

    # Master flag: any limitation checked on profile sheet
    any_limitation = 0

    # Master flag: any USE Aid checked on profile sheet
    any_use_aid = 0

    # Master flag: any NEED Aid checked on profile sheet
    any_need_aid = 0

    # Hearing sub-path: whether child has hearing difficulty or cannot hear
    hearing_difficulty = 0
    hearing_cannot = 0

    # Seeing sub-path
    seeing_difficulty = 0
    seeing_cannot = 0

    # Speaking difficulty path
    speaking_difficulty = 0

    # Learning disability flags
    learning_b43 = 0
    learning_b44 = 0

    # Developmental condition flag
    has_developmental = 0

    # Emotional condition flag
    has_emotional = 0

    # Chronic conditions - any yes in B59
    has_chronic_yes = 0

    # Help received flags for Section C
    help_personal_care = 0
    help_moving = 0
    c9a_yes = 0
    c9b_yes = 0

    # Family help flags for Section C
    c12_any_yes = 0
    c17_any_yes = 0

    # Work impact flags
    c22_any_yes = 0

    # Child care
    uses_child_care = 0
    uses_other_child_care = 0

    # Education path
    education_status = 0
    school_type = 0
    province_code = 0
    ever_attended_school = 0
    class_type = 0

    # Leisure / recreation
    prevented_leisure = 0

    # Computer / Internet
    has_computer = 0
    has_internet = 0
    uses_internet_home = 0

    # Home accommodation
    uses_exterior_features = 0
    needs_exterior_features = 0
    uses_interior_features = 0
    needs_interior_features = 0

    # Transportation
    owns_car = 0
    has_car_features = 0
    bus_service_available = 0
    uses_bus_service = 0

    # Aids expenses
    has_aid_expenses = 0

    # Medication
    uses_medication = 0
    uses_regular_not_daily = 0

    # Health services expenses
    saw_health_professional = 0
    has_health_expenses = 0

    # Unmet health needs
    needed_health_services = 0

    # Tax credits
    claimed_child_care_credit = 0
    claimed_medical_credit = 0
    claimed_disability_credit = 0

  blocks:
    # =========================================================================
    # SECTION A - FILTER QUESTIONS (p2)
    # =========================================================================
    - id: b_filter
      title: "Section A - Filter Questions"
      items:
        - id: qa1
          kind: Question
          title: "Does the child have any DIFFICULTY hearing, seeing, communicating, walking, climbing stairs, bending, learning or doing any similar activities?"
          codeBlock: |
            if qa1.outcome == 1 or qa1.outcome == 2:
                limitation_general = 1
          input:
            control: Radio
            labels:
              1: "Yes, sometimes"
              2: "Yes, often"
              3: "No"

        - id: qa2a
          kind: Question
          title: "Does a physical condition OR mental condition OR health problem REDUCE THE AMOUNT OR THE KIND OF ACTIVITY the child can do at home?"
          codeBlock: |
            if qa2a.outcome == 1 or qa2a.outcome == 2:
                limitation_general = 1
          input:
            control: Radio
            labels:
              1: "Yes, sometimes"
              2: "Yes, often"
              3: "No"

        - id: qa2b
          kind: Question
          title: "Does a physical condition OR mental condition OR health problem REDUCE THE AMOUNT OR THE KIND OF ACTIVITY the child can do at work or at school?"
          codeBlock: |
            if qa2b.outcome == 1 or qa2b.outcome == 2:
                limitation_general = 1
          input:
            control: Radio
            labels:
              1: "Yes, sometimes"
              2: "Yes, often"
              3: "No"
              5: "Not applicable"

        - id: qa2c
          kind: Question
          title: "Does a physical condition OR mental condition OR health problem REDUCE THE AMOUNT OR THE KIND OF ACTIVITY the child can do in other activities, for example, transportation or leisure?"
          codeBlock: |
            if qa2c.outcome == 1 or qa2c.outcome == 2:
                limitation_general = 1
          input:
            control: Radio
            labels:
              1: "Yes, sometimes"
              2: "Yes, often"
              3: "No"

    # =========================================================================
    # SECTION B - ACTIVITY LIMITATIONS: HEARING (p2-4)
    # =========================================================================
    - id: b_hearing
      title: "Section B - Hearing"
      items:
        - id: qb1
          kind: Question
          title: "Does the child use a hearing aid or hearing aids?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # B2: WITH HEARING AID(S), how would you describe hearing ability?
        - id: qb2
          kind: Question
          title: "WITH HEARING AID(S), how would you describe his/her ability to hear?"
          precondition:
            - predicate: qb1.outcome == 1
          codeBlock: |
            if qb2.outcome == 2:
                limitation_hearing = 1
                hearing_difficulty = 1
          input:
            control: Radio
            labels:
              1: "Child has no problem hearing"
              2: "Child has difficulty hearing"

        # B3: How much difficulty (with aid)
        - id: qb3
          kind: Question
          title: "How much difficulty?"
          precondition:
            - predicate: qb1.outcome == 1 and qb2.outcome == 2
          input:
            control: Radio
            labels:
              1: "Some difficulty"
              2: "A lot of difficulty"

        # B4: WITHOUT hearing aids (B1=No or DK/Ref)
        - id: qb4
          kind: Question
          title: "How would you describe the child's ability to hear?"
          precondition:
            - predicate: qb1.outcome == 3
          codeBlock: |
            if qb4.outcome == 2:
                limitation_hearing = 1
                hearing_difficulty = 1
            if qb4.outcome == 3:
                limitation_hearing = 1
                hearing_cannot = 1
          input:
            control: Radio
            labels:
              1: "Child has no problem hearing"
              2: "Child has difficulty hearing"
              3: "Child cannot hear"

        # B5: How much difficulty (without aid)
        - id: qb5
          kind: Question
          title: "How much difficulty?"
          precondition:
            - predicate: qb1.outcome == 3 and qb4.outcome == 2
          input:
            control: Radio
            labels:
              1: "Some difficulty"
              2: "A lot of difficulty"

        # B6.edit: If child born AFTER May 15, 1996 -> go to B51. Otherwise continue.
        # B6: hearing aids/equipment for hearing difficulties
        - id: qb6
          kind: Question
          title: "Does the child USE any aids, specialized equipment or services for children with hearing difficulties, for example, a volume control telephone or T.V. decoder?"
          precondition:
            - predicate: born_after_1996 == 0 and (hearing_difficulty == 1 or hearing_cannot == 1)
          codeBlock: |
            if qb6.outcome == 1:
                use_aid_hearing = 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # B7: Does he/she now use (grid of hearing aids)
        - id: qb7
          kind: QuestionGroup
          title: "Does he/she now use:"
          precondition:
            - predicate: born_after_1996 == 0 and use_aid_hearing == 1
          questions:
            - "A volume control telephone"
            - "A closed caption TV or decoder"
            - "A TTY or TDD"
            - "An amplifier, such as FM or infrared"
            - "A computer to communicate (e.g. e-mail or chat service)"
            - "A Sign language interpreter"
            - "Other aid"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # B8: unmet need for hearing aids
        - id: qb8
          kind: Question
          title: "Are there any aids or services for children with hearing difficulties that the child CURRENTLY needs, but does not have?"
          precondition:
            - predicate: born_after_1996 == 0 and (hearing_difficulty == 1 or hearing_cannot == 1)
          codeBlock: |
            if qb8.outcome == 1:
                need_aid_hearing = 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # B9: Which aids does he/she NEED but not have (checklist - mark all that apply)
        # Modeled as QuestionGroup with Switch
        - id: qb9
          kind: QuestionGroup
          title: "Which aids or services does he/she NEED, but does not have?"
          precondition:
            - predicate: born_after_1996 == 0 and need_aid_hearing == 1
          questions:
            - "A hearing aid or hearing aids"
            - "A volume control telephone"
            - "A closed caption T.V. or decoder"
            - "A TTY or TDD"
            - "An amplifier, such as FM or infrared"
            - "A computer to communicate (e.g. e-mail or chat service)"
            - "A Sign language interpreter"
            - "Other aid"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # B10: communication skills
        - id: qb10
          kind: QuestionGroup
          title: "Does the child:"
          precondition:
            - predicate: hearing_difficulty == 1 or hearing_cannot == 1
          questions:
            - "Use Sign Language, such as ASL or LSQ?"
            - "Speech read or lip read?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

    # =========================================================================
    # SECTION B - SEEING (p4-6)
    # =========================================================================
    - id: b_seeing
      title: "Section B - Seeing"
      items:
        - id: qb11
          kind: Question
          title: "Does the child wear glasses or contact lenses to see up close or at a distance?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # B12: WITH glasses/contacts
        - id: qb12
          kind: Question
          title: "With GLASSES or CONTACT LENSES, how would you describe his/her vision ability?"
          precondition:
            - predicate: qb11.outcome == 1
          codeBlock: |
            if qb12.outcome == 2:
                limitation_seeing = 1
                seeing_difficulty = 1
          input:
            control: Radio
            labels:
              1: "Child has no problem seeing"
              2: "Child has difficulty seeing"

        # B13: How much difficulty (with glasses)
        - id: qb13
          kind: Question
          title: "How much difficulty?"
          precondition:
            - predicate: qb11.outcome == 1 and qb12.outcome == 2
          input:
            control: Radio
            labels:
              1: "Some difficulty"
              2: "A lot of difficulty"

        # B14: WITHOUT glasses
        - id: qb14
          kind: Question
          title: "How would you describe the child's vision ability?"
          precondition:
            - predicate: qb11.outcome == 3
          codeBlock: |
            if qb14.outcome == 2:
                limitation_seeing = 1
                seeing_difficulty = 1
            if qb14.outcome == 3:
                limitation_seeing = 1
                seeing_cannot = 1
          input:
            control: Radio
            labels:
              1: "Child has no problem seeing"
              2: "Child has difficulty seeing"
              3: "Child cannot see"

        # B15: How much difficulty (without glasses)
        - id: qb15
          kind: Question
          title: "How much difficulty?"
          precondition:
            - predicate: qb11.outcome == 3 and qb14.outcome == 2
          input:
            control: Radio
            labels:
              1: "Some difficulty"
              2: "A lot of difficulty"

        # B16: legally blind diagnosis
        - id: qb16
          kind: Question
          title: "Has the child been diagnosed by an eye specialist as being legally blind?"
          precondition:
            - predicate: born_after_1996 == 0 and (seeing_difficulty == 1 or seeing_cannot == 1)
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # B17: USE aids for vision
        - id: qb17
          kind: Question
          title: "Does the child USE any aids or specialized equipment for children with vision difficulties, for example, magnifiers or Braille reading materials?"
          precondition:
            - predicate: born_after_1996 == 0 and (seeing_difficulty == 1 or seeing_cannot == 1)
          codeBlock: |
            if qb17.outcome == 1:
                use_aid_seeing = 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # B18: Does he/she now use (vision aids grid)
        - id: qb18
          kind: QuestionGroup
          title: "Does he/she now use:"
          precondition:
            - predicate: born_after_1996 == 0 and use_aid_seeing == 1
          questions:
            - "Magnifiers"
            - "Braille reading materials"
            - "Large print reading materials"
            - "Talking books"
            - "Recording equipment"
            - "A closed circuit TV"
            - "A computer with Braille, large print, or speech access"
            - "Other aid"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # B19: unmet need for vision aids
        - id: qb19
          kind: Question
          title: "Are there any aids or specialized equipment for children with vision difficulties that the child CURRENTLY needs, but does not have?"
          precondition:
            - predicate: born_after_1996 == 0 and (seeing_difficulty == 1 or seeing_cannot == 1)
          codeBlock: |
            if qb19.outcome == 1:
                need_aid_seeing = 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # B20: Which vision aids needed
        - id: qb20
          kind: QuestionGroup
          title: "Which aids does he/she NEED, but does not have?"
          precondition:
            - predicate: born_after_1996 == 0 and need_aid_seeing == 1
          questions:
            - "Glasses or contact lenses"
            - "Magnifiers"
            - "Braille reading materials"
            - "Large print reading materials"
            - "Talking books"
            - "Recording equipment"
            - "A closed circuit TV"
            - "A computer with Braille, large print, or speech access"
            - "Other aid"
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # =========================================================================
    # SECTION B - COMMUNICATING (p6-8)
    # =========================================================================
    - id: b_communicating
      title: "Section B - Communicating"
      items:
        # B21: speech difficulty
        - id: qb21
          kind: Question
          title: "Because of a condition or health problem, does the child have any difficulty speaking?"
          codeBlock: |
            if qb21.outcome == 1:
                limitation_communicating = 1
                speaking_difficulty = 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # B22: difficulty being understood when speaking (asked only when B21=No)
        # PDF: B21=Yes -> go to B23 (skip B22); B21=No -> B22
        - id: qb22
          kind: Question
          title: "Because of a condition or health problem, does the child have any difficulty making himself/herself understood when speaking?"
          precondition:
            - predicate: qb21.outcome == 3
          codeBlock: |
            if qb22.outcome == 1:
                limitation_communicating = 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # B23: How much difficulty speaking (B21=Yes path only)
        - id: qb23
          kind: Question
          title: "How much difficulty does he/she have speaking?"
          precondition:
            - predicate: qb21.outcome == 1
          input:
            control: Radio
            labels:
              1: "Child has some difficulty"
              2: "Child has a lot of difficulty"
              3: "Child cannot speak"

        # B24: difficulty being understood (B21=Yes path, B23 != cannot speak)
        - id: qb24
          kind: Question
          title: "Because of a condition or health problem, does the child have any difficulty making himself/herself understood when speaking?"
          precondition:
            - predicate: qb21.outcome == 1 and qb23.outcome != 3
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # B25: How well understood when speaking (both paths)
        # Path A: B21=Yes -> B23 (not "cannot speak") -> B24 -> B25
        # Path B: B21=No -> B22=Yes -> B25
        - id: qb25
          kind: QuestionGroup
          title: "How well do you feel the child is able to make himself/herself understood when speaking with:"
          precondition:
            - predicate: (qb21.outcome == 1 and qb23.outcome != 3) or qb22.outcome == 1
          questions:
            - "His/her family members?"
            - "His/her friends?"
            - "Other people?"
          input:
            control: Radio
            labels:
              1: "Completely"
              2: "Partially"
              3: "Not at all"

        # B26: Does he/she use communication methods (any communicating limitation)
        - id: qb26
          kind: QuestionGroup
          title: "Does he/she use:"
          precondition:
            - predicate: qb21.outcome == 1 or qb22.outcome == 1
          questions:
            - "Sign language, such as ASL or LSQ"
            - "Other form of communication"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # B27: USE aids for speaking/communicating
        - id: qb27
          kind: Question
          title: "Does the child USE any specialized equipment for children who have difficulty speaking or making themselves understood, for example, a voice amplifier or Blissboard?"
          precondition:
            - predicate: limitation_communicating == 1
          codeBlock: |
            if qb27.outcome == 1:
                use_aid_communicating = 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # B28: Does he/she now use (communication aids grid)
        - id: qb28
          kind: QuestionGroup
          title: "Does he/she now use:"
          precondition:
            - predicate: use_aid_communicating == 1
          questions:
            - "A voice amplifier"
            - "A computer or keyboard device to communicate"
            - "A communication board, such as a Blissboard"
            - "Other aid"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # B29: unmet need for communication aids
        - id: qb29
          kind: Question
          title: "Are there any aids or specialized equipment for children who have difficulty speaking or making themselves understood that the child CURRENTLY needs, but does not have?"
          precondition:
            - predicate: limitation_communicating == 1
          codeBlock: |
            if qb29.outcome == 1:
                need_aid_communicating = 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # B30: Which communication aids needed
        - id: qb30
          kind: QuestionGroup
          title: "Which aids does he/she NEED, but does not have?"
          precondition:
            - predicate: need_aid_communicating == 1
          questions:
            - "A voice amplifier"
            - "A computer or keyboard device to communicate"
            - "A communication board, such as a Blissboard"
            - "Other aid"
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # =========================================================================
    # SECTION B - WALKING / MOBILITY (p8-9)
    # =========================================================================
    - id: b_walking
      title: "Section B - Walking"
      items:
        # B31: walking difficulty
        - id: qb31
          kind: Question
          title: "Because of a condition or health problem, does the child have any difficulty walking? This means walking on a flat firm surface, such as a sidewalk or floor."
          codeBlock: |
            if qb31.outcome == 1 or qb31.outcome == 2:
                limitation_walking = 1
          input:
            control: Radio
            labels:
              1: "Yes, sometimes"
              2: "Yes, often or always"
              3: "No"

        # B32: How much difficulty walking
        - id: qb32
          kind: Question
          title: "How much difficulty does he/she have walking?"
          precondition:
            - predicate: limitation_walking == 1
          input:
            control: Radio
            labels:
              1: "Some difficulty"
              2: "A lot of difficulty"
              3: "Child cannot walk"

        # B33: USE aids for walking
        - id: qb33
          kind: Question
          title: "Does the child USE any aids or specialized equipment for children who have difficulty walking or moving around, such as a cane or crutches?"
          precondition:
            - predicate: limitation_walking == 1
          codeBlock: |
            if qb33.outcome == 1:
                use_aid_walking = 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # B34: Does he/she now use (walking aids grid)
        - id: qb34
          kind: QuestionGroup
          title: "Does he/she now use:"
          precondition:
            - predicate: use_aid_walking == 1
          questions:
            - "Orthopaedic or medically prescribed shoes"
            - "A cane or crutches"
            - "A walker"
            - "A manual wheelchair"
            - "An electric wheelchair"
            - "Braces, such as a leg brace (Exclude dental braces)"
            - "Lift devices, such as a bed lift device"
            - "Other aid"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # B35: unmet need for walking aids
        - id: qb35
          kind: Question
          title: "Are there any aids or specialized equipment for children who have difficulty walking or moving around that the child CURRENTLY needs, but does not have?"
          precondition:
            - predicate: limitation_walking == 1
          codeBlock: |
            if qb35.outcome == 1:
                need_aid_walking = 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # B36: Which walking aids needed
        - id: qb36
          kind: QuestionGroup
          title: "Which aids does he/she NEED, but does not have?"
          precondition:
            - predicate: need_aid_walking == 1
          questions:
            - "Orthopaedic or medically prescribed shoes"
            - "A cane or crutches"
            - "A walker"
            - "A manual wheelchair"
            - "An electric wheelchair"
            - "Braces, such as a leg brace (Exclude dental braces)"
            - "Lift devices, such as a bed lift device"
            - "Other aid"
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # =========================================================================
    # SECTION B - HANDS/FINGERS (p9-10)
    # =========================================================================
    - id: b_hands
      title: "Section B - Hands/Fingers"
      items:
        # B37: difficulty using hands/fingers
        - id: qb37
          kind: Question
          title: "Because of a condition or health problem, does the child have any difficulty USING his/her HANDS or FINGERS to grasp or hold small objects, such as a pencil or scissors?"
          codeBlock: |
            if qb37.outcome == 1 or qb37.outcome == 2:
                limitation_hands = 1
          input:
            control: Radio
            labels:
              1: "Yes, sometimes"
              2: "Yes, often or always"
              3: "No"

        # B38: How much difficulty
        - id: qb38
          kind: Question
          title: "How much difficulty?"
          precondition:
            - predicate: limitation_hands == 1
          input:
            control: Radio
            labels:
              1: "Some difficulty"
              2: "A lot of difficulty"
              3: "Completely unable"

        # B39: USE aids for hands/fingers
        - id: qb39
          kind: Question
          title: "Does the child USE any aids or specialized equipment designed to support, replace or assist in the use of hands or fingers, such as a hand or arm brace, or grasping tools?"
          precondition:
            - predicate: limitation_hands == 1
          codeBlock: |
            if qb39.outcome == 1:
                use_aid_hands = 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # B40: Does he/she now use (hands aids grid)
        - id: qb40
          kind: QuestionGroup
          title: "Does he/she now use:"
          precondition:
            - predicate: use_aid_hands == 1
          questions:
            - "A hand or arm brace"
            - "Grasping tools or reach extenders"
            - "Other aid"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # B41: unmet need for hand aids
        - id: qb41
          kind: Question
          title: "Are there any aids or specialized equipment designed to support, replace or assist in the use of hands or fingers that the child CURRENTLY needs, but does not have?"
          precondition:
            - predicate: limitation_hands == 1
          codeBlock: |
            if qb41.outcome == 1:
                need_aid_hands = 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # B42: Which hand aids needed
        - id: qb42
          kind: QuestionGroup
          title: "Which aids does he/she NEED, but does not have?"
          precondition:
            - predicate: need_aid_hands == 1
          questions:
            - "A hand or arm brace"
            - "Grasping tools or reach extenders"
            - "Other aid"
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # =========================================================================
    # SECTION B - LEARNING (p10-12)
    # =========================================================================
    - id: b_learning
      title: "Section B - Learning"
      items:
        # B43: learning disability
        - id: qb43
          kind: Question
          title: "Do you think that the child has a learning disability, such as dyslexia, hyperactivity or attention problems?"
          codeBlock: |
            if qb43.outcome == 1:
                limitation_learning = 1
                learning_b43 = 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # B44: professional diagnosis of learning disability
        - id: qb44
          kind: Question
          title: "Has a teacher, doctor or other health professional ever said that the child had a learning disability?"
          codeBlock: |
            if qb44.outcome == 1:
                limitation_learning = 1
                learning_b44 = 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # B45.edit: If B43 OR B44 is "Yes", continue. Otherwise, go to B53 (p12).
        # B45: activity reduction due to learning condition
        - id: qb45
          kind: Question
          title: "Does this condition reduce the amount or the kind of activities the child can do?"
          precondition:
            - predicate: learning_b43 == 1 or learning_b44 == 1
          input:
            control: Radio
            labels:
              1: "Yes, sometimes"
              2: "Yes, often or always"
              3: "No"

        # B46: How many activities prevented
        - id: qb46
          kind: QuestionGroup
          title: "How many ACTIVITIES does this condition USUALLY prevent him/her from doing:"
          precondition:
            - predicate: (learning_b43 == 1 or learning_b44 == 1) and (qb45.outcome == 1 or qb45.outcome == 2)
          questions:
            - "At home?"
            - "At school?"
            - "At play or recreational activities?"
          input:
            control: Radio
            labels:
              1: "None"
              2: "A few"
              3: "Many"
              4: "Most"

        # B47: USE aids for learning
        - id: qb47
          kind: Question
          title: "Does the child USE any aids, specialized equipment or services to help him/her with his/her learning difficulty?"
          precondition:
            - predicate: learning_b43 == 1 or learning_b44 == 1
          codeBlock: |
            if qb47.outcome == 1:
                use_aid_learning = 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # B48: Does he/she now use (learning aids grid)
        - id: qb48
          kind: QuestionGroup
          title: "Does he/she now use:"
          precondition:
            - predicate: use_aid_learning == 1
          questions:
            - "A computer as a learning aid"
            - "A voice activated or voice synthesis computer software (e.g. Dragon Dictate, Via Voice)"
            - "Talking books"
            - "Recording equipment"
            - "A tutor"
            - "Other aid"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # B49: unmet need for learning aids
        - id: qb49
          kind: Question
          title: "Are there any learning aids, specialized equipment or services that the child CURRENTLY needs, but does not have?"
          precondition:
            - predicate: learning_b43 == 1 or learning_b44 == 1
          codeBlock: |
            if qb49.outcome == 1:
                need_aid_learning = 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # B50: Which learning aids needed
        - id: qb50
          kind: QuestionGroup
          title: "Which aids or services does he/she NEED, but does not have?"
          precondition:
            - predicate: need_aid_learning == 1
          questions:
            - "A computer as a learning aid"
            - "A voice activated or voice synthesis computer software (e.g. Dragon Dictate, Via Voice)"
            - "Talking books"
            - "Recording equipment"
            - "A tutor"
            - "Other aid"
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # =========================================================================
    # SECTION B - DEVELOPMENTAL (p12-13)
    # B51.edit: Go to B53 (for children born after 1996 who skip learning section)
    # =========================================================================
    - id: b_developmental
      title: "Section B - Developmental"
      items:
        # B51: developmental delay
        - id: qb51
          kind: Question
          title: "Because of a condition or health problem, does the child have a delay in his/her development, either a physical, intellectual or another type of delay?"
          precondition:
            - predicate: born_after_1996 == 1
          codeBlock: |
            if qb51.outcome == 1:
                limitation_developmental = 1
                has_developmental = 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # B52: What kind of delay
        - id: qb52
          kind: QuestionGroup
          title: "What kind of delay is this?"
          precondition:
            - predicate: born_after_1996 == 1 and qb51.outcome == 1
          questions:
            - "A delay in his/her PHYSICAL development"
            - "A delay in his/her INTELLECTUAL development"
            - "Other type of delay"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # B53: professional diagnosis of developmental disability
        - id: qb53
          kind: Question
          title: "Has a doctor, psychologist or other health professional ever said that the child has a developmental disability or disorder? These may include autism, Down syndrome, or mental impairment due to a lack of oxygen at birth."
          codeBlock: |
            if qb53.outcome == 1:
                limitation_developmental = 1
                has_developmental = 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # B54: activity reduction from developmental condition
        - id: qb54
          kind: Question
          title: "Does this condition reduce the amount or the kind of activities the child can do?"
          precondition:
            - predicate: has_developmental == 1
          input:
            control: Radio
            labels:
              1: "Yes, sometimes"
              2: "Yes, often or always"
              3: "No"

        # B55: How many activities prevented
        - id: qb55
          kind: QuestionGroup
          title: "How many ACTIVITIES does this condition USUALLY prevent him/her from doing:"
          precondition:
            - predicate: has_developmental == 1 and (qb54.outcome == 1 or qb54.outcome == 2)
          questions:
            - "At home?"
            - "At school?"
            - "At play or recreational activities?"
          input:
            control: Radio
            labels:
              1: "None"
              2: "A few"
              3: "Many"
              4: "Most"

    # =========================================================================
    # SECTION B - EMOTIONAL/PSYCHOLOGICAL (p13)
    # =========================================================================
    - id: b_emotional
      title: "Section B - Emotional/Psychological"
      items:
        # B56: emotional/psychological/behavioural conditions
        - id: qb56
          kind: Question
          title: "Does the child have any emotional, psychological or behavioural conditions that have lasted or are expected to last six months or more?"
          codeBlock: |
            if qb56.outcome == 1:
                has_emotional = 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # B57: activity reduction
        - id: qb57
          kind: Question
          title: "Does this condition reduce the amount or the kind of activities the child can do?"
          precondition:
            - predicate: has_emotional == 1
          codeBlock: |
            if qb57.outcome == 1 or qb57.outcome == 2:
                limitation_emotional = 1
          input:
            control: Radio
            labels:
              1: "Yes, sometimes"
              2: "Yes, often or always"
              3: "No"

        # B58: How many activities prevented
        - id: qb58
          kind: QuestionGroup
          title: "How many ACTIVITIES does this condition USUALLY prevent him/her from doing:"
          precondition:
            - predicate: has_emotional == 1 and (qb57.outcome == 1 or qb57.outcome == 2)
          questions:
            - "At home?"
            - "At school?"
            - "At play or recreational activities?"
          input:
            control: Radio
            labels:
              1: "None"
              2: "A few"
              3: "Many"
              4: "Most"

    # =========================================================================
    # SECTION B - CHRONIC CONDITIONS (p14-15)
    # =========================================================================
    - id: b_chronic
      title: "Section B - Chronic Conditions"
      items:
        # B59: chronic health conditions (grid of 20 conditions)
        - id: qb59
          kind: QuestionGroup
          title: "Does the child have any of the following LONG-TERM conditions which have been DIAGNOSED by a health professional?"
          questions:
            - "Asthma or severe allergies"
            - "Heart condition or disease"
            - "Kidney condition or disease"
            - "Cancer"
            - "Diabetes"
            - "Epilepsy"
            - "Autism"
            - "Cerebral Palsy"
            - "Spina Bifida"
            - "Cystic Fibrosis"
            - "Muscular Dystrophy"
            - "Migraines"
            - "Arthritis or rheumatism"
            - "Paralysis of any kind"
            - "Missing or malformed arms, legs, fingers or toes"
            - "Fetal Alcohol Syndrome"
            - "Attention Deficit Disorder (ADD) or Attention Deficit Hyperactivity Disorder (ADHD)"
            - "Down syndrome"
            - "Complex medical care needs"
            - "Any other LONG-TERM condition diagnosed by a health professional"
          codeBlock: |
            # B60.edit: If at least one "Yes" in B59, continue. Otherwise go to B62.edit
            # Check each sub-item for Yes (1)
            has_chronic_yes_tmp = 0
            for i in range(20):
                if qb59.outcome[i] == 1:
                    has_chronic_yes_tmp = 1
            has_chronic_yes = has_chronic_yes_tmp
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # B60: activity reduction from chronic conditions
        - id: qb60
          kind: Question
          title: "Does this condition (Do these conditions) reduce the amount or the kind of activities the child can do?"
          precondition:
            - predicate: has_chronic_yes == 1
          codeBlock: |
            if qb60.outcome == 1 or qb60.outcome == 2:
                limitation_chronic = 1
          input:
            control: Radio
            labels:
              1: "Yes, sometimes"
              2: "Yes, often or always"
              3: "No"

        # B61: How many activities prevented
        - id: qb61
          kind: QuestionGroup
          title: "How many ACTIVITIES does this condition (do these conditions) USUALLY prevent him/her from doing:"
          precondition:
            - predicate: has_chronic_yes == 1 and (qb60.outcome == 1 or qb60.outcome == 2)
          questions:
            - "At home?"
            - "At school?"
            - "At play or recreational activities?"
          input:
            control: Radio
            labels:
              1: "None"
              2: "A few"
              3: "Many"
              4: "Most"

    # =========================================================================
    # SECTION B - MAIN CONDITION & DIAGNOSIS (p15-16)
    # B62.edit: If any box checked in "Limitation" column on Profile Sheet, go to B62.
    #           Otherwise, go to Follow-up Question (p52).
    # =========================================================================
    - id: b_main_condition
      title: "Section B - Main Condition and Diagnosis"
      items:
        - id: qb62_check
          kind: Comment
          title: "The following questions are about the main condition causing difficulties or activity limitations."
          codeBlock: |
            # Compute any_limitation
            if limitation_general == 1 or limitation_hearing == 1 or limitation_seeing == 1 or limitation_communicating == 1 or limitation_walking == 1 or limitation_hands == 1 or limitation_learning == 1 or limitation_developmental == 1 or limitation_emotional == 1 or limitation_chronic == 1:
                any_limitation = 1
            # Compute any_use_aid
            if use_aid_hearing == 1 or use_aid_seeing == 1 or use_aid_communicating == 1 or use_aid_walking == 1 or use_aid_hands == 1 or use_aid_learning == 1 or use_aid_chronic == 1:
                any_use_aid = 1
            # Compute any_need_aid
            if need_aid_hearing == 1 or need_aid_seeing == 1 or need_aid_communicating == 1 or need_aid_walking == 1 or need_aid_hands == 1 or need_aid_learning == 1 or need_aid_chronic == 1:
                any_need_aid = 1

        # B62: age when suspected long-term condition
        - id: qb62
          kind: Question
          title: "How old was the child when you suspected that he/she has a long-term condition or health problem?"
          precondition:
            - predicate: any_limitation == 1
          input:
            control: Editbox
            min: 0
            max: 14

        # B63: main condition (open-ended, model as categorical)
        - id: qb63
          kind: Question
          title: "What is the MAIN condition or health problem which causes him/her difficulties or activity limitations?"
          precondition:
            - predicate: any_limitation == 1
          input:
            control: Radio
            labels:
              1: "Condition specified"

        # B64: cause of condition
        - id: qb64
          kind: Question
          title: "Which one of the following best describes the CAUSE of this condition or health problem?"
          precondition:
            - predicate: any_limitation == 1
          input:
            control: Radio
            labels:
              1: "Existed at birth, was due to premature birth or accident at birth"
              2: "A disease or illness"
              3: "Accident at home or at school"
              4: "Motor vehicle accident"
              5: "Other"

        # B65: got a diagnosis
        - id: qb65
          kind: Question
          title: "Did you get a diagnosis for the child's condition or health problem?"
          precondition:
            - predicate: any_limitation == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # B66: age at diagnosis
        - id: qb66
          kind: Question
          title: "How old was the child when you obtained a diagnosis for his/her condition or health problem?"
          precondition:
            - predicate: any_limitation == 1 and qb65.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 14

        # B67: difficulties getting diagnosis
        - id: qb67
          kind: QuestionGroup
          title: "Did you experience any of the following situations when you were trying to obtain a diagnosis for the child's condition or health problem?"
          precondition:
            - predicate: any_limitation == 1 and qb65.outcome == 1
          questions:
            - "Doctor or health professional took a wait and see approach"
            - "Long waiting period to get the diagnosis"
            - "Difficulty getting referrals or appointments"
            - "Doctor or health professional not available locally"
            - "Too expensive"
            - "Did not know where to get the diagnosis"
            - "Other"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

    # =========================================================================
    # SECTION B - GENERAL HEALTH & MEDICATIONS (p16-18)
    # =========================================================================
    - id: b_health_meds
      title: "Section B - General Health and Medications"
      items:
        # B68: general health
        - id: qb68
          kind: Question
          title: "How would you describe the child's general health? Would you say that his/her health is:"
          precondition:
            - predicate: any_limitation == 1
          input:
            control: Radio
            labels:
              1: "Excellent"
              2: "Very good"
              3: "Good"
              4: "Fair"
              5: "Poor"

        # B69: uses medications
        - id: qb69
          kind: Question
          title: "Does the child USE any prescription or non-prescription medications on a regular basis, that is, AT LEAST ONCE A WEEK?"
          precondition:
            - predicate: any_limitation == 1
          codeBlock: |
            if qb69.outcome == 1:
                uses_medication = 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # B70: prescription medications daily
        - id: qb70
          kind: Question
          title: "How many kinds of PRESCRIPTION medications does he/she take EVERYDAY?"
          precondition:
            - predicate: uses_medication == 1
          input:
            control: Radio
            labels:
              1: "None"
              2: "1-3 kinds"
              3: "4 kinds or more"

        # B71: non-prescription medications daily
        - id: qb71
          kind: Question
          title: "How many kinds of NON-PRESCRIPTION medications does he/she take EVERYDAY?"
          precondition:
            - predicate: uses_medication == 1
          input:
            control: Radio
            labels:
              1: "None"
              2: "1-3 kinds"
              3: "4 kinds or more"

        # B72: uses medications regularly but NOT daily
        - id: qb72
          kind: Question
          title: "Does the child USE any medications regularly, but NOT DAILY?"
          precondition:
            - predicate: uses_medication == 1
          codeBlock: |
            if qb72.outcome == 1:
                uses_regular_not_daily = 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # B73: prescription meds not daily
        - id: qb73
          kind: Question
          title: "How many kinds of PRESCRIPTION medications does he/she take (regularly, but NOT DAILY)?"
          precondition:
            - predicate: uses_regular_not_daily == 1
          input:
            control: Radio
            labels:
              1: "None"
              2: "1-3 kinds"
              3: "4 kinds or more"

        # B74: non-prescription meds not daily
        - id: qb74
          kind: Question
          title: "How many kinds of NON-PRESCRIPTION medications does he/she take (regularly, but NOT DAILY)?"
          precondition:
            - predicate: uses_regular_not_daily == 1
          input:
            control: Radio
            labels:
              1: "None"
              2: "1-3 kinds"
              3: "4 kinds or more"

        # B75: out-of-pocket medication expenses
        - id: qb75
          kind: Question
          title: "IN THE PAST 12 MONTHS, did you or your family have any OUT-OF-POCKET expenses, that are not reimbursed by any sources, for the child's prescription or non-prescription medications?"
          precondition:
            - predicate: any_limitation == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # B76: medication expense amount
        - id: qb76
          kind: Question
          title: "What is your best estimate of the OUT-OF-POCKET or DIRECT costs to you or your family for these extra expenses?"
          precondition:
            - predicate: any_limitation == 1 and qb75.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 999999
            left: "$"

        # B77: medication expense group
        - id: qb77
          kind: Question
          title: "Which one of the following expense groups is the best estimate of the direct costs to you or your family?"
          precondition:
            - predicate: any_limitation == 1 and qb75.outcome == 1
          input:
            control: Radio
            labels:
              1: "Less than $100"
              2: "$100 to less than $200"
              3: "$200 to less than $500"
              4: "$500 to less than $1000"
              5: "$1000 to less than $2000"
              6: "$2000 to less than $5000"
              7: "$5000 or more"

        # B78: unmet medication needs
        - id: qb78
          kind: Question
          title: "Because of a condition or health problem, does the child CURRENTLY need any prescription or non-prescription medications on a regular basis, which he/she does not have?"
          precondition:
            - predicate: any_limitation == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # B79: why doesn't have medications
        - id: qb79
          kind: QuestionGroup
          title: "Why doesn't he/she have these medications?"
          precondition:
            - predicate: any_limitation == 1 and qb78.outcome == 1
          questions:
            - "Not covered by insurance"
            - "Too expensive"
            - "Not approved or recommended by health professionals"
            - "Other reason"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

    # =========================================================================
    # SECTION B - HEALTH PROFESSIONALS (p18-19)
    # =========================================================================
    - id: b_health_prof
      title: "Section B - Health Professionals"
      items:
        # B80: contact with health professionals
        - id: qb80
          kind: QuestionGroup
          title: "IN THE PAST 12 MONTHS, how OFTEN has the child seen or received care from a:"
          precondition:
            - predicate: any_limitation == 1
          questions:
            - "Family doctor or general practitioner?"
            - "Medical specialist (such as a heart specialist)?"
            - "Nurse?"
            - "Speech therapist?"
            - "Physiotherapist?"
            - "Psychologist or psychotherapist?"
            - "Chiropractor?"
            - "Other health professional"
          codeBlock: |
            # B81.edit: If at least one check mark in column (1) (2) or (3) of B80, continue.
            # Columns 1-3 = at least once a week / at least once a month / less than once a month
            saw_hp = 0
            for i in range(8):
                if qb80.outcome[i] == 1 or qb80.outcome[i] == 2 or qb80.outcome[i] == 3:
                    saw_hp = 1
            saw_health_professional = saw_hp
          input:
            control: Radio
            labels:
              1: "At least once a week"
              2: "At least once a month"
              3: "Less than once a month"
              4: "Never"

        # B81: out-of-pocket health professional expenses
        - id: qb81
          kind: Question
          title: "IN THE PAST 12 MONTHS, did you or your family have any OUT-OF-POCKET expenses, that are not reimbursed by any sources, for the services that the child received from health professionals?"
          precondition:
            - predicate: any_limitation == 1 and saw_health_professional == 1
          codeBlock: |
            if qb81.outcome == 1:
                has_health_expenses = 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # B82: expense amount
        - id: qb82
          kind: Question
          title: "What is your best estimate of the OUT-OF-POCKET or DIRECT costs to you or your family for these extra expenses?"
          precondition:
            - predicate: has_health_expenses == 1
          input:
            control: Editbox
            min: 1
            max: 999999
            left: "$"

        # B83: expense group
        - id: qb83
          kind: Question
          title: "Which one of the following expense groups is the best estimate of the direct costs to you or your family?"
          precondition:
            - predicate: has_health_expenses == 1
          input:
            control: Radio
            labels:
              1: "Less than $200"
              2: "$200 to less than $500"
              3: "$500 to less than $1000"
              4: "$1000 to less than $2000"
              5: "$2000 to less than $5000"
              6: "$5000 or more"

        # B84: unmet health service needs
        - id: qb84
          kind: Question
          title: "IN THE PAST 12 MONTHS, was there ever a time when the child needed health services because of his/her condition, but did not receive them?"
          precondition:
            - predicate: any_limitation == 1
          codeBlock: |
            if qb84.outcome == 1:
                needed_health_services = 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # B85: what health services needed
        - id: qb85
          kind: QuestionGroup
          title: "What kind of health services did he/she NEED, but did not receive?"
          precondition:
            - predicate: needed_health_services == 1
          questions:
            - "Family doctor or general practitioner"
            - "Medical specialist (such as a heart specialist)"
            - "Nurse for care"
            - "Speech therapist"
            - "Physiotherapist"
            - "Psychologist or psychotherapist"
            - "Chiropractor"
            - "Other"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # B86: why didn't receive health services
        - id: qb86
          kind: QuestionGroup
          title: "Why didn't the child receive the health service that he/she needed?"
          precondition:
            - predicate: needed_health_services == 1
          questions:
            - "Not covered by insurance"
            - "Too expensive"
            - "Not available locally"
            - "Long waiting period"
            - "Other reason"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

    # =========================================================================
    # SECTION B - OTHER AIDS & EXPENSES (p20-22)
    # B87.edit: If child born AFTER May 15, 1996 -> go to C12. Otherwise, continue.
    # =========================================================================
    - id: b_other_aids
      title: "Section B - Other Aids and Equipment"
      items:
        # B87: use any other aids
        - id: qb87
          kind: Question
          title: "Because of a condition or health problem, does the child USE any aids or specialized equipment that you have not already mentioned?"
          precondition:
            - predicate: any_limitation == 1
          codeBlock: |
            if qb87.outcome == 1:
                use_aid_chronic = 1
                any_use_aid = 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # B88: Does he/she now use
        - id: qb88
          kind: QuestionGroup
          title: "Does he/she now use:"
          precondition:
            - predicate: use_aid_chronic == 1
          questions:
            - "Respiratory aids, such as inhalers, puffers, oxygen"
            - "Pain management aids, such as a TENS machine"
            - "Other aid or specialized equipment"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # B89.edit: If any box checked in "USE - Aid" column on Profile Sheet, continue.
        #           Otherwise, go to B93.
        # B89: funding for aids
        - id: qb89
          kind: QuestionGroup
          title: "What kind of funding was used to get the aids the child currently uses?"
          precondition:
            - predicate: any_use_aid == 1
          questions:
            - "Your own money"
            - "Friends and family members"
            - "Private health insurance"
            - "Government program"
            - "Other funding"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # B90: out-of-pocket aid expenses
        - id: qb90
          kind: Question
          title: "IN THE PAST 12 MONTHS, did you or your family have any OUT-OF-POCKET expenses (that are not reimbursed by any sources) for the purchase or maintenance of aids or specialized equipment that the child uses?"
          precondition:
            - predicate: any_use_aid == 1
          codeBlock: |
            if qb90.outcome == 1:
                has_aid_expenses = 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # B91: expense amount
        - id: qb91
          kind: Question
          title: "What is your best estimate of the OUT-OF-POCKET or DIRECT costs to you or your family for these extra expenses?"
          precondition:
            - predicate: has_aid_expenses == 1
          input:
            control: Editbox
            min: 1
            max: 999999
            left: "$"

        # B92: expense group
        - id: qb92
          kind: Question
          title: "Which one of the following expense groups is the best estimate of the direct costs to you or your family?"
          precondition:
            - predicate: has_aid_expenses == 1
          input:
            control: Radio
            labels:
              1: "Less than $200"
              2: "$200 to less than $500"
              3: "$500 to less than $1000"
              4: "$1000 to less than $2000"
              5: "$2000 to less than $5000"
              6: "$5000 or more"

        # B93: CURRENTLY need other aids
        - id: qb93
          kind: Question
          title: "Does the child CURRENTLY need any aids or specialized equipment that you have not already mentioned?"
          precondition:
            - predicate: any_limitation == 1
          codeBlock: |
            if qb93.outcome == 1:
                need_aid_chronic = 1
                any_need_aid = 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # B94: Which aids needed
        - id: qb94
          kind: QuestionGroup
          title: "Which aids does the child NEED, but does not have?"
          precondition:
            - predicate: need_aid_chronic == 1
          questions:
            - "Respiratory aids, such as inhalers, puffers, oxygen"
            - "Pain management aids, such as a TENS machine"
            - "Other aid or specialized equipment"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # B95.edit: If any box checked in "NEED Aid" column on Profile Sheet, continue.
        #           Otherwise, go to C1 (p22).
        # B95: why doesn't have aids
        - id: qb95
          kind: QuestionGroup
          title: "Why doesn't he/she have these aids and specialized equipment?"
          precondition:
            - predicate: any_need_aid == 1
          questions:
            - "Not covered by insurance"
            - "Too expensive"
            - "Not available locally"
            - "Do not know where to obtain the aid"
            - "Child's condition is not serious enough"
            - "Only needed occasionally"
            - "Other reason"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # B96: impact of not having aids
        - id: qb96
          kind: Question
          title: "Do you think that there is an impact on the child because he/she does not have these aids?"
          precondition:
            - predicate: any_need_aid == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # B97: what is the impact
        - id: qb97
          kind: QuestionGroup
          title: "What is the impact of not having these aids or specialized equipment?"
          precondition:
            - predicate: any_need_aid == 1 and qb96.outcome == 1
          questions:
            - "Child's participation in regular everyday activity is reduced"
            - "Child is frustrated"
            - "Child's self-esteem is affected"
            - "Other"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

    # =========================================================================
    # SECTION C - HELP WITH EVERYDAY ACTIVITIES (p22-27)
    # Section C header: If child born AFTER May 15, 1996, go to C12.
    # =========================================================================
    - id: b_personal_care
      title: "Section C - Help with Everyday Activities"
      items:
        # C1: personal care help
        - id: qc1
          kind: Question
          title: "Does the child USUALLY receive help with personal care, such as bathing, toiletting, dressing or feeding?"
          precondition:
            - predicate: born_after_1996 == 0
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # C2: is it because of condition
        - id: qc2
          kind: Question
          title: "Is this because of his/her condition or health problem?"
          precondition:
            - predicate: born_after_1996 == 0 and qc1.outcome == 1
          codeBlock: |
            if qc2.outcome == 1:
                help_personal_care = 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # C3: how much help
        - id: qc3
          kind: Question
          title: "How much help does he/she need?"
          precondition:
            - predicate: help_personal_care == 1
          input:
            control: Radio
            labels:
              1: "Some help"
              2: "A lot of help"

        # C4: who provides help
        - id: qc4
          kind: Question
          title: "Who provides most of the help for his/her personal care?"
          precondition:
            - predicate: help_personal_care == 1
          input:
            control: Radio
            labels:
              1: "Mostly the mother"
              2: "Mostly the father"
              3: "Both the mother and the father"
              4: "Other family members"
              5: "Other"

        # C5: help moving inside residence
        - id: qc5
          kind: Question
          title: "Does the child USUALLY receive help with moving about inside his/her residence, such as moving from one room to another?"
          precondition:
            - predicate: born_after_1996 == 0
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # C6: is it because of condition
        - id: qc6
          kind: Question
          title: "Is this because of his/her condition or health problem?"
          precondition:
            - predicate: born_after_1996 == 0 and qc5.outcome == 1
          codeBlock: |
            if qc6.outcome == 1:
                help_moving = 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # C7: how much help moving
        - id: qc7
          kind: Question
          title: "How much help does he/she need?"
          precondition:
            - predicate: help_moving == 1
          input:
            control: Radio
            labels:
              1: "Some help"
              2: "A lot of help"

        # C8: who provides help moving
        - id: qc8
          kind: Question
          title: "Who provides most of the help for moving about inside his/her residence?"
          precondition:
            - predicate: help_moving == 1
          input:
            control: Radio
            labels:
              1: "Mostly the mother"
              2: "Mostly the father"
              3: "Both the mother and the father"
              4: "Other family members"
              5: "Other"

        # C9: CURRENTLY need help or additional help
        - id: qc9
          kind: QuestionGroup
          title: "Because of the child's condition, do you CURRENTLY need help or additional help with:"
          precondition:
            - predicate: born_after_1996 == 0
          questions:
            - "His/her personal care?"
            - "Moving him/her about inside his/her residence?"
          codeBlock: |
            if qc9.outcome[0] == 1:
                c9a_yes = 1
            if qc9.outcome[1] == 1:
                c9b_yes = 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # C10.edit: If C9(a) OR C9(b) is "Yes", continue. Otherwise, go to C12.
        # C10: hours per week of help needed
        - id: qc10
          kind: Question
          title: "How many hours per week of help or additional help do you need?"
          precondition:
            - predicate: c9a_yes == 1 or c9b_yes == 1
          input:
            control: Radio
            labels:
              1: "1-4 hours per week"
              2: "5-10 hours per week"
              3: "More than 10 hours per week"

        # C11: why not receive help
        - id: qc11
          kind: QuestionGroup
          title: "Why do you not receive this help?"
          precondition:
            - predicate: c9a_yes == 1 or c9b_yes == 1
          questions:
            - "It is too expensive"
            - "Help from family and friends is not available"
            - "Services or special programs (for help) are not available locally"
            - "Child is presently on a waiting list"
            - "Do not know where to look for help"
            - "Child's condition is not serious enough"
            - "You have not asked for help"
            - "Other"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

    # =========================================================================
    # SECTION C - FAMILY HELP (p24-27)
    # =========================================================================
    - id: b_family_help
      title: "Section C - Family Help"
      items:
        # C12: family help received
        - id: qc12
          kind: QuestionGroup
          title: "Because of the child's condition, do you USUALLY receive help with the following:"
          questions:
            - "Help with everyday housework, such as house cleaning or meal preparation"
            - "Help to allow you to attend to other family responsibilities"
            - "Help to allow you to take time off for personal activities"
          codeBlock: |
            c12_any = 0
            for i in range(3):
                if qc12.outcome[i] == 1:
                    c12_any = 1
            c12_any_yes = c12_any
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # C13.edit: If at least one "Yes" in C12, continue. Otherwise, go to C17.
        # C13: who provides family help
        - id: qc13
          kind: QuestionGroup
          title: "Who USUALLY provides you this help?"
          precondition:
            - predicate: c12_any_yes == 1
          questions:
            - "Family living with you"
            - "Family not living with you"
            - "Friends or neighbours"
            - "Government organization or agency"
            - "Private organization or agency"
            - "Voluntary organization or agency"
            - "Other"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # C14: out-of-pocket family help expenses
        - id: qc14
          kind: Question
          title: "IN THE PAST 12 MONTHS, did you or your family have any OUT-OF-POCKET expenses (that are not reimbursed by any sources) for this help?"
          precondition:
            - predicate: c12_any_yes == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # C15: expense amount
        - id: qc15
          kind: Question
          title: "What is your best estimate of the OUT-OF-POCKET or DIRECT costs to you or your family for these extra expenses?"
          precondition:
            - predicate: c12_any_yes == 1 and qc14.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 999999
            left: "$"

        # C16: expense group
        - id: qc16
          kind: Question
          title: "Which one of the following expense groups is the best estimate of the direct costs to you or your family?"
          precondition:
            - predicate: c12_any_yes == 1 and qc14.outcome == 1
          input:
            control: Radio
            labels:
              1: "Less than $200"
              2: "$200 to less than $500"
              3: "$500 to less than $1000"
              4: "$1000 to less than $2000"
              5: "$2000 to less than $5000"
              6: "$5000 or more"

        # C17: CURRENTLY need help or additional help
        - id: qc17
          kind: QuestionGroup
          title: "Because of the child's condition, do you CURRENTLY need help or additional help with the following:"
          questions:
            - "Help with everyday housework, such as house cleaning or meal preparation"
            - "Help to allow you to attend to other family responsibilities"
            - "Help to allow you to take time off for personal activities"
          codeBlock: |
            c17_any = 0
            for i in range(3):
                if qc17.outcome[i] == 1:
                    c17_any = 1
            c17_any_yes = c17_any
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # C18.edit: If at least one "Yes" in C17, continue. Otherwise, go to C19.
        # C18: why not receive additional help
        - id: qc18
          kind: QuestionGroup
          title: "Why do you not receive this help or additional help?"
          precondition:
            - predicate: c17_any_yes == 1
          questions:
            - "It is too expensive"
            - "Help from family and friends is not available"
            - "Services or special programs (for help) are not available locally"
            - "Child is presently on a waiting list"
            - "Do not know where to look for help"
            - "Child's condition is not serious enough"
            - "You have not asked for help"
            - "Other"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # C19: difficulty coordinating care
        - id: qc19
          kind: Question
          title: "IN THE PAST 12 MONTHS, did you have any difficulty with coordinating the care of the child, for example, making appointments, phoning or visiting health professionals and specialists?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # C20: what kind of difficulty
        - id: qc20
          kind: QuestionGroup
          title: "What kind of difficulty did you have?"
          precondition:
            - predicate: qc19.outcome == 1
          questions:
            - "Difficulty obtaining appointments"
            - "Health professional or specialist not available locally"
            - "A lack of communication between health professionals"
            - "Difficulty getting information"
            - "Your lack of time to coordinate the care"
            - "Work conflicts"
            - "Other difficulty"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # C21: who coordinates care
        - id: qc21
          kind: Question
          title: "Who USUALLY coordinates the care of the child?"
          input:
            control: Radio
            labels:
              1: "Mostly the mother"
              2: "Mostly the father"
              3: "Both the father and the mother"
              4: "Other family members"
              5: "Other"

        # C22: work impact on family
        - id: qc22
          kind: QuestionGroup
          title: "Because of the child's condition or health problem, has anyone in your family EVER:"
          questions:
            - "Not taken a job in order to take care of the child?"
            - "Quit working (other than normal maternity or paternity leave)?"
            - "Changed work hours to different time of day (or night)?"
            - "Turned down a promotion or a better job?"
            - "Worked fewer hours?"
          codeBlock: |
            c22_any = 0
            for i in range(5):
                if qc22.outcome[i] == 1:
                    c22_any = 1
            c22_any_yes = c22_any
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # C23.edit: If at least one "Yes" in C22, continue. Otherwise, go to C24.
        # C23: who was most affected
        - id: qc23
          kind: Question
          title: "Who was most affected by these work-related issues?"
          precondition:
            - predicate: c22_any_yes == 1
          input:
            control: Radio
            labels:
              1: "Mostly the mother"
              2: "Mostly the father"
              3: "Both the mother and the father"
              4: "Other family members"
              5: "Other"

        # C24: financial problems
        - id: qc24
          kind: Question
          title: "DURING THE PAST 12 MONTHS, has your family had financial problems because of the child's condition or health problem?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

    # =========================================================================
    # SECTION D - CHILD CARE (p27-29)
    # =========================================================================
    - id: b_child_care
      title: "Section D - Child Care"
      items:
        # D1: uses child care
        - id: qd1
          kind: Question
          title: "Do you CURRENTLY use child care such as day care, babysitting or a before and after school program for the child while you (or your spouse/partner) are at work or studying?"
          codeBlock: |
            if qd1.outcome == 1:
                uses_child_care = 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # D2: main child care arrangement
        - id: qd2
          kind: Question
          title: "What is your MAIN child care arrangement?"
          precondition:
            - predicate: uses_child_care == 1
          input:
            control: Radio
            labels:
              1: "Before and after school program"
              2: "Nursery school"
              3: "Day care centre"
              4: "Care in someone else's home by a non-relative"
              5: "Care in someone else's home by a relative"
              6: "Care in child's home by a non-relative"
              7: "Care in child's home by a relative"
              8: "Other"

        # D3: hours per week
        - id: qd3
          kind: Question
          title: "Approximately how many hours per WEEK is that?"
          precondition:
            - predicate: uses_child_care == 1
          input:
            control: Editbox
            min: 1
            max: 99

        # D4: other child care arrangement
        - id: qd4
          kind: Question
          title: "Do you use any other child care arrangement?"
          precondition:
            - predicate: uses_child_care == 1
          codeBlock: |
            if qd4.outcome == 1:
                uses_other_child_care = 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # D5: other hours per week
        - id: qd5
          kind: Question
          title: "Approximately how many hours per WEEK is that?"
          precondition:
            - predicate: uses_other_child_care == 1
          input:
            control: Editbox
            min: 1
            max: 99

        # D6: child care refusal
        - id: qd6
          kind: Question
          title: "Has a child care program or service ever refused to take care of the child because of his/her condition or health problem?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # D7: what type refused
        - id: qd7
          kind: QuestionGroup
          title: "What type of child care programs or services refused to provide care to the child?"
          precondition:
            - predicate: qd6.outcome == 1
          questions:
            - "Before and after school program"
            - "Nursery school"
            - "Day care centre"
            - "Care in someone else's home"
            - "Care in child's home"
            - "Other"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

    # =========================================================================
    # SECTION E - EDUCATION (p29-39)
    # NOT asked if child born AFTER May 15, 1996
    # =========================================================================
    - id: b_education
      title: "Section E - Education"
      precondition:
        - predicate: born_after_1996 == 0
      items:
        # E1: education status in April 2001
        - id: qe1
          kind: Question
          title: "In APRIL 2001, was the child:"
          codeBlock: |
            education_status = qe1.outcome
          input:
            control: Radio
            labels:
              1: "Going to school or kindergarten"
              2: "Being tutored at home through the school system"
              3: "Neither of the above"

        # E2: why tutored at home
        - id: qe2
          kind: QuestionGroup
          title: "Why was the child being tutored at home through the school system?"
          precondition:
            - predicate: education_status == 2
          questions:
            - "Personal care such as feeding and toiletting needed, but not available at school"
            - "Teacher's aides or special education classes not available in REGULAR SCHOOL"
            - "SPECIAL EDUCATION SCHOOL not available locally"
            - "Child's condition or health problem prevented him/her from going to school"
            - "Parents preferred home tutoring for the child"
            - "Other reason"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # E3: why not attending school (neither school nor home tutored)
        - id: qe3
          kind: QuestionGroup
          title: "Why was the child not attending school in April 2001?"
          precondition:
            - predicate: education_status == 3
          questions:
            - "Personal care such as feeding and toiletting needed, but not available at school"
            - "Teacher's aides or special education classes not available in REGULAR SCHOOL"
            - "SPECIAL EDUCATION SCHOOL not available locally"
            - "Child's condition or health problem prevented him/her from going to school"
            - "Child not ready or too young to attend school"
            - "Other reason"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # E4: did child ever go to school
        - id: qe4
          kind: Question
          title: "Did the child ever go to school?"
          precondition:
            - predicate: education_status == 3
          codeBlock: |
            ever_attended_school = qe4.outcome
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # E5: why never attended school
        - id: qe5
          kind: QuestionGroup
          title: "Why did the child never attend school?"
          precondition:
            - predicate: education_status == 3 and ever_attended_school == 3
          questions:
            - "Personal care such as feeding and toiletting needed, but not available at school"
            - "Teacher's aides or special education classes not available in REGULAR SCHOOL"
            - "SPECIAL EDUCATION SCHOOL not available locally"
            - "Child's condition or health problem prevented him/her from going to school"
            - "Child not ready or too young to attend school"
            - "Other reason"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # E6: type of school
        - id: qe6
          kind: Question
          title: "In APRIL 2001, what type of school was the child attending?"
          precondition:
            - predicate: education_status == 1
          codeBlock: |
            school_type = qe6.outcome
          input:
            control: Radio
            labels:
              1: "Special education school"
              2: "Regular school"
              3: "Regular school with special education classes"
              4: "Other"

        # E7: type of classes
        - id: qe7
          kind: Question
          title: "At this school, what type of classes was the child attending?"
          precondition:
            - predicate: education_status == 1 and (school_type == 2 or school_type == 3 or school_type == 4)
          codeBlock: |
            class_type = qe7.outcome
          input:
            control: Radio
            labels:
              1: "Only regular classes"
              2: "Some regular classes and some special education classes"
              3: "Only special education classes"

        # E8: ever attend special education school
        - id: qe8
          kind: Question
          title: "Did the child ever attend a special education school?"
          precondition:
            - predicate: education_status == 1 and (school_type == 2 or school_type == 3 or school_type == 4)
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # E9: why didn't attend special education school
        - id: qe9
          kind: QuestionGroup
          title: "Why didn't he/she attend a special education school in April 2001?"
          precondition:
            - predicate: education_status == 1 and (school_type == 2 or school_type == 3 or school_type == 4) and qe8.outcome == 1
          questions:
            - "Special education school no longer available locally"
            - "Child has moved into regular school"
            - "Other reason"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # E10.edit: If E7 is (1) "Only regular classes", go to E11. Otherwise continue.
        # E10: main condition requiring special education
        - id: qe10
          kind: QuestionGroup
          title: "What is the MAIN condition or health problem which required the child to receive special education services?"
          precondition:
            - predicate: education_status == 1 and (school_type == 1 or (school_type != 1 and class_type != 1))
          questions:
            - "Learning disabilities"
            - "Developmental disability or disorder"
            - "Speech or language difficulties"
            - "Emotional, psychological or behavioural conditions"
            - "Hearing difficulties, including deafness"
            - "Vision difficulties, including blindness"
            - "Difficulty with walking or moving around"
            - "Other condition"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # E11: difficulty getting special education services
        - id: qe11
          kind: Question
          title: "Did you ever have any difficulty in trying to get special education services for the child?"
          precondition:
            - predicate: education_status == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # E12: what kind of difficulty
        - id: qe12
          kind: QuestionGroup
          title: "What kind of difficulty did you have?"
          precondition:
            - predicate: education_status == 1 and qe11.outcome == 1
          questions:
            - "Special education services not available locally"
            - "Insufficient level of staffing or special education services"
            - "Communication problems with school"
            - "Difficulty to have the child tested for special education services"
            - "Other difficulty"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # E13: province of school (simplified - using generic grade question)
        - id: qe13
          kind: Question
          title: "In APRIL 2001, in which province or territory did the child attend school?"
          precondition:
            - predicate: education_status == 1 or (education_status == 3 and ever_attended_school == 1)
          codeBlock: |
            province_code = qe13.outcome
          input:
            control: Radio
            labels:
              1: "Newfoundland"
              2: "Prince Edward Island"
              3: "Nova Scotia"
              4: "New Brunswick"
              5: "Quebec"
              6: "Ontario"
              7: "Manitoba"
              8: "Saskatchewan"
              9: "Alberta"
              10: "British Columbia"
              11: "Northwest Territory"
              12: "Nunavut"
              13: "Yukon"
              14: "Other"

        # E19: grade enrolled (generic version covering all provinces)
        - id: qe19
          kind: Question
          title: "In what grade was the child enrolled in APRIL 2001?"
          precondition:
            - predicate: education_status == 1 or (education_status == 3 and ever_attended_school == 1)
          input:
            control: Radio
            labels:
              1: "Kindergarten"
              2: "Grade 1"
              3: "Grade 2"
              4: "Grade 3"
              5: "Grade 4"
              6: "Grade 5"
              7: "Grade 6"
              8: "Grade 7"
              9: "Grade 8"
              10: "Grade 9"
              11: "Grade 10"
              12: "Grade 11"
              13: "Grade 12"
              14: "Ungraded"

        # E20: type of education/therapy at school
        - id: qe20
          kind: QuestionGroup
          title: "In APRIL 2001, what type of education, training or therapy was the child receiving at school?"
          precondition:
            - predicate: education_status == 1
          questions:
            - "Academic subjects"
            - "Life skills"
            - "Speech and language therapy"
            - "Mental health or counselling services"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # E21: school performance
        - id: qe21
          kind: Question
          title: "Based on your knowledge of his/her school work, including his/her report cards, how did the child do during the last school year?"
          precondition:
            - predicate: education_status == 1
          input:
            control: Radio
            labels:
              1: "Very well"
              2: "Well"
              3: "Average"
              4: "Poorly"
              5: "Very poorly"
              6: "Not applicable"

        # E22: homework help frequency
        - id: qe22
          kind: Question
          title: "How often did you (or your spouse/partner) check the child's homework or provide help with his/her homework during the last school year?"
          precondition:
            - predicate: education_status == 1
          input:
            control: Radio
            labels:
              1: "Never or rarely"
              2: "Less than once a month"
              3: "At least once a month"
              4: "At least once a week"
              5: "A few times a week"
              6: "Every day"

        # E23: impact of condition on education
        - id: qe23
          kind: QuestionGroup
          title: "Because of a condition or health problem:"
          precondition:
            - predicate: education_status == 1
          questions:
            - "Did the child have to leave his/her community to attend school?"
            - "Was his/her schooling interrupted for long periods of time?"
            - "Did the child take fewer courses or academic subjects at school?"
            - "Did it take the child longer to achieve his/her present level of education?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # E24: school activities limited by condition
        - id: qe24
          kind: QuestionGroup
          title: "Did a condition or health problem limit the child's participation in any of the following SCHOOL ACTIVITIES during the last school year?"
          precondition:
            - predicate: education_status == 1
          questions:
            - "Taking part in physical education or organized games requiring physical activity"
            - "Playing with others during recess or lunch hour"
            - "Taking part in school outings, such as visits to a museum"
            - "Classroom participation"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # E25: special building features at school
        - id: qe25
          kind: Question
          title: "Because of a condition or health problem, did the child USE any special building features or equipment, such as ramps or automatic door openers AT SCHOOL?"
          precondition:
            - predicate: education_status == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # E26: which special features used
        - id: qe26
          kind: QuestionGroup
          title: "Which kind of special features did he/she USE at school?"
          precondition:
            - predicate: education_status == 1 and qe25.outcome == 1
          questions:
            - "Ramps or street level entrances"
            - "Widened doorways or hallways"
            - "Automatic or easy to open doors"
            - "An elevator or lift device"
            - "Special railings in washrooms"
            - "Other feature"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # E27: NEED special features not available
        - id: qe27
          kind: Question
          title: "Because of a condition or health problem, did the child NEED any special features or equipment AT SCHOOL, such as ramps or automatic door openers, which were not available?"
          precondition:
            - predicate: education_status == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # E28: which features needed
        - id: qe28
          kind: QuestionGroup
          title: "What kind of special features or equipment did he/she need AT SCHOOL, but did not have?"
          precondition:
            - predicate: education_status == 1 and qe27.outcome == 1
          questions:
            - "Ramps or street level entrances"
            - "Widened doorways or hallways"
            - "Automatic or easy to open doors"
            - "An elevator or lift device"
            - "Special railings in washrooms"
            - "Other feature"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # E29: assistive aids at school
        - id: qe29
          kind: QuestionGroup
          title: "During the last school year, did the child USE any assistive aids, devices or services AT SCHOOL?"
          precondition:
            - predicate: education_status == 1
          questions:
            - "Tutors or teacher's aides"
            - "Note takers or readers"
            - "Sign language interpreters"
            - "Attendant care services"
            - "Amplifiers, such as FM or infrared"
            - "Talking books"
            - "Magnifiers"
            - "Recording equipment"
            - "A computer with Braille or speech access"
            - "Other aid or service"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # E30: needed assistive aids but didn't have
        - id: qe30
          kind: Question
          title: "Were there any assistive aids, devices or services that the child needed AT SCHOOL, but did not have?"
          precondition:
            - predicate: education_status == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # E31: which aids needed at school
        - id: qe31
          kind: QuestionGroup
          title: "What kind of assistive aids or services did he/she need AT SCHOOL, but did not have?"
          precondition:
            - predicate: education_status == 1 and qe30.outcome == 1
          questions:
            - "Tutors or teacher's aides"
            - "Note takers or readers"
            - "Sign language interpreters"
            - "Attendant care services"
            - "Amplifiers, such as FM or infrared"
            - "Talking books"
            - "Magnifiers"
            - "Recording equipment"
            - "A computer with Braille or speech access"
            - "Other aid or service"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # E32: why didn't have aids at school
        - id: qe32
          kind: QuestionGroup
          title: "Why didn't the child have these aids or services AT SCHOOL?"
          precondition:
            - predicate: education_status == 1 and qe30.outcome == 1
          questions:
            - "School funding cutbacks or lack of funding in the school system"
            - "School did not think child needed assistive aids or services"
            - "Child did not want to use assistive aids or services"
            - "Other reason"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # E33: parent involvement at school
        - id: qe33
          kind: QuestionGroup
          title: "During the last school year, have you (or your partner/spouse) done any of the following for the child?"
          precondition:
            - predicate: education_status == 1
          questions:
            - "Spoken to, visited or corresponded with child's teacher"
            - "Attended a school event in which child participated"
            - "Volunteered in child's class or helped with a class trip"
            - "Helped elsewhere in the school, such as in the library or computer room"
            - "Attended a parent-school association, parent advisory committee or parent council meeting"
            - "Fundraising for school"
            - "Other activity"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # E34: school descriptions (agree/disagree)
        - id: qe34
          kind: QuestionGroup
          title: "Do you strongly agree, agree, disagree, or strongly disagree with the following descriptions of the school that the child attended during the last school year?"
          precondition:
            - predicate: education_status == 1
          questions:
            - "The school offered parents many opportunities to be involved in the school activities"
            - "Parents were made to feel welcome in the school"
            - "Overall, the school accommodated the child's condition or health problem"
          input:
            control: Radio
            labels:
              1: "Strongly agree"
              2: "Agree"
              3: "Disagree"
              4: "Strongly disagree"

        # E35: looking forward to school
        - id: qe35
          kind: Question
          title: "How often did the child look forward to going to school during the last school year?"
          precondition:
            - predicate: education_status == 1
          input:
            control: Radio
            labels:
              1: "Almost never"
              2: "Rarely"
              3: "Sometimes"
              4: "Often"
              5: "Almost always"

        # E36: transportation to school
        - id: qe36
          kind: Question
          title: "During the last school year, what was the method of transportation the child used MOST OFTEN to get to school?"
          precondition:
            - predicate: education_status == 1
          input:
            control: Radio
            labels:
              1: "Was driven to school by family motor vehicle"
              2: "School bus"
              3: "Regular city bus"
              4: "Specialized bus services for persons with disabilities"
              5: "Walked or biked to school"
              6: "Other"

        # E37: professional assessment
        - id: qe37
          kind: Question
          title: "Has a professional assessment ever been done to determine the child's educational needs?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # E38: who completed assessment
        - id: qe38
          kind: QuestionGroup
          title: "Who completed this assessment?"
          precondition:
            - predicate: qe37.outcome == 1
          questions:
            - "Psychologist or psychiatrist"
            - "Social worker"
            - "Special education consultant"
            - "Speech or language therapist"
            - "Other professional or specialist"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

    # =========================================================================
    # SECTION F - LEISURE AND RECREATION (p40-44)
    # NOT asked if child born AFTER May 15, 1996
    # =========================================================================
    - id: b_leisure
      title: "Section F - Leisure and Recreation Activities"
      precondition:
        - predicate: born_after_1996 == 0
      items:
        # F1: activities frequency
        - id: qf1
          kind: QuestionGroup
          title: "In the last 12 months, OUTSIDE OF SCHOOL HOURS, how often has the child:"
          questions:
            - "Taken part in sports with a coach or instructor (except dance or gymnastics)?"
            - "Taken lessons or instruction in other organized physical activities with a coach or instructor, such as dance, gymnastics or martial arts?"
            - "Taken part in unorganized sports or physical activities without a coach or instructor?"
            - "Taken lessons or instruction in music, art or other non-sport activities?"
            - "Taken part in clubs, groups or community programs, such as church groups, Girl or Boy Scouts?"
          input:
            control: Radio
            labels:
              1: "Everyday"
              2: "At least once a week"
              3: "At least once a month"
              4: "Less than once a month"
              5: "Never"

        # F2: home activities frequency
        - id: qf2
          kind: QuestionGroup
          title: "How often does he/she:"
          questions:
            - "Watch T.V.?"
            - "Play computer or video games?"
            - "Talk on the phone with friends?"
          input:
            control: Radio
            labels:
              1: "Everyday"
              2: "At least once a week"
              3: "At least once a month"
              4: "Less than once a month"
              5: "Never"

        # F3: reading frequency
        - id: qf3
          kind: Question
          title: "How often does the child read or have books read to him/her (for pleasure)? Please do not include reading that is required for school."
          input:
            control: Radio
            labels:
              1: "Everyday"
              2: "At least once a week"
              3: "At least once a month"
              4: "Less than once a month"
              5: "Never"

        # F4: play alone frequency
        - id: qf4
          kind: Question
          title: "Outside of school hours, how often does he/she play alone, for example, riding a bike or doing a craft?"
          input:
            control: Radio
            labels:
              1: "Often"
              2: "Sometimes"
              3: "Seldom"
              4: "Never"

        # F5: summer camp
        - id: qf5
          kind: Question
          title: "Has the child ever gone to summer camps (including regular or special camps)?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # F6: camp for children with conditions
        - id: qf6
          kind: Question
          title: "Was this a camp for children with a health problem or condition?"
          precondition:
            - predicate: qf5.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # F7: prevented from leisure activities
        - id: qf7
          kind: Question
          title: "Because of a condition or health problem, is the child prevented from taking part in any social or physical leisure activities?"
          codeBlock: |
            if qf7.outcome == 1:
                prevented_leisure = 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # F8: what prevents leisure
        - id: qf8
          kind: QuestionGroup
          title: "What prevents the child from doing more social or physical leisure activities?"
          precondition:
            - predicate: prevented_leisure == 1
          questions:
            - "Recreational facilities or programs not available locally"
            - "Buildings and equipment not physically accessible"
            - "Inadequate transportation services"
            - "Too expensive"
            - "Child is physically unable to do more"
            - "Child needs someone's assistance"
            - "Child needs specialized aids or equipment, but he/she doesn't have them"
            - "Other reason"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # F9: getting along with other children
        - id: qf9
          kind: Question
          title: "DURING THE PAST SIX MONTHS, how well has the child gotten along with other children, such as friends or classmates (excluding brothers or sisters)?"
          input:
            control: Radio
            labels:
              1: "Very well (or no problems)"
              2: "Quite well (or hardly any problems)"
              3: "Pretty well (or occasional problems)"
              4: "Not too well (or frequent problems)"
              5: "Not well at all (or constant problems)"

        # F10: computers at home
        - id: qf10
          kind: Question
          title: "How many personal computers are there in your home?"
          codeBlock: |
            if qf10.outcome == 2 or qf10.outcome == 3 or qf10.outcome == 4:
                has_computer = 1
          input:
            control: Radio
            labels:
              1: "None"
              2: "One"
              3: "Two"
              4: "Three or more"

        # F11: reasons for not purchasing computer
        - id: qf11
          kind: QuestionGroup
          title: "What are the reasons that keep you from purchasing a personal computer?"
          precondition:
            - predicate: has_computer == 0
          questions:
            - "Cost"
            - "Not needed at home"
            - "Not interested"
            - "Lack of computer skills or training"
            - "Fear of technology"
            - "Disability"
            - "Other"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # F12: household connected to Internet
        - id: qf12
          kind: Question
          title: "Is your household connected to the Internet?"
          precondition:
            - predicate: has_computer == 1
          codeBlock: |
            if qf12.outcome == 1:
                has_internet = 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # F13: reasons for no Internet
        - id: qf13
          kind: QuestionGroup
          title: "What are the reasons that keep you from getting Internet access for your HOME?"
          precondition:
            - predicate: has_computer == 1 and has_internet == 0
          questions:
            - "Cost"
            - "Not needed at home"
            - "Not interested"
            - "Lack of computer skills or training"
            - "Fear of technology"
            - "Disability"
            - "Other"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # F14: does child use Internet at home
        - id: qf14
          kind: Question
          title: "Does the child use the Internet AT HOME?"
          precondition:
            - predicate: has_internet == 1
          codeBlock: |
            if qf14.outcome == 1:
                uses_internet_home = 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # F15: reasons for not using Internet at home
        - id: qf15
          kind: QuestionGroup
          title: "What are the reasons that keep the child from using the Internet at home?"
          precondition:
            - predicate: has_internet == 1 and uses_internet_home == 0
          questions:
            - "Child too young or not ready to use it"
            - "Child does not need it"
            - "Child is not interested"
            - "Child does not have the computer skills or training"
            - "Child's condition or health problem"
            - "Other"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # F16: Internet usage frequency at home
        - id: qf16
          kind: QuestionGroup
          title: "AT HOME, how often does he/she use:"
          precondition:
            - predicate: uses_internet_home == 1
          questions:
            - "Internet to participate in newsgroups or chat groups?"
            - "Internet for school work?"
            - "Internet for personal interest or entertainment?"
            - "E-mail to stay in touch with friends?"
          input:
            control: Radio
            labels:
              1: "Everyday"
              2: "At least once a week"
              3: "At least once a month"
              4: "Less than once a month"
              5: "Never"

    # =========================================================================
    # SECTION G - HOME ACCOMMODATION (p45-47)
    # NOT asked if child born AFTER May 15, 1996
    # =========================================================================
    - id: b_home
      title: "Section G - Home Accommodation"
      precondition:
        - predicate: born_after_1996 == 0
      items:
        # G1: exterior features
        - id: qg1
          kind: Question
          title: "Because of a condition or health problem, does the child USE any special features, such as access ramps or automatic door openers to ENTER or LEAVE his/her residence?"
          codeBlock: |
            if qg1.outcome == 1:
                uses_exterior_features = 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # G2: which exterior features used
        - id: qg2
          kind: QuestionGroup
          title: "Which special features does he/she use?"
          precondition:
            - predicate: uses_exterior_features == 1
          questions:
            - "Ramps or street level entrances"
            - "Widened doorways or hallways"
            - "Automatic or easy to open doors"
            - "An elevator or lift device"
            - "Other feature"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # G3: NEED exterior features
        - id: qg3
          kind: Question
          title: "Does the child CURRENTLY need any special features to enter or leave his/her residence, which he/she does not have?"
          codeBlock: |
            if qg3.outcome == 1:
                needs_exterior_features = 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # G4: which exterior features needed
        - id: qg4
          kind: QuestionGroup
          title: "Which special features does the child NEED, but does not have?"
          precondition:
            - predicate: needs_exterior_features == 1
          questions:
            - "Ramps or street level entrances"
            - "Widened doorways or hallways"
            - "Automatic or easy to open doors"
            - "An elevator or lift device"
            - "Other feature"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # G5: why doesn't have exterior features
        - id: qg5
          kind: QuestionGroup
          title: "Why doesn't the child have these special features?"
          precondition:
            - predicate: needs_exterior_features == 1
          questions:
            - "Not covered by insurance"
            - "Too expensive"
            - "Landlord/landlady not willing"
            - "Only needed occasionally"
            - "Other reason"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # G6: interior features
        - id: qg6
          kind: Question
          title: "Because of a condition or health problem, does the child USE any special features, such as special railings, grab bars or lift devices INSIDE his/her residence?"
          codeBlock: |
            if qg6.outcome == 1:
                uses_interior_features = 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # G7: which interior features used
        - id: qg7
          kind: QuestionGroup
          title: "Which special features does the child use INSIDE his/her residence?"
          precondition:
            - predicate: uses_interior_features == 1
          questions:
            - "Grab bars or bath lift device in the bathroom"
            - "Lowered counters, sinks or switches in the kitchen"
            - "An elevator or lift device"
            - "Widened doorways or hallways"
            - "Automatic or easy to open doors"
            - "Visual or flashing alarms"
            - "Audio warning devices"
            - "Other feature"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # G8: NEED interior features
        - id: qg8
          kind: Question
          title: "Does the child CURRENTLY need any special features INSIDE his/her residence, which he/she does not have?"
          codeBlock: |
            if qg8.outcome == 1:
                needs_interior_features = 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # G9: which interior features needed
        - id: qg9
          kind: QuestionGroup
          title: "Which special features does the child NEED, but does not have?"
          precondition:
            - predicate: needs_interior_features == 1
          questions:
            - "Grab bars or bath lift device in the bathroom"
            - "Lowered counters, sinks or switches in the kitchen"
            - "An elevator or lift device"
            - "Widened doorways or hallways"
            - "Automatic or easy to open doors"
            - "Visual or flashing alarms"
            - "Audio warning devices"
            - "Other feature"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # G10: why doesn't have interior features
        - id: qg10
          kind: QuestionGroup
          title: "Why doesn't the child have these special features INSIDE his/her residence?"
          precondition:
            - predicate: needs_interior_features == 1
          questions:
            - "Not covered by insurance"
            - "Too expensive"
            - "Landlord/landlady not willing"
            - "Only needed occasionally"
            - "Other reason"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

    # =========================================================================
    # SECTION H - TRANSPORTATION (p47-50)
    # NOT asked if child born AFTER May 15, 1996
    # =========================================================================
    - id: b_transportation
      title: "Section H - Transportation"
      precondition:
        - predicate: born_after_1996 == 0
      items:
        # H1: car features
        - id: qh1
          kind: Question
          title: "Because of the child's condition, does your car have special features or equipment, such as a lift device or a large trunk to carry a wheelchair?"
          codeBlock: |
            if qh1.outcome == 1:
                owns_car = 1
                has_car_features = 1
            if qh1.outcome == 3:
                owns_car = 1
            if qh1.outcome == 5:
                owns_car = 0
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              5: "DO NOT OWN A CAR"

        # H2: need other car features
        - id: qh2
          kind: Question
          title: "Do you NEED ANY OTHER special features or equipment for your car because of the child's condition?"
          precondition:
            - predicate: owns_car == 1 and has_car_features == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # H3: need car features (no current features)
        - id: qh3
          kind: Question
          title: "Because of the child's condition, do you NEED any special features or equipment (for your car)?"
          precondition:
            - predicate: owns_car == 1 and has_car_features == 0
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # H4: why don't have car features
        - id: qh4
          kind: QuestionGroup
          title: "Why do you not have these special features or equipment for your car?"
          precondition:
            - predicate: (owns_car == 1 and has_car_features == 1 and qh2.outcome == 1) or (owns_car == 1 and has_car_features == 0 and qh3.outcome == 1)
          questions:
            - "Not covered by insurance"
            - "Too expensive"
            - "Only needed occasionally"
            - "Other reason"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # H5: specialized bus service available
        - id: qh5
          kind: Question
          title: "Is a specialized bus service available in your area?"
          codeBlock: |
            if qh5.outcome == 1:
                bus_service_available = 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # H6: does child need this service
        - id: qh6
          kind: Question
          title: "Does the child NEED this service?"
          precondition:
            - predicate: bus_service_available == 0
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # H7: does child use this service
        - id: qh7
          kind: Question
          title: "Does the child use this service?"
          precondition:
            - predicate: bus_service_available == 1
          codeBlock: |
            if qh7.outcome == 1:
                uses_bus_service = 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # H8: how often uses service
        - id: qh8
          kind: Question
          title: "How often does he/she use this service?"
          precondition:
            - predicate: uses_bus_service == 1
          input:
            control: Radio
            labels:
              1: "Almost everyday for at least some part of the year"
              2: "Frequently"
              3: "Occasionally"
              4: "Seldom"

        # H9: difficulty using service
        - id: qh9
          kind: Question
          title: "IN THE PAST 12 MONTHS, did the child have any difficulty using this service?"
          precondition:
            - predicate: uses_bus_service == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # H10: what kind of difficulty
        - id: qh10
          kind: QuestionGroup
          title: "What kind of difficulty did he/she have?"
          precondition:
            - predicate: uses_bus_service == 1 and qh9.outcome == 1
          questions:
            - "Service is needed more often than currently offered"
            - "Impractical scheduling for child's needs"
            - "Booking rules don't allow for last minute arrangements"
            - "Too expensive"
            - "Other reason"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # H11: taxi use
        - id: qh11
          kind: Question
          title: "IN THE PAST 12 MONTHS has the child had to use a taxi service because of his/her condition or health problem?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # H12: how often taxi
        - id: qh12
          kind: Question
          title: "How often did he/she use a taxi service?"
          precondition:
            - predicate: qh11.outcome == 1
          input:
            control: Radio
            labels:
              1: "Almost everyday for at least some part of the year"
              2: "Frequently"
              3: "Occasionally"
              4: "Seldom"

        # H13: cancelled activities due to transportation
        - id: qh13
          kind: Question
          title: "IN THE PAST 12 MONTHS, for local trips which you must take with the child, have you had to cancel or reschedule some activities because of problems with transportation services?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # H14: transportation expenses
        - id: qh14
          kind: Question
          title: "IN THE PAST 12 MONTHS, did you or your family have any OUT-OF-POCKET expenses for the child's transportation, for example, his/her travel to and from treatment, therapy or other medical or rehabilitation services?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # H15: expense amount
        - id: qh15
          kind: Question
          title: "What is your best estimate of the OUT-OF-POCKET or DIRECT costs to you or your family for these extra expenses?"
          precondition:
            - predicate: qh14.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 999999
            left: "$"

        # H16: expense group
        - id: qh16
          kind: Question
          title: "Which one of the following expense groups is the best estimate of the direct costs to you or your family?"
          precondition:
            - predicate: qh14.outcome == 1
          input:
            control: Radio
            labels:
              1: "Less than $100"
              2: "$100 to less than $200"
              3: "$200 to less than $500"
              4: "$500 to less than $1000"
              5: "$1000 to less than $2000"
              6: "$2000 to less than $5000"
              7: "$5000 or more"

    # =========================================================================
    # SECTION I - ECONOMIC CHARACTERISTICS (p50-51)
    # =========================================================================
    - id: b_economic
      title: "Section I - Economic Characteristics"
      items:
        # I1: insurance coverage
        - id: qi1
          kind: QuestionGroup
          title: "Do you have insurance that covers all or part of:"
          questions:
            - "The cost of the child's prescription medications?"
            - "The cost of the child's eye glasses or contact lenses?"
            - "Hospital charges for a private or semi-private room?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # I2: child care tax credit
        - id: qi2
          kind: Question
          title: "Did you claim Child Care Expenses for the child with your 2000 income tax return?"
          codeBlock: |
            if qi2.outcome == 1:
                claimed_child_care_credit = 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # I3: received child care credit
        - id: qi3
          kind: Question
          title: "Did you receive it?"
          precondition:
            - predicate: claimed_child_care_credit == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # I4: medical expenses credit
        - id: qi4
          kind: Question
          title: "Did you claim Medical Expenses for the child with your 2000 income tax return?"
          codeBlock: |
            if qi4.outcome == 1:
                claimed_medical_credit = 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # I5: received medical credit
        - id: qi5
          kind: Question
          title: "Did you receive it?"
          precondition:
            - predicate: claimed_medical_credit == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # I6: disability tax credit
        - id: qi6
          kind: Question
          title: "Did you claim a Disability Tax Credit for the child with your 2000 income tax return?"
          codeBlock: |
            if qi6.outcome == 1:
                claimed_disability_credit = 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # I7: received disability credit
        - id: qi7
          kind: Question
          title: "Did you receive it?"
          precondition:
            - predicate: claimed_disability_credit == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # I8: why not claim disability credit
        - id: qi8
          kind: QuestionGroup
          title: "Why did you not claim the Disability Tax Credit?"
          precondition:
            - predicate: qi6.outcome == 3
          questions:
            - "You did not know it existed"
            - "You did not think that the child would meet the eligibility requirements"
            - "You were not able to obtain the disability certificate (Form T2201) from your doctor"
            - "Other reason"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # I9: household income
        - id: qi9
          kind: Question
          title: "For the year ending December 31, 2000, what is your best estimate of the total income, before taxes and deductions, of all household members, including yourself, from all sources?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            left: "$"

        # I10: income group (fallback)
        - id: qi10
          kind: Question
          title: "Can you estimate in which of the following groups your HOUSEHOLD INCOME fell?"
          input:
            control: Radio
            labels:
              1: "$1 to less than $5000"
              2: "$5,000 to less than $10,000"
              3: "$10,000 to less than $15,000"
              4: "$15,000 to less than $20,000"
              5: "$20,000 to less than $30,000"
              6: "$30,000 to less than $40,000"
              7: "$40,000 to less than $50,000"
              8: "$50,000 to less than $60,000"
              9: "$60,000 to less than $80,000"
              10: "$80,000 or more"

    # =========================================================================
    # FOLLOW-UP (p52)
    # =========================================================================
    - id: b_followup
      title: "Follow-up"
      items:
        - id: q_followup
          kind: Question
          title: "May Statistics Canada contact you again in a year or two to find out more about the child?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
