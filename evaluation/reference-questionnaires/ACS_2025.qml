qmlVersion: "1.0"
questionnaire:
  title: "2025 American Community Survey"
  codeInit: |
    num_people = 0
    is_house_or_mobile = 0
    has_acreage = 0
    ag_sales_applicable = 0
    internet_paid = 0
    is_owner = 0
    is_renter = 0
    is_occupied_free = 0
    is_mobile_home = 0
    has_mortgage = 0
    has_second_mortgage = 0
    no_regular_payment = 0
    born_in_us = 0
    is_us_citizen_nat = 0
    attended_school = 0
    has_bachelors = 0
    speaks_other_lang = 0
    lived_here_1yr = 0
    moved_diff_house = 0
    is_insured = 0
    has_premium = 0
    is_age_5plus = 0
    is_age_15plus = 0
    is_female_15_50 = 0
    has_grandchildren = 0
    is_grandparent_responsible = 0
    ever_served_military = 0
    served_active_duty = 0
    has_va_rating = 0
    worked_last_week = 0
    worked_any = 0
    drove_car = 0
    did_not_work = 0
    on_layoff = 0
    temp_absent = 0
    was_recalled = 0
    looked_for_work = 0
    last_worked_recent = 0
    worked_past_5yrs = 0
    worked_every_week = 0
    p1_sex = 0
    p1_age = 0
    hoa_yes = 0
    never_married = 0
    marital_not_never = 0

  blocks:
    # =========================================================================
    # COVER PAGE - Household Count
    # =========================================================================
    - id: b_cover
      title: "Start Here"
      items:
        - id: q_intro
          kind: Comment
          title: "Welcome to the 2025 American Community Survey. Your response is required by law. The U.S. Census Bureau is required by law to protect your information."

        - id: q_num_people
          kind: Question
          title: "How many people, including yourself, live or stay at this address? Include anyone not related to you, like roommates and other families; babies and children, related or unrelated; everyone staying here now who has no other place to stay. Do NOT include anyone living somewhere else such as a college student living away or someone in the Armed Forces on deployment."
          input:
            control: Editbox
            min: 1
            max: 12
          codeBlock: |
            num_people = q_num_people.outcome

    # =========================================================================
    # PERSON 1 - Basic Demographics (Pages 2)
    # =========================================================================
    - id: b_person1_basic
      title: "Person 1"
      items:
        - id: q_p1_intro
          kind: Comment
          title: "Person 1 is the person living or staying here in whose name this house or apartment is owned, being bought, or rented. If there is no such person, start with the name of any adult living or staying here."

        - id: q_p1_relationship
          kind: Question
          title: "How is this person related to Person 1?"
          input:
            control: Radio
            labels:
              1: "Person 1"
          codeBlock: |
            p1_age = 0
            p1_sex = 0

        - id: q_p1_sex
          kind: Question
          title: "What is Person 1's sex?"
          input:
            control: Radio
            labels:
              1: "Male"
              2: "Female"
          codeBlock: |
            p1_sex = q_p1_sex.outcome

        - id: q_p1_age
          kind: Question
          title: "What is Person 1's age? For babies less than 1 year old, do not write the age in months. Write 0 as the age."
          input:
            control: Editbox
            min: 0
            max: 130
            right: "years"
          codeBlock: |
            p1_age = q_p1_age.outcome
            if p1_age >= 5:
                is_age_5plus = 1
            if p1_age >= 15:
                is_age_15plus = 1
            if p1_sex == 2 and p1_age >= 15 and p1_age <= 50:
                is_female_15_50 = 1

        - id: q_p1_birth_month
          kind: Question
          title: "What is Person 1's month of birth?"
          input:
            control: Editbox
            min: 1
            max: 12

        - id: q_p1_birth_day
          kind: Question
          title: "What is Person 1's day of birth?"
          input:
            control: Editbox
            min: 1
            max: 31

        - id: q_p1_birth_year
          kind: Question
          title: "What is Person 1's year of birth?"
          input:
            control: Editbox
            min: 1880
            max: 2025

        - id: q_p1_hispanic
          kind: Question
          title: "Is Person 1 of Hispanic, Latino, or Spanish origin?"
          input:
            control: Radio
            labels:
              1: "No, not of Hispanic, Latino, or Spanish origin"
              2: "Yes, Mexican, Mexican Am., Chicano"
              3: "Yes, Puerto Rican"
              4: "Yes, Cuban"
              5: "Yes, another Hispanic, Latino, or Spanish origin"

        - id: q_p1_hispanic_other
          kind: Question
          title: "Please specify the other Hispanic, Latino, or Spanish origin (for example, Salvadoran, Dominican, Colombian, Guatemalan, Spaniard, Ecuadorian, etc.):"
          precondition:
            - predicate: q_p1_hispanic.outcome == 5
          input:
            control: Textarea
            placeholder: "Print origin..."
            maxLength: 200

        - id: q_p1_race
          kind: Question
          title: "What is Person 1's race? Mark one or more boxes AND print origins."
          input:
            control: Checkbox
            labels:
              1: "White"
              2: "Black or African Am."
              4: "American Indian or Alaska Native"
              8: "Chinese"
              16: "Filipino"
              32: "Asian Indian"
              64: "Vietnamese"
              128: "Korean"
              256: "Japanese"
              512: "Other Asian"
              1024: "Native Hawaiian"
              2048: "Samoan"
              4096: "Chamorro"
              8192: "Other Pacific Islander"
              16384: "Some other race"

        - id: q_p1_race_white_origin
          kind: Question
          title: "Please print White origins (for example, German, Irish, English, Italian, Lebanese, Egyptian, etc.):"
          precondition:
            - predicate: q_p1_race.outcome % 2 >= 1
          input:
            control: Textarea
            placeholder: "Print origins..."
            maxLength: 200

        - id: q_p1_race_black_origin
          kind: Question
          title: "Please print Black or African American origins (for example, African American, Jamaican, Haitian, Nigerian, Ethiopian, Somali, etc.):"
          precondition:
            - predicate: q_p1_race.outcome % 4 >= 2
          input:
            control: Textarea
            placeholder: "Print origins..."
            maxLength: 200

        - id: q_p1_race_aian_tribe
          kind: Question
          title: "Please print name of enrolled or principal tribe(s) for American Indian or Alaska Native (for example, Navajo Nation, Blackfeet Tribe, Mayan, Aztec, etc.):"
          precondition:
            - predicate: q_p1_race.outcome % 8 >= 4
          input:
            control: Textarea
            placeholder: "Print tribe(s)..."
            maxLength: 200

        - id: q_p1_race_other_asian
          kind: Question
          title: "Please print other Asian origin (for example, Pakistani, Cambodian, Hmong, etc.):"
          precondition:
            - predicate: q_p1_race.outcome % 1024 >= 512
          input:
            control: Textarea
            placeholder: "Print origin..."
            maxLength: 200

        - id: q_p1_race_other_pi
          kind: Question
          title: "Please print other Pacific Islander origin (for example, Tongan, Fijian, Marshallese, etc.):"
          precondition:
            - predicate: q_p1_race.outcome % 16384 >= 8192
          input:
            control: Textarea
            placeholder: "Print origin..."
            maxLength: 200

        - id: q_p1_race_some_other
          kind: Question
          title: "Please print some other race or origin:"
          precondition:
            - predicate: q_p1_race.outcome % 32768 >= 16384
          input:
            control: Textarea
            placeholder: "Print race or origin..."
            maxLength: 200

    # =========================================================================
    # PERSON 2 - Basic Demographics (Page 3) - conditional on num_people >= 2
    # =========================================================================
    - id: b_person2_basic
      title: "Person 2"
      precondition:
        - predicate: num_people >= 2
      items:
        - id: q_p2_relationship
          kind: Question
          title: "How is this person related to Person 1?"
          input:
            control: Dropdown
            labels:
              1: "Opposite-sex husband/wife/spouse"
              2: "Opposite-sex unmarried partner"
              3: "Same-sex husband/wife/spouse"
              4: "Same-sex unmarried partner"
              5: "Biological son or daughter"
              6: "Adopted son or daughter"
              7: "Stepson or stepdaughter"
              8: "Brother or sister"
              9: "Father or mother"
              10: "Grandchild"
              11: "Parent-in-law"
              12: "Son-in-law or daughter-in-law"
              13: "Other relative"
              14: "Roommate or housemate"
              15: "Foster child"
              16: "Other nonrelative"

        - id: q_p2_sex
          kind: Question
          title: "What is Person 2's sex?"
          input:
            control: Radio
            labels:
              1: "Male"
              2: "Female"

        - id: q_p2_age
          kind: Question
          title: "What is Person 2's age?"
          input:
            control: Editbox
            min: 0
            max: 130
            right: "years"

        - id: q_p2_birth_month
          kind: Question
          title: "What is Person 2's month of birth?"
          input:
            control: Editbox
            min: 1
            max: 12

        - id: q_p2_birth_day
          kind: Question
          title: "What is Person 2's day of birth?"
          input:
            control: Editbox
            min: 1
            max: 31

        - id: q_p2_birth_year
          kind: Question
          title: "What is Person 2's year of birth?"
          input:
            control: Editbox
            min: 1880
            max: 2025

        - id: q_p2_hispanic
          kind: Question
          title: "Is Person 2 of Hispanic, Latino, or Spanish origin?"
          input:
            control: Radio
            labels:
              1: "No, not of Hispanic, Latino, or Spanish origin"
              2: "Yes, Mexican, Mexican Am., Chicano"
              3: "Yes, Puerto Rican"
              4: "Yes, Cuban"
              5: "Yes, another Hispanic, Latino, or Spanish origin"

        - id: q_p2_hispanic_other
          kind: Question
          title: "Please specify the other Hispanic, Latino, or Spanish origin:"
          precondition:
            - predicate: q_p2_hispanic.outcome == 5
          input:
            control: Textarea
            placeholder: "Print origin..."
            maxLength: 200

        - id: q_p2_race
          kind: Question
          title: "What is Person 2's race? Mark one or more boxes AND print origins."
          input:
            control: Checkbox
            labels:
              1: "White"
              2: "Black or African Am."
              4: "American Indian or Alaska Native"
              8: "Chinese"
              16: "Filipino"
              32: "Asian Indian"
              64: "Vietnamese"
              128: "Korean"
              256: "Japanese"
              512: "Other Asian"
              1024: "Native Hawaiian"
              2048: "Samoan"
              4096: "Chamorro"
              8192: "Other Pacific Islander"
              16384: "Some other race"

    # =========================================================================
    # PERSON 3 - Basic Demographics (Page 4)
    # =========================================================================
    - id: b_person3_basic
      title: "Person 3"
      precondition:
        - predicate: num_people >= 3
      items:
        - id: q_p3_relationship
          kind: Question
          title: "How is this person related to Person 1?"
          input:
            control: Dropdown
            labels:
              1: "Opposite-sex husband/wife/spouse"
              2: "Opposite-sex unmarried partner"
              3: "Same-sex husband/wife/spouse"
              4: "Same-sex unmarried partner"
              5: "Biological son or daughter"
              6: "Adopted son or daughter"
              7: "Stepson or stepdaughter"
              8: "Brother or sister"
              9: "Father or mother"
              10: "Grandchild"
              11: "Parent-in-law"
              12: "Son-in-law or daughter-in-law"
              13: "Other relative"
              14: "Roommate or housemate"
              15: "Foster child"
              16: "Other nonrelative"

        - id: q_p3_sex
          kind: Question
          title: "What is Person 3's sex?"
          input:
            control: Radio
            labels:
              1: "Male"
              2: "Female"

        - id: q_p3_age
          kind: Question
          title: "What is Person 3's age?"
          input:
            control: Editbox
            min: 0
            max: 130
            right: "years"

        - id: q_p3_birth_month
          kind: Question
          title: "What is Person 3's month of birth?"
          input:
            control: Editbox
            min: 1
            max: 12

        - id: q_p3_birth_day
          kind: Question
          title: "What is Person 3's day of birth?"
          input:
            control: Editbox
            min: 1
            max: 31

        - id: q_p3_birth_year
          kind: Question
          title: "What is Person 3's year of birth?"
          input:
            control: Editbox
            min: 1880
            max: 2025

        - id: q_p3_hispanic
          kind: Question
          title: "Is Person 3 of Hispanic, Latino, or Spanish origin?"
          input:
            control: Radio
            labels:
              1: "No, not of Hispanic, Latino, or Spanish origin"
              2: "Yes, Mexican, Mexican Am., Chicano"
              3: "Yes, Puerto Rican"
              4: "Yes, Cuban"
              5: "Yes, another Hispanic, Latino, or Spanish origin"

        - id: q_p3_hispanic_other
          kind: Question
          title: "Please specify the other Hispanic, Latino, or Spanish origin:"
          precondition:
            - predicate: q_p3_hispanic.outcome == 5
          input:
            control: Textarea
            placeholder: "Print origin..."
            maxLength: 200

        - id: q_p3_race
          kind: Question
          title: "What is Person 3's race? Mark one or more boxes AND print origins."
          input:
            control: Checkbox
            labels:
              1: "White"
              2: "Black or African Am."
              4: "American Indian or Alaska Native"
              8: "Chinese"
              16: "Filipino"
              32: "Asian Indian"
              64: "Vietnamese"
              128: "Korean"
              256: "Japanese"
              512: "Other Asian"
              1024: "Native Hawaiian"
              2048: "Samoan"
              4096: "Chamorro"
              8192: "Other Pacific Islander"
              16384: "Some other race"

    # =========================================================================
    # PERSON 4 - Basic Demographics (Page 5)
    # =========================================================================
    - id: b_person4_basic
      title: "Person 4"
      precondition:
        - predicate: num_people >= 4
      items:
        - id: q_p4_relationship
          kind: Question
          title: "How is this person related to Person 1?"
          input:
            control: Dropdown
            labels:
              1: "Opposite-sex husband/wife/spouse"
              2: "Opposite-sex unmarried partner"
              3: "Same-sex husband/wife/spouse"
              4: "Same-sex unmarried partner"
              5: "Biological son or daughter"
              6: "Adopted son or daughter"
              7: "Stepson or stepdaughter"
              8: "Brother or sister"
              9: "Father or mother"
              10: "Grandchild"
              11: "Parent-in-law"
              12: "Son-in-law or daughter-in-law"
              13: "Other relative"
              14: "Roommate or housemate"
              15: "Foster child"
              16: "Other nonrelative"

        - id: q_p4_sex
          kind: Question
          title: "What is Person 4's sex?"
          input:
            control: Radio
            labels:
              1: "Male"
              2: "Female"

        - id: q_p4_age
          kind: Question
          title: "What is Person 4's age?"
          input:
            control: Editbox
            min: 0
            max: 130
            right: "years"

        - id: q_p4_birth_month
          kind: Question
          title: "What is Person 4's month of birth?"
          input:
            control: Editbox
            min: 1
            max: 12

        - id: q_p4_birth_day
          kind: Question
          title: "What is Person 4's day of birth?"
          input:
            control: Editbox
            min: 1
            max: 31

        - id: q_p4_birth_year
          kind: Question
          title: "What is Person 4's year of birth?"
          input:
            control: Editbox
            min: 1880
            max: 2025

        - id: q_p4_hispanic
          kind: Question
          title: "Is Person 4 of Hispanic, Latino, or Spanish origin?"
          input:
            control: Radio
            labels:
              1: "No, not of Hispanic, Latino, or Spanish origin"
              2: "Yes, Mexican, Mexican Am., Chicano"
              3: "Yes, Puerto Rican"
              4: "Yes, Cuban"
              5: "Yes, another Hispanic, Latino, or Spanish origin"

        - id: q_p4_hispanic_other
          kind: Question
          title: "Please specify the other Hispanic, Latino, or Spanish origin:"
          precondition:
            - predicate: q_p4_hispanic.outcome == 5
          input:
            control: Textarea
            placeholder: "Print origin..."
            maxLength: 200

        - id: q_p4_race
          kind: Question
          title: "What is Person 4's race? Mark one or more boxes AND print origins."
          input:
            control: Checkbox
            labels:
              1: "White"
              2: "Black or African Am."
              4: "American Indian or Alaska Native"
              8: "Chinese"
              16: "Filipino"
              32: "Asian Indian"
              64: "Vietnamese"
              128: "Korean"
              256: "Japanese"
              512: "Other Asian"
              1024: "Native Hawaiian"
              2048: "Samoan"
              4096: "Chamorro"
              8192: "Other Pacific Islander"
              16384: "Some other race"

    # =========================================================================
    # PERSON 5 - Basic Demographics (Page 6)
    # =========================================================================
    - id: b_person5_basic
      title: "Person 5"
      precondition:
        - predicate: num_people >= 5
      items:
        - id: q_p5_relationship
          kind: Question
          title: "How is this person related to Person 1?"
          input:
            control: Dropdown
            labels:
              1: "Opposite-sex husband/wife/spouse"
              2: "Opposite-sex unmarried partner"
              3: "Same-sex husband/wife/spouse"
              4: "Same-sex unmarried partner"
              5: "Biological son or daughter"
              6: "Adopted son or daughter"
              7: "Stepson or stepdaughter"
              8: "Brother or sister"
              9: "Father or mother"
              10: "Grandchild"
              11: "Parent-in-law"
              12: "Son-in-law or daughter-in-law"
              13: "Other relative"
              14: "Roommate or housemate"
              15: "Foster child"
              16: "Other nonrelative"

        - id: q_p5_sex
          kind: Question
          title: "What is Person 5's sex?"
          input:
            control: Radio
            labels:
              1: "Male"
              2: "Female"

        - id: q_p5_age
          kind: Question
          title: "What is Person 5's age?"
          input:
            control: Editbox
            min: 0
            max: 130
            right: "years"

        - id: q_p5_birth_month
          kind: Question
          title: "What is Person 5's month of birth?"
          input:
            control: Editbox
            min: 1
            max: 12

        - id: q_p5_birth_day
          kind: Question
          title: "What is Person 5's day of birth?"
          input:
            control: Editbox
            min: 1
            max: 31

        - id: q_p5_birth_year
          kind: Question
          title: "What is Person 5's year of birth?"
          input:
            control: Editbox
            min: 1880
            max: 2025

        - id: q_p5_hispanic
          kind: Question
          title: "Is Person 5 of Hispanic, Latino, or Spanish origin?"
          input:
            control: Radio
            labels:
              1: "No, not of Hispanic, Latino, or Spanish origin"
              2: "Yes, Mexican, Mexican Am., Chicano"
              3: "Yes, Puerto Rican"
              4: "Yes, Cuban"
              5: "Yes, another Hispanic, Latino, or Spanish origin"

        - id: q_p5_hispanic_other
          kind: Question
          title: "Please specify the other Hispanic, Latino, or Spanish origin:"
          precondition:
            - predicate: q_p5_hispanic.outcome == 5
          input:
            control: Textarea
            placeholder: "Print origin..."
            maxLength: 200

        - id: q_p5_race
          kind: Question
          title: "What is Person 5's race? Mark one or more boxes AND print origins."
          input:
            control: Checkbox
            labels:
              1: "White"
              2: "Black or African Am."
              4: "American Indian or Alaska Native"
              8: "Chinese"
              16: "Filipino"
              32: "Asian Indian"
              64: "Vietnamese"
              128: "Korean"
              256: "Japanese"
              512: "Other Asian"
              1024: "Native Hawaiian"
              2048: "Samoan"
              4096: "Chamorro"
              8192: "Other Pacific Islander"
              16384: "Some other race"

    # =========================================================================
    # PERSONS 6-12 Abbreviated (Page 7)
    # =========================================================================
    - id: b_persons_6_12
      title: "Additional Persons (6-12)"
      precondition:
        - predicate: num_people >= 6
      items:
        - id: q_p6_12_intro
          kind: Comment
          title: "If there are more than five people living or staying here, print their names in the spaces below. We may call you for more information about them."

        - id: q_p6_sex
          kind: Question
          title: "Person 6: Sex?"
          input:
            control: Radio
            labels:
              1: "Male"
              2: "Female"

        - id: q_p6_age
          kind: Question
          title: "Person 6: Age (in years)?"
          input:
            control: Editbox
            min: 0
            max: 130

        - id: q_p7_sex
          kind: Question
          title: "Person 7: Sex?"
          precondition:
            - predicate: num_people >= 7
          input:
            control: Radio
            labels:
              1: "Male"
              2: "Female"

        - id: q_p7_age
          kind: Question
          title: "Person 7: Age (in years)?"
          precondition:
            - predicate: num_people >= 7
          input:
            control: Editbox
            min: 0
            max: 130

        - id: q_p8_sex
          kind: Question
          title: "Person 8: Sex?"
          precondition:
            - predicate: num_people >= 8
          input:
            control: Radio
            labels:
              1: "Male"
              2: "Female"

        - id: q_p8_age
          kind: Question
          title: "Person 8: Age (in years)?"
          precondition:
            - predicate: num_people >= 8
          input:
            control: Editbox
            min: 0
            max: 130

        - id: q_p9_sex
          kind: Question
          title: "Person 9: Sex?"
          precondition:
            - predicate: num_people >= 9
          input:
            control: Radio
            labels:
              1: "Male"
              2: "Female"

        - id: q_p9_age
          kind: Question
          title: "Person 9: Age (in years)?"
          precondition:
            - predicate: num_people >= 9
          input:
            control: Editbox
            min: 0
            max: 130

        - id: q_p10_sex
          kind: Question
          title: "Person 10: Sex?"
          precondition:
            - predicate: num_people >= 10
          input:
            control: Radio
            labels:
              1: "Male"
              2: "Female"

        - id: q_p10_age
          kind: Question
          title: "Person 10: Age (in years)?"
          precondition:
            - predicate: num_people >= 10
          input:
            control: Editbox
            min: 0
            max: 130

        - id: q_p11_sex
          kind: Question
          title: "Person 11: Sex?"
          precondition:
            - predicate: num_people >= 11
          input:
            control: Radio
            labels:
              1: "Male"
              2: "Female"

        - id: q_p11_age
          kind: Question
          title: "Person 11: Age (in years)?"
          precondition:
            - predicate: num_people >= 11
          input:
            control: Editbox
            min: 0
            max: 130

        - id: q_p12_sex
          kind: Question
          title: "Person 12: Sex?"
          precondition:
            - predicate: num_people >= 12
          input:
            control: Radio
            labels:
              1: "Male"
              2: "Female"

        - id: q_p12_age
          kind: Question
          title: "Person 12: Age (in years)?"
          precondition:
            - predicate: num_people >= 12
          input:
            control: Editbox
            min: 0
            max: 130

    # =========================================================================
    # HOUSING - Page 8
    # =========================================================================
    - id: b_housing
      title: "Housing"
      items:
        - id: q_h_intro
          kind: Comment
          title: "Please answer the following questions about the house, apartment, or mobile home at the address on the mailing label."

        - id: q_h1_building_type
          kind: Question
          title: "Which best describes this building? Include all apartments, flats, etc., even if vacant."
          input:
            control: Dropdown
            labels:
              1: "A mobile home"
              2: "A one-family house detached from any other house"
              3: "A one-family house attached to one or more houses"
              4: "A building with 2 apartments"
              5: "A building with 3 or 4 apartments"
              6: "A building with 5 to 9 apartments"
              7: "A building with 10 to 19 apartments"
              8: "A building with 20 to 49 apartments"
              9: "A building with 50 or more apartments"
              10: "Boat, RV, van, etc."
          codeBlock: |
            if q_h1_building_type.outcome in [1, 2, 3]:
                is_house_or_mobile = 1
            if q_h1_building_type.outcome == 1:
                is_mobile_home = 1

        - id: q_h2_year_built
          kind: Question
          title: "About when was this building first built?"
          input:
            control: Dropdown
            labels:
              1: "2020 or later"
              2: "2010 to 2019"
              3: "2000 to 2009"
              4: "1990 to 1999"
              5: "1980 to 1989"
              6: "1970 to 1979"
              7: "1960 to 1969"
              8: "1950 to 1959"
              9: "1940 to 1949"
              10: "1939 or earlier"

        - id: q_h2_year_built_specify
          kind: Question
          title: "Specify the year built (2020 or later):"
          precondition:
            - predicate: q_h2_year_built.outcome == 1
          input:
            control: Editbox
            min: 2020
            max: 2025

        - id: q_h3_move_in_month
          kind: Question
          title: "When did Person 1 (listed on page 2) move into this house, apartment, or mobile home? Month:"
          input:
            control: Editbox
            min: 1
            max: 12

        - id: q_h3_move_in_year
          kind: Question
          title: "When did Person 1 move into this house, apartment, or mobile home? Year:"
          input:
            control: Editbox
            min: 1900
            max: 2025

    # =========================================================================
    # HOUSING - Acreage and Agriculture (Page 8 right side, conditional)
    # =========================================================================
    - id: b_housing_acreage
      title: "Housing - Acreage and Agriculture"
      precondition:
        - predicate: is_house_or_mobile == 1
      items:
        - id: q_h4_acres
          kind: Question
          title: "How many acres is this house or mobile home on?"
          input:
            control: Radio
            labels:
              1: "Less than 1 acre"
              2: "1 to 9.9 acres"
              3: "10 or more acres"
          codeBlock: |
            if q_h4_acres.outcome >= 2:
                has_acreage = 1

        - id: q_h5_ag_sales
          kind: Question
          title: "IN THE PAST 12 MONTHS, what were the actual sales of all agricultural products from this property?"
          precondition:
            - predicate: has_acreage == 1
          input:
            control: Radio
            labels:
              1: "None"
              2: "$1 to $999"
              3: "$1,000 to $2,499"
              4: "$2,500 to $4,999"
              5: "$5,000 to $9,999"
              6: "$10,000 or more"

    # =========================================================================
    # HOUSING - Rooms (Page 8)
    # =========================================================================
    - id: b_housing_rooms
      title: "Housing - Rooms"
      items:
        - id: q_h6a_rooms
          kind: Question
          title: "How many separate rooms are in this house, apartment, or mobile home? Rooms must be separated by built-in archways or walls that extend out at least 6 inches and go from floor to ceiling. INCLUDE bedrooms, kitchens, etc. EXCLUDE bathrooms, porches, balconies, foyers, halls, or unfinished basements."
          input:
            control: Editbox
            min: 1
            max: 30

        - id: q_h6b_bedrooms
          kind: Question
          title: "How many of these rooms are bedrooms? Count as bedrooms those rooms you would list if this house, apartment, or mobile home were for sale or rent. If this is an efficiency/studio apartment, print '0'."
          input:
            control: Editbox
            min: 0
            max: 30
          postcondition:
            - predicate: q_h6b_bedrooms.outcome <= q_h6a_rooms.outcome
              hint: "Number of bedrooms cannot exceed total number of rooms."

    # =========================================================================
    # HOUSING CONTINUED - Plumbing, Kitchen, Sewer, Phone (Page 9)
    # =========================================================================
    - id: b_housing_facilities
      title: "Housing - Facilities"
      items:
        - id: q_h7a_hot_cold_water
          kind: Question
          title: "Does this house, apartment, or mobile home have hot and cold running water?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q_h7b_bathtub
          kind: Question
          title: "Does this house, apartment, or mobile home have a bathtub or shower?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q_h7c_sink
          kind: Question
          title: "Does this house, apartment, or mobile home have a sink with a faucet?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q_h7d_stove
          kind: Question
          title: "Does this house, apartment, or mobile home have a stove or range?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q_h7e_refrigerator
          kind: Question
          title: "Does this house, apartment, or mobile home have a refrigerator?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q_h8_sewer
          kind: Question
          title: "Is this house, apartment, or mobile home connected to a public sewer?"
          input:
            control: Radio
            labels:
              1: "Yes, connected to public sewer"
              2: "No, connected to septic tank"
              3: "No, use other type of system"

        - id: q_h9_phone
          kind: Question
          title: "Can you or any member of this household both make and receive phone calls when at this house, apartment, or mobile home? Include calls using cell phones, land lines, or other phone devices."
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # =========================================================================
    # HOUSING - Computers and Internet (Page 9)
    # =========================================================================
    - id: b_housing_tech
      title: "Housing - Computers and Internet"
      items:
        - id: q_h10a_desktop
          kind: Question
          title: "At this house, apartment, or mobile home - do you or any member of this household own or use a desktop or laptop?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q_h10b_smartphone
          kind: Question
          title: "At this house, apartment, or mobile home - do you or any member of this household own or use a smartphone?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q_h10c_tablet
          kind: Question
          title: "At this house, apartment, or mobile home - do you or any member of this household own or use a tablet or other portable wireless computer?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q_h10d_other_computer
          kind: Question
          title: "At this house, apartment, or mobile home - do you or any member of this household own or use some other type of computer?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q_h10d_other_specify
          kind: Question
          title: "Please specify the other type of computer:"
          precondition:
            - predicate: q_h10d_other_computer.outcome == 1
          input:
            control: Textarea
            placeholder: "Specify..."
            maxLength: 200

        - id: q_h11_internet_access
          kind: Question
          title: "At this house, apartment, or mobile home - do you or any member of this household have access to the Internet?"
          input:
            control: Radio
            labels:
              1: "Yes, by paying a cell phone company or Internet service provider"
              2: "Yes, without paying a cell phone company or Internet service provider"
              3: "No access to the Internet at this house, apartment, or mobile home"
          codeBlock: |
            if q_h11_internet_access.outcome == 1:
                internet_paid = 1

        - id: q_h12a_cellular
          kind: Question
          title: "Do you or any member of this household have access to the Internet using a cellular data plan for a smartphone or other mobile device?"
          precondition:
            - predicate: internet_paid == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q_h12b_broadband
          kind: Question
          title: "Do you or any member of this household have access to the Internet using broadband (high speed) Internet service such as cable, fiber optic, or DSL service installed in this household?"
          precondition:
            - predicate: internet_paid == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q_h12c_satellite
          kind: Question
          title: "Do you or any member of this household have access to the Internet using satellite Internet service installed in this household?"
          precondition:
            - predicate: internet_paid == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q_h12d_dialup
          kind: Question
          title: "Do you or any member of this household have access to the Internet using dial-up Internet service installed in this household?"
          precondition:
            - predicate: internet_paid == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q_h12e_other_service
          kind: Question
          title: "Do you or any member of this household have access to the Internet using some other service?"
          precondition:
            - predicate: internet_paid == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q_h12e_other_specify
          kind: Question
          title: "Specify other Internet service:"
          precondition:
            - predicate: internet_paid == 1
            - predicate: q_h12e_other_service.outcome == 1
          input:
            control: Textarea
            placeholder: "Specify service..."
            maxLength: 200

    # =========================================================================
    # HOUSING - Vehicles, Electric Vehicle, Heating Fuel (Page 9)
    # =========================================================================
    - id: b_housing_vehicles
      title: "Housing - Vehicles and Energy"
      items:
        - id: q_h13_vehicles
          kind: Question
          title: "How many automobiles, vans, and trucks of one-ton capacity or less are kept at home for use by members of this household?"
          input:
            control: Radio
            labels:
              1: "None"
              2: "1"
              3: "2"
              4: "3"
              5: "4"
              6: "5"
              7: "6 or more"

        - id: q_h14_electric_vehicle
          kind: Question
          title: "Do you or any member of this household own or lease an electric vehicle? Include both all-electric and plug-in hybrid electric vehicles."
          precondition:
            - predicate: q_h13_vehicles.outcome >= 2
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q_h15_heating_fuel
          kind: Question
          title: "Which FUEL is used MOST for heating this house, apartment, or mobile home?"
          input:
            control: Dropdown
            labels:
              1: "Gas: Natural gas from underground pipes serving the neighborhood"
              2: "Gas: Bottled or tank (propane, butane, etc.)"
              3: "Electricity"
              4: "Fuel oil, kerosene, etc."
              5: "Coal or coke"
              6: "Wood"
              7: "Solar energy"
              8: "Other fuel"
              9: "No fuel used"

    # =========================================================================
    # HOUSING CONTINUED - Solar, Utilities, SNAP (Page 10)
    # =========================================================================
    - id: b_housing_costs
      title: "Housing - Solar and Utility Costs"
      items:
        - id: q_h16_solar
          kind: Question
          title: "Does this house, apartment, or mobile home use solar panels that generate electricity?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q_h17a_electricity_cost
          kind: Question
          title: "LAST MONTH, what was the cost of electricity for this house, apartment, or mobile home? Enter the dollar amount, or select an alternative."
          input:
            control: Radio
            labels:
              1: "Enter dollar amount"
              2: "Included in rent or condominium fee"
              3: "No charge or electricity not used"

        - id: q_h17a_electricity_dollars
          kind: Question
          title: "Last month's electricity cost (in dollars):"
          precondition:
            - predicate: q_h17a_electricity_cost.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 99999
            left: "$"

        - id: q_h17b_gas_cost
          kind: Question
          title: "LAST MONTH, what was the cost of gas for this house, apartment, or mobile home? Enter the dollar amount, or select an alternative."
          input:
            control: Radio
            labels:
              1: "Enter dollar amount"
              2: "Included in rent or condominium fee"
              3: "Included in electricity payment entered above"
              4: "No charge or gas not used"

        - id: q_h17b_gas_dollars
          kind: Question
          title: "Last month's gas cost (in dollars):"
          precondition:
            - predicate: q_h17b_gas_cost.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 99999
            left: "$"

        - id: q_h17c_water_cost
          kind: Question
          title: "IN THE PAST 12 MONTHS, what was the cost of water and sewer for this house, apartment, or mobile home? If you have lived here less than 12 months, estimate the cost."
          input:
            control: Radio
            labels:
              1: "Enter dollar amount"
              2: "Included in rent or condominium fee"
              3: "No charge"

        - id: q_h17c_water_dollars
          kind: Question
          title: "Past 12 months' water and sewer cost (in dollars):"
          precondition:
            - predicate: q_h17c_water_cost.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 99999
            left: "$"

        - id: q_h17d_fuel_cost
          kind: Question
          title: "IN THE PAST 12 MONTHS, what was the cost of oil, coal, kerosene, wood, etc., for this house, apartment, or mobile home? If you have lived here less than 12 months, estimate the cost."
          input:
            control: Radio
            labels:
              1: "Enter dollar amount"
              2: "Included in rent or condominium fee"
              3: "No charge or these fuels not used"

        - id: q_h17d_fuel_dollars
          kind: Question
          title: "Past 12 months' oil/coal/kerosene/wood cost (in dollars):"
          precondition:
            - predicate: q_h17d_fuel_cost.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 99999
            left: "$"

        - id: q_h18_snap
          kind: Question
          title: "IN THE PAST 12 MONTHS, did you or any member of this household receive benefits from the Food Stamp Program or SNAP (the Supplemental Nutrition Assistance Program)? Do NOT include WIC, the School Lunch Program, or assistance from food banks."
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q_h19_hoa
          kind: Question
          title: "Is this house, apartment, or mobile home part of a homeowners association or condominium?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
          codeBlock: |
            if q_h19_hoa.outcome == 1:
                hoa_yes = 1

        - id: q_h19_hoa_fee
          kind: Question
          title: "What is the required monthly homeowners association fee and/or condominium fee? For renters, answer only if you pay the fee in addition to your rent; otherwise, mark the 'None' box."
          precondition:
            - predicate: hoa_yes == 1
          input:
            control: Radio
            labels:
              1: "Enter monthly dollar amount"
              2: "None"

        - id: q_h19_hoa_fee_dollars
          kind: Question
          title: "Monthly HOA/condominium fee (in dollars):"
          precondition:
            - predicate: hoa_yes == 1
            - predicate: q_h19_hoa_fee.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 99999
            left: "$"

    # =========================================================================
    # HOUSING - Tenure (Page 10)
    # =========================================================================
    - id: b_housing_tenure
      title: "Housing - Tenure"
      items:
        - id: q_h20_tenure
          kind: Question
          title: "Is this house, apartment, or mobile home owned or rented?"
          input:
            control: Radio
            labels:
              1: "Owned by you or someone in this household with a mortgage or loan (include home equity loans)"
              2: "Owned by you or someone in this household free and clear (without a mortgage or loan)"
              3: "Rented"
              4: "Occupied without payment of rent"
          codeBlock: |
            if q_h20_tenure.outcome in [1, 2]:
                is_owner = 1
            if q_h20_tenure.outcome == 3:
                is_renter = 1
            if q_h20_tenure.outcome == 4:
                is_occupied_free = 1

    # =========================================================================
    # HOUSING - Rent (Page 10, conditional on rented)
    # =========================================================================
    - id: b_housing_rent
      title: "Housing - Rent"
      precondition:
        - predicate: is_renter == 1
      items:
        - id: q_h21a_rent
          kind: Question
          title: "What is the monthly rent for this house, apartment, or mobile home?"
          input:
            control: Editbox
            min: 0
            max: 99999
            left: "$"
            right: "per month"

        - id: q_h21b_meals
          kind: Question
          title: "Does the monthly rent include any meals?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # =========================================================================
    # HOUSING - Owner Costs (Page 11, conditional on owned)
    # =========================================================================
    - id: b_housing_owner
      title: "Housing - Owner Costs"
      precondition:
        - predicate: is_owner == 1
      items:
        - id: q_h22_value
          kind: Question
          title: "About how much do you think this house and lot, apartment, or mobile home (and lot, if owned) would sell for if it were for sale?"
          input:
            control: Editbox
            min: 0
            max: 99999999
            left: "$"

        - id: q_h23_property_tax
          kind: Question
          title: "What are the annual real estate taxes on THIS property?"
          input:
            control: Radio
            labels:
              1: "Enter annual dollar amount"
              2: "None"

        - id: q_h23_property_tax_dollars
          kind: Question
          title: "Annual real estate taxes (in dollars):"
          precondition:
            - predicate: q_h23_property_tax.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 999999
            left: "$"

        - id: q_h24_insurance
          kind: Question
          title: "What is the annual payment for fire, hazard, and flood insurance on THIS property?"
          input:
            control: Radio
            labels:
              1: "Enter annual dollar amount"
              2: "None"

        - id: q_h24_insurance_dollars
          kind: Question
          title: "Annual fire/hazard/flood insurance (in dollars):"
          precondition:
            - predicate: q_h24_insurance.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 999999
            left: "$"

        - id: q_h25a_mortgage
          kind: Question
          title: "Do you or any member of this household have a mortgage, deed of trust, contract to purchase, or similar debt on THIS property?"
          input:
            control: Radio
            labels:
              1: "Yes, mortgage, deed of trust, or similar debt"
              2: "Yes, contract to purchase"
              3: "No"
          codeBlock: |
            if q_h25a_mortgage.outcome in [1, 2]:
                has_mortgage = 1

        - id: q_h25b_mortgage_payment
          kind: Question
          title: "How much is the regular monthly mortgage payment on THIS property? Include payment only on FIRST mortgage or contract to purchase."
          precondition:
            - predicate: has_mortgage == 1
          input:
            control: Radio
            labels:
              1: "Enter monthly dollar amount"
              2: "No regular payment required"
          codeBlock: |
            if q_h25b_mortgage_payment.outcome == 2:
                no_regular_payment = 1

        - id: q_h25b_mortgage_dollars
          kind: Question
          title: "Regular monthly mortgage payment (in dollars):"
          precondition:
            - predicate: has_mortgage == 1
            - predicate: no_regular_payment == 0
          input:
            control: Editbox
            min: 0
            max: 99999
            left: "$"

        - id: q_h25c_taxes_in_mortgage
          kind: Question
          title: "Does the regular monthly mortgage payment include payments for real estate taxes on THIS property?"
          precondition:
            - predicate: has_mortgage == 1
          input:
            control: Radio
            labels:
              1: "Yes, taxes included in mortgage payment"
              2: "No, taxes paid separately or taxes not required"

        - id: q_h25d_insurance_in_mortgage
          kind: Question
          title: "Does the regular monthly mortgage payment include payments for fire, hazard, or flood insurance on THIS property?"
          precondition:
            - predicate: has_mortgage == 1
          input:
            control: Radio
            labels:
              1: "Yes, insurance included in mortgage payment"
              2: "No, insurance paid separately or no insurance"

        - id: q_h26a_second_mortgage
          kind: Question
          title: "Do you or any member of this household have a second mortgage or a home equity loan on THIS property?"
          input:
            control: Radio
            labels:
              1: "Yes, home equity loan"
              2: "Yes, second mortgage"
              3: "Yes, second mortgage and home equity loan"
              4: "No"
          codeBlock: |
            if q_h26a_second_mortgage.outcome in [1, 2, 3]:
                has_second_mortgage = 1

        - id: q_h26b_second_payment
          kind: Question
          title: "How much is the regular monthly payment on all second or junior mortgages and all home equity loans on THIS property?"
          precondition:
            - predicate: has_second_mortgage == 1
          input:
            control: Radio
            labels:
              1: "Enter monthly dollar amount"
              2: "No regular payment required"

        - id: q_h26b_second_dollars
          kind: Question
          title: "Monthly payment on second mortgages/home equity loans (in dollars):"
          precondition:
            - predicate: has_second_mortgage == 1
            - predicate: q_h26b_second_payment.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 99999
            left: "$"

    # =========================================================================
    # HOUSING - Mobile Home Costs (Page 11, conditional on mobile home)
    # =========================================================================
    - id: b_housing_mobile
      title: "Housing - Mobile Home Costs"
      precondition:
        - predicate: is_mobile_home == 1
      items:
        - id: q_h27_mobile_costs
          kind: Question
          title: "What are the total annual costs for personal property taxes, site rent, registration fees, and license fees on THIS mobile home and its site? Exclude real estate taxes."
          input:
            control: Editbox
            min: 0
            max: 999999
            left: "$"
            right: "per year"

    # =========================================================================
    # PERSON 1 DETAILED - Place of Birth, Citizenship (Page 12)
    # =========================================================================
    - id: b_person1_origin
      title: "Person 1 - Place of Birth and Citizenship"
      items:
        - id: q_p1_detail_intro
          kind: Comment
          title: "Answer questions about Person 1 on the following pages."

        - id: q_7_birthplace
          kind: Question
          title: "Where was this person born?"
          input:
            control: Radio
            labels:
              1: "In the United States"
              2: "Outside the United States"
          codeBlock: |
            if q_7_birthplace.outcome == 1:
                born_in_us = 1

        - id: q_7_birthplace_us_state
          kind: Question
          title: "Print name of U.S. state where born:"
          precondition:
            - predicate: born_in_us == 1
          input:
            control: Textarea
            placeholder: "State name..."
            maxLength: 100

        - id: q_7_birthplace_foreign
          kind: Question
          title: "Print name of foreign country, or Puerto Rico, Guam, etc.:"
          precondition:
            - predicate: born_in_us == 0
          input:
            control: Textarea
            placeholder: "Country name..."
            maxLength: 100

        - id: q_8_citizenship
          kind: Question
          title: "Is this person a citizen of the United States?"
          input:
            control: Dropdown
            labels:
              1: "Yes, born in the United States"
              2: "Yes, born in Puerto Rico, Guam, the U.S. Virgin Islands, or Northern Marianas"
              3: "Yes, born abroad of U.S. citizen parent or parents"
              4: "Yes, U.S. citizen by naturalization"
              5: "No, not a U.S. citizen"
          codeBlock: |
            if q_8_citizenship.outcome == 4:
                is_us_citizen_nat = 1

        - id: q_8_naturalization_year
          kind: Question
          title: "Print year of naturalization:"
          precondition:
            - predicate: is_us_citizen_nat == 1
          input:
            control: Editbox
            min: 1900
            max: 2025

        - id: q_9_year_came_to_us
          kind: Question
          title: "When did this person come to live in the United States? If this person came to live in the United States more than once, print latest year."
          precondition:
            - predicate: born_in_us == 0
          input:
            control: Editbox
            min: 1900
            max: 2025

    # =========================================================================
    # PERSON 1 - Education (Page 12)
    # =========================================================================
    - id: b_person1_education
      title: "Person 1 - Education"
      items:
        - id: q_10a_school_attendance
          kind: Question
          title: "At any time IN THE LAST 3 MONTHS, has this person attended school or college? Include only nursery or preschool, kindergarten, elementary school, home school, and schooling which leads to a high school diploma or a college degree."
          input:
            control: Radio
            labels:
              1: "No, has not attended in the last 3 months"
              2: "Yes, public school, public college"
              3: "Yes, private school, private college, home school"
          codeBlock: |
            if q_10a_school_attendance.outcome in [2, 3]:
                attended_school = 1

        - id: q_10b_grade_level
          kind: Question
          title: "What grade or level was this person attending?"
          precondition:
            - predicate: attended_school == 1
          input:
            control: Dropdown
            labels:
              1: "Nursery school, preschool"
              2: "Kindergarten"
              3: "Grade 1 through 12"
              4: "College undergraduate years (freshman to senior)"
              5: "Graduate or professional school beyond a bachelor's degree"

        - id: q_10b_grade_specify
          kind: Question
          title: "Specify grade 1 through 12:"
          precondition:
            - predicate: attended_school == 1
            - predicate: q_10b_grade_level.outcome == 3
          input:
            control: Editbox
            min: 1
            max: 12

        - id: q_11_highest_degree
          kind: Question
          title: "What is the highest grade of school or degree this person has COMPLETED? If currently enrolled, select the previous grade or highest degree received."
          input:
            control: Dropdown
            labels:
              1: "Less than grade 1"
              2: "Grade 1 through 11"
              3: "12th grade - NO DIPLOMA"
              4: "Regular high school diploma"
              5: "GED or alternative credential"
              6: "Some college credit, but less than 1 year of college credit"
              7: "1 or more years of college credit, no degree"
              8: "Associate's degree (for example: AA, AS)"
              9: "Bachelor's degree (for example: BA, BS)"
              10: "Master's degree (for example: MA, MS, MEng, MEd, MSW, MBA)"
              11: "Professional degree beyond a bachelor's degree (for example: MD, DDS, DVM, LLB, JD)"
              12: "Doctorate degree (for example: PhD, EdD)"
          codeBlock: |
            if q_11_highest_degree.outcome >= 9:
                has_bachelors = 1

        - id: q_11_grade_specify
          kind: Question
          title: "Specify grade 1 through 11:"
          precondition:
            - predicate: q_11_highest_degree.outcome == 2
          input:
            control: Editbox
            min: 1
            max: 11

    # =========================================================================
    # PERSON 1 - Bachelor's Degree Field (Page 13, conditional)
    # =========================================================================
    - id: b_person1_bachelors
      title: "Person 1 - Bachelor's Degree"
      precondition:
        - predicate: has_bachelors == 1
      items:
        - id: q_12_bachelors_field
          kind: Question
          title: "This question focuses on this person's BACHELOR'S DEGREE. Please print below the specific major(s) of any BACHELOR'S DEGREES this person has received. (For example: chemical engineering, elementary teacher education, organizational psychology.)"
          input:
            control: Textarea
            placeholder: "Print field(s) of degree..."
            maxLength: 300

    # =========================================================================
    # PERSON 1 - Ancestry and Language (Page 13)
    # =========================================================================
    - id: b_person1_ancestry
      title: "Person 1 - Ancestry and Language"
      items:
        - id: q_13_ancestry
          kind: Question
          title: "What is this person's ancestry or ethnic origin? (For example, Italian, Jamaican, African Am., Cambodian, Cape Verdean, Norwegian, Dominican, French Canadian, Haitian, Korean, Lebanese, Polish, Nigerian, Mexican, Taiwanese, Ukrainian, and so on.)"
          input:
            control: Textarea
            placeholder: "Print ancestry or ethnic origin..."
            maxLength: 200

        - id: q_14a_other_language
          kind: Question
          title: "Does this person speak a language other than English at home?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
          codeBlock: |
            if q_14a_other_language.outcome == 1:
                speaks_other_lang = 1

        - id: q_14b_language
          kind: Question
          title: "What is this language? (For example: Korean, Italian, Spanish, Vietnamese)"
          precondition:
            - predicate: speaks_other_lang == 1
          input:
            control: Textarea
            placeholder: "Print language..."
            maxLength: 100

        - id: q_14c_english_ability
          kind: Question
          title: "How well does this person speak English?"
          precondition:
            - predicate: speaks_other_lang == 1
          input:
            control: Radio
            labels:
              1: "Very well"
              2: "Well"
              3: "Not well"
              4: "Not at all"

    # =========================================================================
    # PERSON 1 - Migration (Page 13)
    # =========================================================================
    - id: b_person1_migration
      title: "Person 1 - Residence 1 Year Ago"
      items:
        - id: q_15a_residence_1yr
          kind: Question
          title: "Did this person live in this house or apartment 1 year ago?"
          input:
            control: Radio
            labels:
              1: "Person is under 1 year old"
              2: "Yes, this house"
              3: "No, outside the United States and Puerto Rico"
              4: "No, different house in the United States or Puerto Rico"
          codeBlock: |
            if q_15a_residence_1yr.outcome in [1, 2, 3]:
                lived_here_1yr = 1
            if q_15a_residence_1yr.outcome == 4:
                moved_diff_house = 1

        - id: q_15a_foreign_country
          kind: Question
          title: "Print name of foreign country, or U.S. Virgin Islands, Guam, etc.:"
          precondition:
            - predicate: q_15a_residence_1yr.outcome == 3
          input:
            control: Textarea
            placeholder: "Print country..."
            maxLength: 100

        - id: q_15b_address
          kind: Question
          title: "Where did this person live 1 year ago? Print address (number and street name):"
          precondition:
            - predicate: moved_diff_house == 1
          input:
            control: Textarea
            placeholder: "Address..."
            maxLength: 200

        - id: q_15b_city
          kind: Question
          title: "Name of city, town, or post office where this person lived 1 year ago:"
          precondition:
            - predicate: moved_diff_house == 1
          input:
            control: Textarea
            placeholder: "City or town..."
            maxLength: 100

        - id: q_15b_county
          kind: Question
          title: "Name of U.S. county or municipio in Puerto Rico where this person lived 1 year ago:"
          precondition:
            - predicate: moved_diff_house == 1
          input:
            control: Textarea
            placeholder: "County..."
            maxLength: 100

        - id: q_15b_state
          kind: Question
          title: "Name of U.S. state or Puerto Rico where this person lived 1 year ago:"
          precondition:
            - predicate: moved_diff_house == 1
          input:
            control: Textarea
            placeholder: "State..."
            maxLength: 100

        - id: q_15b_zip
          kind: Question
          title: "ZIP Code where this person lived 1 year ago:"
          precondition:
            - predicate: moved_diff_house == 1
          input:
            control: Editbox
            min: 0
            max: 99999

    # =========================================================================
    # PERSON 1 - Health Insurance (Page 13-14)
    # =========================================================================
    - id: b_person1_insurance
      title: "Person 1 - Health Insurance"
      items:
        - id: q_16_insurance
          kind: Question
          title: "Is this person CURRENTLY covered by any of the following types of health insurance or health coverage plans? Do NOT include plans that cover only one type of service, such as dental, drug, or vision plans. Mark all that apply."
          input:
            control: Checkbox
            labels:
              1: "Insurance through a current or former employer, union, or professional association"
              2: "Medicare"
              4: "Medicaid, Children's Health Insurance Program (CHIP), or government-assistance plan"
              8: "Insurance purchased directly from an insurance company, a broker, or a State or Federal Marketplace"
              16: "Veteran's health care (enrolled for VA)"
              32: "TRICARE or other military health care"
              64: "Indian Health Service"
              128: "Any other type of health insurance or health coverage plan"
              256: "No health insurance or health coverage plan"
          codeBlock: |
            if q_16_insurance.outcome % 256 >= 1:
                is_insured = 1

        - id: q_16_insurance_other
          kind: Question
          title: "Specify other type of health insurance or health coverage plan:"
          precondition:
            - predicate: q_16_insurance.outcome % 256 >= 128
          input:
            control: Textarea
            placeholder: "Specify..."
            maxLength: 200

    # =========================================================================
    # PERSON 1 - Insurance Premium (Page 14, conditional on insured)
    # =========================================================================
    - id: b_person1_premium
      title: "Person 1 - Insurance Premium"
      precondition:
        - predicate: is_insured == 1
      items:
        - id: q_17a_premium
          kind: Question
          title: "Is there a premium for this plan? A premium is a fixed amount of money paid on a regular basis for health coverage. It does not include copays, deductibles, or other expenses such as prescription costs."
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
          codeBlock: |
            if q_17a_premium.outcome == 1:
                has_premium = 1

        - id: q_17b_tax_credit
          kind: Question
          title: "Does this person or another family member receive a tax credit or subsidy based on family income to help pay the premium?"
          precondition:
            - predicate: has_premium == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # =========================================================================
    # PERSON 1 - Disability (Page 14)
    # =========================================================================
    - id: b_person1_disability
      title: "Person 1 - Disability"
      items:
        - id: q_18a_hearing
          kind: Question
          title: "Is this person deaf or does he/she have serious difficulty hearing?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q_18b_vision
          kind: Question
          title: "Is this person blind or does he/she have serious difficulty seeing even when wearing glasses?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # =========================================================================
    # PERSON 1 - Disability (Age 5+) (Page 14)
    # =========================================================================
    - id: b_person1_disability_5plus
      title: "Person 1 - Disability (Age 5+)"
      precondition:
        - predicate: is_age_5plus == 1
      items:
        - id: q_19a_cognitive
          kind: Question
          title: "Because of a physical, mental, or emotional condition, does this person have serious difficulty concentrating, remembering, or making decisions?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q_19b_ambulatory
          kind: Question
          title: "Does this person have serious difficulty walking or climbing stairs?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q_19c_self_care
          kind: Question
          title: "Does this person have difficulty dressing or bathing?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # =========================================================================
    # PERSON 1 - Independent Living Difficulty (Age 15+) (Page 14)
    # =========================================================================
    - id: b_person1_independent
      title: "Person 1 - Independent Living"
      precondition:
        - predicate: is_age_15plus == 1
      items:
        - id: q_20_independent
          kind: Question
          title: "Because of a physical, mental, or emotional condition, does this person have difficulty doing errands alone such as visiting a doctor's office or shopping?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # =========================================================================
    # PERSON 1 - Marital Status (Age 15+) (Page 14)
    # =========================================================================
    - id: b_person1_marital
      title: "Person 1 - Marital Status"
      precondition:
        - predicate: is_age_15plus == 1
      items:
        - id: q_21_marital_status
          kind: Question
          title: "What is this person's marital status?"
          input:
            control: Radio
            labels:
              1: "Now married"
              2: "Widowed"
              3: "Divorced"
              4: "Separated"
              5: "Never married"
          codeBlock: |
            if q_21_marital_status.outcome == 5:
                never_married = 1
            if q_21_marital_status.outcome in [1, 2, 3, 4]:
                marital_not_never = 1

        - id: q_22a_married_12mo
          kind: Question
          title: "In the PAST 12 MONTHS did this person get married?"
          precondition:
            - predicate: never_married == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q_22b_widowed_12mo
          kind: Question
          title: "In the PAST 12 MONTHS did this person get widowed?"
          precondition:
            - predicate: never_married == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q_22c_divorced_12mo
          kind: Question
          title: "In the PAST 12 MONTHS did this person get divorced?"
          precondition:
            - predicate: never_married == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q_23_times_married
          kind: Question
          title: "How many times has this person been married?"
          precondition:
            - predicate: never_married == 0
          input:
            control: Radio
            labels:
              1: "Once"
              2: "Two times"
              3: "Three or more times"

        - id: q_24_year_last_married
          kind: Question
          title: "In what year did this person last get married?"
          precondition:
            - predicate: never_married == 0
          input:
            control: Editbox
            min: 1930
            max: 2025

    # =========================================================================
    # PERSON 1 - Fertility (Female 15-50) (Page 15)
    # =========================================================================
    - id: b_person1_fertility
      title: "Person 1 - Fertility"
      precondition:
        - predicate: is_female_15_50 == 1
      items:
        - id: q_25_gave_birth
          kind: Question
          title: "In the PAST 12 MONTHS, has this person given birth to any children?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # =========================================================================
    # PERSON 1 - Grandparents (Page 15)
    # =========================================================================
    - id: b_person1_grandparents
      title: "Person 1 - Grandparents as Caregivers"
      items:
        - id: q_26a_grandchildren
          kind: Question
          title: "Does this person have any of his/her own grandchildren under the age of 18 living in this house or apartment?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
          codeBlock: |
            if q_26a_grandchildren.outcome == 1:
                has_grandchildren = 1

        - id: q_26b_responsible
          kind: Question
          title: "Is this grandparent currently responsible for most of the basic needs of any grandchildren under the age of 18 who live in this house or apartment?"
          precondition:
            - predicate: has_grandchildren == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
          codeBlock: |
            if q_26b_responsible.outcome == 1:
                is_grandparent_responsible = 1

        - id: q_26c_how_long
          kind: Question
          title: "How long has this grandparent been responsible for these grandchildren?"
          precondition:
            - predicate: is_grandparent_responsible == 1
          input:
            control: Radio
            labels:
              1: "Less than 6 months"
              2: "6 to 11 months"
              3: "1 or 2 years"
              4: "3 or 4 years"
              5: "5 or more years"

    # =========================================================================
    # PERSON 1 - Military Service (Page 15)
    # =========================================================================
    - id: b_person1_military
      title: "Person 1 - Military Service"
      items:
        - id: q_27_military
          kind: Question
          title: "Has this person ever served on active duty in the U.S. Armed Forces, Reserves, or National Guard?"
          input:
            control: Radio
            labels:
              1: "Never served in the military"
              2: "Only on active duty for training in the Reserves or National Guard"
              3: "Now on active duty"
              4: "On active duty in the past, but not now"
          codeBlock: |
            if q_27_military.outcome in [2, 3, 4]:
                ever_served_military = 1
            if q_27_military.outcome in [3, 4]:
                served_active_duty = 1

        - id: q_28_service_period
          kind: Question
          title: "When did this person serve on active duty in the U.S. Armed Forces? Mark a box for EACH period in which this person served, even if just for part of the period."
          precondition:
            - predicate: served_active_duty == 1
          input:
            control: Checkbox
            labels:
              1: "September 2001 or later (Post 9/11)"
              2: "August 1990 through August 2001 (including the Persian Gulf War)"
              4: "June 1975 through July 1990"
              8: "August 1964 through May 1975 (including the Vietnam War)"
              16: "February 1955 through July 1964"
              32: "June 1950 through January 1955 (including the Korean War)"
              64: "January 1947 through May 1950"
              128: "December 1941 through December 1946 (including World War II)"
              256: "November 1941 or earlier"

        - id: q_29a_va_rating
          kind: Question
          title: "Does this person have a VA service-connected disability rating?"
          precondition:
            - predicate: ever_served_military == 1
          input:
            control: Radio
            labels:
              1: "Yes (such as 0%, 10%, 20%, ..., 100%)"
              2: "No"
          codeBlock: |
            if q_29a_va_rating.outcome == 1:
                has_va_rating = 1

        - id: q_29b_va_rating_pct
          kind: Question
          title: "What is this person's service-connected disability rating?"
          precondition:
            - predicate: has_va_rating == 1
          input:
            control: Radio
            labels:
              1: "0 percent"
              2: "10 or 20 percent"
              3: "30 or 40 percent"
              4: "50 or 60 percent"
              5: "70 percent or higher"

    # =========================================================================
    # PERSON 1 - Employment (Page 16)
    # =========================================================================
    - id: b_person1_employment
      title: "Person 1 - Employment"
      items:
        - id: q_30a_worked_last_week
          kind: Question
          title: "LAST WEEK, did this person work for pay at a job (or business)?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No - Did not work (or retired)"
          codeBlock: |
            if q_30a_worked_last_week.outcome == 1:
                worked_last_week = 1
                worked_any = 1
            if q_30a_worked_last_week.outcome == 2:
                did_not_work = 1

        - id: q_30b_any_work
          kind: Question
          title: "LAST WEEK, did this person do ANY work for pay, even for as little as one hour?"
          precondition:
            - predicate: did_not_work == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
          codeBlock: |
            if q_30b_any_work.outcome == 1:
                worked_any = 1

    # =========================================================================
    # PERSON 1 - Work Location and Commute (Page 16, conditional on worked)
    # =========================================================================
    - id: b_person1_work_location
      title: "Person 1 - Work Location"
      precondition:
        - predicate: worked_any == 1
      items:
        - id: q_31a_work_address
          kind: Question
          title: "At what location did this person work LAST WEEK? If this person worked at more than one location, print where he or she worked most last week. Address (Number and street name):"
          input:
            control: Textarea
            placeholder: "Address..."
            maxLength: 200

        - id: q_31b_work_city
          kind: Question
          title: "Name of city, town, or post office of work location:"
          input:
            control: Textarea
            placeholder: "City or town..."
            maxLength: 100

        - id: q_31c_city_limits
          kind: Question
          title: "Is the work location inside the limits of that city or town?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No, outside the city/town limits"

        - id: q_31d_work_county
          kind: Question
          title: "Name of county of work location:"
          input:
            control: Textarea
            placeholder: "County..."
            maxLength: 100

        - id: q_31e_work_state
          kind: Question
          title: "Name of U.S. state or foreign country of work location:"
          input:
            control: Textarea
            placeholder: "State or country..."
            maxLength: 100

        - id: q_31f_work_zip
          kind: Question
          title: "ZIP Code of work location:"
          input:
            control: Editbox
            min: 0
            max: 99999

        - id: q_32_transportation
          kind: Question
          title: "How did this person usually get to work LAST WEEK? Mark ONE box for the method of transportation used for most of the distance."
          input:
            control: Dropdown
            labels:
              1: "Car, truck, or van"
              2: "Bus"
              3: "Subway or elevated rail"
              4: "Long-distance train or commuter rail"
              5: "Light rail, streetcar, or trolley"
              6: "Ferryboat"
              7: "Taxi or ride-hailing services"
              8: "Motorcycle"
              9: "Bicycle"
              10: "Walked"
              11: "Worked from home"
              12: "Other method"
          codeBlock: |
            if q_32_transportation.outcome == 1:
                drove_car = 1

        - id: q_33_carpool
          kind: Question
          title: "How many people, including this person, usually rode to work in the car, truck, or van LAST WEEK?"
          precondition:
            - predicate: drove_car == 1
          input:
            control: Editbox
            min: 1
            max: 20
            right: "person(s)"

        - id: q_34_depart_hour
          kind: Question
          title: "LAST WEEK, what time did this person's trip to work usually begin? Hour:"
          precondition:
            - predicate: q_32_transportation.outcome != 11
          input:
            control: Editbox
            min: 1
            max: 12

        - id: q_34_depart_minute
          kind: Question
          title: "LAST WEEK, what time did this person's trip to work usually begin? Minute:"
          precondition:
            - predicate: q_32_transportation.outcome != 11
          input:
            control: Editbox
            min: 0
            max: 59

        - id: q_34_depart_ampm
          kind: Question
          title: "LAST WEEK, was the departure time a.m. or p.m.?"
          precondition:
            - predicate: q_32_transportation.outcome != 11
          input:
            control: Radio
            labels:
              1: "a.m."
              2: "p.m."

        - id: q_35_commute_minutes
          kind: Question
          title: "How many minutes did it usually take this person to get from home to work LAST WEEK?"
          precondition:
            - predicate: q_32_transportation.outcome != 11
          input:
            control: Editbox
            min: 0
            max: 200
            right: "minutes"

    # =========================================================================
    # PERSON 1 - Not Working Last Week (Page 16-17)
    # =========================================================================
    - id: b_person1_not_working
      title: "Person 1 - Not Working Last Week"
      precondition:
        - predicate: did_not_work == 1
        - predicate: q_30b_any_work.outcome == 2
      items:
        - id: q_36a_on_layoff
          kind: Question
          title: "LAST WEEK, was this person on layoff from a job?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
          codeBlock: |
            if q_36a_on_layoff.outcome == 1:
                on_layoff = 1

        - id: q_36b_temp_absent
          kind: Question
          title: "LAST WEEK, was this person TEMPORARILY absent from a job or business?"
          precondition:
            - predicate: on_layoff == 0
          input:
            control: Radio
            labels:
              1: "Yes, on vacation, temporary illness, maternity leave, other family/personal reasons, bad weather, etc."
              2: "No"
          codeBlock: |
            if q_36b_temp_absent.outcome == 1:
                temp_absent = 1

        - id: q_36c_recalled
          kind: Question
          title: "Has this person been informed that he or she will be recalled to work within the next 6 months OR been given a date to return to work?"
          precondition:
            - predicate: on_layoff == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
          codeBlock: |
            if q_36c_recalled.outcome == 1:
                was_recalled = 1

        - id: q_37_looking_for_work
          kind: Question
          title: "During the LAST 4 WEEKS, has this person been ACTIVELY looking for work?"
          precondition:
            - predicate: (on_layoff == 0 and temp_absent == 0) or (on_layoff == 1 and was_recalled == 0)
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
          codeBlock: |
            if q_37_looking_for_work.outcome == 1:
                looked_for_work = 1

        - id: q_38_could_start
          kind: Question
          title: "LAST WEEK, could this person have started a job if offered one, or returned to work if recalled?"
          precondition:
            - predicate: looked_for_work == 1 or was_recalled == 1
          input:
            control: Radio
            labels:
              1: "Yes, could have gone to work"
              2: "No, because of own temporary illness"
              3: "No, because of all other reasons (in school, etc.)"

        - id: q_39_when_last_worked
          kind: Question
          title: "When did this person last work for pay, even for a few days?"
          input:
            control: Radio
            labels:
              1: "Within the past 12 months"
              2: "1 to 5 years ago"
              3: "Over 5 years ago or never worked"
          codeBlock: |
            if q_39_when_last_worked.outcome in [1, 2]:
                last_worked_recent = 1
            if q_39_when_last_worked.outcome in [1, 2]:
                worked_past_5yrs = 1

    # =========================================================================
    # PERSON 1 - Weeks and Hours Worked (Page 17)
    # =========================================================================
    - id: b_person1_work_hours
      title: "Person 1 - Weeks and Hours Worked"
      precondition:
        - predicate: worked_any == 1 or last_worked_recent == 1
      items:
        - id: q_40a_worked_every_week
          kind: Question
          title: "During the PAST 12 MONTHS (52 weeks), did this person work EVERY week? Count paid vacation, paid sick leave, and military service as work. Include all jobs for pay."
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
          codeBlock: |
            if q_40a_worked_every_week.outcome == 1:
                worked_every_week = 1

        - id: q_40b_weeks_worked
          kind: Question
          title: "During the PAST 12 MONTHS (52 weeks), how many WEEKS did this person work for at least one day? Include weeks when this person only worked for a few hours."
          precondition:
            - predicate: worked_every_week == 0
          input:
            control: Editbox
            min: 0
            max: 51
            right: "weeks"

        - id: q_41_hours_per_week
          kind: Question
          title: "During the PAST 12 MONTHS, for the weeks worked, how many HOURS did this person usually work each WEEK? Include all jobs for pay and military service."
          input:
            control: Editbox
            min: 0
            max: 120
            right: "hours per week"

    # =========================================================================
    # PERSON 1 - Description of Employment (Page 17, conditional)
    # =========================================================================
    - id: b_person1_job_description
      title: "Person 1 - Description of Employment"
      precondition:
        - predicate: worked_any == 1 or worked_past_5yrs == 1
      items:
        - id: q_42_desc_intro
          kind: Comment
          title: "The next series of questions is about the type of employment this person had last week. If this person had more than one job, describe the one at which the most hours were worked. If this person did not work last week, describe the most recent employment in the past five years."

        - id: q_42a_class_of_worker
          kind: Question
          title: "Which one of the following best describes this person's employment last week or the most recent employment in the past 5 years?"
          input:
            control: Dropdown
            labels:
              1: "For-profit company or organization"
              2: "Non-profit organization (including tax-exempt and charitable organizations)"
              3: "Local government (for example: city or county school district)"
              4: "State government (including state colleges/universities)"
              5: "Active duty U.S. Armed Forces or Commissioned Corps"
              6: "Federal government civilian employee"
              7: "Owner of non-incorporated business, professional practice, or farm"
              8: "Owner of incorporated business, professional practice, or farm"
              9: "Worked without pay in a for-profit family business or farm for 15 hours or more per week"

        - id: q_42b_employer_name
          kind: Question
          title: "What was the name of this person's employer, business, agency, or branch of the Armed Forces?"
          input:
            control: Textarea
            placeholder: "Employer name..."
            maxLength: 200

        - id: q_42c_industry
          kind: Question
          title: "What kind of business or industry was this? Include the main activity, product, or service provided at the location where employed. (For example: elementary school, residential construction)"
          input:
            control: Textarea
            placeholder: "Business or industry..."
            maxLength: 200

        - id: q_42d_industry_type
          kind: Question
          title: "Was this mainly manufacturing, wholesale trade, retail trade, or other?"
          input:
            control: Radio
            labels:
              1: "Manufacturing"
              2: "Wholesale trade"
              3: "Retail trade"
              4: "Other (agriculture, construction, service, government, etc.)"

        - id: q_42e_occupation
          kind: Question
          title: "What was this person's main occupation? (For example: 4th grade teacher, entry-level plumber)"
          input:
            control: Textarea
            placeholder: "Occupation..."
            maxLength: 200

        - id: q_42f_duties
          kind: Question
          title: "Describe this person's most important activities or duties. (For example: instruct and evaluate students and create lesson plans, assemble and install pipe sections and review building plans for work details)"
          input:
            control: Textarea
            placeholder: "Activities or duties..."
            maxLength: 300

    # =========================================================================
    # PERSON 1 - Income (Page 18)
    # =========================================================================
    - id: b_person1_income
      title: "Person 1 - Income in the Past 12 Months"
      items:
        - id: q_43_income_intro
          kind: Comment
          title: "INCOME IN THE PAST 12 MONTHS. Mark the 'Yes' box for each type of income this person received, and give your best estimate of the TOTAL AMOUNT during the PAST 12 MONTHS. Mark the 'No' box to show types of income NOT received."

        - id: q_43a_wages_yn
          kind: Question
          title: "Wages, salary, commissions, bonuses, or tips from all jobs. Report amount before deductions for taxes, bonds, dues, or other items."
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q_43a_wages_amount
          kind: Question
          title: "Total wages, salary, commissions, bonuses, or tips amount for past 12 months:"
          precondition:
            - predicate: q_43a_wages_yn.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 9999999
            left: "$"

        - id: q_43b_self_employment_yn
          kind: Question
          title: "Self-employment income from own nonfarm businesses or farm businesses, including proprietorships and partnerships. Report NET income after business expenses."
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q_43b_self_employment_amount
          kind: Question
          title: "Total self-employment income amount for past 12 months (net income; mark Loss if applicable):"
          precondition:
            - predicate: q_43b_self_employment_yn.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 9999999
            left: "$"

        - id: q_43b_self_employment_loss
          kind: Question
          title: "Was the self-employment income a loss?"
          precondition:
            - predicate: q_43b_self_employment_yn.outcome == 1
          input:
            control: Switch
            on: "Yes (Loss)"
            off: "No"

        - id: q_43c_interest_yn
          kind: Question
          title: "Interest, dividends, net rental income, royalty income, or income from estates and trusts. Report even small amounts credited to an account."
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q_43c_interest_amount
          kind: Question
          title: "Total interest, dividends, rental income amount for past 12 months:"
          precondition:
            - predicate: q_43c_interest_yn.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 9999999
            left: "$"

        - id: q_43c_interest_loss
          kind: Question
          title: "Was the interest/dividend/rental income a loss?"
          precondition:
            - predicate: q_43c_interest_yn.outcome == 1
          input:
            control: Switch
            on: "Yes (Loss)"
            off: "No"

        - id: q_43d_ss_yn
          kind: Question
          title: "Social Security or Railroad Retirement."
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q_43d_ss_amount
          kind: Question
          title: "Total Social Security or Railroad Retirement amount for past 12 months:"
          precondition:
            - predicate: q_43d_ss_yn.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 999999
            left: "$"

        - id: q_43e_ssi_yn
          kind: Question
          title: "Supplemental Security Income (SSI)."
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q_43e_ssi_amount
          kind: Question
          title: "Total Supplemental Security Income (SSI) amount for past 12 months:"
          precondition:
            - predicate: q_43e_ssi_yn.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 999999
            left: "$"

        - id: q_43f_welfare_yn
          kind: Question
          title: "Any public assistance or welfare payments from the state or local welfare office."
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q_43f_welfare_amount
          kind: Question
          title: "Total public assistance or welfare amount for past 12 months:"
          precondition:
            - predicate: q_43f_welfare_yn.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 999999
            left: "$"

        - id: q_43g_retirement_yn
          kind: Question
          title: "Retirement income, pensions, survivor or disability income. Include income from a previous employer or union, or any regular withdrawals or distributions from IRA, Roth IRA, 401(k), 403(b), or other accounts specifically designed for retirement. Do not include Social Security."
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q_43g_retirement_amount
          kind: Question
          title: "Total retirement income, pensions, survivor or disability income amount for past 12 months:"
          precondition:
            - predicate: q_43g_retirement_yn.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 9999999
            left: "$"

        - id: q_43h_other_income_yn
          kind: Question
          title: "Any other sources of income received regularly such as Veterans' (VA) payments, unemployment compensation, child support or alimony. Do NOT include lump sum payments such as money from an inheritance or the sale of a home."
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q_43h_other_income_amount
          kind: Question
          title: "Total other income amount for past 12 months:"
          precondition:
            - predicate: q_43h_other_income_yn.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 9999999
            left: "$"

        - id: q_44_total_income
          kind: Question
          title: "What was this person's total income during the PAST 12 MONTHS? Add entries in questions 43a to 43h; subtract any losses. If net income was a loss, enter the amount and mark Loss."
          input:
            control: Radio
            labels:
              1: "Enter total dollar amount"
              2: "None"

        - id: q_44_total_income_amount
          kind: Question
          title: "Total income for past 12 months (in dollars):"
          precondition:
            - predicate: q_44_total_income.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 9999999
            left: "$"

        - id: q_44_total_income_loss
          kind: Question
          title: "Was the total income a loss?"
          precondition:
            - predicate: q_44_total_income.outcome == 1
          input:
            control: Switch
            on: "Yes (Loss)"
            off: "No"
