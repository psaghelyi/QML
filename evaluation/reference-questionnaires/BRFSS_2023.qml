qmlVersion: "1.0"
questionnaire:
  title: "2023 Behavioral Risk Factor Surveillance System (BRFSS)"
  codeInit: |
    # Core computed variables
    currently_smoke = 0
    ever_smoked = 0
    has_diabetes = 0
    has_asthma = 0
    has_skin_cancer = 0
    has_other_cancer = 0
    has_copd = 0
    has_arthritis = 0
    has_depression = 0
    has_kidney_disease = 0
    has_heart_disease = 0
    has_stroke = 0
    drinks_alcohol = 0
    got_flu_shot = 0
    got_pneumonia_shot = 0
    got_covid_vax = 0
    is_employed = 0
    age_years = 0
    has_children = 0
    hpv_age_eligible = 0
    uses_marijuana = 0
  blocks:
    # =========================================================
    # CORE SECTION 1: Health Status
    # =========================================================
    - id: b_health_status
      title: "Section 1: Health Status"
      items:
        - id: q_genhlth
          kind: Question
          title: "Would you say that in general your health is..."
          input:
            control: Radio
            labels:
              1: "Excellent"
              2: "Very good"
              3: "Good"
              4: "Fair"
              5: "Poor"
              7: "Don't know / Not sure"
              9: "Refused"

    # =========================================================
    # CORE SECTION 2: Healthy Days - Health-Related Quality of Life
    # =========================================================
    - id: b_healthy_days
      title: "Section 2: Healthy Days"
      items:
        - id: q_physhlth
          kind: Question
          title: "Now thinking about your physical health, which includes physical illness and injury, for how many days during the past 30 days was your physical health not good?"
          input:
            control: Editbox
            min: 0
            max: 30
            right: "days (0 = none)"

        - id: q_menthlth
          kind: Question
          title: "Now thinking about your mental health, which includes stress, depression, and problems with emotions, for how many days during the past 30 days was your mental health not good?"
          input:
            control: Editbox
            min: 0
            max: 30
            right: "days (0 = none)"

        - id: q_poorhlth
          kind: Question
          title: "During the past 30 days, for about how many days did poor physical or mental health keep you from doing your usual activities, such as self-care, work, or recreation?"
          precondition:
            - predicate: "q_physhlth.outcome >= 1 or q_menthlth.outcome >= 1"
          input:
            control: Editbox
            min: 0
            max: 30
            right: "days (0 = none)"

    # =========================================================
    # CORE SECTION 3: Health Care Access
    # =========================================================
    - id: b_healthcare
      title: "Section 3: Health Care Access"
      items:
        - id: q_hlthpln
          kind: Question
          title: "Do you have any kind of health care coverage, including health insurance, prepaid plans such as HMOs, or government plans such as Medicare, or Indian Health Service?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_persdoc
          kind: Question
          title: "Do you have one person you think of as your personal doctor or health care provider? (If yes: Is that one person or more than one person?)"
          input:
            control: Radio
            labels:
              1: "Yes, only one"
              2: "More than one"
              3: "No"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_medcost
          kind: Question
          title: "Was there a time in the past 12 months when you needed to see a doctor but could not because of cost?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_checkup
          kind: Question
          title: "About how long has it been since you last visited a doctor for a routine checkup?"
          input:
            control: Radio
            labels:
              1: "Within past year (anytime less than 12 months ago)"
              2: "Within past 2 years (1 year but less than 2 years ago)"
              3: "Within past 5 years (2 years but less than 5 years ago)"
              4: "5 or more years ago"
              8: "Never"
              7: "Don't know / Not sure"
              9: "Refused"

    # =========================================================
    # CORE SECTION 4: Exercise
    # =========================================================
    - id: b_exercise
      title: "Section 4: Exercise"
      items:
        - id: q_exerany
          kind: Question
          title: "During the past month, other than your regular job, did you participate in any physical activities or exercises such as running, calisthenics, golf, gardening, or walking for exercise?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

    # =========================================================
    # CORE SECTION 5: Chronic Health Conditions
    # =========================================================
    - id: b_chronic
      title: "Section 5: Chronic Health Conditions"
      items:
        # --- Diabetes ---
        - id: q_diabete
          kind: Question
          title: "Have you ever been told by a doctor that you have diabetes?"
          codeBlock: |
            if q_diabete.outcome == 1:
                has_diabetes = 1
            if q_diabete.outcome == 2:
                has_diabetes = 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "Yes, but only during pregnancy (female respondents)"
              3: "No"
              4: "No, pre-diabetes or borderline diabetes"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_diabage
          kind: Question
          title: "How old were you when you were told you had diabetes?"
          precondition:
            - predicate: q_diabete.outcome == 1
          postcondition:
            - predicate: q_diabage.outcome >= 1
              hint: "Age must be at least 1"
            - predicate: q_diabage.outcome <= 97
              hint: "Age must be 97 or less (98 = Don't know/Not sure, 99 = Refused)"
          input:
            control: Editbox
            min: 1
            max: 99
            right: "years old (98=Don't know, 99=Refused)"

        - id: q_insulin
          kind: Question
          title: "Are you now taking insulin?"
          precondition:
            - predicate: q_diabete.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_bldsugar
          kind: Question
          title: "During the past 12 months, how many times have you checked your blood sugar?"
          precondition:
            - predicate: q_diabete.outcome == 1
          input:
            control: Radio
            labels:
              1: "Once a day or more"
              2: "Once a week or more (but not every day)"
              3: "Less than once a week"
              4: "Never"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_doctdiab
          kind: Question
          title: "During the past 12 months, have you seen a doctor, nurse, or other health professional for your diabetes?"
          precondition:
            - predicate: q_diabete.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

        # --- Asthma ---
        - id: q_asthma
          kind: Question
          title: "Have you ever been told by a doctor, nurse, or other health professional that you had asthma?"
          codeBlock: |
            if q_asthma.outcome == 1:
                has_asthma = 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_asthnow
          kind: Question
          title: "Do you still have asthma?"
          precondition:
            - predicate: q_asthma.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

        # --- Skin Cancer ---
        - id: q_chcscncr
          kind: Question
          title: "Have you ever been told by a doctor, nurse, or other health professional that you had skin cancer?"
          codeBlock: |
            if q_chcscncr.outcome == 1:
                has_skin_cancer = 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

        # --- Other Cancers ---
        - id: q_chcocncr
          kind: Question
          title: "Have you ever been told by a doctor, nurse, or other health professional that you had any other types of cancer?"
          codeBlock: |
            if q_chcocncr.outcome == 1:
                has_other_cancer = 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

        # --- COPD ---
        - id: q_chccopd
          kind: Question
          title: "Have you ever been told by a doctor, nurse, or other health professional that you have COPD (chronic obstructive pulmonary disease), emphysema or chronic bronchitis?"
          codeBlock: |
            if q_chccopd.outcome == 1:
                has_copd = 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

        # --- Arthritis ---
        - id: q_havarth
          kind: Question
          title: "Have you ever been told by a doctor, nurse, or other health professional that you have some form of arthritis, rheumatoid arthritis, gout, lupus, or fibromyalgia?"
          codeBlock: |
            if q_havarth.outcome == 1:
                has_arthritis = 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

        # --- Depression ---
        - id: q_addepev
          kind: Question
          title: "Has a doctor, nurse, or other health professional EVER told you that you have a depressive disorder (including depression, major depression, dysthymia, or minor depression)?"
          codeBlock: |
            if q_addepev.outcome == 1:
                has_depression = 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

        # --- Kidney Disease ---
        - id: q_chckdny
          kind: Question
          title: "Not including kidney stones, bladder infection or incontinence, were you ever told you had kidney disease?"
          codeBlock: |
            if q_chckdny.outcome == 1:
                has_kidney_disease = 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

        # --- Coronary Heart Disease ---
        - id: q_cvdcrhd
          kind: Question
          title: "Has a doctor, nurse, or other health professional EVER told you that you had angina or coronary heart disease?"
          codeBlock: |
            if q_cvdcrhd.outcome == 1:
                has_heart_disease = 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

        # --- Heart Attack ---
        - id: q_cvdinfr
          kind: Question
          title: "Has a doctor, nurse, or other health professional EVER told you that you had a heart attack, also called a myocardial infarction?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

        # --- Stroke ---
        - id: q_cvdstrk
          kind: Question
          title: "Has a doctor, nurse, or other health professional EVER told you that you had a stroke?"
          codeBlock: |
            if q_cvdstrk.outcome == 1:
                has_stroke = 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

    # =========================================================
    # CORE SECTION 6: Tobacco Use
    # =========================================================
    - id: b_tobacco
      title: "Section 6: Tobacco Use"
      items:
        - id: q_smoke100
          kind: Question
          title: "Have you smoked at least 100 cigarettes in your entire life?"
          codeBlock: |
            if q_smoke100.outcome == 1:
                ever_smoked = 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_smokday
          kind: Question
          title: "Do you now smoke cigarettes every day, some days, or not at all?"
          precondition:
            - predicate: q_smoke100.outcome == 1
          codeBlock: |
            if q_smokday.outcome == 1 or q_smokday.outcome == 2:
                currently_smoke = 1
          input:
            control: Radio
            labels:
              1: "Every day"
              2: "Some days"
              3: "Not at all"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_smokstop
          kind: Question
          title: "During the past 12 months, have you stopped smoking for one day or longer because you were trying to quit smoking?"
          precondition:
            - predicate: currently_smoke == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_lastsmk
          kind: Question
          title: "How long has it been since you last smoked a cigarette, even one or two puffs?"
          precondition:
            - predicate: q_smoke100.outcome == 1
            - predicate: q_smokday.outcome == 3
          input:
            control: Radio
            labels:
              1: "Within the past month (less than 1 month ago)"
              2: "Within the past 3 months (1 month but less than 3 months ago)"
              3: "Within the past 6 months (3 months but less than 6 months ago)"
              4: "Within the past year (6 months but less than 1 year ago)"
              5: "1 to 5 years ago"
              6: "5 to 10 years ago"
              7: "10 years or more"
              8: "Never smoked regularly"
              77: "Don't know / Not sure"
              99: "Refused"

        - id: q_smokless
          kind: Question
          title: "Do you currently use chewing tobacco, snuff, or snus?"
          input:
            control: Radio
            labels:
              1: "Every day"
              2: "Some days"
              3: "Not at all"
              7: "Don't know / Not sure"
              9: "Refused"

        # E-cigarettes
        - id: q_ecigaret
          kind: Question
          title: "Have you ever used an e-cigarette or other electronic vaping product, even just one time, in your entire life?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_ecignow
          kind: Question
          title: "Do you currently use e-cigarettes or other electronic vaping products every day, some days, or not at all?"
          precondition:
            - predicate: q_ecigaret.outcome == 1
          input:
            control: Radio
            labels:
              1: "Every day"
              2: "Some days"
              3: "Not at all"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_lcsnuget
          kind: Question
          title: "Have you ever used nicotine replacement therapy products (such as nicotine patches, nicotine gum, or nicotine lozenges)?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_lcsnunow
          kind: Question
          title: "Are you currently using nicotine replacement therapy products?"
          precondition:
            - predicate: q_lcsnuget.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

    # =========================================================
    # CORE SECTION 7: Alcohol Consumption
    # =========================================================
    - id: b_alcohol
      title: "Section 7: Alcohol Consumption"
      items:
        - id: q_drnkany
          kind: Question
          title: "During the past 30 days, have you had at least one drink of any alcoholic beverage such as beer, wine, a malt beverage or liquor?"
          codeBlock: |
            if q_drnkany.outcome == 1:
                drinks_alcohol = 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_drnknum
          kind: Question
          title: "During the past 30 days, how many days per month did you have at least one drink of any alcoholic beverage?"
          precondition:
            - predicate: drinks_alcohol == 1
          input:
            control: Editbox
            min: 1
            max: 30
            right: "days per month"

        - id: q_drnkwek
          kind: Question
          title: "On the days when you drank, about how many drinks did you drink on the average?"
          precondition:
            - predicate: drinks_alcohol == 1
          input:
            control: Editbox
            min: 1
            max: 76
            right: "drinks (76 = 76 or more)"

        - id: q_binge
          kind: Question
          title: "Considering all types of alcoholic beverages, how many times during the past 30 days did you have 5 or more drinks for men or 4 or more drinks for women on an occasion?"
          precondition:
            - predicate: drinks_alcohol == 1
          input:
            control: Editbox
            min: 0
            max: 76
            right: "times (76 = 76 or more)"

    # =========================================================
    # CORE SECTION 8: Fruits and Vegetables
    # =========================================================
    - id: b_fruits_veg
      title: "Section 8: Fruits and Vegetables"
      items:
        - id: q_frutjuic
          kind: Question
          title: "How often did you drink 100% pure fruit juices? (Not counting fruit-flavored drinks with added sugar)"
          input:
            control: Radio
            labels:
              1: "Never"
              2: "1 to 6 times per week"
              3: "1 time per day"
              4: "2 times per day"
              5: "3 or more times per day"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_fruit
          kind: Question
          title: "How often did you eat fruit? (Not counting juices)"
          input:
            control: Radio
            labels:
              1: "Never"
              2: "1 to 6 times per week"
              3: "1 time per day"
              4: "2 times per day"
              5: "3 or more times per day"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_fvgreen
          kind: Question
          title: "How often did you eat a green leafy or lettuce salad, with or without other vegetables?"
          input:
            control: Radio
            labels:
              1: "Never"
              2: "1 to 6 times per week"
              3: "1 time per day"
              4: "2 times per day"
              5: "3 or more times per day"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_fvbean
          kind: Question
          title: "How often did you eat beans or lentils?"
          input:
            control: Radio
            labels:
              1: "Never"
              2: "1 to 6 times per week"
              3: "1 time per day"
              4: "2 times per day"
              5: "3 or more times per day"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_fvorang
          kind: Question
          title: "How often did you eat orange-colored vegetables such as sweet potatoes, pumpkin, or winter squash?"
          input:
            control: Radio
            labels:
              1: "Never"
              2: "1 to 6 times per week"
              3: "1 time per day"
              4: "2 times per day"
              5: "3 or more times per day"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_vegetabl
          kind: Question
          title: "How often did you eat other vegetables?"
          input:
            control: Radio
            labels:
              1: "Never"
              2: "1 to 6 times per week"
              3: "1 time per day"
              4: "2 times per day"
              5: "3 or more times per day"
              7: "Don't know / Not sure"
              9: "Refused"

    # =========================================================
    # CORE SECTION 9: Demographics
    # =========================================================
    - id: b_demographics
      title: "Section 9: Demographics"
      items:
        - id: q_sex
          kind: Question
          title: "What was your sex at birth? Was it male or female?"
          input:
            control: Radio
            labels:
              1: "Male"
              2: "Female"
              9: "Refused"

        - id: q_sexvar
          kind: Question
          title: "Do you currently describe yourself as male, female, or transgender?"
          input:
            control: Radio
            labels:
              1: "Male"
              2: "Female"
              3: "Transgender"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_trnsgndr
          kind: Question
          title: "Do you consider yourself to be transgender?"
          precondition:
            - predicate: q_sexvar.outcome == 3
          input:
            control: Radio
            labels:
              1: "Male-to-female"
              2: "Female-to-male"
              3: "Gender non-conforming"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_sxorient
          kind: Question
          title: "Do you consider yourself to be straight or heterosexual, lesbian or gay, bisexual, or something else?"
          input:
            control: Radio
            labels:
              1: "Straight or heterosexual"
              2: "Lesbian or gay"
              3: "Bisexual"
              4: "Something else"
              5: "I don't know the answer"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_marital
          kind: Question
          title: "Are you... (marital status)"
          input:
            control: Radio
            labels:
              1: "Married"
              2: "Divorced"
              3: "Widowed"
              4: "Separated"
              5: "Never married"
              6: "A member of an unmarried couple"
              9: "Refused"

        - id: q_children
          kind: Question
          title: "How many children less than 18 years of age live in your household?"
          codeBlock: |
            if q_children.outcome >= 1 and q_children.outcome <= 87:
                has_children = 1
          input:
            control: Editbox
            min: 0
            max: 99
            right: "children (88 = None, 99 = Refused)"

        - id: q_educa
          kind: Question
          title: "What is the highest grade or year of school you completed?"
          input:
            control: Radio
            labels:
              1: "Never attended school or only kindergarten"
              2: "Grades 1 through 8 (Elementary)"
              3: "Grades 9 through 11 (Some high school)"
              4: "Grade 12 or GED (High school graduate)"
              5: "College 1 year to 3 years (Some college or technical school)"
              6: "College 4 years or more (College graduate)"
              9: "Refused"

        - id: q_employ
          kind: Question
          title: "Are you currently...?"
          codeBlock: |
            if q_employ.outcome == 1 or q_employ.outcome == 2 or q_employ.outcome == 3:
                is_employed = 1
          input:
            control: Radio
            labels:
              1: "Employed for wages"
              2: "Self-employed"
              3: "Out of work for 1 year or more"
              4: "Out of work for less than 1 year"
              5: "A homemaker"
              6: "A student"
              7: "Retired"
              8: "Unable to work"
              9: "Refused"

        - id: q_income
          kind: Question
          title: "Is your annual household income from all sources..."
          input:
            control: Radio
            labels:
              1: "Less than $10,000"
              2: "$10,000 to less than $15,000"
              3: "$15,000 to less than $20,000"
              4: "$20,000 to less than $25,000"
              5: "$25,000 to less than $35,000"
              6: "$35,000 to less than $50,000"
              7: "$50,000 to less than $75,000"
              8: "$75,000 or more"
              77: "Don't know / Not sure"
              99: "Refused"

        - id: q_renthom
          kind: Question
          title: "Do you own or rent your home?"
          input:
            control: Radio
            labels:
              1: "Own"
              2: "Rent"
              3: "Other arrangement"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_veteran
          kind: Question
          title: "Have you ever served on active duty in the United States Armed Forces, either in the regular military or in a National Guard or military reserve unit?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_internet
          kind: Question
          title: "Have you used the internet in the past 30 days?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_weight
          kind: Question
          title: "About how much do you weigh without shoes?"
          input:
            control: Editbox
            min: 50
            max: 999
            right: "pounds (9999 = Refused/Don't know)"

        - id: q_height
          kind: Question
          title: "About how tall are you without shoes?"
          input:
            control: Editbox
            min: 1
            max: 9999
            right: "feet and inches combined (e.g., 509 = 5 ft 9 in; 9999 = Refused)"

        - id: q_age
          kind: Question
          title: "How old are you?"
          codeBlock: |
            age_years = q_age.outcome
          input:
            control: Editbox
            min: 18
            max: 99
            right: "years old (99 = Refused)"

        - id: q_race
          kind: Question
          title: "Which one or more of the following would you say is your race?"
          input:
            control: Radio
            labels:
              1: "White"
              2: "Black or African American"
              3: "American Indian or Alaska Native"
              4: "Asian"
              5: "Native Hawaiian or Other Pacific Islander"
              6: "Other race"
              7: "No preferred race"
              8: "Multiracial"
              77: "Don't know / Not sure"
              99: "Refused"

        - id: q_hispanic
          kind: Question
          title: "Are you Hispanic, Latino/a, or Spanish origin?"
          input:
            control: Radio
            labels:
              1: "Yes, Hispanic"
              2: "No, not Hispanic"
              7: "Don't know / Not sure"
              9: "Refused"

    # =========================================================
    # CORE SECTION 10: Immunization
    # =========================================================
    - id: b_immunization
      title: "Section 10: Immunization"
      items:
        - id: q_flushot
          kind: Question
          title: "During the past 12 months, have you had either a flu shot or a flu vaccine that was sprayed in your nose?"
          codeBlock: |
            if q_flushot.outcome == 1:
                got_flu_shot = 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_flushyr
          kind: Question
          title: "During what month and year did you receive your most recent flu shot or flu vaccine?"
          precondition:
            - predicate: got_flu_shot == 1
          input:
            control: Radio
            labels:
              1: "July 2022 - December 2022"
              2: "January 2023 - June 2023"
              3: "July 2023 - December 2023"
              4: "January 2024 or later"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_pneuvac
          kind: Question
          title: "Have you ever had a pneumonia shot also known as a pneumococcal vaccine?"
          codeBlock: |
            if q_pneuvac.outcome == 1:
                got_pneumonia_shot = 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_shingles
          kind: Question
          title: "Have you ever had the shingles or zoster vaccine?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

    # =========================================================
    # CORE SECTION 11: HIV/AIDS
    # =========================================================
    - id: b_hiv
      title: "Section 11: HIV/AIDS"
      items:
        - id: q_hivtst
          kind: Question
          title: "Have you ever been tested for HIV?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_hivtimr
          kind: Question
          title: "How long has it been since your last HIV test?"
          precondition:
            - predicate: q_hivtst.outcome == 1
          input:
            control: Radio
            labels:
              1: "Within the past 12 months"
              2: "Within the past year (1 to 2 years ago)"
              3: "Within the past 2 years (2 to 3 years ago)"
              4: "Within the past 5 years (3 to 5 years ago)"
              5: "5 or more years ago"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_hivrisk
          kind: Question
          title: "In the past 12 months, have you... (risk behaviors for HIV)"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

    # =========================================================
    # OPTIONAL MODULE 1: Diabetes Extended
    # =========================================================
    - id: b_mod_diabetes
      title: "Optional Module 1: Diabetes (Extended)"
      precondition:
        - predicate: has_diabetes == 1
      items:
        - id: q_prediab
          kind: Question
          title: "Have you ever been told by a doctor or other health professional that you have pre-diabetes or borderline diabetes?"
          precondition:
            - predicate: q_diabete.outcome == 3
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Yes, during pregnancy (females only)"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_eyeexam
          kind: Question
          title: "Have you had an eye exam in the past 12 months in which the pupils were dilated, making you temporarily sensitive to light?"
          precondition:
            - predicate: has_diabetes == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_diabeye
          kind: Question
          title: "Has a doctor ever told you that diabetes has affected your eyes or that you had retinopathy?"
          precondition:
            - predicate: has_diabetes == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_diabfoot
          kind: Question
          title: "Have you ever had any sores or irritations on your feet that took more than 4 weeks to heal?"
          precondition:
            - predicate: has_diabetes == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_diabkidn
          kind: Question
          title: "Has a doctor ever told you that diabetes has affected your kidneys?"
          precondition:
            - predicate: has_diabetes == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_diabnutr
          kind: Question
          title: "Have you ever taken a course or class in how to manage your diabetes yourself?"
          precondition:
            - predicate: has_diabetes == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

    # =========================================================
    # OPTIONAL MODULE 2: Arthritis Management
    # =========================================================
    - id: b_mod_arthritis
      title: "Optional Module 2: Arthritis Management"
      precondition:
        - predicate: has_arthritis == 1
      items:
        - id: q_artwrk
          kind: Question
          title: "Do your arthritis or joint symptoms currently affect whether you work?"
          input:
            control: Radio
            labels:
              1: "Yes, unable to work"
              2: "Yes, limited in the kind or amount of work I can do"
              3: "No, arthritis does not affect my work"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_arthlmt
          kind: Question
          title: "Are you limited in any of your usual activities because of arthritis or joint symptoms?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_arthedu
          kind: Question
          title: "Have you ever taken an educational course or class to teach you how to manage the problems caused by your arthritis?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

    # =========================================================
    # OPTIONAL MODULE 3: Asthma Management
    # =========================================================
    - id: b_mod_asthma
      title: "Optional Module 3: Asthma Management"
      precondition:
        - predicate: has_asthma == 1
      items:
        - id: q_asattack
          kind: Question
          title: "During the past 12 months, have you had an episode of asthma or an asthma attack?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_aservist
          kind: Question
          title: "During the past 12 months, have you visited an emergency room or urgent care center because of asthma?"
          precondition:
            - predicate: q_asthnow.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_asdrvist
          kind: Question
          title: "During the past 12 months, have you had to see a doctor, nurse, or other health professional for asthma?"
          precondition:
            - predicate: q_asthnow.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_asrchkp
          kind: Question
          title: "During the past 12 months, have you had a routine check-up for your asthma?"
          precondition:
            - predicate: q_asthnow.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_asymed
          kind: Question
          title: "Do you currently take asthma medication?"
          precondition:
            - predicate: q_asthnow.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_asnoslep
          kind: Question
          title: "During the past 30 days, how many days did asthma symptoms keep you awake at night?"
          precondition:
            - predicate: q_asthnow.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 30
            right: "days"

    # =========================================================
    # OPTIONAL MODULE 4: Oral Health
    # =========================================================
    - id: b_oral_health
      title: "Optional Module 4: Oral Health"
      items:
        - id: q_lastden
          kind: Question
          title: "How long has it been since you last visited a dentist or a dental clinic for any reason?"
          input:
            control: Radio
            labels:
              1: "Within the past year (anytime less than 12 months ago)"
              2: "Within the past 2 years (1 year but less than 2 years ago)"
              3: "Within the past 5 years (2 years but less than 5 years ago)"
              4: "5 or more years ago"
              8: "Never"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_rmvteeth
          kind: Question
          title: "How many of your permanent teeth have been removed because of tooth decay or gum disease?"
          input:
            control: Radio
            labels:
              1: "None"
              2: "1 to 5"
              3: "6 or more, but not all"
              4: "All"
              7: "Don't know / Not sure"
              9: "Refused"

    # =========================================================
    # OPTIONAL MODULE 5: Vision
    # =========================================================
    - id: b_vision
      title: "Optional Module 5: Vision"
      items:
        - id: q_eyewear
          kind: Question
          title: "Do you wear glasses or contact lenses?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_visiondf
          kind: Question
          title: "Are you blind or do you have serious difficulty seeing, even when wearing glasses?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

    # =========================================================
    # OPTIONAL MODULE 6: Cognitive Decline
    # =========================================================
    - id: b_cognitive
      title: "Optional Module 6: Cognitive Decline"
      items:
        - id: q_cimemlos
          kind: Question
          title: "During the past 12 months, have you experienced confusion or memory loss that is happening more often or is getting worse?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_cdhouse
          kind: Question
          title: "During the past 12 months, as a result of confusion or memory loss, how often have you given up day-to-day household activities or chores you used to do, such as cooking, cleaning, taking medications, driving, or paying bills?"
          precondition:
            - predicate: q_cimemlos.outcome == 1
          input:
            control: Radio
            labels:
              1: "Always"
              2: "Usually"
              3: "Sometimes"
              4: "Rarely"
              5: "Never"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_cdassist
          kind: Question
          title: "Do you need assistance with these activities because of confusion or memory loss?"
          precondition:
            - predicate: q_cimemlos.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_cdsocial
          kind: Question
          title: "During the past 12 months, as a result of confusion or memory loss, how often have you had difficulty doing social activities?"
          precondition:
            - predicate: q_cimemlos.outcome == 1
          input:
            control: Radio
            labels:
              1: "Always"
              2: "Usually"
              3: "Sometimes"
              4: "Rarely"
              5: "Never"
              7: "Don't know / Not sure"
              9: "Refused"

    # =========================================================
    # OPTIONAL MODULE 7: Falls
    # =========================================================
    - id: b_falls
      title: "Optional Module 7: Falls"
      items:
        - id: q_fall12mn
          kind: Question
          title: "In the past 12 months, have you had any falls?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_fallinj
          kind: Question
          title: "In the past 12 months, how many times have you fallen?"
          precondition:
            - predicate: q_fall12mn.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 76
            right: "times (76 = 76 or more)"

        - id: q_fallinjr
          kind: Question
          title: "In the past 12 months, have you had any fall injuries that required medical treatment or restricted your activities for at least a day?"
          precondition:
            - predicate: q_fall12mn.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

    # =========================================================
    # OPTIONAL MODULE 8: Cancer Screening
    # =========================================================
    - id: b_cancer_screen
      title: "Optional Module 8: Cancer Screening"
      items:
        # Colorectal
        - id: q_hadsigm
          kind: Question
          title: "A sigmoidoscopy or colonoscopy is an exam in which a tube is inserted in the rectum to view the colon for signs of cancer or other health problems. Have you ever had this exam?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_hadsgco
          kind: Question
          title: "Was this most recent exam a sigmoidoscopy or a colonoscopy?"
          precondition:
            - predicate: q_hadsigm.outcome == 1
          input:
            control: Radio
            labels:
              1: "Sigmoidoscopy"
              2: "Colonoscopy"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_lastsig
          kind: Question
          title: "How long ago was your most recent sigmoidoscopy or colonoscopy?"
          precondition:
            - predicate: q_hadsigm.outcome == 1
          input:
            control: Radio
            labels:
              1: "Within the past year (anytime less than 12 months ago)"
              2: "Within the past 2 years (1 year but less than 2 years ago)"
              3: "Within the past 5 years (2 years but less than 5 years ago)"
              4: "Within the past 10 years (5 years but less than 10 years ago)"
              5: "10 or more years ago"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_hpvtest
          kind: Question
          title: "Have you ever had an HPV test (to screen for human papillomavirus or cervical cancer)?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_paptest
          kind: Question
          title: "A Pap test is a test for cancer or pre-cancer of the cervix. Have you ever had a Pap test?"
          precondition:
            - predicate: q_sex.outcome == 2
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_lastpap
          kind: Question
          title: "How long has it been since you had your last Pap test?"
          precondition:
            - predicate: q_paptest.outcome == 1
          input:
            control: Radio
            labels:
              1: "Within the past year (anytime less than 12 months ago)"
              2: "Within the past 2 years (1 year but less than 2 years ago)"
              3: "Within the past 3 years (2 years but less than 3 years ago)"
              4: "Within the past 5 years (3 years but less than 5 years ago)"
              5: "5 or more years ago"
              7: "Don't know / Not sure"
              9: "Refused"

        # Mammogram
        - id: q_hadmam
          kind: Question
          title: "A mammogram is an x-ray of each breast to look for breast cancer. Have you ever had a mammogram?"
          precondition:
            - predicate: q_sex.outcome == 2
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_lastmam
          kind: Question
          title: "How long has it been since your last mammogram?"
          precondition:
            - predicate: q_hadmam.outcome == 1
          input:
            control: Radio
            labels:
              1: "Within the past year (anytime less than 12 months ago)"
              2: "Within the past 2 years (1 year but less than 2 years ago)"
              3: "Within the past 3 years (2 years but less than 3 years ago)"
              4: "Within the past 5 years (3 years but less than 5 years ago)"
              5: "5 or more years ago"
              7: "Don't know / Not sure"
              9: "Refused"

        # Prostate
        - id: q_psatest
          kind: Question
          title: "A PSA test is a blood test used to check for prostate cancer. Have you ever had a PSA test?"
          precondition:
            - predicate: q_sex.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_lastpsa
          kind: Question
          title: "How long ago was your last PSA test?"
          precondition:
            - predicate: q_psatest.outcome == 1
          input:
            control: Radio
            labels:
              1: "Within the past year (anytime less than 12 months ago)"
              2: "Within the past 2 years (1 year but less than 2 years ago)"
              3: "Within the past 5 years (2 years but less than 5 years ago)"
              4: "5 or more years ago"
              7: "Don't know / Not sure"
              9: "Refused"

    # =========================================================
    # OPTIONAL MODULE 9: Anxiety and Depression (PHQ-8)
    # =========================================================
    - id: b_phq8
      title: "Optional Module 9: Anxiety and Depression (PHQ-8)"
      items:
        - id: q_phq8_intro
          kind: Comment
          title: "Over the last 2 weeks, how often have you been bothered by any of the following problems?"

        - id: q_phq8_1
          kind: Question
          title: "Little interest or pleasure in doing things"
          input:
            control: Radio
            labels:
              0: "Not at all"
              1: "Several days"
              2: "More than half the days"
              3: "Nearly every day"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_phq8_2
          kind: Question
          title: "Feeling down, depressed, or hopeless"
          input:
            control: Radio
            labels:
              0: "Not at all"
              1: "Several days"
              2: "More than half the days"
              3: "Nearly every day"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_phq8_3
          kind: Question
          title: "Trouble falling or staying asleep, or sleeping too much"
          input:
            control: Radio
            labels:
              0: "Not at all"
              1: "Several days"
              2: "More than half the days"
              3: "Nearly every day"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_phq8_4
          kind: Question
          title: "Feeling tired or having little energy"
          input:
            control: Radio
            labels:
              0: "Not at all"
              1: "Several days"
              2: "More than half the days"
              3: "Nearly every day"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_phq8_5
          kind: Question
          title: "Poor appetite or overeating"
          input:
            control: Radio
            labels:
              0: "Not at all"
              1: "Several days"
              2: "More than half the days"
              3: "Nearly every day"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_phq8_6
          kind: Question
          title: "Feeling bad about yourself or that you are a failure or have let yourself or your family down"
          input:
            control: Radio
            labels:
              0: "Not at all"
              1: "Several days"
              2: "More than half the days"
              3: "Nearly every day"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_phq8_7
          kind: Question
          title: "Trouble concentrating on things, such as reading the newspaper or watching television"
          input:
            control: Radio
            labels:
              0: "Not at all"
              1: "Several days"
              2: "More than half the days"
              3: "Nearly every day"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_phq8_8
          kind: Question
          title: "Moving or speaking so slowly that other people could have noticed. Or the opposite - being so fidgety or restless that you have been moving around a lot more than usual"
          input:
            control: Radio
            labels:
              0: "Not at all"
              1: "Several days"
              2: "More than half the days"
              3: "Nearly every day"
              7: "Don't know / Not sure"
              9: "Refused"

    # =========================================================
    # OPTIONAL MODULE 10: Food Insecurity
    # =========================================================
    - id: b_food_insecurity
      title: "Optional Module 10: Food Insecurity"
      items:
        - id: q_foodstmp
          kind: Question
          title: "During the past 12 months, did you receive food stamps, also called SNAP, the Supplemental Nutrition Assistance Program, on an EBT card?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_frtjuice
          kind: Question
          title: "During the past 12 months, how often did you not have enough food or money to buy food?"
          input:
            control: Radio
            labels:
              1: "Never"
              2: "Rarely"
              3: "Sometimes"
              4: "Usually"
              5: "Always"
              7: "Don't know / Not sure"
              9: "Refused"

    # =========================================================
    # OPTIONAL MODULE 11: Firearm Safety
    # =========================================================
    - id: b_firearms
      title: "Optional Module 11: Firearm Safety"
      items:
        - id: q_firearms
          kind: Question
          title: "Are any firearms kept in or around your home?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_gunlock
          kind: Question
          title: "Are any of these firearms now stored in a locked place?"
          precondition:
            - predicate: q_firearms.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes, all"
              2: "Yes, some"
              3: "No"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_gunload
          kind: Question
          title: "Are any of these firearms now stored loaded?"
          precondition:
            - predicate: q_firearms.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

    # =========================================================
    # OPTIONAL MODULE 12: Elder Care
    # =========================================================
    - id: b_elder_care
      title: "Optional Module 12: Elder Care"
      items:
        - id: q_caregiv
          kind: Question
          title: "In the past 30 days, did you provide regular care or assistance to a friend or family member who has a health problem or disability?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_cgrelat
          kind: Question
          title: "Is the person you care for a parent (including step or in-law), spouse or partner, child, or other relative, neighbor or friend?"
          precondition:
            - predicate: q_caregiv.outcome == 1
          input:
            control: Radio
            labels:
              1: "Parent (including step or in-law)"
              2: "Spouse or partner"
              3: "Child (including step or foster child)"
              4: "Other relative"
              5: "Neighbor, friend, or other non-relative"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_cgagecat
          kind: Question
          title: "How old is the person you care for?"
          precondition:
            - predicate: q_caregiv.outcome == 1
          input:
            control: Radio
            labels:
              1: "18 to 64 years"
              2: "65 years or older"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_cghours
          kind: Question
          title: "During the past 30 days, about how many hours did you spend providing care or assistance?"
          precondition:
            - predicate: q_caregiv.outcome == 1
          input:
            control: Radio
            labels:
              1: "0 to 8 hours per week"
              2: "9 to 19 hours per week"
              3: "20 to 39 hours per week"
              4: "40 or more hours per week"
              7: "Don't know / Not sure"
              9: "Refused"

    # =========================================================
    # OPTIONAL MODULE 13: Heart Attack and Stroke Prevention
    # =========================================================
    - id: b_heart_stroke_prev
      title: "Optional Module 13: Heart Attack and Stroke Prevention"
      precondition:
        - predicate: has_heart_disease == 1 or has_stroke == 1
      items:
        - id: q_aspirin
          kind: Question
          title: "Are you currently taking aspirin regularly to prevent a heart attack, stroke, or cancer?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_statins
          kind: Question
          title: "Are you currently taking medication to lower your cholesterol?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_bpstroke
          kind: Question
          title: "Are you currently taking medication to lower your blood pressure?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

    # =========================================================
    # OPTIONAL MODULE 14: Physical Activity (Extended)
    # =========================================================
    - id: b_phys_activity
      title: "Optional Module 14: Physical Activity (Extended)"
      items:
        - id: q_exract11
          kind: Question
          title: "What type of physical activity or exercise did you spend the most time doing during the past month?"
          precondition:
            - predicate: q_exerany.outcome == 1
          input:
            control: Radio
            labels:
              1: "Walking"
              2: "Running or jogging"
              3: "Gardening or yard work"
              4: "Bicycling or bicycling machine exercise"
              5: "Aerobics video or class"
              6: "Calisthenics"
              7: "Elliptical/EFX machine exercise"
              8: "Household activities"
              9: "Weight lifting"
              10: "Yoga, Pilates, or Tai Chi"
              11: "Other"
              77: "Don't know / Not sure"
              99: "Refused"

        - id: q_exeroft1
          kind: Question
          title: "How many times per week or per month did you take part in this activity during the past month?"
          precondition:
            - predicate: q_exerany.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 99
            right: "times (specify per week or month)"

        - id: q_exerhmm1
          kind: Question
          title: "How many minutes or hours per session did you usually spend on this activity?"
          precondition:
            - predicate: q_exerany.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 999
            right: "minutes"

    # =========================================================
    # OPTIONAL MODULE 15: Social Determinants of Health
    # =========================================================
    - id: b_sdoh
      title: "Optional Module 15: Social Determinants of Health"
      items:
        - id: q_msdhe01
          kind: Question
          title: "In general, how satisfied are you with your life? Are you..."
          input:
            control: Radio
            labels:
              1: "Very satisfied"
              2: "Satisfied"
              3: "Dissatisfied"
              4: "Very dissatisfied"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_msdhe02
          kind: Question
          title: "How often do you get the social and emotional support that you need? Is that..."
          input:
            control: Radio
            labels:
              1: "Always"
              2: "Usually"
              3: "Sometimes"
              4: "Rarely"
              5: "Never"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_msdhe03
          kind: Question
          title: "How often do you feel lonely? Is it..."
          input:
            control: Radio
            labels:
              1: "Always"
              2: "Usually"
              3: "Sometimes"
              4: "Rarely"
              5: "Never"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_msdhe04
          kind: Question
          title: "In the past 12 months have you lost employment or had hours reduced?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_msdhe05
          kind: Question
          title: "During the past 12 months, have you received food stamps (SNAP) on an EBT card?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_msdhe06
          kind: Question
          title: "During the past 12 months how often did the food that you bought not last, and you didn't have money to get more? Was that..."
          input:
            control: Radio
            labels:
              1: "Always"
              2: "Usually"
              3: "Sometimes"
              4: "Rarely"
              5: "Never"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_msdhe07
          kind: Question
          title: "During the last 12 months, was there a time when you were not able to pay your mortgage, rent or utility bills?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_msdhe08
          kind: Question
          title: "During the last 12 months was there a time when an electric, gas, oil, or water company threatened to shut off services?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_msdhe09
          kind: Question
          title: "During the past 12 months has a lack of reliable transportation kept you from medical appointments, meetings, work, or from getting things needed for daily living?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_msdhe10
          kind: Question
          title: "Within the last 30 days, how often have you felt stress? (Stress means a situation in which a person feels tense, restless, nervous or anxious or is unable to sleep at night because their mind is troubled.) Was it..."
          input:
            control: Radio
            labels:
              1: "Always"
              2: "Usually"
              3: "Sometimes"
              4: "Rarely"
              5: "Never"
              7: "Don't know / Not sure"
              9: "Refused"

    # =========================================================
    # OPTIONAL MODULE 16: Marijuana Use (Module 23)
    # =========================================================
    - id: b_marijuana
      title: "Optional Module 16: Marijuana Use"
      items:
        - id: q_mmu01
          kind: Question
          title: "During the past 30 days, on how many days did you use marijuana or cannabis? (Do not include hemp-based or CBD-only products.)"
          codeBlock: |
            if q_mmu01.outcome >= 1 and q_mmu01.outcome <= 30:
                uses_marijuana = 1
          input:
            control: Editbox
            min: 0
            max: 99
            right: "days (0 = none, 88 = None, 77 = Don't know, 99 = Refused)"

        - id: q_mmu02
          kind: Question
          title: "During the past 30 days, did you smoke it (for example, in a joint, bong, pipe, or blunt)?"
          precondition:
            - predicate: uses_marijuana == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_mmu03
          kind: Question
          title: "During the past 30 days, did you eat it or drink it (for example, in brownies, cakes, cookies, or candy, or in tea, cola, or alcohol)?"
          precondition:
            - predicate: uses_marijuana == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_mmu04
          kind: Question
          title: "During the past 30 days, did you vaporize it (for example, in an e-cigarette-like vaporizer or another vaporizing device)?"
          precondition:
            - predicate: uses_marijuana == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_mmu05
          kind: Question
          title: "During the past 30 days, did you dab it (for example, using a dabbing rig, knife, or dab pen)?"
          precondition:
            - predicate: uses_marijuana == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_mmu06
          kind: Question
          title: "During the past 30 days, did you use it in some other way?"
          precondition:
            - predicate: uses_marijuana == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_mmu07
          kind: Question
          title: "During the past 30 days, which one of the following ways did you use marijuana the most often?"
          precondition:
            - predicate: uses_marijuana == 1
          input:
            control: Radio
            labels:
              1: "Smoke it (for example, in a joint, bong, pipe, or blunt)"
              2: "Eat it or drink it (for example, in brownies, cakes, cookies, or candy or in tea, cola or alcohol)"
              3: "Vaporize it (for example, in an e-cigarette-like vaporizer or another vaporizing device)"
              4: "Dab it (for example, using a dabbing rig, knife, or dab pen)"
              5: "Use it some other way"
              7: "Don't know / Not sure"
              9: "Refused"

    # =========================================================
    # OPTIONAL MODULE 17: Adverse Childhood Experiences (Module 24)
    # =========================================================
    - id: b_ace
      title: "Optional Module 17: Adverse Childhood Experiences (ACE)"
      items:
        - id: q_ace_intro
          kind: Comment
          title: "I'd like to ask you some questions about events that happened during your childhood (before you were 18 years of age). This information will allow us to better understand problems that may occur early in life. These are sensitive questions and some people may feel uncomfortable. You can ask me to skip any question you do not want to answer."

        - id: q_mace01
          kind: Question
          title: "Now, looking back before you were 18 years of age: Did you live with anyone who was depressed, mentally ill, or suicidal?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_mace02
          kind: Question
          title: "Did you live with anyone who was a problem drinker or alcoholic?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_mace03
          kind: Question
          title: "Did you live with anyone who used illegal street drugs or who abused prescription medications?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_mace04
          kind: Question
          title: "Did you live with anyone who served time or was sentenced to serve time in a prison, jail, or other correctional facility?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_mace05
          kind: Question
          title: "Were your parents separated or divorced?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Parents not married"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_mace06
          kind: Question
          title: "How often did your parents or adults in your home ever slap, hit, kick, punch or beat each other up? Was it..."
          input:
            control: Radio
            labels:
              1: "Never"
              2: "Once"
              3: "More than once"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_mace07
          kind: Question
          title: "Not including spanking, (before age 18), how often did a parent or adult in your home ever hit, beat, kick, or physically hurt you in any way? Was it..."
          input:
            control: Radio
            labels:
              1: "Never"
              2: "Once"
              3: "More than once"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_mace08
          kind: Question
          title: "How often did a parent or adult in your home ever swear at you, insult you, or put you down? Was it..."
          input:
            control: Radio
            labels:
              1: "Never"
              2: "Once"
              3: "More than once"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_mace09
          kind: Question
          title: "How often did anyone at least 5 years older than you or an adult, ever touch you sexually? Was it..."
          input:
            control: Radio
            labels:
              1: "Never"
              2: "Once"
              3: "More than once"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_mace10
          kind: Question
          title: "How often did anyone at least 5 years older than you or an adult, try to make you touch them sexually? Was it..."
          input:
            control: Radio
            labels:
              1: "Never"
              2: "Once"
              3: "More than once"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_mace11
          kind: Question
          title: "How often did anyone at least 5 years older than you or an adult, force you to have sex? Was it..."
          input:
            control: Radio
            labels:
              1: "Never"
              2: "Once"
              3: "More than once"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_mace12
          kind: Question
          title: "For how much of your childhood was there an adult in your household who made you feel safe and protected? Would you say never, a little of the time, some of the time, most of the time, or all of the time?"
          input:
            control: Radio
            labels:
              1: "Never"
              2: "A little of the time"
              3: "Some of the time"
              4: "Most of the time"
              5: "All of the time"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_mace13
          kind: Question
          title: "For how much of your childhood was there an adult in your household who tried hard to make sure your basic needs were met? Would you say never, a little of the time, some of the time, most of the time, or all of the time?"
          input:
            control: Radio
            labels:
              1: "Never"
              2: "A little of the time"
              3: "Some of the time"
              4: "Most of the time"
              5: "All of the time"
              7: "Don't know / Not sure"
              9: "Refused"

    # =========================================================
    # OPTIONAL MODULE 18: Place of Flu Vaccination (Module 25)
    # =========================================================
    - id: b_flu_place
      title: "Optional Module 18: Place of Flu Vaccination"
      precondition:
        - predicate: got_flu_shot == 1
      items:
        - id: q_mfp01
          kind: Question
          title: "At what kind of place did you get your last flu shot or vaccine?"
          input:
            control: Radio
            labels:
              1: "A doctor's office or health maintenance organization (HMO)"
              2: "A health department"
              3: "Another type of clinic or health center (a community health center)"
              4: "A senior, recreation, or community center"
              5: "A store (supermarket, drug store)"
              6: "A hospital (inpatient or outpatient)"
              7: "An emergency room"
              8: "Workplace"
              9: "Some other kind of place"
              10: "Received vaccination in Canada/Mexico"
              11: "A school"
              77: "Don't know / Not sure"
              99: "Refused"

    # =========================================================
    # OPTIONAL MODULE 19: HPV Vaccination (Module 26)
    # =========================================================
    - id: b_hpv_vax
      title: "Optional Module 19: HPV Vaccination"
      precondition:
        - predicate: age_years >= 18
        - predicate: age_years <= 49
      items:
        - id: q_mhpv01
          kind: Question
          title: "Have you ever had an H.P.V. vaccination? (Human Papillomavirus; Gardasil or Cervarix)"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Doctor refused when asked"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_mhpv02
          kind: Question
          title: "How many HPV shots did you receive?"
          precondition:
            - predicate: q_mhpv01.outcome == 1
          input:
            control: Radio
            labels:
              1: "1 shot"
              2: "2 shots"
              3: "All shots (completed series)"
              77: "Don't know / Not sure"
              99: "Refused"

    # =========================================================
    # OPTIONAL MODULE 20: Tetanus (Tdap) (Module 27)
    # =========================================================
    - id: b_tdap
      title: "Optional Module 20: Tetanus Diphtheria (Tdap)"
      items:
        - id: q_mtdap01
          kind: Question
          title: "Have you received a tetanus shot in the past 10 years?"
          input:
            control: Radio
            labels:
              1: "Yes, received Tdap"
              2: "Yes, received tetanus shot, but not Tdap"
              3: "Yes, received tetanus shot but not sure what type"
              4: "No, did not receive any tetanus shot in the past 10 years"
              7: "Don't know / Not sure"
              9: "Refused"

    # =========================================================
    # OPTIONAL MODULE 21: COVID Vaccination (Module 28)
    # =========================================================
    - id: b_covid_vax
      title: "Optional Module 21: COVID-19 Vaccination"
      items:
        - id: q_mcov01
          kind: Question
          title: "Have you received at least one dose of a COVID-19 vaccination?"
          codeBlock: |
            if q_mcov01.outcome == 1:
                got_covid_vax = 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_mcov02
          kind: Question
          title: "Would you say you will definitely get a vaccine, will probably get a vaccine, will probably not get a vaccine, will definitely not get a vaccine, or are you not sure?"
          precondition:
            - predicate: q_mcov01.outcome == 2
          input:
            control: Radio
            labels:
              1: "Will definitely get a vaccine"
              2: "Will probably get a vaccine"
              3: "Will probably not get a vaccine"
              4: "Will definitely not get a vaccine"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_mcov03
          kind: Question
          title: "How many COVID-19 vaccinations have you received?"
          precondition:
            - predicate: got_covid_vax == 1
          input:
            control: Radio
            labels:
              1: "One"
              2: "Two"
              3: "Three"
              4: "Four"
              5: "Five or more"
              7: "Don't know / Not sure"
              9: "Refused"

    # =========================================================
    # OPTIONAL MODULE 22: Reactions to Race (Module 30)
    # =========================================================
    - id: b_reactions_race
      title: "Optional Module 22: Reactions to Race"
      items:
        - id: q_mrtr01
          kind: Question
          title: "Earlier I asked you to self-identify your race. Now I will ask you how other people identify you and treat you. How do other people usually classify you in this country? Would you say: White, Black or African American, Hispanic or Latino, Asian, Native Hawaiian or Other Pacific Islander, American Indian or Alaska Native, or some other group?"
          input:
            control: Radio
            labels:
              1: "White"
              2: "Black or African American"
              3: "Hispanic or Latino"
              4: "Asian"
              5: "Native Hawaiian or Other Pacific Islander"
              6: "American Indian or Alaska Native"
              7: "Mixed Race"
              8: "Some other group"
              77: "Don't know / Not sure"
              99: "Refused"

        - id: q_mrtr02
          kind: Question
          title: "How often do you think about your race? Would you say never, once a year, once a month, once a week, once a day, once an hour, or constantly?"
          input:
            control: Radio
            labels:
              1: "Never"
              2: "Once a year"
              3: "Once a month"
              4: "Once a week"
              5: "Once a day"
              6: "Once an hour"
              8: "Constantly"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_mrtr03
          kind: Question
          title: "Within the past 12 months, do you feel that in general you were treated worse than, the same as, or better than people of other races?"
          input:
            control: Radio
            labels:
              1: "Worse than other races"
              2: "The same as other races"
              3: "Better than other races"
              4: "Worse than some races, better than others"
              5: "Only encountered people of the same race"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_mrtr04
          kind: Question
          title: "Within the past 12 months at work, do you feel you were treated worse than, the same as, or better than people of other races?"
          precondition:
            - predicate: is_employed == 1
          input:
            control: Radio
            labels:
              1: "Worse than other races"
              2: "The same as other races"
              3: "Better than other races"
              4: "Worse than some races, better than others"
              5: "Only encountered people of the same race"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_mrtr05
          kind: Question
          title: "Within the past 12 months, when seeking health care, do you feel your experiences were worse than, the same as, or better than for people of other races?"
          input:
            control: Radio
            labels:
              1: "Worse than other races"
              2: "The same as other races"
              3: "Better than other races"
              4: "Worse than some races, better than others"
              5: "Only encountered people of the same race"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_mrtr06
          kind: Question
          title: "Within the past 30 days, have you experienced any physical symptoms, for example, a headache, an upset stomach, tensing of your muscles, or a pounding heart, as a result of how you were treated based on your race?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

    # =========================================================
    # OPTIONAL MODULE 23: Random Child Selection (Module 31)
    # =========================================================
    - id: b_child_selection
      title: "Optional Module 23: Random Child Selection"
      precondition:
        - predicate: has_children == 1
      items:
        - id: q_mrcs_intro
          kind: Comment
          title: "Previously, you indicated there are children age 17 or younger in your household. I would like to ask you some questions about one child. (CATI: Randomly select one child.)"

        - id: q_mrcs01
          kind: Question
          title: "What is the birth month and year of the selected child?"
          input:
            control: Editbox
            min: 1
            max: 9999
            right: "MM/YYYY (7777=Don't know, 9999=Refused)"

        - id: q_mrcs02
          kind: Question
          title: "Is the child a boy or a girl?"
          input:
            control: Radio
            labels:
              1: "Boy"
              2: "Girl"
              3: "Nonbinary/other"
              9: "Refused"

        - id: q_mrcs03
          kind: Question
          title: "What was the child's sex on their original birth certificate?"
          precondition:
            - predicate: q_mrcs02.outcome == 3
          input:
            control: Radio
            labels:
              1: "Boy"
              2: "Girl"
              9: "Refused"

        - id: q_mrcs04
          kind: Question
          title: "Is the child Hispanic, Latino/a, or Spanish origin?"
          input:
            control: Radio
            labels:
              1: "Mexican, Mexican American, Chicano/a"
              2: "Puerto Rican"
              3: "Cuban"
              4: "Another Hispanic, Latino/a, or Spanish origin"
              5: "No"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_mrcs05
          kind: Question
          title: "Which one or more of the following would you say is the race of the child?"
          input:
            control: Radio
            labels:
              10: "White"
              20: "Black or African American"
              30: "American Indian or Alaska Native"
              40: "Asian"
              50: "Pacific Islander"
              60: "Other"
              77: "Don't know / Not sure"
              88: "No additional choices"
              99: "Refused"

        - id: q_mrcs06
          kind: Question
          title: "How are you related to the child? Are you a..."
          input:
            control: Radio
            labels:
              1: "Parent (including biologic, step, or adoptive parent)"
              2: "Grandparent"
              3: "Foster parent or guardian"
              4: "Sibling (including biologic, step, and adoptive sibling)"
              5: "Other relative"
              6: "Not related in any way"
              7: "Don't know / Not sure"
              9: "Refused"

    # =========================================================
    # OPTIONAL MODULE 24: Childhood Asthma Prevalence (Module 32)
    # =========================================================
    - id: b_child_asthma
      title: "Optional Module 24: Childhood Asthma Prevalence"
      precondition:
        - predicate: has_children == 1
      items:
        - id: q_mcap01
          kind: Question
          title: "Has a doctor, nurse or other health professional EVER said that the child has asthma?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"

        - id: q_mcap02
          kind: Question
          title: "Does the child still have asthma?"
          precondition:
            - predicate: q_mcap01.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Not sure"
              9: "Refused"
