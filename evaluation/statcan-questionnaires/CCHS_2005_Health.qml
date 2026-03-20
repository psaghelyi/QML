qmlVersion: "1.0"
questionnaire:
  title: "Canadian Community Health Survey - Cycle 3.1 (2005)"
  codeInit: |
    # Respondent demographics (set from ANC block)
    age = 0
    sex = 0
    is_proxy = 0

    # Module selection flags (each module has a block flag)
    # 1 = selected for this respondent, 0 = not selected
    do_gen = 1
    do_org = 1
    do_slp = 1
    do_cih = 1
    do_hcs = 1
    do_hwt = 1
    do_ccc = 1
    do_dia = 1
    do_med = 1
    do_hcu = 1
    do_hmc = 1
    do_pas = 1
    do_rac = 1
    do_twd = 1
    do_flu = 1
    do_bpc = 1
    do_pap = 1
    do_mam = 1
    do_brx = 1
    do_bsx = 1
    do_eyx = 1
    do_pcu = 1
    do_psa = 1
    do_ccs = 1
    do_den = 1
    do_oh2 = 1
    do_fdc = 1
    do_fvc = 1
    do_pac = 1
    do_sac = 1
    do_upe = 1
    do_ssb = 1
    do_smk = 1
    do_sch = 1
    do_nde = 1
    do_sca = 1
    do_spc = 1
    do_ysm = 1
    do_ets = 1
    do_alc = 1
    do_mex = 1
    do_drg = 1
    do_cpg = 1
    do_swl = 1
    do_sts = 1
    do_stc = 1
    do_cst = 1
    do_wst = 1
    do_sfe = 1
    do_ssa = 1
    do_ssu = 1
    do_cmh = 1
    do_dis = 1
    do_dep = 1
    do_sui = 1
    do_inj = 1
    do_hui = 1
    do_sfr = 1
    do_sxb = 1
    do_acc = 1
    do_wtm = 1
    do_mhw = 1
    do_lbf = 1
    do_lf2 = 1
    do_sdc = 1
    do_edu = 1
    do_ins = 1
    do_inc = 1
    do_fsc = 1
    do_dwl = 1
    do_adm = 1

    # Smoking status variables (shared across modules)
    smk_status = 0
    smk_daily = 0
    smk_occasional = 0
    smk_former = 0

    # Chronic condition flags (shared across modules)
    has_asthma = 0
    has_diabetes = 0
    has_heart_disease = 0
    has_cancer = 0
    has_high_bp = 0

    # Depression screening variables
    dep_sad_2wks = 0
    dep_interest_2wks = 0
    dep_symptom_count = 0

    # Labour force variables
    lbf_worked_last_week = 0
    lbf_has_job = 0
    lbf_employee = 0

    # Health care utilization
    has_regular_doctor = 0
    overnight_patient = 0

  blocks:
    # =========================================================================
    # BLOCK 1: AGE OF SELECTED RESPONDENT (ANC) - p.1
    # Entry point for all respondents. Collects demographics.
    # =========================================================================
    - id: b_anc
      title: "Age of Selected Respondent"
      items:
        - id: anc_q01
          kind: Comment
          title: "This survey collects information about health status, health care utilization and health determinants for the Canadian population."

        - id: anc_q02
          kind: Question
          title: "Is this interview being conducted by proxy (someone answering on behalf of the selected respondent)?"
          codeBlock: |
            is_proxy = anc_q02.outcome
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: anc_q03
          kind: Question
          title: "What is the sex of the respondent?"
          codeBlock: |
            sex = anc_q03.outcome
          input:
            control: Radio
            labels:
              1: "Male"
              2: "Female"

        - id: anc_q04
          kind: Question
          title: "What is your age?"
          codeBlock: |
            age = anc_q04.outcome
          input:
            control: Editbox
            min: 12
            max: 110
            left: "Age:"
            right: "years"

    # =========================================================================
    # BLOCK 2: GENERAL HEALTH (GEN) - p.3
    # Core common content asked of all respondents.
    # =========================================================================
    - id: b_gen
      title: "General Health"
      items:
        - id: gen_q01
          kind: Question
          title: "In general, would you say your health is:"
          precondition:
            - predicate: do_gen == 1
          input:
            control: Radio
            labels:
              1: "Excellent"
              2: "Very good"
              3: "Good"
              4: "Fair"
              5: "Poor"

        - id: gen_q02
          kind: Question
          title: "In general, would you say your mental health is:"
          precondition:
            - predicate: do_gen == 1
          input:
            control: Radio
            labels:
              1: "Excellent"
              2: "Very good"
              3: "Good"
              4: "Fair"
              5: "Poor"

        - id: gen_q05
          kind: Question
          title: "Compared to one year ago, how would you say your health is now?"
          precondition:
            - predicate: do_gen == 1
          input:
            control: Radio
            labels:
              1: "Much better now"
              2: "Somewhat better now"
              3: "About the same"
              4: "Somewhat worse now"
              5: "Much worse now"

        - id: gen_q07
          kind: Question
          title: "Do you have any of the following long-term conditions diagnosed by a health professional? (Select most limiting)"
          precondition:
            - predicate: do_gen == 1
          input:
            control: Radio
            labels:
              1: "Food allergies"
              2: "Other allergies"
              3: "Asthma"
              4: "Fibromyalgia"
              5: "Arthritis/Rheumatism"
              6: "Back problems"
              7: "High blood pressure"
              8: "Migraine headaches"
              9: "Chronic bronchitis/Emphysema/COPD"
              10: "Diabetes"
              11: "Heart disease"
              12: "Cancer"
              13: "Stomach/Intestinal ulcers"
              14: "Stroke"
              15: "Urinary incontinence"
              16: "Bowel disorder"
              17: "Alzheimers/Dementia"
              18: "None of the above"

        - id: gen_q08
          kind: Question
          title: "Are you usually free of pain or discomfort?"
          precondition:
            - predicate: do_gen == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: gen_q09
          kind: Question
          title: "How would you describe the usual intensity of your pain or discomfort?"
          precondition:
            - predicate: do_gen == 1 and gen_q08.outcome == 0
          input:
            control: Radio
            labels:
              1: "Mild"
              2: "Moderate"
              3: "Severe"

        - id: gen_q10
          kind: Question
          title: "How many activities does your pain or discomfort prevent?"
          precondition:
            - predicate: do_gen == 1 and gen_q08.outcome == 0
          input:
            control: Radio
            labels:
              1: "None"
              2: "A few"
              3: "Some"
              4: "Most"

    # =========================================================================
    # BLOCK 3: VOLUNTARY ORGANIZATIONS (ORG) - p.6
    # =========================================================================
    - id: b_org
      title: "Voluntary Organizations"
      items:
        - id: org_q01
          kind: Question
          title: "In the past 12 months, were you a member of or a participant in any voluntary organizations or associations (such as school groups, church groups, community centres)?"
          precondition:
            - predicate: do_org == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: org_q02
          kind: Question
          title: "In total, how many different organizations or associations were you a member of or a participant in?"
          precondition:
            - predicate: do_org == 1 and org_q01.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 20

    # =========================================================================
    # BLOCK 4: SLEEP (SLP) - p.7
    # =========================================================================
    - id: b_slp
      title: "Sleep"
      items:
        - id: slp_q01
          kind: Question
          title: "How long do you usually spend sleeping each night?"
          precondition:
            - predicate: do_slp == 1
          input:
            control: Editbox
            min: 1
            max: 20
            right: "hours"

        - id: slp_q02
          kind: Question
          title: "How often do you have trouble going to sleep or staying asleep?"
          precondition:
            - predicate: do_slp == 1
          input:
            control: Radio
            labels:
              1: "Most of the time"
              2: "Sometimes"
              3: "Rarely"
              4: "Never"

        - id: slp_q03
          kind: Question
          title: "How often do you find your sleep refreshing?"
          precondition:
            - predicate: do_slp == 1
          input:
            control: Radio
            labels:
              1: "Most of the time"
              2: "Sometimes"
              3: "Rarely"
              4: "Never"

        - id: slp_q04
          kind: Question
          title: "How often do you have difficulty staying awake during normal waking hours when you want to?"
          precondition:
            - predicate: do_slp == 1
          input:
            control: Radio
            labels:
              1: "Most of the time"
              2: "Sometimes"
              3: "Rarely"
              4: "Never"

    # =========================================================================
    # BLOCK 5: CHANGES MADE TO IMPROVE HEALTH (CIH) - p.9
    # =========================================================================
    - id: b_cih
      title: "Changes Made to Improve Health"
      items:
        - id: cih_q01
          kind: Question
          title: "In the past 12 months, have you done anything to improve your health (e.g. lost weight, exercised more, quit smoking)?"
          precondition:
            - predicate: do_cih == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: cih_q02
          kind: Question
          title: "What was the most important change you made? (Select primary change)"
          precondition:
            - predicate: do_cih == 1 and cih_q01.outcome == 1
          input:
            control: Dropdown
            labels:
              1: "Exercised more"
              2: "Lost weight"
              3: "Changed diet / improved nutrition"
              4: "Quit smoking or reduced amount smoked"
              5: "Reduced stress"
              6: "Other"

    # =========================================================================
    # BLOCK 6: HEALTH CARE SYSTEM SATISFACTION (HCS) - p.12
    # =========================================================================
    - id: b_hcs
      title: "Health Care System Satisfaction"
      items:
        - id: hcs_q01
          kind: Question
          title: "How would you rate the availability of health care services in your community?"
          precondition:
            - predicate: do_hcs == 1
          input:
            control: Radio
            labels:
              1: "Excellent"
              2: "Good"
              3: "Fair"
              4: "Poor"

        - id: hcs_q02
          kind: Question
          title: "How would you rate the quality of health care services you have received in the past 12 months?"
          precondition:
            - predicate: do_hcs == 1
          input:
            control: Radio
            labels:
              1: "Excellent"
              2: "Good"
              3: "Fair"
              4: "Poor"

        - id: hcs_q03
          kind: Question
          title: "Overall, how would you rate the way health care services were provided?"
          precondition:
            - predicate: do_hcs == 1
          input:
            control: Radio
            labels:
              1: "Excellent"
              2: "Good"
              3: "Fair"
              4: "Poor"

    # =========================================================================
    # BLOCK 7: HEIGHT AND WEIGHT (HWT) - p.14
    # Self-reported height and weight.
    # =========================================================================
    - id: b_hwt
      title: "Height and Weight"
      items:
        - id: hwt_q01
          kind: Question
          title: "How tall are you without shoes? (in centimetres)"
          precondition:
            - predicate: do_hwt == 1
          input:
            control: Editbox
            min: 91
            max: 213
            right: "cm"

        - id: hwt_q02
          kind: Question
          title: "How much do you weigh? (in kilograms)"
          precondition:
            - predicate: do_hwt == 1
          input:
            control: Editbox
            min: 23
            max: 261
            right: "kg"

    # =========================================================================
    # BLOCK 8: CHRONIC CONDITIONS (CCC) - p.18
    # Large battery of conditions with cascading follow-ups.
    # Key routing: each condition flagged, diabetes triggers DIA block.
    # PDF: CCC_Q011 through CCC_Q361 (36+ conditions)
    # =========================================================================
    - id: b_ccc
      title: "Chronic Conditions"
      items:
        - id: ccc_intro
          kind: Comment
          title: "Now I'd like to ask about certain chronic health conditions which you may have. We are interested in long-term conditions which are expected to last or have already lasted 6 months or more and that have been diagnosed by a health professional."
          precondition:
            - predicate: do_ccc == 1

        - id: ccc_q01_asthma
          kind: Question
          title: "Do you have asthma?"
          precondition:
            - predicate: do_ccc == 1
          codeBlock: |
            has_asthma = ccc_q01_asthma.outcome
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: ccc_q02_fibromyalgia
          kind: Question
          title: "Do you have fibromyalgia?"
          precondition:
            - predicate: do_ccc == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: ccc_q03_arthritis
          kind: Question
          title: "Do you have arthritis or rheumatism, excluding fibromyalgia?"
          precondition:
            - predicate: do_ccc == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: ccc_q04_back_problems
          kind: Question
          title: "Do you have back problems, excluding fibromyalgia and arthritis?"
          precondition:
            - predicate: do_ccc == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: ccc_q05_high_bp
          kind: Question
          title: "Do you have high blood pressure?"
          precondition:
            - predicate: do_ccc == 1
          codeBlock: |
            has_high_bp = ccc_q05_high_bp.outcome
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: ccc_q06_migraine
          kind: Question
          title: "Do you suffer from migraine headaches?"
          precondition:
            - predicate: do_ccc == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: ccc_q07_copd
          kind: Question
          title: "Do you have chronic bronchitis, emphysema or chronic obstructive pulmonary disease (COPD)?"
          precondition:
            - predicate: do_ccc == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: ccc_q08_diabetes
          kind: Question
          title: "Do you have diabetes?"
          precondition:
            - predicate: do_ccc == 1
          codeBlock: |
            has_diabetes = ccc_q08_diabetes.outcome
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: ccc_q09_epilepsy
          kind: Question
          title: "Do you have epilepsy?"
          precondition:
            - predicate: do_ccc == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: ccc_q10_heart_disease
          kind: Question
          title: "Do you have heart disease?"
          precondition:
            - predicate: do_ccc == 1
          codeBlock: |
            has_heart_disease = ccc_q10_heart_disease.outcome
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: ccc_q11_cancer
          kind: Question
          title: "Do you have cancer?"
          precondition:
            - predicate: do_ccc == 1
          codeBlock: |
            has_cancer = ccc_q11_cancer.outcome
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: ccc_q12_ulcers
          kind: Question
          title: "Do you have stomach or intestinal ulcers?"
          precondition:
            - predicate: do_ccc == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: ccc_q13_stroke
          kind: Question
          title: "Have you suffered the effects of a stroke?"
          precondition:
            - predicate: do_ccc == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: ccc_q14_incontinence
          kind: Question
          title: "Do you suffer from urinary incontinence?"
          precondition:
            - predicate: do_ccc == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: ccc_q15_bowel
          kind: Question
          title: "Do you have a bowel disorder such as Crohn's disease or colitis?"
          precondition:
            - predicate: do_ccc == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: ccc_q16_dementia
          kind: Question
          title: "Do you have Alzheimer's disease or any other dementia?"
          precondition:
            - predicate: do_ccc == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: ccc_q17_mood
          kind: Question
          title: "Do you have a mood disorder such as depression, bipolar disorder, mania or dysthymia?"
          precondition:
            - predicate: do_ccc == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: ccc_q18_anxiety
          kind: Question
          title: "Do you have an anxiety disorder such as a phobia, obsessive-compulsive disorder or a panic disorder?"
          precondition:
            - predicate: do_ccc == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: ccc_q19_chronic_fatigue
          kind: Question
          title: "Do you have chronic fatigue syndrome?"
          precondition:
            - predicate: do_ccc == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: ccc_q20_mcs
          kind: Question
          title: "Do you have multiple chemical sensitivities?"
          precondition:
            - predicate: do_ccc == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: ccc_q21_other
          kind: Question
          title: "Do you have any other long-term physical or mental health condition that has been diagnosed by a health professional?"
          precondition:
            - predicate: do_ccc == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # =========================================================================
    # BLOCK 9: DIABETES CARE (DIA) - p.28
    # Only for respondents who reported diabetes in CCC.
    # Complex routing: age gates, insulin use, monitoring frequency.
    # =========================================================================
    - id: b_dia
      title: "Diabetes Care"
      items:
        - id: dia_q01
          kind: Question
          title: "What type of diabetes do you have?"
          precondition:
            - predicate: do_dia == 1 and has_diabetes == 1
          input:
            control: Radio
            labels:
              1: "Type 1"
              2: "Type 2"
              3: "Gestational diabetes"

        - id: dia_q02
          kind: Question
          title: "How old were you when you were first diagnosed with diabetes?"
          precondition:
            - predicate: do_dia == 1 and has_diabetes == 1
          input:
            control: Editbox
            min: 1
            max: 110
            right: "years old"

        - id: dia_q03
          kind: Question
          title: "Do you currently take insulin for your diabetes?"
          precondition:
            - predicate: do_dia == 1 and has_diabetes == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: dia_q04
          kind: Question
          title: "Do you currently take pills for your diabetes?"
          precondition:
            - predicate: do_dia == 1 and has_diabetes == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: dia_q05
          kind: Question
          title: "In the past 12 months, how many times have you seen a doctor, nurse, or other health professional for your diabetes?"
          precondition:
            - predicate: do_dia == 1 and has_diabetes == 1
          input:
            control: Editbox
            min: 0
            max: 366

        - id: dia_q06
          kind: Question
          title: "In the past 12 months, have you had an eye examination by an eye specialist where your pupils were dilated (drops placed in your eyes)?"
          precondition:
            - predicate: do_dia == 1 and has_diabetes == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: dia_q07
          kind: Question
          title: "In the past 12 months, have you had your feet checked for sores or irritations by any health professional?"
          precondition:
            - predicate: do_dia == 1 and has_diabetes == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: dia_q08
          kind: Question
          title: "How often do you test your blood for sugar or glucose? (times per day)"
          precondition:
            - predicate: do_dia == 1 and has_diabetes == 1
          input:
            control: Editbox
            min: 0
            max: 20

    # =========================================================================
    # BLOCK 10: MEDICATION USE (MED) - p.32
    # Battery of medication types. Sex/age gates for birth control, hormones.
    # =========================================================================
    - id: b_med
      title: "Medication Use"
      items:
        - id: med_intro
          kind: Comment
          title: "In the past month, that is from one month ago to yesterday, did you take any of the following medications?"
          precondition:
            - predicate: do_med == 1

        - id: med_q1
          kind: QuestionGroup
          title: "In the past month, did you take:"
          precondition:
            - predicate: do_med == 1
          questions:
            - "Pain relievers such as aspirin or Tylenol (including arthritis medicine and anti-inflammatories)?"
            - "Tranquillizers such as Valium?"
            - "Diet pills?"
            - "Antidepressants?"
            - "Codeine, Demerol or morphine?"
            - "Allergy medicine such as Reactine or Allegra?"
            - "Asthma medications such as inhalers or nebulizers?"
            - "Cough or cold remedies?"
            - "Penicillin or other antibiotics?"
            - "Medicine for the heart?"
            - "Diuretics or water pills?"
            - "Steroids?"
            - "Sleeping pills such as Imovane, Nytol or Starnoc?"
            - "Stomach remedies?"
            - "Laxatives?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: med_q1s
          kind: Question
          title: "In the past month, did you take birth control pills?"
          precondition:
            - predicate: do_med == 1 and sex == 2 and age <= 49
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: med_q1t
          kind: Question
          title: "In the past month, did you take hormones for menopause or ageing symptoms?"
          precondition:
            - predicate: do_med == 1 and sex == 2 and age >= 30
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: med_q1t1
          kind: Question
          title: "What type of hormones are you taking?"
          precondition:
            - predicate: do_med == 1 and sex == 2 and age >= 30 and med_q1t.outcome == 1
          input:
            control: Radio
            labels:
              1: "Estrogen only"
              2: "Progesterone only"
              3: "Both"
              4: "Neither"

        - id: med_q1u
          kind: Question
          title: "In the past month, did you take thyroid medication such as Synthroid or Levothyroxine?"
          precondition:
            - predicate: do_med == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: med_q1v
          kind: Question
          title: "In the past month, did you take any other medication?"
          precondition:
            - predicate: do_med == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # =========================================================================
    # BLOCK 11: HEALTH CARE UTILIZATION (HCU) - p.37
    # Contacts with health professionals, unmet needs.
    # =========================================================================
    - id: b_hcu
      title: "Health Care Utilization"
      items:
        - id: hcu_q01aa
          kind: Question
          title: "Do you have a regular medical doctor?"
          precondition:
            - predicate: do_hcu == 1
          codeBlock: |
            has_regular_doctor = hcu_q01aa.outcome
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: hcu_q01ba
          kind: Question
          title: "In the past 12 months, have you been a patient overnight in a hospital, nursing home or convalescent home?"
          precondition:
            - predicate: do_hcu == 1
          codeBlock: |
            overnight_patient = hcu_q01ba.outcome
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: hcu_q01bb
          kind: Question
          title: "For how many nights in the past 12 months?"
          precondition:
            - predicate: do_hcu == 1 and hcu_q01ba.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 366

        - id: hcu_q02a
          kind: Question
          title: "In the past 12 months, how many times have you seen or talked to a family doctor or general practitioner about your physical, emotional or mental health?"
          precondition:
            - predicate: do_hcu == 1
          input:
            control: Editbox
            min: 0
            max: 366

        - id: hcu_q06
          kind: Question
          title: "During the past 12 months, was there ever a time when you felt that you needed health care but you didn't receive it?"
          precondition:
            - predicate: do_hcu == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: hcu_q08
          kind: Question
          title: "What type of care was needed?"
          precondition:
            - predicate: do_hcu == 1 and hcu_q06.outcome == 1
          input:
            control: Radio
            labels:
              1: "Treatment of a physical health problem"
              2: "Treatment of an emotional or mental health problem"
              3: "A regular check-up"
              4: "Care of an injury"
              5: "Other"

    # =========================================================================
    # BLOCK 12: HOME CARE SERVICES (HMC) - p.46
    # Age gate: 18+
    # =========================================================================
    - id: b_hmc
      title: "Home Care Services"
      items:
        - id: hmc_q09
          kind: Question
          title: "Have you received any home care services in the past 12 months, with the cost being entirely or partially covered by government?"
          precondition:
            - predicate: do_hmc == 1 and age >= 18
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: hmc_q11
          kind: Question
          title: "In the past 12 months, have you received any home care services that were paid entirely by you or through private insurance?"
          precondition:
            - predicate: do_hmc == 1 and age >= 18
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # =========================================================================
    # BLOCK 13: PATIENT SATISFACTION (PAS) - p.51
    # =========================================================================
    - id: b_pas
      title: "Patient Satisfaction"
      items:
        - id: pas_q01
          kind: Question
          title: "Overall, how would you rate the health care you received in the past 12 months?"
          precondition:
            - predicate: do_pas == 1
          input:
            control: Radio
            labels:
              1: "Excellent"
              2: "Very good"
              3: "Good"
              4: "Fair"
              5: "Poor"

    # =========================================================================
    # BLOCK 14: RESTRICTION OF ACTIVITIES (RAC) - p.55
    # =========================================================================
    - id: b_rac
      title: "Restriction of Activities"
      items:
        - id: rac_q01
          kind: Question
          title: "Because of a long-term physical or mental condition or a health problem, are you limited in the kind or amount of activity you can do at home?"
          precondition:
            - predicate: do_rac == 1
          input:
            control: Radio
            labels:
              1: "Sometimes"
              2: "Often"
              3: "Never"

        - id: rac_q02
          kind: Question
          title: "Because of a long-term physical or mental condition or a health problem, are you limited in the kind or amount of activity you can do at school, at work, or in other activities?"
          precondition:
            - predicate: do_rac == 1
          input:
            control: Radio
            labels:
              1: "Sometimes"
              2: "Often"
              3: "Never"

        - id: rac_q03
          kind: Question
          title: "Do you need any help in transportation, preparing meals, or doing everyday housework?"
          precondition:
            - predicate: do_rac == 1
          input:
            control: Radio
            labels:
              1: "Sometimes"
              2: "Often"
              3: "Never"

    # =========================================================================
    # BLOCK 15: TWO-WEEK DISABILITY (TWD) - p.60
    # =========================================================================
    - id: b_twd
      title: "Two-Week Disability"
      items:
        - id: twd_q01
          kind: Question
          title: "During the past 2 weeks, did you stay in bed because of illness or injury? (include nights in hospital)"
          precondition:
            - predicate: do_twd == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: twd_q02
          kind: Question
          title: "How many days did you stay in bed?"
          precondition:
            - predicate: do_twd == 1 and twd_q01.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 14
            right: "days"

    # =========================================================================
    # BLOCK 16: FLU SHOTS (FLU) - p.63
    # =========================================================================
    - id: b_flu
      title: "Flu Shots"
      items:
        - id: flu_q01
          kind: Question
          title: "Have you ever had a flu shot?"
          precondition:
            - predicate: do_flu == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: flu_q02
          kind: Question
          title: "When did you have your last flu shot?"
          precondition:
            - predicate: do_flu == 1 and flu_q01.outcome == 1
          input:
            control: Radio
            labels:
              1: "Less than 1 year ago"
              2: "1 year to less than 2 years ago"
              3: "2 or more years ago"

    # =========================================================================
    # BLOCK 17: BLOOD PRESSURE CHECK (BPC) - p.65
    # =========================================================================
    - id: b_bpc
      title: "Blood Pressure Check"
      items:
        - id: bpc_q01
          kind: Question
          title: "When was the last time you had your blood pressure checked by a health professional?"
          precondition:
            - predicate: do_bpc == 1
          input:
            control: Radio
            labels:
              1: "Less than 1 year ago"
              2: "1 year to less than 2 years ago"
              3: "2 years to less than 5 years ago"
              4: "5 or more years ago"
              5: "Never"

    # =========================================================================
    # BLOCK 18: PAP SMEAR TEST (PAP) - p.67
    # Sex gate: females only. Age gate: 18+.
    # =========================================================================
    - id: b_pap
      title: "Pap Smear Test"
      items:
        - id: pap_q01
          kind: Question
          title: "Have you ever had a Pap smear test?"
          precondition:
            - predicate: do_pap == 1 and sex == 2 and age >= 18
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: pap_q02
          kind: Question
          title: "When was the last time you had a Pap smear test?"
          precondition:
            - predicate: do_pap == 1 and sex == 2 and age >= 18 and pap_q01.outcome == 1
          input:
            control: Radio
            labels:
              1: "Less than 6 months ago"
              2: "6 months to less than 1 year ago"
              3: "1 year to less than 2 years ago"
              4: "2 years to less than 3 years ago"
              5: "3 years to less than 5 years ago"
              6: "5 or more years ago"

    # =========================================================================
    # BLOCK 19: MAMMOGRAPHY (MAM) - p.69
    # Sex gate: females. Age gate: 35+.
    # =========================================================================
    - id: b_mam
      title: "Mammography"
      items:
        - id: mam_q01
          kind: Question
          title: "Have you ever had a mammogram, that is, a breast x-ray?"
          precondition:
            - predicate: do_mam == 1 and sex == 2 and age >= 35
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: mam_q02
          kind: Question
          title: "When was the last time?"
          precondition:
            - predicate: do_mam == 1 and sex == 2 and age >= 35 and mam_q01.outcome == 1
          input:
            control: Radio
            labels:
              1: "Less than 1 year ago"
              2: "1 year to less than 2 years ago"
              3: "2 years to less than 5 years ago"
              4: "5 or more years ago"

    # =========================================================================
    # BLOCK 20: PROSTATE CANCER SCREENING (PSA) - p.79
    # Sex gate: males. Age gate: 40+.
    # =========================================================================
    - id: b_psa
      title: "Prostate Cancer Screening"
      items:
        - id: psa_q01
          kind: Question
          title: "Have you ever had a PSA blood test to check for prostate cancer?"
          precondition:
            - predicate: do_psa == 1 and sex == 1 and age >= 40
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: psa_q02
          kind: Question
          title: "When was the last time?"
          precondition:
            - predicate: do_psa == 1 and sex == 1 and age >= 40 and psa_q01.outcome == 1
          input:
            control: Radio
            labels:
              1: "Less than 1 year ago"
              2: "1 year to less than 2 years ago"
              3: "2 or more years ago"

    # =========================================================================
    # BLOCK 21: COLORECTAL CANCER SCREENING (CCS) - p.81
    # Age gate: 50+
    # =========================================================================
    - id: b_ccs
      title: "Colorectal Cancer Screening"
      items:
        - id: ccs_q01
          kind: Question
          title: "Have you ever had a FOBT (fecal occult blood test) to check for colorectal cancer?"
          precondition:
            - predicate: do_ccs == 1 and age >= 50
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: ccs_q02
          kind: Question
          title: "Have you ever had a colonoscopy or sigmoidoscopy?"
          precondition:
            - predicate: do_ccs == 1 and age >= 50
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # =========================================================================
    # BLOCK 22: DENTAL VISITS (DEN) - p.84
    # =========================================================================
    - id: b_den
      title: "Dental Visits"
      items:
        - id: den_q01
          kind: Question
          title: "When did you last see a dentist?"
          precondition:
            - predicate: do_den == 1
          input:
            control: Radio
            labels:
              1: "Less than 1 year ago"
              2: "1 year to less than 2 years ago"
              3: "2 years to less than 3 years ago"
              4: "3 years to less than 5 years ago"
              5: "5 or more years ago"
              6: "Never"

        - id: den_q02
          kind: Question
          title: "Do you have dental insurance that covers all or part of your dental expenses?"
          precondition:
            - predicate: do_den == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # =========================================================================
    # BLOCK 23: FRUIT AND VEGETABLE CONSUMPTION (FVC) - p.93
    # =========================================================================
    - id: b_fvc
      title: "Fruit and Vegetable Consumption"
      items:
        - id: fvc_q01
          kind: Question
          title: "How many times per day do you usually drink fruit juice?"
          precondition:
            - predicate: do_fvc == 1
          input:
            control: Editbox
            min: 0
            max: 20

        - id: fvc_q02
          kind: Question
          title: "Not counting juice, how many times per day do you usually eat fruit?"
          precondition:
            - predicate: do_fvc == 1
          input:
            control: Editbox
            min: 0
            max: 20

        - id: fvc_q03
          kind: Question
          title: "How many times per day do you usually eat green salad?"
          precondition:
            - predicate: do_fvc == 1
          input:
            control: Editbox
            min: 0
            max: 20

        - id: fvc_q04
          kind: Question
          title: "How many times per day do you usually eat potatoes (not including french fries, fried potatoes or chips)?"
          precondition:
            - predicate: do_fvc == 1
          input:
            control: Editbox
            min: 0
            max: 20

        - id: fvc_q05
          kind: Question
          title: "How many times per day do you usually eat carrots?"
          precondition:
            - predicate: do_fvc == 1
          input:
            control: Editbox
            min: 0
            max: 20

        - id: fvc_q06
          kind: Question
          title: "Not counting carrots, potatoes, or salad, how many times per day do you usually eat other vegetables?"
          precondition:
            - predicate: do_fvc == 1
          input:
            control: Editbox
            min: 0
            max: 20

    # =========================================================================
    # BLOCK 24: PHYSICAL ACTIVITY (PAC) - p.99
    # =========================================================================
    - id: b_pac
      title: "Physical Activity"
      items:
        - id: pac_q01
          kind: Question
          title: "In the past 3 months, did you do any physical activity or exercise?"
          precondition:
            - predicate: do_pac == 1 and age >= 12
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: pac_q02
          kind: Question
          title: "In the past 3 months, how many times did you walk for exercise?"
          precondition:
            - predicate: do_pac == 1 and age >= 12 and pac_q01.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 365

        - id: pac_q03
          kind: Question
          title: "How much time did you spend on each occasion?"
          precondition:
            - predicate: do_pac == 1 and age >= 12 and pac_q01.outcome == 1 and pac_q02.outcome > 0
          input:
            control: Editbox
            min: 1
            max: 480
            right: "minutes"

    # =========================================================================
    # BLOCK 25: SMOKING (SMK) - p.110
    # Complex multi-stage routing: current status, former smoker detail,
    # age started, amount smoked. Feeds into NDE, SCA, SPC, YSM, ETS.
    # =========================================================================
    - id: b_smk
      title: "Smoking"
      items:
        - id: smk_q01
          kind: Question
          title: "At the present time, do you smoke cigarettes daily, occasionally or not at all?"
          precondition:
            - predicate: do_smk == 1
          codeBlock: |
            if smk_q01.outcome == 1:
                smk_status = 1
                smk_daily = 1
            elif smk_q01.outcome == 2:
                smk_status = 2
                smk_occasional = 1
            else:
                smk_status = 3
          input:
            control: Radio
            labels:
              1: "Daily"
              2: "Occasionally"
              3: "Not at all"

        - id: smk_q02
          kind: Question
          title: "Have you ever smoked cigarettes daily?"
          precondition:
            - predicate: do_smk == 1 and smk_q01.outcome == 2
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: smk_q03
          kind: Question
          title: "Have you smoked at least 100 cigarettes in your life?"
          precondition:
            - predicate: do_smk == 1 and smk_q01.outcome == 3
          codeBlock: |
            if smk_q03.outcome == 1:
                smk_former = 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: smk_q04
          kind: Question
          title: "Have you ever smoked cigarettes daily?"
          precondition:
            - predicate: do_smk == 1 and smk_q01.outcome == 3 and smk_q03.outcome == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: smk_q05
          kind: Question
          title: "How many cigarettes do you smoke each day now?"
          precondition:
            - predicate: do_smk == 1 and smk_daily == 1
          input:
            control: Editbox
            min: 1
            max: 99

        - id: smk_q06
          kind: Question
          title: "At what age did you begin smoking cigarettes daily?"
          precondition:
            - predicate: do_smk == 1 and smk_daily == 1
          input:
            control: Editbox
            min: 5
            max: 110

        - id: smk_q07
          kind: Question
          title: "On the days that you do smoke, about how many cigarettes do you usually have?"
          precondition:
            - predicate: do_smk == 1 and smk_occasional == 1
          input:
            control: Editbox
            min: 1
            max: 99

    # =========================================================================
    # BLOCK 26: ALCOHOL USE (ALC) - p.126
    # Routing: drinker/non-drinker, frequency, binge drinking, age started.
    # Age < 19 gets ALC_Q8 (age started drinking).
    # =========================================================================
    - id: b_alc
      title: "Alcohol Use"
      items:
        - id: alc_q1
          kind: Question
          title: "During the past 12 months, have you had a drink of beer, wine, liquor or any other alcoholic beverage?"
          precondition:
            - predicate: do_alc == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: alc_q2
          kind: Question
          title: "During the past 12 months, how often did you drink alcoholic beverages?"
          precondition:
            - predicate: do_alc == 1 and alc_q1.outcome == 1
          input:
            control: Radio
            labels:
              1: "Less than once a month"
              2: "Once a month"
              3: "2 to 3 times a month"
              4: "Once a week"
              5: "2 to 3 times a week"
              6: "4 to 6 times a week"
              7: "Every day"

        - id: alc_q3
          kind: Question
          title: "How often in the past 12 months have you had 5 or more drinks on one occasion?"
          precondition:
            - predicate: do_alc == 1 and alc_q1.outcome == 1
          input:
            control: Radio
            labels:
              1: "Never"
              2: "Less than once a month"
              3: "Once a month"
              4: "2 to 3 times a month"
              5: "Once a week"
              6: "More than once a week"

        - id: alc_q5b
          kind: Question
          title: "Have you ever had a drink?"
          precondition:
            - predicate: do_alc == 1 and alc_q1.outcome == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: alc_q6
          kind: Question
          title: "Did you ever regularly drink more than 12 drinks a week?"
          precondition:
            - predicate: do_alc == 1 and alc_q5b.outcome == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: alc_q8
          kind: Question
          title: "How old were you when you first started drinking alcoholic beverages?"
          precondition:
            - predicate: do_alc == 1 and age <= 19
          input:
            control: Editbox
            min: 5
            max: 19

    # =========================================================================
    # BLOCK 27: MATERNAL EXPERIENCES (MEX) - p.129
    # Sex gate: female. Age gate: 15-55. Not proxy.
    # Complex routing: birth -> breastfeeding -> smoking during pregnancy.
    # =========================================================================
    - id: b_mex
      title: "Maternal Experiences"
      items:
        - id: mex_q01
          kind: Question
          title: "Have you given birth in the past 5 years?"
          precondition:
            - predicate: do_mex == 1 and sex == 2 and age >= 15 and age <= 55 and is_proxy == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: mex_q02
          kind: Question
          title: "Did you take a vitamin supplement containing folic acid before your last pregnancy?"
          precondition:
            - predicate: do_mex == 1 and sex == 2 and age >= 15 and age <= 55 and is_proxy == 0 and mex_q01.outcome == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: mex_q03
          kind: Question
          title: "For your last baby, did you breastfeed or try to breastfeed?"
          precondition:
            - predicate: do_mex == 1 and sex == 2 and age >= 15 and age <= 55 and is_proxy == 0 and mex_q01.outcome == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: mex_q05
          kind: Question
          title: "Are you still breastfeeding?"
          precondition:
            - predicate: do_mex == 1 and sex == 2 and age >= 15 and age <= 55 and is_proxy == 0 and mex_q01.outcome == 1 and mex_q03.outcome == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: mex_q06
          kind: Question
          title: "How long did you breastfeed your last baby?"
          precondition:
            - predicate: do_mex == 1 and sex == 2 and age >= 15 and age <= 55 and is_proxy == 0 and mex_q01.outcome == 1 and mex_q03.outcome == 1 and mex_q05.outcome == 0
          input:
            control: Dropdown
            labels:
              1: "Less than 1 week"
              2: "1 to 2 weeks"
              3: "3 to 4 weeks"
              4: "5 to 8 weeks"
              5: "9 weeks to less than 12 weeks"
              6: "3 months"
              7: "4 months"
              8: "5 months"
              9: "6 months"
              10: "7 to 9 months"
              11: "10 to 12 months"
              12: "More than 1 year"

        - id: mex_q26
          kind: Question
          title: "Did anyone regularly smoke in your presence during or after the pregnancy (about 6 months after)?"
          precondition:
            - predicate: do_mex == 1 and sex == 2 and age >= 15 and age <= 55 and is_proxy == 0 and mex_q01.outcome == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # =========================================================================
    # BLOCK 28: ILLICIT DRUGS (IDG) - p.135
    # Not proxy. Progressive disclosure per substance.
    # =========================================================================
    - id: b_drg
      title: "Illicit Drugs"
      items:
        - id: drg_q01
          kind: Question
          title: "Have you ever used or tried marijuana, cannabis or hashish?"
          precondition:
            - predicate: do_drg == 1 and is_proxy == 0
          input:
            control: Radio
            labels:
              1: "Yes, just once"
              2: "Yes, more than once"
              3: "No"

        - id: drg_q02
          kind: Question
          title: "Have you used it in the past 12 months?"
          precondition:
            - predicate: do_drg == 1 and is_proxy == 0 and drg_q01.outcome != 3
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: drg_q04
          kind: Question
          title: "Have you ever used or tried cocaine or crack?"
          precondition:
            - predicate: do_drg == 1 and is_proxy == 0
          input:
            control: Radio
            labels:
              1: "Yes, just once"
              2: "Yes, more than once"
              3: "No"

        - id: drg_q07
          kind: Question
          title: "Have you ever used or tried speed (amphetamines)?"
          precondition:
            - predicate: do_drg == 1 and is_proxy == 0
          input:
            control: Radio
            labels:
              1: "Yes, just once"
              2: "Yes, more than once"
              3: "No"

        - id: drg_q10
          kind: Question
          title: "Have you ever used or tried ecstasy (MDMA) or other similar drugs?"
          precondition:
            - predicate: do_drg == 1 and is_proxy == 0
          input:
            control: Radio
            labels:
              1: "Yes, just once"
              2: "Yes, more than once"
              3: "No"

        - id: drg_q13
          kind: Question
          title: "Have you ever used or tried hallucinogens, PCP or LSD?"
          precondition:
            - predicate: do_drg == 1 and is_proxy == 0
          input:
            control: Radio
            labels:
              1: "Yes, just once"
              2: "Yes, more than once"
              3: "No"

        - id: drg_q16
          kind: Question
          title: "Have you ever used or tried heroin?"
          precondition:
            - predicate: do_drg == 1 and is_proxy == 0
          input:
            control: Radio
            labels:
              1: "Yes, just once"
              2: "Yes, more than once"
              3: "No"

        - id: drg_q19
          kind: Question
          title: "Have you ever sniffed glue, gasoline or other solvents?"
          precondition:
            - predicate: do_drg == 1 and is_proxy == 0
          input:
            control: Radio
            labels:
              1: "Yes, just once"
              2: "Yes, more than once"
              3: "No"

        - id: drg_q22
          kind: Question
          title: "Have you ever used any drugs by injection (non-medical, excluding steroids)?"
          precondition:
            - predicate: do_drg == 1 and is_proxy == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: drg_q23
          kind: Question
          title: "Have you ever used anabolic steroids without a prescription?"
          precondition:
            - predicate: do_drg == 1 and is_proxy == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # =========================================================================
    # BLOCK 29: STRESS SOURCES (STS) - p.156
    # =========================================================================
    - id: b_sts
      title: "Stress Sources"
      items:
        - id: sts_q01
          kind: Question
          title: "Thinking about the amount of stress in your life, would you say that most days are:"
          precondition:
            - predicate: do_sts == 1 and age >= 15
          input:
            control: Radio
            labels:
              1: "Not at all stressful"
              2: "Not very stressful"
              3: "A bit stressful"
              4: "Quite a bit stressful"
              5: "Extremely stressful"

    # =========================================================================
    # BLOCK 30: SOCIAL SUPPORT - AVAILABILITY (SSA) - p.168
    # =========================================================================
    - id: b_ssa
      title: "Social Support - Availability"
      items:
        - id: ssa_q01
          kind: QuestionGroup
          title: "How often is each of the following kinds of support available to you if you need it?"
          precondition:
            - predicate: do_ssa == 1 and age >= 15
          questions:
            - "Someone to help you if you were confined to bed"
            - "Someone you can count on to listen to you when you need to talk"
            - "Someone to give you advice about a crisis"
            - "Someone to take you to the doctor if you needed it"
            - "Someone who shows you love and affection"
            - "Someone to have a good time with"
            - "Someone to give you information to help you understand a situation"
            - "Someone to confide in or talk to about yourself or your problems"
          input:
            control: Radio
            labels:
              1: "None of the time"
              2: "A little of the time"
              3: "Some of the time"
              4: "Most of the time"
              5: "All of the time"

    # =========================================================================
    # BLOCK 31: DISTRESS (DIS) - p.181
    # K6 scale, non-proxy.
    # =========================================================================
    - id: b_dis
      title: "Distress"
      items:
        - id: dis_intro
          kind: Comment
          title: "During the past month, about how often did you feel..."
          precondition:
            - predicate: do_dis == 1 and is_proxy == 0

        - id: dis_q01
          kind: QuestionGroup
          title: "During the past month, about how often did you feel:"
          precondition:
            - predicate: do_dis == 1 and is_proxy == 0
          questions:
            - "Nervous?"
            - "Hopeless?"
            - "Restless or fidgety?"
            - "So depressed that nothing could cheer you up?"
            - "That everything was an effort?"
            - "Worthless?"
          input:
            control: Radio
            labels:
              1: "All of the time"
              2: "Most of the time"
              3: "Some of the time"
              4: "A little of the time"
              5: "None of the time"

    # =========================================================================
    # BLOCK 32: DEPRESSION (DPS) - p.185
    # CIDI-SF Short Form. Complex dual-pathway structure.
    # Two independent screening paths: sadness (Q02-Q15) and loss of
    # interest (Q16-Q28). Each path has severity gates.
    # KEY ROUTING ISSUE: DEP_C14 checks if ANY symptom from either path
    # was endorsed, creating a cross-reference between paths.
    # =========================================================================
    - id: b_dep
      title: "Depression (CIDI-SF)"
      items:
        - id: dep_q02
          kind: Question
          title: "During the past 12 months, was there ever a time when you felt sad, blue, or depressed for 2 weeks or more in a row?"
          precondition:
            - predicate: do_dep == 1 and is_proxy == 0
          codeBlock: |
            dep_sad_2wks = dep_q02.outcome
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # Sadness pathway: duration gate
        - id: dep_q03
          kind: Question
          title: "How long did these feelings usually last?"
          precondition:
            - predicate: do_dep == 1 and is_proxy == 0 and dep_sad_2wks == 1
          input:
            control: Radio
            labels:
              1: "All day long"
              2: "Most of the day"
              3: "About half of the day"
              4: "Less than half of a day"

        # Frequency gate (only if duration >= half day)
        - id: dep_q04
          kind: Question
          title: "How often did you feel this way during those 2 weeks?"
          precondition:
            - predicate: do_dep == 1 and is_proxy == 0 and dep_sad_2wks == 1 and dep_q03.outcome <= 2
          input:
            control: Radio
            labels:
              1: "Every day"
              2: "Almost every day"
              3: "Less often"

        # Symptom battery (only if frequent + prolonged sadness)
        - id: dep_q05
          kind: Question
          title: "During those 2 weeks, did you lose interest in most things?"
          precondition:
            - predicate: do_dep == 1 and is_proxy == 0 and dep_sad_2wks == 1 and dep_q03.outcome <= 2 and dep_q04.outcome <= 2
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: dep_q06
          kind: Question
          title: "Did you feel tired out or low on energy all of the time?"
          precondition:
            - predicate: do_dep == 1 and is_proxy == 0 and dep_sad_2wks == 1 and dep_q03.outcome <= 2 and dep_q04.outcome <= 2
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: dep_q07
          kind: Question
          title: "Did you gain weight, lose weight, or stay about the same?"
          precondition:
            - predicate: do_dep == 1 and is_proxy == 0 and dep_sad_2wks == 1 and dep_q03.outcome <= 2 and dep_q04.outcome <= 2
          input:
            control: Radio
            labels:
              1: "Gained weight"
              2: "Lost weight"
              3: "Stayed about the same"
              4: "Was on a diet"

        - id: dep_q09
          kind: Question
          title: "Did you have more trouble falling asleep than you usually do?"
          precondition:
            - predicate: do_dep == 1 and is_proxy == 0 and dep_sad_2wks == 1 and dep_q03.outcome <= 2 and dep_q04.outcome <= 2
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: dep_q11
          kind: Question
          title: "Did you have a lot more trouble concentrating than usual?"
          precondition:
            - predicate: do_dep == 1 and is_proxy == 0 and dep_sad_2wks == 1 and dep_q03.outcome <= 2 and dep_q04.outcome <= 2
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: dep_q12
          kind: Question
          title: "Did you feel down on yourself, no good, or worthless?"
          precondition:
            - predicate: do_dep == 1 and is_proxy == 0 and dep_sad_2wks == 1 and dep_q03.outcome <= 2 and dep_q04.outcome <= 2
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: dep_q13
          kind: Question
          title: "Did you think a lot about death - either your own, someone else's, or death in general?"
          precondition:
            - predicate: do_dep == 1 and is_proxy == 0 and dep_sad_2wks == 1 and dep_q03.outcome <= 2 and dep_q04.outcome <= 2
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # DEP_C14 symptom count gate: if any symptom endorsed, continue to duration
        - id: dep_q14
          kind: Question
          title: "About how many weeks altogether did you feel this way during the past 12 months?"
          precondition:
            - predicate: do_dep == 1 and is_proxy == 0 and dep_sad_2wks == 1 and dep_q03.outcome <= 2 and dep_q04.outcome <= 2
          postcondition:
            - predicate: dep_q14.outcome >= 2 and dep_q14.outcome <= 52
              hint: "Weeks must be between 2 and 52"
          input:
            control: Editbox
            min: 2
            max: 53

        - id: dep_q15
          kind: Question
          title: "In what month was the last time you felt this way for 2 weeks or more?"
          precondition:
            - predicate: do_dep == 1 and is_proxy == 0 and dep_sad_2wks == 1 and dep_q03.outcome <= 2 and dep_q04.outcome <= 2
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

        # Loss of interest pathway (Q16)
        - id: dep_q16
          kind: Question
          title: "During the past 12 months, was there ever a time lasting 2 weeks or more when you lost interest in most things like hobbies, work, or activities that usually give you pleasure?"
          precondition:
            - predicate: do_dep == 1 and is_proxy == 0
          codeBlock: |
            dep_interest_2wks = dep_q16.outcome
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: dep_q17
          kind: Question
          title: "How long did the loss of interest usually last?"
          precondition:
            - predicate: do_dep == 1 and is_proxy == 0 and dep_interest_2wks == 1
          input:
            control: Radio
            labels:
              1: "All day long"
              2: "Most of the day"
              3: "About half of the day"
              4: "Less than half of a day"

        - id: dep_q18
          kind: Question
          title: "How often did you feel this way during those 2 weeks?"
          precondition:
            - predicate: do_dep == 1 and is_proxy == 0 and dep_interest_2wks == 1 and dep_q17.outcome <= 2
          input:
            control: Radio
            labels:
              1: "Every day"
              2: "Almost every day"
              3: "Less often"

        # Symptom battery for interest pathway
        - id: dep_q19
          kind: Question
          title: "During those 2 weeks did you feel tired out or low on energy all the time?"
          precondition:
            - predicate: do_dep == 1 and is_proxy == 0 and dep_interest_2wks == 1 and dep_q17.outcome <= 2 and dep_q18.outcome <= 2
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: dep_q20
          kind: Question
          title: "Did you gain weight, lose weight, or stay about the same?"
          precondition:
            - predicate: do_dep == 1 and is_proxy == 0 and dep_interest_2wks == 1 and dep_q17.outcome <= 2 and dep_q18.outcome <= 2
          input:
            control: Radio
            labels:
              1: "Gained weight"
              2: "Lost weight"
              3: "Stayed about the same"
              4: "Was on a diet"

        - id: dep_q22
          kind: Question
          title: "Did you have more trouble falling asleep than you usually do?"
          precondition:
            - predicate: do_dep == 1 and is_proxy == 0 and dep_interest_2wks == 1 and dep_q17.outcome <= 2 and dep_q18.outcome <= 2
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: dep_q24
          kind: Question
          title: "Did you have a lot more trouble concentrating than usual?"
          precondition:
            - predicate: do_dep == 1 and is_proxy == 0 and dep_interest_2wks == 1 and dep_q17.outcome <= 2 and dep_q18.outcome <= 2
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: dep_q25
          kind: Question
          title: "Did you feel down on yourself, no good, or worthless?"
          precondition:
            - predicate: do_dep == 1 and is_proxy == 0 and dep_interest_2wks == 1 and dep_q17.outcome <= 2 and dep_q18.outcome <= 2
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: dep_q26
          kind: Question
          title: "Did you think a lot about death?"
          precondition:
            - predicate: do_dep == 1 and is_proxy == 0 and dep_interest_2wks == 1 and dep_q17.outcome <= 2 and dep_q18.outcome <= 2
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: dep_q27
          kind: Question
          title: "About how many weeks did you feel this way during the past 12 months?"
          precondition:
            - predicate: do_dep == 1 and is_proxy == 0 and dep_interest_2wks == 1 and dep_q17.outcome <= 2 and dep_q18.outcome <= 2
          input:
            control: Editbox
            min: 2
            max: 53

        - id: dep_q28
          kind: Question
          title: "In what month was the last time you felt this way?"
          precondition:
            - predicate: do_dep == 1 and is_proxy == 0 and dep_interest_2wks == 1 and dep_q17.outcome <= 2 and dep_q18.outcome <= 2
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
    # BLOCK 33: SUICIDAL THOUGHTS AND ATTEMPTS (SUI) - p.191
    # Not proxy. Age >= 15. Sensitive topic.
    # =========================================================================
    - id: b_sui
      title: "Suicidal Thoughts and Attempts"
      items:
        - id: sui_q1
          kind: Question
          title: "Have you ever seriously considered committing suicide or taking your own life?"
          precondition:
            - predicate: do_sui == 1 and is_proxy == 0 and age >= 15
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: sui_q2
          kind: Question
          title: "Has this happened in the past 12 months?"
          precondition:
            - predicate: do_sui == 1 and is_proxy == 0 and age >= 15 and sui_q1.outcome == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: sui_q3
          kind: Question
          title: "Have you ever attempted to commit suicide or tried taking your own life?"
          precondition:
            - predicate: do_sui == 1 and is_proxy == 0 and age >= 15 and sui_q1.outcome == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: sui_q4
          kind: Question
          title: "Did this happen in the past 12 months?"
          precondition:
            - predicate: do_sui == 1 and is_proxy == 0 and age >= 15 and sui_q1.outcome == 1 and sui_q3.outcome == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: sui_q5
          kind: Question
          title: "Did you see, or talk on the telephone, to a health professional following your attempt to commit suicide?"
          precondition:
            - predicate: do_sui == 1 and is_proxy == 0 and age >= 15 and sui_q1.outcome == 1 and sui_q3.outcome == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # =========================================================================
    # BLOCK 34: INJURIES (INJ/REP) - p.193
    # Two sub-sections: repetitive strain then other injuries.
    # Body part routing, fall causation chain, treatment cascade.
    # =========================================================================
    - id: b_inj
      title: "Injuries"
      items:
        # Repetitive strain section
        - id: rep_q01
          kind: Question
          title: "In the past 12 months, did you have any injuries due to repetitive strain which were serious enough to limit your normal activities?"
          precondition:
            - predicate: do_inj == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: rep_q03
          kind: Question
          title: "What part of the body was most affected by the repetitive strain?"
          precondition:
            - predicate: do_inj == 1 and rep_q01.outcome == 1
          input:
            control: Dropdown
            labels:
              1: "Head"
              2: "Neck"
              3: "Shoulder, upper arm"
              4: "Elbow, lower arm"
              5: "Wrist"
              6: "Hand"
              7: "Hip"
              8: "Thigh"
              9: "Knee, lower leg"
              10: "Ankle, foot"
              11: "Upper back or upper spine"
              12: "Lower back or lower spine"
              13: "Chest"
              14: "Abdomen or pelvis"

        # Other injuries section
        - id: inj_q01
          kind: Question
          title: "Not counting repetitive strain injuries, in the past 12 months, were you injured?"
          precondition:
            - predicate: do_inj == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: inj_q02
          kind: Question
          title: "How many times were you injured?"
          precondition:
            - predicate: do_inj == 1 and inj_q01.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 30

        - id: inj_q05
          kind: Question
          title: "What type of injury did you have? (most serious)"
          precondition:
            - predicate: do_inj == 1 and inj_q01.outcome == 1
          input:
            control: Dropdown
            labels:
              1: "Multiple injuries"
              2: "Broken or fractured bones"
              3: "Burn, scald, chemical burn"
              4: "Dislocation"
              5: "Sprain or strain"
              6: "Cut, puncture, animal or human bite"
              7: "Scrape, bruise, blister"
              8: "Concussion or other brain injury"
              9: "Poisoning"
              10: "Injury to internal organs"
              11: "Other"

        - id: inj_q06
          kind: Question
          title: "What part of the body was injured?"
          precondition:
            - predicate: do_inj == 1 and inj_q01.outcome == 1
          input:
            control: Dropdown
            labels:
              1: "Multiple sites"
              2: "Eyes"
              3: "Head (excluding eyes)"
              4: "Neck"
              5: "Shoulder, upper arm"
              6: "Elbow, lower arm"
              7: "Wrist"
              8: "Hand"
              9: "Hip"
              10: "Thigh"
              11: "Knee, lower leg"
              12: "Ankle, foot"
              13: "Upper back or upper spine"
              14: "Lower back or lower spine"
              15: "Chest"
              16: "Abdomen or pelvis"

        - id: inj_q10
          kind: Question
          title: "Was the injury the result of a fall?"
          precondition:
            - predicate: do_inj == 1 and inj_q01.outcome == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: inj_q11
          kind: Question
          title: "How did you fall?"
          precondition:
            - predicate: do_inj == 1 and inj_q01.outcome == 1 and inj_q10.outcome == 1
          input:
            control: Dropdown
            labels:
              1: "While skating, skiing, snowboarding"
              2: "Going up or down stairs/steps"
              3: "Slip, trip or stumble on ice or snow"
              4: "Slip, trip or stumble on any other surface"
              5: "From furniture"
              6: "From elevated position (ladder, tree)"
              7: "Other"

        - id: inj_q12
          kind: Question
          title: "What caused the injury?"
          precondition:
            - predicate: do_inj == 1 and inj_q01.outcome == 1 and inj_q10.outcome == 0
          input:
            control: Dropdown
            labels:
              1: "Transportation accident"
              2: "Accidentally bumped, pushed, bitten by person or animal"
              3: "Accidentally struck or crushed by object(s)"
              4: "Accidental contact with sharp object, tool or machine"
              5: "Smoke, fire, flames"
              6: "Accidental contact with hot object, liquid or gas"
              7: "Extreme weather or natural disaster"
              8: "Overexertion or strenuous movement"
              9: "Physical assault"
              10: "Other"

        - id: inj_q13
          kind: Question
          title: "Did you receive any medical attention for the injury from a health professional in the 48 hours following the injury?"
          precondition:
            - predicate: do_inj == 1 and inj_q01.outcome == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: inj_q15
          kind: Question
          title: "Were you admitted to a hospital overnight?"
          precondition:
            - predicate: do_inj == 1 and inj_q01.outcome == 1 and inj_q13.outcome == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # =========================================================================
    # BLOCK 35: HEALTH UTILITY INDEX (HUI) - p.201
    # Optional module (subsample). Cascading vision/hearing/mobility/dexterity.
    # Complex skip patterns within each functional domain.
    # =========================================================================
    - id: b_hui
      title: "Health Utility Index"
      items:
        # VISION cascade
        - id: hui_q01
          kind: Question
          title: "Are you usually able to see well enough to read ordinary newsprint without glasses or contact lenses?"
          precondition:
            - predicate: do_hui == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: hui_q02
          kind: Question
          title: "Are you usually able to see well enough to read ordinary newsprint with glasses or contact lenses?"
          precondition:
            - predicate: do_hui == 1 and hui_q01.outcome == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: hui_q03
          kind: Question
          title: "Are you able to see at all?"
          precondition:
            - predicate: do_hui == 1 and hui_q01.outcome == 0 and hui_q02.outcome == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: hui_q04
          kind: Question
          title: "Are you able to see well enough to recognize a friend on the other side of the street without glasses or contact lenses?"
          precondition:
            - predicate: do_hui == 1 and hui_q01.outcome == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: hui_q05
          kind: Question
          title: "Are you usually able to see well enough to recognize a friend on the other side of the street with glasses or contact lenses?"
          precondition:
            - predicate: do_hui == 1 and hui_q01.outcome == 1 and hui_q04.outcome == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # HEARING cascade
        - id: hui_q06
          kind: Question
          title: "Are you usually able to hear what is said in a group conversation with at least 3 other people without a hearing aid?"
          precondition:
            - predicate: do_hui == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: hui_q08
          kind: Question
          title: "Are you usually able to hear what is said in a conversation with one other person in a quiet room without a hearing aid?"
          precondition:
            - predicate: do_hui == 1 and hui_q06.outcome == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # SPEECH
        - id: hui_q10
          kind: Question
          title: "Are you usually able to be understood completely when speaking with strangers in your own language?"
          precondition:
            - predicate: do_hui == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: hui_q11
          kind: Question
          title: "Are you able to be understood partially when speaking with strangers?"
          precondition:
            - predicate: do_hui == 1 and hui_q10.outcome == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # GETTING AROUND (MOBILITY) cascade
        - id: hui_q14
          kind: Question
          title: "Are you usually able to walk around the neighbourhood without difficulty and without mechanical support such as braces, a cane or crutches?"
          precondition:
            - predicate: do_hui == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: hui_q15
          kind: Question
          title: "Are you able to walk at all?"
          precondition:
            - predicate: do_hui == 1 and hui_q14.outcome == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: hui_q18
          kind: Question
          title: "Do you require a wheelchair to get around?"
          precondition:
            - predicate: do_hui == 1 and hui_q14.outcome == 0 and hui_q15.outcome == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # DEXTERITY
        - id: hui_q21
          kind: Question
          title: "Are you usually able to grasp and handle small objects such as a pencil or scissors?"
          precondition:
            - predicate: do_hui == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # FEELINGS
        - id: hui_q25
          kind: Question
          title: "Would you describe yourself as being usually:"
          precondition:
            - predicate: do_hui == 1
          input:
            control: Radio
            labels:
              1: "Happy and interested in life"
              2: "Somewhat happy"
              3: "Somewhat unhappy"
              4: "Unhappy with little interest in life"
              5: "So unhappy that life is not worthwhile"

        # MEMORY
        - id: hui_q26
          kind: Question
          title: "How would you describe your usual ability to remember things?"
          precondition:
            - predicate: do_hui == 1
          input:
            control: Radio
            labels:
              1: "Able to remember most things"
              2: "Somewhat forgetful"
              3: "Very forgetful"
              4: "Unable to remember anything at all"

        # THINKING
        - id: hui_q27
          kind: Question
          title: "How would you describe your usual ability to think and solve day-to-day problems?"
          precondition:
            - predicate: do_hui == 1
          input:
            control: Radio
            labels:
              1: "Able to think clearly and solve problems"
              2: "Having a little difficulty"
              3: "Having some difficulty"
              4: "Having a great deal of difficulty"
              5: "Unable to think or solve problems"

        # PAIN AND DISCOMFORT
        - id: hui_q28
          kind: Question
          title: "Are you usually free of pain or discomfort?"
          precondition:
            - predicate: do_hui == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: hui_q29
          kind: Question
          title: "How would you describe the usual intensity of your pain or discomfort?"
          precondition:
            - predicate: do_hui == 1 and hui_q28.outcome == 0
          input:
            control: Radio
            labels:
              1: "Mild"
              2: "Moderate"
              3: "Severe"

        - id: hui_q30
          kind: Question
          title: "How many activities does your pain or discomfort prevent?"
          precondition:
            - predicate: do_hui == 1 and hui_q28.outcome == 0
          input:
            control: Radio
            labels:
              1: "None"
              2: "A few"
              3: "Some"
              4: "Most"

    # =========================================================================
    # BLOCK 36: HEALTH STATUS SF-36 (SFR) - p.207
    # Standard SF-36 battery. Optional module.
    # =========================================================================
    - id: b_sfr
      title: "Health Status - SF-36"
      items:
        - id: sfr_q03
          kind: QuestionGroup
          title: "Does your health limit you in any of the following activities?"
          precondition:
            - predicate: do_sfr == 1
          questions:
            - "Vigorous activities, such as running, lifting heavy objects"
            - "Moderate activities, such as moving a table, bowling"
            - "Lifting or carrying groceries"
            - "Climbing several flights of stairs"
            - "Climbing one flight of stairs"
            - "Bending, kneeling, or stooping"
            - "Walking more than one kilometre"
            - "Walking several blocks"
            - "Walking one block"
            - "Bathing or dressing yourself"
          input:
            control: Radio
            labels:
              1: "Limited a lot"
              2: "Limited a little"
              3: "Not at all limited"

        - id: sfr_q21
          kind: Question
          title: "During the past 4 weeks, how much bodily pain have you had?"
          precondition:
            - predicate: do_sfr == 1
          input:
            control: Radio
            labels:
              1: "None"
              2: "Very mild"
              3: "Mild"
              4: "Moderate"
              5: "Severe"
              6: "Very severe"

        - id: sfr_q23
          kind: Question
          title: "During the past 4 weeks, how much of the time did you feel full of pep?"
          precondition:
            - predicate: do_sfr == 1
          input:
            control: Radio
            labels:
              1: "All of the time"
              2: "Most of the time"
              3: "A good bit of the time"
              4: "Some of the time"
              5: "A little of the time"
              6: "None of the time"

        - id: sfr_q24
          kind: Question
          title: "During the past 4 weeks, how much of the time have you been a very nervous person?"
          precondition:
            - predicate: do_sfr == 1
          input:
            control: Radio
            labels:
              1: "All of the time"
              2: "Most of the time"
              3: "A good bit of the time"
              4: "Some of the time"
              5: "A little of the time"
              6: "None of the time"

        - id: sfr_q25
          kind: Question
          title: "During the past 4 weeks, how much of the time have you felt so down in the dumps that nothing could cheer you up?"
          precondition:
            - predicate: do_sfr == 1
          input:
            control: Radio
            labels:
              1: "All of the time"
              2: "Most of the time"
              3: "A good bit of the time"
              4: "Some of the time"
              5: "A little of the time"
              6: "None of the time"

        - id: sfr_q26
          kind: Question
          title: "During the past 4 weeks, how much of the time have you felt calm and peaceful?"
          precondition:
            - predicate: do_sfr == 1
          input:
            control: Radio
            labels:
              1: "All of the time"
              2: "Most of the time"
              3: "A good bit of the time"
              4: "Some of the time"
              5: "A little of the time"
              6: "None of the time"

        - id: sfr_q27
          kind: Question
          title: "During the past 4 weeks, how much of the time did you have a lot of energy?"
          precondition:
            - predicate: do_sfr == 1
          input:
            control: Radio
            labels:
              1: "All of the time"
              2: "Most of the time"
              3: "A good bit of the time"
              4: "Some of the time"
              5: "A little of the time"
              6: "None of the time"

        - id: sfr_q28
          kind: Question
          title: "During the past 4 weeks, how much of the time have you felt downhearted and blue?"
          precondition:
            - predicate: do_sfr == 1
          input:
            control: Radio
            labels:
              1: "All of the time"
              2: "Most of the time"
              3: "A good bit of the time"
              4: "Some of the time"
              5: "A little of the time"
              6: "None of the time"

        - id: sfr_q29
          kind: Question
          title: "During the past 4 weeks, how much of the time did you feel worn out?"
          precondition:
            - predicate: do_sfr == 1
          input:
            control: Radio
            labels:
              1: "All of the time"
              2: "Most of the time"
              3: "A good bit of the time"
              4: "Some of the time"
              5: "A little of the time"
              6: "None of the time"

        - id: sfr_q30
          kind: Question
          title: "During the past 4 weeks, how much of the time have you been a happy person?"
          precondition:
            - predicate: do_sfr == 1
          input:
            control: Radio
            labels:
              1: "All of the time"
              2: "Most of the time"
              3: "A good bit of the time"
              4: "Some of the time"
              5: "A little of the time"
              6: "None of the time"

        - id: sfr_q31
          kind: Question
          title: "During the past 4 weeks, how much of the time did you feel tired?"
          precondition:
            - predicate: do_sfr == 1
          input:
            control: Radio
            labels:
              1: "All of the time"
              2: "Most of the time"
              3: "A good bit of the time"
              4: "Some of the time"
              5: "A little of the time"
              6: "None of the time"

    # =========================================================================
    # BLOCK 37: LABOUR FORCE (LBF) - p.250
    # Age gate: 15-75. Complex job attachment / search / occupation routing.
    # Subsample only.
    # =========================================================================
    - id: b_lbf
      title: "Labour Force"
      items:
        - id: lbf_q01
          kind: Question
          title: "Last week, did you work at a job or a business? (include part-time, seasonal, contract work, self-employment)"
          precondition:
            - predicate: do_lbf == 1 and age >= 15 and age <= 75
          codeBlock: |
            lbf_worked_last_week = lbf_q01.outcome
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Permanently unable to work"

        - id: lbf_q02
          kind: Question
          title: "Last week, did you have a job or business from which you were absent?"
          precondition:
            - predicate: do_lbf == 1 and age >= 15 and age <= 75 and lbf_worked_last_week == 0
          codeBlock: |
            lbf_has_job = lbf_q02.outcome
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: lbf_q03
          kind: Question
          title: "Did you have more than one job or business last week?"
          precondition:
            - predicate: do_lbf == 1 and age >= 15 and age <= 75 and lbf_worked_last_week == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: lbf_q11
          kind: Question
          title: "In the past 4 weeks, did you do anything to find work?"
          precondition:
            - predicate: do_lbf == 1 and age >= 15 and age <= 75 and lbf_worked_last_week == 0 and lbf_has_job == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: lbf_q13
          kind: Question
          title: "What is the main reason that you are not currently working at a job or business?"
          precondition:
            - predicate: do_lbf == 1 and age >= 15 and age <= 75 and lbf_worked_last_week == 0 and lbf_has_job == 0
          input:
            control: Dropdown
            labels:
              1: "Own illness or disability"
              2: "Caring for own children"
              3: "Caring for elder relatives"
              4: "Pregnancy"
              5: "Other personal or family responsibilities"
              6: "Vacation"
              7: "School or educational leave"
              8: "Retired"
              9: "Believes no work available"
              10: "Other"

        - id: lbf_q31
          kind: Question
          title: "Are/Were you an employee or self-employed?"
          precondition:
            - predicate: do_lbf == 1 and age >= 15 and age <= 75 and (lbf_worked_last_week == 1 or lbf_has_job == 1)
          codeBlock: |
            lbf_employee = lbf_q31.outcome
          input:
            control: Radio
            labels:
              1: "Employee"
              2: "Self-employed"
              3: "Working in a family business without pay"

        - id: lbf_q37
          kind: Question
          title: "At your place of work, what are the restrictions on smoking?"
          precondition:
            - predicate: do_lbf == 1 and age >= 15 and age <= 75 and (lbf_worked_last_week == 1 or lbf_has_job == 1)
          input:
            control: Radio
            labels:
              1: "Restricted completely"
              2: "Allowed in designated areas"
              3: "Restricted only in certain places"
              4: "Not restricted at all"

        - id: lbf_q42
          kind: Question
          title: "About how many hours a week do you usually work at your job/business?"
          precondition:
            - predicate: do_lbf == 1 and age >= 15 and age <= 75 and (lbf_worked_last_week == 1 or lbf_has_job == 1)
          input:
            control: Editbox
            min: 1
            max: 168
            right: "hours"

        - id: lbf_q61
          kind: Question
          title: "During the past 52 weeks, how many weeks did you do any work at a job or a business?"
          precondition:
            - predicate: do_lbf == 1 and age >= 15 and age <= 75
          input:
            control: Editbox
            min: 0
            max: 52
            right: "weeks"

    # =========================================================================
    # BLOCK 38: SOCIO-DEMOGRAPHIC CHARACTERISTICS (SDC) - p.267
    # =========================================================================
    - id: b_sdc
      title: "Socio-Demographic Characteristics"
      items:
        - id: sdc_q01
          kind: Question
          title: "In what country were you born?"
          precondition:
            - predicate: do_sdc == 1
          input:
            control: Radio
            labels:
              1: "Canada"
              2: "Other country"

        - id: sdc_q02
          kind: Question
          title: "In what year did you first come to Canada to live?"
          precondition:
            - predicate: do_sdc == 1 and sdc_q01.outcome == 2
          input:
            control: Editbox
            min: 1900
            max: 2005

        - id: sdc_q03
          kind: Question
          title: "To which ethnic or cultural group(s) did your ancestors belong? (Select primary)"
          precondition:
            - predicate: do_sdc == 1
          input:
            control: Dropdown
            labels:
              1: "Canadian"
              2: "English"
              3: "French"
              4: "Scottish"
              5: "Irish"
              6: "German"
              7: "Italian"
              8: "Ukrainian"
              9: "Chinese"
              10: "South Asian"
              11: "Aboriginal"
              12: "Other"

        - id: sdc_q04
          kind: Question
          title: "What language do you speak most often at home?"
          precondition:
            - predicate: do_sdc == 1
          input:
            control: Radio
            labels:
              1: "English"
              2: "French"
              3: "Other"

        - id: sdc_q05
          kind: Question
          title: "What is your current marital status?"
          precondition:
            - predicate: do_sdc == 1 and age >= 15
          input:
            control: Radio
            labels:
              1: "Married"
              2: "Common-law"
              3: "Widowed"
              4: "Separated"
              5: "Divorced"
              6: "Single, never married"

    # =========================================================================
    # BLOCK 39: EDUCATION (EDU) - p.274
    # =========================================================================
    - id: b_edu
      title: "Education"
      items:
        - id: edu_q01
          kind: Question
          title: "What is the highest grade of elementary or high school you have ever completed?"
          precondition:
            - predicate: do_edu == 1 and age >= 15
          input:
            control: Dropdown
            labels:
              1: "Grade 8 or lower"
              2: "Grade 9"
              3: "Grade 10"
              4: "Grade 11"
              5: "Grade 12"
              6: "Grade 13"

        - id: edu_q02
          kind: Question
          title: "Have you received a high school diploma?"
          precondition:
            - predicate: do_edu == 1 and age >= 15
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: edu_q03
          kind: Question
          title: "Have you received any other education that could count towards a degree, certificate or diploma from an educational institution?"
          precondition:
            - predicate: do_edu == 1 and age >= 15
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: edu_q04
          kind: Question
          title: "What is the highest degree, certificate or diploma you have obtained?"
          precondition:
            - predicate: do_edu == 1 and age >= 15 and edu_q03.outcome == 1
          input:
            control: Dropdown
            labels:
              1: "Trade certificate or diploma from a vocational school"
              2: "Non-university certificate or diploma"
              3: "University certificate below bachelor's"
              4: "Bachelor's degree"
              5: "University degree or certificate above bachelor's"

    # =========================================================================
    # BLOCK 40: INCOME (INC) - p.280
    # =========================================================================
    - id: b_inc
      title: "Income"
      items:
        - id: inc_q01
          kind: Question
          title: "What is your best estimate of the total income, before taxes and deductions, of all household members from all sources in the past 12 months?"
          precondition:
            - predicate: do_inc == 1
          input:
            control: Dropdown
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

        - id: inc_q02
          kind: Question
          title: "What is your best estimate of your personal income, before taxes and deductions, from all sources in the past 12 months?"
          precondition:
            - predicate: do_inc == 1 and age >= 15
          input:
            control: Dropdown
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
    # BLOCK 41: FOOD SECURITY (FSC) - p.285
    # Cascading severity: household food insecurity -> child food insecurity.
    # =========================================================================
    - id: b_fsc
      title: "Food Security"
      items:
        - id: fsc_q010
          kind: Question
          title: "Which of the following statements best describes the food eaten in your household in the past 12 months?"
          precondition:
            - predicate: do_fsc == 1
          input:
            control: Radio
            labels:
              1: "You and your household members always had enough of the kinds of food you wanted to eat"
              2: "You and your household members had enough to eat but not always the kinds of food you wanted"
              3: "Sometimes you and your household members did not have enough to eat"
              4: "Often you and your household members did not have enough to eat"

        - id: fsc_q020
          kind: Question
          title: "You and other household members worried that food would run out before you got money to buy more. Was that often, sometimes, or never true in the past 12 months?"
          precondition:
            - predicate: do_fsc == 1
          input:
            control: Radio
            labels:
              1: "Often true"
              2: "Sometimes true"
              3: "Never true"

        - id: fsc_q090
          kind: Question
          title: "In the past 12 months, did you personally ever eat less than you felt you should because there wasn't enough money to buy food?"
          precondition:
            - predicate: do_fsc == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: fsc_q100
          kind: Question
          title: "In the past 12 months, were you personally ever hungry but didn't eat because you couldn't afford enough food?"
          precondition:
            - predicate: do_fsc == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # =========================================================================
    # BLOCK 42: DWELLING CHARACTERISTICS (DWL) - p.290
    # =========================================================================
    - id: b_dwl
      title: "Dwelling Characteristics"
      items:
        - id: dwl_q01
          kind: Question
          title: "What type of dwelling do you live in?"
          precondition:
            - predicate: do_dwl == 1
          input:
            control: Dropdown
            labels:
              1: "Single detached"
              2: "Double (semi-detached)"
              3: "Row or terrace"
              4: "Duplex"
              5: "Low-rise apartment (fewer than 5 stories)"
              6: "High-rise apartment (5 stories or more)"
              7: "Institution"
              8: "Hotel/rooming/lodging house/camp"
              9: "Mobile home"
              10: "Other"

        - id: dwl_q02
          kind: Question
          title: "How many bedrooms are there in this dwelling?"
          precondition:
            - predicate: do_dwl == 1
          input:
            control: Editbox
            min: 0
            max: 20

        - id: dwl_q03
          kind: Question
          title: "Is this dwelling owned by a member of this household?"
          precondition:
            - predicate: do_dwl == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # =========================================================================
    # BLOCK 43: ADMINISTRATION (ADM) - p.292
    # Data sharing consent, frame evaluation.
    # =========================================================================
    - id: b_adm
      title: "Administration"
      items:
        - id: adm_q01b
          kind: Question
          title: "This linked information will be kept confidential and used only for statistical purposes. Do we have your permission?"
          precondition:
            - predicate: do_adm == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: adm_q04b
          kind: Question
          title: "Do you agree to share the information collected in this survey with provincial and territorial ministries of health, Health Canada, and the Public Health Agency of Canada?"
          precondition:
            - predicate: do_adm == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: adm_n09
          kind: Question
          title: "Was this interview conducted on the telephone or in person?"
          precondition:
            - predicate: do_adm == 1
          input:
            control: Radio
            labels:
              1: "On telephone"
              2: "In person"
              3: "Both"

        - id: adm_n10
          kind: Question
          title: "Was the respondent alone when you asked this health questionnaire?"
          precondition:
            - predicate: do_adm == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: adm_n12
          kind: Question
          title: "Record language of interview."
          precondition:
            - predicate: do_adm == 1
          input:
            control: Radio
            labels:
              1: "English"
              2: "French"
              3: "Other"
