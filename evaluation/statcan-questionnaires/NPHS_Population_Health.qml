qmlVersion: "1.0"
questionnaire:
  title: "National Population Health Survey (NPHS) - Statistics Canada"
  codeInit: |
    age = 0
    sex = 0
    marital_status = 0
    is_working = 0
    has_children = 0
    is_proxy = 0
    is_female = 0
    is_married_or_partnered = 0
    bed_days = 0
    cut_down_days = 0
    smokes_daily = 0
    smokes_occasionally = 0
    ever_smoked = 0
    drank_past_year = 0
    ever_drank = 0
    has_asthma = 0
    has_cancer = 0
    has_limitation = 0
    has_disability = 0
    bicycles = 0
    had_injury = 0
    depression_screen_sad = 0
    depression_screen_interest = 0

  blocks:
    # =========================================================================
    # DEMOGRAPHICS
    # =========================================================================
    - id: demographics
      title: "Demographics"
      items:
        - id: demo_q4
          kind: Question
          title: "What is your age?"
          input:
            control: Editbox
            min: 0
            max: 120
          codeBlock: |
            age = demo_q4

        - id: demo_q5
          kind: Question
          title: "What is your sex?"
          input:
            control: Radio
            labels:
              1: "Male"
              2: "Female"
          codeBlock: |
            sex = demo_q5
            is_female = 1 if sex == 2 else 0

        - id: demo_q6
          kind: Question
          title: "What is your marital status?"
          precondition:
            - predicate: age >= 15
          input:
            control: Radio
            labels:
              1: "Married"
              2: "Living common-law"
              3: "Widowed"
              4: "Separated"
              5: "Divorced"
              6: "Single, never married"
          codeBlock: |
            marital_status = demo_q6
            is_married_or_partnered = 1 if marital_status in (1, 2) else 0

    # =========================================================================
    # HOUSEHOLD
    # =========================================================================
    - id: household
      title: "Household"
      items:
        - id: hhld_q1
          kind: Question
          title: "Is this dwelling owned by a member of this household?"
          input:
            control: Switch

        - id: hhld_q3
          kind: Question
          title: "How many bedrooms are there in this dwelling?"
          input:
            control: Editbox
            min: 0
            max: 30

        - id: hhld_q4
          kind: Question
          title: "Do you have a pet?"
          input:
            control: Switch

        - id: hhld_q5
          kind: Question
          title: "What kind of pet do you have?"
          precondition:
            - predicate: hhld_q4 == 1
          input:
            control: Radio
            labels:
              1: "Dog"
              2: "Cat"
              3: "Other"

        - id: hhld_q5a
          kind: Question
          title: "Does your pet live mostly indoors?"
          precondition:
            - predicate: hhld_q4 == 1
          input:
            control: Switch

    # =========================================================================
    # TWO-WEEK DISABILITY
    # =========================================================================
    - id: two_week_disability
      title: "Two-Week Disability"
      items:
        - id: twowk_q1
          kind: Question
          title: "During the past 2 weeks, did you stay in bed because of illness or injury (including any nights in hospital)?"
          input:
            control: Switch
          codeBlock: |
            bed_days = 0
            cut_down_days = 0

        - id: twowk_q2
          kind: Question
          title: "How many days did you stay in bed all or most of the day?"
          precondition:
            - predicate: twowk_q1 == 1
          input:
            control: Editbox
            min: 1
            max: 14
          postcondition:
            - predicate: twowk_q2 <= 14
              hint: "Days in bed cannot exceed 14 (two weeks)."
          codeBlock: |
            bed_days = twowk_q2

        - id: twowk_q3
          kind: Question
          title: "During the past 2 weeks, did you have to cut down on things you normally do because of illness or injury?"
          precondition:
            - predicate: twowk_q1 == 0 or (twowk_q1 == 1 and bed_days < 14)
          input:
            control: Switch

        - id: twowk_q4
          kind: Question
          title: "How many days did you have to cut down?"
          precondition:
            - predicate: twowk_q3 == 1
          input:
            control: Editbox
            min: 1
            max: 14
          postcondition:
            - predicate: bed_days + twowk_q4 <= 14
              hint: "Days in bed plus days cut down cannot exceed 14."
          codeBlock: |
            cut_down_days = twowk_q4

        - id: twowk_q5
          kind: Question
          title: "Do you have a regular medical doctor?"
          input:
            control: Switch

    # =========================================================================
    # HEALTH CARE UTILIZATION (age >= 12)
    # =========================================================================
    - id: health_care_utilization
      title: "Health Care Utilization"
      items:
        - id: util_q1
          kind: Question
          title: "In the past 12 months, were you a patient overnight in any hospital, nursing home, or convalescent home?"
          precondition:
            - predicate: age >= 12
          input:
            control: Switch

        - id: util_q1a
          kind: Question
          title: "How many nights in total?"
          precondition:
            - predicate: age >= 12 and util_q1 == 1
          input:
            control: Editbox
            min: 1
            max: 365

        - id: util_q2
          kind: Comment
          title: "In the past 12 months, how many times have you seen or talked on the telephone about your physical, emotional, or mental health with the following:"
          precondition:
            - predicate: age >= 12

        - id: util_q2a
          kind: Question
          title: "a) Family doctor or general practitioner"
          precondition:
            - predicate: age >= 12
          input:
            control: Editbox
            min: 0
            max: 365

        - id: util_q2b
          kind: Question
          title: "b) Eye specialist (ophthalmologist or optometrist)"
          precondition:
            - predicate: age >= 12
          input:
            control: Editbox
            min: 0
            max: 365

        - id: util_q2c
          kind: Question
          title: "c) Other medical doctor (such as surgeon, allergist, gynaecologist, psychiatrist)"
          precondition:
            - predicate: age >= 12
          input:
            control: Editbox
            min: 0
            max: 365

        - id: util_q2d
          kind: Question
          title: "d) Dentist or orthodontist"
          precondition:
            - predicate: age >= 12
          input:
            control: Editbox
            min: 0
            max: 365

        - id: util_q2e
          kind: Question
          title: "e) Chiropractor"
          precondition:
            - predicate: age >= 12
          input:
            control: Editbox
            min: 0
            max: 365

        - id: util_q2f
          kind: Question
          title: "f) Physiotherapist"
          precondition:
            - predicate: age >= 12
          input:
            control: Editbox
            min: 0
            max: 365

        - id: util_q2g
          kind: Question
          title: "g) Psychologist"
          precondition:
            - predicate: age >= 12
          input:
            control: Editbox
            min: 0
            max: 365

        - id: util_q2h
          kind: Question
          title: "h) Social worker or counsellor"
          precondition:
            - predicate: age >= 12
          input:
            control: Editbox
            min: 0
            max: 365

        - id: util_q2i
          kind: Question
          title: "i) Speech therapist or audiologist"
          precondition:
            - predicate: age >= 12
          input:
            control: Editbox
            min: 0
            max: 365

        - id: util_q2j
          kind: Question
          title: "j) Nurse"
          precondition:
            - predicate: age >= 12
          input:
            control: Editbox
            min: 0
            max: 365

        - id: util_q4
          kind: Question
          title: "In the past 12 months, have you consulted an alternative health care provider such as an acupuncturist, homeopath, or massage therapist?"
          precondition:
            - predicate: age >= 12
          input:
            control: Switch

        - id: util_q5
          kind: Question
          title: "What type of alternative health care provider did you see?"
          precondition:
            - predicate: age >= 12 and util_q4 == 1
          input:
            control: Checkbox
            labels:
              1: "Massage therapist"
              2: "Acupuncturist"
              4: "Homeopath or naturopath"
              8: "Feldenkrais or Alexander teacher"
              16: "Relaxation therapist"
              32: "Biofeedback teacher"
              64: "Rolfer"
              128: "Herbalist"
              256: "Reflexologist"
              512: "Spiritual healer"
              1024: "Religious healer"
              2048: "Imagery technique practitioner"
              4096: "Other"

        - id: util_q6
          kind: Question
          title: "During the past 12 months, was there ever a time when you felt that you needed health care but you didn't receive it?"
          precondition:
            - predicate: age >= 12
          input:
            control: Switch

        - id: util_q7
          kind: Question
          title: "Why didn't you get care?"
          precondition:
            - predicate: age >= 12 and util_q6 == 1
          input:
            control: Radio
            labels:
              1: "Not available in the area"
              2: "Not available at the time required"
              3: "Waiting time too long"
              4: "Felt it would be inadequate"
              5: "Cost"

        - id: util_q8
          kind: Question
          title: "What type of care was needed?"
          precondition:
            - predicate: age >= 12 and util_q6 == 1
          input:
            control: Checkbox
            labels:
              1: "Treatment of a physical health problem"
              2: "Treatment of an emotional or mental health problem"
              4: "Regular check-up"
              8: "Care of an injury"
              16: "Other"

        - id: util_q9
          kind: Question
          title: "In the past 12 months, did you receive any home care services?"
          precondition:
            - predicate: age >= 18
          input:
            control: Switch

        - id: util_q10
          kind: Question
          title: "What type of home care services did you receive?"
          precondition:
            - predicate: age >= 18 and util_q9 == 1
          input:
            control: Checkbox
            labels:
              1: "Nursing care"
              2: "Other health care (physiotherapy, etc.)"
              4: "Personal care (bathing, dressing)"
              8: "Housework (laundry, cleaning)"
              16: "Meal preparation or delivery"
              32: "Respite care"

    # =========================================================================
    # RESTRICTION OF ACTIVITIES (age >= 12)
    # =========================================================================
    - id: restriction_of_activities
      title: "Restriction of Activities"
      items:
        - id: restr_intro
          kind: Comment
          title: "The next questions deal with any limitations in your daily activities."
          precondition:
            - predicate: age >= 12

        - id: restr_q1
          kind: QuestionGroup
          title: "Does a long-term physical or mental condition or health problem reduce the amount or the kind of activity you can do:"
          precondition:
            - predicate: age >= 12
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Not applicable"
          questions:
            - "a) At home?"
            - "b) At school?"
            - "c) At work?"
            - "d) In other activities such as transportation, leisure, or sports?"
          codeBlock: |
            has_limitation = 1 if (restr_q1.outcome[0] == 1 or restr_q1.outcome[1] == 1 or restr_q1.outcome[2] == 1 or restr_q1.outcome[3] == 1) else 0

        - id: restr_q2
          kind: Question
          title: "Do you have any long-term disabilities or handicaps?"
          precondition:
            - predicate: age >= 12
          input:
            control: Switch
          codeBlock: |
            has_disability = restr_q2

        - id: restr_q3
          kind: Question
          title: "What is the main condition or health problem that limits your activities?"
          precondition:
            - predicate: age >= 12 and has_limitation == 1
          input:
            control: Radio
            labels:
              1: "Allergies"
              2: "Asthma"
              3: "Arthritis/rheumatism"
              4: "Back problems"
              5: "Heart condition"
              6: "Cancer"
              7: "Diabetes"
              8: "Emphysema/bronchitis"
              9: "Depression/mental illness"
              10: "Injury"
              11: "Other"

        - id: restr_q4
          kind: Question
          title: "What is the main condition or health problem that causes your disability?"
          precondition:
            - predicate: age >= 12 and has_limitation == 0 and has_disability == 1
          input:
            control: Radio
            labels:
              1: "Allergies"
              2: "Asthma"
              3: "Arthritis/rheumatism"
              4: "Back problems"
              5: "Heart condition"
              6: "Cancer"
              7: "Diabetes"
              8: "Emphysema/bronchitis"
              9: "Depression/mental illness"
              10: "Injury"
              11: "Other"

        - id: restr_q5
          kind: Question
          title: "Was this condition caused by:"
          precondition:
            - predicate: age >= 12 and (has_limitation == 1 or has_disability == 1)
          input:
            control: Radio
            labels:
              1: "A condition present at birth"
              2: "A disease or illness"
              3: "A work-related injury"
              4: "A traffic accident"
              5: "A sports injury"
              6: "A fall"
              7: "Fire or fire-related"
              8: "Other accident or injury"
              9: "Natural aging"
              10: "Overwork or stress"
              11: "Other"

        - id: restr_q6
          kind: Question
          title: "Because of a long-term physical condition or health problem, do you need help with:"
          precondition:
            - predicate: age >= 12 and (has_limitation == 1 or has_disability == 1)
          input:
            control: Checkbox
            labels:
              1: "Preparing meals"
              2: "Shopping for necessities"
              4: "Everyday housework"
              8: "Heavy household chores"
              16: "Personal care"
              32: "Moving about inside the house"
              64: "None of the above"

    # =========================================================================
    # CHRONIC CONDITIONS (age >= 12)
    # =========================================================================
    - id: chronic_conditions
      title: "Chronic Conditions"
      items:
        - id: chron_intro
          kind: Comment
          title: "Now I'd like to ask about certain chronic health conditions which you may have. We are interested in long-term conditions that have lasted or are expected to last 6 months or more and that have been diagnosed by a health professional."
          precondition:
            - predicate: age >= 12

        - id: chron_q1
          kind: Question
          title: "Do you have any of the following long-term conditions that have been diagnosed by a health professional?"
          precondition:
            - predicate: age >= 12
          input:
            control: Checkbox
            labels:
              1: "Food allergies"
              2: "Other allergies"
              4: "Asthma"
              8: "Arthritis or rheumatism"
              16: "Back problems (excluding arthritis)"
              32: "High blood pressure"
              64: "Migraine headaches"
              128: "Chronic bronchitis or emphysema"
              256: "Sinusitis"
              512: "Diabetes"
              1024: "Epilepsy"
              2048: "Heart disease"
              4096: "Cancer"
              8192: "Stomach or intestinal ulcers"
              16384: "Effects of a stroke"
              32768: "Urinary incontinence"
              65536: "Any other long-term condition"
          codeBlock: |
            has_asthma = 1 if (chron_q1 & 4) else 0
            has_cancer = 1 if (chron_q1 & 4096) else 0

        - id: chron_q1_acne
          kind: Question
          title: "Do you have acne?"
          precondition:
            - predicate: age >= 12 and age < 30
          input:
            control: Switch

        - id: chron_q1_alzheimer
          kind: Question
          title: "Do you have Alzheimer's disease or any other dementia?"
          precondition:
            - predicate: age >= 18
          input:
            control: Switch

        - id: chron_q1_cataracts
          kind: Question
          title: "Do you have cataracts?"
          precondition:
            - predicate: age >= 18
          input:
            control: Switch

        - id: chron_q1_glaucoma
          kind: Question
          title: "Do you have glaucoma?"
          precondition:
            - predicate: age >= 18
          input:
            control: Switch

        - id: chron_q1mm
          kind: Question
          title: "What type of cancer?"
          precondition:
            - predicate: age >= 12 and has_cancer == 1
          input:
            control: Radio
            labels:
              1: "Breast"
              2: "Prostate"
              3: "Colorectal"
              4: "Lung"
              5: "Non-Hodgkin's lymphoma"
              6: "Bladder"
              7: "Skin (melanoma)"
              8: "Leukemia"
              9: "Other"

        - id: chron_q1cc1
          kind: Question
          title: "Have you had an asthma attack in the past 12 months?"
          precondition:
            - predicate: age >= 12 and has_asthma == 1
          input:
            control: Switch

        - id: chron_q1cc2
          kind: Question
          title: "Have you had wheezing or whistling in the chest at any time in the past 12 months?"
          precondition:
            - predicate: age >= 12
          input:
            control: Switch

    # =========================================================================
    # SOCIO-DEMOGRAPHICS
    # =========================================================================
    - id: socio_demographics
      title: "Socio-demographics"
      items:
        - id: socio_q1
          kind: Question
          title: "In what country were you born?"
          input:
            control: Radio
            labels:
              1: "Canada"
              2: "United Kingdom"
              3: "Italy"
              4: "Germany"
              5: "Poland"
              6: "United States"
              7: "Portugal"
              8: "China"
              9: "Hong Kong"
              10: "India"
              11: "Philippines"
              12: "Other"

        - id: socio_q3
          kind: Question
          title: "In what year did you first come to Canada to live?"
          precondition:
            - predicate: socio_q1 != 1
          input:
            control: Editbox
            min: 1900
            max: 2000

        - id: socio_q4
          kind: Question
          title: "To which ethnic or cultural group(s) do you belong?"
          input:
            control: Checkbox
            labels:
              1: "Canadian"
              2: "French"
              4: "English"
              8: "German"
              16: "Scottish"
              32: "Irish"
              64: "Italian"
              128: "Ukrainian"
              256: "Dutch"
              512: "Chinese"
              1024: "Jewish"
              2048: "Polish"
              4096: "Portuguese"
              8192: "South Asian"
              16384: "Black"
              32768: "North American Indian"
              65536: "Métis"
              131072: "Inuit/Eskimo"
              262144: "Other"

        - id: socio_q5
          kind: Question
          title: "What language(s) can you speak well enough to conduct a conversation?"
          input:
            control: Checkbox
            labels:
              1: "English"
              2: "French"
              4: "Other"

        - id: socio_q6
          kind: Question
          title: "What language did you first learn at home in childhood and still understand?"
          input:
            control: Checkbox
            labels:
              1: "English"
              2: "French"
              4: "Other"

        - id: socio_q7
          kind: Question
          title: "How would you best describe your race or colour?"
          input:
            control: Checkbox
            labels:
              1: "White"
              2: "Chinese"
              4: "South Asian"
              8: "Black"
              16: "Native/Aboriginal"
              32: "Arab/West Asian"
              64: "Filipino"
              128: "Southeast Asian"
              256: "Latin American"
              512: "Japanese"
              1024: "Korean"
              2048: "Other"

    # =========================================================================
    # EDUCATION (age >= 12)
    # =========================================================================
    - id: education
      title: "Education"
      items:
        - id: educ_q1
          kind: Question
          title: "How many years of elementary and high school education have you completed?"
          precondition:
            - predicate: age >= 12
          input:
            control: Dropdown
            labels:
              0: "None"
              1: "1 year"
              2: "2 years"
              3: "3 years"
              4: "4 years"
              5: "5 years"
              6: "6 years"
              7: "7 years"
              8: "8 years"
              9: "9 years"
              10: "10 years"
              11: "11 years"
              12: "12 years"
              13: "13 years"

        - id: educ_q2
          kind: Question
          title: "Did you graduate from high school (secondary school)?"
          precondition:
            - predicate: age >= 15
          input:
            control: Switch

        - id: educ_q3
          kind: Question
          title: "Have you had any further education beyond high school?"
          precondition:
            - predicate: age >= 15
          input:
            control: Switch

        - id: educ_q4
          kind: Question
          title: "What is the highest level of education you have attained?"
          precondition:
            - predicate: age >= 15 and educ_q3 == 1
          input:
            control: Radio
            labels:
              1: "Some community college, CEGEP, or nursing school"
              2: "Diploma or certificate from community college, CEGEP, or nursing school"
              3: "Some university (no degree)"
              4: "Bachelor's degree"
              5: "Master's degree"
              6: "Degree in medicine, dentistry, veterinary medicine, optometry, law, or theology"
              7: "Earned doctorate"

        - id: educ_q5
          kind: Question
          title: "Are you currently attending a school, college, or university?"
          precondition:
            - predicate: age >= 12 and age < 65
          input:
            control: Switch

        - id: educ_q6
          kind: Question
          title: "Are you attending full-time or part-time?"
          precondition:
            - predicate: age >= 12 and age < 65 and educ_q5 == 1
          input:
            control: Radio
            labels:
              1: "Full-time"
              2: "Part-time"

    # =========================================================================
    # LABOUR FORCE (age >= 15)
    # =========================================================================
    - id: labour_force
      title: "Labour Force"
      items:
        - id: lfs_q1
          kind: Question
          title: "Last week, what was your main activity?"
          precondition:
            - predicate: age >= 15
          input:
            control: Radio
            labels:
              1: "Caring for family"
              2: "Working at a job or business"
              3: "Looking for work"
              4: "Going to school"
              5: "Retired"
              6: "Long-term illness"
              7: "Maternity/paternity leave"
              8: "Other"

        - id: lfs_q2
          kind: Question
          title: "In the past 12 months, did you work at a job or business?"
          precondition:
            - predicate: age >= 15 and lfs_q1 != 2 and lfs_q1 != 3
          input:
            control: Switch

        - id: lfs_q3
          kind: Question
          title: "How many jobs did you have in the past 12 months?"
          precondition:
            - predicate: age >= 15 and (lfs_q1 == 2 or lfs_q1 == 3 or lfs_q2 == 1)
          input:
            control: Editbox
            min: 1
            max: 6

        - id: lfs_q4
          kind: Question
          title: "How long have you worked for your current (or most recent) employer?"
          precondition:
            - predicate: age >= 15 and (lfs_q1 == 2 or lfs_q1 == 3 or lfs_q2 == 1)
          input:
            control: Radio
            labels:
              1: "Less than 1 year"
              2: "1 to 5 years"
              3: "6 to 10 years"
              4: "11 to 20 years"
              5: "More than 20 years"

        - id: lfs_q5
          kind: Question
          title: "Do you currently have a job from which you are absent?"
          precondition:
            - predicate: age >= 15 and lfs_q1 != 2
          input:
            control: Switch

        - id: lfs_q6
          kind: Question
          title: "How many hours per week do (did) you usually work at your main job?"
          precondition:
            - predicate: age >= 15 and (lfs_q1 == 2 or lfs_q1 == 3 or lfs_q2 == 1)
          input:
            control: Editbox
            min: 1
            max: 100

        - id: lfs_q16
          kind: Question
          title: "In your main job, are (were) you:"
          precondition:
            - predicate: age >= 15 and (lfs_q1 == 2 or lfs_q1 == 3 or lfs_q2 == 1)
          input:
            control: Radio
            labels:
              1: "An employee working for wages, salary, tips, or commission"
              2: "Self-employed without paid help"
              3: "Self-employed with paid help"
              4: "An unpaid family worker"
          codeBlock: |
            is_working = 1 if (lfs_q1 == 2 or lfs_q5 == 1) else 0

    # =========================================================================
    # INCOME
    # =========================================================================
    - id: income
      title: "Income"
      items:
        - id: incom_q1
          kind: Question
          title: "What are the sources of income for your household?"
          input:
            control: Checkbox
            labels:
              1: "Wages and salaries"
              2: "Self-employment income"
              4: "Dividends and interest"
              8: "Employment Insurance"
              16: "Worker's Compensation"
              32: "Canada/Quebec Pension Plan"
              64: "Old Age Security/Guaranteed Income Supplement"
              128: "Provincial/municipal social assistance or welfare"
              256: "Child Tax Benefit"
              512: "Alimony, child support"
              1024: "Other government transfers"
              2048: "Retirement pensions, annuities"
              4096: "Other (rental income, scholarships, etc.)"

        - id: incom_q3
          kind: Question
          title: "What is your best estimate of the total income, before taxes and deductions, of all household members from all sources in the past 12 months?"
          input:
            control: Radio
            labels:
              1: "No income"
              2: "Less than $5,000"
              3: "$5,000 to $9,999"
              4: "$10,000 to $14,999"
              5: "$15,000 to $19,999"
              6: "$20,000 to $29,999"
              7: "$30,000 to $39,999"
              8: "$40,000 to $49,999"
              9: "$50,000 to $59,999"
              10: "$60,000 to $79,999"
              11: "$80,000 or more"

    # =========================================================================
    # GENERAL HEALTH (Health Component, age >= 12)
    # =========================================================================
    - id: general_health
      title: "General Health"
      items:
        - id: genhlt_q1
          kind: Question
          title: "In general, would you say your health is:"
          precondition:
            - predicate: age >= 12
          input:
            control: Radio
            labels:
              1: "Excellent"
              2: "Very good"
              3: "Good"
              4: "Fair"
              5: "Poor"

        - id: genhlt_q2
          kind: Question
          title: "Are you currently pregnant?"
          precondition:
            - predicate: is_female == 1 and age >= 15 and age <= 49
          input:
            control: Switch

        - id: genhlt_q3
          kind: Question
          title: "Are you receiving prenatal care from:"
          precondition:
            - predicate: is_female == 1 and age >= 15 and age <= 49 and genhlt_q2 == 1
          input:
            control: Radio
            labels:
              1: "A physician"
              2: "A midwife"
              3: "Both"
              4: "Neither"

    # =========================================================================
    # HEIGHT AND WEIGHT
    # =========================================================================
    - id: height_weight
      title: "Height and Weight"
      items:
        - id: htwt_q1
          kind: Question
          title: "How tall are you without shoes? (in centimetres)"
          precondition:
            - predicate: age >= 12
          input:
            control: Editbox
            min: 50
            max: 250

        - id: htwt_q2
          kind: Question
          title: "How much do you weigh? (in kilograms)"
          precondition:
            - predicate: age >= 12
          input:
            control: Editbox
            min: 10
            max: 300

    # =========================================================================
    # PREVENTIVE HEALTH (age >= 12, non-proxy)
    # =========================================================================
    - id: preventive_health
      title: "Preventive Health"
      items:
        - id: php_q1
          kind: Question
          title: "When was the last time you had your blood pressure checked by a health professional?"
          precondition:
            - predicate: age >= 12 and is_proxy == 0
          input:
            control: Radio
            labels:
              1: "Less than 6 months ago"
              2: "6 months to less than 1 year ago"
              3: "1 year to less than 2 years ago"
              4: "2 years to less than 5 years ago"
              5: "5 or more years ago"
              6: "Never"

        - id: php_q2
          kind: Question
          title: "Have you ever had a mammogram?"
          precondition:
            - predicate: is_female == 1 and age >= 35 and is_proxy == 0
          input:
            control: Switch

        - id: php_q2a
          kind: Question
          title: "When was your last mammogram?"
          precondition:
            - predicate: is_female == 1 and age >= 35 and is_proxy == 0 and php_q2 == 1
          input:
            control: Radio
            labels:
              1: "Less than 1 year ago"
              2: "1 to 2 years ago"
              3: "More than 2 years ago"

        - id: php_q2b
          kind: Question
          title: "What was the main reason for your last mammogram?"
          precondition:
            - predicate: is_female == 1 and age >= 35 and is_proxy == 0 and php_q2 == 1
          input:
            control: Radio
            labels:
              1: "Family history of breast cancer"
              2: "Breast problem (lump, pain, discharge)"
              3: "Routine screening"
              4: "Other"

        - id: php_q3
          kind: Question
          title: "Have you ever had a PAP smear test?"
          precondition:
            - predicate: is_female == 1 and age >= 18 and is_proxy == 0
          input:
            control: Switch

        - id: php_q3a
          kind: Question
          title: "When was your last PAP smear test?"
          precondition:
            - predicate: is_female == 1 and age >= 18 and is_proxy == 0 and php_q3 == 1
          input:
            control: Radio
            labels:
              1: "Less than 6 months ago"
              2: "6 months to less than 1 year ago"
              3: "1 year to less than 3 years ago"
              4: "3 or more years ago"

    # =========================================================================
    # SMOKING
    # =========================================================================
    - id: smoking
      title: "Smoking"
      items:
        - id: smok_q1
          kind: Question
          title: "Does anyone in your household smoke inside the house, every day or almost every day?"
          precondition:
            - predicate: age >= 12
          input:
            control: Switch

        - id: smok_q2
          kind: Question
          title: "At the present time, do you smoke cigarettes:"
          precondition:
            - predicate: age >= 12
          input:
            control: Radio
            labels:
              1: "Daily"
              2: "Occasionally"
              3: "Not at all"
          codeBlock: |
            smokes_daily = 1 if smok_q2 == 1 else 0
            smokes_occasionally = 1 if smok_q2 == 2 else 0

        - id: smok_q3
          kind: Question
          title: "At what age did you begin smoking cigarettes daily?"
          precondition:
            - predicate: age >= 12 and smokes_daily == 1
          input:
            control: Editbox
            min: 5
            max: 120

        - id: smok_q4
          kind: Question
          title: "How many cigarettes do you smoke each day now?"
          precondition:
            - predicate: age >= 12 and smokes_daily == 1
          input:
            control: Editbox
            min: 1
            max: 100

        - id: smok_q4a
          kind: Question
          title: "Have you ever smoked cigarettes at all?"
          precondition:
            - predicate: age >= 12 and smok_q2 == 3
          input:
            control: Switch
          codeBlock: |
            ever_smoked = smok_q4a if smok_q2 == 3 else (1 if smok_q2 in (1, 2) else 0)

        - id: smok_q5
          kind: Question
          title: "Have you ever smoked cigarettes daily?"
          precondition:
            - predicate: age >= 12 and (smokes_occasionally == 1 or (smok_q2 == 3 and ever_smoked == 1))
          input:
            control: Switch

        - id: smok_q6
          kind: Question
          title: "At what age did you begin smoking daily?"
          precondition:
            - predicate: age >= 12 and smok_q5 == 1
          input:
            control: Editbox
            min: 5
            max: 120

        - id: smok_q7
          kind: Question
          title: "How many cigarettes did you usually smoke each day?"
          precondition:
            - predicate: age >= 12 and smok_q5 == 1
          input:
            control: Editbox
            min: 1
            max: 100

        - id: smok_q8
          kind: Question
          title: "At what age did you stop smoking daily?"
          precondition:
            - predicate: age >= 12 and smok_q5 == 1 and smok_q2 != 1
          input:
            control: Editbox
            min: 5
            max: 120

    # =========================================================================
    # ALCOHOL
    # =========================================================================
    - id: alcohol
      title: "Alcohol Use"
      items:
        - id: alco_q1
          kind: Question
          title: "During the past 12 months, did you drink any alcoholic beverages (beer, wine, liquor)?"
          precondition:
            - predicate: age >= 12
          input:
            control: Switch
          codeBlock: |
            drank_past_year = alco_q1

        - id: alco_q2
          kind: Question
          title: "How often in the past 12 months did you drink alcoholic beverages?"
          precondition:
            - predicate: age >= 12 and drank_past_year == 1
          input:
            control: Radio
            labels:
              1: "Every day"
              2: "4 to 6 times a week"
              3: "2 to 3 times a week"
              4: "Once a week"
              5: "Once or twice a month"
              6: "Less than once a month"
              7: "Occasional (a few times a year)"

        - id: alco_q3
          kind: Question
          title: "How often in the past 12 months have you had 5 or more drinks on one occasion?"
          precondition:
            - predicate: age >= 12 and drank_past_year == 1
          input:
            control: Radio
            labels:
              1: "Never"
              2: "Less than once a month"
              3: "Once a month"
              4: "2 to 3 times a month"
              5: "Once a week"
              6: "More than once a week"

        - id: alco_q4
          kind: Question
          title: "On the occasions when you drank, what was the largest number of drinks you had?"
          precondition:
            - predicate: age >= 12 and drank_past_year == 1 and is_proxy == 0
          input:
            control: Editbox
            min: 1
            max: 50

        - id: alco_q5
          kind: Question
          title: "Did you have a drink in the past week?"
          precondition:
            - predicate: age >= 12 and drank_past_year == 1
          input:
            control: Switch

        - id: alco_q5a
          kind: QuestionGroup
          title: "Thinking about the past 7 days (Monday to Sunday), how many drinks did you have on each day?"
          precondition:
            - predicate: age >= 12 and drank_past_year == 1 and alco_q5 == 1
          input:
            control: Editbox
            min: 0
            max: 50
          questions:
            - "Monday"
            - "Tuesday"
            - "Wednesday"
            - "Thursday"
            - "Friday"
            - "Saturday"
            - "Sunday"

        - id: alco_q5b
          kind: Question
          title: "Have you ever had a drink of beer, wine, or liquor?"
          precondition:
            - predicate: age >= 12 and drank_past_year == 0
          input:
            control: Switch
          codeBlock: |
            ever_drank = alco_q5b if drank_past_year == 0 else drank_past_year

        - id: alco_q6
          kind: Question
          title: "Was there ever a time when you drank 12 or more drinks a week?"
          precondition:
            - predicate: age >= 12 and ever_drank == 1 and drank_past_year == 0
          input:
            control: Switch

        - id: alco_q7
          kind: Question
          title: "What were the reasons you reduced or stopped drinking?"
          precondition:
            - predicate: age >= 12 and ever_drank == 1 and drank_past_year == 0
          input:
            control: Checkbox
            labels:
              1: "Health problems related to drinking"
              2: "Health problems not related to drinking"
              4: "Concern about health effects of alcohol"
              8: "Alcohol is too expensive"
              16: "Family or marriage problems"
              32: "Work or school problems"
              64: "Friends' influence"
              128: "Doctor's advice"
              256: "Pregnancy or breast-feeding"
              512: "Weight concern"
              1024: "Loss of interest"
              2048: "Religious or moral reasons"
              4096: "Other"

    # =========================================================================
    # PHYSICAL ACTIVITIES (non-proxy)
    # =========================================================================
    - id: physical_activities
      title: "Physical Activities"
      items:
        - id: phys_intro
          kind: Comment
          title: "The next questions deal with physical activities that you may have done in the past 3 months, that is, from the beginning of (3 months ago) to yesterday. We are interested in activities during your free time."
          precondition:
            - predicate: age >= 12 and is_proxy == 0

        - id: phys_q1
          kind: Question
          title: "In the past 3 months, did you do any of the following?"
          precondition:
            - predicate: age >= 12 and is_proxy == 0
          input:
            control: Checkbox
            labels:
              1: "Walking for exercise"
              2: "Gardening or yard work"
              4: "Swimming"
              8: "Bicycling"
              16: "Popular or social dance"
              32: "Home exercises"
              64: "Ice hockey"
              128: "Ice skating"
              256: "In-line skating"
              512: "Jogging or running"
              1024: "Golfing"
              2048: "Exercise class or aerobics"
              4096: "Downhill skiing or snowboarding"
              8192: "Bowling"
              16384: "Baseball or softball"
              32768: "Tennis"
              65536: "Weight training"
              131072: "Fishing"
              262144: "Volleyball"
              524288: "Basketball"
              1048576: "Cross-country skiing"
              2097152: "Canoeing or kayaking"
              4194304: "Yoga or tai chi"
              8388608: "Other"
          codeBlock: |
            bicycles = 1 if (phys_q1 & 8) else 0

        - id: phys_q4a
          kind: Question
          title: "During the past 3 months, on average, about how many hours per week did you spend walking to work, to school, or while doing errands?"
          precondition:
            - predicate: age >= 12 and is_proxy == 0
          input:
            control: Radio
            labels:
              1: "None"
              2: "Less than 1 hour"
              3: "1 to 5 hours"
              4: "6 to 10 hours"
              5: "11 to 20 hours"
              6: "More than 20 hours"

        - id: phys_q4b
          kind: Question
          title: "During the past 3 months, on average, about how many hours per week did you bicycle to work, to school, or while doing errands?"
          precondition:
            - predicate: age >= 12 and is_proxy == 0
          input:
            control: Radio
            labels:
              1: "None"
              2: "Less than 1 hour"
              3: "1 to 5 hours"
              4: "6 to 10 hours"
              5: "11 to 20 hours"
              6: "More than 20 hours"

        - id: phys_q5
          kind: Question
          title: "When you bicycle, how often do you wear a helmet?"
          precondition:
            - predicate: age >= 12 and is_proxy == 0 and bicycles == 1
          input:
            control: Radio
            labels:
              1: "Always"
              2: "Most of the time"
              3: "About half the time"
              4: "Rarely"
              5: "Never"

        - id: phys_q6
          kind: Question
          title: "Thinking about the amount of physical effort required in your daily activities (not including recreational activities), which of the following best describes your usual daily activities?"
          precondition:
            - predicate: age >= 12 and is_proxy == 0
          input:
            control: Radio
            labels:
              1: "Usually sit during the day and don't walk around very much"
              2: "Stand or walk quite a lot but don't carry or lift things often"
              3: "Usually lift or carry light loads, or climb stairs or hills often"
              4: "Do heavy work or carry very heavy loads"

    # =========================================================================
    # INJURIES
    # =========================================================================
    - id: injuries
      title: "Injuries"
      items:
        - id: inj_q1
          kind: Question
          title: "In the past 12 months, were you injured seriously enough to limit your normal activities?"
          precondition:
            - predicate: age >= 12
          input:
            control: Switch
          codeBlock: |
            had_injury = inj_q1

        - id: inj_q2
          kind: Question
          title: "How many times were you injured in the past 12 months?"
          precondition:
            - predicate: age >= 12 and had_injury == 1
          input:
            control: Editbox
            min: 1
            max: 20

        - id: inj_q3
          kind: Question
          title: "What type of injury was the most serious one?"
          precondition:
            - predicate: age >= 12 and had_injury == 1
          input:
            control: Radio
            labels:
              1: "Broken or fractured bones"
              2: "Dislocation"
              3: "Sprain or strain"
              4: "Burn or scald"
              5: "Cut, puncture, or animal bite"
              6: "Scrape, bruise, or blister"
              7: "Concussion"
              8: "Poisoning"
              9: "Internal injury"
              10: "Multiple injuries"
              11: "Other"

        - id: inj_q4
          kind: Question
          title: "What part of your body was injured?"
          precondition:
            - predicate: age >= 12 and had_injury == 1
          input:
            control: Radio
            labels:
              1: "Head"
              2: "Eyes"
              3: "Neck/spine"
              4: "Shoulder/upper arm"
              5: "Forearm/wrist/hand"
              6: "Chest/abdomen"
              7: "Hip/upper leg"
              8: "Knee/lower leg/foot"
              9: "Multiple sites"
              10: "Other"

        - id: inj_q5
          kind: Question
          title: "Where were you when the injury occurred?"
          precondition:
            - predicate: age >= 12 and had_injury == 1
          input:
            control: Radio
            labels:
              1: "In the home (inside)"
              2: "In the home (outside — yard, driveway)"
              3: "Other private residence"
              4: "School, college, or university"
              5: "Sports area (arena, pool, gym)"
              6: "Street, highway, or sidewalk"
              7: "Commercial/service area (store, office, restaurant)"
              8: "Industrial or construction area"
              9: "Other"

        - id: inj_q6
          kind: Question
          title: "What were you doing when you were injured?"
          precondition:
            - predicate: age >= 12 and had_injury == 1
          input:
            control: Radio
            labels:
              1: "Sports or physical exercise"
              2: "Leisure or hobby"
              3: "Working at a job or business"
              4: "Household chores, yard work"
              5: "Travelling to or from work/school"
              6: "Eating, sleeping, personal care"
              7: "Other"

        - id: inj_q7
          kind: Question
          title: "Was the injury related to your work?"
          precondition:
            - predicate: age >= 12 and had_injury == 1
          input:
            control: Switch

        - id: inj_q8
          kind: Question
          title: "At the time of the injury, which of the following safety devices or practices were you using?"
          precondition:
            - predicate: age >= 12 and had_injury == 1
          input:
            control: Checkbox
            labels:
              1: "Seatbelt"
              2: "Child car seat"
              4: "Bicycle helmet"
              8: "Other helmet (e.g., hockey, motorcycle)"
              16: "Protective clothing or equipment"
              32: "Reflectors or reflective clothing"
              64: "Other safety device"
              128: "None"

    # =========================================================================
    # CHRONIC STRESS (age >= 18, non-proxy)
    # =========================================================================
    - id: chronic_stress
      title: "Stress — Ongoing Problems"
      items:
        - id: cstress_intro
          kind: Comment
          title: "The following questions deal with different aspects of your life. For each statement please tell me if you agree, disagree, or if it is not applicable."
          precondition:
            - predicate: age >= 18 and is_proxy == 0

        - id: cstress_q1
          kind: Question
          title: "You are trying to take on too many things at once."
          precondition:
            - predicate: age >= 18 and is_proxy == 0
          input:
            control: Radio
            labels:
              1: "True"
              0: "False"

        - id: cstress_q2
          kind: Question
          title: "There is too much pressure on you to be like other people."
          precondition:
            - predicate: age >= 18 and is_proxy == 0
          input:
            control: Radio
            labels:
              1: "True"
              0: "False"

        - id: cstress_q3
          kind: Question
          title: "Too much is expected of you by others."
          precondition:
            - predicate: age >= 18 and is_proxy == 0
          input:
            control: Radio
            labels:
              1: "True"
              0: "False"

        - id: cstress_q4
          kind: Question
          title: "You don't have enough money to buy the things you need."
          precondition:
            - predicate: age >= 18 and is_proxy == 0
          input:
            control: Radio
            labels:
              1: "True"
              0: "False"

        - id: cstress_q5
          kind: Question
          title: "Your partner doesn't understand you."
          precondition:
            - predicate: age >= 18 and is_proxy == 0 and is_married_or_partnered == 1
          input:
            control: Radio
            labels:
              1: "True"
              0: "False"

        - id: cstress_q6
          kind: Question
          title: "Your partner doesn't show enough affection."
          precondition:
            - predicate: age >= 18 and is_proxy == 0 and is_married_or_partnered == 1
          input:
            control: Radio
            labels:
              1: "True"
              0: "False"

        - id: cstress_q7
          kind: Question
          title: "You would like more commitment from your partner."
          precondition:
            - predicate: age >= 18 and is_proxy == 0 and is_married_or_partnered == 1
          input:
            control: Radio
            labels:
              1: "True"
              0: "False"

        - id: cstress_q8
          kind: Question
          title: "It's difficult to find someone compatible with you."
          precondition:
            - predicate: age >= 18 and is_proxy == 0 and is_married_or_partnered == 0
          input:
            control: Radio
            labels:
              1: "True"
              0: "False"

        - id: cstress_q9
          kind: Question
          title: "Do you have any children?"
          precondition:
            - predicate: age >= 18 and is_proxy == 0
          input:
            control: Switch
          codeBlock: |
            has_children = cstress_q9

        - id: cstress_q10
          kind: Question
          title: "One of your children seems very unhappy."
          precondition:
            - predicate: age >= 18 and is_proxy == 0 and has_children == 1
          input:
            control: Radio
            labels:
              1: "True"
              0: "False"

        - id: cstress_q11
          kind: Question
          title: "A child's behaviour is a source of serious concern to you."
          precondition:
            - predicate: age >= 18 and is_proxy == 0 and has_children == 1
          input:
            control: Radio
            labels:
              1: "True"
              0: "False"

        - id: cstress_q12
          kind: Question
          title: "You have a parent, a child, or a partner who is in very bad health and may die."
          precondition:
            - predicate: age >= 18 and is_proxy == 0
          input:
            control: Radio
            labels:
              1: "True"
              0: "False"

        - id: cstress_q13
          kind: Question
          title: "You have a close friend or family member with an alcohol or drug problem."
          precondition:
            - predicate: age >= 18 and is_proxy == 0
          input:
            control: Radio
            labels:
              1: "True"
              0: "False"

        - id: cstress_q14
          kind: Question
          title: "Your neighbourhood or community is too noisy or polluted."
          precondition:
            - predicate: age >= 18 and is_proxy == 0
          input:
            control: Radio
            labels:
              1: "True"
              0: "False"

        - id: cstress_q15
          kind: Question
          title: "There is too much crime in your neighbourhood."
          precondition:
            - predicate: age >= 18 and is_proxy == 0
          input:
            control: Radio
            labels:
              1: "True"
              0: "False"

        - id: cstress_q16
          kind: Question
          title: "Your housing is inadequate (too small, in need of major repairs)."
          precondition:
            - predicate: age >= 18 and is_proxy == 0
          input:
            control: Radio
            labels:
              1: "True"
              0: "False"

        - id: cstress_q17
          kind: Question
          title: "You would like to move but you cannot."
          precondition:
            - predicate: age >= 18 and is_proxy == 0
          input:
            control: Radio
            labels:
              1: "True"
              0: "False"

        - id: cstress_q18
          kind: Question
          title: "People are too critical of you or what you do."
          precondition:
            - predicate: age >= 18 and is_proxy == 0
          input:
            control: Radio
            labels:
              1: "True"
              0: "False"

    # =========================================================================
    # RECENT LIFE EVENTS (age >= 18)
    # =========================================================================
    - id: recent_life_events
      title: "Recent Life Events"
      items:
        - id: recent_intro
          kind: Comment
          title: "During the past 12 months, did any of the following events happen to you?"
          precondition:
            - predicate: age >= 18

        - id: recent_q1
          kind: Question
          title: "You were physically attacked or abused?"
          precondition:
            - predicate: age >= 18
          input:
            control: Switch

        - id: recent_q2
          kind: Question
          title: "You or your partner had an unwanted pregnancy?"
          precondition:
            - predicate: age >= 18
          input:
            control: Switch

        - id: recent_q3
          kind: Question
          title: "You had an abortion or miscarriage?"
          precondition:
            - predicate: age >= 18 and is_female == 1
          input:
            control: Switch

        - id: recent_q4
          kind: Question
          title: "You experienced a major financial crisis (bankruptcy, inability to pay bills)?"
          precondition:
            - predicate: age >= 18
          input:
            control: Switch

        - id: recent_q5
          kind: Question
          title: "A family member other than your partner or child failed at school or at work?"
          precondition:
            - predicate: age >= 18
          input:
            control: Switch

        - id: recent_q6
          kind: Question
          title: "Your partner changed jobs for a worse one?"
          precondition:
            - predicate: age >= 18 and is_married_or_partnered == 1
          input:
            control: Switch

        - id: recent_q7
          kind: Question
          title: "Your partner lost his/her job or was laid off?"
          precondition:
            - predicate: age >= 18 and is_married_or_partnered == 1
          input:
            control: Switch

        - id: recent_q8
          kind: Question
          title: "You and your partner argued a lot more?"
          precondition:
            - predicate: age >= 18 and is_married_or_partnered == 1
          input:
            control: Switch

        - id: recent_q9
          kind: Question
          title: "You or a household member went on welfare?"
          precondition:
            - predicate: age >= 18
          input:
            control: Switch

        - id: recent_q10
          kind: Question
          title: "An adult child moved back into your home?"
          precondition:
            - predicate: age >= 18 and has_children == 1
          input:
            control: Switch

    # =========================================================================
    # CHILDHOOD TRAUMAS (age >= 18)
    # =========================================================================
    - id: childhood_traumas
      title: "Childhood Traumas"
      items:
        - id: traum_intro
          kind: Comment
          title: "The next questions are about events that happened during your childhood and adolescence (before you were 18 years old)."
          precondition:
            - predicate: age >= 18

        - id: traum_q1
          kind: Question
          title: "Did you spend 2 weeks or more in the hospital?"
          precondition:
            - predicate: age >= 18
          input:
            control: Switch

        - id: traum_q2
          kind: Question
          title: "Did your parents get a divorce?"
          precondition:
            - predicate: age >= 18
          input:
            control: Switch

        - id: traum_q3
          kind: Question
          title: "Did your father or mother not have a job for a long time when he/she wanted to be working?"
          precondition:
            - predicate: age >= 18
          input:
            control: Switch

        - id: traum_q4
          kind: Question
          title: "Did something happen that scared you so much you thought about it for years after?"
          precondition:
            - predicate: age >= 18
          input:
            control: Switch

        - id: traum_q5
          kind: Question
          title: "Were you sent away from home for doing something wrong?"
          precondition:
            - predicate: age >= 18
          input:
            control: Switch

        - id: traum_q6
          kind: Question
          title: "Did a parent drink or use drugs so often that it caused problems for the family?"
          precondition:
            - predicate: age >= 18
          input:
            control: Switch

        - id: traum_q7
          kind: Question
          title: "Were you ever physically abused by someone close to you?"
          precondition:
            - predicate: age >= 18
          input:
            control: Switch

    # =========================================================================
    # WORK STRESS (age >= 15, currently employed, non-proxy)
    # =========================================================================
    - id: work_stress
      title: "Work Stress"
      items:
        - id: wstress_q1
          kind: QuestionGroup
          title: "The following statements describe your current job or most recent main job. Please tell me how much you agree or disagree with each."
          precondition:
            - predicate: age >= 15 and is_working == 1 and is_proxy == 0
          input:
            control: Radio
            labels:
              1: "Strongly agree"
              2: "Agree"
              3: "Neither agree nor disagree"
              4: "Disagree"
              5: "Strongly disagree"
          questions:
            - "a) Your job requires that you learn new things."
            - "b) Your job requires a high level of skill."
            - "c) Your job allows you freedom to decide how you do your job."
            - "d) Your job requires that you do things over and over."
            - "e) Your job is very hectic."
            - "f) You are free from conflicting demands that others make."
            - "g) Your job security is good."
            - "h) Your job requires a lot of physical effort."
            - "i) You have a lot to say about what happens in your job."
            - "j) You are exposed to hostility or conflict from the people you work with."
            - "k) Your supervisor is helpful in getting the job done."
            - "l) The people you work with are helpful in getting the job done."

        - id: wstress_q2
          kind: Question
          title: "How satisfied are you with your job?"
          precondition:
            - predicate: age >= 15 and is_working == 1 and is_proxy == 0
          input:
            control: Radio
            labels:
              1: "Very satisfied"
              2: "Somewhat satisfied"
              3: "Not too satisfied"
              4: "Not at all satisfied"

    # =========================================================================
    # SELF-ESTEEM (age >= 12, non-proxy)
    # =========================================================================
    - id: self_esteem
      title: "Self-Esteem"
      items:
        - id: esteem_q1
          kind: QuestionGroup
          title: "The following statements deal with your general feelings about yourself. Please tell me how much you agree or disagree with each."
          precondition:
            - predicate: age >= 12 and is_proxy == 0
          input:
            control: Radio
            labels:
              1: "Strongly agree"
              2: "Agree"
              3: "Neither agree nor disagree"
              4: "Disagree"
              5: "Strongly disagree"
          questions:
            - "a) You feel that you have a number of good qualities."
            - "b) You feel that you're a person of worth at least equal to others."
            - "c) You are able to do things as well as most other people."
            - "d) You take a positive attitude toward yourself."
            - "e) On the whole, you are satisfied with yourself."
            - "f) All in all, you are inclined to feel you are a failure."

    # =========================================================================
    # MASTERY (age >= 12, non-proxy)
    # =========================================================================
    - id: mastery
      title: "Mastery"
      items:
        - id: mast_q1
          kind: QuestionGroup
          title: "The following statements describe how some people feel about themselves. How much do you agree or disagree with each?"
          precondition:
            - predicate: age >= 12 and is_proxy == 0
          input:
            control: Radio
            labels:
              1: "Strongly agree"
              2: "Agree"
              3: "Neither agree nor disagree"
              4: "Disagree"
              5: "Strongly disagree"
          questions:
            - "a) You have little control over the things that happen to you."
            - "b) There is really no way you can solve some of the problems you have."
            - "c) There is little you can do to change many of the important things in your life."
            - "d) You often feel helpless in dealing with the problems of life."
            - "e) Sometimes you feel that you are being pushed around in life."
            - "f) What happens to you in the future mostly depends on you."
            - "g) You can do just about anything you really set your mind to."

    # =========================================================================
    # SENSE OF COHERENCE (age >= 18, non-proxy)
    # =========================================================================
    - id: sense_of_coherence
      title: "Sense of Coherence"
      items:
        - id: scoh_intro
          kind: Comment
          title: "Here is a series of questions relating to various aspects of your life. Each question has 7 possible answers. Please choose the number which expresses your answer, with 1 and 7 being the extreme answers."
          precondition:
            - predicate: age >= 18 and is_proxy == 0

        - id: scoh_q1
          kind: Question
          title: "Do you have the feeling that you don't really care about what goes on around you?"
          precondition:
            - predicate: age >= 18 and is_proxy == 0
          input:
            control: Slider
            min: 1
            max: 7
            step: 1

        - id: scoh_q2
          kind: Question
          title: "Has it happened in the past that you were surprised by the behaviour of people whom you thought you knew well?"
          precondition:
            - predicate: age >= 18 and is_proxy == 0
          input:
            control: Slider
            min: 1
            max: 7
            step: 1

        - id: scoh_q3
          kind: Question
          title: "Has it happened that people whom you counted on disappointed you?"
          precondition:
            - predicate: age >= 18 and is_proxy == 0
          input:
            control: Slider
            min: 1
            max: 7
            step: 1

        - id: scoh_q4
          kind: Question
          title: "Until now your life has had: no clear goals or purpose (1) ... very clear goals and purpose (7)."
          precondition:
            - predicate: age >= 18 and is_proxy == 0
          input:
            control: Slider
            min: 1
            max: 7
            step: 1

        - id: scoh_q5
          kind: Question
          title: "Do you have the feeling that you are being treated unfairly?"
          precondition:
            - predicate: age >= 18 and is_proxy == 0
          input:
            control: Slider
            min: 1
            max: 7
            step: 1

        - id: scoh_q6
          kind: Question
          title: "Do you have the feeling that you are in an unfamiliar situation and don't know what to do?"
          precondition:
            - predicate: age >= 18 and is_proxy == 0
          input:
            control: Slider
            min: 1
            max: 7
            step: 1

        - id: scoh_q7
          kind: Question
          title: "Doing the things you do every day is: a source of deep pleasure and satisfaction (1) ... a source of pain and boredom (7)."
          precondition:
            - predicate: age >= 18 and is_proxy == 0
          input:
            control: Slider
            min: 1
            max: 7
            step: 1

        - id: scoh_q8
          kind: Question
          title: "Do you have very mixed-up feelings and ideas?"
          precondition:
            - predicate: age >= 18 and is_proxy == 0
          input:
            control: Slider
            min: 1
            max: 7
            step: 1

        - id: scoh_q9
          kind: Question
          title: "Does it happen that you have feelings inside you would rather not feel?"
          precondition:
            - predicate: age >= 18 and is_proxy == 0
          input:
            control: Slider
            min: 1
            max: 7
            step: 1

        - id: scoh_q10
          kind: Question
          title: "Many people — even those with a strong character — sometimes feel like losers in certain situations. How often have you felt this way in the past?"
          precondition:
            - predicate: age >= 18 and is_proxy == 0
          input:
            control: Slider
            min: 1
            max: 7
            step: 1

        - id: scoh_q11
          kind: Question
          title: "When something happened, have you generally found that: you overestimated or underestimated its importance (1) ... you saw things in the right proportion (7)?"
          precondition:
            - predicate: age >= 18 and is_proxy == 0
          input:
            control: Slider
            min: 1
            max: 7
            step: 1

        - id: scoh_q12
          kind: Question
          title: "How often do you have the feeling that there's little meaning in the things you do in your daily life?"
          precondition:
            - predicate: age >= 18 and is_proxy == 0
          input:
            control: Slider
            min: 1
            max: 7
            step: 1

        - id: scoh_q13
          kind: Question
          title: "How often do you have feelings that you're not sure you can keep under control?"
          precondition:
            - predicate: age >= 18 and is_proxy == 0
          input:
            control: Slider
            min: 1
            max: 7
            step: 1

    # =========================================================================
    # HEALTH STATUS (HUI)
    # =========================================================================
    - id: health_status
      title: "Health Status"
      items:
        # --- Vision ---
        - id: hstat_vision_intro
          kind: Comment
          title: "The next questions deal with your ability to see, hear, and communicate."
          precondition:
            - predicate: age >= 12

        - id: hstat_q1
          kind: Question
          title: "Are you able to see well enough to read ordinary newsprint without glasses or contact lenses?"
          precondition:
            - predicate: age >= 12
          input:
            control: Switch

        - id: hstat_q2
          kind: Question
          title: "Are you able to see well enough to read ordinary newsprint with glasses or contact lenses?"
          precondition:
            - predicate: age >= 12 and hstat_q1 == 0
          input:
            control: Switch

        - id: hstat_q3
          kind: Question
          title: "Are you able to see at all?"
          precondition:
            - predicate: age >= 12 and hstat_q1 == 0 and hstat_q2 == 0
          input:
            control: Switch

        - id: hstat_q4
          kind: Question
          title: "Can you see well enough to recognize a friend on the other side of the street without glasses or contact lenses?"
          precondition:
            - predicate: age >= 12 and (hstat_q1 == 1 or (hstat_q1 == 0 and hstat_q2 == 1))
          input:
            control: Switch

        - id: hstat_q5
          kind: Question
          title: "Can you see well enough to recognize a friend on the other side of the street with glasses or contact lenses?"
          precondition:
            - predicate: age >= 12 and (hstat_q1 == 1 or (hstat_q1 == 0 and hstat_q2 == 1)) and hstat_q4 == 0
          input:
            control: Switch

        # --- Hearing ---
        - id: hstat_q6
          kind: Question
          title: "Are you able to hear what is said in a group conversation with at least 3 other people without a hearing aid?"
          precondition:
            - predicate: age >= 12
          input:
            control: Switch

        - id: hstat_q7
          kind: Question
          title: "Are you able to hear what is said in a group conversation with at least 3 other people with a hearing aid?"
          precondition:
            - predicate: age >= 12 and hstat_q6 == 0
          input:
            control: Switch

        - id: hstat_q8
          kind: Question
          title: "Are you able to hear at all?"
          precondition:
            - predicate: age >= 12 and hstat_q6 == 0 and hstat_q7 == 0
          input:
            control: Switch

        - id: hstat_q9
          kind: Question
          title: "Are you able to hear what is said in a conversation with one other person in a quiet room without a hearing aid?"
          precondition:
            - predicate: age >= 12 and hstat_q6 == 0 and hstat_q7 == 1
          input:
            control: Switch

        # --- Speech ---
        - id: hstat_q10
          kind: Question
          title: "Are you able to be understood completely when speaking with strangers in your own language?"
          precondition:
            - predicate: age >= 12
          input:
            control: Switch

        - id: hstat_q11
          kind: Question
          title: "Are you able to be partially understood when speaking with strangers?"
          precondition:
            - predicate: age >= 12 and hstat_q10 == 0
          input:
            control: Switch

        - id: hstat_q12
          kind: Question
          title: "Are you able to be understood completely when speaking with those who know you well?"
          precondition:
            - predicate: age >= 12 and hstat_q10 == 0
          input:
            control: Switch

        - id: hstat_q13
          kind: Question
          title: "Are you able to be partially understood when speaking with those who know you well?"
          precondition:
            - predicate: age >= 12 and hstat_q10 == 0 and hstat_q12 == 0
          input:
            control: Switch

        # --- Getting Around ---
        - id: hstat_q14
          kind: Question
          title: "Are you able to walk around the neighbourhood without difficulty and without mechanical support such as braces, a cane, or crutches?"
          precondition:
            - predicate: age >= 12
          input:
            control: Switch

        - id: hstat_q15
          kind: Question
          title: "Are you able to walk at all?"
          precondition:
            - predicate: age >= 12 and hstat_q14 == 0
          input:
            control: Switch

        - id: hstat_q16
          kind: Question
          title: "Do you require mechanical support (braces, cane, crutches) to walk?"
          precondition:
            - predicate: age >= 12 and hstat_q14 == 0 and hstat_q15 == 1
          input:
            control: Switch

        - id: hstat_q17
          kind: Question
          title: "Do you need the help of another person to walk?"
          precondition:
            - predicate: age >= 12 and hstat_q14 == 0 and hstat_q15 == 1
          input:
            control: Switch

        - id: hstat_q18
          kind: Question
          title: "Do you use a wheelchair to get around?"
          precondition:
            - predicate: age >= 12 and hstat_q14 == 0
          input:
            control: Switch

        - id: hstat_q19
          kind: Question
          title: "How often do you use the wheelchair?"
          precondition:
            - predicate: age >= 12 and hstat_q18 == 1
          input:
            control: Radio
            labels:
              1: "Always"
              2: "Often"
              3: "Sometimes"

        - id: hstat_q20
          kind: Question
          title: "Do you need the help of another person to operate the wheelchair?"
          precondition:
            - predicate: age >= 12 and hstat_q18 == 1
          input:
            control: Switch

        # --- Hands and Fingers ---
        - id: hstat_q21
          kind: Question
          title: "Are you able to grasp and handle small objects such as a pencil or scissors?"
          precondition:
            - predicate: age >= 12
          input:
            control: Switch

        - id: hstat_q22
          kind: Question
          title: "Do you need the help of another person because of limitations in the use of hands or fingers?"
          precondition:
            - predicate: age >= 12 and hstat_q21 == 0
          input:
            control: Switch

        - id: hstat_q23
          kind: Question
          title: "How much help do you need?"
          precondition:
            - predicate: age >= 12 and hstat_q22 == 1
          input:
            control: Radio
            labels:
              1: "Some help"
              2: "A lot of help"
              3: "Complete help"

        - id: hstat_q24
          kind: Question
          title: "Do you need special equipment (for example, devices to help you grasp) because of limitations in the use of hands or fingers?"
          precondition:
            - predicate: age >= 12 and hstat_q21 == 0
          input:
            control: Switch

        # --- Feelings ---
        - id: hstat_q25
          kind: Question
          title: "Would you describe yourself as being usually:"
          precondition:
            - predicate: age >= 12
          input:
            control: Radio
            labels:
              1: "Happy and interested in life"
              2: "Somewhat happy"
              3: "Somewhat unhappy"
              4: "Unhappy with little interest in life"
              5: "So unhappy that life is not worthwhile"

        # --- Memory ---
        - id: hstat_q26
          kind: Question
          title: "How would you describe your usual ability to remember things?"
          precondition:
            - predicate: age >= 12
          input:
            control: Radio
            labels:
              1: "Able to remember most things"
              2: "Somewhat forgetful"
              3: "Very forgetful"
              4: "Unable to remember anything at all"

        # --- Thinking ---
        - id: hstat_q27
          kind: Question
          title: "How would you describe your usual ability to think and solve day-to-day problems?"
          precondition:
            - predicate: age >= 12
          input:
            control: Radio
            labels:
              1: "Able to think clearly and solve problems"
              2: "A little difficulty"
              3: "Some difficulty"
              4: "A great deal of difficulty"
              5: "Unable to think or solve problems"

        # --- Pain ---
        - id: hstat_q28
          kind: Question
          title: "Are you usually free of pain or discomfort?"
          precondition:
            - predicate: age >= 12
          input:
            control: Switch

        - id: hstat_q29
          kind: Question
          title: "How would you describe the usual intensity of your pain or discomfort?"
          precondition:
            - predicate: age >= 12 and hstat_q28 == 0
          input:
            control: Radio
            labels:
              1: "Mild"
              2: "Moderate"
              3: "Severe"

        - id: hstat_q30
          kind: Question
          title: "How many activities does your pain or discomfort prevent?"
          precondition:
            - predicate: age >= 12 and hstat_q28 == 0
          input:
            control: Radio
            labels:
              1: "None"
              2: "A few"
              3: "Some"
              4: "Most"

    # =========================================================================
    # DRUG USE
    # =========================================================================
    - id: drug_use
      title: "Drug Use"
      items:
        - id: drug_q1
          kind: Question
          title: "In the past month, did you take any of the following types of medication?"
          precondition:
            - predicate: age >= 12
          input:
            control: Checkbox
            labels:
              1: "Pain relievers (aspirin, Tylenol, codeine)"
              2: "Cough or cold remedies"
              4: "Antibiotics"
              8: "Asthma medications"
              16: "Tranquillizers (Valium)"
              32: "Diet pills"
              64: "Antidepressants"
              128: "Codeine, Demerol, or morphine"
              256: "Sleeping pills"
              512: "Stomach remedies (Pepto-Bismol, Tums)"
              1024: "Laxatives"
              2048: "Blood pressure medication"
              4096: "Diuretics (water pills)"
              8192: "Heart medicine"
              16384: "Thyroid medication"
              32768: "Insulin"
              65536: "Diabetes pills"
              131072: "Allergy medicine"
              262144: "Steroids"
              524288: "Hormone replacement therapy"
              1048576: "Birth control pills"
              2097152: "Other"
              4194304: "None"

        - id: drug_q2
          kind: Question
          title: "In the past 2 days, how many different types of medications (prescribed or over-the-counter) did you take?"
          precondition:
            - predicate: age >= 12
          input:
            control: Editbox
            min: 0
            max: 30

        - id: drug_q4
          kind: Question
          title: "In the past month, did you take any vitamins, minerals, herbal remedies, or other health products?"
          precondition:
            - predicate: age >= 12
          input:
            control: Switch

    # =========================================================================
    # MENTAL HEALTH — DISTRESS SCALE (non-proxy)
    # =========================================================================
    - id: mental_health_distress
      title: "Mental Health — Psychological Distress"
      items:
        - id: mhlth_intro
          kind: Comment
          title: "During the past month, about how often did you feel..."
          precondition:
            - predicate: age >= 12 and is_proxy == 0

        - id: mhlth_q1a
          kind: Question
          title: "...so sad that nothing could cheer you up?"
          precondition:
            - predicate: age >= 12 and is_proxy == 0
          input:
            control: Radio
            labels:
              1: "All of the time"
              2: "Most of the time"
              3: "Some of the time"
              4: "A little of the time"
              5: "None of the time"

        - id: mhlth_q1b
          kind: Question
          title: "...nervous?"
          precondition:
            - predicate: age >= 12 and is_proxy == 0
          input:
            control: Radio
            labels:
              1: "All of the time"
              2: "Most of the time"
              3: "Some of the time"
              4: "A little of the time"
              5: "None of the time"

        - id: mhlth_q1c
          kind: Question
          title: "...restless or fidgety?"
          precondition:
            - predicate: age >= 12 and is_proxy == 0
          input:
            control: Radio
            labels:
              1: "All of the time"
              2: "Most of the time"
              3: "Some of the time"
              4: "A little of the time"
              5: "None of the time"

        - id: mhlth_q1d
          kind: Question
          title: "...hopeless?"
          precondition:
            - predicate: age >= 12 and is_proxy == 0
          input:
            control: Radio
            labels:
              1: "All of the time"
              2: "Most of the time"
              3: "Some of the time"
              4: "A little of the time"
              5: "None of the time"

        - id: mhlth_q1e
          kind: Question
          title: "...worthless?"
          precondition:
            - predicate: age >= 12 and is_proxy == 0
          input:
            control: Radio
            labels:
              1: "All of the time"
              2: "Most of the time"
              3: "Some of the time"
              4: "A little of the time"
              5: "None of the time"

        - id: mhlth_q1f
          kind: Question
          title: "...that everything was an effort?"
          precondition:
            - predicate: age >= 12 and is_proxy == 0
          input:
            control: Radio
            labels:
              1: "All of the time"
              2: "Most of the time"
              3: "Some of the time"
              4: "A little of the time"
              5: "None of the time"

        - id: mhlth_q1j
          kind: Question
          title: "How much did these feelings interfere with your life or activities?"
          precondition:
            - predicate: age >= 12 and is_proxy == 0
          input:
            control: Radio
            labels:
              1: "A lot"
              2: "Some"
              3: "A little"
              4: "Not at all"

        - id: mhlth_q1k
          kind: Question
          title: "In the past month, how many times did you see or talk on the phone with a doctor or other health professional about these feelings?"
          precondition:
            - predicate: age >= 12 and is_proxy == 0
          input:
            control: Editbox
            min: 0
            max: 100

    # =========================================================================
    # MENTAL HEALTH — DEPRESSION SCREENING (non-proxy)
    # =========================================================================
    - id: mental_health_depression
      title: "Mental Health — Depression Screening"
      items:
        - id: mhlth_q2
          kind: Question
          title: "During the past 12 months, was there ever a time when you felt sad, blue, or depressed for 2 weeks or more in a row?"
          precondition:
            - predicate: age >= 12 and is_proxy == 0
          input:
            control: Switch
          codeBlock: |
            depression_screen_sad = mhlth_q2

        - id: mhlth_q3
          kind: Question
          title: "How long did that period last?"
          precondition:
            - predicate: age >= 12 and is_proxy == 0 and depression_screen_sad == 1
          input:
            control: Radio
            labels:
              1: "2 weeks"
              2: "Between 2 weeks and a month"
              3: "Between 1 and 6 months"
              4: "Between 6 and 12 months"
              5: "The entire 12 months"

        - id: mhlth_q4
          kind: Question
          title: "Was that period of feeling sad or depressed the whole day, most of the day, about half, or less than half the day?"
          precondition:
            - predicate: age >= 12 and is_proxy == 0 and depression_screen_sad == 1
          input:
            control: Radio
            labels:
              1: "All day"
              2: "Most of the day"
              3: "About half the day"
              4: "Less than half the day"

        - id: mhlth_q5
          kind: Question
          title: "Was it every day, almost every day, or less often?"
          precondition:
            - predicate: age >= 12 and is_proxy == 0 and depression_screen_sad == 1
          input:
            control: Radio
            labels:
              1: "Every day"
              2: "Almost every day"
              3: "Less often"

        - id: mhlth_q6
          kind: Question
          title: "During the past 12 months, was there ever a time lasting 2 weeks or more when you lost interest in most things like hobbies, work, or activities that usually give you pleasure?"
          precondition:
            - predicate: age >= 12 and is_proxy == 0
          input:
            control: Switch
          codeBlock: |
            depression_screen_interest = mhlth_q6

        - id: mhlth_q7
          kind: Question
          title: "During that period, did you feel tired out or low on energy all the time?"
          precondition:
            - predicate: age >= 12 and is_proxy == 0 and (depression_screen_sad == 1 or depression_screen_interest == 1)
          input:
            control: Switch

        - id: mhlth_q8
          kind: Question
          title: "Did you gain or lose weight without trying to?"
          precondition:
            - predicate: age >= 12 and is_proxy == 0 and (depression_screen_sad == 1 or depression_screen_interest == 1)
          input:
            control: Radio
            labels:
              1: "Gained weight"
              2: "Lost weight"
              3: "Both gained and lost"
              4: "No change"

        - id: mhlth_q9
          kind: Question
          title: "Did you have more trouble falling asleep, staying asleep, or waking too early than you usually do?"
          precondition:
            - predicate: age >= 12 and is_proxy == 0 and (depression_screen_sad == 1 or depression_screen_interest == 1)
          input:
            control: Switch

        - id: mhlth_q10
          kind: Question
          title: "Did you have a lot more trouble concentrating than usual?"
          precondition:
            - predicate: age >= 12 and is_proxy == 0 and (depression_screen_sad == 1 or depression_screen_interest == 1)
          input:
            control: Switch

        - id: mhlth_q11
          kind: Question
          title: "Did you feel down on yourself, no good, or worthless?"
          precondition:
            - predicate: age >= 12 and is_proxy == 0 and (depression_screen_sad == 1 or depression_screen_interest == 1)
          input:
            control: Switch

        - id: mhlth_q12
          kind: Question
          title: "Did you think a lot about death — either your own, someone else's, or death in general?"
          precondition:
            - predicate: age >= 12 and is_proxy == 0 and (depression_screen_sad == 1 or depression_screen_interest == 1)
          input:
            control: Switch

        - id: mhlth_q14
          kind: Question
          title: "About how many weeks out of 52 did you feel this way?"
          precondition:
            - predicate: age >= 12 and is_proxy == 0 and (depression_screen_sad == 1 or depression_screen_interest == 1)
          input:
            control: Editbox
            min: 2
            max: 52

        - id: mhlth_q15
          kind: Question
          title: "During which month did the longest period start?"
          precondition:
            - predicate: age >= 12 and is_proxy == 0 and (depression_screen_sad == 1 or depression_screen_interest == 1)
          input:
            control: Dropdown
            labels:
              1: "January"
              2: "February"
              3: "March"
              4: "April"
              5: "May"
              6: "June"
              7: "July"
              8: "August"
              9: "September"
              10: "October"
              11: "November"
              12: "December"

    # =========================================================================
    # SOCIAL SUPPORT (non-proxy)
    # =========================================================================
    - id: social_support
      title: "Social Support"
      items:
        - id: socsup_q1
          kind: Question
          title: "Are you a member of any voluntary organizations or associations such as school groups, church social groups, community centres, ethnic associations, or social, civic, or fraternal clubs?"
          precondition:
            - predicate: age >= 12 and is_proxy == 0
          input:
            control: Switch

        - id: socsup_q2
          kind: Question
          title: "In the past 12 months, how often did you participate in meetings or activities of these organizations?"
          precondition:
            - predicate: age >= 12 and is_proxy == 0 and socsup_q1 == 1
          input:
            control: Radio
            labels:
              1: "At least once a week"
              2: "At least once a month"
              3: "At least 3 or 4 times a year"
              4: "At least once a year"

        - id: socsup_q2a
          kind: Question
          title: "Other than on special occasions (weddings, funerals, baptisms), how often did you attend religious services or meetings in the past 12 months?"
          precondition:
            - predicate: age >= 12 and is_proxy == 0
          input:
            control: Radio
            labels:
              1: "At least once a week"
              2: "At least once a month"
              3: "A few times a year"
              4: "At least once a year"
              5: "Not at all"

        - id: socsup_q3
          kind: Question
          title: "Do you have someone you can confide in or talk to about your private feelings or concerns?"
          precondition:
            - predicate: age >= 12 and is_proxy == 0
          input:
            control: Switch

        - id: socsup_q4
          kind: Question
          title: "Do you have someone you can really count on in a crisis?"
          precondition:
            - predicate: age >= 12 and is_proxy == 0
          input:
            control: Switch

        - id: socsup_q5
          kind: Question
          title: "Do you have someone you can count on for advice when making important personal decisions?"
          precondition:
            - predicate: age >= 12 and is_proxy == 0
          input:
            control: Switch

        - id: socsup_q6
          kind: Question
          title: "Do you have someone who makes you feel loved and cared for?"
          precondition:
            - predicate: age >= 12 and is_proxy == 0
          input:
            control: Switch

        - id: socsup_q7
          kind: QuestionGroup
          title: "How often are you in contact with (seeing, talking, or writing to) the following people? Indicate: daily, weekly, monthly, or less."
          precondition:
            - predicate: age >= 12 and is_proxy == 0
          input:
            control: Radio
            labels:
              1: "Daily"
              2: "At least once a week"
              3: "At least once a month"
              4: "Less than once a month"
              5: "Never or not applicable"
          questions:
            - "a) Family members (immediate and extended family not living with you)"
            - "b) Friends"
            - "c) Neighbours"
            - "d) Co-workers (outside of work)"
            - "e) Professionals (doctor, lawyer, accountant)"
            - "f) Other acquaintances"
