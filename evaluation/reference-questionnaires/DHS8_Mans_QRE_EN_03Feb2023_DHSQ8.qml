qmlVersion: "1.0"
questionnaire:
  title: "DHS-8 Model Man's Questionnaire"
  codeInit: |
    consent = 0
    born_in_country = 0
    years_residence = 0
    always_lived_here = 0
    attended_school = 0
    education_level = 0
    literacy = 0
    owns_mobile = 0
    used_internet_ever = 0
    used_internet_recent = 0
    has_fathered = 0
    children_living_with = 0
    children_elsewhere = 0
    has_living_children = 0
    total_children = 0
    youngest_child_age = 0
    youngest_child_under3 = 0
    has_dead_children = 0
    marital_status = 0
    currently_in_union = 0
    formerly_in_union = 0
    num_wives = 0
    one_wife = 0
    has_had_sex = 0
    last_sex_unit = 0
    recent_sex = 0
    used_method_last = 0
    method_condom_or_female_condom = 0
    condom_used_last = 0
    had_second_partner = 0
    had_third_partner = 0
    wife_pregnant = 0
    man_sterilized = 0
    wife_pregnant_multi = 0
    has_children_flag = 0
    no_children_flag = 0
    ideal_children_response = 0
    worked_last_7_days = 0
    absent_from_job = 0
    worked_last_12_months = 0
    earns_cash = 0
    owns_house = 0
    owns_land = 0
    has_bank_account = 0
    heard_hiv = 0
    age_years = 0
    is_young = 0
    hiv_tested = 0
    got_results = 0
    hiv_positive = 0
    heard_sti = 0
    circumcised_yes = 0
    trad_circumcised = 0
    med_circumcised = 0
    smokes_currently = 0
    smokes_every_day = 0
    smokes_some_days = 0
    smoked_past_daily = 0
    uses_smokeless = 0
    uses_smokeless_daily = 0
    ever_drank_alcohol = 0
    has_insurance = 0
    heard_self_test = 0

  blocks:
    # =========================================================================
    # INTRODUCTION AND CONSENT
    # =========================================================================
    - id: b_consent
      title: "Introduction and Consent"
      items:
        - id: q_consent_intro
          kind: Comment
          title: "Hello. My name is ___. I am working with [NAME OF ORGANIZATION]. We are conducting a survey about health and other topics all over [NAME OF COUNTRY]. The information we collect will help the government to plan health services. Your household was selected for the survey. The questions usually take about 20 minutes. All of the answers you give will be confidential and will not be shared with anyone other than members of our survey team. You don't have to be in the survey, but we hope you will agree to answer the questions since your views are important. If I ask you any question you don't want to answer, just let me know and I will go on to the next question or you can stop the interview at any time."

        - id: q_consent
          kind: Question
          title: "May I begin the interview now?"
          input:
            control: Radio
            labels:
              1: "Respondent agrees to be interviewed"
              2: "Respondent does not agree to be interviewed"
          codeBlock: |
            if q_consent.outcome == 1:
                consent = 1

    # =========================================================================
    # SECTION 1: RESPONDENT'S BACKGROUND
    # =========================================================================
    - id: b_background
      title: "Section 1. Respondent's Background"
      precondition:
        - predicate: consent == 1
      items:
        - id: q101_time_hours
          kind: Question
          title: "Record the time. Hours:"
          input:
            control: Editbox
            min: 0
            max: 23

        - id: q101_time_minutes
          kind: Question
          title: "Record the time. Minutes:"
          input:
            control: Editbox
            min: 0
            max: 59

        - id: q102_birthplace
          kind: Question
          title: "What province/region/state were you born in?"
          input:
            control: Radio
            labels:
              1: "Province/Region/State 1"
              2: "Province/Region/State 2"
              3: "Province/Region/State 3"
              96: "Outside of country"
          codeBlock: |
            if q102_birthplace.outcome in [1, 2, 3]:
                born_in_country = 1

        - id: q103_birth_country
          kind: Question
          title: "What country were you born in?"
          precondition:
            - predicate: q102_birthplace.outcome == 96
          input:
            control: Editbox
            min: 1
            max: 999

        - id: q104_years_lived
          kind: Question
          title: "How long have you been living continuously in the current city, town or village of residence? (If less than one year, record 00 years.)"
          input:
            control: Editbox
            min: 0
            max: 95
          codeBlock: |
            years_residence = q104_years_lived.outcome
            if q104_years_lived.outcome == 95:
                always_lived_here = 1

        - id: q104_visitor
          kind: Question
          title: "Are you a visitor to this place?"
          precondition:
            - predicate: q104_years_lived.outcome == 0
          input:
            control: Radio
            labels:
              1: "No, resident"
              2: "Yes, visitor"
          codeBlock: |
            if q104_visitor.outcome == 2:
                always_lived_here = 2

        # CHECK 104: 00-04 years -> 106; 05 years or more -> 107
        # Modeled: q106 gets precondition years 0-4 and NOT always/visitor
        # q107 onwards gets no special gate (asked of everyone who didn't skip)

        - id: q106_move_month
          kind: Question
          title: "In what month did you move here?"
          precondition:
            - predicate: always_lived_here == 0
            - predicate: years_residence <= 4
          input:
            control: Editbox
            min: 1
            max: 98
            right: "(98 = Don't know month)"

        - id: q106_move_year
          kind: Question
          title: "In what year did you move here?"
          precondition:
            - predicate: always_lived_here == 0
            - predicate: years_residence <= 4
          input:
            control: Editbox
            min: 1900
            max: 9998
            right: "(9998 = Don't know year)"

        - id: q107_prev_region
          kind: Question
          title: "Just before you moved here, which province/region/state did you live in?"
          precondition:
            - predicate: always_lived_here == 0
          input:
            control: Radio
            labels:
              1: "Province/Region/State 1"
              2: "Province/Region/State 2"
              3: "Province/Region/State 3"
              96: "Outside of country"

        - id: q108_prev_urban
          kind: Question
          title: "Just before you moved here, did you live in a city, in a town, or in a rural area?"
          precondition:
            - predicate: always_lived_here == 0
          input:
            control: Radio
            labels:
              1: "City"
              2: "Town"
              3: "Rural area"

        - id: q109_reason_move
          kind: Question
          title: "Why did you move to this place?"
          precondition:
            - predicate: always_lived_here == 0
          input:
            control: Radio
            labels:
              1: "Employment"
              2: "Education/Training"
              3: "Marriage formation"
              4: "Family reunification/Other family related reason"
              5: "Forced displacement"
              96: "Other"

        - id: q110_birth_month
          kind: Question
          title: "In what month were you born?"
          input:
            control: Editbox
            min: 1
            max: 98
            right: "(98 = Don't know month)"

        - id: q110_birth_year
          kind: Question
          title: "In what year were you born?"
          input:
            control: Editbox
            min: 1900
            max: 9998
            right: "(9998 = Don't know year)"

        - id: q111_age
          kind: Question
          title: "How old were you at your last birthday?"
          input:
            control: Editbox
            min: 15
            max: 95
          codeBlock: |
            age_years = q111_age.outcome
            if q111_age.outcome >= 15 and q111_age.outcome <= 24:
                is_young = 1

        - id: q112_health
          kind: Question
          title: "In general, would you say your health is very good, good, moderate, bad, or very bad?"
          input:
            control: Radio
            labels:
              1: "Very good"
              2: "Good"
              3: "Moderate"
              4: "Bad"
              5: "Very bad"

        - id: q113_school
          kind: Question
          title: "Have you ever attended school?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
          codeBlock: |
            if q113_school.outcome == 1:
                attended_school = 1

        - id: q114_education
          kind: Question
          title: "What is the highest level of school you attended: primary, secondary, or higher?"
          precondition:
            - predicate: q113_school.outcome == 1
          input:
            control: Radio
            labels:
              1: "Primary"
              2: "Secondary"
              3: "Higher"
          codeBlock: |
            education_level = q114_education.outcome

        - id: q115_grade
          kind: Question
          title: "What is the highest grade/form/year you completed at that level? (If completed less than one year at that level, record 00.)"
          precondition:
            - predicate: q113_school.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 9

        # CHECK 116: Primary or Secondary -> 117; Higher -> 119
        - id: q117_literacy
          kind: Question
          title: "Now I would like you to read this sentence to me. (Show card to respondent. If respondent cannot read whole sentence, probe: Can you read any part of the sentence to me?)"
          precondition:
            - predicate: attended_school == 0 or education_level in [1, 2]
          input:
            control: Radio
            labels:
              1: "Cannot read at all"
              2: "Able to read only part of the sentence"
              3: "Able to read whole sentence"
              4: "No card with required language"
              5: "Blind/visually impaired"
          codeBlock: |
            literacy = q117_literacy.outcome

        # CHECK 118: code 2, 3, or 4 -> 119; code 1 or 5 -> 120
        - id: q119_newspaper
          kind: Question
          title: "Do you read a newspaper or magazine at least once a week, less than once a week or not at all?"
          precondition:
            - predicate: education_level == 3 or literacy in [2, 3, 4]
          input:
            control: Radio
            labels:
              1: "At least once a week"
              2: "Less than once a week"
              3: "Not at all"

        - id: q120_radio
          kind: Question
          title: "Do you listen to the radio at least once a week, less than once a week or not at all?"
          input:
            control: Radio
            labels:
              1: "At least once a week"
              2: "Less than once a week"
              3: "Not at all"

        - id: q121_tv
          kind: Question
          title: "Do you watch television at least once a week, less than once a week or not at all?"
          input:
            control: Radio
            labels:
              1: "At least once a week"
              2: "Less than once a week"
              3: "Not at all"

        - id: q122_mobile
          kind: Question
          title: "Do you own a mobile phone?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
          codeBlock: |
            if q122_mobile.outcome == 1:
                owns_mobile = 1

        - id: q123_smartphone
          kind: Question
          title: "Is your mobile phone a smart phone?"
          precondition:
            - predicate: q122_mobile.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: q127_internet_ever
          kind: Question
          title: "Have you ever used the Internet from any location on any device?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
          codeBlock: |
            if q127_internet_ever.outcome == 1:
                used_internet_ever = 1

        - id: q128_internet_recent
          kind: Question
          title: "In the last 12 months, have you used the Internet? (If necessary, probe for use from any location, with any device.)"
          precondition:
            - predicate: q127_internet_ever.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
          codeBlock: |
            if q128_internet_recent.outcome == 1:
                used_internet_recent = 1

        - id: q129_internet_freq
          kind: Question
          title: "During the last one month, how often did you use the Internet: almost every day, at least once a week, less than once a week, or not at all?"
          precondition:
            - predicate: q128_internet_recent.outcome == 1
          input:
            control: Radio
            labels:
              1: "Almost every day"
              2: "At least once a week"
              3: "Less than once a week"
              4: "Not at all"

        - id: q130_religion
          kind: Question
          title: "What is your religion?"
          input:
            control: Radio
            labels:
              1: "Religion 1"
              2: "Religion 2"
              3: "Religion 3"
              96: "Other"

        - id: q131_ethnicity
          kind: Question
          title: "What is your ethnic group?"
          input:
            control: Radio
            labels:
              1: "Ethnic group 1"
              2: "Ethnic group 2"
              3: "Ethnic group 3"
              96: "Other"

    # =========================================================================
    # SECTION 2: REPRODUCTION
    # =========================================================================
    - id: b_reproduction
      title: "Section 2. Reproduction"
      precondition:
        - predicate: consent == 1
      items:
        - id: q201_fathered
          kind: Question
          title: "Now I would like to ask about any children you have had during your life. I am interested in all of the children that are biologically yours, even if they are not legally yours or do not have your last name. Have you ever fathered any children with any woman?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
          codeBlock: |
            if q201_fathered.outcome == 1:
                has_fathered = 1

        - id: q202_living_with
          kind: Question
          title: "Do you have any sons or daughters that you have fathered who are now living with you?"
          precondition:
            - predicate: q201_fathered.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: q203a_sons_home
          kind: Question
          title: "How many sons live with you? (If none, record 00.)"
          precondition:
            - predicate: q202_living_with.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 20
          codeBlock: |
            children_living_with = children_living_with + q203a_sons_home.outcome

        - id: q203b_daughters_home
          kind: Question
          title: "And how many daughters live with you? (If none, record 00.)"
          precondition:
            - predicate: q202_living_with.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 20
          codeBlock: |
            children_living_with = children_living_with + q203b_daughters_home.outcome

        - id: q204_alive_elsewhere
          kind: Question
          title: "Do you have any sons or daughters that you have fathered who are alive but do not live with you?"
          precondition:
            - predicate: q201_fathered.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: q205a_sons_elsewhere
          kind: Question
          title: "How many sons are alive but do not live with you? (If none, record 00.)"
          precondition:
            - predicate: q204_alive_elsewhere.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 20
          codeBlock: |
            children_elsewhere = children_elsewhere + q205a_sons_elsewhere.outcome

        - id: q205b_daughters_elsewhere
          kind: Question
          title: "And how many daughters are alive but do not live with you? (If none, record 00.)"
          precondition:
            - predicate: q204_alive_elsewhere.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 20
          codeBlock: |
            children_elsewhere = children_elsewhere + q205b_daughters_elsewhere.outcome

        - id: q206_child_died
          kind: Question
          title: "Have you ever fathered a son or a daughter who was born alive but later died? (If no, probe: Any baby who cried, who made any movement, sound, or effort to breathe, or who showed any other signs of life even if for a very short time?)"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
          codeBlock: |
            if q206_child_died.outcome == 1:
                has_dead_children = 1

        - id: q207a_boys_dead
          kind: Question
          title: "How many boys have died? (If none, record 00.)"
          precondition:
            - predicate: q206_child_died.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 20

        - id: q207b_girls_dead
          kind: Question
          title: "And how many girls have died? (If none, record 00.)"
          precondition:
            - predicate: q206_child_died.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 20

        # Q208: Sum of 203, 205, 207 = total children. Modeled as computed variable.
        - id: q208_total_children
          kind: Question
          title: "Sum answers to 203, 205, and 207, and enter total. If none, record 00."
          input:
            control: Editbox
            min: 0
            max: 95
          codeBlock: |
            total_children = q208_total_children.outcome
            if total_children >= 1:
                has_children_flag = 1
            if total_children == 0:
                no_children_flag = 1
            if children_living_with + children_elsewhere >= 1:
                has_living_children = 1

        # CHECK 209: more than one child -> 210; only one child -> 211; no children -> 301
        - id: q210_same_mother
          kind: Question
          title: "Did all of the children you have fathered have the same biological mother?"
          precondition:
            - predicate: total_children >= 2
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # Q211: age at first/only child's birth
        - id: q211_age_first_child
          kind: Question
          title: "How old were you when your first child was born? (If only one child: How old were you when your child was born?)"
          precondition:
            - predicate: total_children >= 1
          input:
            control: Editbox
            min: 10
            max: 60

        # CHECK 212: at least one living child -> continue; no living children -> 301
        # CHECK 213: more than one living child or only one living child -> ask age
        - id: q213_youngest_age
          kind: Question
          title: "How old is your youngest child? (If only one living child: How old is your child?) Age in years."
          precondition:
            - predicate: has_living_children == 1
          input:
            control: Editbox
            min: 0
            max: 50
          codeBlock: |
            youngest_child_age = q213_youngest_age.outcome
            if youngest_child_age <= 2:
                youngest_child_under3 = 1

        # CHECK 214: youngest child 0-2 years -> continue; 3+ years -> 301
        - id: q215_youngest_name
          kind: Question
          title: "What is the name of your youngest child? (Record name. If only one living child: What is the name of your child?)"
          precondition:
            - predicate: youngest_child_under3 == 1
          input:
            control: Textarea
            placeholder: "Enter name of child"
            maxLength: 100

        - id: q216_antenatal
          kind: Question
          title: "When (NAME IN 215)'s mother was pregnant with (NAME IN 215), did she have any antenatal check-ups?"
          precondition:
            - predicate: youngest_child_under3 == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q217_present_antenatal
          kind: Question
          title: "Were you ever present during any of those antenatal check-ups?"
          precondition:
            - predicate: q216_antenatal.outcome == 1
          input:
            control: Radio
            labels:
              1: "Present"
              2: "Not present"

        - id: q218_born_facility
          kind: Question
          title: "Was (NAME IN 215) born in a hospital or health facility?"
          precondition:
            - predicate: youngest_child_under3 == 1
          input:
            control: Radio
            labels:
              1: "Hospital/health facility"
              2: "Other"

        - id: q219_went_facility
          kind: Question
          title: "Did you go with (NAME IN 215)'s mother to the hospital or health facility where she gave birth to (NAME IN 215)?"
          precondition:
            - predicate: q218_born_facility.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

    # =========================================================================
    # SECTION 3: CONTRACEPTION
    # =========================================================================
    - id: b_contraception
      title: "Section 3. Contraception"
      precondition:
        - predicate: consent == 1
      items:
        - id: q301_intro
          kind: Comment
          title: "Now I would like to talk about family planning - the various ways or methods that a couple can use to delay or avoid a pregnancy."

        - id: q301_female_sterilization
          kind: Question
          title: "Have you heard of Female Sterilization? (Probe: Women can have an operation to avoid having any more children.)"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: q302_male_sterilization
          kind: Question
          title: "Have you heard of Male Sterilization? (Probe: Men can have an operation to avoid having any more children.)"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: q303_iud
          kind: Question
          title: "Have you heard of IUD? (Probe: Women can have a loop or coil placed inside them by a doctor or a nurse which can prevent pregnancy for one or more years.)"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: q304_injectables
          kind: Question
          title: "Have you heard of Injectables? (Probe: Women can have an injection by a health provider that stops them from becoming pregnant for one or more months.)"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: q305_implants
          kind: Question
          title: "Have you heard of Implants? (Probe: Women can have one or more small rods placed in their upper arm by a doctor or nurse which can prevent pregnancy for one or more years.)"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: q306_pill
          kind: Question
          title: "Have you heard of Pill? (Probe: Women can take a pill every day to avoid becoming pregnant.)"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: q307_condom
          kind: Question
          title: "Have you heard of Condom? (Probe: Men can put a rubber sheath on their penis before sexual intercourse.)"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: q308_female_condom
          kind: Question
          title: "Have you heard of Female Condom? (Probe: Women can place a sheath in their vagina before sexual intercourse.)"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: q309_emergency
          kind: Question
          title: "Have you heard of Emergency Contraception? (Probe: As an emergency measure, within 3 days after they have unprotected sexual intercourse, women can take special pills to prevent pregnancy.)"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: q310_sdm
          kind: Question
          title: "Have you heard of Standard Days Method? (Probe: A woman uses a string of colored beads to know the days she can get pregnant. On the days she can get pregnant, she uses a condom or does not have sexual intercourse.)"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: q311_lam
          kind: Question
          title: "Have you heard of Lactational Amenorrhea Method (LAM)? (Probe: Up to 6 months after childbirth, before the menstrual period has returned, women use a method requiring frequent breastfeeding day and night.)"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: q312_rhythm
          kind: Question
          title: "Have you heard of Rhythm Method? (Probe: To avoid pregnancy, women do not have sexual intercourse on the days of the month they think they can get pregnant.)"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: q313_withdrawal
          kind: Question
          title: "Have you heard of Withdrawal? (Probe: Men can be careful and pull out before climax.)"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: q314_other_method
          kind: Question
          title: "Have you heard of any other ways or methods that women or men can use to avoid pregnancy?"
          input:
            control: Radio
            labels:
              1: "Yes, modern method"
              2: "Yes, traditional method"
              3: "No"

        - id: q302a_fp_radio
          kind: Question
          title: "In the last 12 months have you: a) Heard about family planning on the radio?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: q302b_fp_tv
          kind: Question
          title: "b) Seen anything about family planning on the television?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: q302c_fp_newspaper
          kind: Question
          title: "c) Read about family planning in a newspaper or magazine?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: q302d_fp_mobile
          kind: Question
          title: "d) Received a voice or text message about family planning on a mobile phone?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: q302e_fp_social
          kind: Question
          title: "e) Seen anything about family planning on social media such as Facebook, Twitter, or Instagram?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: q302f_fp_poster
          kind: Question
          title: "f) Seen anything about family planning on a poster, leaflet or brochure?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: q302g_fp_outdoor
          kind: Question
          title: "g) Seen anything about family planning on an outdoor sign or billboard?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: q302h_fp_community
          kind: Question
          title: "h) Heard anything about family planning at community meetings or events?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: q303_fp_discussed
          kind: Question
          title: "In the last few months, have you discussed family planning with a health worker or health professional?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: q304_fertile_period
          kind: Question
          title: "Now I would like to ask you about a woman's risk of pregnancy. From one menstrual period to the next, are there certain days when a woman is more likely to become pregnant when she has sexual relations?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q305_when_fertile
          kind: Question
          title: "Is this time just before her period begins, during her period, right after her period has ended, or halfway between two periods?"
          precondition:
            - predicate: q304_fertile_period.outcome == 1
          input:
            control: Radio
            labels:
              1: "Just before her period begins"
              2: "During her period"
              3: "Right after her period has ended"
              4: "Halfway between two periods"
              6: "Other"
              8: "Don't know"

        - id: q306_postpartum
          kind: Question
          title: "After the birth of a child, can a woman become pregnant before her menstrual period has returned?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q307a_contraception_concern
          kind: Question
          title: "Do you agree or disagree: Contraception is a woman's concern and a man should not have to worry about it."
          input:
            control: Radio
            labels:
              1: "Agree"
              2: "Disagree"
              8: "Don't know"

        - id: q307b_promiscuous
          kind: Question
          title: "Do you agree or disagree: Women who use contraception may become promiscuous."
          input:
            control: Radio
            labels:
              1: "Agree"
              2: "Disagree"
              8: "Don't know"

    # =========================================================================
    # SECTION 4: MARRIAGE AND SEXUAL ACTIVITY
    # =========================================================================
    - id: b_marriage
      title: "Section 4. Marriage and Sexual Activity"
      precondition:
        - predicate: consent == 1
      items:
        - id: q401_marital
          kind: Question
          title: "Are you currently married or living together with a woman as if married?"
          input:
            control: Radio
            labels:
              1: "Yes, currently married"
              2: "Yes, living with a woman"
              3: "No, not in union"
          codeBlock: |
            if q401_marital.outcome in [1, 2]:
                currently_in_union = 1
                marital_status = 1

        - id: q402_ever_married
          kind: Question
          title: "Have you ever been married or lived together with a woman as if married?"
          precondition:
            - predicate: q401_marital.outcome == 3
          input:
            control: Radio
            labels:
              1: "Yes, formerly married"
              2: "Yes, lived with a woman"
              3: "No"
          codeBlock: |
            if q402_ever_married.outcome in [1, 2]:
                formerly_in_union = 1
                marital_status = 2

        - id: q403_widowed
          kind: Question
          title: "What is your marital status now: are you widowed, divorced, or separated?"
          precondition:
            - predicate: q402_ever_married.outcome in [1, 2]
          input:
            control: Radio
            labels:
              1: "Widowed"
              2: "Divorced"
              3: "Separated"

        - id: q404_wife_living
          kind: Question
          title: "Is your (wife/partner) living with you now or is she staying elsewhere?"
          precondition:
            - predicate: currently_in_union == 1
          input:
            control: Radio
            labels:
              1: "Living with him"
              2: "Staying elsewhere"

        - id: q405_other_wives
          kind: Question
          title: "Do you have other wives or do you live with other women as if married?"
          precondition:
            - predicate: currently_in_union == 1
          input:
            control: Radio
            labels:
              1: "Yes (more than one wife)"
              2: "No (only one wife)"
          codeBlock: |
            if q405_other_wives.outcome == 2:
                one_wife = 1
                num_wives = 1
            if q405_other_wives.outcome == 1:
                one_wife = 0

        - id: q406_num_wives
          kind: Question
          title: "Altogether, how many wives or live-in partners do you have?"
          precondition:
            - predicate: q405_other_wives.outcome == 1
          input:
            control: Editbox
            min: 2
            max: 20
          codeBlock: |
            num_wives = q406_num_wives.outcome

        - id: q407_wife_name
          kind: Comment
          title: "Record the name and the line number from the household questionnaire for each wife or live-in partner. If a woman is not listed in the household, record 00."
          precondition:
            - predicate: currently_in_union == 1

        - id: q408_wife_age
          kind: Question
          title: "How old was (NAME IN 407) on her last birthday?"
          precondition:
            - predicate: currently_in_union == 1
          input:
            control: Editbox
            min: 10
            max: 95

        # CHECK 409: one wife/partner -> 410; more than one -> 411
        # Also reached by formerly married (Q403: divorced=2 or separated=3 -> 410)
        - id: q410_married_times
          kind: Question
          title: "Have you been married or lived with a woman only once or more than once?"
          precondition:
            - predicate: (currently_in_union == 1 and one_wife == 1) or formerly_in_union == 1
          input:
            control: Radio
            labels:
              1: "More than once"
              2: "Only once"

        # Q411: CHECK 405 AND 410
        # Both code 2 (only one wife AND only once) -> start date of current wife
        # Other -> start date of first wife
        - id: q411_month_start
          kind: Question
          title: "In what month and year did you start living with your (wife/partner)? (If more than one: your first wife or partner)"
          precondition:
            - predicate: currently_in_union == 1 or formerly_in_union == 1
          input:
            control: Editbox
            min: 1
            max: 98
            right: "(98 = Don't know month)"

        - id: q411_year_start
          kind: Question
          title: "In what year did you start living with her?"
          precondition:
            - predicate: currently_in_union == 1 or formerly_in_union == 1
          input:
            control: Editbox
            min: 1900
            max: 9998
            right: "(9998 = Don't know year)"

        - id: q412_age_first_union
          kind: Question
          title: "How old were you when you first started living with her?"
          precondition:
            - predicate: currently_in_union == 1 or formerly_in_union == 1
          input:
            control: Editbox
            min: 10
            max: 60

        - id: q413_privacy
          kind: Comment
          title: "CHECK FOR PRESENCE OF OTHERS. BEFORE CONTINUING, MAKE EVERY EFFORT TO ENSURE PRIVACY."
          precondition:
            - predicate: currently_in_union == 1 or formerly_in_union == 1 or q402_ever_married.outcome == 3

        - id: q414_first_sex_age
          kind: Question
          title: "I would like to ask some questions about sexual activity in order to gain a better understanding of some important life issues. Let me assure you again that your answers are completely confidential and will not be told to anyone. How old were you when you had sexual intercourse for the very first time? (Record 00 if never had sexual intercourse.)"
          input:
            control: Editbox
            min: 0
            max: 50
          codeBlock: |
            if q414_first_sex_age.outcome > 0:
                has_had_sex = 1

        - id: q415_last_sex
          kind: Question
          title: "I would like to ask you about your recent sexual activity. When was the last time you had sexual intercourse?"
          precondition:
            - predicate: has_had_sex == 1
          input:
            control: Radio
            labels:
              1: "Days ago"
              2: "Weeks ago"
              3: "Months ago"
              4: "Years ago"
          codeBlock: |
            last_sex_unit = q415_last_sex.outcome
            if q415_last_sex.outcome in [1, 2, 3]:
                recent_sex = 1

        - id: q415_last_sex_number
          kind: Question
          title: "How many (days/weeks/months/years) ago?"
          precondition:
            - predicate: has_had_sex == 1
          input:
            control: Editbox
            min: 1
            max: 50

        - id: q416_used_method
          kind: Question
          title: "The last time you had sexual intercourse, did you or your partner do something or use any method to delay or avoid a pregnancy?"
          precondition:
            - predicate: has_had_sex == 1
            - predicate: recent_sex == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
          codeBlock: |
            if q416_used_method.outcome == 1:
                used_method_last = 1

        - id: q417_know_source
          kind: Question
          title: "Do you know of a place where you can obtain a method of family planning?"
          precondition:
            - predicate: used_method_last == 0
            - predicate: has_had_sex == 1
            - predicate: recent_sex == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: q418_method_used
          kind: Question
          title: "What method did you or your partner use? (Record all mentioned.)"
          precondition:
            - predicate: used_method_last == 1
          input:
            control: Checkbox
            labels:
              1: "Female sterilization"
              2: "Male sterilization"
              4: "IUD"
              8: "Injectables"
              16: "Implants"
              32: "Pill"
              64: "Condom"
              128: "Female condom"
              256: "Emergency contraception"
              512: "Standard Days Method"
              1024: "Lactational Amenorrhea Method"
              2048: "Rhythm method"
              4096: "Withdrawal"
              8192: "Other modern method"
              16384: "Other traditional method"
          codeBlock: |
            if q418_method_used.outcome % 4 >= 2:
                man_sterilized = 1
            if q418_method_used.outcome % 128 >= 64:
                method_condom_or_female_condom = 1
            if q418_method_used.outcome % 256 >= 128:
                method_condom_or_female_condom = 1

        - id: q419_condom_last
          kind: Question
          title: "The last time you had sexual intercourse, was a condom used?"
          precondition:
            - predicate: used_method_last == 1
            - predicate: method_condom_or_female_condom == 0
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
          codeBlock: |
            if q419_condom_last.outcome == 1:
                condom_used_last = 1

        - id: q420_condom_brand
          kind: Question
          title: "What was the brand name of the condom used? (If brand not known, ask to see the package.)"
          precondition:
            - predicate: method_condom_or_female_condom == 1 or condom_used_last == 1
          input:
            control: Radio
            labels:
              1: "Brand A"
              2: "Brand B"
              3: "Brand C"
              96: "Other"
              98: "Don't know"

        - id: q421_condom_source
          kind: Question
          title: "From where did you obtain the condom the last time?"
          precondition:
            - predicate: method_condom_or_female_condom == 1 or condom_used_last == 1
          input:
            control: Dropdown
            labels:
              11: "Government hospital"
              12: "Government health center"
              13: "Family planning clinic"
              14: "Mobile clinic"
              15: "Community health worker/Field worker"
              16: "Other public sector"
              21: "Private hospital"
              22: "Private clinic"
              23: "Pharmacy"
              24: "Private doctor"
              25: "Mobile clinic (private)"
              26: "Community health worker (private)"
              27: "Other private medical sector"
              31: "NGO hospital"
              32: "NGO clinic"
              36: "Other NGO medical sector"
              41: "Shop"
              42: "Church"
              43: "Friend/Relative"
              96: "Other"
              98: "Don't know"

        - id: q422_relationship_1
          kind: Question
          title: "What was your relationship to this person with whom you had sexual intercourse?"
          precondition:
            - predicate: has_had_sex == 1
            - predicate: recent_sex == 1
          input:
            control: Radio
            labels:
              1: "Wife"
              2: "Live-in partner"
              3: "Girlfriend not living with respondent"
              4: "Casual acquaintance"
              5: "Client/sex worker"
              6: "Other"

        - id: q423_other_partner
          kind: Question
          title: "Apart from this person, have you had sexual intercourse with any other person in the last 12 months?"
          precondition:
            - predicate: has_had_sex == 1
            - predicate: recent_sex == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
          codeBlock: |
            if q423_other_partner.outcome == 1:
                had_second_partner = 1

        - id: q424_condom_2nd
          kind: Question
          title: "The last time you had sexual intercourse with this second person, was a condom used?"
          precondition:
            - predicate: had_second_partner == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: q425_relationship_2
          kind: Question
          title: "What was your relationship to this second person with whom you had sexual intercourse?"
          precondition:
            - predicate: had_second_partner == 1
          input:
            control: Radio
            labels:
              1: "Wife"
              2: "Live-in partner"
              3: "Girlfriend not living with respondent"
              4: "Casual acquaintance"
              5: "Client/sex worker"
              6: "Other"

        - id: q426_third_partner
          kind: Question
          title: "Apart from these two people, have you had sexual intercourse with any other person in the last 12 months?"
          precondition:
            - predicate: had_second_partner == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
          codeBlock: |
            if q426_third_partner.outcome == 1:
                had_third_partner = 1

        - id: q427_condom_3rd
          kind: Question
          title: "The last time you had sexual intercourse with this third person, was a condom used?"
          precondition:
            - predicate: had_third_partner == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: q428_relationship_3
          kind: Question
          title: "What was your relationship to this third person with whom you had sexual intercourse?"
          precondition:
            - predicate: had_third_partner == 1
          input:
            control: Radio
            labels:
              1: "Wife"
              2: "Live-in partner"
              3: "Girlfriend not living with respondent"
              4: "Casual acquaintance"
              5: "Client/sex worker"
              6: "Other"

        - id: q429_total_partners
          kind: Question
          title: "In total, with how many different people have you had sexual intercourse in your lifetime? (If non-numeric answer, probe to get an estimate. If number of partners is 95 or more, record 95.)"
          precondition:
            - predicate: has_had_sex == 1
          input:
            control: Editbox
            min: 1
            max: 98
            right: "(98 = Don't know)"

    # =========================================================================
    # SECTION 5: FERTILITY PREFERENCES
    # =========================================================================
    - id: b_fertility
      title: "Section 5. Fertility Preferences"
      precondition:
        - predicate: consent == 1
      items:
        # CHECK 501: Currently married/living with partner -> continue; not -> 514
        # CHECK 502: Man not sterilized or question not asked -> continue; sterilized -> 514
        # CHECK 503: One wife/partner -> 504; More than one -> 509

        - id: q504_wife_pregnant
          kind: Question
          title: "Is your (wife/partner) currently pregnant?"
          precondition:
            - predicate: currently_in_union == 1
            - predicate: man_sterilized == 0
            - predicate: one_wife == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
          codeBlock: |
            if q504_wife_pregnant.outcome == 1:
                wife_pregnant = 1

        - id: q505_want_another
          kind: Question
          title: "Now I have some questions about the future. After the child you and your (wife/partner) are expecting now, would you like to have another child, or would you prefer not to have any more children?"
          precondition:
            - predicate: wife_pregnant == 1
          input:
            control: Radio
            labels:
              1: "Have another child"
              2: "No more"
              8: "Undecided/Don't know"

        - id: q506_wait_time
          kind: Question
          title: "After the birth of the child you are expecting now, how long would you like to wait before the birth of another child?"
          precondition:
            - predicate: q505_want_another.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 998
            right: "(Months=value if unit months; 993=Soon/Now; 996=Other; 998=Don't know)"

        # Q507: CHECK 208 - has fathered / has not fathered
        - id: q507_want_child
          kind: Question
          title: "Now I have some questions about the future. Would you like to have (a/another) child, or would you prefer not to have any (more) children?"
          precondition:
            - predicate: currently_in_union == 1
            - predicate: man_sterilized == 0
            - predicate: wife_pregnant == 0
            - predicate: one_wife == 1
          input:
            control: Radio
            labels:
              1: "Have (a/another) child"
              2: "No more/None"
              3: "Says couple can't get pregnant"
              4: "Wife/partner sterilized"
              5: "Respondent sterilized"
              8: "Undecided/Don't know"
          # Note: Q507 option 5 (respondent sterilized) is informational here;
          # man_sterilized is set from Q418 (contraception method used)

        - id: q508_wait_time2
          kind: Question
          title: "How long would you like to wait from now before the birth of (a/another) child?"
          precondition:
            - predicate: q507_want_child.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 998
            right: "(Months=value; 993=Soon/Now; 994=Can't get pregnant; 996=Other; 998=Don't know)"

        # Q509: Multiple wives/partners
        - id: q509_any_wife_pregnant
          kind: Question
          title: "Are any of your wives or partners currently pregnant?"
          precondition:
            - predicate: currently_in_union == 1
            - predicate: man_sterilized == 0
            - predicate: one_wife == 0
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
          codeBlock: |
            if q509_any_wife_pregnant.outcome == 1:
                wife_pregnant_multi = 1

        - id: q510_want_another_multi
          kind: Question
          title: "Now I have some questions about the future. After the child you and your wife or partner are expecting now, would you like to have another child, or would you prefer not to have any more children?"
          precondition:
            - predicate: wife_pregnant_multi == 1
          input:
            control: Radio
            labels:
              1: "Have another child"
              2: "No more"
              8: "Undecided/Don't know"

        - id: q511_wait_time_multi
          kind: Question
          title: "After the birth of the child you are expecting now, how long would you like to wait before the birth of another child?"
          precondition:
            - predicate: q510_want_another_multi.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 998

        - id: q512_want_child_multi
          kind: Question
          title: "Now I have some questions about the future. Would you like to have (a/another) child, or would you prefer not to have any (more) children?"
          precondition:
            - predicate: currently_in_union == 1
            - predicate: man_sterilized == 0
            - predicate: one_wife == 0
            - predicate: wife_pregnant_multi == 0
          input:
            control: Radio
            labels:
              1: "Have (a/another) child"
              2: "No more/None"
              3: "Says couple can't get pregnant"
              4: "Wife/wives/partner(s) sterilized"
              5: "Respondent sterilized"
              8: "Undecided/Don't know"

        - id: q513_wait_time_multi2
          kind: Question
          title: "How long would you like to wait from now before the birth of (a/another) child?"
          precondition:
            - predicate: q512_want_child_multi.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 998

        # Q514: Ideal number of children
        - id: q514_ideal_children
          kind: Question
          title: "If you could go back to the time you did not have any children and could choose exactly the number of children to have in your whole life, how many would that be? (If no living children: If you could choose exactly the number of children to have in your whole life, how many would that be?) (Probe for a numeric response. Record 00 for None.)"
          precondition:
            - predicate: currently_in_union == 1 or formerly_in_union == 1 or q402_ever_married.outcome == 3
          input:
            control: Editbox
            min: 0
            max: 96
            right: "(96 = Other/non-numeric)"
          codeBlock: |
            ideal_children_response = q514_ideal_children.outcome

        - id: q515_boys
          kind: Question
          title: "How many of these children would you like to be boys?"
          precondition:
            - predicate: ideal_children_response >= 1
            - predicate: ideal_children_response <= 95
          input:
            control: Editbox
            min: 0
            max: 95

        - id: q515_girls
          kind: Question
          title: "How many of these children would you like to be girls?"
          precondition:
            - predicate: ideal_children_response >= 1
            - predicate: ideal_children_response <= 95
          input:
            control: Editbox
            min: 0
            max: 95

        - id: q515_either
          kind: Question
          title: "For how many would it not matter if it's a boy or a girl?"
          precondition:
            - predicate: ideal_children_response >= 1
            - predicate: ideal_children_response <= 95
          input:
            control: Editbox
            min: 0
            max: 95

    # =========================================================================
    # SECTION 6: EMPLOYMENT AND GENDER ROLES
    # =========================================================================
    - id: b_employment
      title: "Section 6. Employment and Gender Roles"
      precondition:
        - predicate: consent == 1
      items:
        - id: q601_work_7days
          kind: Question
          title: "Have you done any work in the last 7 days?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
          codeBlock: |
            if q601_work_7days.outcome == 1:
                worked_last_7_days = 1

        - id: q602_absent
          kind: Question
          title: "Although you did not work in the last 7 days, do you have any job or business from which you were absent for leave, illness, vacation, or any other such reason?"
          precondition:
            - predicate: q601_work_7days.outcome == 2
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
          codeBlock: |
            if q602_absent.outcome == 1:
                absent_from_job = 1

        - id: q603_work_12months
          kind: Question
          title: "Have you done any work in the last 12 months?"
          precondition:
            - predicate: q601_work_7days.outcome == 2
            - predicate: absent_from_job == 0
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
          codeBlock: |
            if q603_work_12months.outcome == 1:
                worked_last_12_months = 1

        - id: q604_occupation
          kind: Question
          title: "What is your occupation? That is, what kind of work do you mainly do?"
          precondition:
            - predicate: worked_last_7_days == 1 or absent_from_job == 1 or worked_last_12_months == 1
          input:
            control: Editbox
            min: 1
            max: 99

        - id: q605_work_frequency
          kind: Question
          title: "Do you usually work throughout the year, or do you work seasonally, or only once in a while?"
          precondition:
            - predicate: worked_last_7_days == 1 or absent_from_job == 1 or worked_last_12_months == 1
          input:
            control: Radio
            labels:
              1: "Throughout the year"
              2: "Seasonally/Part of the year"
              3: "Once in a while"

        - id: q606_payment
          kind: Question
          title: "Are you paid in cash or kind for this work or are you not paid at all?"
          precondition:
            - predicate: worked_last_7_days == 1 or absent_from_job == 1 or worked_last_12_months == 1
          input:
            control: Radio
            labels:
              1: "Cash only"
              2: "Cash and kind"
              3: "In kind only"
              4: "Not paid"
          codeBlock: |
            if q606_payment.outcome in [1, 2]:
                earns_cash = 1

        # CHECK 607: Currently married or living with partner -> continue; not -> 612
        - id: q608_comment
          kind: Comment
          title: "CHECK 606: Code 1 or 2 circled (earns cash) -> ask Q609. Otherwise -> skip to Q610."
          precondition:
            - predicate: currently_in_union == 1
            - predicate: worked_last_7_days == 1 or absent_from_job == 1 or worked_last_12_months == 1

        - id: q609_spending
          kind: Question
          title: "Who usually decides how the money you earn will be used: you, your (wife/partner), or you and your (wife/partner) jointly?"
          precondition:
            - predicate: currently_in_union == 1
            - predicate: earns_cash == 1
          input:
            control: Radio
            labels:
              1: "Respondent"
              2: "Wife/Partner"
              3: "Respondent and wife/partner jointly"
              6: "Other"

        - id: q610_healthcare
          kind: Question
          title: "Who usually makes decisions about health care for yourself: you, your (wife/partner), you and your (wife/partner) jointly, or someone else?"
          precondition:
            - predicate: currently_in_union == 1
          input:
            control: Radio
            labels:
              1: "Respondent"
              2: "Wife/Partner"
              3: "Respondent and wife/partner jointly"
              4: "Someone else"
              6: "Other"

        - id: q611_purchases
          kind: Question
          title: "Who usually makes decisions about making major household purchases?"
          precondition:
            - predicate: currently_in_union == 1
          input:
            control: Radio
            labels:
              1: "Respondent"
              2: "Wife/Partner"
              3: "Respondent and wife/partner jointly"
              4: "Someone else"
              6: "Other"

        - id: q612_own_house
          kind: Question
          title: "Do you own this or any other house either alone or jointly with someone else?"
          input:
            control: Radio
            labels:
              1: "Alone only"
              2: "Jointly with wife/partner only"
              3: "Jointly with someone else only"
              4: "Jointly with wife/partner and someone else"
              5: "Both alone and jointly"
              6: "Does not own"
          codeBlock: |
            if q612_own_house.outcome in [1, 2, 3, 4, 5]:
                owns_house = 1

        - id: q613_house_title
          kind: Question
          title: "Do you have a title deed or other government recognized document for any house you own?"
          precondition:
            - predicate: owns_house == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q614_house_name
          kind: Question
          title: "Is your name on this document?"
          precondition:
            - predicate: q613_house_title.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q615_own_land
          kind: Question
          title: "Do you own any agricultural or non-agricultural land either alone or jointly with someone else?"
          input:
            control: Radio
            labels:
              1: "Alone only"
              2: "Jointly with wife/partner only"
              3: "Jointly with someone else only"
              4: "Jointly with wife/partner and someone else"
              5: "Both alone and jointly"
              6: "Does not own"
          codeBlock: |
            if q615_own_land.outcome in [1, 2, 3, 4, 5]:
                owns_land = 1

        - id: q616_land_title
          kind: Question
          title: "Do you have a title deed or other government recognized document for any land you own?"
          precondition:
            - predicate: owns_land == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q617_land_name
          kind: Question
          title: "Is your name on this document?"
          precondition:
            - predicate: q616_land_title.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q617a_bank
          kind: Question
          title: "Do you have an account in a bank or other financial institution that you yourself use?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
          codeBlock: |
            if q617a_bank.outcome == 1:
                has_bank_account = 1

        - id: q617b_bank_use
          kind: Question
          title: "Did you yourself put money in or take money out of this account in the last 12 months?"
          precondition:
            - predicate: q617a_bank.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: q617c_mobile_money
          kind: Question
          title: "In the last 12 months, have you used a mobile phone to make financial transactions such as sending or receiving money, paying bills, purchasing goods or services, or receiving wages?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: q618a_beating_goesout
          kind: Question
          title: "In your opinion, is a husband justified in hitting or beating his wife in the following situations: a) If she goes out without telling him?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q618b_beating_neglects
          kind: Question
          title: "b) If she neglects the children?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q618c_beating_argues
          kind: Question
          title: "c) If she argues with him?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q618d_beating_refusessex
          kind: Question
          title: "d) If she refuses to have sex with him?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q618e_beating_burnsfood
          kind: Question
          title: "e) If she burns the food?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q619_father_beat
          kind: Question
          title: "As far as you know did your father ever beat your mother?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

    # =========================================================================
    # SECTION 7: HIV/AIDS
    # =========================================================================
    - id: b_hiv
      title: "Section 7. HIV/AIDS"
      precondition:
        - predicate: consent == 1
      items:
        - id: q700_intro
          kind: Comment
          title: "Now I would like to talk about HIV and AIDS."

        - id: q701_heard_hiv
          kind: Question
          title: "Have you ever heard of HIV or AIDS?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
          codeBlock: |
            if q701_heard_hiv.outcome == 1:
                heard_hiv = 1

        # CHECK 702: age 15-24 -> ask 703-707; 25+ -> skip to 708
        - id: q703_reduce_risk
          kind: Question
          title: "HIV is the virus that can lead to AIDS. Can people reduce their chance of getting HIV by having just one uninfected sex partner who has no other sex partners?"
          precondition:
            - predicate: heard_hiv == 1
            - predicate: is_young == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q704_mosquito
          kind: Question
          title: "Can people get HIV from mosquito bites?"
          precondition:
            - predicate: heard_hiv == 1
            - predicate: is_young == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q705_condom_reduce
          kind: Question
          title: "Can people reduce their chance of getting HIV by using a condom every time they have sex?"
          precondition:
            - predicate: heard_hiv == 1
            - predicate: is_young == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q706_sharing_food
          kind: Question
          title: "Can people get HIV by sharing food with a person who has HIV?"
          precondition:
            - predicate: heard_hiv == 1
            - predicate: is_young == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q707_healthy_person
          kind: Question
          title: "Is it possible for a healthy-looking person to have HIV?"
          precondition:
            - predicate: heard_hiv == 1
            - predicate: is_young == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q708_heard_arvs
          kind: Question
          title: "Have you heard of ARVs, that is, antiretroviral medicines that treat HIV?"
          precondition:
            - predicate: heard_hiv == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: q709_pmtct
          kind: Question
          title: "Are there any special medicines that a doctor or a nurse can give to a woman infected with HIV to reduce the risk of transmission to the baby?"
          precondition:
            - predicate: heard_hiv == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q710_prep
          kind: Question
          title: "Have you heard of PrEP, a medicine taken daily that can prevent a person from getting HIV?"
          precondition:
            - predicate: heard_hiv == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: q711_approve_prep
          kind: Question
          title: "Do you approve of people who take a pill every day to prevent getting HIV?"
          precondition:
            - predicate: q710_prep.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know/Not sure/Depends"

        - id: q712_privacy2
          kind: Comment
          title: "CHECK FOR PRESENCE OF OTHERS. BEFORE CONTINUING, MAKE EVERY EFFORT TO ENSURE PRIVACY."

        - id: q713_tested_hiv
          kind: Question
          title: "Have you ever been tested for HIV?"
          precondition:
            - predicate: heard_hiv == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
          codeBlock: |
            if q713_tested_hiv.outcome == 1:
                hiv_tested = 1

        - id: q714_test_month
          kind: Question
          title: "In what month and year was your most recent HIV test? Month:"
          precondition:
            - predicate: hiv_tested == 1
          input:
            control: Editbox
            min: 1
            max: 98

        - id: q714_test_year
          kind: Question
          title: "Year of most recent HIV test:"
          precondition:
            - predicate: hiv_tested == 1
          input:
            control: Editbox
            min: 1990
            max: 9998

        - id: q715_test_place
          kind: Question
          title: "Where was the test done?"
          precondition:
            - predicate: hiv_tested == 1
          input:
            control: Dropdown
            labels:
              11: "Government hospital"
              12: "Government health center"
              13: "Stand-alone HTC center"
              14: "Family planning clinic"
              15: "Mobile HTC services"
              16: "Other public sector"
              21: "Private hospital"
              22: "Private clinic"
              23: "Private doctor"
              24: "Stand-alone HTC center (private)"
              25: "Pharmacy"
              26: "Mobile HTC services (private)"
              27: "Other private medical sector"
              31: "NGO hospital"
              32: "NGO clinic"
              36: "Other NGO medical sector"
              41: "Home"
              42: "Workplace"
              43: "Correctional facility"
              96: "Other"

        - id: q716_got_results
          kind: Question
          title: "Did you get the results of the test?"
          precondition:
            - predicate: hiv_tested == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
          codeBlock: |
            if q716_got_results.outcome == 1:
                got_results = 1

        - id: q717_test_result
          kind: Question
          title: "What was the result of the test?"
          precondition:
            - predicate: got_results == 1
          input:
            control: Radio
            labels:
              1: "Positive"
              2: "Negative"
              3: "Indeterminate"
              4: "Declined to answer"
          codeBlock: |
            if q717_test_result.outcome == 1:
                hiv_positive = 1

        - id: q718_first_positive_month
          kind: Question
          title: "In what month and year did you receive your first HIV-positive test result? Month:"
          precondition:
            - predicate: hiv_positive == 1
          input:
            control: Editbox
            min: 1
            max: 98

        - id: q718_first_positive_year
          kind: Question
          title: "Year of first HIV-positive test result:"
          precondition:
            - predicate: hiv_positive == 1
          input:
            control: Editbox
            min: 1990
            max: 9998

        - id: q719_taking_arvs
          kind: Question
          title: "Are you currently taking ARVs, that is antiretroviral medicines? (By currently, I mean that you may have missed some doses but you are still taking ARVs.)"
          precondition:
            - predicate: hiv_positive == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q720_times_tested
          kind: Question
          title: "How many times have you been tested for HIV in your lifetime? (If non-numeric answer, probe to get an estimate. If number of tests is 95 or more, record 95.)"
          precondition:
            - predicate: hiv_tested == 1
          input:
            control: Editbox
            min: 1
            max: 95

        - id: q721_self_test
          kind: Question
          title: "Have you heard of test kits people can use to test themselves for HIV?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
          codeBlock: |
            if q721_self_test.outcome == 1:
                heard_self_test = 1

        - id: q722_used_self_test
          kind: Question
          title: "Have you ever tested yourself for HIV using a self-test kit?"
          precondition:
            - predicate: heard_self_test == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: q723_buy_vegetables
          kind: Question
          title: "Would you buy fresh vegetables from a shopkeeper or vendor if you knew that this person had HIV?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know/Not sure/Depends"

        - id: q724_children_school
          kind: Question
          title: "Do you think children living with HIV should be allowed to attend school with children who do not have HIV?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know/Not sure/Depends"

        # CHECK 725: Q717 code 1 (positive) -> continue; other -> 729
        - id: q726_disclosed
          kind: Question
          title: "Now I would like to ask you a few questions about your experiences living with HIV. Have you disclosed your HIV status to anyone other than me?"
          precondition:
            - predicate: hiv_positive == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: q727_ashamed
          kind: Question
          title: "Do you agree or disagree with the following statement: I have felt ashamed because of my HIV status."
          precondition:
            - predicate: hiv_positive == 1
          input:
            control: Radio
            labels:
              1: "Agree"
              2: "Disagree"

        - id: q728a_people_talk
          kind: Question
          title: "Please tell me if the following things have happened to you, or if you think they have happened to you, because of your HIV status in the last 12 months: a) People have talked badly about me because of my HIV status."
          precondition:
            - predicate: hiv_positive == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: q728b_disclosed_others
          kind: Question
          title: "b) Someone else disclosed my HIV status without my permission."
          precondition:
            - predicate: hiv_positive == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: q728c_verbally_insulted
          kind: Question
          title: "c) I have been verbally insulted, harassed, or threatened because of my HIV status."
          precondition:
            - predicate: hiv_positive == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: q728d_healthcare_talk
          kind: Question
          title: "d) Healthcare workers talked badly about me because of my HIV status."
          precondition:
            - predicate: hiv_positive == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: q728e_healthcare_abuse
          kind: Question
          title: "e) Healthcare workers yelled at me, scolded me, called me names, or verbally abused me in another way because of my HIV status."
          precondition:
            - predicate: hiv_positive == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # Q729: CHECK 701 - heard about HIV -> version a; not -> version b
        - id: q729_heard_sti
          kind: Question
          title: "Apart from HIV, have you heard about other infections that can be transmitted through sexual contact? (If not heard of HIV: Have you heard about infections that can be transmitted through sexual contact?)"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
          codeBlock: |
            if q729_heard_sti.outcome == 1:
                heard_sti = 1

        # CHECK 730: Q414 has had sexual intercourse -> continue; never -> 735
        - id: q731_check
          kind: Comment
          title: "CHECK 729: Heard about other sexually transmitted infections?"
          precondition:
            - predicate: has_had_sex == 1

        - id: q732_had_sti
          kind: Question
          title: "Now I would like to ask you some questions about your health in the last 12 months. During the last 12 months, have you had a disease which you got through sexual contact?"
          precondition:
            - predicate: has_had_sex == 1
            - predicate: heard_sti == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q733_discharge
          kind: Question
          title: "Sometimes men experience an abnormal discharge from their penis. During the last 12 months, have you had an abnormal discharge from your penis?"
          precondition:
            - predicate: has_had_sex == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q734_sore
          kind: Question
          title: "Sometimes men have a sore or ulcer on or near their penis. During the last 12 months, have you had a sore or ulcer on or near your penis?"
          precondition:
            - predicate: has_had_sex == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q735_condom_sti
          kind: Question
          title: "If a wife knows her husband has a disease that she can get during sexual intercourse, is she justified in asking that they use a condom when they have sex?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q736_refuse_sex
          kind: Question
          title: "Is a wife justified in refusing to have sex with her husband when she knows he has sex with other women?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

    # =========================================================================
    # SECTION 8: OTHER HEALTH ISSUES
    # =========================================================================
    - id: b_health
      title: "Section 8. Other Health Issues"
      precondition:
        - predicate: consent == 1
      items:
        - id: q801_circumcised
          kind: Question
          title: "Some men are circumcised. Are you circumcised?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
          codeBlock: |
            if q801_circumcised.outcome == 1:
                circumcised_yes = 1

        - id: q802_trad_circumcised
          kind: Question
          title: "Some men are traditionally circumcised by a traditional practitioner, family member or friend. Are you traditionally circumcised?"
          precondition:
            - predicate: circumcised_yes == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
          codeBlock: |
            if q802_trad_circumcised.outcome == 1:
                trad_circumcised = 1

        - id: q803_trad_age
          kind: Question
          title: "How old were you when you got traditionally circumcised? (95 = During childhood, less than 5 years; 98 = Don't know)"
          precondition:
            - predicate: trad_circumcised == 1
          input:
            control: Editbox
            min: 0
            max: 98

        - id: q804_med_circumcised
          kind: Question
          title: "Some men are medically circumcised, that is, the foreskin is completely removed from the penis by a healthcare worker. Are you medically circumcised?"
          precondition:
            - predicate: circumcised_yes == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
          codeBlock: |
            if q804_med_circumcised.outcome == 1:
                med_circumcised = 1

        - id: q805_med_age
          kind: Question
          title: "How old were you when you got medically circumcised? (95 = During childhood, less than 5 years; 98 = Don't know)"
          precondition:
            - predicate: med_circumcised == 1
          input:
            control: Editbox
            min: 0
            max: 98

        - id: q806_smoke_current
          kind: Question
          title: "Do you currently smoke tobacco every day, some days, or not at all?"
          input:
            control: Radio
            labels:
              1: "Every day"
              2: "Some days"
              3: "Not at all"
          codeBlock: |
            if q806_smoke_current.outcome in [1, 2]:
                smokes_currently = 1
            if q806_smoke_current.outcome == 1:
                smokes_every_day = 1
            if q806_smoke_current.outcome == 2:
                smokes_some_days = 1

        # Q807: Asked when Q806=2 (some days). Q806=1 skips to Q809, Q806=3 skips to Q808.
        - id: q807_smoked_daily_past
          kind: Question
          title: "In the past, have you smoked tobacco every day?"
          precondition:
            - predicate: q806_smoke_current.outcome == 2
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
          codeBlock: |
            if q807_smoked_daily_past.outcome == 1:
                smoked_past_daily = 1

        # Q808: Asked when Q806=3 (not at all) OR when Q806=2 and Q807=2 (some days but not past daily)
        - id: q808_smoked_past
          kind: Question
          title: "In the past, have you ever smoked tobacco every day, some days, or not at all?"
          precondition:
            - predicate: q806_smoke_current.outcome == 3 or (smokes_some_days == 1 and smoked_past_daily == 0)
          input:
            control: Radio
            labels:
              1: "Every day"
              2: "Some days"
              3: "Not at all"

        # Q809: For those who smoke every day (Q806=1). Daily product counts.
        - id: q809a_mfg_cigarettes
          kind: Question
          title: "On average, how many manufactured cigarettes do you currently smoke each day? (If the product is used but not every day, record 888. If the product is not used at all, record 000.)"
          precondition:
            - predicate: smokes_every_day == 1
          input:
            control: Editbox
            min: 0
            max: 888

        - id: q809b_handrolled
          kind: Question
          title: "Hand-rolled cigarettes per day?"
          precondition:
            - predicate: smokes_every_day == 1
          input:
            control: Editbox
            min: 0
            max: 888

        - id: q809c_kreteks
          kind: Question
          title: "Kreteks per day?"
          precondition:
            - predicate: smokes_every_day == 1
          input:
            control: Editbox
            min: 0
            max: 888

        - id: q809d_pipes
          kind: Question
          title: "Pipes full of tobacco per day?"
          precondition:
            - predicate: smokes_every_day == 1
          input:
            control: Editbox
            min: 0
            max: 888

        - id: q809e_cigars
          kind: Question
          title: "Cigars, cheroots, or cigarillos per day?"
          precondition:
            - predicate: smokes_every_day == 1
          input:
            control: Editbox
            min: 0
            max: 888

        - id: q809f_waterpipe
          kind: Question
          title: "Number of water pipe sessions per day?"
          precondition:
            - predicate: smokes_every_day == 1
          input:
            control: Editbox
            min: 0
            max: 888

        - id: q809g_others
          kind: Question
          title: "Any other smoked tobacco products per day?"
          precondition:
            - predicate: smokes_every_day == 1
          input:
            control: Editbox
            min: 0
            max: 888

        # Q810: For those who currently smoke some days (Q806=2) and smoked daily in the past (Q807=1)
        - id: q810a_mfg_weekly
          kind: Question
          title: "On average, how many manufactured cigarettes do you currently smoke each week?"
          precondition:
            - predicate: smoked_past_daily == 1
          input:
            control: Editbox
            min: 0
            max: 888

        - id: q810b_handrolled_weekly
          kind: Question
          title: "Hand-rolled cigarettes per week?"
          precondition:
            - predicate: smoked_past_daily == 1
          input:
            control: Editbox
            min: 0
            max: 888

        - id: q810c_kreteks_weekly
          kind: Question
          title: "Kreteks per week?"
          precondition:
            - predicate: smoked_past_daily == 1
          input:
            control: Editbox
            min: 0
            max: 888

        - id: q810d_pipes_weekly
          kind: Question
          title: "Pipes full of tobacco per week?"
          precondition:
            - predicate: smoked_past_daily == 1
          input:
            control: Editbox
            min: 0
            max: 888

        - id: q810e_cigars_weekly
          kind: Question
          title: "Cigars, cheroots, or cigarillos per week?"
          precondition:
            - predicate: smoked_past_daily == 1
          input:
            control: Editbox
            min: 0
            max: 888

        - id: q810f_waterpipe_weekly
          kind: Question
          title: "Number of water pipe sessions per week?"
          precondition:
            - predicate: smoked_past_daily == 1
          input:
            control: Editbox
            min: 0
            max: 888

        - id: q810g_others_weekly
          kind: Question
          title: "Any other smoked tobacco products per week?"
          precondition:
            - predicate: smoked_past_daily == 1
          input:
            control: Editbox
            min: 0
            max: 888

        - id: q811_smokeless
          kind: Question
          title: "Do you currently use smokeless tobacco every day, some days, or not at all?"
          input:
            control: Radio
            labels:
              1: "Every day"
              2: "Some days"
              3: "Not at all"
          codeBlock: |
            if q811_smokeless.outcome in [1, 2]:
                uses_smokeless = 1
            if q811_smokeless.outcome == 1:
                uses_smokeless_daily = 1

        # Q812: For those who use smokeless every day (Q811=1). Daily counts.
        - id: q812a_snuff_mouth
          kind: Question
          title: "On average, how many times a day do you use snuff, by mouth?"
          precondition:
            - predicate: uses_smokeless_daily == 1
          input:
            control: Editbox
            min: 0
            max: 888

        - id: q812b_snuff_nose
          kind: Question
          title: "Snuff, by nose (times per day)?"
          precondition:
            - predicate: uses_smokeless_daily == 1
          input:
            control: Editbox
            min: 0
            max: 888

        - id: q812c_chewing
          kind: Question
          title: "Chewing tobacco (times per day)?"
          precondition:
            - predicate: uses_smokeless_daily == 1
          input:
            control: Editbox
            min: 0
            max: 888

        - id: q812d_betel
          kind: Question
          title: "Betel quid with tobacco (times per day)?"
          precondition:
            - predicate: uses_smokeless_daily == 1
          input:
            control: Editbox
            min: 0
            max: 888

        - id: q812e_other_smokeless
          kind: Question
          title: "Any other smokeless tobacco products (times per day)?"
          precondition:
            - predicate: uses_smokeless_daily == 1
          input:
            control: Editbox
            min: 0
            max: 888

        # Q813: For those who use smokeless some days (Q811=2). Weekly counts.
        - id: q813a_snuff_mouth_weekly
          kind: Question
          title: "On average, how many times a week do you use snuff, by mouth?"
          precondition:
            - predicate: q811_smokeless.outcome == 2
          input:
            control: Editbox
            min: 0
            max: 888

        - id: q813b_snuff_nose_weekly
          kind: Question
          title: "Snuff, by nose (times per week)?"
          precondition:
            - predicate: q811_smokeless.outcome == 2
          input:
            control: Editbox
            min: 0
            max: 888

        - id: q813c_chewing_weekly
          kind: Question
          title: "Chewing tobacco (times per week)?"
          precondition:
            - predicate: q811_smokeless.outcome == 2
          input:
            control: Editbox
            min: 0
            max: 888

        - id: q813d_betel_weekly
          kind: Question
          title: "Betel quid with tobacco (times per week)?"
          precondition:
            - predicate: q811_smokeless.outcome == 2
          input:
            control: Editbox
            min: 0
            max: 888

        - id: q813e_other_smokeless_weekly
          kind: Question
          title: "Any other smokeless tobacco products (times per week)?"
          precondition:
            - predicate: q811_smokeless.outcome == 2
          input:
            control: Editbox
            min: 0
            max: 888

        - id: q814_ever_alcohol
          kind: Question
          title: "Now I would like to ask you some questions about drinking alcohol. Have you ever consumed any alcohol, such as beer, wine, spirits, or [ADD OTHER LOCAL EXAMPLES]?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
          codeBlock: |
            if q814_ever_alcohol.outcome == 1:
                ever_drank_alcohol = 1

        - id: q815_days_drank
          kind: Question
          title: "During the last one month, on how many days did you have an alcoholic drink? (If non-numeric answer, probe to get an estimate. If respondent answers 'every day' or 'almost every day', code 95. Record 00 if did not have even one drink.)"
          precondition:
            - predicate: ever_drank_alcohol == 1
          input:
            control: Editbox
            min: 0
            max: 95

        - id: q816_drinks_per_day
          kind: Question
          title: "We count one drink of alcohol as one can or bottle of beer, one glass of wine, one shot of spirits, or one cup of [ADD OTHER LOCAL EXAMPLES]. In the last one month, on the days that you drank alcohol, how many drinks did you usually have per day?"
          precondition:
            - predicate: ever_drank_alcohol == 1
            - predicate: q815_days_drank.outcome >= 1
          input:
            control: Editbox
            min: 1
            max: 95

        - id: q817_insurance
          kind: Question
          title: "Are you covered by any health insurance?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
          codeBlock: |
            if q817_insurance.outcome == 1:
                has_insurance = 1

        - id: q818_insurance_type
          kind: Question
          title: "What type of health insurance are you covered by? (Record all mentioned.)"
          precondition:
            - predicate: has_insurance == 1
          input:
            control: Checkbox
            labels:
              1: "Mutual health organization/Community-based health insurance"
              2: "Health insurance through employer"
              4: "Social security"
              8: "Other privately purchased commercial health insurance"
              16: "Other"

        - id: q819_end_hours
          kind: Question
          title: "Record the time. Hours:"
          input:
            control: Editbox
            min: 0
            max: 23

        - id: q819_end_minutes
          kind: Question
          title: "Record the time. Minutes:"
          input:
            control: Editbox
            min: 0
            max: 59
