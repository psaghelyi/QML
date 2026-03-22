qmlVersion: "1.0"
questionnaire:
  title: "DHS-8 Model Woman's Questionnaire"
  codeInit: |
    # Consent
    consent = 0
    # Section 1 classification
    born_outside = 0
    years_residence = 0
    short_residence = 0
    attended_school = 0
    education_level = 0
    literacy = 0
    owns_mobile = 0
    used_internet = 0
    used_internet_12m = 0
    # Section 2 classification
    ever_given_birth = 0
    sons_at_home = 0
    daughters_at_home = 0
    sons_elsewhere = 0
    daughters_elsewhere = 0
    boys_dead = 0
    girls_dead = 0
    total_live_births = 0
    has_children_living = 0
    ever_had_loss = 0
    pregnancy_losses = 0
    total_pregnancies = 0
    has_past_pregnancies = 0
    is_pregnant = 0
    last_period_code = 0
    period_within_year = 0
    # Section 3 classification
    using_method = 0
    sterilized = 0
    current_method = 0
    ever_used_method = 0
    last_method = 0
    told_side_effects = 0
    method_is_injectable = 0
    method_is_pill = 0
    method_is_condom = 0
    method_is_sterilization = 0
    method_needs_source = 0
    # Section 4 classification
    has_recent_pregnancy = 0
    preg_outcome_type = 0
    had_anc = 0
    delivery_place = 0
    is_most_recent_lb = 0
    facility_birth = 0
    had_health_check_mother = 0
    child_alive = 0
    ever_breastfed = 0
    is_last_pregnancy = 0
    preg_is_birth = 0
    tetanus_given = 0
    tetanus_times_val = 0
    iron_given = 0
    malaria_sp_given = 0
    newborn_check_facility = 0
    post_facility_check_mother = 0
    post_facility_check_baby = 0
    home_birth_check_mother = 0
    home_birth_check_baby = 0
    # Section 5 classification
    has_surviving_child_035 = 0
    has_vacc_card = 0
    card_seen = 0
    all_vacc_on_card = 0
    vacc_on_card = 0
    ever_had_vacc_card = 0
    received_any_vacc = 0
    received_hepb = 0
    received_polio = 0
    received_pentavalent = 0
    received_pneumo = 0
    received_rotavirus = 0
    received_measles = 0
    # Section 6 classification
    has_surviving_child_059 = 0
    child_had_diarrhea = 0
    sought_diarrhea_advice = 0
    child_had_fever = 0
    child_had_cough = 0
    sought_fever_advice = 0
    child_took_medicine = 0
    act_given = 0
    has_youngest_child_023 = 0
    # Section 7 classification
    marital_status = 0
    currently_in_union = 0
    ever_in_union = 0
    married_more_than_once = 0
    has_other_wives = 0
    ever_had_sex = 0
    last_sex_unit = 0
    not_pregnant = 0
    used_method_last_sex = 0
    used_condom_last = 0
    had_second_partner = 0
    had_third_partner = 0
    has_marriage_doc = 0
    # Section 8 classification
    wants_more = 0
    ideal_number = 0
    # Section 9 classification
    husband_attended_school = 0
    husband_worked = 0
    respondent_worked = 0
    paid_for_work = 0
    owns_house = 0
    owns_land = 0
    has_bank_account = 0
    has_house_title = 0
    has_land_title = 0
    # Section 10 classification
    heard_hiv = 0
    age_group_hiv = 0
    heard_prep = 0
    last_lb_023 = 0
    had_anc_for_last = 0
    tested_hiv_anc = 0
    tested_hiv_delivery = 0
    tested_hiv_ever = 0
    hiv_result = 0
    heard_self_test = 0
    hiv_positive = 0
    heard_sti = 0
    is_young_woman = 0
    got_hiv_test_results = 0
    tested_hiv_pregnancy = 0
    facility_birth_last = 0
    tested_hiv_since_preg = 0
    # Section 11 classification
    smokes = 0
    uses_other_tobacco = 0
    ever_drank_alcohol = 0
    drank_recently = 0
    has_insurance = 0

  blocks:
    # =========================================================================
    # INTRODUCTION AND CONSENT
    # =========================================================================
    - id: b_consent
      title: "Introduction and Consent"
      items:
        - id: q_intro
          kind: Comment
          title: "Hello. My name is ___. I am working with [NAME OF ORGANIZATION]. We are conducting a survey about health and other topics all over [NAME OF COUNTRY]. The information we collect will help the government to plan health services. Your household was selected for the survey. The questions usually take about 30 to 60 minutes. All of the answers you give will be confidential. You don't have to be in the survey, but we hope you will agree to answer the questions since your views are important."

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
        - id: q102_birthplace
          kind: Question
          title: "What [PROVINCE/REGION/STATE] were you born in?"
          input:
            control: Radio
            labels:
              1: "Province/Region/State 1"
              2: "Province/Region/State 2"
              3: "Province/Region/State 3"
              96: "Outside of country"
          codeBlock: |
            if q102_birthplace.outcome == 96:
                born_outside = 1

        - id: q103_birth_country
          kind: Question
          title: "What country were you born in?"
          precondition:
            - predicate: q102_birthplace.outcome == 96
          input:
            control: Editbox
            min: 1
            max: 999

        - id: q104_residence_years
          kind: Question
          title: "How long have you been living continuously in (NAME OF CURRENT CITY, TOWN OR VILLAGE OF RESIDENCE)? If less than one year, record '00' years."
          input:
            control: Radio
            labels:
              0: "Less than 1 year"
              1: "1 year"
              2: "2 years"
              3: "3 years"
              4: "4 years"
              5: "5 years"
              6: "6-10 years"
              7: "11-20 years"
              8: "21+ years"
              95: "Always"
              96: "Visitor"
          codeBlock: |
            if q104_residence_years.outcome in [95, 96]:
                years_residence = 95
            elif q104_residence_years.outcome >= 5:
                years_residence = 5
            else:
                years_residence = q104_residence_years.outcome
            if q104_residence_years.outcome in [0, 1, 2, 3, 4]:
                short_residence = 1

        - id: q106_move_month
          kind: Question
          title: "In what month and year did you move here? (Record month 1-12, or 98 for don't know month)"
          precondition:
            - predicate: short_residence == 1
            - predicate: q104_residence_years.outcome not in [95, 96]
          input:
            control: Editbox
            min: 1
            max: 98

        - id: q107_prev_region
          kind: Question
          title: "Just before you moved here, which [PROVINCE/REGION/STATE] did you live in?"
          precondition:
            - predicate: q104_residence_years.outcome not in [95, 96]
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
            - predicate: q104_residence_years.outcome not in [95, 96]
          input:
            control: Radio
            labels:
              1: "City"
              2: "Town"
              3: "Rural area"

        - id: q109_move_reason
          kind: Question
          title: "Why did you move to this place?"
          precondition:
            - predicate: q104_residence_years.outcome not in [95, 96]
          input:
            control: Dropdown
            labels:
              1: "Employment"
              2: "Education/Training"
              3: "Marriage formation"
              4: "Family reunification/Other family-related reason"
              5: "Forced displacement"
              96: "Other"

        - id: q110_birth_month_year
          kind: Question
          title: "In what month and year were you born? (Record month 1-12, or 98 for don't know)"
          input:
            control: Editbox
            min: 1
            max: 98

        - id: q111_age
          kind: Question
          title: "How old were you at your last birthday?"
          input:
            control: Editbox
            min: 15
            max: 49
            right: "years"
          codeBlock: |
            if q111_age.outcome is not None and q111_age.outcome <= 24:
                is_young_woman = 1

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
            control: Switch
            on: "Yes"
            off: "No"
          codeBlock: |
            if q113_school.outcome == 1:
                attended_school = 1

        - id: q114_education
          kind: Question
          title: "What is the highest level of school you attended: primary, secondary, or higher?"
          precondition:
            - predicate: attended_school == 1
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
          title: "What is the highest [GRADE/FORM/YEAR] you completed at that level? If completed less than one year at that level, record '00'."
          precondition:
            - predicate: attended_school == 1
          input:
            control: Editbox
            min: 0
            max: 20

        - id: q117_literacy
          kind: Question
          title: "Now I would like you to read this sentence to me. (SHOW CARD TO RESPONDENT.)"
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
            control: Switch
            on: "Yes"
            off: "No"
          codeBlock: |
            if q122_mobile.outcome == 1:
                owns_mobile = 1

        - id: q123_smartphone
          kind: Question
          title: "Is your mobile phone a smart phone?"
          precondition:
            - predicate: owns_mobile == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q127_internet_ever
          kind: Question
          title: "Have you ever used the Internet from any location on any device?"
          input:
            control: Switch
            on: "Yes"
            off: "No"
          codeBlock: |
            if q127_internet_ever.outcome == 1:
                used_internet = 1

        - id: q128_internet_12m
          kind: Question
          title: "In the last 12 months, have you used the Internet?"
          precondition:
            - predicate: used_internet == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q129_internet_freq
          kind: Question
          title: "During the last one month, how often did you use the Internet: almost every day, at least once a week, less than once a week, or not at all?"
          precondition:
            - predicate: q128_internet_12m.outcome == 1
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
              1: "Ethnic Group 1"
              2: "Ethnic Group 2"
              3: "Ethnic Group 3"
              96: "Other"

    # =========================================================================
    # SECTION 2: REPRODUCTION
    # =========================================================================
    - id: b_reproduction
      title: "Section 2. Reproduction"
      precondition:
        - predicate: consent == 1
      items:
        - id: q201_ever_birth
          kind: Question
          title: "Now I would like to ask about all the births you have had during your life. Have you ever given birth?"
          input:
            control: Switch
            on: "Yes"
            off: "No"
          codeBlock: |
            if q201_ever_birth.outcome == 1:
                ever_given_birth = 1

        - id: q202_children_living
          kind: Question
          title: "Do you have any sons or daughters to whom you have given birth who are now living with you?"
          precondition:
            - predicate: ever_given_birth == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"
          codeBlock: |
            if q202_children_living.outcome == 1:
                has_children_living = 1

        - id: q203a_sons_home
          kind: Question
          title: "How many sons live with you? If none, record '00'."
          precondition:
            - predicate: q202_children_living.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 20
          codeBlock: |
            sons_at_home = q203a_sons_home.outcome

        - id: q203b_daughters_home
          kind: Question
          title: "And how many daughters live with you? If none, record '00'."
          precondition:
            - predicate: q202_children_living.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 20
          codeBlock: |
            daughters_at_home = q203b_daughters_home.outcome

        - id: q204_children_elsewhere
          kind: Question
          title: "Do you have any sons or daughters to whom you have given birth who are alive but do not live with you?"
          precondition:
            - predicate: ever_given_birth == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q205a_sons_elsewhere
          kind: Question
          title: "How many sons are alive but do not live with you? If none, record '00'."
          precondition:
            - predicate: ever_given_birth == 1
            - predicate: q204_children_elsewhere.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 20
          codeBlock: |
            sons_elsewhere = q205a_sons_elsewhere.outcome

        - id: q205b_daughters_elsewhere
          kind: Question
          title: "And how many daughters are alive but do not live with you? If none, record '00'."
          precondition:
            - predicate: ever_given_birth == 1
            - predicate: q204_children_elsewhere.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 20
          codeBlock: |
            daughters_elsewhere = q205b_daughters_elsewhere.outcome

        - id: q206_child_died
          kind: Question
          title: "Have you ever given birth to a boy or girl who was born alive but later died?"
          precondition:
            - predicate: ever_given_birth == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q207a_boys_dead
          kind: Question
          title: "How many boys have died? If none, record '00'."
          precondition:
            - predicate: ever_given_birth == 1
            - predicate: q206_child_died.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 20
          codeBlock: |
            boys_dead = q207a_boys_dead.outcome

        - id: q207b_girls_dead
          kind: Question
          title: "And how many girls have died? If none, record '00'."
          precondition:
            - predicate: ever_given_birth == 1
            - predicate: q206_child_died.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 20
          codeBlock: |
            girls_dead = q207b_girls_dead.outcome
            total_live_births = sons_at_home + daughters_at_home + sons_elsewhere + daughters_elsewhere + boys_dead + girls_dead

        - id: q208_total_births
          kind: Question
          title: "SUM ANSWERS TO 203, 205, AND 207 AND ENTER TOTAL. Just to confirm, your total number of live births is:"
          input:
            control: Editbox
            min: 0
            max: 30
          codeBlock: |
            total_live_births = q208_total_births.outcome

        - id: q210_pregnancy_loss
          kind: Question
          title: "Women sometimes have a pregnancy that does not result in a live birth. For example, a pregnancy can end in a miscarriage, an abortion, or the child can be born dead. Have you ever had a pregnancy that did not end in a live birth?"
          input:
            control: Switch
            on: "Yes"
            off: "No"
          codeBlock: |
            if q210_pregnancy_loss.outcome == 1:
                ever_had_loss = 1

        - id: q211_num_losses
          kind: Question
          title: "How many miscarriages, abortions, and stillbirths have you had?"
          precondition:
            - predicate: ever_had_loss == 1
          input:
            control: Editbox
            min: 0
            max: 20
          codeBlock: |
            pregnancy_losses = q211_num_losses.outcome
            total_pregnancies = total_live_births + pregnancy_losses
            if total_pregnancies >= 1:
                has_past_pregnancies = 1

        - id: q212_total_pregnancies
          kind: Question
          title: "SUM ANSWERS TO 208 AND 211 AND ENTER TOTAL. Total pregnancy outcomes:"
          input:
            control: Editbox
            min: 0
            max: 50
          codeBlock: |
            total_pregnancies = q212_total_pregnancies.outcome
            if total_pregnancies >= 1:
                has_past_pregnancies = 1

        - id: q232_pregnant_now
          kind: Question
          title: "Are you pregnant now?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Unsure"
          codeBlock: |
            if q232_pregnant_now.outcome == 1:
                is_pregnant = 1
            if q232_pregnant_now.outcome == 2:
                not_pregnant = 1

        - id: q233_pregnancy_duration
          kind: Question
          title: "How many weeks or months pregnant are you?"
          precondition:
            - predicate: is_pregnant == 1
          input:
            control: Editbox
            min: 1
            max: 42
            right: "weeks/months"

        - id: q234_wanted_pregnancy
          kind: Question
          title: "When you got pregnant, did you want to get pregnant at that time?"
          precondition:
            - predicate: is_pregnant == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q235_want_child
          kind: Question
          title: "Did you want to have a baby later on or did you not want any (more) children?"
          precondition:
            - predicate: is_pregnant == 1
            - predicate: q234_wanted_pregnancy.outcome == 0
          input:
            control: Radio
            labels:
              1: "Later"
              2: "No more/None"

        - id: q236_last_period
          kind: Question
          title: "When did your last menstrual period start?"
          precondition:
            - predicate: is_pregnant == 0
          input:
            control: Radio
            labels:
              1: "Days ago"
              2: "Weeks ago"
              3: "Months ago"
              4: "Years ago"
              994: "In menopause/Has had hysterectomy"
              995: "Before last pregnancy"
              996: "Never menstruated"
          codeBlock: |
            last_period_code = q236_last_period.outcome
            if q236_last_period.outcome in [1, 2, 3]:
                period_within_year = 1

        - id: q238_menstrual_materials
          kind: Question
          title: "During your last menstrual period, what did you use to collect or absorb your menstrual blood? Anything else?"
          precondition:
            - predicate: is_pregnant == 0
            - predicate: period_within_year == 1
          input:
            control: Checkbox
            labels:
              1: "Reusable sanitary pads"
              2: "Disposable sanitary pads"
              4: "Tampons"
              8: "Menstrual cup"
              16: "Cloth"
              32: "Toilet paper"
              64: "Cotton wool"
              128: "Underwear only"
              256: "Other"
              512: "Nothing"

        - id: q239_wash_privacy
          kind: Question
          title: "During your last menstrual period, were you able to wash and change in privacy while at home?"
          precondition:
            - predicate: is_pregnant == 0
            - predicate: period_within_year == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Away from home during last menstrual period"

        - id: q240_age_first_period
          kind: Question
          title: "How old were you when you had your first menstrual period?"
          precondition:
            - predicate: is_pregnant == 0
            - predicate: last_period_code not in [994, 995, 996]
          input:
            control: Editbox
            min: 8
            max: 25

        - id: q241_fertile_days
          kind: Question
          title: "From one menstrual period to the next, are there certain days when a woman is more likely to become pregnant?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q242_when_fertile
          kind: Question
          title: "Is this time just before her period begins, during her period, right after her period has ended, or halfway between two periods?"
          precondition:
            - predicate: q241_fertile_days.outcome == 1
          input:
            control: Radio
            labels:
              1: "Just before her period begins"
              2: "During her period"
              3: "Right after her period has ended"
              4: "Halfway between two periods"
              6: "Other"
              8: "Don't know"

        - id: q243_pregnant_before_period
          kind: Question
          title: "After the birth of a child, can a woman become pregnant before her menstrual period has returned?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

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

        - id: q301_01_female_sterilization
          kind: Question
          title: "Have you heard of Female Sterilization? PROBE: Women can have an operation to avoid having any more children."
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q301_02_male_sterilization
          kind: Question
          title: "Have you heard of Male Sterilization? PROBE: Men can have an operation to avoid having any more children."
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q301_03_iud
          kind: Question
          title: "Have you heard of IUD? PROBE: Women can have a loop or coil placed inside them by a doctor or a nurse which can prevent pregnancy for one or more years."
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q301_04_injectables
          kind: Question
          title: "Have you heard of Injectables? PROBE: Women can have an injection by a health provider that stops them from becoming pregnant for one or more months."
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q301_05_implants
          kind: Question
          title: "Have you heard of Implants? PROBE: Women can have one or more small rods placed in their upper arm by a doctor or nurse which can prevent pregnancy for one or more years."
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q301_06_pill
          kind: Question
          title: "Have you heard of Pill? PROBE: Women can take a pill every day to avoid becoming pregnant."
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q301_07_condom
          kind: Question
          title: "Have you heard of Condom? PROBE: Men can put a rubber sheath on their penis before sexual intercourse."
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q301_08_female_condom
          kind: Question
          title: "Have you heard of Female Condom? PROBE: Women can place a sheath in their vagina before sexual intercourse."
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q301_09_emergency
          kind: Question
          title: "Have you heard of Emergency Contraception? PROBE: As an emergency measure, within 3 days after unprotected sexual intercourse, women can take special pills to prevent pregnancy."
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q301_10_sdm
          kind: Question
          title: "Have you heard of Standard Days Method? PROBE: A woman uses a string of colored beads to know the days she can get pregnant."
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q301_11_lam
          kind: Question
          title: "Have you heard of Lactational Amenorrhea Method (LAM)? PROBE: Up to 6 months after childbirth, before the menstrual period has returned, women use a method requiring frequent breastfeeding day and night."
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q301_12_rhythm
          kind: Question
          title: "Have you heard of Rhythm Method? PROBE: To avoid pregnancy, women do not have sexual intercourse on the days of the month they think they can get pregnant."
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q301_13_withdrawal
          kind: Question
          title: "Have you heard of Withdrawal? PROBE: Men can be careful and pull out before climax."
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q301_14_other
          kind: Question
          title: "Have you heard of any other ways or methods that women or men can use to avoid pregnancy?"
          input:
            control: Radio
            labels:
              1: "Yes, modern method"
              2: "Yes, traditional method"
              3: "No"

        - id: q303_currently_using
          kind: Question
          title: "Are you or your partner currently doing something or using any method to delay or avoid getting pregnant?"
          precondition:
            - predicate: is_pregnant == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"
          codeBlock: |
            if q303_currently_using.outcome == 1:
                using_method = 1

        - id: q304_sterilized
          kind: Question
          title: "Are you or your partner sterilized? IF YES: Who is sterilized, you or your partner?"
          precondition:
            - predicate: is_pregnant == 0
            - predicate: q303_currently_using.outcome == 0
          input:
            control: Radio
            labels:
              1: "Yes, respondent sterilized only"
              2: "Yes, partner sterilized only"
              3: "Yes, both sterilized"
              4: "No, neither sterilized"
          codeBlock: |
            if q304_sterilized.outcome in [1, 2, 3]:
                sterilized = 1

        - id: q306_using_method
          kind: Question
          title: "Just to check, are you or your partner doing any of the following to avoid pregnancy: deliberately avoiding sex on certain days, using a condom, using withdrawal or using emergency contraception?"
          precondition:
            - predicate: is_pregnant == 0
            - predicate: q303_currently_using.outcome == 0
            - predicate: q304_sterilized.outcome == 4
          input:
            control: Switch
            on: "Yes"
            off: "No"
          codeBlock: |
            if q306_using_method.outcome == 1:
                using_method = 1

        - id: q307_method
          kind: Question
          title: "Which method are you using? (RECORD ALL MENTIONED. IF MORE THAN ONE METHOD, FOLLOW SKIP INSTRUCTION FOR HIGHEST METHOD IN LIST.)"
          precondition:
            - predicate: using_method == 1
          input:
            control: Dropdown
            labels:
              1: "Female sterilization"
              2: "Male sterilization"
              3: "IUD"
              4: "Injectables"
              5: "Implants"
              6: "Pill"
              7: "Condom"
              8: "Female condom"
              9: "Emergency contraception"
              10: "Standard Days Method"
              11: "Lactational Amenorrhea Method"
              12: "Rhythm Method"
              13: "Withdrawal"
              95: "Other modern method"
              96: "Other traditional method"
          codeBlock: |
            current_method = q307_method.outcome
            if current_method == 4:
                method_is_injectable = 1
            if current_method == 6:
                method_is_pill = 1
            if current_method == 7:
                method_is_condom = 1
            if current_method in [1, 2]:
                method_is_sterilization = 1
            if current_method in [3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 95, 96]:
                method_needs_source = 1

        - id: q308_injectable_type
          kind: Question
          title: "Now I'm going to show you two pictures. Please point to the picture that best matches what was used the last time you received your injectable."
          precondition:
            - predicate: method_is_injectable == 1
          input:
            control: Radio
            labels:
              1: "DMPA-SC/Sayana Press"
              2: "Needle and syringe"
              8: "Don't know"

        - id: q309_self_injection
          kind: Question
          title: "The last time you received your injectable, did you inject DMPA-SC/Sayana Press yourself or did a health care provider do it for you?"
          precondition:
            - predicate: method_is_injectable == 1
          input:
            control: Radio
            labels:
              1: "Self-injection"
              2: "Injection given by health care provider"
              8: "Don't know"

        - id: q310_pill_brand
          kind: Question
          title: "What is the brand name of the pills you are using?"
          precondition:
            - predicate: method_is_pill == 1
          input:
            control: Dropdown
            labels:
              1: "Brand A"
              2: "Brand B"
              3: "Brand C"
              96: "Other"
              98: "Don't know"

        - id: q311_condom_brand
          kind: Question
          title: "What is the brand name of the condoms you are using?"
          precondition:
            - predicate: method_is_condom == 1
          input:
            control: Dropdown
            labels:
              1: "Brand A"
              2: "Brand B"
              3: "Brand C"
              96: "Other"
              98: "Don't know"

        - id: q312_sterilization_facility
          kind: Question
          title: "In what facility did the sterilization take place?"
          precondition:
            - predicate: method_is_sterilization == 1
          input:
            control: Dropdown
            labels:
              11: "Government hospital"
              12: "Government health center"
              13: "Family planning clinic"
              14: "Mobile clinic"
              16: "Other public sector"
              21: "Private hospital"
              22: "Private clinic"
              23: "Private doctor's office"
              24: "Mobile clinic (private)"
              26: "Other private medical sector"
              31: "NGO hospital"
              32: "NGO clinic"
              36: "Other NGO medical sector"
              96: "Other"
              98: "Don't know"

        - id: q313_sterilization_date
          kind: Question
          title: "In what month and year was the sterilization performed? (Record month 1-12 or 98 for DK)"
          precondition:
            - predicate: method_is_sterilization == 1
          input:
            control: Editbox
            min: 1
            max: 98

        - id: q314_method_start
          kind: Question
          title: "Since what month and year have you been using (METHOD) without stopping? (Record number of months)"
          precondition:
            - predicate: using_method == 1
            - predicate: current_method not in [1, 2]
          input:
            control: Editbox
            min: 0
            max: 600
            right: "months"

        - id: q320_ever_used
          kind: Question
          title: "Have you ever used anything or tried in any way to delay or avoid getting pregnant?"
          precondition:
            - predicate: using_method == 0
            - predicate: sterilized == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"
          codeBlock: |
            if q320_ever_used.outcome == 1:
                ever_used_method = 1

        - id: q318_emergency_12m
          kind: Question
          title: "Have you used emergency contraception in the last 12 months? That is, have you taken special pills within 3 days after having unprotected sexual intercourse to prevent pregnancy?"
          precondition:
            - predicate: using_method == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q323_told_side_effects
          kind: Question
          title: "At that time, were you told about side effects or problems you might have with the method?"
          precondition:
            - predicate: using_method == 1
            - predicate: current_method not in [1, 2]
          input:
            control: Switch
            on: "Yes"
            off: "No"
          codeBlock: |
            if q323_told_side_effects.outcome == 1:
                told_side_effects = 1

        - id: q325_told_what_to_do
          kind: Question
          title: "Were you told what to do if you experienced side effects or problems?"
          precondition:
            - predicate: told_side_effects == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q326_told_other_methods
          kind: Question
          title: "At that time, were you told about other methods of family planning that you could use?"
          precondition:
            - predicate: using_method == 1
            - predicate: current_method not in [1, 2]
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q328_could_switch
          kind: Question
          title: "At that time, were you told that you could switch to another method if you wanted to or needed to?"
          precondition:
            - predicate: using_method == 1
            - predicate: current_method not in [1, 2]
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q330_method_source
          kind: Question
          title: "Where did you obtain (METHOD) the last time?"
          precondition:
            - predicate: method_needs_source == 1
          input:
            control: Dropdown
            labels:
              11: "Government hospital"
              12: "Government health center"
              13: "Family planning clinic"
              14: "Mobile clinic"
              15: "Community health worker/Fieldworker"
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

        - id: q331_know_source
          kind: Question
          title: "Do you know of a place where you can obtain a method of family planning?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q332_visited_fieldworker
          kind: Question
          title: "In the last 12 months, were you visited by a fieldworker?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q333_fieldworker_fp
          kind: Question
          title: "Did the fieldworker talk to you about family planning?"
          precondition:
            - predicate: q332_visited_fieldworker.outcome == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q334_visited_facility
          kind: Question
          title: "In the last 12 months, have you visited a health facility for care for yourself or your children?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q335_facility_fp
          kind: Question
          title: "Did any staff member at the health facility speak to you about family planning methods?"
          precondition:
            - predicate: q334_visited_facility.outcome == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # =========================================================================
    # SECTION 4: PREGNANCY AND POSTNATAL CARE (MOST RECENT PREGNANCY)
    # =========================================================================
    - id: b_pregnancy_care
      title: "Section 4. Pregnancy and Postnatal Care"
      precondition:
        - predicate: consent == 1
        - predicate: has_past_pregnancies == 1
      items:
        - id: q405_outcome_type
          kind: Question
          title: "CHECK 402: What was the pregnancy outcome type for the most recent pregnancy in the last 3 years?"
          input:
            control: Radio
            labels:
              1: "Most recent live birth"
              2: "Prior live birth"
              3: "Most recent stillbirth"
              4: "Prior stillbirth"
              5: "Miscarriage/Abortion"
          codeBlock: |
            preg_outcome_type = q405_outcome_type.outcome
            if preg_outcome_type == 1:
                is_most_recent_lb = 1

        - id: q408_wanted_pregnancy
          kind: Question
          title: "When you got pregnant, did you want to get pregnant at that time?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q409_want_later
          kind: Question
          title: "Did you want to have a baby later on, or not at all?"
          precondition:
            - predicate: q408_wanted_pregnancy.outcome == 0
          input:
            control: Radio
            labels:
              1: "Later"
              2: "Not at all"

        - id: q412_anc
          kind: Question
          title: "Did you see anyone for antenatal care for this pregnancy?"
          precondition:
            - predicate: preg_outcome_type in [1, 3]
          input:
            control: Switch
            on: "Yes"
            off: "No"
          codeBlock: |
            if q412_anc.outcome == 1:
                had_anc = 1

        - id: q414_anc_provider
          kind: Question
          title: "Whom did you see? Anyone else? (PROBE TO IDENTIFY EACH TYPE OF PERSON AND RECORD ALL MENTIONED.)"
          precondition:
            - predicate: had_anc == 1
          input:
            control: Checkbox
            labels:
              1: "Doctor"
              2: "Nurse/Midwife"
              4: "Auxiliary Midwife"
              8: "Traditional Birth Attendant"
              16: "Community Health Worker/Field Worker"
              32: "Other"

        - id: q416_anc_timing
          kind: Question
          title: "How many weeks or months pregnant were you when you first received antenatal care for this pregnancy?"
          precondition:
            - predicate: had_anc == 1
          input:
            control: Editbox
            min: 1
            max: 42
            right: "weeks/months"

        - id: q417_anc_visits
          kind: Question
          title: "How many times did you receive antenatal care during this pregnancy?"
          precondition:
            - predicate: had_anc == 1
          input:
            control: Editbox
            min: 1
            max: 30

        - id: q415_anc_source
          kind: Question
          title: "Where did you receive antenatal care for this pregnancy? Anywhere else?"
          precondition:
            - predicate: had_anc == 1
          input:
            control: Dropdown
            labels:
              1: "Her home"
              2: "Other home"
              11: "Government hospital"
              12: "Government health center"
              13: "Government health post"
              14: "Other public sector"
              21: "Private hospital"
              22: "Private clinic"
              23: "Other private medical sector"
              31: "NGO hospital"
              32: "NGO clinic"
              33: "Other NGO medical sector"
              96: "Other"

        - id: q418a_bp
          kind: Question
          title: "As part of your antenatal care, did a healthcare provider measure your blood pressure?"
          precondition:
            - predicate: had_anc == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q418b_urine
          kind: Question
          title: "As part of your antenatal care, did a healthcare provider take a urine sample?"
          precondition:
            - predicate: had_anc == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q418c_blood
          kind: Question
          title: "As part of your antenatal care, did a healthcare provider take a blood sample?"
          precondition:
            - predicate: had_anc == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q420_tetanus
          kind: Question
          title: "During this pregnancy, were you given an injection in the arm to prevent the baby from getting tetanus after birth?"
          precondition:
            - predicate: preg_outcome_type == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q421_tetanus_times
          kind: Question
          title: "During this pregnancy, how many times did you get a tetanus injection?"
          precondition:
            - predicate: preg_outcome_type == 1
            - predicate: q420_tetanus.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 7
          codeBlock: |
            tetanus_times_val = q421_tetanus_times.outcome

        - id: q423_tetanus_before
          kind: Question
          title: "At any time before this pregnancy, did you receive any tetanus injections?"
          precondition:
            - predicate: preg_outcome_type == 1
            - predicate: q420_tetanus.outcome in [2, 8]
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q424_tetanus_before_times
          kind: Question
          title: "Before this pregnancy, how many times did you receive a tetanus injection?"
          precondition:
            - predicate: q423_tetanus_before.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 7

        - id: q426_iron
          kind: Question
          title: "During this pregnancy, were you given or did you buy any iron tablets or iron syrup?"
          precondition:
            - predicate: preg_outcome_type in [1, 3]
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q428_iron_days
          kind: Question
          title: "During the whole pregnancy, for how many days did you take the iron tablets or syrup?"
          precondition:
            - predicate: preg_outcome_type in [1, 3]
            - predicate: q426_iron.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 300
            right: "days"

        - id: q427_iron_source
          kind: Question
          title: "Where did you get the iron tablets or syrup?"
          precondition:
            - predicate: preg_outcome_type in [1, 3]
            - predicate: q426_iron.outcome == 1
          input:
            control: Dropdown
            labels:
              11: "Government hospital"
              12: "Government health center"
              13: "Government health post"
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
              33: "Other NGO medical sector"
              41: "Shop"
              42: "Market"
              43: "Mass distribution campaign"
              96: "Other"

        - id: q429_deworming
          kind: Question
          title: "During this pregnancy, did you take any medicine for intestinal worms?"
          precondition:
            - predicate: preg_outcome_type in [1, 3]
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q430_food_assistance
          kind: Question
          title: "During this pregnancy, did you receive food or cash assistance through a program for pregnant women?"
          precondition:
            - predicate: preg_outcome_type in [1, 3]
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q431_malaria
          kind: Question
          title: "During this pregnancy, did you take SP/Fansidar to keep you from getting malaria?"
          precondition:
            - predicate: preg_outcome_type in [1, 3]
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q432_malaria_times
          kind: Question
          title: "How many times did you take SP/Fansidar during this pregnancy?"
          precondition:
            - predicate: preg_outcome_type in [1, 3]
            - predicate: q431_malaria.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 20

        - id: q433_sp_source
          kind: Question
          title: "Did you get the SP/Fansidar during an antenatal care visit, during another visit to a health facility or from another source?"
          precondition:
            - predicate: q431_malaria.outcome == 1
          input:
            control: Radio
            labels:
              1: "Antenatal visit"
              2: "Another facility visit"
              6: "Other source"

        - id: q434_birth_attendant
          kind: Question
          title: "Who assisted with the delivery? Anyone else? (PROBE FOR THE TYPE(S) OF PERSON(S) AND RECORD ALL MENTIONED.)"
          precondition:
            - predicate: preg_outcome_type in [1, 2, 3, 4]
          input:
            control: Checkbox
            labels:
              1: "Doctor"
              2: "Nurse/Midwife"
              4: "Auxiliary Midwife"
              8: "Traditional Birth Attendant"
              16: "Relative/Friend"
              32: "Other"
              64: "No one assisted"

        - id: q435_delivery_place
          kind: Question
          title: "Where did you give birth / deliver?"
          precondition:
            - predicate: preg_outcome_type in [1, 2, 3, 4]
          input:
            control: Dropdown
            labels:
              11: "Her home"
              12: "Other home"
              21: "Government hospital"
              22: "Government health center"
              23: "Government health post"
              26: "Other public sector"
              31: "Private hospital"
              32: "Private clinic"
              36: "Other private medical sector"
              41: "NGO hospital"
              42: "NGO clinic"
              46: "Other NGO medical sector"
              96: "Other"
          codeBlock: |
            delivery_place = q435_delivery_place.outcome
            if delivery_place >= 21 and delivery_place <= 46:
                facility_birth = 1

        - id: q436_caesarean
          kind: Question
          title: "Was (NAME) delivered by caesarean, that is, did they cut your belly open to take the baby out?"
          precondition:
            - predicate: preg_outcome_type in [1, 2, 3, 4]
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q438_skin_contact
          kind: Question
          title: "After the birth, was (NAME) put on your chest?"
          precondition:
            - predicate: preg_outcome_type == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q439_bare_skin
          kind: Question
          title: "Was (NAME)'s bare skin touching your bare skin?"
          precondition:
            - predicate: preg_outcome_type == 1
            - predicate: q438_skin_contact.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q441_birth_size
          kind: Question
          title: "When (NAME) was born, was (NAME) very large, larger than average, average, smaller than average, or very small?"
          precondition:
            - predicate: preg_outcome_type in [1, 2]
          input:
            control: Radio
            labels:
              1: "Very large"
              2: "Larger than average"
              3: "Average"
              4: "Smaller than average"
              5: "Very small"
              8: "Don't know"

        - id: q442_weighed
          kind: Question
          title: "Was (NAME) weighed at birth?"
          precondition:
            - predicate: preg_outcome_type in [1, 2]
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q443_weight
          kind: Question
          title: "How much did (NAME) weigh? (Record weight in kilograms from health card, if available.)"
          precondition:
            - predicate: preg_outcome_type in [1, 2]
            - predicate: q442_weighed.outcome == 1
          input:
            control: Editbox
            min: 500
            max: 6000
            right: "grams"

        - id: q448_health_check_mother
          kind: Question
          title: "Before you left the facility, did anyone check on your health?"
          precondition:
            - predicate: facility_birth == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"
          codeBlock: |
            if q448_health_check_mother.outcome == 1:
                had_health_check_mother = 1

        - id: q447_facility_stay
          kind: Question
          title: "How long after delivery did you stay in the facility?"
          precondition:
            - predicate: facility_birth == 1
          input:
            control: Editbox
            min: 0
            max: 999
            right: "hours"

        - id: q449_check_timing
          kind: Question
          title: "How long after delivery did the first check take place?"
          precondition:
            - predicate: had_health_check_mother == 1
          input:
            control: Editbox
            min: 0
            max: 999
            right: "hours"

        - id: q450_check_provider
          kind: Question
          title: "Who checked on your health at that time?"
          precondition:
            - predicate: had_health_check_mother == 1
          input:
            control: Dropdown
            labels:
              11: "Doctor"
              12: "Nurse/Midwife"
              13: "Auxiliary midwife"
              21: "Traditional birth attendant"
              22: "Community health worker/Field worker"
              96: "Other"

        - id: q452_newborn_check_facility
          kind: Question
          title: "Before (NAME) left the facility, did anyone check on (NAME)'s health?"
          precondition:
            - predicate: facility_birth == 1
            - predicate: preg_outcome_type == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
          codeBlock: |
            if q452_newborn_check_facility.outcome == 1:
                newborn_check_facility = 1

        - id: q455_post_facility_check
          kind: Question
          title: "After you left the facility, did anyone check on your health?"
          precondition:
            - predicate: facility_birth == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"
          codeBlock: |
            if q455_post_facility_check.outcome == 1:
                post_facility_check_mother = 1

        - id: q460_post_facility_check_baby
          kind: Question
          title: "After (NAME) left the facility, did any health care provider check on (NAME)'s health?"
          precondition:
            - predicate: preg_outcome_type == 1
            - predicate: facility_birth == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
          codeBlock: |
            if q460_post_facility_check_baby.outcome == 1:
                home_birth_check_baby = 1

        - id: q464_postnatal_check_mother
          kind: Question
          title: "Did anyone check on your health after delivery? For example, someone asking you questions about your health or examining you."
          precondition:
            - predicate: facility_birth == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"
          codeBlock: |
            if q464_postnatal_check_mother.outcome == 1:
                home_birth_check_mother = 1

        - id: q469_newborn_check_home
          kind: Question
          title: "After (NAME) was born, did any health care provider or a traditional birth attendant check on (NAME)'s health? For example, someone examining (NAME), checking the cord, or talking to you about how to care for (NAME)."
          precondition:
            - predicate: preg_outcome_type == 1
            - predicate: facility_birth == 0
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q474_postnatal_maternal
          kind: Comment
          title: "During the first 2 days after the birth, did any healthcare provider do the following to you:"

        - id: q474a_blood_pressure
          kind: Question
          title: "Measure your blood pressure?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q474b_bleeding
          kind: Question
          title: "Discuss your vaginal bleeding with you?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q474c_family_planning
          kind: Question
          title: "Discuss family planning with you?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q480_breastfed
          kind: Question
          title: "Did you ever breastfeed (NAME)?"
          precondition:
            - predicate: preg_outcome_type == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"
          codeBlock: |
            if q480_breastfed.outcome == 1:
                ever_breastfed = 1

        - id: q482_breastfeed_start
          kind: Question
          title: "How long after birth did you first put (NAME) to the breast? (If less than 1 hour, record '00' hours.)"
          precondition:
            - predicate: ever_breastfed == 1
          input:
            control: Editbox
            min: 0
            max: 96
            right: "hours"

        - id: q483_prelacteal
          kind: Question
          title: "In the first 2 days after delivery, was (NAME) given anything other than breast milk to eat or drink?"
          precondition:
            - predicate: preg_outcome_type == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q485_still_breastfeeding
          kind: Question
          title: "Are you still breastfeeding (NAME)?"
          precondition:
            - predicate: ever_breastfed == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q486_bottle
          kind: Question
          title: "Did (NAME) drink anything from a bottle with a nipple yesterday during the day or at night?"
          precondition:
            - predicate: preg_outcome_type == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

    # =========================================================================
    # SECTION 5: CHILD IMMUNIZATION
    # =========================================================================
    - id: b_immunization
      title: "Section 5. Child Immunization"
      precondition:
        - predicate: consent == 1
        - predicate: ever_given_birth == 1
      items:
        - id: q501_check
          kind: Comment
          title: "CHECK 220, 224 AND 225 IN THE PREGNANCY HISTORY: ANY SURVIVING CHILDREN BORN 0-35 MONTHS BEFORE THE SURVEY?"

        - id: q504_vacc_card
          kind: Question
          title: "Do you have a card or other document where (NAME IN 503)'s vaccinations are written down?"
          input:
            control: Radio
            labels:
              1: "Yes, has only a card"
              2: "Yes, has only another document"
              3: "Yes, has card and other document"
              4: "No, no card and no other document"
          codeBlock: |
            if q504_vacc_card.outcome in [1, 2, 3]:
                has_vacc_card = 1

        - id: q507_card_seen
          kind: Question
          title: "May I see the card or other document where (NAME IN 503)'s vaccinations are written down?"
          precondition:
            - predicate: has_vacc_card == 1
          input:
            control: Radio
            labels:
              1: "Yes, only card seen"
              2: "Yes, only other document seen"
              3: "Yes, card and other document seen"
              4: "No card and no other document seen"
          codeBlock: |
            if q507_card_seen.outcome in [1, 2, 3]:
                card_seen = 1

        - id: q505_ever_had_card
          kind: Question
          title: "Did you ever have a vaccination card for (NAME IN 503)?"
          precondition:
            - predicate: has_vacc_card == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"
          codeBlock: |
            if q505_ever_had_card.outcome == 1:
                ever_had_vacc_card = 1

        - id: q513_vacc_received
          kind: Question
          title: "Did (NAME) ever receive any vaccinations to prevent (NAME) from getting diseases, including vaccinations received in campaigns or immunization days or child health days?"
          precondition:
            - predicate: card_seen == 0
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q514_bcg
          kind: Question
          title: "Has (NAME) ever received a BCG vaccination against tuberculosis, that is, an injection in the arm or shoulder that usually causes a scar?"
          precondition:
            - predicate: card_seen == 0
            - predicate: q513_vacc_received.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q515_hepb
          kind: Question
          title: "At or soon after birth, did (NAME) receive a Hepatitis B vaccination, that is, an injection in the thigh to prevent Hepatitis B?"
          precondition:
            - predicate: card_seen == 0
            - predicate: q513_vacc_received.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
          codeBlock: |
            if q515_hepb.outcome == 1:
                received_hepb = 1

        - id: q516_hepb_24hrs
          kind: Question
          title: "Did (NAME) receive it within 24 hours of birth?"
          precondition:
            - predicate: received_hepb == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q517_polio
          kind: Question
          title: "Has (NAME) ever received oral polio vaccine, that is, about two drops in the mouth to prevent polio?"
          precondition:
            - predicate: card_seen == 0
            - predicate: q513_vacc_received.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q519_polio_times
          kind: Question
          title: "How many times did (NAME) receive the oral polio vaccine?"
          precondition:
            - predicate: card_seen == 0
            - predicate: q517_polio.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 10

        - id: q518_polio_first
          kind: Question
          title: "Did (NAME) receive the first oral polio vaccine in the first 2 weeks after birth or later?"
          precondition:
            - predicate: card_seen == 0
            - predicate: q517_polio.outcome == 1
          input:
            control: Radio
            labels:
              1: "First two weeks"
              2: "Later"

        - id: q520_ipv
          kind: Question
          title: "The last time (NAME) received the polio drops, did (NAME) also get an IPV injection in the arm to protect against polio?"
          precondition:
            - predicate: card_seen == 0
            - predicate: q517_polio.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q521_pentavalent
          kind: Question
          title: "Has (NAME) ever received a pentavalent vaccination, that is, an injection given in the thigh sometimes at the same time as polio drops?"
          precondition:
            - predicate: card_seen == 0
            - predicate: q513_vacc_received.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q522_pentavalent_times
          kind: Question
          title: "How many times did (NAME) receive the pentavalent vaccine?"
          precondition:
            - predicate: card_seen == 0
            - predicate: q521_pentavalent.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 10

        - id: q523_pneumo
          kind: Question
          title: "Has (NAME) ever received a pneumococcal vaccination, that is, an injection in the thigh to prevent pneumonia?"
          precondition:
            - predicate: card_seen == 0
            - predicate: q513_vacc_received.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
          codeBlock: |
            if q523_pneumo.outcome == 1:
                received_pneumo = 1

        - id: q524_pneumo_times
          kind: Question
          title: "How many times did (NAME) receive the pneumococcal vaccine?"
          precondition:
            - predicate: received_pneumo == 1
          input:
            control: Editbox
            min: 1
            max: 5

        - id: q525_rotavirus
          kind: Question
          title: "Has (NAME) ever received a rotavirus vaccination, that is, liquid in the mouth to prevent diarrhea?"
          precondition:
            - predicate: card_seen == 0
            - predicate: q513_vacc_received.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
          codeBlock: |
            if q525_rotavirus.outcome == 1:
                received_rotavirus = 1

        - id: q526_rotavirus_times
          kind: Question
          title: "How many times did (NAME) receive the rotavirus vaccine?"
          precondition:
            - predicate: received_rotavirus == 1
          input:
            control: Editbox
            min: 1
            max: 5

        - id: q527_measles
          kind: Question
          title: "Has (NAME) ever received a measles vaccination, that is, an injection in the arm to prevent measles?"
          precondition:
            - predicate: card_seen == 0
            - predicate: q513_vacc_received.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q528_measles_times
          kind: Question
          title: "How many times did (NAME) receive the measles vaccine?"
          precondition:
            - predicate: card_seen == 0
            - predicate: q527_measles.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 5

        - id: q529_vacc_source
          kind: Question
          title: "Where did (NAME) receive most of his/her vaccinations?"
          input:
            control: Dropdown
            labels:
              11: "Government hospital"
              12: "Government health center"
              13: "Government health post"
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
              41: "Vaccination campaign"
              96: "Other"

    # =========================================================================
    # SECTION 6: CHILD HEALTH AND NUTRITION
    # =========================================================================
    - id: b_child_health
      title: "Section 6. Child Health and Nutrition"
      precondition:
        - predicate: consent == 1
        - predicate: ever_given_birth == 1
      items:
        - id: q604_iron_child
          kind: Question
          title: "In the last 12 months, was (NAME) given iron tablets or syrup?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q605_vitamin_a
          kind: Question
          title: "In the last 6 months, was (NAME) given a vitamin A dose like [this/any of these]?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q606_deworming_child
          kind: Question
          title: "In the last 6 months, was (NAME) given any medicine for intestinal worms?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q607a_weight
          kind: Question
          title: "In the last 3 months, has any healthcare provider or community health worker measured (NAME)'s weight?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q607b_height
          kind: Question
          title: "In the last 3 months, has any healthcare provider or community health worker measured (NAME)'s length or height?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q607c_arm
          kind: Question
          title: "In the last 3 months, has any healthcare provider or community health worker measured around (NAME)'s upper arm?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q608_diarrhea
          kind: Question
          title: "Has (NAME) had diarrhea in the last 2 weeks?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
          codeBlock: |
            if q608_diarrhea.outcome == 1:
                child_had_diarrhea = 1

        - id: q609_drink_diarrhea
          kind: Question
          title: "Now I would like to know how much (NAME) was given to drink during the diarrhea. Was (NAME) given less than usual to drink, about the same amount, or more than usual to drink?"
          precondition:
            - predicate: child_had_diarrhea == 1
          input:
            control: Radio
            labels:
              1: "Much less"
              2: "Somewhat less"
              3: "About the same"
              4: "More"
              5: "Nothing to drink"
              8: "Don't know"

        - id: q610_food_diarrhea
          kind: Question
          title: "When (NAME) had diarrhea, was (NAME) given less than usual to eat, about the same amount, more than usual, or nothing to eat?"
          precondition:
            - predicate: child_had_diarrhea == 1
          input:
            control: Radio
            labels:
              1: "Much less"
              2: "Somewhat less"
              3: "About the same"
              4: "More"
              5: "Stopped food"
              6: "Never gave food"
              8: "Don't know"

        - id: q611_sought_advice
          kind: Question
          title: "Did you seek advice or treatment for the diarrhea from any source?"
          precondition:
            - predicate: child_had_diarrhea == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"
          codeBlock: |
            if q611_sought_advice.outcome == 1:
                sought_diarrhea_advice = 1

        - id: q615_ors
          kind: Question
          title: "Was (NAME) given a fluid made from a special ORS packet?"
          precondition:
            - predicate: child_had_diarrhea == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q615c_zinc
          kind: Question
          title: "Was (NAME) given zinc tablets or syrup?"
          precondition:
            - predicate: child_had_diarrhea == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q615b_ors_liquid
          kind: Question
          title: "Was (NAME) given pre-packaged ORS liquid?"
          precondition:
            - predicate: child_had_diarrhea == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q615d_homemade_fluid
          kind: Question
          title: "Was (NAME) given a government-recommended homemade fluid?"
          precondition:
            - predicate: child_had_diarrhea == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q618_fever
          kind: Question
          title: "Has (NAME) been ill with a fever at any time in the last 2 weeks?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
          codeBlock: |
            if q618_fever.outcome == 1:
                child_had_fever = 1

        - id: q619_blood_test
          kind: Question
          title: "At any time during the illness, did (NAME) have blood taken from (NAME)'s finger or heel for testing?"
          precondition:
            - predicate: child_had_fever == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q620_malaria_diagnosis
          kind: Question
          title: "Were you told by a healthcare provider that (NAME) had malaria?"
          precondition:
            - predicate: child_had_fever == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q621_cough
          kind: Question
          title: "Has (NAME) had an illness with a cough at any time in the last 2 weeks?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
          codeBlock: |
            if q621_cough.outcome == 1:
                child_had_cough = 1

        - id: q622_breathing
          kind: Question
          title: "Has (NAME) had fast, short, rapid breaths or difficulty breathing at any time in the last 2 weeks?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q623_breathing_location
          kind: Question
          title: "Was the fast or difficult breathing due to a problem in the chest or to a blocked or runny nose?"
          precondition:
            - predicate: q622_breathing.outcome == 1
          input:
            control: Radio
            labels:
              1: "Chest only"
              2: "Nose only"
              3: "Both"
              6: "Other"
              8: "Don't know"

        - id: q625_sought_treatment
          kind: Question
          title: "Did you seek advice or treatment for the illness from any source?"
          precondition:
            - predicate: child_had_fever == 1 or child_had_cough == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"
          codeBlock: |
            if q625_sought_treatment.outcome == 1:
                sought_fever_advice = 1

        - id: q630_took_medicine
          kind: Question
          title: "At any time during the illness, did (NAME) take any medicine for the illness?"
          precondition:
            - predicate: child_had_fever == 1 or child_had_cough == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
          codeBlock: |
            if q630_took_medicine.outcome == 1:
                child_took_medicine = 1

        - id: q639_ate_food
          kind: Question
          title: "Did (NAME) eat any solid, semi-solid, or soft foods yesterday during the day or at night?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q640_times_ate
          kind: Question
          title: "How many times did (NAME) eat solid, semi-solid, or soft foods yesterday during the day or at night? (If 7 or more times, record '7'.)"
          precondition:
            - predicate: q639_ate_food.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 7

        - id: q641_feeding_advice
          kind: Question
          title: "In the last 6 months, did any healthcare provider or community health worker talk with you about how or what to feed (NAME)?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q642_stool_disposal
          kind: Question
          title: "The last time (NAME) passed stools, what was done to dispose of the stools?"
          input:
            control: Dropdown
            labels:
              1: "Child used toilet or latrine"
              2: "Put/rinsed into toilet or latrine"
              3: "Put/rinsed into drain or ditch"
              4: "Thrown into garbage"
              5: "Buried"
              6: "Left in the open"
              96: "Other"

    # =========================================================================
    # SECTION 7: MARRIAGE AND SEXUAL ACTIVITY
    # =========================================================================
    - id: b_marriage
      title: "Section 7. Marriage and Sexual Activity"
      precondition:
        - predicate: consent == 1
      items:
        - id: q701_marital_status
          kind: Question
          title: "Are you currently married or living together with a man as if married?"
          input:
            control: Radio
            labels:
              1: "Yes, currently married"
              2: "Yes, living with a man"
              3: "No, not in union"
          codeBlock: |
            marital_status = q701_marital_status.outcome
            if q701_marital_status.outcome in [1, 2]:
                currently_in_union = 1

        - id: q702_ever_married
          kind: Question
          title: "Have you ever been married or lived together with a man as if married?"
          precondition:
            - predicate: currently_in_union == 0
          input:
            control: Radio
            labels:
              1: "Yes, formerly married"
              2: "Yes, lived with a man"
              3: "No"
          codeBlock: |
            if q702_ever_married.outcome in [1, 2]:
                ever_in_union = 1

        - id: q703_current_status
          kind: Question
          title: "What is your marital status now: are you widowed, divorced, or separated?"
          precondition:
            - predicate: currently_in_union == 0
            - predicate: ever_in_union == 1
          input:
            control: Radio
            labels:
              1: "Widowed"
              2: "Divorced"
              3: "Separated"

        - id: q706a_marriage_doc
          kind: Question
          title: "Do you have a marriage certificate or other document recognizing this (marriage/union)?"
          precondition:
            - predicate: currently_in_union == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
          codeBlock: |
            if q706a_marriage_doc.outcome == 1:
                has_marriage_doc = 1

        - id: q707_marriage_registered
          kind: Question
          title: "Was this marriage ever registered with the civil authority?"
          precondition:
            - predicate: currently_in_union == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q709_partner_living
          kind: Question
          title: "Is your (husband/partner) living with you now or is he staying elsewhere?"
          precondition:
            - predicate: currently_in_union == 1
          input:
            control: Radio
            labels:
              1: "Living with her"
              2: "Staying elsewhere"

        - id: q711_other_wives
          kind: Question
          title: "Does your (husband/partner) have other wives or does he live with other women as if married?"
          precondition:
            - predicate: currently_in_union == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
          codeBlock: |
            if q711_other_wives.outcome == 1:
                has_other_wives = 1

        - id: q712_num_wives
          kind: Question
          title: "Including yourself, in total, how many wives or live-in partners does he have?"
          precondition:
            - predicate: has_other_wives == 1
          input:
            control: Editbox
            min: 2
            max: 20

        - id: q713_wife_rank
          kind: Question
          title: "Are you the first, second, ... wife?"
          precondition:
            - predicate: has_other_wives == 1
          input:
            control: Editbox
            min: 1
            max: 20

        - id: q714_married_once
          kind: Question
          title: "Have you been married or lived with a man only once or more than once?"
          precondition:
            - predicate: currently_in_union == 1 or ever_in_union == 1
          input:
            control: Radio
            labels:
              1: "Only once"
              2: "More than once"
          codeBlock: |
            if q714_married_once.outcome == 2:
                married_more_than_once = 1

        - id: q715_first_cohabitation_month
          kind: Question
          title: "In what month and year did you start living with your (first husband/partner)? (Record month 1-12, 98 for DK)"
          precondition:
            - predicate: currently_in_union == 1 or ever_in_union == 1
          input:
            control: Editbox
            min: 1
            max: 98

        - id: q716_age_first_cohabitation
          kind: Question
          title: "How old were you when you first started living with him?"
          precondition:
            - predicate: currently_in_union == 1 or ever_in_union == 1
          input:
            control: Editbox
            min: 10
            max: 49
            right: "years"

        - id: q719_current_partner_start
          kind: Question
          title: "In what month and year did you start living with your current (husband/partner)? (Record month 1-12, 98 for DK)"
          precondition:
            - predicate: currently_in_union == 1
            - predicate: married_more_than_once == 1
          input:
            control: Editbox
            min: 1
            max: 98

        - id: q720_age_current_partner
          kind: Question
          title: "How old were you when you first started living with your current (husband/partner)?"
          precondition:
            - predicate: currently_in_union == 1
            - predicate: married_more_than_once == 1
          input:
            control: Editbox
            min: 10
            max: 49
            right: "years"

        - id: q721_privacy
          kind: Comment
          title: "CHECK FOR PRESENCE OF OTHERS. BEFORE CONTINUING, MAKE EVERY EFFORT TO ENSURE PRIVACY."

        - id: q722_age_first_sex
          kind: Question
          title: "How old were you when you had sexual intercourse for the very first time? (Record '00' for never had sexual intercourse.)"
          input:
            control: Editbox
            min: 0
            max: 49
          codeBlock: |
            if q722_age_first_sex.outcome > 0:
                ever_had_sex = 1

        - id: q723_last_sex
          kind: Question
          title: "When was the last time you had sexual intercourse?"
          precondition:
            - predicate: ever_had_sex == 1
          input:
            control: Radio
            labels:
              1: "Days ago"
              2: "Weeks ago"
              3: "Months ago"
              4: "Years ago"
          codeBlock: |
            last_sex_unit = q723_last_sex.outcome

        - id: q725_method_last_sex
          kind: Question
          title: "The last time you had sexual intercourse, did you or your partner do something or use any method to delay or avoid getting pregnant?"
          precondition:
            - predicate: ever_had_sex == 1
            - predicate: not_pregnant == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"
          codeBlock: |
            if q725_method_last_sex.outcome == 1:
                used_method_last_sex = 1

        - id: q727_condom_last
          kind: Question
          title: "The last time you had sexual intercourse, was a condom used?"
          precondition:
            - predicate: ever_had_sex == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"
          codeBlock: |
            if q727_condom_last.outcome == 1:
                used_condom_last = 1

        - id: q730_relationship
          kind: Question
          title: "What was your relationship to this person with whom you had sexual intercourse?"
          precondition:
            - predicate: ever_had_sex == 1
          input:
            control: Radio
            labels:
              1: "Husband"
              2: "Live-in partner"
              3: "Boyfriend not living with respondent"
              4: "Casual acquaintance"
              5: "Client/sex worker"
              6: "Other"

        - id: q731_other_partner
          kind: Question
          title: "Apart from this person, have you had sexual intercourse with any other person in the last 12 months?"
          precondition:
            - predicate: ever_had_sex == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"
          codeBlock: |
            if q731_other_partner.outcome == 1:
                had_second_partner = 1

        - id: q732_condom_second
          kind: Question
          title: "The last time you had sexual intercourse with this second person, was a condom used?"
          precondition:
            - predicate: had_second_partner == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q733_relationship_second
          kind: Question
          title: "What was your relationship to this second person with whom you had sexual intercourse?"
          precondition:
            - predicate: had_second_partner == 1
          input:
            control: Radio
            labels:
              1: "Husband"
              2: "Live-in partner"
              3: "Boyfriend not living with respondent"
              4: "Casual acquaintance"
              5: "Client/sex worker"
              6: "Other"

        - id: q734_third_partner
          kind: Question
          title: "Apart from these two people, have you had sexual intercourse with any other person in the last 12 months?"
          precondition:
            - predicate: had_second_partner == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"
          codeBlock: |
            if q734_third_partner.outcome == 1:
                had_third_partner = 1

        - id: q735_condom_third
          kind: Question
          title: "The last time you had sexual intercourse with this third person, was a condom used?"
          precondition:
            - predicate: had_third_partner == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q736_relationship_third
          kind: Question
          title: "What was your relationship to this third person with whom you had sexual intercourse?"
          precondition:
            - predicate: had_third_partner == 1
          input:
            control: Radio
            labels:
              1: "Husband"
              2: "Live-in partner"
              3: "Boyfriend not living with respondent"
              4: "Casual acquaintance"
              5: "Client/sex worker"
              6: "Other"

        - id: q737_lifetime_partners
          kind: Question
          title: "In total, with how many different people have you had sexual intercourse in your lifetime?"
          precondition:
            - predicate: ever_had_sex == 1
          input:
            control: Editbox
            min: 1
            max: 95

    # =========================================================================
    # SECTION 8: FERTILITY PREFERENCES
    # =========================================================================
    - id: b_fertility_pref
      title: "Section 8. Fertility Preferences"
      precondition:
        - predicate: consent == 1
      items:
        - id: q803_want_more_pregnant
          kind: Question
          title: "After the child you are expecting now, would you like to have another child, or would you prefer not to have any more children?"
          precondition:
            - predicate: is_pregnant == 1
            - predicate: sterilized == 0
          input:
            control: Radio
            labels:
              1: "Have another child"
              2: "No more"
              8: "Undecided/Don't know"
          codeBlock: |
            if q803_want_more_pregnant.outcome == 1:
                wants_more = 1

        - id: q804_want_child
          kind: Question
          title: "Now I have some questions about the future. Would you like to have (a/another) child, or would you prefer not to have any (more) children?"
          precondition:
            - predicate: is_pregnant == 0
            - predicate: sterilized == 0
          input:
            control: Radio
            labels:
              1: "Have (a/another) child"
              2: "No more/None"
              3: "Says she can't get pregnant"
              8: "Undecided/Don't know"
          codeBlock: |
            if q804_want_child.outcome == 1:
                wants_more = 1

        - id: q805_wait_time
          kind: Question
          title: "How long would you like to wait from now before the birth of (a/another) child?"
          precondition:
            - predicate: wants_more == 1
          input:
            control: Radio
            labels:
              1: "Months"
              2: "Years"
              993: "Soon/now"
              994: "Says she can't get pregnant"
              995: "After marriage"
              996: "Other"
              998: "Don't know"

        - id: q810_reason_not_using
          kind: Question
          title: "Can you tell me why you are not using a method to prevent pregnancy?"
          precondition:
            - predicate: using_method == 0
            - predicate: sterilized == 0
            - predicate: currently_in_union == 1 or ever_in_union == 1
          input:
            control: Dropdown
            labels:
              1: "Not married"
              2: "Not having sex"
              3: "Infrequent sex"
              4: "Menopausal/Hysterectomy"
              5: "Can't get pregnant"
              6: "Not menstruated since last birth"
              7: "Breastfeeding"
              8: "Up to God/Fatalistic"
              9: "Respondent opposed"
              10: "Husband/partner opposed"
              11: "Others opposed"
              12: "Religious prohibition"
              13: "Knows no method"
              14: "Knows no source"
              15: "Inconvenient to use"
              16: "Changes in menstrual bleeding"
              17: "Methods could cause infertility"
              18: "Interferes with body's normal processes"
              19: "Other side effects"
              20: "Lack of access/too far"
              21: "Costs too much"
              22: "Preferred method not available"
              23: "No method available"
              96: "Other"
              98: "Don't know"

        - id: q812_future_use
          kind: Question
          title: "Do you think you will use a contraceptive method to delay or avoid pregnancy at any time in the future?"
          precondition:
            - predicate: using_method == 0
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q813_ideal_children
          kind: Question
          title: "If you could go back to the time you did not have any children and could choose exactly the number of children to have in your whole life, how many would that be?"
          input:
            control: Editbox
            min: 0
            max: 30

        - id: q814_ideal_boys
          kind: Question
          title: "How many of these children would you like to be boys?"
          precondition:
            - predicate: q813_ideal_children.outcome >= 1
          input:
            control: Editbox
            min: 0
            max: 30

        - id: q814_ideal_girls
          kind: Question
          title: "How many of these children would you like to be girls?"
          precondition:
            - predicate: q813_ideal_children.outcome >= 1
          input:
            control: Editbox
            min: 0
            max: 30

        - id: q814_ideal_either
          kind: Question
          title: "How many would it not matter if it's a boy or a girl?"
          precondition:
            - predicate: q813_ideal_children.outcome >= 1
          input:
            control: Editbox
            min: 0
            max: 30

        - id: q815_fp_media
          kind: Comment
          title: "In the last 12 months have you heard or seen family planning messages through various media?"

        - id: q815a_radio_fp
          kind: Question
          title: "Heard about family planning on the radio?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q815b_tv_fp
          kind: Question
          title: "Seen anything about family planning on the television?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q815c_newspaper_fp
          kind: Question
          title: "Read about family planning in a newspaper or magazine?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q815d_mobile_fp
          kind: Question
          title: "Received a voice or text message about family planning on a mobile phone?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q815e_social_fp
          kind: Question
          title: "Seen anything about family planning on social media such as Facebook, Twitter, or Instagram?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q815f_poster_fp
          kind: Question
          title: "Seen anything about family planning on a poster, leaflet or brochure?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q815g_billboard_fp
          kind: Question
          title: "Seen anything about family planning on an outdoor sign or billboard?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q815h_community_fp
          kind: Question
          title: "Heard anything about family planning at community meetings or events?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q819_opinion_importance
          kind: Question
          title: "When making this decision with your (husband/partner), would you say that your opinion is more important, equally important, or less important than your (husband/partner's) opinion?"
          precondition:
            - predicate: currently_in_union == 1
          input:
            control: Radio
            labels:
              1: "More important"
              2: "Equally important"
              3: "Less important"

        - id: q818_decision_contraception
          kind: Question
          title: "Who usually makes the decision on whether or not you should use contraception: you, your (husband/partner), you and your (husband/partner) jointly, or someone else?"
          precondition:
            - predicate: currently_in_union == 1
          input:
            control: Radio
            labels:
              1: "Respondent"
              2: "Husband/Partner"
              3: "Respondent and husband/partner jointly"
              4: "Someone else"
              6: "Other"

        - id: q820_pressure_pregnant
          kind: Question
          title: "Has your (husband/partner) or any other family member ever tried to force or pressure you to become pregnant when you did not want to become pregnant?"
          precondition:
            - predicate: currently_in_union == 1 or ever_in_union == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q822_partner_wants
          kind: Question
          title: "Does your (husband/partner) want the same number of children that you want, or does he want more or fewer than you want?"
          precondition:
            - predicate: currently_in_union == 1
            - predicate: sterilized == 0
          input:
            control: Radio
            labels:
              1: "Same number"
              2: "More children"
              3: "Fewer children"
              8: "Don't know"

    # =========================================================================
    # SECTION 9: HUSBAND'S BACKGROUND AND WOMAN'S WORK
    # =========================================================================
    - id: b_husband_work
      title: "Section 9. Husband's Background and Woman's Work"
      precondition:
        - predicate: consent == 1
      items:
        - id: q902_husband_age
          kind: Question
          title: "How old was your (husband/partner) on his last birthday?"
          precondition:
            - predicate: currently_in_union == 1
          input:
            control: Editbox
            min: 15
            max: 95
            right: "years"

        - id: q903_husband_school
          kind: Question
          title: "Did your (husband/partner) ever attend school?"
          precondition:
            - predicate: currently_in_union == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q904_husband_education
          kind: Question
          title: "What was the highest level of school he attended: primary, secondary, or higher?"
          precondition:
            - predicate: q903_husband_school.outcome == 1
          input:
            control: Radio
            labels:
              1: "Primary"
              2: "Secondary"
              3: "Higher"
              8: "Don't know"

        - id: q905_husband_grade
          kind: Question
          title: "What was the highest [GRADE/FORM/YEAR] he completed at that level? If completed less than one year at that level, record '00'."
          precondition:
            - predicate: q903_husband_school.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 20

        - id: q906_husband_work_7days
          kind: Question
          title: "Has your (husband/partner) done any work in the last 7 days?"
          precondition:
            - predicate: currently_in_union == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
          codeBlock: |
            if q906_husband_work_7days.outcome == 1:
                husband_worked = 1

        - id: q907_husband_work_12m
          kind: Question
          title: "Has your (husband/partner) done any work in the last 12 months?"
          precondition:
            - predicate: currently_in_union == 1
            - predicate: q906_husband_work_7days.outcome in [2, 8]
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
          codeBlock: |
            if q907_husband_work_12m.outcome == 1:
                husband_worked = 1

        - id: q908_husband_occupation
          kind: Question
          title: "What is your (husband's/partner's) occupation? That is, what kind of work does he mainly do?"
          precondition:
            - predicate: husband_worked == 1
          input:
            control: Editbox
            min: 1
            max: 999

        - id: q909_respondent_work
          kind: Question
          title: "Aside from your own housework, have you done any work in the last 7 days?"
          input:
            control: Switch
            on: "Yes"
            off: "No"
          codeBlock: |
            if q909_respondent_work.outcome == 1:
                respondent_worked = 1

        - id: q910_other_work
          kind: Question
          title: "As you know, some women take up jobs for which they are paid in cash or kind. Others sell things, have a small business or work on the family farm or in the family business. In the last 7 days, have you done any of these things or any other work?"
          precondition:
            - predicate: q909_respondent_work.outcome == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"
          codeBlock: |
            if q910_other_work.outcome == 1:
                respondent_worked = 1

        - id: q911_absent_work
          kind: Question
          title: "Although you did not work in the last 7 days, do you have any job or business from which you were absent for leave, illness, vacation, maternity leave, or any other such reason?"
          precondition:
            - predicate: q909_respondent_work.outcome == 0
            - predicate: q910_other_work.outcome == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"
          codeBlock: |
            if q911_absent_work.outcome == 1:
                respondent_worked = 1

        - id: q912_work_12m
          kind: Question
          title: "Have you done any work in the last 12 months?"
          precondition:
            - predicate: q909_respondent_work.outcome == 0
            - predicate: q910_other_work.outcome == 0
            - predicate: q911_absent_work.outcome == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"
          codeBlock: |
            if q912_work_12m.outcome == 1:
                respondent_worked = 1

        - id: q913_occupation
          kind: Question
          title: "What is your occupation? That is, what kind of work do you mainly do?"
          precondition:
            - predicate: respondent_worked == 1
          input:
            control: Editbox
            min: 1
            max: 999

        - id: q914_employer
          kind: Question
          title: "Do you do this work for a member of your family, for someone else, or are you self-employed?"
          precondition:
            - predicate: respondent_worked == 1
          input:
            control: Radio
            labels:
              1: "For family member"
              2: "For someone else"
              3: "Self-employed"

        - id: q915_work_frequency
          kind: Question
          title: "Do you usually work throughout the year, or do you work seasonally, or only once in a while?"
          precondition:
            - predicate: respondent_worked == 1
          input:
            control: Radio
            labels:
              1: "Throughout the year"
              2: "Seasonally/part of the year"
              3: "Once in a while"

        - id: q916_payment
          kind: Question
          title: "Are you paid in cash or kind for this work or are you not paid at all?"
          precondition:
            - predicate: respondent_worked == 1
          input:
            control: Radio
            labels:
              1: "Cash only"
              2: "Cash and kind"
              3: "In kind only"
              4: "Not paid"
          codeBlock: |
            if q916_payment.outcome in [1, 2]:
                paid_for_work = 1

        - id: q919_earnings_decision
          kind: Question
          title: "Who usually decides how the money you earn will be used: you, your (husband/partner), or you and your (husband/partner) jointly?"
          precondition:
            - predicate: currently_in_union == 1
            - predicate: paid_for_work == 1
          input:
            control: Radio
            labels:
              1: "Respondent"
              2: "Husband/Partner"
              3: "Respondent and husband/partner jointly"
              6: "Other"

        - id: q920_earnings_comparison
          kind: Question
          title: "Would you say that the money that you earn is more than what your (husband/partner) earns, less than what he earns, or about the same?"
          precondition:
            - predicate: currently_in_union == 1
            - predicate: paid_for_work == 1
          input:
            control: Radio
            labels:
              1: "More than him"
              2: "Less than him"
              3: "About the same"
              4: "Husband/partner has no earnings"
              8: "Don't know"

        - id: q921_husband_earnings_decision
          kind: Question
          title: "Who usually decides how your (husband's/partner's) earnings will be used: you, your (husband/partner), or you and your (husband/partner) jointly?"
          precondition:
            - predicate: currently_in_union == 1
            - predicate: paid_for_work == 1
          input:
            control: Radio
            labels:
              1: "Respondent"
              2: "Husband/Partner"
              3: "Respondent and husband/partner jointly"
              4: "Husband/partner has no earnings"
              6: "Other"

        - id: q922_health_decisions
          kind: Question
          title: "Who usually makes decisions about health care for yourself: you, your (husband/partner), you and your (husband/partner) jointly, or someone else?"
          precondition:
            - predicate: currently_in_union == 1
          input:
            control: Radio
            labels:
              1: "Respondent"
              2: "Husband/Partner"
              3: "Respondent and husband/partner jointly"
              4: "Someone else"
              6: "Other"

        - id: q923_purchases
          kind: Question
          title: "Who usually makes decisions about making major household purchases?"
          precondition:
            - predicate: currently_in_union == 1
          input:
            control: Radio
            labels:
              1: "Respondent"
              2: "Husband/Partner"
              3: "Respondent and husband/partner jointly"
              4: "Someone else"
              6: "Other"

        - id: q924_family_visits
          kind: Question
          title: "Who usually makes decisions about visits to your family or relatives?"
          precondition:
            - predicate: currently_in_union == 1
          input:
            control: Radio
            labels:
              1: "Respondent"
              2: "Husband/Partner"
              3: "Respondent and husband/partner jointly"
              4: "Someone else"
              6: "Other"

        - id: q925_house_ownership
          kind: Question
          title: "Do you own this or any other house either alone or jointly with someone else?"
          input:
            control: Dropdown
            labels:
              1: "Alone only"
              2: "Jointly with husband/partner only"
              3: "Jointly with someone else only"
              4: "Jointly with husband/partner and someone else"
              5: "Both alone and jointly"
              6: "Does not own"
          codeBlock: |
            if q925_house_ownership.outcome in [1, 2, 3, 4, 5]:
                owns_house = 1

        - id: q926_house_title
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
          codeBlock: |
            if q926_house_title.outcome == 1:
                has_house_title = 1

        - id: q927_house_name_on_title
          kind: Question
          title: "Is your name on this document?"
          precondition:
            - predicate: has_house_title == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q928_land_ownership
          kind: Question
          title: "Do you own any agricultural or non-agricultural land either alone or jointly with someone else?"
          input:
            control: Dropdown
            labels:
              1: "Alone only"
              2: "Jointly with husband/partner only"
              3: "Jointly with someone else only"
              4: "Jointly with husband/partner and someone else"
              5: "Both alone and jointly"
              6: "Does not own"
          codeBlock: |
            if q928_land_ownership.outcome in [1, 2, 3, 4, 5]:
                owns_land = 1

        - id: q929_land_title
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
          codeBlock: |
            if q929_land_title.outcome == 1:
                has_land_title = 1

        - id: q930_land_name_on_title
          kind: Question
          title: "Is your name on this document?"
          precondition:
            - predicate: has_land_title == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q930a_bank_account
          kind: Question
          title: "Do you have an account in a bank or other financial institution that you yourself use?"
          input:
            control: Switch
            on: "Yes"
            off: "No"
          codeBlock: |
            if q930a_bank_account.outcome == 1:
                has_bank_account = 1

        - id: q930b_bank_activity
          kind: Question
          title: "Did you yourself put money in or take money out of this account in the last 12 months?"
          precondition:
            - predicate: has_bank_account == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q930c_mobile_money
          kind: Question
          title: "In the last 12 months, have you used a mobile phone to make financial transactions such as sending or receiving money, paying bills, purchasing goods or services, or receiving wages?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q932_violence_attitudes
          kind: Comment
          title: "In your opinion, is a husband justified in hitting or beating his wife in the following situations?"

        - id: q932a_goes_out
          kind: Question
          title: "If she goes out without telling him?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q932b_neglects_children
          kind: Question
          title: "If she neglects the children?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q932c_argues
          kind: Question
          title: "If she argues with him?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q932d_refuses_sex
          kind: Question
          title: "If she refuses to have sex with him?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q932e_burns_food
          kind: Question
          title: "If she burns the food?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

    # =========================================================================
    # SECTION 10: HIV/AIDS
    # =========================================================================
    - id: b_hiv
      title: "Section 10. HIV/AIDS"
      precondition:
        - predicate: consent == 1
      items:
        - id: q1000_intro
          kind: Comment
          title: "Now I would like to talk about HIV and AIDS."

        - id: q1001_heard_hiv
          kind: Question
          title: "Have you ever heard of HIV or AIDS?"
          input:
            control: Switch
            on: "Yes"
            off: "No"
          codeBlock: |
            if q1001_heard_hiv.outcome == 1:
                heard_hiv = 1

        - id: q1003_reduce_risk
          kind: Question
          title: "Can people reduce their chance of getting HIV by having just one uninfected sex partner who has no other sex partners?"
          precondition:
            - predicate: heard_hiv == 1
            - predicate: is_young_woman == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q1004_mosquito
          kind: Question
          title: "Can people get HIV from mosquito bites?"
          precondition:
            - predicate: heard_hiv == 1
            - predicate: is_young_woman == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q1005_condom_hiv
          kind: Question
          title: "Can people reduce their chance of getting HIV by using a condom every time they have sex?"
          precondition:
            - predicate: heard_hiv == 1
            - predicate: is_young_woman == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q1006_sharing_food
          kind: Question
          title: "Can people get HIV by sharing food with a person who has HIV?"
          precondition:
            - predicate: heard_hiv == 1
            - predicate: is_young_woman == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q1007_healthy_looking
          kind: Question
          title: "Is it possible for a healthy-looking person to have HIV?"
          precondition:
            - predicate: heard_hiv == 1
            - predicate: is_young_woman == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q1008_heard_arvs
          kind: Question
          title: "Have you heard of ARVs, that is, antiretroviral medicines that treat HIV?"
          precondition:
            - predicate: heard_hiv == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q1009_pmtct
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

        - id: q1010_heard_prep
          kind: Question
          title: "Have you heard of PrEP, a medicine taken daily that can prevent a person from getting HIV?"
          precondition:
            - predicate: heard_hiv == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"
          codeBlock: |
            if q1010_heard_prep.outcome == 1:
                heard_prep = 1

        - id: q1011_approve_prep
          kind: Question
          title: "Do you approve of people who take a pill every day to prevent getting HIV?"
          precondition:
            - predicate: heard_prep == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know/Not sure/Depends"

        - id: q1024_ever_tested
          kind: Question
          title: "Have you ever been tested for HIV?"
          precondition:
            - predicate: heard_hiv == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"
          codeBlock: |
            if q1024_ever_tested.outcome == 1:
                tested_hiv_ever = 1

        - id: q1027_results
          kind: Question
          title: "Did you get the results of the test?"
          precondition:
            - predicate: tested_hiv_ever == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q1028_result
          kind: Question
          title: "What was the result of the test?"
          precondition:
            - predicate: tested_hiv_ever == 1
            - predicate: q1027_results.outcome == 1
          input:
            control: Radio
            labels:
              1: "Positive"
              2: "Negative"
              3: "Indeterminate"
              4: "Declined to answer"
              5: "Did not receive test result"
          codeBlock: |
            hiv_result = q1028_result.outcome
            if q1028_result.outcome == 1:
                hiv_positive = 1

        - id: q1029_first_positive_date
          kind: Question
          title: "In what month and year did you receive your first HIV-positive test result? (Record month 1-12, 95 for same as last test, 98 for DK)"
          precondition:
            - predicate: hiv_positive == 1
          input:
            control: Editbox
            min: 1
            max: 98

        - id: q1030_taking_arvs
          kind: Question
          title: "Are you currently taking ARVs, that is, antiretroviral medicines?"
          precondition:
            - predicate: hiv_positive == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q1031_test_count
          kind: Question
          title: "How many times have you been tested for HIV in your lifetime?"
          precondition:
            - predicate: tested_hiv_ever == 1
          input:
            control: Editbox
            min: 1
            max: 95

        - id: q1032_self_test_kit
          kind: Question
          title: "Have you heard of test kits people can use to test themselves for HIV?"
          precondition:
            - predicate: heard_hiv == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"
          codeBlock: |
            if q1032_self_test_kit.outcome == 1:
                heard_self_test = 1

        - id: q1033_used_self_test
          kind: Question
          title: "Have you ever tested yourself for HIV using a self-test kit?"
          precondition:
            - predicate: heard_self_test == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q1034_buy_vegetables
          kind: Question
          title: "Would you buy fresh vegetables from a shopkeeper or vendor if you knew that this person had HIV?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know/Not sure/Depends"

        - id: q1035_children_school
          kind: Question
          title: "Do you think children living with HIV should be allowed to attend school with children who do not have HIV?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know/Not sure/Depends"

        - id: q1040_heard_sti
          kind: Question
          title: "Apart from HIV, have you heard about other infections that can be transmitted through sexual contact?"
          precondition:
            - predicate: heard_hiv == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"
          codeBlock: |
            if q1040_heard_sti.outcome == 1:
                heard_sti = 1

        - id: q1043_sti_12m
          kind: Question
          title: "During the last 12 months, have you had a disease which you got through sexual contact?"
          precondition:
            - predicate: ever_had_sex == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q1044_discharge
          kind: Question
          title: "Sometimes women experience a bad-smelling abnormal genital discharge. During the last 12 months, have you had a bad-smelling abnormal genital discharge?"
          precondition:
            - predicate: ever_had_sex == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q1045_sore
          kind: Question
          title: "Sometimes women have a genital sore or ulcer. During the last 12 months, have you had a genital sore or ulcer?"
          precondition:
            - predicate: ever_had_sex == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q1046_condom_justified
          kind: Question
          title: "If a wife knows her husband has a disease that she can get during sexual intercourse, is she justified in asking that they use a condom when they have sex?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q1047_refuse_sex
          kind: Question
          title: "Is a wife justified in refusing to have sex with her husband when she knows he has sex with other women?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q1049_can_refuse
          kind: Question
          title: "Can you say no to your (husband/partner) if you do not want to have sexual intercourse?"
          precondition:
            - predicate: currently_in_union == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Depends/Not sure"

        - id: q1050_ask_condom
          kind: Question
          title: "Could you ask your (husband/partner) to use a condom if you wanted him to?"
          precondition:
            - predicate: currently_in_union == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Depends/Not sure"

    # =========================================================================
    # SECTION 11: OTHER HEALTH ISSUES
    # =========================================================================
    - id: b_other_health
      title: "Section 11. Other Health Issues"
      precondition:
        - predicate: consent == 1
      items:
        - id: q1101_travel_time
          kind: Question
          title: "How long does it take in minutes to go from your home to the nearest healthcare facility?"
          input:
            control: Editbox
            min: 0
            max: 999
            right: "minutes"

        - id: q1102_transport
          kind: Question
          title: "How do you travel to this healthcare facility from your home?"
          input:
            control: Dropdown
            labels:
              1: "Car/truck"
              2: "Public bus"
              3: "Motorcycle/scooter"
              4: "Boat with motor"
              5: "Animal-drawn cart"
              6: "Bicycle"
              7: "Boat without motor"
              8: "Walking"
              96: "Other"

        - id: q1103_breast_exam
          kind: Question
          title: "Has a doctor or other healthcare provider examined your breasts to check for breast cancer?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q1104_cervical_description
          kind: Comment
          title: "Now I'm going to ask you about tests a healthcare worker can do to check for cervical cancer. The cervix connects the womb to the vagina. To be checked for cervical cancer, a woman is asked to lie on her back with her legs apart. Then the healthcare worker will use a brush or swab to collect a sample from inside her. This test is called a Pap smear or HPV test. Another method is called a VIA or Visual Inspection with Acetic Acid."

        - id: q1105_cervical_test
          kind: Question
          title: "Has a doctor or other healthcare worker ever tested you for cervical cancer?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        - id: q1106_smoking
          kind: Question
          title: "Do you currently smoke cigarettes every day, some days, or not at all?"
          input:
            control: Radio
            labels:
              1: "Every day"
              2: "Some days"
              3: "Not at all"
          codeBlock: |
            if q1106_smoking.outcome in [1, 2]:
                smokes = 1

        - id: q1107_cigarettes_day
          kind: Question
          title: "On average, how many cigarettes do you currently smoke each day?"
          precondition:
            - predicate: q1106_smoking.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 99

        - id: q1108_other_tobacco
          kind: Question
          title: "Do you currently smoke or use any other type of tobacco every day, some days, or not at all?"
          input:
            control: Radio
            labels:
              1: "Every day"
              2: "Some days"
              3: "Not at all"
          codeBlock: |
            if q1108_other_tobacco.outcome in [1, 2]:
                uses_other_tobacco = 1

        - id: q1109_tobacco_type
          kind: Question
          title: "What other type of tobacco do you currently smoke or use?"
          precondition:
            - predicate: uses_other_tobacco == 1
          input:
            control: Checkbox
            labels:
              1: "Kreteks"
              2: "Pipes full of tobacco"
              4: "Cigars, cheroots, or cigarillos"
              8: "Water pipe"
              16: "Snuff by mouth"
              32: "Snuff by nose"
              64: "Chewing tobacco"
              128: "Betel quid with tobacco"
              256: "Other"

        - id: q1110_alcohol
          kind: Question
          title: "Have you ever consumed any alcohol, such as beer, wine, spirits, or other local examples?"
          input:
            control: Switch
            on: "Yes"
            off: "No"
          codeBlock: |
            if q1110_alcohol.outcome == 1:
                ever_drank_alcohol = 1

        - id: q1111_alcohol_frequency
          kind: Question
          title: "During the last one month, on how many days did you have an alcoholic drink? (Record '00' if did not drink, '95' for every day/almost every day.)"
          precondition:
            - predicate: ever_drank_alcohol == 1
          input:
            control: Editbox
            min: 0
            max: 95
          codeBlock: |
            if q1111_alcohol_frequency.outcome > 0:
                drank_recently = 1

        - id: q1112_drinks_per_day
          kind: Question
          title: "In the last one month, on the days that you drank alcohol, how many drinks did you usually have per day?"
          precondition:
            - predicate: drank_recently == 1
          input:
            control: Editbox
            min: 0
            max: 30

        - id: q1113_barriers
          kind: Comment
          title: "Many different factors can prevent women from getting medical advice or treatment for themselves. When you are sick and want to get medical advice or treatment, is each of the following a big problem or not a big problem?"

        - id: q1113a_permission
          kind: Question
          title: "Getting permission to go to the doctor?"
          input:
            control: Radio
            labels:
              1: "Big problem"
              2: "Not a big problem"

        - id: q1113b_money
          kind: Question
          title: "Getting money needed for advice or treatment?"
          input:
            control: Radio
            labels:
              1: "Big problem"
              2: "Not a big problem"

        - id: q1113c_distance
          kind: Question
          title: "The distance to the health facility?"
          input:
            control: Radio
            labels:
              1: "Big problem"
              2: "Not a big problem"

        - id: q1113d_go_alone
          kind: Question
          title: "Not wanting to go alone?"
          input:
            control: Radio
            labels:
              1: "Big problem"
              2: "Not a big problem"

        - id: q1114_insurance
          kind: Question
          title: "Are you covered by any health insurance?"
          input:
            control: Switch
            on: "Yes"
            off: "No"
          codeBlock: |
            if q1114_insurance.outcome == 1:
                has_insurance = 1

        - id: q1115_insurance_type
          kind: Question
          title: "What type of health insurance are you covered by? (RECORD ALL MENTIONED.)"
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

        - id: q1116_end_time
          kind: Question
          title: "RECORD THE TIME. (Hours, 0-23)"
          input:
            control: Editbox
            min: 0
            max: 23
