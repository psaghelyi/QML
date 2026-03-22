# Labour Force Survey (LFS) - QML Adaptation
# Source: Statistics Canada, Catalogue no. 71-543, Appendix B
# Converted from imperative CATI branching to declarative QML preconditions/postconditions.
#
# Conversion notes:
#   - "If X, go to Y" becomes a precondition on Y
#   - The LFS PATH variable (1-7) is tracked via codeInit/codeBlock
#   - Cross-checks (e.g., actual hours computation) become postconditions
#   - Contact and Household components omitted (interviewer logistics)
#   - Text-entry fields (employer name, business name) omitted (no branching impact)
#   - "Subsequent interview" panel-survey logic cannot be represented (single-administration)
#
# PATH definitions (from PDF p57):
#   1 = Employed, at work
#   2 = Employed, absent from work
#   3 = Temporary layoff
#   4 = Job seeker
#   5 = Future start
#   6 = Not in labour force, able to work
#   7 = Not in labour force, permanently unable to work
#
# KNOWN CONTRADICTIONS PRESERVED FROM ORIGINAL:
#   - PDF p54 CAF_Q01: "If age<16 or age>65, skip" vs p57 header: "aged 15 or over"
#   - PATH variable used as both classification AND routing mechanism

qmlVersion: "1.0"

questionnaire:
  title: "Labour Force Survey (LFS) - Statistics Canada Adaptation"
  codeInit: |
    path = 0
    is_employee = 0
    is_self_employed = 0
    has_job_description = 0
    past_job_path7 = 0
    usual_hours = 0
    hours_away = 0
    paid_overtime = 0
    unpaid_extra = 0
    discouraged_worker = 0

  blocks:
    # =========================================================================
    # BLOCK 1: Individual Demographics
    # Source: PDF pp52-54 (ANC_Q01 through CAF_Q01)
    # =========================================================================
    - id: b_demographics
      title: "Individual Demographics"
      items:
        # ANC_Q01/Q02/Q03 collapsed into single age question
        - id: q_age
          kind: Question
          title: "What is your age?"
          input:
            control: Editbox
            min: 0
            max: 120
            right: "years"
          # PDF p57: "For each person aged 15 or over" — section header text
          postcondition:
            - predicate: q_age.outcome >= 15
              hint: "Respondent must be 15 or older for the Labour Force Survey."

        # SEX_Q01
        - id: q_sex
          kind: Question
          title: "What is your sex?"
          input:
            control: Radio
            labels:
              1: "Male"
              2: "Female"

        # MSNC_Q01: "If age < 16, go to FI_N01" (skip marital status)
        - id: q_marital_status
          kind: Question
          title: "What is your marital status?"
          precondition:
            - predicate: q_age.outcome >= 16
          input:
            control: Radio
            labels:
              1: "Married"
              2: "Living common-law"
              3: "Widowed"
              4: "Separated"
              5: "Divorced"
              6: "Single, never married"

        # IMM_Q01
        - id: q_country_birth
          kind: Question
          title: "In what country were you born?"
          input:
            control: Dropdown
            labels:
              1: "Canada"
              2: "United States"
              3: "United Kingdom"
              4: "Germany"
              5: "Italy"
              6: "Poland"
              7: "Portugal"
              8: "China"
              9: "Hong Kong"
              10: "India"
              11: "Philippines"
              12: "Vietnam"
              13: "Other"

        # IMM_Q02: "If 01-Canada, go to ABO_Q01" (skip immigration)
        - id: q_landed_immigrant
          kind: Question
          title: "Is, or has this person ever been, a landed immigrant in Canada?"
          precondition:
            - predicate: q_country_birth.outcome != 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # IMM_Q03: precondition: landed immigrant = yes
        - id: q_year_immigrant
          kind: Question
          title: "In what year did you first become a landed immigrant?"
          precondition:
            - predicate: q_landed_immigrant.outcome == 1
          input:
            control: Editbox
            min: 1900
            max: 2026
            right: ""

        # ABO_Q01: "If Country of Birth is NOT Canada, USA or Greenland, go to ED_Q01"
        # Greenland not in country list, so <= 2 covers Canada + USA
        - id: q_aboriginal
          kind: Question
          title: "Are you an Aboriginal person, that is, North American Indian, Metis or Inuit?"
          precondition:
            - predicate: q_country_birth.outcome <= 2
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # ABO_Q02: precondition: aboriginal = yes
        - id: q_aboriginal_group
          kind: Question
          title: "Which Aboriginal group do you belong to?"
          precondition:
            - predicate: q_aboriginal.outcome == 1
          input:
            control: Checkbox
            labels:
              1: "North American Indian"
              2: "Metis"
              4: "Inuit"

        # ED_Q01: "If age < 14, go to CAF_Q01"
        - id: q_highest_grade
          kind: Question
          title: "What is the highest grade of elementary or high school ever completed?"
          precondition:
            - predicate: q_age.outcome >= 14
          input:
            control: Radio
            labels:
              1: "Grade 8 or lower"
              2: "Grade 9-10"
              3: "Grade 11-13"

        # ED_Q02: "If Grade 8 or lower or Grade 9-10, go to ED_Q03"
        - id: q_hs_graduate
          kind: Question
          title: "Did you graduate from high school (secondary school)?"
          precondition:
            - predicate: q_highest_grade.outcome == 3
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # ED_Q03: all grade paths converge here
        - id: q_other_education
          kind: Question
          title: "Have you received any other education that could be counted towards a degree, certificate or diploma from an educational institution?"
          precondition:
            - predicate: q_age.outcome >= 14
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # ED_Q04: precondition: other education = yes
        - id: q_highest_degree
          kind: Question
          title: "What is the highest degree, certificate or diploma you have obtained?"
          precondition:
            - predicate: q_other_education.outcome == 1
          input:
            control: Radio
            labels:
              1: "No postsecondary degree, certificate or diploma"
              2: "Trade certificate or diploma from a vocational school or apprenticeship"
              3: "Non-university certificate or diploma (community college, CEGEP, etc.)"
              4: "University certificate below bachelor's level"
              5: "Bachelor's degree"
              6: "University degree or certificate above bachelor's level"

        # CHE_Q01: complex precondition
        # PDF: "If Canada OR IMM_Q02=No OR no post-secondary → skip"
        # Shown when: NOT Canada AND landed immigrant AND has post-secondary
        - id: q_country_education
          kind: Question
          title: "In what country did you complete your highest degree, certificate or diploma?"
          precondition:
            - predicate: q_country_birth.outcome != 1
            - predicate: q_landed_immigrant.outcome == 1
            - predicate: q_highest_degree.outcome >= 2
          input:
            control: Dropdown
            labels:
              1: "Canada"
              2: "United States"
              3: "United Kingdom"
              4: "Germany"
              5: "Italy"
              6: "Poland"
              7: "Portugal"
              8: "China"
              9: "Hong Kong"
              10: "India"
              11: "Philippines"
              12: "Vietnam"
              13: "Other"

        # CAF_Q01: "If age < 16 or age > 65, go to ANC_Q01 for next household member"
        # CONTRADICTION: this uses age 16-65, but Labour Force header says "aged 15 or over"
        - id: q_armed_forces
          kind: Question
          title: "Are you a full-time member of the regular Canadian Armed Forces?"
          precondition:
            - predicate: q_age.outcome >= 16
            - predicate: q_age.outcome <= 65
          input:
            control: Switch
            off: "No"
            on: "Yes"

    # =========================================================================
    # BLOCK 2: Job Attachment (Q100-Q105)
    # PDF p58: PATH variable gets assigned here
    # PRECONDITION: CAF_Q01 uses age 16-65 (contradicts "aged 15 or over" header)
    # =========================================================================
    - id: b_job_attachment
      title: "Job Attachment"
      precondition:
        - predicate: q_armed_forces.outcome == 0
        - predicate: q_age.outcome >= 16
        - predicate: q_age.outcome <= 65
      items:
        - id: q100_intro
          kind: Comment
          title: "The following questions concern your activities last week. By last week, I mean the week beginning on the most recent Sunday and ending last Saturday."

        # Q100: "Last week, did you work at a job or business?"
        # If yes → PATH=1, go to 102
        # If no → go to 101
        # If permanently unable → PATH=7, go to 104
        - id: q100_worked
          kind: Question
          title: "Last week, did you work at a job or business? (regardless of the number of hours)"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Permanently unable to work"
          codeBlock: |
            if q100_worked.outcome == 1:
              path = 1
            elif q100_worked.outcome == 3:
              path = 7

        # Q101: "Last week, did you have a job from which you were absent?"
        # Precondition: Q100 = No
        - id: q101_absent_from_job
          kind: Question
          title: "Last week, did you have a job or business from which you were absent?"
          precondition:
            - predicate: q100_worked.outcome == 2
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q102: "Did you have more than one job last week?"
        # Precondition: Q100 = Yes (PATH 1)
        - id: q102_multiple_jobs
          kind: Question
          title: "Did you have more than one job or business last week?"
          precondition:
            - predicate: q100_worked.outcome == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q103: "Was this a result of changing employers?"
        # Precondition: Q102 = Yes
        - id: q103_changing_employers
          kind: Question
          title: "Was this a result of changing employers?"
          precondition:
            - predicate: q102_multiple_jobs.outcome == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q104: "Has he/she ever worked at a job or business?"
        # Reached when: (Q100=No AND Q101=No) OR Q100=Permanently unable
        - id: q104_ever_worked
          kind: Question
          title: "Have you ever worked at a job or business?"
          precondition:
            - predicate: (q100_worked.outcome == 2 and q101_absent_from_job.outcome == 0) or q100_worked.outcome == 3
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q105: "When did you last work?"
        # Precondition: Q104 = Yes
        # PDF routing:
        #   If not within past year → go to 170
        #   If PATH = 7 → go to 131 (directly, skip job description)
        #   If PATH not 7 → go to 110 (job description)
        - id: q105_when_last_worked
          kind: Question
          title: "When did you last work?"
          precondition:
            - predicate: q104_ever_worked.outcome == 1
          input:
            control: Radio
            labels:
              1: "Within the past year"
              2: "More than one year ago"
          codeBlock: |
            if q105_when_last_worked.outcome == 1:
              if path == 7:
                past_job_path7 = 1
              else:
                has_job_description = 1

    # =========================================================================
    # BLOCK 3: Job Description (Q110-Q118)
    # Reached by: PATH=1 (worked), Q101=Yes (absent), Q105→Q110 (past job)
    # NOT reached by: PATH=7 (goes directly to Q131 via past_job_path7)
    # =========================================================================
    - id: b_job_description
      title: "Job Description"
      precondition:
        - predicate: path == 1 or q101_absent_from_job.outcome == 1 or has_job_description == 1
      items:
        # Q110: "Was he/she an employee or self-employed?"
        # PDF has only Employee / Self-employed (no third option)
        # If not self-employed → go to 114 (employer name, omitted)
        - id: q110_class_of_worker
          kind: Question
          title: "At your main job or business, were you an employee or self-employed?"
          input:
            control: Radio
            labels:
              1: "Employee"
              2: "Self-employed"
              3: "Working in a family business without pay"
          codeBlock: |
            if q110_class_of_worker.outcome == 1:
              is_employee = 1
            elif q110_class_of_worker.outcome == 2:
              is_self_employed = 1

        # Q111: "Did he/she have an incorporated business?"
        # Precondition: self-employed
        - id: q111_incorporated
          kind: Question
          title: "Did you have an incorporated business?"
          precondition:
            - predicate: q110_class_of_worker.outcome == 2
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q112: "Did he/she have any employees?"
        # Precondition: self-employed
        - id: q112_had_employees
          kind: Question
          title: "Did you have any employees?"
          precondition:
            - predicate: q110_class_of_worker.outcome == 2
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q115: "What kind of business, industry or service was this?"
        - id: q115_industry
          kind: Question
          title: "What kind of business, industry or service was this?"
          input:
            control: Radio
            labels:
              1: "Agriculture, forestry, fishing"
              2: "Mining, oil and gas"
              3: "Manufacturing"
              4: "Construction"
              5: "Wholesale and retail trade"
              6: "Transportation and warehousing"
              7: "Finance, insurance, real estate"
              8: "Professional, scientific, technical services"
              9: "Educational services"
              10: "Health care and social assistance"
              11: "Accommodation and food services"
              12: "Public administration"
              13: "Other"

        # Q118: "When did you start working for this employer?"
        - id: q118_start_year
          kind: Question
          title: "When did you start working at this job or business?"
          input:
            control: Editbox
            min: 1950
            max: 2026
            right: "(year)"

    # =========================================================================
    # BLOCK 4: Absence and Separation (Q130-Q137)
    # Entry points:
    #   - Q101=Yes (absent from job) → Q130
    #   - has_job_description=1 (past job, Q101≠Yes) → Q131
    #   - past_job_path7=1 (PATH=7, worked within year) → Q131
    # NOT entered by PATH=1 (PDF Q130: "If PATH=1, go to 150")
    # =========================================================================
    - id: b_absence_separation
      title: "Absence and Separation"
      precondition:
        - predicate: q101_absent_from_job.outcome == 1 or has_job_description == 1 or past_job_path7 == 1
      items:
        # Q130: "What was the main reason you were absent from work last week?"
        # Only for Q101=Yes (currently absent from a job)
        # PDF routing:
        #   Temp layoff due to business → go to 134
        #   Seasonal layoff → go to 136
        #   Casual job → go to 137
        #   Otherwise → PATH = 2 and go to 150
        - id: q130_reason_absent
          kind: Question
          title: "What was the main reason you were absent from work last week?"
          precondition:
            - predicate: q101_absent_from_job.outcome == 1
          input:
            control: Radio
            labels:
              1: "Own illness or disability"
              2: "Caring for own children"
              3: "Caring for elder relative"
              4: "Maternity or parental leave"
              5: "Other personal or family responsibilities"
              6: "Vacation"
              7: "Labour dispute (strike or lockout)"
              8: "Temporary layoff due to business conditions"
              9: "Seasonal layoff"
              10: "Casual job, no work available"
              11: "Work schedule (shift work)"
              12: "Self-employed, no work available"
              13: "Seasonal business"
              14: "Other"
          codeBlock: |
            if q130_reason_absent.outcome != 8 and q130_reason_absent.outcome != 9 and q130_reason_absent.outcome != 10:
              path = 2

        # Q131: "What was the main reason you stopped working?"
        # For past job holders NOT currently absent
        # Also reached by PATH=7 from Q105 (via past_job_path7)
        - id: q131_reason_stopped
          kind: Question
          title: "What was the main reason you stopped working at that job or business?"
          precondition:
            - predicate: q101_absent_from_job.outcome != 1
          input:
            control: Radio
            labels:
              1: "Own illness or disability"
              2: "Caring for own children"
              3: "Caring for elder relative"
              4: "Pregnancy"
              5: "Other personal or family responsibilities"
              6: "Going to school"
              7: "Lost job, laid off or job ended"
              8: "Business sold or closed down"
              9: "Changed residence"
              10: "Dissatisfied with job"
              11: "Retired"
              12: "Other"

        # Q132: "Can you be more specific about the reason for job loss?"
        # PDF: "If PATH = 7, go to 137" — PATH=7 skips Q132
        # Only shown when Q131 = "Lost job" AND PATH != 7
        - id: q132_job_loss_detail
          kind: Question
          title: "Can you be more specific about the main reason for the job loss?"
          precondition:
            - predicate: q131_reason_stopped.outcome == 7
            - predicate: path != 7
          input:
            control: Radio
            labels:
              1: "End of seasonal job"
              2: "End of temporary, term or contract job"
              3: "Casual job"
              4: "Company moved"
              5: "Company went out of business"
              6: "Business conditions (not enough work, drop in orders)"
              7: "Dismissal by employer (fired)"
              8: "Other"

        # Q133: "Does he/she expect to return to that job?"
        # PDF: "If 'Business conditions' in Q132, go to 133. Otherwise go to 137."
        - id: q133_expect_return
          kind: Question
          title: "Do you expect to return to that job?"
          precondition:
            - predicate: q132_job_loss_detail.outcome == 6
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Not sure"

        # Q134: "Has your employer given you a date to return?"
        # Reached from: Q130=temp layoff (8) OR Q133=yes (1)
        - id: q134_given_return_date
          kind: Question
          title: "Has your employer given you a date to return?"
          precondition:
            - predicate: q130_reason_absent.outcome == 8 or q133_expect_return.outcome == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q135: "Has he/she been given any indication of recall within 6 months?"
        # Reached from: Q134 = No
        - id: q135_recall_indication
          kind: Question
          title: "Have you been given any indication that you will be recalled within the next 6 months?"
          precondition:
            - predicate: q134_given_return_date.outcome == 0
            - predicate: q130_reason_absent.outcome == 8 or q133_expect_return.outcome == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q136: "How many weeks on layoff?"
        # Reached from: Q130=seasonal (9), Q134→Q136, Q135→Q136
        # PDF Q136 PATH=3 logic:
        #   If Q130=seasonal → no PATH=3
        #   If Q134=no AND Q135=no → no PATH=3
        #   If layoff > 52 weeks → no PATH=3
        #   Otherwise → PATH=3
        - id: q136_weeks_on_layoff
          kind: Question
          title: "As of last week, how many weeks had you been on layoff?"
          precondition:
            - predicate: q130_reason_absent.outcome == 8 or q130_reason_absent.outcome == 9 or q133_expect_return.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 520
            right: "weeks"
          codeBlock: |
            if q130_reason_absent.outcome != 9:
              if q136_weeks_on_layoff.outcome <= 52:
                if q134_given_return_date.outcome == 1 or q135_recall_indication.outcome == 1:
                  path = 3

        # Q137: "Usually work 30+ hours per week?"
        # Reached by all paths through this block except PATH=2 (skip to Q150)
        # PDF: "If PATH=3, go to 190. Otherwise go to 170."
        - id: q137_usually_30plus
          kind: Question
          title: "Did you usually work 30 or more hours per week?"
          precondition:
            - predicate: path != 2
          input:
            control: Radio
            labels:
              1: "30 or more hours per week"
              2: "Less than 30 hours per week"

    # =========================================================================
    # BLOCK 5: Work Hours - Main Job (Q150-Q163)
    # Precondition: PATH 1 (at work) or PATH 2 (absent with job)
    # PDF Q151/Q152: "If PATH = 2, go to 158" — absent employees skip Q153-Q156
    # =========================================================================
    - id: b_work_hours
      title: "Work Hours (Main Job)"
      precondition:
        - predicate: path == 1 or path == 2
      items:
        # Q150: "Does the number of hours vary from week to week?"
        - id: q150_hours_vary
          kind: Question
          title: "Excluding overtime, does the number of hours you work vary from week to week?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q151: usual hours (fixed schedule)
        - id: q151_usual_hours
          kind: Question
          title: "Excluding overtime, how many hours do you usually work per week?"
          precondition:
            - predicate: q150_hours_vary.outcome == 0
          input:
            control: Editbox
            min: 0
            max: 168
            right: "hours"
          codeBlock: |
            usual_hours = q151_usual_hours.outcome

        # Q152: average hours (variable schedule)
        - id: q152_average_hours
          kind: Question
          title: "On average, how many hours do you usually work per week?"
          precondition:
            - predicate: q150_hours_vary.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 168
            right: "hours"
          codeBlock: |
            usual_hours = q152_average_hours.outcome

        # Q153: Hours away — EMPLOYEES AND PATH=1 ONLY
        # PDF Q151/Q152: "If PATH=2, go to 158" — PATH 2 employees skip Q153-Q156
        - id: q153_hours_away
          kind: Question
          title: "Last week, how many hours were you away from this job because of vacation, illness, or any other reason?"
          precondition:
            - predicate: is_employee == 1
            - predicate: path == 1
          input:
            control: Editbox
            min: 0
            max: 168
            right: "hours"
          codeBlock: |
            hours_away = q153_hours_away.outcome

        # Q154: Reason for absence
        - id: q154_absence_reason
          kind: Question
          title: "What was the main reason for that absence?"
          precondition:
            - predicate: q153_hours_away.outcome > 0
          input:
            control: Radio
            labels:
              1: "Own illness or disability"
              2: "Caring for own children"
              3: "Caring for elder relative"
              4: "Maternity or parental leave"
              5: "Other personal or family responsibilities"
              6: "Vacation"
              7: "Labour dispute (strike or lockout)"
              8: "Temporary layoff due to business conditions"
              9: "Holiday (legal or religious)"
              10: "Weather"
              11: "Job started or ended during week"
              12: "Working short-time (material shortage, plant maintenance)"
              13: "Other"

        # Q155: Paid overtime — EMPLOYEES AND PATH=1 ONLY
        - id: q155_paid_overtime
          kind: Question
          title: "Last week, how many hours of paid overtime did you work at this job?"
          precondition:
            - predicate: is_employee == 1
            - predicate: path == 1
          input:
            control: Editbox
            min: 0
            max: 168
            right: "hours"
          codeBlock: |
            paid_overtime = q155_paid_overtime.outcome

        # Q156: Unpaid extra hours — EMPLOYEES AND PATH=1 ONLY
        # CROSS-CHECK: actual_hours = usual - away + paid_overtime + unpaid_extra
        - id: q156_unpaid_extra
          kind: Question
          title: "Last week, how many extra hours without pay did you work at this job?"
          precondition:
            - predicate: is_employee == 1
            - predicate: path == 1
          input:
            control: Editbox
            min: 0
            max: 168
            right: "hours"
          codeBlock: |
            unpaid_extra = q156_unpaid_extra.outcome
          postcondition:
            - predicate: (usual_hours - hours_away + paid_overtime + unpaid_extra) >= 0
              hint: "Computed actual hours cannot be negative. Check hours away vs. usual hours."

        # Q157: Actual hours (self-employed AND PATH=1)
        - id: q157_actual_hours_self
          kind: Question
          title: "Last week, how many hours did you actually work at your job or business?"
          precondition:
            - predicate: is_self_employed == 1
            - predicate: path == 1
          input:
            control: Editbox
            min: 0
            max: 168
            right: "hours"

        # Q158: Full-time threshold
        # PDF: "If 151>=29.5 or 152>=29.5 and PATH=2, go to 162"
        # PDF: "If 151>=29.5 or 152>=29.5 and PATH=1, go to 200"
        # Only asked when usual hours < 30
        - id: q158_want_fulltime
          kind: Question
          title: "Do you want to work 30 or more hours per week at a single job?"
          precondition:
            - predicate: usual_hours < 30
            - predicate: usual_hours > 0
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q159: Why not want 30+ hours
        - id: q159_why_not_fulltime
          kind: Question
          title: "What is the main reason you do not want to work 30 or more hours per week?"
          precondition:
            - predicate: q158_want_fulltime.outcome == 0
          input:
            control: Radio
            labels:
              1: "Own illness or disability"
              2: "Caring for own children"
              3: "Caring for elder relative"
              4: "Other personal or family responsibilities"
              5: "Going to school"
              6: "Personal preference"
              7: "Other"

        # Q160: Why usually work less than 30 hours (wants full-time but can't get it)
        - id: q160_why_part_time
          kind: Question
          title: "What is the main reason you usually work less than 30 hours per week at your main job?"
          precondition:
            - predicate: q158_want_fulltime.outcome == 1
          input:
            control: Radio
            labels:
              1: "Own illness or disability"
              2: "Caring for own children"
              3: "Caring for elder relative"
              4: "Other personal or family responsibilities"
              5: "Going to school"
              6: "Business conditions"
              7: "Could not find work with 30 or more hours per week"
              8: "Other"

        # Q161: "Did he/she look for full-time work?"
        # Only when Q160 = business conditions OR couldn't find 30+ hours
        - id: q161_looked_fulltime
          kind: Question
          title: "At any time in the 4 weeks ending last Saturday, did you look for full-time work?"
          precondition:
            - predicate: q160_why_part_time.outcome == 6 or q160_why_part_time.outcome == 7
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q162: Weeks continuously absent (PATH 2 only)
        - id: q162_weeks_absent
          kind: Question
          title: "As of last week, how many weeks had you been continuously absent from work?"
          precondition:
            - predicate: path == 2
          input:
            control: Editbox
            min: 0
            max: 520
            right: "weeks"

        # Q163: Getting wages during absence
        # PDF: "If Employee OR (Self-employed AND incorporated), go to 163"
        - id: q163_getting_wages
          kind: Question
          title: "Are you getting any wages or salary from your employer for any time off last week?"
          precondition:
            - predicate: path == 2
            - predicate: is_employee == 1 or (is_self_employed == 1 and q111_incorporated.outcome == 1)
          input:
            control: Switch
            off: "No"
            on: "Yes"

    # =========================================================================
    # BLOCK 6: Job Search and Future Start (Q170-Q178)
    # Precondition: not employed (PATH not 1 or 2), not permanently unable (7)
    # PDF Q170: "If PATH = 7, go to 500"
    # =========================================================================
    - id: b_job_search
      title: "Job Search and Future Start"
      precondition:
        - predicate: path != 1
        - predicate: path != 2
        - predicate: path != 7
      items:
        # Q170: "Did you do anything to find work?"
        # PDF: If no and age>=65 → PATH=6, go to 500
        #       If no and age<=64 → go to 174
        #       If yes → PATH=4, go to 171
        - id: q170_looked_for_work
          kind: Question
          title: "In the 4 weeks ending last Saturday, did you do anything to find work?"
          input:
            control: Switch
            off: "No"
            on: "Yes"
          codeBlock: |
            if q170_looked_for_work.outcome == 1:
              path = 4
            elif q_age.outcome >= 65:
              path = 6

        # Q171: Search methods
        - id: q171_search_methods
          kind: Question
          title: "What did you do to find work in those 4 weeks? Did you do anything else to find work?"
          precondition:
            - predicate: q170_looked_for_work.outcome == 1
          input:
            control: Checkbox
            labels:
              1: "Public employment agency"
              2: "Private employment agency"
              4: "Union"
              8: "Employers directly"
              16: "Friends or relatives"
              32: "Placed or answered ads"
              64: "Looked at job ads"
              128: "Other"

        # Q172: Weeks looking
        - id: q172_weeks_looking
          kind: Question
          title: "As of last week, how many weeks had you been looking for work? (since the date last worked)"
          precondition:
            - predicate: q170_looked_for_work.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 520
            right: "weeks"

        # Q173: Main activity before looking
        - id: q173_activity_before
          kind: Question
          title: "What was your main activity before you started looking for work?"
          precondition:
            - predicate: q170_looked_for_work.outcome == 1
          input:
            control: Radio
            labels:
              1: "Working"
              2: "Managing a home"
              3: "Going to school"
              4: "Other"

        # Q174: Future job start
        # Precondition: didn't look for work AND age <= 64
        # PDF: "If no, then PATH = 6 and go to 176"
        - id: q174_future_job
          kind: Question
          title: "Last week, did you have a job to start at a definite date in the future?"
          precondition:
            - predicate: q170_looked_for_work.outcome == 0
            - predicate: q_age.outcome <= 64
          input:
            control: Switch
            off: "No"
            on: "Yes"
          codeBlock: |
            if q174_future_job.outcome == 0:
              path = 6

        # Q175: Start within 4 weeks?
        - id: q175_start_within_4weeks
          kind: Question
          title: "Will you start that job before or after 4 weeks from last Saturday?"
          precondition:
            - predicate: q174_future_job.outcome == 1
          input:
            control: Radio
            labels:
              1: "Before the date (within 4 weeks)"
              2: "On or after the date (4+ weeks)"
          codeBlock: |
            if q175_start_within_4weeks.outcome == 1:
              path = 5
            else:
              path = 6

        # Q176: Want a job?
        # Precondition: Q174 = No (no future job, PATH=6 already set)
        # PDF: "If no, go to 500" (with PATH=6)
        - id: q176_want_job
          kind: Question
          title: "Did you want a job last week?"
          precondition:
            - predicate: q174_future_job.outcome == 0
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q177: Want 30+ hours
        # Reached from Q173 (seekers, PATH=4) or Q176=Yes (non-seekers, PATH=6)
        - id: q177_want_30plus
          kind: Question
          title: "Did you want a job with 30 or more hours per week?"
          precondition:
            - predicate: q170_looked_for_work.outcome == 1 or q176_want_job.outcome == 1
          input:
            control: Radio
            labels:
              1: "30 or more hours per week"
              2: "Less than 30 hours per week"

        # Q178: Reason not looking
        # Precondition: didn't look (Q170=0) AND wants job (Q176=1)
        # PDF: "If PATH=4, go to 190. If 'Believes no work available', go to 190."
        # IMPORTANT: "Believes no work available" → availability check (discouraged worker)
        - id: q178_reason_not_looking
          kind: Question
          title: "What was the main reason you did not look for work last week?"
          precondition:
            - predicate: q170_looked_for_work.outcome == 0
            - predicate: q176_want_job.outcome == 1
          input:
            control: Radio
            labels:
              1: "Own illness or disability"
              2: "Caring for own children"
              3: "Caring for elder relative"
              4: "Other personal or family responsibilities"
              5: "Going to school"
              6: "Waiting for recall (to former employer)"
              7: "Waiting for replies from employers"
              8: "Believes no work available (in area, or suited to skills)"
              9: "No reason given"
              10: "Other"
          codeBlock: |
            if q178_reason_not_looking.outcome == 8:
              discouraged_worker = 1

    # =========================================================================
    # BLOCK 7: Availability (Q190-Q191)
    # Precondition: PATH 3 (temp layoff), 4 (job seeker), 5 (future start),
    #               or discouraged worker (PATH=6, "believes no work available")
    # PDF Q178: "If 'Believes no work available', go to 190"
    # =========================================================================
    - id: b_availability
      title: "Availability"
      precondition:
        - predicate: path == 3 or path == 4 or path == 5 or discouraged_worker == 1
      items:
        # Q190: "Could you have worked last week?"
        - id: q190_could_have_worked
          kind: Question
          title: "Could you have worked last week if a suitable job had been offered or if you had been recalled?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q191: "What was the main reason you were not available?"
        - id: q191_reason_unavailable
          kind: Question
          title: "What was the main reason you were not available to work last week?"
          precondition:
            - predicate: q190_could_have_worked.outcome == 0
          input:
            control: Radio
            labels:
              1: "Own illness or disability"
              2: "Caring for own children"
              3: "Caring for elder relative"
              4: "Other personal or family responsibilities"
              5: "Going to school"
              6: "Vacation"
              7: "Already has a job"
              8: "Other"

    # =========================================================================
    # BLOCK 8: Earnings, Union, and Permanence (Q200-Q241)
    # Precondition: PATH 1 or 2 (employed), employee only
    # PDF Q200: "If 110 is not Employee, go to 300"
    # =========================================================================
    - id: b_earnings
      title: "Earnings, Union Membership, and Job Permanence"
      precondition:
        - predicate: path == 1 or path == 2
        - predicate: is_employee == 1
      items:
        # Q200: "Is he/she paid by the hour?"
        - id: q200_paid_hourly
          kind: Question
          title: "At your job, are you paid by the hour?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q201: "Does he/she usually receive tips or commissions?"
        - id: q201_tips_commissions
          kind: Question
          title: "Do you usually receive tips or commissions?"
          precondition:
            - predicate: q200_paid_hourly.outcome == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q202: "What is the hourly rate of pay?"
        - id: q202_hourly_rate
          kind: Question
          title: "Including tips and commissions, what is your hourly rate of pay?"
          precondition:
            - predicate: q200_paid_hourly.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 500
            left: "$"
            right: "per hour"

        # Q204: "What is the easiest way to report your wage?"
        - id: q204_pay_period
          kind: Question
          title: "What is the easiest way for you to tell us your wage or salary, before taxes and other deductions?"
          precondition:
            - predicate: q200_paid_hourly.outcome == 0
          input:
            control: Radio
            labels:
              1: "Yearly"
              2: "Monthly"
              3: "Semi-monthly"
              4: "Bi-weekly"
              5: "Weekly"
              6: "Other"

        # Q205-Q209 combined: "What is the wage/salary for that period?"
        - id: q205_wage_amount
          kind: Question
          title: "What is your wage or salary for that period, before taxes and other deductions?"
          precondition:
            - predicate: q200_paid_hourly.outcome == 0
          input:
            control: Editbox
            min: 0
            max: 10000000
            left: "$"
            right: ""

        # Q220: "Is he/she a union member?"
        - id: q220_union_member
          kind: Question
          title: "Are you a union member at your employer?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q221: "Is he/she covered by a union contract?"
        - id: q221_union_covered
          kind: Question
          title: "Are you covered by a union contract or collective agreement?"
          precondition:
            - predicate: q220_union_member.outcome == 0
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q240: "Is the job permanent?"
        - id: q240_permanent
          kind: Question
          title: "Is your job permanent, or is there some way that it is not permanent? (for example, seasonal, temporary, term or casual)"
          input:
            control: Radio
            labels:
              1: "Permanent"
              2: "Not permanent"

        # Q241: "In what way is the job not permanent?"
        - id: q241_why_not_permanent
          kind: Question
          title: "In what way is your job not permanent?"
          precondition:
            - predicate: q240_permanent.outcome == 2
          input:
            control: Radio
            labels:
              1: "Seasonal job"
              2: "Temporary, term or contract job (non-seasonal)"
              3: "Casual job"
              4: "Other"

    # =========================================================================
    # BLOCK 9: Firm Size (Q260-Q262)
    # Precondition: PATH 1 or 2, employee
    # =========================================================================
    - id: b_firm_size
      title: "Firm Size"
      precondition:
        - predicate: path == 1 or path == 2
        - predicate: is_employee == 1
      items:
        # Q260
        - id: q260_employees_at_location
          kind: Question
          title: "About how many persons are employed at the location where you work?"
          input:
            control: Radio
            labels:
              1: "Less than 20"
              2: "20 to 99"
              3: "100 to 500"
              4: "Over 500"

        # Q261: "Does the employer operate at more than one location?"
        - id: q261_multiple_locations
          kind: Question
          title: "Does your employer operate at more than one location?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q262: "In total, how many persons at all locations?"
        # PDF: "If no, or 260 = Over 500, go to 300"
        - id: q262_total_employees
          kind: Question
          title: "In total, about how many persons are employed at all locations?"
          precondition:
            - predicate: q261_multiple_locations.outcome == 1
            - predicate: q260_employees_at_location.outcome != 4
          input:
            control: Radio
            labels:
              1: "Less than 20"
              2: "20 to 99"
              3: "100 to 500"
              4: "Over 500"

    # =========================================================================
    # BLOCK 10: Other Job Hours (Q300-Q321)
    # Precondition: PATH 1 AND had multiple jobs (Q102 = Yes)
    # PDF Q300: "If 102 = no, go to 400"
    # =========================================================================
    - id: b_other_job
      title: "Other Job or Business"
      precondition:
        - predicate: q102_multiple_jobs.outcome == 1
      items:
        # Q300: "Was he/she an employee or self-employed at the other job?"
        - id: q300_other_class
          kind: Question
          title: "At your other job or business, were you an employee or self-employed?"
          input:
            control: Radio
            labels:
              1: "Employee"
              2: "Self-employed"

        # Q301: "Did he/she have an incorporated business?" (other job, self-employed)
        - id: q301_other_incorporated
          kind: Question
          title: "Did you have an incorporated business at your other job?"
          precondition:
            - predicate: q300_other_class.outcome == 2
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q302: "Did he/she have any employees?" (other job, self-employed)
        - id: q302_other_employees
          kind: Question
          title: "Did you have any employees at your other job?"
          precondition:
            - predicate: q300_other_class.outcome == 2
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q320: "How many hours do you usually work at this other job?"
        - id: q320_other_usual_hours
          kind: Question
          title: "How many hours do you usually work per week at this other job or business?"
          input:
            control: Editbox
            min: 0
            max: 168
            right: "hours"

        # Q321: "Last week, how many hours did you actually work at this other job?"
        # PDF: "If PATH = 2, go to 400" — PATH 2 skips actual hours
        - id: q321_other_actual_hours
          kind: Question
          title: "Last week, how many hours did you actually work at this other job or business?"
          precondition:
            - predicate: path != 2
          input:
            control: Editbox
            min: 0
            max: 168
            right: "hours"

    # =========================================================================
    # BLOCK 11: Temporary Layoff Job Search (Q400)
    # Precondition: PATH 3 only (temporary layoff)
    # PDF Q400: "If PATH not 3, go to 500"
    # =========================================================================
    - id: b_layoff_search
      title: "Temporary Layoff Job Search"
      precondition:
        - predicate: path == 3
      items:
        # Q400
        - id: q400_looked_other_employer
          kind: Question
          title: "In the 4 weeks ending last Saturday, did you look for a job with a different employer?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

    # =========================================================================
    # BLOCK 12: School Attendance (Q500-Q521)
    # PDF Q500: "If age >= 65, go to END"
    # NOTE: No PATH exclusion — all paths reach Q500 eventually
    # =========================================================================
    - id: b_school
      title: "School Attendance"
      precondition:
        - predicate: q_age.outcome < 65
      items:
        # Q500
        - id: q500_attending_school
          kind: Question
          title: "Last week, were you attending a school, college or university?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q501
        - id: q501_enrollment_status
          kind: Question
          title: "Were you enrolled as a full-time or part-time student?"
          precondition:
            - predicate: q500_attending_school.outcome == 1
          input:
            control: Radio
            labels:
              1: "Full-time"
              2: "Part-time"

        # Q502
        - id: q502_type_of_school
          kind: Question
          title: "What kind of school was this?"
          precondition:
            - predicate: q500_attending_school.outcome == 1
          input:
            control: Radio
            labels:
              1: "Elementary, junior high school, high school or equivalent"
              2: "Community college, junior college, or CEGEP"
              3: "University"
              4: "Other"

        # Q520: "Was ... a full-time student in March of this year?"
        # PDF: only May-August, ages 15-24 (survey month can't be encoded in QML)
        - id: q520_fulltime_in_march
          kind: Question
          title: "Were you a full-time student in March of this year?"
          precondition:
            - predicate: q_age.outcome >= 15
            - predicate: q_age.outcome <= 24
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q521: "Does ... expect to be a full-time student this fall?"
        - id: q521_expect_student_fall
          kind: Question
          title: "Do you expect to be a full-time student this fall?"
          precondition:
            - predicate: q520_fulltime_in_march.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Not sure"

    # =========================================================================
    # BLOCK 13: Survey Completion
    # =========================================================================
    - id: b_completion
      title: "Survey Completion"
      items:
        - id: q_thank_you
          kind: Comment
          title: "Thank you for your participation in the Labour Force Survey."
