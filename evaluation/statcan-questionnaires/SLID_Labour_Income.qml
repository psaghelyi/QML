qmlVersion: "1.0"
questionnaire:
  title: "SLID 1994 Preliminary Interview - Labour and Income Dynamics"
  codeInit: |
    # Age gate variable (pre-filled from household roster)
    age = 0
    sex = 0
    marital_status = 0
    # Employment routing
    emp_status = 0
    ever_worked = 0
    perm_unable = 0
    temp_layoff = 0
    worked_ref_year = 0
    is_paid_worker_j1 = 0
    is_paid_worker_j2 = 0
    has_second_job = 0
    # Work experience routing
    ever_fulltime = 0
    years_working = 0
    worked_every_year = 0
    # Childbirth routing
    is_female_18plus = 0
    had_children = 0
    children_born_count = 0
    # Education routing
    years_elem_hs = 0
    enrolled_other_school = 0
    got_certificate = 0
    enrolled_university = 0
    got_uni_degree = 0
    # Wage reporting category for J1
    wage_category_j1 = 0
    wage_category_j2 = 0

  blocks:
    # =========================================================================
    # SCREENING - Age gate
    # =========================================================================
    - id: b_screening
      title: "Screening"
      items:
        - id: q_age
          kind: Question
          title: "Respondent's age in years"
          codeBlock: |
            age = q_age.outcome
          input:
            control: Editbox
            min: 0
            max: 120

        - id: q_sex
          kind: Question
          title: "Respondent's sex"
          codeBlock: |
            sex = q_sex.outcome
          input:
            control: Radio
            labels:
              1: "Male"
              2: "Female"

        - id: q_marital_status_roster
          kind: Question
          title: "Marital status from household roster"
          codeBlock: |
            marital_status = q_marital_status_roster.outcome
          input:
            control: Radio
            labels:
              1: "Married"
              2: "Common-law"
              3: "Separated"
              4: "Divorced"
              5: "Widowed"
              6: "Single (never married)"
              7: "DK/R"

    # =========================================================================
    # EMPPRE MODULE - Current/Recent Work Activity (p5-20)
    # =========================================================================
    - id: b_emppre_entry
      title: "EMPPRE - Employment Status"
      items:
        # * START-EMPPRE: Internal logic: [age] = 15 or more? (p5)
        # If No -> Go to EXPRE-Q1A
        - id: q_emppre_intro
          kind: Comment
          title: "The next questions are about current or recent work activity."
          precondition:
            - predicate: age >= 15

        # EMPPRE-Q1: Did respondent work at a job or business at the beginning of January? (p5)
        - id: q_emppre_q1
          kind: Question
          title: "DID [respondent] WORK AT A JOB OR BUSINESS AT THE BEGINNING OF JANUARY OF THIS YEAR?"
          precondition:
            - predicate: age >= 15
          codeBlock: |
            if q_emppre_q1.outcome == 1:
                emp_status = 1
            elif q_emppre_q1.outcome == 3:
                perm_unable = 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Permanently unable to work"
              4: "DK/R"

        # EMPPRE-Q2: Did respondent have a job but not at work? (p5)
        # Precondition: Q1 = No
        - id: q_emppre_q2
          kind: Question
          title: "DID [respondent] HAVE A JOB OR BUSINESS AT WHICH HE/SHE DID NOT WORK AT THE BEGINNING OF JANUARY?"
          precondition:
            - predicate: age >= 15 and q_emppre_q1.outcome == 2
          codeBlock: |
            if q_emppre_q2.outcome == 1:
                emp_status = 2
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "DK/R"

        # EMPPRE-Q3: Why absent from work? (p6)
        # Precondition: Q2 = Yes
        - id: q_emppre_q3
          kind: Question
          title: "WHY WAS [respondent] ABSENT FROM WORK AT THE BEGINNING OF JANUARY?"
          precondition:
            - predicate: age >= 15 and q_emppre_q1.outcome == 2 and q_emppre_q2.outcome == 1
          codeBlock: |
            if q_emppre_q3.outcome == 6:
                temp_layoff = 0
            elif q_emppre_q3.outcome == 7:
                temp_layoff = 1
            elif q_emppre_q3.outcome == 8:
                temp_layoff = 2
          input:
            control: Dropdown
            labels:
              1: "Own illness or disability"
              2: "Pregnancy"
              3: "Caring for own children"
              4: "Caring for elder relatives"
              5: "Other personal or family responsibilities"
              6: "School or educational leave"
              7: "Temporary layoff due to seasonal conditions"
              8: "Temporary layoff - non seasonal"
              9: "Labour dispute"
              10: "Unpaid or partially paid vacation"
              11: "Other"

        # EMPPRE-Q4: Did respondent receive any pay for absence? (p6)
        # If Q3 = school/educational leave -> Go to Q5; otherwise -> Q4
        - id: q_emppre_q4
          kind: Question
          title: "DID [respondent] RECEIVE ANY PAY FROM HIS/HER EMPLOYER FOR THIS ABSENCE?"
          precondition:
            - predicate: age >= 15 and q_emppre_q1.outcome == 2 and q_emppre_q2.outcome == 1 and q_emppre_q3.outcome != 6
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "DK/R"

        # * EMPPRE-N4: Internal logic: Q3 = Temporary Layoff? (p6)
        # If Yes -> Go to Q8; Otherwise -> J1.Q1
        # Temp layoff = Q3 in {7, 8}
        # This is a routing node: if temp layoff -> skip to Q8 (job search)
        # if not temp layoff -> go to J1.Q1 (employer details)

    # =========================================================================
    # EMPPRE - No job path (Q5-Q7, Q8-Q11) (p7-10)
    # =========================================================================
    - id: b_emppre_nojob
      title: "EMPPRE - No Current Job"
      items:
        # EMPPRE-Q5: Did respondent ever work? (p7)
        # Reached when: Q1=perm_unable, Q1=DK/R, Q2=No/DK/R
        - id: q_emppre_q5
          kind: Question
          title: "DID [respondent] EVER WORK AT A JOB OR BUSINESS?"
          precondition:
            - predicate: age >= 15 and (q_emppre_q1.outcome == 3 or q_emppre_q1.outcome == 4 or (q_emppre_q1.outcome == 2 and q_emppre_q2.outcome != 1))
          codeBlock: |
            if q_emppre_q5.outcome == 1:
                ever_worked = 1
          input:
            control: Radio
            labels:
              1: "Yes/DK/R"
              2: "No"

        # EMPPRE-Q6: When did respondent last work? (p7)
        # Precondition: Q5 = Yes
        - id: q_emppre_q6
          kind: Question
          title: "WHEN DID [respondent] LAST WORK AT A JOB OR BUSINESS? (Enter year)"
          precondition:
            - predicate: age >= 15 and ever_worked == 1
          codeBlock: |
            # EMPPRE-N6: Date in Q6 is before January [current year] minus 5 AND Q1=perm unable? (p7)
            # If yes -> go to N12; otherwise -> Q7
            # We encode: if last worked > 5 years ago AND permanently unable -> skip to N12
            if q_emppre_q6.outcome <= 1988 and perm_unable == 1:
                worked_ref_year = 0
            else:
                worked_ref_year = 1
          input:
            control: Editbox
            min: 1924
            max: 1994

        # EMPPRE-Q7: Main reason for leaving this job (p7-8)
        # Precondition: Q6 answered AND not (old + perm unable)
        - id: q_emppre_q7
          kind: Question
          title: "WHAT WAS [respondent]'S MAIN REASON FOR LEAVING THIS JOB?"
          precondition:
            - predicate: age >= 15 and ever_worked == 1 and worked_ref_year == 1
          input:
            control: Dropdown
            labels:
              1: "Own illness, disability"
              2: "Caring for own children"
              3: "Caring for elder relatives"
              4: "Other personal or family responsibilities"
              5: "Going to school"
              6: "Quit job for no specific reason"
              7: "Lost job or laid off job - Paid workers only"
              8: "Changed residence"
              9: "Dissatisfied with job"
              10: "Retired"
              11: "Other"

        # * EMPPRE-N7: Internal logic: Q1 = permanently unable to work? (p8)
        # If Yes -> N12; Otherwise -> Q8
        # This routes permanently unable workers who never worked to N12 (age gate)
        # and those who did work to Q8 (job search)

        # EMPPRE-Q8: Did respondent look for work in January? (p8)
        # Reached from: N4 (temp layoff), N7 (not perm unable, never worked or old+unable)
        - id: q_emppre_q8
          kind: Question
          title: "DID [respondent] LOOK FOR WORK IN JANUARY OF THIS YEAR?"
          precondition:
            - predicate: age >= 15 and ((q_emppre_q1.outcome == 2 and q_emppre_q2.outcome == 1 and q_emppre_q3.outcome != 6 and (q_emppre_q3.outcome == 7 or q_emppre_q3.outcome == 8)) or (q_emppre_q5.outcome == 2 and perm_unable == 0) or (ever_worked == 1 and worked_ref_year == 1 and perm_unable == 0))
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "DK/R"

        # EMPPRE-Q9: What did respondent do to find work? (p8)
        # Precondition: Q8 = Yes
        - id: q_emppre_q9
          kind: Question
          title: "WHAT DID [respondent] DO TO FIND WORK?"
          precondition:
            - predicate: age >= 15 and q_emppre_q8.outcome == 1
          input:
            control: Dropdown
            labels:
              1: "Contacted employer directly"
              2: "Friend or relative"
              3: "Placed or answered newspaper ad"
              4: "Employment agency"
              5: "Referral from another employer"
              6: "Other"

        # EMPPRE-Q10: Did respondent look for work in 6 months before? (p9)
        # Precondition: Q8 = No/DK/R
        - id: q_emppre_q10
          kind: Question
          title: "DID [respondent] LOOK FOR WORK AT ANY TIME IN THE 6 MONTHS BEFORE THAT?"
          precondition:
            - predicate: age >= 15 and (q_emppre_q8.outcome == 2 or q_emppre_q8.outcome == 3)
          input:
            control: Radio
            labels:
              1: "Yes/DK/R"
              2: "No"

        # EMPPRE-Q11: Reasons for not looking for work (p9-10)
        # Precondition: Q10 = Yes/DK/R
        - id: q_emppre_q11
          kind: Question
          title: "WHAT WERE THE REASONS [respondent] DID NOT LOOK FOR WORK IN JANUARY OF THIS YEAR?"
          precondition:
            - predicate: age >= 15 and (q_emppre_q10.outcome == 1)
          input:
            control: Dropdown
            labels:
              1: "Own illness, disability"
              2: "Caring for own children"
              3: "Caring for elder relatives"
              4: "Other personal or family responsibilities"
              5: "Going to school"
              6: "No longer interested in finding work"
              7: "Waiting for recall (to former job)"
              8: "Has found new job"
              9: "Waiting for replies from employers"
              10: "Believes no work available"
              11: "No reason given"
              12: "Other"

    # =========================================================================
    # EMPPRE - Age gate and school (N12, Q12, Q13) (p10)
    # =========================================================================
    - id: b_emppre_age_school
      title: "EMPPRE - Age Gate and School Attendance"
      items:
        # * EMPPRE-N11A: Internal logic: Q5=no (never worked) or dates last worked (Q6)
        #   is before January [reference year]? (p9)
        # If Yes -> N12; Otherwise -> J1.Q1A
        # This checks whether respondent worked in the reference year

        # * EMPPRE-N12: Internal logic: [age] is greater than 64 years? (p10)
        # If Yes -> EXPRE-Q1; Otherwise -> Q12
        # Respondents over 64 skip school questions and go to EXPRE

        # EMPPRE-Q12: In January, was respondent attending school? (p10)
        # Precondition: age <= 64 AND reached N12 path
        - id: q_emppre_q12
          kind: Question
          title: "IN JANUARY OF THIS YEAR, WAS [respondent] ATTENDING A SCHOOL, COLLEGE OR UNIVERSITY?"
          precondition:
            - predicate: age >= 15 and age <= 64
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "DK/R"

        # EMPPRE-Q13: Full-time or part-time student? (p10)
        # Precondition: Q12 = Yes
        - id: q_emppre_q13
          kind: Question
          title: "WAS [respondent] ENROLLED AS A FULL-TIME OR PART-TIME STUDENT?"
          precondition:
            - predicate: age >= 15 and age <= 64 and q_emppre_q12.outcome == 1
          input:
            control: Radio
            labels:
              1: "Full-time student"
              2: "Part-time student"
              3: "Some of each"

    # =========================================================================
    # EMPPRE - Job 1 Details (J1.Q1 - J1.Q15) (p11-16)
    # =========================================================================
    - id: b_emppre_job1
      title: "EMPPRE - Main Job Details"
      items:
        # EMPPRE-J1.Q1: Employer name for main job in January (p11)
        # Reached from: N4 (not temp layoff), Q9, N11A (worked in ref year)
        # For QML: show when respondent was working (Q1=Yes) or had job but absent (not temp layoff, not school leave)
        - id: q_j1_q1
          kind: Comment
          title: "I WOULD LIKE TO ASK A FEW QUESTIONS ABOUT [respondent]'S MAIN JOB OR BUSINESS IN EARLY JANUARY. FOR WHOM DID [respondent] WORK?"
          precondition:
            - predicate: age >= 15 and (q_emppre_q1.outcome == 1 or (q_emppre_q1.outcome == 2 and q_emppre_q2.outcome == 1 and q_emppre_q3.outcome != 6 and q_emppre_q3.outcome != 7 and q_emppre_q3.outcome != 8))

        # EMPPRE-J1.Q1A: Employer name for last job in reference year (p11)
        # Reached from N11A when respondent worked in reference year but not in January
        - id: q_j1_q1a
          kind: Comment
          title: "I WOULD LIKE TO ASK A FEW QUESTIONS ABOUT THE LAST JOB OR BUSINESS HELD BY [respondent] IN [reference year]. FOR WHOM DID [respondent] WORK?"
          precondition:
            - predicate: age >= 15 and q_emppre_q1.outcome != 1 and (q_emppre_q1.outcome != 2 or q_emppre_q2.outcome != 1 or q_emppre_q3.outcome == 6 or q_emppre_q3.outcome == 7 or q_emppre_q3.outcome == 8) and ever_worked == 1 and worked_ref_year == 1

        # EMPPRE-J1.Q2: When first started working for this employer (p11)
        - id: q_j1_q2
          kind: Question
          title: "WHEN WAS THE FIRST TIME [respondent] STARTED WORKING FOR THIS EMPLOYER? (Enter year)"
          precondition:
            - predicate: age >= 15 and (q_emppre_q1.outcome == 1 or (q_emppre_q1.outcome == 2 and q_emppre_q2.outcome == 1 and q_emppre_q3.outcome != 6 and q_emppre_q3.outcome != 7 and q_emppre_q3.outcome != 8) or (ever_worked == 1 and worked_ref_year == 1))
          input:
            control: Editbox
            min: 1924
            max: 1994

        # EMPPRE-J1.Q3: What kind of business, industry or service (p12)
        - id: q_j1_q3
          kind: Question
          title: "WHAT KIND OF BUSINESS, INDUSTRY OR SERVICE WAS THIS?"
          precondition:
            - predicate: age >= 15 and (q_emppre_q1.outcome == 1 or (q_emppre_q1.outcome == 2 and q_emppre_q2.outcome == 1 and q_emppre_q3.outcome != 6 and q_emppre_q3.outcome != 7 and q_emppre_q3.outcome != 8) or (ever_worked == 1 and worked_ref_year == 1))
          input:
            control: Dropdown
            labels:
              1: "Agriculture"
              2: "Manufacturing"
              3: "Construction"
              4: "Retail trade"
              5: "Finance and insurance"
              6: "Government"
              7: "Education"
              8: "Health care"
              9: "Other services"
              10: "Other"

        # EMPPRE-J1.Q4: What kind of work (p12)
        - id: q_j1_q4
          kind: Question
          title: "WHAT KIND OF WORK WAS [respondent] DOING?"
          precondition:
            - predicate: age >= 15 and (q_emppre_q1.outcome == 1 or (q_emppre_q1.outcome == 2 and q_emppre_q2.outcome == 1 and q_emppre_q3.outcome != 6 and q_emppre_q3.outcome != 7 and q_emppre_q3.outcome != 8) or (ever_worked == 1 and worked_ref_year == 1))
          input:
            control: Dropdown
            labels:
              1: "Management"
              2: "Professional"
              3: "Clerical"
              4: "Sales"
              5: "Service"
              6: "Trades and transport"
              7: "Primary industry"
              8: "Processing and manufacturing"
              9: "Other"

        # EMPPRE-J1.Q5: Most important activities or duties (p12)
        - id: q_j1_q5
          kind: Question
          title: "WHAT WERE [respondent]'S MOST IMPORTANT ACTIVITIES OR DUTIES?"
          precondition:
            - predicate: age >= 15 and (q_emppre_q1.outcome == 1 or (q_emppre_q1.outcome == 2 and q_emppre_q2.outcome == 1 and q_emppre_q3.outcome != 6 and q_emppre_q3.outcome != 7 and q_emppre_q3.outcome != 8) or (ever_worked == 1 and worked_ref_year == 1))
          input:
            control: Dropdown
            labels:
              1: "Administrative duties"
              2: "Technical duties"
              3: "Manual labour"
              4: "Customer service"
              5: "Other"

        # EMPPRE-J1.Q6: Class of worker (p12)
        # If paid worker or DK/R -> J1.Q7A; Otherwise -> EMPPRE-N12
        - id: q_j1_q6
          kind: Question
          title: "IN THIS JOB, WAS [respondent] A PAID WORKER, SELF-EMPLOYED OR AN UNPAID FAMILY WORKER?"
          precondition:
            - predicate: age >= 15 and (q_emppre_q1.outcome == 1 or (q_emppre_q1.outcome == 2 and q_emppre_q2.outcome == 1 and q_emppre_q3.outcome != 6 and q_emppre_q3.outcome != 7 and q_emppre_q3.outcome != 8) or (ever_worked == 1 and worked_ref_year == 1))
          codeBlock: |
            if q_j1_q6.outcome == 1:
                is_paid_worker_j1 = 1
            else:
                is_paid_worker_j1 = 0
          input:
            control: Dropdown
            labels:
              1: "Paid worker"
              2: "Unpaid family worker"
              3: "Self-employed Incorporated - With paid help"
              4: "Self-employed Incorporated - No paid help"
              5: "Self-employed Unincorporated - With paid help"
              6: "Self-employed Unincorporated - No paid help"

        # EMPPRE-J1.Q7A: Months worked at this job (p13)
        # Precondition: paid worker (Q6=1 or DK/R -> encoded as 1)
        - id: q_j1_q7a
          kind: Question
          title: "IN WHICH MONTHS OF [reference year] DID [respondent] WORK AT THIS JOB?"
          precondition:
            - predicate: age >= 15 and is_paid_worker_j1 == 1
          input:
            control: Radio
            labels:
              1: "All months/DK/R"
              2: "Started in current year"
              3: "Specify months"
              4: "Last worked before reference year"

        # EMPPRE-J1.Q8: Did respondent usually work every week of the month? (p13)
        # Precondition: J1.Q7A = All months
        - id: q_j1_q8
          kind: Question
          title: "AT THIS JOB, DID [respondent] USUALLY WORK EVERY WEEK OF THE MONTH?"
          precondition:
            - predicate: age >= 15 and is_paid_worker_j1 == 1 and (q_j1_q7a.outcome == 1 or q_j1_q7a.outcome == 3)
          input:
            control: Radio
            labels:
              1: "Yes/DK/R"
              2: "No"

        # EMPPRE-J1.Q9: Weeks usually worked per month (p14)
        # Precondition: J1.Q8 = No
        - id: q_j1_q9
          kind: Question
          title: "HOW MANY WEEKS DID [respondent] USUALLY WORK EACH MONTH?"
          precondition:
            - predicate: age >= 15 and is_paid_worker_j1 == 1 and q_j1_q8.outcome == 2
          input:
            control: Editbox
            min: 1
            max: 3

        # EMPPRE-J1.Q10: Hours per week usually paid (p14)
        - id: q_j1_q10
          kind: Question
          title: "HOW MANY HOURS PER WEEK DID [respondent] USUALLY GET PAID?"
          precondition:
            - predicate: age >= 15 and is_paid_worker_j1 == 1 and (q_j1_q7a.outcome == 1 or q_j1_q7a.outcome == 3)
          input:
            control: Editbox
            min: 1
            max: 99

        # EMPPRE-J1.Q11A: Wage or salary before taxes (p14)
        - id: q_j1_q11a
          kind: Question
          title: "AT THIS JOB, WHAT WAS [respondent]'S WAGE OR SALARY BEFORE TAXES AND DEDUCTIONS?"
          precondition:
            - predicate: age >= 15 and is_paid_worker_j1 == 1 and (q_j1_q7a.outcome == 1 or q_j1_q7a.outcome == 3)
          input:
            control: Editbox
            min: 1
            max: 999999

        # EMPPRE-J1.Q11B: Category for reported wage (p14-15)
        - id: q_j1_q11b
          kind: Question
          title: "Interviewer: Select the appropriate category for reported wage or salary"
          precondition:
            - predicate: age >= 15 and is_paid_worker_j1 == 1 and (q_j1_q7a.outcome == 1 or q_j1_q7a.outcome == 3)
          codeBlock: |
            wage_category_j1 = q_j1_q11b.outcome
          input:
            control: Radio
            labels:
              1: "Hourly"
              2: "Weekly"
              3: "Every two weeks/twice a month"
              4: "Monthly"
              5: "Yearly"
              6: "Other (specify)"

        # EMPPRE-J1.Q12: Total earnings from this job (p15)
        # If J1.Q11B = Other (6) -> J1.Q12; otherwise -> J1.Q13
        - id: q_j1_q12
          kind: Question
          title: "WHAT WERE [respondent]'S TOTAL EARNINGS FROM THIS JOB IN [reference year]?"
          precondition:
            - predicate: age >= 15 and is_paid_worker_j1 == 1 and wage_category_j1 == 6
          input:
            control: Editbox
            min: 1
            max: 999999

        # EMPPRE-J1.Q13: Did respondent receive commissions, tips, bonuses? (p15)
        - id: q_j1_q13
          kind: Question
          title: "DID [respondent] RECEIVE ANY COMMISSIONS, TIPS, BONUSES OR PAID OVERTIME FROM THIS JOB IN [reference year]?"
          precondition:
            - predicate: age >= 15 and is_paid_worker_j1 == 1 and (q_j1_q7a.outcome == 1 or q_j1_q7a.outcome == 3)
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No/DK/R"

        # EMPPRE-J1.Q14: Were commissions included in amount reported? (p15)
        # Precondition: J1.Q13 = Yes
        - id: q_j1_q14
          kind: Question
          title: "WERE THESE COMMISSIONS, TIPS, BONUSES OR PAID OVERTIME INCLUDED IN THE AMOUNT JUST REPORTED?"
          precondition:
            - predicate: age >= 15 and is_paid_worker_j1 == 1 and q_j1_q13.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes/DK/R"
              2: "No"

        # EMPPRE-J1.Q15: Total earnings from commissions, etc. (p16)
        # Precondition: J1.Q14 = No
        - id: q_j1_q15
          kind: Question
          title: "WHAT WERE [respondent]'S TOTAL EARNINGS IN [reference year] FROM THESE COMMISSIONS, TIPS, BONUSES, OR PAID OVERTIME?"
          precondition:
            - predicate: age >= 15 and is_paid_worker_j1 == 1 and q_j1_q13.outcome == 1 and q_j1_q14.outcome == 2
          input:
            control: Editbox
            min: 1
            max: 999999

    # =========================================================================
    # EMPPRE - Second Job (J2.Q1 - J2.Q16) (p16-21)
    # =========================================================================
    - id: b_emppre_job2
      title: "EMPPRE - Second Job Details"
      items:
        # EMPPRE-J2.Q1: Did respondent have more than one job? (p16)
        - id: q_j2_q1
          kind: Question
          title: "DID [respondent] HAVE MORE THAN ONE JOB OR BUSINESS IN JANUARY OF THIS YEAR?"
          precondition:
            - predicate: age >= 15 and is_paid_worker_j1 == 1
          codeBlock: |
            if q_j2_q1.outcome == 1:
                has_second_job = 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No/DK/R"

        # EMPPRE-J2.Q2: Employer name for second job (p16)
        - id: q_j2_q2
          kind: Comment
          title: "I WOULD LIKE TO ASK A FEW QUESTIONS ABOUT [respondent]'S OTHER JOB OR BUSINESS IN JANUARY OF THIS YEAR. FOR WHOM DID [respondent] WORK?"
          precondition:
            - predicate: age >= 15 and has_second_job == 1

        # EMPPRE-J2.Q3: When first started working for this employer (p16)
        - id: q_j2_q3
          kind: Question
          title: "WHEN DID [respondent] FIRST START WORKING FOR THIS EMPLOYER? (Enter year)"
          precondition:
            - predicate: age >= 15 and has_second_job == 1
          input:
            control: Editbox
            min: 1924
            max: 1994

        # EMPPRE-J2.Q4: Industry (p17)
        - id: q_j2_q4
          kind: Question
          title: "WHAT KIND OF BUSINESS, INDUSTRY OR SERVICE WAS THIS?"
          precondition:
            - predicate: age >= 15 and has_second_job == 1
          input:
            control: Dropdown
            labels:
              1: "Agriculture"
              2: "Manufacturing"
              3: "Construction"
              4: "Retail trade"
              5: "Finance and insurance"
              6: "Government"
              7: "Education"
              8: "Health care"
              9: "Other services"
              10: "Other"

        # EMPPRE-J2.Q5: Occupation (p17)
        - id: q_j2_q5
          kind: Question
          title: "WHAT KIND OF WORK WAS [respondent] DOING?"
          precondition:
            - predicate: age >= 15 and has_second_job == 1
          input:
            control: Dropdown
            labels:
              1: "Management"
              2: "Professional"
              3: "Clerical"
              4: "Sales"
              5: "Service"
              6: "Trades and transport"
              7: "Primary industry"
              8: "Processing and manufacturing"
              9: "Other"

        # EMPPRE-J2.Q6: Most important duties (p17)
        - id: q_j2_q6
          kind: Question
          title: "WHAT WERE [respondent]'S MOST IMPORTANT ACTIVITIES OR DUTIES?"
          precondition:
            - predicate: age >= 15 and has_second_job == 1
          input:
            control: Dropdown
            labels:
              1: "Administrative duties"
              2: "Technical duties"
              3: "Manual labour"
              4: "Customer service"
              5: "Other"

        # EMPPRE-J2.Q7: Class of worker for second job (p17)
        - id: q_j2_q7
          kind: Question
          title: "IN THIS JOB, WAS [respondent] A PAID WORKER, SELF-EMPLOYED OR AN UNPAID FAMILY WORKER?"
          precondition:
            - predicate: age >= 15 and has_second_job == 1
          codeBlock: |
            if q_j2_q7.outcome == 1:
                is_paid_worker_j2 = 1
            else:
                is_paid_worker_j2 = 0
          input:
            control: Dropdown
            labels:
              1: "Paid worker"
              2: "Unpaid family worker"
              3: "Self-employed Incorporated - With paid help"
              4: "Self-employed Incorporated - No paid help"
              5: "Self-employed Unincorporated - With paid help"
              6: "Self-employed Unincorporated - No paid help"

        # EMPPRE-J2.Q8A: Months worked at second job (p17-18)
        - id: q_j2_q8a
          kind: Question
          title: "IN WHICH MONTHS OF [reference year] DID [respondent] WORK AT THIS JOB?"
          precondition:
            - predicate: age >= 15 and has_second_job == 1 and is_paid_worker_j2 == 1
          input:
            control: Radio
            labels:
              1: "All months/DK/R"
              2: "Started in current year"
              3: "Specify months"
              4: "Last worked before reference year"

        # EMPPRE-J2.Q9: Did respondent usually work every week? (p18)
        - id: q_j2_q9
          kind: Question
          title: "AT THIS JOB, DID [respondent] USUALLY WORK EVERY WEEK OF THE MONTH?"
          precondition:
            - predicate: age >= 15 and has_second_job == 1 and is_paid_worker_j2 == 1 and (q_j2_q8a.outcome == 1 or q_j2_q8a.outcome == 3)
          input:
            control: Radio
            labels:
              1: "Yes/DK/R"
              2: "No"

        # EMPPRE-J2.Q10: Weeks per month (p19)
        - id: q_j2_q10
          kind: Question
          title: "HOW MANY WEEKS DID [respondent] USUALLY WORK EACH MONTH?"
          precondition:
            - predicate: age >= 15 and has_second_job == 1 and is_paid_worker_j2 == 1 and q_j2_q9.outcome == 2
          input:
            control: Editbox
            min: 1
            max: 3

        # EMPPRE-J2.Q11: Hours per week (p19)
        - id: q_j2_q11
          kind: Question
          title: "HOW MANY HOURS PER WEEK DID [respondent] USUALLY GET PAID?"
          precondition:
            - predicate: age >= 15 and has_second_job == 1 and is_paid_worker_j2 == 1 and (q_j2_q8a.outcome == 1 or q_j2_q8a.outcome == 3)
          input:
            control: Editbox
            min: 1
            max: 99

        # EMPPRE-J2.Q12A: Wage or salary (p19)
        - id: q_j2_q12a
          kind: Question
          title: "AT THIS JOB, WHAT WAS [respondent]'S WAGE OR SALARY BEFORE TAXES AND DEDUCTIONS?"
          precondition:
            - predicate: age >= 15 and has_second_job == 1 and is_paid_worker_j2 == 1 and (q_j2_q8a.outcome == 1 or q_j2_q8a.outcome == 3)
          input:
            control: Editbox
            min: 1
            max: 999999

        # EMPPRE-J2.Q12B: Wage category (p19-20)
        - id: q_j2_q12b
          kind: Question
          title: "Interviewer: Select the appropriate category for reported wage or salary"
          precondition:
            - predicate: age >= 15 and has_second_job == 1 and is_paid_worker_j2 == 1 and (q_j2_q8a.outcome == 1 or q_j2_q8a.outcome == 3)
          codeBlock: |
            wage_category_j2 = q_j2_q12b.outcome
          input:
            control: Radio
            labels:
              1: "Hourly"
              2: "Weekly"
              3: "Every two weeks/twice a month"
              4: "Monthly"
              5: "Yearly"
              6: "Other (specify)"

        # EMPPRE-J2.Q13: Total earnings from second job (p20)
        - id: q_j2_q13
          kind: Question
          title: "WHAT WERE [respondent]'S TOTAL EARNINGS FROM THIS JOB IN [reference year]?"
          precondition:
            - predicate: age >= 15 and has_second_job == 1 and is_paid_worker_j2 == 1 and wage_category_j2 == 6
          input:
            control: Editbox
            min: 1
            max: 999999

        # EMPPRE-J2.Q14: Commissions, tips, bonuses? (p20)
        - id: q_j2_q14
          kind: Question
          title: "DID [respondent] RECEIVE ANY COMMISSIONS, TIPS, BONUSES OR PAID OVERTIME FROM THIS JOB IN [reference year]?"
          precondition:
            - predicate: age >= 15 and has_second_job == 1 and is_paid_worker_j2 == 1 and (q_j2_q8a.outcome == 1 or q_j2_q8a.outcome == 3)
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No/DK/R"

        # EMPPRE-J2.Q15: Were commissions included? (p20)
        - id: q_j2_q15
          kind: Question
          title: "WERE THESE COMMISSIONS, TIPS, BONUSES OR PAID OVERTIME INCLUDED IN THE AMOUNT JUST REPORTED?"
          precondition:
            - predicate: age >= 15 and has_second_job == 1 and is_paid_worker_j2 == 1 and q_j2_q14.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes/DK/R"
              2: "No"

        # EMPPRE-J2.Q16: Total earnings from commissions (p21)
        - id: q_j2_q16
          kind: Question
          title: "WHAT WERE [respondent]'S TOTAL EARNINGS IN [reference year] FROM THESE COMMISSIONS, TIPS, BONUSES, OR PAID OVERTIME?"
          precondition:
            - predicate: age >= 15 and has_second_job == 1 and is_paid_worker_j2 == 1 and q_j2_q14.outcome == 1 and q_j2_q15.outcome == 2
          input:
            control: Editbox
            min: 1
            max: 999999

    # =========================================================================
    # EXPRE MODULE - Work Experience (p21-26)
    # =========================================================================
    - id: b_expre
      title: "EXPRE - Work Experience"
      items:
        # * EXPRE-N1: Internal logic: [age] is greater than 69 years? (p21)
        # If Yes -> DEMPRE-Q1A; Otherwise -> EXPRE-Q1A
        # Age over 69 skip entire EXPRE module

        # EXPRE-Q1A: Did respondent ever work full-time? (p21-22)
        - id: q_expre_q1a
          kind: Question
          title: "DID [respondent] EVER WORK FULL-TIME? (Exclude summer jobs while in school)"
          precondition:
            - predicate: age >= 15 and age <= 69
          codeBlock: |
            if q_expre_q1a.outcome == 1:
                ever_fulltime = 1
            else:
                ever_fulltime = 0
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No, never worked full-time"
              3: "No, only worked full-time at summer jobs while in school"
              4: "DK/R"

        # EXPRE-Q1B: How many years ago first started working full-time? (p22)
        # Precondition: Q1A = Yes
        - id: q_expre_q1b
          kind: Question
          title: "HOW MANY YEARS AGO DID [respondent] FIRST START WORKING FULL-TIME? (Enter 00 if less than one year)"
          precondition:
            - predicate: age >= 15 and age <= 69 and ever_fulltime == 1
          codeBlock: |
            years_working = q_expre_q1b.outcome
          input:
            control: Editbox
            min: 0
            max: 60

        # EXPRE-Q2A: Any years when respondent did not work? (p22)
        # Precondition: Q1B > 1
        - id: q_expre_q2a
          kind: Question
          title: "IN THOSE [response given in EXPRE-Q1B] YEARS, WERE THERE ANY YEARS WHEN [respondent] DID NOT WORK AT A JOB OR BUSINESS?"
          precondition:
            - predicate: age >= 15 and age <= 69 and ever_fulltime == 1 and years_working > 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No/DK/R"

        # EXPRE-Q2B: How many years not working (p23)
        # Precondition: Q2A = Yes
        - id: q_expre_q2b
          kind: Question
          title: "HOW MANY YEARS DID [respondent] NOT WORK AT A JOB OR BUSINESS?"
          precondition:
            - predicate: age >= 15 and age <= 69 and ever_fulltime == 1 and years_working > 1 and q_expre_q2a.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 60

        # EXPRE-Q3: Did respondent work at least 6 months each and every year? (p23)
        # Precondition: Q1B > 1 (reached from Q2A=No or Q2B)
        - id: q_expre_q3
          kind: Question
          title: "IN THOSE [EXPRE-Q1B] YEARS, DID [respondent] WORK AT LEAST 6 MONTHS EACH AND EVERY YEAR?"
          precondition:
            - predicate: age >= 15 and age <= 69 and ever_fulltime == 1 and years_working > 1
          codeBlock: |
            if q_expre_q3.outcome == 1:
                worked_every_year = 1
            else:
                worked_every_year = 0
          input:
            control: Radio
            labels:
              1: "Yes/DK/R"
              2: "No"

        # EXPRE-Q4A: How many years worked full-time only? (p23)
        # Precondition: Q3 = Yes/DK/R (worked every year path)
        - id: q_expre_q4a
          kind: Question
          title: "HOW MANY YEARS DID HE/SHE WORK ONLY FULL-TIME? (30+ hours per week)"
          precondition:
            - predicate: age >= 15 and age <= 69 and ever_fulltime == 1 and years_working > 1 and worked_every_year == 1
          input:
            control: Editbox
            min: 0
            max: 60

        # EXPRE-Q4B: How many years worked part-time only? (p24)
        - id: q_expre_q4b
          kind: Question
          title: "HOW MANY YEARS DID HE/SHE WORK ONLY PART-TIME?"
          precondition:
            - predicate: age >= 15 and age <= 69 and ever_fulltime == 1 and years_working > 1 and worked_every_year == 1
          input:
            control: Editbox
            min: 0
            max: 60

        # EXPRE-Q4C: How many years worked some of each? (p24)
        - id: q_expre_q4c
          kind: Question
          title: "HOW MANY DID HE/SHE ONLY WORK SOME OF EACH (full-time and part-time)?"
          precondition:
            - predicate: age >= 15 and age <= 69 and ever_fulltime == 1 and years_working > 1 and worked_every_year == 1
          input:
            control: Editbox
            min: 0
            max: 60

        # * EXPRE-N4: Internal logic: Sum of Q4A/B/C = EXPRE-Q1B? (p24)
        # This is a validation check - postcondition
        # If sum doesn't match -> Q4D error message; if matches -> DEMPRE-Q1A

        # EXPRE-Q5A: Since first started working, how many years worked at least 6 months? (p25)
        # Precondition: Q3 = No (didn't work every year) or Q2B answered
        - id: q_expre_q5a
          kind: Question
          title: "SINCE [respondent] FIRST STARTED WORKING, HOW MANY YEARS DID HE/SHE WORK AT LEAST 6 MONTHS OF THE YEAR?"
          precondition:
            - predicate: age >= 15 and age <= 69 and ever_fulltime == 1 and years_working > 1 and worked_every_year == 0
          input:
            control: Editbox
            min: 0
            max: 60

        # EXPRE-Q6A: How many years worked full-time only (from Q5A years)? (p25)
        # Precondition: Q5A > 0
        - id: q_expre_q6a
          kind: Question
          title: "IN THOSE [EXPRE-Q5A] YEARS, HOW MANY DID HE/SHE WORK ONLY FULL-TIME?"
          precondition:
            - predicate: age >= 15 and age <= 69 and ever_fulltime == 1 and years_working > 1 and worked_every_year == 0 and q_expre_q5a.outcome > 0
          input:
            control: Editbox
            min: 0
            max: 60

        # EXPRE-Q6B: How many years worked part-time only? (p25)
        - id: q_expre_q6b
          kind: Question
          title: "IN THOSE [EXPRE-Q5A] YEARS, HOW MANY DID HE/SHE WORK ONLY PART-TIME?"
          precondition:
            - predicate: age >= 15 and age <= 69 and ever_fulltime == 1 and years_working > 1 and worked_every_year == 0 and q_expre_q5a.outcome > 0
          input:
            control: Editbox
            min: 0
            max: 60

        # EXPRE-Q6C: How many years worked some of each? (p26)
        - id: q_expre_q6c
          kind: Question
          title: "IN THOSE [EXPRE-Q5A] YEARS, HOW MANY DID HE/SHE ONLY WORK SOME OF EACH?"
          precondition:
            - predicate: age >= 15 and age <= 69 and ever_fulltime == 1 and years_working > 1 and worked_every_year == 0 and q_expre_q5a.outcome > 0
          input:
            control: Editbox
            min: 0
            max: 60

        # * EXPRE-N6: Sum of Q6A/B/C = EXPRE-Q5A? (p26)
        # Validation check - same pattern as N4

    # =========================================================================
    # DEMPRE MODULE - Demographics (p26-36)
    # =========================================================================
    - id: b_dempre_marital
      title: "DEMPRE - Marital History"
      items:
        # DEMPRE-Q1A: Intro (p26-27)
        - id: q_dempre_q1a
          kind: Comment
          title: "THE NEXT FEW QUESTIONS ARE ABOUT [respondent]'S FAMILY BACKGROUND AND ARE BASED ON THE DATE OF BIRTH AND MARITAL STATUS REPORTED EARLIER IN THE INTERVIEW."

        # * DEMPRE-N1 through N1F: Marital status routing (p27-28)
        # Married -> Q2B; Common-law -> Q5; Separated/Divorced -> Q1; Widowed -> Q7; Single/DK/R -> N11A

        # DEMPRE-Q1: Date of separation (p28)
        # Precondition: separated or divorced
        - id: q_dempre_q1
          kind: Question
          title: "WHAT WAS THE DATE OF [respondent]'S SEPARATION? (Enter year)"
          precondition:
            - predicate: marital_status == 3 or marital_status == 4
          input:
            control: Editbox
            min: 1924
            max: 1994

        # DEMPRE-Q2: Date of this marriage (p28)
        # Precondition: separated or divorced (after Q1)
        - id: q_dempre_q2
          kind: Question
          title: "WHAT WAS THE DATE OF THIS MARRIAGE? (Enter year)"
          precondition:
            - predicate: marital_status == 3 or marital_status == 4
          input:
            control: Editbox
            min: 1924
            max: 1994

        # DEMPRE-Q2B: Date of marriage (for married respondents) (p29)
        - id: q_dempre_q2b
          kind: Question
          title: "WHAT WAS THE DATE OF [respondent]'S MARRIAGE? (Enter year)"
          precondition:
            - predicate: marital_status == 1
          input:
            control: Editbox
            min: 1924
            max: 1994

        # DEMPRE-Q3: Was this first marriage? (p29)
        # Precondition: married (after Q2B) or separated/divorced (after Q2)
        - id: q_dempre_q3
          kind: Question
          title: "WAS THIS [respondent]'S FIRST MARRIAGE?"
          precondition:
            - predicate: marital_status == 1 or marital_status == 3 or marital_status == 4
          input:
            control: Radio
            labels:
              1: "Yes/DK/R"
              2: "No"

        # DEMPRE-Q4: Date of first marriage (p29)
        # Precondition: Q3 = No
        - id: q_dempre_q4
          kind: Question
          title: "WHAT WAS THE DATE OF [respondent]'S FIRST MARRIAGE? (Enter year)"
          precondition:
            - predicate: (marital_status == 1 or marital_status == 3 or marital_status == 4) and q_dempre_q3.outcome == 2
          input:
            control: Editbox
            min: 1924
            max: 1994

        # DEMPRE-Q5: When did respondent and partner begin living together? (p30)
        # Precondition: common-law
        - id: q_dempre_q5
          kind: Question
          title: "WHEN DID [respondent] AND HIS/HER PARTNER BEGIN TO LIVE TOGETHER? (Enter year)"
          precondition:
            - predicate: marital_status == 2
          input:
            control: Editbox
            min: 1924
            max: 1994

        # DEMPRE-Q6: Has respondent ever been married? (p30)
        # Precondition: common-law (after Q5)
        - id: q_dempre_q6
          kind: Question
          title: "HAS [respondent] EVER BEEN MARRIED?"
          precondition:
            - predicate: marital_status == 2
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No/DK/R"

        # DEMPRE-Q7: When was respondent widowed? (p30)
        # Precondition: widowed
        - id: q_dempre_q7
          kind: Question
          title: "WHEN WAS [respondent] WIDOWED? (Enter year)"
          precondition:
            - predicate: marital_status == 5
          input:
            control: Editbox
            min: 1924
            max: 1994

        # DEMPRE-Q8: Was this first marriage? (for widowed and common-law who married) (p30)
        # Precondition: widowed, or common-law who has been married (Q6=Yes)
        - id: q_dempre_q8
          kind: Question
          title: "WAS THIS [respondent]'S FIRST MARRIAGE?"
          precondition:
            - predicate: marital_status == 5 or (marital_status == 2 and q_dempre_q6.outcome == 1)
          input:
            control: Radio
            labels:
              1: "Yes/DK/R"
              2: "No"

        # DEMPRE-Q9: Date of marriage (for widowed/common-law first marriage) (p30)
        # Precondition: Q8 = Yes
        - id: q_dempre_q9
          kind: Question
          title: "WHAT WAS THE DATE OF [respondent]'S MARRIAGE? (Enter year)"
          precondition:
            - predicate: (marital_status == 5 or (marital_status == 2 and q_dempre_q6.outcome == 1)) and q_dempre_q8.outcome == 1
          input:
            control: Editbox
            min: 1924
            max: 1994

        # DEMPRE-Q10: Date of first marriage (for widowed/common-law not first marriage) (p31)
        # Precondition: Q8 = No
        - id: q_dempre_q10
          kind: Question
          title: "WHAT WAS THE DATE OF [respondent]'S FIRST MARRIAGE? (Enter year)"
          precondition:
            - predicate: (marital_status == 5 or (marital_status == 2 and q_dempre_q6.outcome == 1)) and q_dempre_q8.outcome == 2
          input:
            control: Editbox
            min: 1924
            max: 1994

    # =========================================================================
    # DEMPRE - Childbirth and Demographics (p32-36)
    # =========================================================================
    - id: b_dempre_children
      title: "DEMPRE - Children and Background"
      items:
        # * DEMPRE-N11A: Internal logic: Respondent is female 18 years of age and over? (p32)
        # If Yes -> Q11; Otherwise -> Q16
        - id: q_dempre_n11a_comment
          kind: Comment
          title: "The next questions are about children."
          precondition:
            - predicate: sex == 2 and age >= 18
          codeBlock: |
            is_female_18plus = 1

        # DEMPRE-Q11: Has respondent had any children? (p33)
        - id: q_dempre_q11
          kind: Question
          title: "HAS [respondent] HAD ANY CHILDREN?"
          precondition:
            - predicate: is_female_18plus == 1
          codeBlock: |
            if q_dempre_q11.outcome == 1:
                had_children = 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "DK/R"

        # DEMPRE-Q12: How many children born? (p33)
        # Precondition: Q11 = Yes
        - id: q_dempre_q12
          kind: Question
          title: "HOW MANY CHILDREN WERE EVER BORN TO [respondent]?"
          precondition:
            - predicate: is_female_18plus == 1 and had_children == 1
          codeBlock: |
            children_born_count = q_dempre_q12.outcome
          input:
            control: Editbox
            min: 0
            max: 20

        # DEMPRE-Q13: Year first child born (p33)
        # Precondition: Q12 > 0
        - id: q_dempre_q13
          kind: Question
          title: "IN WHAT YEAR DID [respondent] GIVE BIRTH TO HER FIRST CHILD? (Enter year)"
          precondition:
            - predicate: is_female_18plus == 1 and had_children == 1 and children_born_count > 0
          input:
            control: Editbox
            min: 1924
            max: 1994

        # DEMPRE-Q14: Has respondent adopted or raised any children? (p33)
        # Reached from: Q12=0 path or after Q13
        - id: q_dempre_q14
          kind: Question
          title: "(Other than children [respondent] has given birth to) HAS [respondent] ADOPTED OR RAISED ANY CHILDREN?"
          precondition:
            - predicate: is_female_18plus == 1 and (had_children == 1 or q_dempre_q11.outcome == 2)
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No/DK/R"

        # DEMPRE-Q15: How many adopted/raised children? (p34)
        # Precondition: Q14 = Yes
        - id: q_dempre_q15
          kind: Question
          title: "HOW MANY (other) CHILDREN HAS [respondent] ADOPTED OR RAISED?"
          precondition:
            - predicate: is_female_18plus == 1 and q_dempre_q14.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 20

        # DEMPRE-Q16: Mother tongue (p34)
        - id: q_dempre_q16
          kind: Question
          title: "WHAT IS THE LANGUAGE THAT [respondent] FIRST LEARNED AT HOME IN CHILDHOOD AND STILL UNDERSTANDS?"
          input:
            control: Radio
            labels:
              1: "English"
              2: "French"
              3: "Other"

        # DEMPRE-Q17: Country of birth (p35)
        - id: q_dempre_q17
          kind: Question
          title: "IN WHAT COUNTRY WAS [respondent] BORN?"
          input:
            control: Dropdown
            labels:
              1: "Canada"
              2: "United Kingdom"
              3: "Italy"
              4: "U.S.A."
              5: "Germany"
              6: "Poland"
              7: "Other"

        # DEMPRE-Q18: Did respondent immigrate to Canada? (p35)
        # Precondition: Q17 != Canada
        - id: q_dempre_q18
          kind: Question
          title: "DID [respondent] IMMIGRATE TO CANADA?"
          precondition:
            - predicate: q_dempre_q17.outcome != 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No (never immigrated - Canadian citizen by birth)"
              3: "DK/R"

        # DEMPRE-Q18B: Year of immigration (p35)
        # Precondition: Q18 = Yes
        - id: q_dempre_q18b
          kind: Question
          title: "IN WHAT YEAR WAS THAT?"
          precondition:
            - predicate: q_dempre_q17.outcome != 1 and q_dempre_q18.outcome == 1
          input:
            control: Editbox
            min: 1924
            max: 1994

        # DEMPRE-Q19: Registered Indian? (p36)
        - id: q_dempre_q19
          kind: Question
          title: "IS [respondent] A REGISTERED INDIAN AS DEFINED BY THE INDIAN ACT OF CANADA?"
          input:
            control: Radio
            labels:
              1: "Yes, Registered Indian"
              2: "No/DK/R"

        # DEMPRE-Q20: Ethnic background (p36)
        - id: q_dempre_q20
          kind: Question
          title: "CANADIANS COME FROM MANY ETHNIC, CULTURAL AND RACIAL BACKGROUNDS. WHAT IS [respondent]'S BACKGROUND?"
          input:
            control: Dropdown
            labels:
              1: "English"
              2: "French"
              3: "German"
              4: "Scottish"
              5: "Italian"
              6: "Irish"
              7: "Ukrainian"
              8: "Chinese"
              9: "Dutch (Netherlands)"
              10: "Jewish"
              11: "Polish"
              12: "Black"
              13: "Metis"
              14: "Inuit/Eskimo"
              15: "North American Indian"
              16: "East Indian"
              17: "Canadian"
              18: "Other"

    # =========================================================================
    # EDUPRE MODULE - Education (p37-45)
    # =========================================================================
    - id: b_edupre
      title: "EDUPRE - Education"
      items:
        # EDUPRE-Q1: Years of elementary and high school (p37)
        - id: q_edupre_q1
          kind: Question
          title: "HOW MANY YEARS OF ELEMENTARY AND HIGH SCHOOL DID [respondent] COMPLETE?"
          codeBlock: |
            years_elem_hs = q_edupre_q1.outcome
          input:
            control: Editbox
            min: 0
            max: 15

        # * VERIFY-Q1: Years of schooling > [age] minus 5? (p37)
        # This is a validation - postcondition
        # If answer is "0" go to Q17 (parents' education); otherwise go to Q2

        # EDUPRE-Q2: Province of schooling (p38)
        # Precondition: Q1 > 0
        - id: q_edupre_q2
          kind: Question
          title: "IN WHICH PROVINCE OR TERRITORY DID [respondent] GET MOST OF HIS/HER ELEMENTARY AND HIGH SCHOOL EDUCATION?"
          precondition:
            - predicate: years_elem_hs > 0
          input:
            control: Dropdown
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
              11: "Yukon"
              12: "Northwest Territories"
              13: "Outside Canada"

        # * EVAL-Q1: EDUPRE-Q1 = 1 to 9? (p38)
        # If Yes -> Q4 (skip Q3); Otherwise -> Q3

        # EDUPRE-Q3: Did respondent complete high school? (p38)
        # Precondition: Q1 >= 10 (more than 9 years means they should have reached HS)
        - id: q_edupre_q3
          kind: Question
          title: "DID [respondent] COMPLETE HIGH SCHOOL?"
          precondition:
            - predicate: years_elem_hs >= 10
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # EDUPRE-Q4: Enrolled in other school (excl university)? (p38-39)
        - id: q_edupre_q4
          kind: Question
          title: "EXCLUDING UNIVERSITY, HAS [respondent] EVER BEEN ENROLLED IN ANY OTHER KIND OF SCHOOL, FOR EXAMPLE A COMMUNITY COLLEGE, BUSINESS SCHOOL, TRADE OR VOCATIONAL SCHOOL, OR CEGEP?"
          precondition:
            - predicate: years_elem_hs > 0
          codeBlock: |
            if q_edupre_q4.outcome == 1:
                enrolled_other_school = 1
            else:
                enrolled_other_school = 0
          input:
            control: Radio
            labels:
              1: "Yes/DK/R"
              2: "No"

        # EDUPRE-Q5: Has respondent received certificates/diplomas? (p39)
        # Precondition: Q4 = Yes
        - id: q_edupre_q5
          kind: Question
          title: "HAS [respondent] RECEIVED ANY CERTIFICATES OR DIPLOMAS AS A RESULT OF THIS EDUCATION?"
          precondition:
            - predicate: enrolled_other_school == 1
          codeBlock: |
            if q_edupre_q5.outcome == 1:
                got_certificate = 1
          input:
            control: Radio
            labels:
              1: "Yes/DK/R"
              2: "No"

        # EDUPRE-Q6: Type of school for most recent certificate (p39)
        # Precondition: Q5 = Yes/DK/R
        - id: q_edupre_q6
          kind: Question
          title: "THINKING OF THE MOST RECENT CERTIFICATE OR DIPLOMA (EXCLUDING UNIVERSITY) COULD YOU TELL ME WHAT TYPE OF SCHOOL OR COLLEGE [respondent] ATTENDED?"
          precondition:
            - predicate: got_certificate == 1
          input:
            control: Radio
            labels:
              1: "Community college or institute of applied arts and technology"
              2: "Business or commercial school"
              3: "Trade or vocational school"
              4: "CEGEP"
              5: "Some other type"

        # EDUPRE-Q7: How long to complete program (p39-40)
        # Precondition: Q5 = Yes (got certificate)
        - id: q_edupre_q7
          kind: Question
          title: "HOW LONG DID IT TAKE [respondent] TO COMPLETE THIS PROGRAM?"
          precondition:
            - predicate: got_certificate == 1
          input:
            control: Radio
            labels:
              1: "Answer given in months"
              2: "Answer given in years"
              3: "DK/R"

        # EDUPRE-Q7A: Number of months (p40)
        # Precondition: Q7 = months
        - id: q_edupre_q7a
          kind: Question
          title: "Interviewer: Enter number of months it took [respondent] to complete this program."
          precondition:
            - predicate: got_certificate == 1 and q_edupre_q7.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 99

        # EDUPRE-Q7B: Number of years (p40)
        # Precondition: Q7 = years
        - id: q_edupre_q7b
          kind: Question
          title: "Interviewer: Enter number of years it took [respondent] to complete this program."
          precondition:
            - predicate: got_certificate == 1 and q_edupre_q7.outcome == 2
          input:
            control: Editbox
            min: 1
            max: 9

        # EDUPRE-Q8: Was this full-time or part-time? (p40)
        # Precondition: got certificate
        - id: q_edupre_q8
          kind: Question
          title: "WAS THIS FULL-TIME, PART-TIME OR SOME OF EACH?"
          precondition:
            - predicate: got_certificate == 1
          input:
            control: Radio
            labels:
              1: "Full-time"
              2: "Part-time"
              3: "Some of each"

        # EDUPRE-Q9: Year received certificate or diploma (p41)
        - id: q_edupre_q9
          kind: Question
          title: "IN WHAT YEAR DID [respondent] RECEIVE HIS/HER CERTIFICATE OR DIPLOMA?"
          precondition:
            - predicate: got_certificate == 1
          input:
            control: Editbox
            min: 1924
            max: 1994

        # EDUPRE-Q10: Major subject or field of study (p41)
        - id: q_edupre_q10
          kind: Question
          title: "WHAT WAS THE MAJOR SUBJECT OR FIELD OF STUDY?"
          precondition:
            - predicate: got_certificate == 1
          input:
            control: Dropdown
            labels:
              1: "Education and teaching"
              2: "Fine and applied arts"
              3: "Humanities"
              4: "Social sciences"
              5: "Commerce and business"
              6: "Agriculture and biological sciences"
              7: "Engineering and applied sciences"
              8: "Health professions"
              9: "Mathematics and physical sciences"
              10: "Other"

        # EDUPRE-Q11: Total years of schooling at college/trade/vocational (p42)
        - id: q_edupre_q11
          kind: Question
          title: "IN TOTAL, HOW MANY YEARS OF SCHOOLING DID [respondent] COMPLETE AT A COMMUNITY COLLEGE, TECHNICAL INSTITUTE, TRADE OR VOCATIONAL SCHOOL, OR CEGEP?"
          precondition:
            - predicate: enrolled_other_school == 1
          input:
            control: Editbox
            min: 0
            max: 20

        # EDUPRE-Q12: Ever enrolled in university? (p42)
        - id: q_edupre_q12
          kind: Question
          title: "HAS [respondent] EVER BEEN ENROLLED IN A UNIVERSITY?"
          precondition:
            - predicate: years_elem_hs > 0
          codeBlock: |
            if q_edupre_q12.outcome == 1:
                enrolled_university = 1
            else:
                enrolled_university = 0
          input:
            control: Radio
            labels:
              1: "Yes/DK/R"
              2: "No"

        # EDUPRE-Q13: Years of university (p43)
        # Precondition: Q12 = Yes
        - id: q_edupre_q13
          kind: Question
          title: "HOW MANY YEARS OF UNIVERSITY HAS [respondent] COMPLETED? (Enter 00 if attended but didn't complete the year)"
          precondition:
            - predicate: enrolled_university == 1
          input:
            control: Editbox
            min: 0
            max: 20

        # EDUPRE-Q14: What degrees from university? (p43)
        # Precondition: Q12 = Yes (enrolled in university)
        - id: q_edupre_q14
          kind: Question
          title: "WHAT DEGREES, CERTIFICATES OR DIPLOMAS HAS [respondent] RECEIVED FROM A UNIVERSITY?"
          precondition:
            - predicate: enrolled_university == 1
          codeBlock: |
            if q_edupre_q14.outcome != 1:
                got_uni_degree = 1
          input:
            control: Radio
            labels:
              1: "None"
              2: "Specify Degrees"
              3: "DK/R"

        # EDUPRE-Q14A: Specify degrees (p44)
        # Precondition: Q14 = Specify Degrees
        - id: q_edupre_q14a
          kind: Question
          title: "Interviewer: Specify degrees, certificates or diplomas [respondent] has received from a university. Mark all that apply."
          precondition:
            - predicate: enrolled_university == 1 and q_edupre_q14.outcome == 2
          input:
            control: Dropdown
            labels:
              1: "University certificate/diploma below Bachelor level"
              2: "Bachelor's degree(s)"
              3: "University certificate/diploma above Bachelor level"
              4: "Master's degree(s)"
              5: "Degree in medicine, dentistry, veterinary medicine or optometry"
              6: "Doctorate (PhD)"

        # EDUPRE-Q15: Year received highest degree (p44)
        # Precondition: Q14 = Specify or DK/R (has some degree)
        - id: q_edupre_q15
          kind: Question
          title: "WHAT YEAR DID [respondent] RECEIVE HIS/HER [highest response category given in EDUPRE-Q14A]?"
          precondition:
            - predicate: enrolled_university == 1 and (q_edupre_q14.outcome == 2 or q_edupre_q14.outcome == 3)
          input:
            control: Editbox
            min: 1924
            max: 1994

        # EDUPRE-Q16: Major field of study (p44)
        # Precondition: Q14 = Specify (has degree)
        - id: q_edupre_q16
          kind: Question
          title: "WHAT WAS THE MAJOR FIELD OF STUDY?"
          precondition:
            - predicate: enrolled_university == 1 and (q_edupre_q14.outcome == 2 or q_edupre_q14.outcome == 3)
          input:
            control: Dropdown
            labels:
              1: "Education and teaching"
              2: "Fine and applied arts"
              3: "Humanities"
              4: "Social sciences"
              5: "Commerce and business"
              6: "Agriculture and biological sciences"
              7: "Engineering and applied sciences"
              8: "Health professions"
              9: "Mathematics and physical sciences"
              10: "Other"

    # =========================================================================
    # EDUPRE - Parents' Education (p44-45)
    # =========================================================================
    - id: b_edupre_parents
      title: "EDUPRE - Parents' Education"
      items:
        # EDUPRE-Q17: Mother's highest level of education (p44-45)
        - id: q_edupre_q17
          kind: Question
          title: "WHAT WAS THE HIGHEST LEVEL OF EDUCATION COMPLETED BY [respondent]'S MOTHER? WAS IT..."
          input:
            control: Radio
            labels:
              1: "Elementary school (includes no schooling)"
              2: "Some high school"
              3: "Completed high school"
              4: "Trade/vocational school"
              5: "Post-secondary certificate or diploma"
              6: "University degree"

        # EDUPRE-Q18: Father's highest level of education (p45)
        - id: q_edupre_q18
          kind: Question
          title: "WHAT WAS THE HIGHEST LEVEL OF EDUCATION COMPLETED BY [respondent]'S FATHER? WAS IT..."
          input:
            control: Radio
            labels:
              1: "Elementary school (includes no schooling)"
              2: "Some high school"
              3: "Completed high school"
              4: "Trade/vocational school"
              5: "Post-secondary certificate or diploma"
              6: "University degree"
