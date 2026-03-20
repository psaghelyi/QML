qmlVersion: "1.0"
questionnaire:
  title: "Survey of Household Spending in 2000"
  codeInit: |
    # Household composition tracking
    household_size = 1
    has_spouse = 0
    # Tenure routing
    tenure_type = 0
    owns_dwelling = 0
    rents_dwelling = 0
    moved_in_2000 = 0
    moved_year = 0
    # Section E routing
    num_owned_dwellings = 0
    # Section I routing
    months_rented = 0
    # Section K routing
    owns_vacation_home = 0
    owns_other_property = 0
    # Section Q routing
    has_vehicle = 0
    # Section R routing
    has_rec_vehicle = 0
    has_package_trip = 0
    # Section T routing
    has_direct_sales = 0
    # Section X routing
    has_business = 0
    # Section Y routing
    has_regular_loans = 0
    # Section C routing
    has_telephones = 0
    has_computer = 0
    has_modem = 0
    # Section D routing
    anyone_total_weeks_52 = 0
    anyone_lived_other_dwelling = 0
    prev_owned_with_mortgage = 0
    prev_owned_without_mortgage = 0
    # Section E routing
    expenses_charged_business = 0
    expenses_charged_rooms = 0
    # Section F routing
    purchased_home = 0
    sold_home = 0
    # Section G routing
    has_mortgage = 0
    mortgage_added = 0
    mortgage_includes_taxes = 0
    mortgage_includes_insurance = 0
    # Section I routing
    rent_charged_business = 0
    rent_charged_rooms = 0
    # Section K routing
    vacation_purchased = 0
    vacation_sold = 0
    other_prop_purchased = 0
    other_prop_sold = 0

  blocks:
    # =========================================================================
    # SECTION A: Household Composition (pp. 2-5)
    # =========================================================================
    - id: b_household_composition
      title: "Section A: Household Composition"
      items:
        - id: a_intro
          kind: Comment
          title: "What are the first names of all members of your household? Include everyone who currently lives here and anyone who was part of your household at any time during 2000. List the household reference person first."

        - id: a_q1_household_size
          kind: Question
          title: "How many persons are in this household (including the reference person)?"
          codeBlock: |
            household_size = a_q1_household_size.outcome
          input:
            control: Editbox
            min: 1
            max: 10

        - id: a_q2_relationship
          kind: Question
          title: "What is person 2's relationship to the household reference person?"
          precondition:
            - predicate: household_size >= 2
          codeBlock: |
            if a_q2_relationship.outcome == 2:
                has_spouse = 1
          input:
            control: Radio
            labels:
              1: "Reference Person"
              2: "Spouse"
              3: "Son/Daughter"
              4: "Other relative"
              5: "Not related"

        - id: a_q3_birth_year
          kind: Question
          title: "In what year was the reference person born? (If born in 1900 or earlier, enter 1900)"
          input:
            control: Editbox
            min: 1900
            max: 2001

        - id: a_q4_sex
          kind: Question
          title: "Is the reference person male or female?"
          input:
            control: Radio
            labels:
              1: "Male"
              2: "Female"

        - id: a_q5_marital_status
          kind: Question
          title: "What was the reference person's marital status on December 31, 2000?"
          input:
            control: Radio
            labels:
              1: "Married spouse of a household member"
              2: "Common-law spouse of a household member"
              3: "Never married (single)"
              4: "Other (separated, divorced or widowed)"

        - id: a_q7_member_dec31
          kind: Question
          title: "Was the reference person a member of this household on December 31, 2000?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: a_q8_member_today
          kind: Question
          title: "Is the reference person a member of this household today?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: a_q9_weeks_member
          kind: Question
          title: "For how many weeks in 2000 was the reference person a member of this household?"
          input:
            control: Editbox
            min: 0
            max: 52

        - id: a_q10_weeks_apart
          kind: Question
          title: "For how many weeks in 2000 did the reference person live apart from this household?"
          precondition:
            - predicate: household_size > 1 and a_q9_weeks_member.outcome < 52
          input:
            control: Editbox
            min: 0
            max: 52

        - id: a_q11_reason_less_52
          kind: Question
          title: "Why is total weeks (Q.9 plus Q.10) less than 52?"
          precondition:
            - predicate: a_q9_weeks_member.outcome < 52 and (household_size == 1 or (household_size > 1 and a_q9_weeks_member.outcome + a_q10_weeks_apart.outcome < 52))
          input:
            control: Radio
            labels:
              1: "Child born in 2000 or 2001"
              2: "Immigrated in 2000 or 2001"
              3: "Belonged to a household in existence elsewhere"
              4: "Other"

        - id: a_q12_data_procedure
          kind: Question
          title: "Data collection procedure code (determined from Q.8, Q.9 and Q.10)"
          input:
            control: Radio
            labels:
              1: "Report data for total weeks (Q.9 plus Q.10) - Q.8=Yes and Q.9 is not 00"
              2: "Report data only for weeks a member (Q.9) - Q.8=No and Q.9 is not 00"
              3: "Report data only for weeks apart (Q.10) - Q.8=Yes, Q.9=00 and Q.10 is not 00"
              4: "End questions - became member after 2000 - Q.8=Yes, Q.9=00, Q.10=00"
              5: "End questions - not a household member - Q.8=No, Q.9=00, Q.10=00"

    # =========================================================================
    # SECTION B: Dwelling Characteristics (pp. 6-8)
    # =========================================================================
    - id: b_dwelling
      title: "Section B: Dwelling Characteristics"
      items:
        - id: b_intro
          kind: Comment
          title: "Report answers for the dwelling that your household occupied on December 31, 2000."

        - id: b_q1_dwelling_type
          kind: Question
          title: "What type of dwelling did your household live in on December 31, 2000?"
          input:
            control: Radio
            labels:
              1: "Single detached"
              2: "Double"
              3: "Row or terrace"
              4: "Duplex"
              5: "Apartment in a building that has less than five storeys"
              6: "Apartment in a building that has five or more storeys"
              7: "Hotel, rooming or lodging house, camp"
              8: "Mobile home"
              9: "Other"

        - id: b_q2_year_built
          kind: Question
          title: "When was this dwelling originally built?"
          input:
            control: Radio
            labels:
              10: "1920 or before"
              11: "1921-1945"
              12: "1946-1960"
              13: "1961-1970"
              14: "1971-1980"
              15: "1981-1990"
              16: "1991-1999"
              17: "2000"

        - id: b_q3_repairs_needed
          kind: Question
          title: "Was this dwelling in need of any repairs on December 31, 2000? (Exclude remodelling and energy improvements.)"
          input:
            control: Radio
            labels:
              18: "Yes, major repairs were needed"
              19: "Yes, minor repairs were needed"
              20: "No, only regular maintenance was needed"

        - id: b_q4_rooms
          kind: Question
          title: "How many rooms were there in this dwelling? (Include kitchen, bedrooms, finished rooms in attic/basement. Exclude bathrooms, halls, vestibules, business rooms.)"
          input:
            control: Editbox
            min: 1
            max: 20

        - id: b_q5_bedrooms
          kind: Question
          title: "How many bedrooms were there in this dwelling? (If a bachelor apartment, enter 0)"
          input:
            control: Editbox
            min: 0
            max: 15

        - id: b_q6_bathrooms
          kind: Question
          title: "How many bathrooms with a bathtub or shower were there in this dwelling?"
          input:
            control: Editbox
            min: 0
            max: 10

        - id: b_q7_heating_equipment
          kind: Question
          title: "What was the principal heating equipment for this dwelling?"
          input:
            control: Radio
            labels:
              1: "Steam or hot water furnace"
              2: "Forced hot air furnace"
              3: "Other hot air furnace"
              4: "Heating stove (include wood stove)"
              5: "Electric heating (include electric baseboard heaters)"
              6: "Cookstove"
              7: "Other"

        - id: b_q8_heating_age
          kind: Question
          title: "How old was this heating equipment?"
          input:
            control: Radio
            labels:
              8: "5 years or less (1995-2000)"
              9: "6 to 10 years (1990-1994)"
              10: "11 to 15 years (1985-1989)"
              11: "16 to 20 years (1980-1984)"
              12: "Over 20 years (Before 1980)"

        - id: b_q9_heating_fuel
          kind: Question
          title: "What was the principal fuel for this heating equipment?"
          input:
            control: Radio
            labels:
              13: "Oil or other liquid fuel"
              14: "Piped gas (natural gas)"
              15: "Bottled gas (propane)"
              16: "Electricity"
              17: "Wood"
              18: "Other"

        - id: b_q10_hot_water_fuel
          kind: Question
          title: "What was the principal fuel for the hot water supply?"
          input:
            control: Radio
            labels:
              19: "Oil or other liquid fuel"
              20: "Piped gas (natural gas)"
              21: "Bottled gas (propane)"
              22: "Electricity"
              23: "Wood"
              24: "Other"
              25: "No running hot water"

        - id: b_q11_cooking_fuel
          kind: Question
          title: "What was the main fuel used for cooking?"
          input:
            control: Radio
            labels:
              26: "Oil or other liquid fuel"
              27: "Piped gas (natural gas)"
              28: "Bottled gas (propane)"
              29: "Electricity"
              30: "Wood"
              31: "Other"

    # =========================================================================
    # SECTION C: Facilities Associated with the Dwelling (pp. 9-10)
    # =========================================================================
    - id: b_facilities
      title: "Section C: Facilities Associated with the Dwelling"
      items:
        - id: c_intro
          kind: Comment
          title: "Include items regardless of ownership, as long as they were in the dwelling your household occupied on December 31, 2000."

        - id: c_q1_refrigerators
          kind: Question
          title: "How many refrigerators did you have? (If none, enter 0; if 10 or more, enter 9)"
          input:
            control: Editbox
            min: 0
            max: 9

        - id: c_q2_colour_tvs
          kind: Question
          title: "How many colour TV sets did you have?"
          input:
            control: Editbox
            min: 0
            max: 9

        - id: c_q3_vcrs
          kind: Question
          title: "How many VCRs did you have?"
          input:
            control: Editbox
            min: 0
            max: 9

        - id: c_q4_telephones
          kind: Question
          title: "How many telephones did you have? (Include phones used for business. Exclude cellular phones.)"
          codeBlock: |
            has_telephones = c_q4_telephones.outcome
          input:
            control: Editbox
            min: 0
            max: 9

        - id: c_q5_phone_numbers
          kind: Question
          title: "How many telephone numbers for this dwelling? (Include phone numbers used for business. Exclude cellular phone numbers.)"
          precondition:
            - predicate: has_telephones > 0
          input:
            control: Editbox
            min: 0
            max: 9

        - id: c_q6_cellular
          kind: Question
          title: "Did you have a cellular phone for personal use? (Exclude cordless phones.)"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: c_q7_microwave
          kind: Question
          title: "Did you have a microwave oven?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: c_q8_freezer
          kind: Question
          title: "Did you have a freezer separate from the refrigerator?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: c_q9_cable_tv
          kind: Question
          title: "Did you have cable TV?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: c_q10_cd_player
          kind: Question
          title: "Did you have a CD player?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: c_q11_computer
          kind: Question
          title: "Did you have a home computer? (Exclude computers used exclusively for business.)"
          codeBlock: |
            has_computer = c_q11_computer.outcome
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: c_q12_modem
          kind: Question
          title: "Did you have a modem?"
          precondition:
            - predicate: has_computer == 1
          codeBlock: |
            has_modem = c_q12_modem.outcome
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: c_q13_internet
          kind: Question
          title: "Did you use the Internet from home?"
          precondition:
            - predicate: has_computer == 1 and has_modem == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: c_q14_air_conditioning
          kind: Question
          title: "Did you have air conditioning?"
          input:
            control: Radio
            labels:
              1: "Window-type air conditioning units"
              2: "Central air conditioning"
              3: "None"

        - id: c_q15_dishwasher
          kind: Question
          title: "Did you have a dishwasher?"
          input:
            control: Radio
            labels:
              4: "A built-in automatic dishwasher"
              5: "A portable automatic dishwasher"
              6: "None"

        - id: c_q16_washing_machine
          kind: Question
          title: "Did you have (inside your dwelling) a washing machine?"
          input:
            control: Radio
            labels:
              7: "An automatic washing machine"
              8: "Any other kind of washing machine"
              9: "None"

        - id: c_q17_dryer
          kind: Question
          title: "Did you have (inside your dwelling) a clothes dryer?"
          input:
            control: Radio
            labels:
              1: "An electric clothes dryer"
              2: "A gas clothes dryer"
              3: "None"

    # =========================================================================
    # SECTION D: Tenure (pp. 11-12)
    # =========================================================================
    - id: b_tenure
      title: "Section D: Tenure"
      items:
        - id: d_q1_tenure
          kind: Question
          title: "On December 31, 2000 was your dwelling:"
          codeBlock: |
            tenure_type = d_q1_tenure.outcome
            if d_q1_tenure.outcome == 1 or d_q1_tenure.outcome == 2:
                owns_dwelling = 1
            if d_q1_tenure.outcome == 3 or d_q1_tenure.outcome == 4:
                rents_dwelling = 1
          input:
            control: Radio
            labels:
              1: "Owned without a mortgage by your household"
              2: "Owned with (a) mortgage(s) by your household"
              3: "Rented by your household"
              4: "Occupied rent-free by your household"

        - id: d_q2_move_year
          kind: Question
          title: "In what year did your household move to this dwelling?"
          codeBlock: |
            moved_year = d_q2_move_year.outcome
            if d_q2_move_year.outcome == 2000:
                moved_in_2000 = 1
          input:
            control: Editbox
            min: 1900
            max: 2001

        - id: d_q3_prev_tenure_ref
          kind: Question
          title: "Did the reference person own or rent their previous dwelling?"
          precondition:
            - predicate: moved_year >= 1995
          input:
            control: Radio
            labels:
              1: "Owned"
              2: "Rented"
              3: "Did not maintain their own dwelling"

        - id: d_q4_prev_tenure_spouse
          kind: Question
          title: "Did the spouse of the reference person own or rent their previous dwelling?"
          precondition:
            - predicate: moved_year >= 1995 and has_spouse == 1
          input:
            control: Radio
            labels:
              4: "Owned"
              5: "Rented"
              6: "Did not maintain their own dwelling"

        - id: d_q5_total_weeks_52
          kind: Question
          title: "Did anyone in this household report TOTAL WEEKS equal to 52? (See Section A, Q.9 plus Q.10)"
          precondition:
            - predicate: moved_in_2000 == 1
          codeBlock: |
            anyone_total_weeks_52 = d_q5_total_weeks_52.outcome
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: d_q5_1_other_dwelling
          kind: Question
          title: "For the total weeks reported earlier (Section A, Q.9 plus Q.10), did anyone live in another dwelling?"
          precondition:
            - predicate: moved_in_2000 == 1 and anyone_total_weeks_52 == 0
          codeBlock: |
            anyone_lived_other_dwelling = d_q5_1_other_dwelling.outcome
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: d_q6_prev_dwellings
          kind: Comment
          title: "Dwellings Previously Occupied by Your Household in 2000"
          precondition:
            - predicate: moved_in_2000 == 1 and (anyone_total_weeks_52 == 1 or anyone_lived_other_dwelling == 1)

        - id: d_q6_1_prev_owned_mortgage
          kind: Question
          title: "Were any of the dwellings previously occupied in 2000 owned with (a) mortgage(s) by your household?"
          precondition:
            - predicate: moved_in_2000 == 1 and (anyone_total_weeks_52 == 1 or anyone_lived_other_dwelling == 1)
          codeBlock: |
            prev_owned_with_mortgage = d_q6_1_prev_owned_mortgage.outcome
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: d_q6_2_prev_owned_no_mortgage
          kind: Question
          title: "Were any of the dwellings previously occupied in 2000 owned without a mortgage by your household?"
          precondition:
            - predicate: moved_in_2000 == 1 and (anyone_total_weeks_52 == 1 or anyone_lived_other_dwelling == 1)
          codeBlock: |
            prev_owned_without_mortgage = d_q6_2_prev_owned_no_mortgage.outcome
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: d_q6_3_prev_rented
          kind: Question
          title: "Were any of the dwellings previously occupied in 2000 rented by your household?"
          precondition:
            - predicate: moved_in_2000 == 1 and (anyone_total_weeks_52 == 1 or anyone_lived_other_dwelling == 1)
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: d_q6_4_prev_rent_free
          kind: Question
          title: "Were any of the dwellings previously occupied in 2000 occupied rent-free by your household?"
          precondition:
            - predicate: moved_in_2000 == 1 and (anyone_total_weeks_52 == 1 or anyone_lived_other_dwelling == 1)
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: d_q7_prev_sold
          kind: QuestionGroup
          title: "Were any of the dwellings previously owned and occupied in 2000:"
          precondition:
            - predicate: moved_in_2000 == 1 and (anyone_total_weeks_52 == 1 or anyone_lived_other_dwelling == 1) and (prev_owned_with_mortgage == 1 or prev_owned_without_mortgage == 1)
          questions:
            - "Sold?"
            - "Rented to others?"
            - "Left vacant?"
            - "Other?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # =========================================================================
    # SECTION E: Owned Principal Residences (pp. 13-14)
    # =========================================================================
    - id: b_owned_principal
      title: "Section E: Owned Principal Residences"
      precondition:
        - predicate: owns_dwelling == 1
      items:
        - id: e_intro
          kind: Comment
          title: "Exclude vacation homes, secondary residences and dwellings owned but not occupied by any member of the household in 2000."

        - id: e_q1_num_owned
          kind: Question
          title: "How many dwellings did members of your household own and occupy in 2000? (If none, enter 0 and go to Section I)"
          codeBlock: |
            num_owned_dwellings = e_q1_num_owned.outcome
          input:
            control: Editbox
            min: 0
            max: 5

        - id: e_q2_months_owned
          kind: Question
          title: "For how many months in 2000 did your household own and occupy the dwelling(s)?"
          precondition:
            - predicate: num_owned_dwellings > 0
          input:
            control: Editbox
            min: 1
            max: 12

        - id: e_q3_expenses
          kind: QuestionGroup
          title: "For dwelling(s) owned and occupied in 2000, how much was the:"
          precondition:
            - predicate: num_owned_dwellings > 0
          questions:
            - "Total amount billed for property taxes in 2000?"
            - "Total premiums paid in 2000 for homeowners' insurance covering fire, theft and other perils?"
            - "Amount paid for condominium charges (include special levies)?"
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: e_q4_charged_business
          kind: Question
          title: "Were any of the expenses just mentioned (in Q.3) charged against income from businesses owned by household members? (Exclude rooms rented out.)"
          precondition:
            - predicate: num_owned_dwellings > 0
          codeBlock: |
            expenses_charged_business = e_q4_charged_business.outcome
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: e_q4_1_amount_business
          kind: Question
          title: "What amount or percentage of the total (Q.3.1 to Q.3.3) was charged against income from your businesses?"
          precondition:
            - predicate: num_owned_dwellings > 0 and expenses_charged_business == 1
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: e_q5_charged_rooms
          kind: Question
          title: "Were any of the expenses just mentioned (in Q.3) charged against income from rooms rented out?"
          precondition:
            - predicate: num_owned_dwellings > 0
          codeBlock: |
            expenses_charged_rooms = e_q5_charged_rooms.outcome
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: e_q5_1_rooms_household
          kind: Question
          title: "What amount or percentage charged against income from rooms rented to household member(s) excluding relatives?"
          precondition:
            - predicate: num_owned_dwellings > 0 and expenses_charged_rooms == 1
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: e_q5_2_rooms_non_members
          kind: Question
          title: "What amount or percentage charged against income from rooms rented to persons who were not members of your household?"
          precondition:
            - predicate: num_owned_dwellings > 0 and expenses_charged_rooms == 1
          input:
            control: Editbox
            min: 0
            max: 999999

    # =========================================================================
    # SECTION F: Purchase and Sale of Homes (p. 15)
    # =========================================================================
    - id: b_purchase_sale
      title: "Section F: Purchase and Sale of Homes"
      items:
        - id: f_q1_purchased_home
          kind: Question
          title: "Did your household purchase a home in 2000?"
          codeBlock: |
            purchased_home = f_q1_purchased_home.outcome
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: f_q1_1_first_time
          kind: Question
          title: "Was this purchase made by (a) person(s) who had never previously owned a dwelling which they occupied?"
          precondition:
            - predicate: purchased_home == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: f_q1_2_purchase_price
          kind: Question
          title: "What was the purchase price of your home? (Exclude adjustments to property taxes and fuel oil.)"
          precondition:
            - predicate: purchased_home == 1
          input:
            control: Editbox
            min: 0
            max: 9999999

        - id: f_q1_3_land_transfer
          kind: Question
          title: "How much was paid for land transfer taxes and land registration fees?"
          precondition:
            - predicate: purchased_home == 1
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: f_q2_sold_home
          kind: Question
          title: "Did your household sell a home in 2000?"
          codeBlock: |
            sold_home = f_q2_sold_home.outcome
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: f_q2_1_selling_price
          kind: Question
          title: "What was the selling price of your home?"
          precondition:
            - predicate: sold_home == 1
          input:
            control: Editbox
            min: 0
            max: 9999999

        - id: f_q2_2_real_estate_commission
          kind: Question
          title: "How much was paid for real estate commissions?"
          precondition:
            - predicate: sold_home == 1
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: f_q3_legal_charges
          kind: Question
          title: "In 2000, how much did your household spend on legal charges related to the dwelling(s), e.g., title searches and mortgage registration fees?"
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: f_q4_other_expenses
          kind: Question
          title: "Other expenses related to the dwelling(s), e.g., surveying, appraisals, renewal fees and early renewal or closing penalties associated with mortgage payments?"
          input:
            control: Editbox
            min: 0
            max: 999999

    # =========================================================================
    # SECTION G: Mortgages on Owned Principal Residences (p. 16)
    # =========================================================================
    - id: b_mortgages
      title: "Section G: Mortgages on Owned Principal Residences"
      precondition:
        - predicate: owns_dwelling == 1
      items:
        - id: g_q1_has_mortgage
          kind: Question
          title: "In 2000, did your household have any mortgages on dwellings which it owned and occupied? (Exclude all other loans.)"
          codeBlock: |
            has_mortgage = g_q1_has_mortgage.outcome
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: g_q2_payments
          kind: QuestionGroup
          title: "In 2000, what payments did your household make on its mortgages? (Exclude amounts pertaining to business.)"
          precondition:
            - predicate: has_mortgage == 1
          questions:
            - "Regular payments - 1st mortgage (amount)"
            - "Regular payments - 2nd mortgage (amount)"
            - "Regular payments - 3rd mortgage (amount)"
            - "Irregular and lump sum payments - 1st mortgage"
            - "Irregular and lump sum payments - 2nd mortgage"
            - "Irregular and lump sum payments - 3rd mortgage"
          input:
            control: Editbox
            min: 0
            max: 9999999

        - id: g_q3_1_includes_taxes
          kind: Question
          title: "Did the mortgage payments just reported (in Q.2) include property taxes?"
          precondition:
            - predicate: has_mortgage == 1
          codeBlock: |
            mortgage_includes_taxes = g_q3_1_includes_taxes.outcome
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: g_q3_2_includes_insurance
          kind: Question
          title: "Did the mortgage payments include mortgage life and/or disability insurance?"
          precondition:
            - predicate: has_mortgage == 1
          codeBlock: |
            mortgage_includes_insurance = g_q3_2_includes_insurance.outcome
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: g_q3_3_insurance_premium
          kind: Question
          title: "What was the total premium paid in 2000 for mortgage life and/or disability insurance?"
          precondition:
            - predicate: has_mortgage == 1 and mortgage_includes_insurance == 1
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: g_q4_amounts_added
          kind: Question
          title: "Were any amounts added to your mortgage(s) in 2000? (Include the amount borrowed if the mortgage started in 2000.)"
          precondition:
            - predicate: has_mortgage == 1
          codeBlock: |
            mortgage_added = g_q4_amounts_added.outcome
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: g_q4_1_amounts
          kind: Question
          title: "What amounts were added to your mortgage(s)?"
          precondition:
            - predicate: has_mortgage == 1 and mortgage_added == 1
          input:
            control: Editbox
            min: 0
            max: 9999999

    # =========================================================================
    # SECTION H: Renovations and Repairs of Owned Principal Residences (pp. 17-18)
    # =========================================================================
    - id: b_renovations
      title: "Section H: Renovations and Repairs of Owned Principal Residences"
      precondition:
        - predicate: owns_dwelling == 1
      items:
        - id: h_intro
          kind: Comment
          title: "Exclude expenses for vacation homes, secondary residences, rented principal residences and other properties. Exclude expenses charged against business and rental income."

        - id: h_q1_additions
          kind: Question
          title: "In 2000, how much did your household spend on additions, renovations and other alterations?"
          input:
            control: Editbox
            min: 0
            max: 9999999

        - id: h_q2_installations
          kind: QuestionGroup
          title: "In 2000, how much did your household spend on installations of built-in equipment, appliances and fixtures?"
          questions:
            - "Replacement installations (total cost)"
            - "New installations (total cost)"
          input:
            control: Editbox
            min: 0
            max: 9999999

        - id: h_q3_repairs
          kind: Question
          title: "In 2000, how much did your household spend on repairs and maintenance?"
          input:
            control: Editbox
            min: 0
            max: 9999999

    # =========================================================================
    # SECTION I: Rented Principal Residences (pp. 19-20)
    # =========================================================================
    - id: b_rented_principal
      title: "Section I: Rented Principal Residences"
      precondition:
        - predicate: rents_dwelling == 1
      items:
        - id: i_intro
          kind: Comment
          title: "Include principal residences occupied rent-free, i.e. where no member owned the dwelling and no rent was charged. Exclude rented vacation homes."

        - id: i_q1_months_rented
          kind: Question
          title: "For how many months in 2000 did your household occupy a rented dwelling? (If none, enter 0 and go to Section J)"
          codeBlock: |
            months_rented = i_q1_months_rented.outcome
          input:
            control: Editbox
            min: 0
            max: 12

        - id: i_q2_total_rent
          kind: Question
          title: "Enter total rent paid for all months in 2000."
          precondition:
            - predicate: months_rented > 0
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: i_q3_additional_payments
          kind: Question
          title: "In 2000, what additional amount was paid to the landlord that was not included in the rent payments just reported, e.g., security deposits?"
          precondition:
            - predicate: months_rented > 0
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: i_q4_rent_returned
          kind: Question
          title: "In 2000, how much of the rent which you paid was returned to your household for any reason, e.g., rent overpayment and return of damage deposit?"
          precondition:
            - predicate: months_rented > 0
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: i_q5_reduced_rent
          kind: Question
          title: "Did your household pay reduced rent in 2000 for any of the following reasons?"
          precondition:
            - predicate: months_rented > 0
          input:
            control: Radio
            labels:
              1: "Government subsidized housing"
              2: "Other reasons, e.g., services to landlord and company housing"
              3: "No reduced rent"

        - id: i_q6_spending
          kind: QuestionGroup
          title: "In 2000, how much did your household spend on:"
          precondition:
            - predicate: months_rented > 0
          questions:
            - "Additions, renovations, alterations, installations, replacements, repairs and maintenance for rented dwelling(s) occupied in 2000?"
            - "Tenants' insurance?"
            - "Parking at your place of residence?"
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: i_q7_charged_business
          kind: Question
          title: "In 2000, was any part of the rent expense charged against income from businesses owned by the household members? (Exclude rooms rented out.)"
          precondition:
            - predicate: months_rented > 0
          codeBlock: |
            rent_charged_business = i_q7_charged_business.outcome
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: i_q7_1_amount_business
          kind: Question
          title: "What amount or percentage of the rent expense was charged against income from your businesses?"
          precondition:
            - predicate: months_rented > 0 and rent_charged_business == 1
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: i_q8_charged_rooms
          kind: Question
          title: "In 2000, was any part of the rent expenses charged against income from rooms rented to others?"
          precondition:
            - predicate: months_rented > 0
          codeBlock: |
            rent_charged_rooms = i_q8_charged_rooms.outcome
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: i_q8_1_rooms_household
          kind: Question
          title: "What amount or percentage charged against income from rooms rented to household member(s) excluding relatives?"
          precondition:
            - predicate: months_rented > 0 and rent_charged_rooms == 1
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: i_q8_2_rooms_non_members
          kind: Question
          title: "What amount or percentage charged against income from rooms rented to persons who were not members of your household?"
          precondition:
            - predicate: months_rented > 0 and rent_charged_rooms == 1
          input:
            control: Editbox
            min: 0
            max: 999999

    # =========================================================================
    # SECTION J: Utilities and Other Rented Accommodation (pp. 21-22)
    # =========================================================================
    - id: b_utilities
      title: "Section J: Utilities and Other Rented Accommodation"
      items:
        - id: j_intro
          kind: Comment
          title: "Ask OWNERS and RENTERS these questions. Water, Fuel and Electricity for Principal Residences."

        - id: j_q1_utilities
          kind: QuestionGroup
          title: "In 2000, how much did your household spend on:"
          questions:
            - "Water and sewage charges (not included in property tax bill)?"
            - "Electricity?"
            - "Other fuel for heating and cooking, e.g., oil, gas, propane and wood?"
            - "Rental of heating equipment?"
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: j_q2_other_accommodation
          kind: QuestionGroup
          title: "In 2000, while away from home overnight or longer, how much did your household spend on:"
          questions:
            - "Hotels and motels?"
            - "Other accommodation?"
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: j_q2_3_in_province
          kind: Question
          title: "Of this amount (Q.2.1 plus Q.2.2), how much was spent in this province?"
          input:
            control: Editbox
            min: 0
            max: 999999

    # =========================================================================
    # SECTION K: Owned Secondary Residences and Other Property (pp. 23-25)
    # =========================================================================
    - id: b_secondary_property
      title: "Section K: Owned Secondary Residences and Other Property"
      items:
        - id: k_intro
          kind: Comment
          title: "Ask OWNERS and RENTERS these questions."

        - id: k_q1_owns_vacation
          kind: Question
          title: "In 2000, did any member of your household own a vacation home or other secondary residence? (Exclude mobile vacation homes.)"
          codeBlock: |
            owns_vacation_home = k_q1_owns_vacation.outcome
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: k_q2_purchased_vacation
          kind: Question
          title: "In 2000, did any member of your household purchase a vacation home or other secondary residence?"
          precondition:
            - predicate: owns_vacation_home == 1
          codeBlock: |
            vacation_purchased = k_q2_purchased_vacation.outcome
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: k_q2_1_purchase_price
          kind: Question
          title: "What was the purchase price?"
          precondition:
            - predicate: owns_vacation_home == 1 and vacation_purchased == 1
          input:
            control: Editbox
            min: 0
            max: 9999999

        - id: k_q3_borrowed
          kind: Question
          title: "How much money was borrowed in 2000 for expenses associated with the dwelling(s)?"
          precondition:
            - predicate: owns_vacation_home == 1
          input:
            control: Editbox
            min: 0
            max: 9999999

        - id: k_q4_mortgage_payments
          kind: Question
          title: "How much were the mortgage payments in 2000? (Exclude payments made at time of sale.)"
          precondition:
            - predicate: owns_vacation_home == 1
          input:
            control: Editbox
            min: 0
            max: 9999999

        - id: k_q5_sold
          kind: Question
          title: "Was (were) the dwelling(s) sold in 2000?"
          precondition:
            - predicate: owns_vacation_home == 1
          codeBlock: |
            vacation_sold = k_q5_sold.outcome
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: k_q5_1_selling_price
          kind: Question
          title: "What was the selling price?"
          precondition:
            - predicate: owns_vacation_home == 1 and vacation_sold == 1
          input:
            control: Editbox
            min: 0
            max: 9999999

        - id: k_q5_2_net_amount
          kind: Question
          title: "What was the net amount received from the sale?"
          precondition:
            - predicate: owns_vacation_home == 1 and vacation_sold == 1
          input:
            control: Editbox
            min: 0
            max: 9999999

        - id: k_q6_expenses
          kind: QuestionGroup
          title: "In 2000, how much did your household spend on:"
          precondition:
            - predicate: owns_vacation_home == 1
          questions:
            - "Additions, renovations and new installations?"
            - "Repairs, maintenance and replacements?"
            - "Property taxes and sewage charges?"
            - "Insurance?"
            - "Electricity, water and fuel?"
            - "Other expenses associated with the property?"
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: k_q7_other_property
          kind: Question
          title: "In 2000, did any member of your household own any other property? (Exclude principal and secondary residences, rental or other business property, and farm property.)"
          codeBlock: |
            owns_other_property = k_q7_other_property.outcome
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: k_q8_purchased_other
          kind: Question
          title: "In 2000, did any member of your household purchase any other property?"
          precondition:
            - predicate: owns_other_property == 1
          codeBlock: |
            other_prop_purchased = k_q8_purchased_other.outcome
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: k_q8_1_purchase_price
          kind: Question
          title: "What was the purchase price?"
          precondition:
            - predicate: owns_other_property == 1 and other_prop_purchased == 1
          input:
            control: Editbox
            min: 0
            max: 9999999

        - id: k_q9_borrowed
          kind: Question
          title: "How much money was borrowed in 2000 for expenses associated with the property (including purchase)?"
          precondition:
            - predicate: owns_other_property == 1
          input:
            control: Editbox
            min: 0
            max: 9999999

        - id: k_q10_mortgage_payments
          kind: Question
          title: "How much were the mortgage payments in 2000? (Exclude payments made at time of sale.)"
          precondition:
            - predicate: owns_other_property == 1
          input:
            control: Editbox
            min: 0
            max: 9999999

        - id: k_q11_additions
          kind: Question
          title: "How much did your household spend on additions or major alterations to the property in 2000?"
          precondition:
            - predicate: owns_other_property == 1
          input:
            control: Editbox
            min: 0
            max: 9999999

        - id: k_q12_other_expenses
          kind: Question
          title: "How much was spent in 2000 on other expenses associated with the property, e.g., property taxes, survey costs, appraisal fees and utilities?"
          precondition:
            - predicate: owns_other_property == 1
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: k_q13_sold
          kind: Question
          title: "Was any of the property sold in 2000?"
          precondition:
            - predicate: owns_other_property == 1
          codeBlock: |
            other_prop_sold = k_q13_sold.outcome
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: k_q13_1_selling_price
          kind: Question
          title: "What was the selling price?"
          precondition:
            - predicate: owns_other_property == 1 and other_prop_sold == 1
          input:
            control: Editbox
            min: 0
            max: 9999999

        - id: k_q13_2_net_amount
          kind: Question
          title: "What was the net amount received from the sale?"
          precondition:
            - predicate: owns_other_property == 1 and other_prop_sold == 1
          input:
            control: Editbox
            min: 0
            max: 9999999

    # =========================================================================
    # SECTION L: Household Furnishings and Equipment (pp. 26-31)
    # =========================================================================
    - id: b_furnishings
      title: "Section L: Household Furnishings and Equipment"
      items:
        - id: l_intro
          kind: Comment
          title: "Include purchases for use in vacation homes or in other accommodations. Include all sales taxes. Include gifts purchased for persons who were not members of your household. Exclude expenses charged against business income."

        - id: l_furnishings
          kind: QuestionGroup
          title: "In 2000, how much did your household spend on Household Furnishings, Art and Antiques:"
          questions:
            - "Furniture for indoor or outdoor use (include mattresses)?"
            - "Glass mirrors, and mirror and picture frames?"
            - "Lamps and lampshades (exclude light fixtures)?"
            - "Rugs, mats and underpadding (exclude wall-to-wall carpeting)?"
            - "Window coverings, household textiles, e.g., curtains, blinds, bedding, towels, tablecloths?"
            - "Works of art, carvings and vases?"
            - "Antiques, e.g., furniture and jewellery at least 100 years old?"
            - "Maintenance and repair of furniture, carpeting and household textiles?"
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: l_entertainment_equipment
          kind: QuestionGroup
          title: "Audio, Video and Other Home Entertainment Equipment (net purchase price, after trade-in allowance deducted):"
          questions:
            - "Audio combinations, components and radios?"
            - "Televisions, VCRs, camcorders and other television/video components?"
            - "Compact discs, pre-recorded audiotapes, videos and videodiscs?"
            - "Blank audio and video tapes?"
            - "Other home entertainment equipment, accessories and parts?"
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: l_computer_equipment
          kind: QuestionGroup
          title: "Computer Equipment:"
          questions:
            - "Computer hardware purchased new?"
            - "Computer hardware purchased used?"
            - "Amount received from sale of computer hardware equipment?"
            - "Computer software?"
            - "Computer supplies and other equipment?"
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: l_entertainment_services
          kind: QuestionGroup
          title: "Home Entertainment Services:"
          questions:
            - "Rental of videos and videodiscs?"
            - "Maintenance and repair of home entertainment equipment?"
            - "Rental of cablevision and satellite services in 2000 (include pay TV)?"
            - "Rental of home entertainment equipment, and other related services?"
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: l_major_appliances
          kind: QuestionGroup
          title: "Major Household Appliances (net purchase price, after trade-in allowance deducted):"
          questions:
            - "Refrigerators and freezers?"
            - "Cooking stoves and ranges?"
            - "Microwave and convection ovens?"
            - "Washers and dryers?"
            - "Vacuum cleaners and other rug cleaning equipment?"
            - "Sewing machines?"
            - "Portable dishwashers?"
            - "Gas barbecues?"
            - "Room air conditioners, portable humidifiers and dehumidifiers?"
            - "Attachments and parts purchased separately for major household appliances?"
            - "Maintenance and repair of major household appliances?"
            - "Amount received from sale of any major household appliances?"
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: l_small_electrical
          kind: QuestionGroup
          title: "Small Electrical Appliances:"
          questions:
            - "Electric food preparation appliances?"
            - "Electric hairstyling and personal care appliances?"
            - "All other electric appliances and equipment?"
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: l_food_equipment
          kind: QuestionGroup
          title: "Equipment for Serving and Preparing Food:"
          questions:
            - "Tableware, flatware and knives?"
            - "Non-electric kitchen and cooking equipment?"
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: l_garden_tools
          kind: QuestionGroup
          title: "Lawn, Garden and Snow Removal Tools, Equipment and Accessories:"
          questions:
            - "Power lawn and garden equipment?"
            - "Snow blowers?"
            - "Other lawn, garden and snow removal tools and equipment?"
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: l_workshop_tools
          kind: QuestionGroup
          title: "Workshop/Garage Tools and Equipment:"
          questions:
            - "Power tools and equipment?"
            - "Other tools?"
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: l_other_equipment
          kind: QuestionGroup
          title: "Other Household Equipment:"
          questions:
            - "Non-electric cleaning equipment?"
            - "Luggage?"
            - "Home security equipment?"
            - "Other household equipment, parts and accessories?"
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: l_services
          kind: QuestionGroup
          title: "Services Related to Household Equipment:"
          questions:
            - "Maintenance and repair of household equipment not previously reported?"
            - "Other services related to household furnishings and equipment (including rentals)?"
          input:
            control: Editbox
            min: 0
            max: 999999

    # =========================================================================
    # SECTION M: Home Operation (pp. 32-33)
    # =========================================================================
    - id: b_home_operation
      title: "Section M: Home Operation"
      items:
        - id: m_communications
          kind: QuestionGroup
          title: "Communications - In 2000 how much did your household spend on:"
          questions:
            - "Telephone services?"
            - "Cellular services?"
            - "Purchase of equipment, e.g., telephone sets, cellular phones, fax machines?"
            - "Internet services?"
            - "Other charges, e.g., wiring and installation fees, and repairs?"
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: m_postal
          kind: Question
          title: "Postage stamps and other postal and communications services?"
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: m_childcare
          kind: QuestionGroup
          title: "Child Care Expenses:"
          questions:
            - "Day care centres?"
            - "Other child care outside the home?"
            - "Child care in the home?"
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: m_home_garden
          kind: QuestionGroup
          title: "Home and Garden Services:"
          questions:
            - "Expenses for domestic help, e.g., housekeepers, cleaners, paid companions and house-sitters?"
            - "Horticultural services, snow and garbage removal?"
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: m_flowers_garden
          kind: QuestionGroup
          title: "Flowers and Garden Supplies:"
          questions:
            - "Nursery and greenhouse stock, cut flowers, floral arrangements and decorative plants?"
            - "Fertilizers, weed controls, herbicides, soils and soil conditioners?"
            - "Insecticides, pesticides and insect repellents?"
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: m_pets
          kind: QuestionGroup
          title: "Pet Expenses:"
          questions:
            - "Pet food (include birdseed)?"
            - "Pet purchase?"
            - "Pet related goods?"
            - "Veterinarian services and kennels, grooming and other pet related services?"
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: m_cleaning
          kind: QuestionGroup
          title: "Cleaning Services:"
          questions:
            - "Laundry and dry-cleaning services (include diaper service)?"
            - "Coin-operated washers and dryers, and self-service dry-cleaning?"
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: m_supplies
          kind: QuestionGroup
          title: "Household Supplies:"
          questions:
            - "Household cleaning supplies?"
            - "Stationery supplies?"
            - "Other paper and plastic supplies?"
            - "Other household supplies, e.g., light bulbs, dry cell batteries, candles?"
          input:
            control: Editbox
            min: 0
            max: 999999

    # =========================================================================
    # SECTION N: Food and Alcohol (pp. 34-35)
    # =========================================================================
    - id: b_food_alcohol
      title: "Section N: Food and Alcohol"
      items:
        - id: n_q1_groceries
          kind: Question
          title: "In 2000, how much did your household spend on food and other groceries purchased from stores, farmer stalls and home delivery?"
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: n_q1_1_nonfood
          kind: Question
          title: "Of this grocery expenditure, how much did your household spend on non-food items, e.g., paper products, cleaners, pet food, alcoholic beverages and cigarettes?"
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: n_q2_additional
          kind: QuestionGroup
          title: "What additional amounts did your household spend on:"
          questions:
            - "Bulk food purchases, e.g., meat in excess of 25 kg?"
            - "Prepared food and non-alcoholic beverages for parties, weddings, etc. not already reported?"
            - "Food and non-alcoholic beverages purchased from stores while away from home overnight or longer?"
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: n_q3_alcohol_stores
          kind: Question
          title: "How much did your household spend on alcoholic beverages purchased from stores?"
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: n_q4_homebrew
          kind: Question
          title: "How much did your household spend on supplies and fees for self-made beer, wine or liquor?"
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: n_q5_restaurant_meals
          kind: Question
          title: "How much did your household spend on meals and snacks from restaurants, drive-ins, cafeterias, take-outs, canteens, etc.?"
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: n_q5_1_in_province
          kind: Question
          title: "Of this amount, how much did your household spend in this province?"
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: n_q6_alcohol_restaurants
          kind: Question
          title: "How much did your household spend on alcoholic beverages purchased and consumed in bars, cocktail lounges, restaurants, etc.?"
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: n_q6_1_in_province
          kind: Question
          title: "Of this amount, how much did your household spend in this province?"
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: n_q7_board
          kind: QuestionGroup
          title: "How much board did your household pay to other private households:"
          questions:
            - "For day board and children's lunches?"
            - "While away from home overnight or longer?"
          input:
            control: Editbox
            min: 0
            max: 999999

    # =========================================================================
    # SECTION O: Clothing (pp. 36-38)
    # =========================================================================
    - id: b_clothing
      title: "Section O: Clothing"
      items:
        - id: o_intro
          kind: Comment
          title: "Include all items purchased for present or future use. Include sales taxes. Report gifts of clothing for persons who were not household members in Q.12."

        - id: o_women_clothing
          kind: QuestionGroup
          title: "Women and Girls 4 Years and Over - In 2000, how much did your household spend on:"
          questions:
            - "Clothing (outerwear, suits, dresses, skirts, slacks, sweaters, sleepwear, sportswear, hosiery)?"
            - "Footwear?"
            - "Accessories (gloves, hats, mitts, purses and umbrellas)?"
            - "Jewellery and watches?"
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: o_men_clothing
          kind: QuestionGroup
          title: "Men and Boys 4 Years and Over - In 2000, how much did your household spend on:"
          questions:
            - "Clothing (outerwear, suits, pants, shirts, sweaters, socks and sportswear)?"
            - "Footwear?"
            - "Accessories (gloves, hats, ties, belts, wallets and umbrellas)?"
            - "Jewellery and watches?"
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: o_children_clothing
          kind: QuestionGroup
          title: "Children Under 4 Years - In 2000, how much did your household spend on:"
          questions:
            - "Outerwear, daywear, sleepwear and cloth diapers?"
            - "Disposable diapers?"
            - "Footwear, e.g., shoes, sandals, boots and slippers?"
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: o_gifts_clothing
          kind: QuestionGroup
          title: "Gifts of Clothing - In 2000, how much did your household spend to purchase gifts of clothing for people who were not members of your household:"
          questions:
            - "For women and girls 4 years and over?"
            - "For men and boys 4 years and over?"
            - "For children under 4 years?"
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: o_clothing_services
          kind: QuestionGroup
          title: "Clothing materials and services:"
          questions:
            - "Clothing material?"
            - "Notions, e.g., patterns, buttons, zippers?"
            - "Dressmaking, tailoring, clothing storage and other clothing services?"
            - "Maintenance, repair and alteration of clothing, footwear, watches and jewellery?"
          input:
            control: Editbox
            min: 0
            max: 999999

    # =========================================================================
    # SECTION P: Personal and Health Care (pp. 39-40)
    # =========================================================================
    - id: b_personal_health
      title: "Section P: Personal and Health Care"
      items:
        - id: p_personal_care
          kind: QuestionGroup
          title: "Personal Care - In 2000, how much did your household spend on:"
          questions:
            - "Hair grooming services?"
            - "Other personal services (hair removal, manicures, facials)?"
            - "Personal care preparations (soap, shampoo, makeup, skin cream, perfume)?"
            - "Personal care supplies and equipment (brushes, wigs, razors, razor blades)?"
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: p_health_insurance
          kind: QuestionGroup
          title: "Health Insurance Premiums - In 2000, how much did your household spend on premiums for:"
          questions:
            - "Provincially or Territorially administered hospital, medical and drug plans?"
            - "Private health insurance plans?"
            - "Dental plans (sold as separate policies)?"
            - "Accident and disability insurance?"
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: p_eye_care
          kind: QuestionGroup
          title: "Eye Care:"
          questions:
            - "Prescription eye wear, e.g., contact lenses, eyeglasses and insurance on lenses?"
            - "Other eye care goods?"
            - "Eye exams, eye surgery and other eye care services?"
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: p_dental
          kind: Question
          title: "Dental services and orthodontic and periodontal procedures?"
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: p_medical
          kind: QuestionGroup
          title: "Other Medical and Health Care:"
          questions:
            - "Physicians' care?"
            - "Other health care practitioners?"
            - "Hospital care?"
            - "Weight control programs, quit-smoking programs and other medical services?"
            - "Medicines, drugs and pharmaceutical products prescribed by a doctor?"
            - "Other medicines, drugs and pharmaceutical products?"
            - "Health care supplies and goods?"
          input:
            control: Editbox
            min: 0
            max: 999999

    # =========================================================================
    # SECTION Q: Automobiles and Trucks (pp. 41-44)
    # =========================================================================
    - id: b_automobiles
      title: "Section Q: Automobiles and Trucks"
      items:
        - id: q_q1_has_vehicle
          kind: Question
          title: "In 2000, did anyone in your household own, lease or operate a car, van or truck and use it completely or partially for private use? (Exclude rented vehicles.)"
          codeBlock: |
            has_vehicle = q_q1_has_vehicle.outcome
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q_q2_vehicle_type
          kind: Question
          title: "Which of the following best describes Vehicle A?"
          precondition:
            - predicate: has_vehicle == 1
          input:
            control: Radio
            labels:
              1: "Car"
              2: "Van/mini-van"
              3: "Truck/sport utility vehicle"

        - id: q_q3_new_or_used
          kind: Question
          title: "When you bought or leased this vehicle, was it new or used?"
          precondition:
            - predicate: has_vehicle == 1
          input:
            control: Radio
            labels:
              4: "New"
              5: "Used"

        - id: q_q4_bought_in_2000
          kind: Question
          title: "Did you buy this vehicle in 2000?"
          precondition:
            - predicate: has_vehicle == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q_q5_purchase_price
          kind: Question
          title: "What was the purchase price after the trade-in allowance was deducted? (Include all sales taxes.)"
          precondition:
            - predicate: has_vehicle == 1 and q_q4_bought_in_2000.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 9999999

        - id: q_q6_leased
          kind: Question
          title: "Was this vehicle leased in 2000?"
          precondition:
            - predicate: has_vehicle == 1 and q_q4_bought_in_2000.outcome == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q_q6_1_leasing_cost
          kind: Question
          title: "What was the total leasing cost paid in 2000? (Include down payment. Exclude operating costs and any amount charged to business.)"
          precondition:
            - predicate: has_vehicle == 1 and q_q4_bought_in_2000.outcome == 0 and q_q6_leased.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: q_q7_status
          kind: Question
          title: "What was the status of this vehicle at December 31, 2000?"
          precondition:
            - predicate: has_vehicle == 1
          input:
            control: Radio
            labels:
              1: "Owned"
              2: "Leased"
              3: "Returned to lessor"
              4: "Sold separately or traded-in on lease"
              5: "Traded-in on purchase"
              6: "Owned/leased by non-household member"
              7: "Other"

        - id: q_q8_net_received
          kind: Question
          title: "If sold separately or traded-in on lease, what was the net amount received?"
          precondition:
            - predicate: has_vehicle == 1 and q_q7_status.outcome == 4
          input:
            control: Editbox
            min: 0
            max: 9999999

        - id: q_q9_trade_in_value
          kind: Question
          title: "If traded-in on purchase, what was the vehicle's trade-in value?"
          precondition:
            - predicate: has_vehicle == 1 and q_q7_status.outcome == 5
          input:
            control: Editbox
            min: 0
            max: 9999999

        - id: q_q10_17_operating
          kind: QuestionGroup
          title: "Automobile and Truck Operation - In 2000, how much did your household spend on the following operating expenses:"
          precondition:
            - predicate: has_vehicle == 1
          questions:
            - "Gas and other fuels?"
            - "Accessories and attachments, e.g., radios, CD players?"
            - "Tires, batteries and other automotive parts and supplies?"
            - "Other maintenance and repair expenses?"
            - "Vehicle registration fees (include insurance that is paid with registration fees)?"
            - "Vehicle insurance premiums?"
            - "Parking costs?"
            - "Other operation services, e.g., auto association fees, towing, and toll and bridge fees?"
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: q_q18_charged_business
          kind: Question
          title: "What amount or percentage of the total operating expenses (Q.10 to Q.17) was charged to business or reimbursed?"
          precondition:
            - predicate: has_vehicle == 1
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: q_q19_insurance_repairs
          kind: Question
          title: "What was the value of repair jobs which were covered by insurance and not paid by this household?"
          precondition:
            - predicate: has_vehicle == 1
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: q_q20_rented_vehicles
          kind: QuestionGroup
          title: "Expenditures for Rented Vehicles - In 2000, how much did your household spend on:"
          questions:
            - "Rented cars - rental fees?"
            - "Rented cars - gas and other fuels?"
            - "Rented trucks or vans - rental fees?"
            - "Rented trucks or vans - gas and other fuels?"
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: q_q21_drivers_licence
          kind: Question
          title: "Drivers' licences and tests? (Report government insurance if included.)"
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: q_q22_driving_lessons
          kind: Question
          title: "Driving lessons?"
          input:
            control: Editbox
            min: 0
            max: 999999

    # =========================================================================
    # SECTION R: Recreational Vehicles and Transportation Services (pp. 45-47)
    # =========================================================================
    - id: b_rec_vehicles
      title: "Section R: Recreational Vehicles and Transportation Services"
      items:
        - id: r_bicycles
          kind: QuestionGroup
          title: "Bicycles - In 2000, how much did your household spend on:"
          questions:
            - "Purchase of bicycles, parts and accessories?"
            - "Bicycle maintenance and repairs?"
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: r_q3_has_rec_vehicle
          kind: Question
          title: "In 2000, did anyone in your household own or operate any recreational vehicle completely or partially for private use? (Exclude rented or leased vehicles.)"
          codeBlock: |
            has_rec_vehicle = r_q3_has_rec_vehicle.outcome
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: r_q5_purchase_price
          kind: Question
          title: "If purchased in 2000, what was the price after the trade-in allowance was deducted?"
          precondition:
            - predicate: has_rec_vehicle == 1
          input:
            control: Editbox
            min: 0
            max: 9999999

        - id: r_q6_11_operating
          kind: QuestionGroup
          title: "In 2000, how much did your household spend on the following operating expenses:"
          precondition:
            - predicate: has_rec_vehicle == 1
          questions:
            - "Accessories, attachments, supplies and parts?"
            - "Gasoline, diesel fuel, etc.?"
            - "Maintenance and repair jobs not covered by insurance?"
            - "Vehicle insurance premiums?"
            - "Registration fees and licences?"
            - "Other expenses, e.g., parking, hangar and airport fees, mooring and boat storage?"
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: r_q12_charged_business
          kind: Question
          title: "What amount or percentage of the total operating expenses (Q.6 to Q.11) was charged to business?"
          precondition:
            - predicate: has_rec_vehicle == 1
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: r_q13_sold
          kind: Question
          title: "If sold separately (not traded-in) in 2000, what was the net amount received?"
          precondition:
            - predicate: has_rec_vehicle == 1
          input:
            control: Editbox
            min: 0
            max: 9999999

        - id: r_q14_rented_rec
          kind: Question
          title: "In 2000, how much were your household's total expenses for rented or leased recreational vehicles?"
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: r_transportation
          kind: QuestionGroup
          title: "Transportation services - In 2000, how much did your household spend on transportation by:"
          questions:
            - "City or commuter bus, subway, streetcar or commuter train?"
            - "Taxi (including tips)?"
            - "Airplane?"
            - "Train (including sleeping car)?"
            - "Highway bus?"
            - "Other passenger transportation?"
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: r_q16_moving
          kind: Question
          title: "In 2000, how much did your household spend on household moving, storage services and delivery services?"
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: r_q17_package_trips
          kind: Question
          title: "In 2000, did any member of your household take a trip that included a package?"
          codeBlock: |
            has_package_trip = r_q17_package_trips.outcome
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: r_q17_1_package_cost
          kind: Question
          title: "What was the cost of the package trips taken by your household in 2000?"
          precondition:
            - predicate: has_package_trip == 1
          input:
            control: Editbox
            min: 0
            max: 999999

    # =========================================================================
    # SECTION S: Recreation, Reading Materials and Education (pp. 48-50)
    # =========================================================================
    - id: b_recreation_education
      title: "Section S: Recreation, Reading Materials and Education"
      items:
        - id: s_sports_equipment
          kind: QuestionGroup
          title: "Sports, Athletic, Camping and Picnic Equipment - In 2000, how much did your household spend on:"
          questions:
            - "Sports and athletic equipment?"
            - "Camping and picnic equipment and accessories?"
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: s_photography
          kind: QuestionGroup
          title: "Photographic Goods and Services:"
          questions:
            - "Cameras, camera parts, attachments, accessories and other photographic goods?"
            - "Photographic film, processing, extra prints and enlargements?"
            - "Photographers' services and other photographic services?"
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: s_q6_musical
          kind: Question
          title: "Musical instruments, parts and accessories?"
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: s_other_recreation
          kind: QuestionGroup
          title: "Other Recreation Equipment:"
          questions:
            - "Artists' materials and handicraft or hobbycraft kits and materials?"
            - "Electronic games and parts, e.g., video game machines, plug-in cartridges?"
            - "Toys and other games (include children's vehicles and bicycles under 14 inches)?"
            - "Playground equipment, above-ground swimming pools and accessories?"
            - "Collectors' items, e.g., stamps and coins?"
            - "Parts and supplies for recreation equipment?"
            - "Rental of video games?"
            - "Rental, maintenance and repair of recreation, sports and health equipment?"
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: s_recreation_services
          kind: QuestionGroup
          title: "Recreation Services - In 2000, how much did your household spend on:"
          questions:
            - "Admissions to movie theatres?"
            - "Admissions to live performing arts?"
            - "Admissions to heritage facilities and other activities and venues?"
            - "Admissions to live sports events?"
            - "Fees for coin-operated and carnival games?"
            - "Membership fees and dues for sports activities, sports and recreation facilities, and health clubs?"
            - "Single usage fees for sports activities, sports and recreation facilities, and health clubs?"
            - "Children's camps, e.g., day camps and summer camps?"
            - "Other cultural and recreational services?"
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: s_reading
          kind: QuestionGroup
          title: "Reading Materials and Other Printed Matter:"
          questions:
            - "Newspapers?"
            - "Magazines and periodicals?"
            - "Books and pamphlets (exclude school books)?"
            - "Maps, sheet music and other printed matter?"
            - "Services, e.g., duplicating services, library charges, book rentals?"
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: s_education
          kind: QuestionGroup
          title: "Education - In 2000, how much did your household spend on:"
          questions:
            - "Kindergarten, nursery school, and elementary and secondary education - tuition fees?"
            - "Kindergarten, nursery school, and elementary and secondary education - books?"
            - "Kindergarten, nursery school, and elementary and secondary education - supplies?"
            - "Post-secondary education - tuition fees?"
            - "Post-secondary education - books?"
            - "Post-secondary education - supplies?"
            - "Other courses and lessons, e.g., music, dancing, sports and crafts?"
            - "Other educational services, e.g., rental of school books and equipment?"
          input:
            control: Editbox
            min: 0
            max: 999999

    # =========================================================================
    # SECTION T: Tobacco and Miscellaneous (pp. 51-52)
    # =========================================================================
    - id: b_tobacco_misc
      title: "Section T: Tobacco and Miscellaneous"
      items:
        - id: t_tobacco
          kind: QuestionGroup
          title: "Tobacco and Smokers' Supplies - In 2000, how much did your household spend on:"
          questions:
            - "Cigarettes, tobacco, cigars and similar products?"
            - "Smokers' supplies, e.g., matches, pipes, lighters, ashtrays?"
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: t_financial
          kind: QuestionGroup
          title: "Miscellaneous Expenses - Financial services:"
          questions:
            - "Service charges for banks and other financial institutions?"
            - "Stock and bond commissions?"
            - "Administration fees for brokers and others?"
            - "Other financial services, e.g., financial planning, tax preparation, accounting?"
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: t_gambling
          kind: QuestionGroup
          title: "Expenses and Winnings from gambling:"
          questions:
            - "Government-run lotteries - expenses?"
            - "Government-run lotteries - winnings?"
            - "Bingos - expenses?"
            - "Bingos - winnings?"
            - "Non-government lotteries, raffle tickets and other games of chance - expenses?"
            - "Non-government lotteries - winnings?"
            - "Casinos, slot machines and video lottery terminals - expenses?"
            - "Casinos, slot machines and video lottery terminals - winnings?"
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: t_other_expenses
          kind: QuestionGroup
          title: "Other expenses:"
          questions:
            - "Loss of deposits, fines, and money lost or stolen?"
            - "Contributions and dues for social clubs, co-operatives, political and fraternal organizations?"
            - "Tools and equipment purchased for work?"
            - "Legal services not related to dwellings?"
            - "What other expenses did you have for goods?"
            - "What other expenses did you have for services?"
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: t_q11_direct_sales
          kind: Question
          title: "In 2000, did your household purchase any goods through direct sales, e.g., door-to-door sales people, factory outlets, mail order companies, catalogue sales, book clubs and the Internet?"
          codeBlock: |
            has_direct_sales = t_q11_direct_sales.outcome
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: t_q11_1_categories
          kind: QuestionGroup
          title: "Did your household purchase the following goods through direct sales?"
          precondition:
            - predicate: has_direct_sales == 1
          questions:
            - "Food and beverages?"
            - "Books, newspapers and magazines?"
            - "Clothing, cosmetics and jewellery?"
            - "Home entertainment products, e.g., CDs, audio equipment and computers?"
            - "Other products used inside the home, e.g., appliances, cleaners, toys and crafts?"
            - "Other products used outside the home, e.g., greenhouse and nursery products?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: t_q11_2_direct_amount
          kind: Question
          title: "In 2000, how much did your household spend on goods purchased through direct sales?"
          precondition:
            - predicate: has_direct_sales == 1
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: t_q12_outside_canada
          kind: Question
          title: "In 2000, how much did your household spend on goods and services purchased outside Canada?"
          input:
            control: Editbox
            min: 0
            max: 999999

    # =========================================================================
    # SECTION U: Personal Income (pp. 53-54)
    # =========================================================================
    - id: b_personal_income
      title: "Section U: Personal Income"
      items:
        - id: u_intro
          kind: Comment
          title: "Ask each of the following questions for each member 15 years or over on December 31, 2000 (born before 1986). Amounts for persons 14 years or under (born after 1985) should be reported in a parent's column."

        - id: u_q1_weeks_worked
          kind: QuestionGroup
          title: "For 2000, for how many weeks did the reference person work:"
          questions:
            - "Full-time, including holidays with pay?"
            - "Part-time, including holidays with pay?"
          input:
            control: Editbox
            min: 0
            max: 52

        - id: u_income
          kind: QuestionGroup
          title: "For 2000, what was the reference person's income from the following sources:"
          questions:
            - "Wages and Salaries before deductions?"
            - "NET Income from Farm and Non-farm Self-employment?"
            - "GROSS Income from Roomers and Boarders who were household members (non-relatives)?"
            - "GROSS Income from Roomers and Boarders who were not members of your household?"
            - "Dividends, Interest on bonds, accounts and GICs, and Other Investment Income?"
            - "Child Tax Benefit (including Quebec Family Allowance)?"
            - "Old Age Security Pension, Guaranteed Income Supplement, Spouse's Allowance?"
            - "Canada or Quebec Pension Plan Benefits?"
            - "Employment Insurance Benefits (before deductions)?"
            - "Goods and Services Tax Credit (received in 2000)?"
            - "Provincial Tax Credits?"
            - "Social Assistance, Provincial Income Supplements, Workers' Compensation Benefits, Veterans' Pensions?"
            - "Retirement Pensions, Superannuation, Annuities and RRIF Withdrawals?"
            - "Personal Income Tax Refunds?"
            - "Other Money Income, e.g., alimony, child support, scholarships?"
            - "Other Money Receipts, e.g., money gifts, cash inheritances, life insurance settlements?"
          input:
            control: Editbox
            min: 0
            max: 9999999

    # =========================================================================
    # SECTION V: Personal Taxes, Security and Money Gifts (pp. 55-56)
    # =========================================================================
    - id: b_taxes_security
      title: "Section V: Personal Taxes, Security and Money Gifts"
      items:
        - id: v_intro
          kind: Comment
          title: "Ask each of the following questions for each member 15 years or over on December 31, 2000 (born before 1986)."

        - id: v_taxes
          kind: QuestionGroup
          title: "Personal Taxes - In 2000, how much did each member pay for:"
          questions:
            - "Income tax on 2000 income?"
            - "Income tax on income for years prior to 2000?"
            - "Other personal taxes, e.g., gift tax?"
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: v_security
          kind: QuestionGroup
          title: "Security and Employment-related Payments:"
          questions:
            - "Premiums on life, term and endowment insurance?"
            - "Annuity contracts and transfers to RRIFs?"
            - "Employment insurance (deductions from pay)?"
            - "Government retirement or pension fund?"
            - "Canada/Quebec pension plan?"
            - "Other retirement or pension funds?"
            - "Dues to unions and professional associations?"
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: v_support
          kind: Question
          title: "In 2000, how much did each member pay for support payments to a former spouse or partner (include alimony, separation allowance or child support)?"
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: v_money_gifts
          kind: QuestionGroup
          title: "In 2000, how much did each member spend on money gifts, contribution and other support payments to persons who were not household members:"
          questions:
            - "Money given to persons living in Canada?"
            - "Money given to persons living outside Canada?"
          input:
            control: Editbox
            min: 0
            max: 999999

        - id: v_charitable
          kind: QuestionGroup
          title: "In 2000, how much did each member spend on charitable contributions to:"
          questions:
            - "Religious organizations?"
            - "Other charitable organizations, e.g., the United Way, heart fund?"
          input:
            control: Editbox
            min: 0
            max: 999999

    # =========================================================================
    # SECTION W: Change in Assets (p. 57)
    # =========================================================================
    - id: b_change_assets
      title: "Section W: Change in Assets"
      items:
        - id: w_intro
          kind: Comment
          title: "Include the change in assets for each member of the household only for the period of time in 2000 when the person was a member of your household. Report answers as a total of the information reported by individual household members."

        - id: w_q1_net_change
          kind: QuestionGroup
          title: "In 2000, what was the NET CHANGE (increase or decrease) in the following household assets:"
          questions:
            - "Cash held in accounts in banks and trust and loan companies, and cash on hand (net increase)?"
            - "Cash held in accounts - net decrease?"
            - "Money owed to your household by persons outside your household (net increase)?"
            - "Money owed to your household (net decrease)?"
            - "Money deposited as a pledge against future purchases (net increase)?"
            - "Money deposited as a pledge (net decrease)?"
          input:
            control: Editbox
            min: 0
            max: 9999999

        - id: w_q2_rrsps
          kind: QuestionGroup
          title: "In 2000, how much did your household contribute to and withdraw from RRSPs?"
          questions:
            - "RRSP Contributions?"
            - "RRSP Withdrawals?"
          input:
            control: Editbox
            min: 0
            max: 9999999

        - id: w_q3_investments
          kind: QuestionGroup
          title: "In 2000, what was the value of your household's purchases and sales of the following:"
          questions:
            - "Savings bonds, and treasury bills - purchases?"
            - "Savings bonds, and treasury bills - sales?"
            - "Publicly traded stocks, mutual funds and shares in investment clubs - purchases?"
            - "Publicly traded stocks, mutual funds - sales?"
            - "Sales of personal property not traded in on new items in 2000?"
          input:
            control: Editbox
            min: 0
            max: 9999999

    # =========================================================================
    # SECTION X: Unincorporated Business (p. 58)
    # =========================================================================
    - id: b_unincorporated_business
      title: "Section X: Unincorporated Business"
      items:
        - id: x_q1_has_business
          kind: Question
          title: "In 2000, did any members of your household have investments in unincorporated businesses, professional practices, farms or rental property?"
          codeBlock: |
            has_business = x_q1_has_business.outcome
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: x_q1_details
          kind: QuestionGroup
          title: "In 2000, how much did your household:"
          precondition:
            - predicate: has_business == 1
          questions:
            - "Repay on the principal of your mortgage(s) or loan(s)?"
            - "Pay to purchase assets (machinery, trucks, cars, buildings)?"
            - "Borrow for the business or farm?"
            - "Receive (after commissions) from the sale of assets?"
            - "Estimate for capital cost allowance (depreciation)?"
          input:
            control: Editbox
            min: 0
            max: 9999999

        - id: x_q2_net_change
          kind: QuestionGroup
          title: "In 2000, what was the NET CHANGE (increase or decrease) in the following:"
          precondition:
            - predicate: has_business == 1
          questions:
            - "Accounts receivable (net increase)?"
            - "Accounts receivable (net decrease)?"
            - "Accounts payable (net decrease - reported as credit)?"
            - "Accounts payable (net increase - reported as debit)?"
          input:
            control: Editbox
            min: 0
            max: 9999999

    # =========================================================================
    # SECTION Y: Loans and Other Debts (pp. 59-60)
    # =========================================================================
    - id: b_loans
      title: "Section Y: Loans and Other Debts"
      items:
        - id: y_q1_has_loans
          kind: Question
          title: "In 2000, did your household have any loans with regular payments? (Include installment payment plans and student loans if repayment has begun. Exclude lines of credit, credit cards and accounts.)"
          codeBlock: |
            has_regular_loans = y_q1_has_loans.outcome
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: y_q3_loan_new
          kind: Question
          title: "Was this loan taken out in 2000?"
          precondition:
            - predicate: has_regular_loans == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: y_q3_1_loan_amount
          kind: Question
          title: "What was the amount of the loan?"
          precondition:
            - predicate: has_regular_loans == 1 and y_q3_loan_new.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 9999999

        - id: y_q4_payments
          kind: Question
          title: "How much were the total payments made on this loan in 2000? (Include lump sum payments.)"
          precondition:
            - predicate: has_regular_loans == 1
          input:
            control: Editbox
            min: 0
            max: 9999999

        - id: y_q5_additional
          kind: Question
          title: "Was there any additional amount borrowed in 2000 on this loan?"
          precondition:
            - predicate: has_regular_loans == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: y_q5_1_additional_amount
          kind: Question
          title: "What was the additional amount?"
          precondition:
            - predicate: has_regular_loans == 1 and y_q5_additional.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 9999999

        - id: y_q6_9_other_debts
          kind: QuestionGroup
          title: "Other Money Owed by Your Household - In 2000, how much did your household owe on the following (amount owed on January 1, 2000):"
          questions:
            - "Loans from financial institutions?"
            - "Credit cards from financial institutions?"
            - "Credit cards and other debts with stores, service stations and other retail establishments?"
            - "Rents, taxes and other bills, e.g., hospital?"
          input:
            control: Editbox
            min: 0
            max: 9999999
