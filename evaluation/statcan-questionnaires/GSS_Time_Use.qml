qmlVersion: "1.0"
questionnaire:
  title: "General Social Survey, Cycle 2: Time Use (GSS 2-2)"
  codeInit: |
    # Language path routing variable set by Section F filter (p18)
    # 1=English-only (no other lang) -> Section T/U
    # 2=English (with other lang knowledge) -> Section G
    # 3=English and French -> Section H
    # 4=English and Other -> Section J
    # 5=French -> Section K
    # 6=French and Other -> Section L
    # 7=Other -> Section M
    lang_path = 0

    # Father path tracking
    # 0 = not yet determined
    # 1 = lived with father, working at job
    # 2 = did not live with father or father not working
    father_path = 0

    # Mother path tracking
    mother_path = 0

    # Education level tracking for Section P routing
    # 0=no schooling, 1=primary (1-8), 2=secondary (9-13), 3=post-secondary
    edu_level = 0

    # Whether respondent graduated secondary school
    graduated_secondary = 0

    # P1 years of schooling category for routing
    p1_category = 0

    # Section P job status: 1=employee, 2=self-employed, 3=never had full-time job
    p_job_status = 0

    # Section Q/U work status tracking
    q_work_status = 0

    # Section S/U telephone tracking
    phone_count = 0
    phone_same_number = 0

    # Section S/U religion tracking
    has_religion = 0

    # Section Q live alone flag
    q_live_alone = 0

    # Section Q home language count for N2 interviewer instruction
    home_lang_count = 0

    # N1 language count
    n1_lang_count = 0

    # French knowledge flags for G9 routing
    knows_french = 0
    knows_other_lang = 0

  blocks:
    # =========================================================================
    # SECTION A: Social Mobility (Respondent) — p6
    # =========================================================================
    - id: b_section_a
      title: "Section A: Social Mobility (Respondent)"
      items:
        - id: a_intro
          kind: Comment
          title: "For this part of the survey I would like you to recall certain aspects of your life from when you were born to when you were 15 years old."

        - id: a1_country_born
          kind: Question
          title: "In what country were you born?"
          input:
            control: Dropdown
            labels:
              1: "Canada - Newfoundland"
              2: "Canada - Prince Edward Island"
              3: "Canada - Nova Scotia"
              4: "Canada - New Brunswick"
              5: "Canada - Quebec"
              6: "Canada - Ontario"
              7: "Canada - Manitoba"
              8: "Canada - Saskatchewan"
              9: "Canada - Alberta"
              10: "Canada - British Columbia"
              11: "Canada - Yukon Territory"
              12: "Canada - Northwest Territories"
              13: "Country outside Canada"
          codeBlock: |
            if a1_country_born.outcome == 13:
                born_in_canada = 0
            else:
                born_in_canada = 1

        - id: a2_year_immigrated
          kind: Question
          title: "In what year did you first immigrate to Canada?"
          precondition:
            - predicate: born_in_canada == 0
          input:
            control: Editbox
            min: 1880
            max: 1986

        - id: a3_date_of_birth
          kind: Question
          title: "What is your date of birth? (Enter year)"
          input:
            control: Editbox
            min: 1866
            max: 1971

        - id: a4_same_community
          kind: Question
          title: "Did you live in the same community from birth up to age 15? By community I mean city, town or rural area."
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Don't know"
          codeBlock: |
            if a4_same_community.outcome == 1:
                a4_skip_to_a7 = 1
            elif a4_same_community.outcome == 3:
                a4_skip_to_b = 1
            else:
                a4_skip_to_a7 = 0
                a4_skip_to_b = 0

        # A4=Yes -> Go to A7; A4=Don't know -> Go to SECTION B
        - id: a5_num_communities
          kind: Question
          title: "In how many different communities did you live during this time?"
          precondition:
            - predicate: a4_same_community.outcome == 2
          input:
            control: Editbox
            min: 1
            max: 99

        - id: a6_years_longest
          kind: Question
          title: "Think about the community you lived in for the longest time from when you were born until you were 15 years old. For how many of those 15 years did you live there?"
          precondition:
            - predicate: a4_same_community.outcome == 2
          input:
            control: Editbox
            min: 0
            max: 15

        # A4=Yes goes to A7; A4=No goes through A5,A6 then to A7
        - id: a7_community_size
          kind: Question
          title: "What was the approximate size of that community?"
          precondition:
            - predicate: a4_same_community.outcome == 1 or a4_same_community.outcome == 2
          input:
            control: Radio
            labels:
              1: "Less than 5,000 population or a rural area"
              2: "5,000 to less than 25,000 population"
              3: "25,000 to less than 100,000 population"
              4: "100,000 to 1 million population"
              5: "Over 1 million population"

        - id: a8_place_canada
          kind: Question
          title: "Was this place in Canada or elsewhere?"
          precondition:
            - predicate: a4_same_community.outcome == 1 or a4_same_community.outcome == 2
          input:
            control: Radio
            labels:
              1: "In Canada"
              2: "Elsewhere"

    # =========================================================================
    # SECTION B: Social Mobility (Father) — p6-7
    # =========================================================================
    - id: b_section_b_father
      title: "Section B: Social Mobility (Respondent's Father)"
      items:
        - id: b1_lived_with_father
          kind: Question
          title: "When you were 15 years old, did you live with your own father? (Include adoptive father)"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
          codeBlock: |
            if b1_lived_with_father.outcome == 1:
                father_path = 1
            else:
                father_path = 0

        # B1=Yes -> Go to B4
        - id: b2_why_not_father
          kind: Question
          title: "Why was this? Was it because ..."
          precondition:
            - predicate: b1_lived_with_father.outcome == 2
          input:
            control: Radio
            labels:
              1: "Your father died"
              2: "Parents were divorced or separated"
              3: "You or your father were temporarily living away from home"
              4: "Other"
          codeBlock: |
            if b2_why_not_father.outcome == 3:
                father_path = 1

        # B2=Temporarily away -> Go to B4; otherwise check B3
        - id: b3_male_substitute
          kind: Question
          title: "During that time, was there a male who took the role of your father?"
          precondition:
            - predicate: b1_lived_with_father.outcome == 2 and b2_why_not_father.outcome != 3
          input:
            control: Switch
            on: "Yes"
            off: "No"
          codeBlock: |
            if b3_male_substitute.outcome == 0:
                father_path = 2

        # B4 is reached if: B1=Yes, or B2=Temporarily away, or B3=Yes
        - id: b4_father_activity
          kind: Question
          title: "Which of the following best describes your father's (or father substitute's) main activity when you were 15 years old?"
          precondition:
            - predicate: father_path == 1 or (b1_lived_with_father.outcome == 2 and b2_why_not_father.outcome != 3 and b3_male_substitute.outcome == 1)
          input:
            control: Radio
            labels:
              1: "Working at a job or business - Employee"
              2: "Working at a job or business - Self-employed"
              3: "A student"
              4: "Retired"
              5: "Keeping house"
              6: "Other"
          codeBlock: |
            if b4_father_activity.outcome == 1:
                father_job = 1
            elif b4_father_activity.outcome == 2:
                father_job = 2
            else:
                father_job = 0

        # B4=Employee -> Go to B5; B4=Self-employed -> Go to B6
        # B4=Student/Retired/Keeping house/Other -> Go to B8
        - id: b5_father_employer
          kind: Comment
          title: "For whom did he work? (Name of business, government department or agency or person)"
          precondition:
            - predicate: father_path == 1 and b4_father_activity.outcome == 1

        - id: b6_father_business
          kind: Comment
          title: "What was the main kind of business, industry or service?"
          precondition:
            - predicate: father_path == 1 and (b4_father_activity.outcome == 1 or b4_father_activity.outcome == 2)

        - id: b7_father_work_type
          kind: Comment
          title: "What kind of work was he doing?"
          precondition:
            - predicate: father_path == 1 and (b4_father_activity.outcome == 1 or b4_father_activity.outcome == 2)

        # B8 - all paths from B4 converge here (except B3=No -> B8 via Go to B8)
        - id: b8_father_education_years
          kind: Question
          title: "In total, how many years of elementary or secondary education did your father (or father substitute) complete?"
          precondition:
            - predicate: father_path == 1 or (b1_lived_with_father.outcome == 2 and b2_why_not_father.outcome != 3 and b3_male_substitute.outcome == 1)
          input:
            control: Radio
            labels:
              0: "No schooling"
              1: "1-6 years"
              2: "7-13 years"
              99: "Don't know"
          codeBlock: |
            if b8_father_education_years.outcome == 0:
                father_edu_skip = 1
            else:
                father_edu_skip = 0

        # B8=No schooling -> Go to B11
        - id: b9_father_further_schooling
          kind: Question
          title: "Did he have any further schooling beyond elementary/secondary school?"
          precondition:
            - predicate: b8_father_education_years.outcome != 0 and b8_father_education_years.outcome != 99
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Don't know"

        # B9=No or Don't know -> Go to B11
        - id: b10_father_highest_level
          kind: Question
          title: "What was the highest level he attained?"
          precondition:
            - predicate: b9_father_further_schooling.outcome == 1
          input:
            control: Radio
            labels:
              1: "Some community college, CEGEP or nursing school"
              2: "Diploma or certificate from community college, CEGEP or nursing school"
              3: "Some university"
              4: "Bachelor or undergraduate degree or teacher's college"
              5: "Master's or earned doctorate"
              6: "Other"
              7: "Don't know"

        - id: b11_father_country_born
          kind: Question
          title: "In what country was he born?"
          precondition:
            - predicate: father_path == 1 or (b1_lived_with_father.outcome == 2 and b2_why_not_father.outcome != 3 and b3_male_substitute.outcome == 1)
          input:
            control: Dropdown
            labels:
              1: "Canada - Newfoundland"
              2: "Canada - Prince Edward Island"
              3: "Canada - Nova Scotia"
              4: "Canada - New Brunswick"
              5: "Canada - Quebec"
              6: "Canada - Ontario"
              7: "Canada - Manitoba"
              8: "Canada - Saskatchewan"
              9: "Canada - Alberta"
              10: "Canada - British Columbia"
              11: "Canada - Yukon Territory"
              12: "Canada - Northwest Territories"
              13: "Country outside Canada"

        - id: b12_father_ethnic_group
          kind: Question
          title: "To which ethnic or cultural group did he belong?"
          precondition:
            - predicate: father_path == 1 or (b1_lived_with_father.outcome == 2 and b2_why_not_father.outcome != 3 and b3_male_substitute.outcome == 1)
          input:
            control: Radio
            labels:
              1: "English"
              2: "French"
              3: "Irish"
              4: "Scottish"
              5: "German"
              6: "Italian"
              7: "Ukrainian"
              8: "Other"
              9: "Don't know"

        - id: b13_father_first_language
          kind: Question
          title: "What was the first language he learned in childhood?"
          precondition:
            - predicate: father_path == 1 or (b1_lived_with_father.outcome == 2 and b2_why_not_father.outcome != 3 and b3_male_substitute.outcome == 1)
          input:
            control: Radio
            labels:
              1: "English"
              2: "French"
              3: "Other"
              4: "Don't know"

    # =========================================================================
    # SECTION B: Social Mobility (Mother) — p7-8
    # =========================================================================
    - id: b_section_b_mother
      title: "Section B: Social Mobility (Respondent's Mother)"
      items:
        - id: b14_lived_with_mother
          kind: Question
          title: "The next questions ask about your mother. When you were 15 years old, did you live with your own mother? (Include adoptive mother)"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
          codeBlock: |
            if b14_lived_with_mother.outcome == 1:
                mother_path = 1

        # B14=Yes -> Go to B17
        - id: b15_why_not_mother
          kind: Question
          title: "Why was this? Was it because ..."
          precondition:
            - predicate: b14_lived_with_mother.outcome == 2
          input:
            control: Radio
            labels:
              1: "Your mother died"
              2: "Parents were divorced or separated"
              3: "You or your mother were temporarily living away from home"
              4: "Other"
          codeBlock: |
            if b15_why_not_mother.outcome == 3:
                mother_path = 1

        - id: b16_female_substitute
          kind: Question
          title: "During that time, was there a female who took the role of your mother?"
          precondition:
            - predicate: b14_lived_with_mother.outcome == 2 and b15_why_not_mother.outcome != 3
          input:
            control: Switch
            on: "Yes"
            off: "No"
          codeBlock: |
            if b16_female_substitute.outcome == 0:
                mother_path = 2

        - id: b17_mother_activity
          kind: Question
          title: "Which of the following best describes your mother's (or mother substitute's) main activity when you were 15 years old?"
          precondition:
            - predicate: mother_path == 1 or (b14_lived_with_mother.outcome == 2 and b15_why_not_mother.outcome != 3 and b16_female_substitute.outcome == 1)
          input:
            control: Radio
            labels:
              1: "Working at a job or business - Employee"
              2: "Working at a job or business - Self-employed"
              3: "Keeping house"
              4: "A student"
              5: "Retired"
              6: "Other"
          codeBlock: |
            if b17_mother_activity.outcome == 1:
                mother_job = 1
            elif b17_mother_activity.outcome == 2:
                mother_job = 2
            else:
                mother_job = 0

        - id: b18_mother_employer
          kind: Comment
          title: "For whom did she work? (Name of business, government department or agency or person)"
          precondition:
            - predicate: mother_path == 1 and b17_mother_activity.outcome == 1

        - id: b19_mother_business
          kind: Comment
          title: "What was the main kind of business, industry or service?"
          precondition:
            - predicate: mother_path == 1 and (b17_mother_activity.outcome == 1 or b17_mother_activity.outcome == 2)

        - id: b20_mother_work_type
          kind: Comment
          title: "What kind of work was she doing?"
          precondition:
            - predicate: mother_path == 1 and (b17_mother_activity.outcome == 1 or b17_mother_activity.outcome == 2)

        - id: b21_mother_education_years
          kind: Question
          title: "In total, how many years of elementary or secondary education did your mother (or mother substitute) complete?"
          precondition:
            - predicate: mother_path == 1 or (b14_lived_with_mother.outcome == 2 and b15_why_not_mother.outcome != 3 and b16_female_substitute.outcome == 1)
          input:
            control: Radio
            labels:
              0: "No schooling"
              1: "1-6 years"
              2: "7-13 years"
              99: "Don't know"

        - id: b22_mother_further_schooling
          kind: Question
          title: "Did she have any further schooling beyond elementary/secondary school?"
          precondition:
            - predicate: b21_mother_education_years.outcome != 0 and b21_mother_education_years.outcome != 99
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Don't know"

        - id: b23_mother_highest_level
          kind: Question
          title: "What was the highest level she attained?"
          precondition:
            - predicate: b22_mother_further_schooling.outcome == 1
          input:
            control: Radio
            labels:
              1: "Some community college, CEGEP or nursing school"
              2: "Diploma or certificate from community college, CEGEP or nursing school"
              3: "Some university"
              4: "Bachelor or undergraduate degree or teacher's college"
              5: "Master's or earned doctorate"
              6: "Other"
              7: "Don't know"

        - id: b24_mother_country_born
          kind: Question
          title: "In what country was she born?"
          precondition:
            - predicate: mother_path == 1 or (b14_lived_with_mother.outcome == 2 and b15_why_not_mother.outcome != 3 and b16_female_substitute.outcome == 1)
          input:
            control: Dropdown
            labels:
              1: "Canada - Newfoundland"
              2: "Canada - Prince Edward Island"
              3: "Canada - Nova Scotia"
              4: "Canada - New Brunswick"
              5: "Canada - Quebec"
              6: "Canada - Ontario"
              7: "Canada - Manitoba"
              8: "Canada - Saskatchewan"
              9: "Canada - Alberta"
              10: "Canada - British Columbia"
              11: "Canada - Yukon Territory"
              12: "Canada - Northwest Territories"
              13: "Country outside Canada"

        - id: b25_mother_ethnic_group
          kind: Question
          title: "To which ethnic or cultural group did she belong?"
          precondition:
            - predicate: mother_path == 1 or (b14_lived_with_mother.outcome == 2 and b15_why_not_mother.outcome != 3 and b16_female_substitute.outcome == 1)
          input:
            control: Radio
            labels:
              1: "English"
              2: "French"
              3: "Irish"
              4: "Scottish"
              5: "German"
              6: "Italian"
              7: "Ukrainian"
              8: "Other"
              9: "Don't know"

        - id: b26_mother_first_language
          kind: Question
          title: "What was the first language she learned in childhood?"
          precondition:
            - predicate: mother_path == 1 or (b14_lived_with_mother.outcome == 2 and b15_why_not_mother.outcome != 3 and b16_female_substitute.outcome == 1)
          input:
            control: Radio
            labels:
              1: "English"
              2: "French"
              3: "Other"
              4: "Don't know"

        - id: b27_respondent_first_language
          kind: Question
          title: "What language did you yourself first speak in childhood?"
          input:
            control: Radio
            labels:
              1: "English"
              2: "French"
              3: "Other"

        - id: b28_brothers
          kind: Question
          title: "How many brothers have you ever had? (Include step, half- and adopted brothers and those no longer living)"
          input:
            control: Editbox
            min: 0
            max: 20

        - id: b29_sisters
          kind: Question
          title: "How many sisters have you ever had? (Include step, half- and adopted sisters and those no longer living)"
          input:
            control: Editbox
            min: 0
            max: 20

    # =========================================================================
    # SECTION D: Daily Activities — p9-16
    # Note: This is a time diary with 44 activity slots. Each slot records
    # activity, start time, end time, location, and companions.
    # In QML we model each slot as a group of questions.
    # For tractability, we model the day of week selection and a summary
    # question about number of activities recorded.
    # =========================================================================
    - id: b_section_d
      title: "Section D: Daily Activities"
      items:
        - id: d_day_of_week
          kind: Question
          title: "INTERVIEWER - Day to which activities refer:"
          input:
            control: Radio
            labels:
              1: "Sunday"
              2: "Monday"
              3: "Tuesday"
              4: "Wednesday"
              5: "Thursday"
              6: "Friday"
              7: "Saturday"

        - id: d_intro
          kind: Comment
          title: "These next questions ask about your daily activities. We need to know in as much detail as you can recall, what you did during the reference day starting at 4:00 o'clock in the morning."

        - id: d_num_activities
          kind: Question
          title: "How many distinct activities did you perform during the reference day? (Activities are recorded in slots 1-44, with additional forms if needed)"
          input:
            control: Editbox
            min: 1
            max: 99

    # =========================================================================
    # SECTION E: Well-being — p17
    # =========================================================================
    - id: b_section_e
      title: "Section E: Well-being"
      items:
        - id: e1_happiness
          kind: Question
          title: "Presently, would you describe yourself as ..."
          input:
            control: Radio
            labels:
              1: "Very happy"
              2: "Somewhat happy"
              3: "Somewhat unhappy"
              4: "Very unhappy"
              5: "No opinion"

        - id: e2_satisfaction
          kind: QuestionGroup
          title: "I am going to ask you to rate certain areas of your life. Please rate your feelings about them as very satisfied, somewhat satisfied, somewhat dissatisfied or very dissatisfied."
          questions:
            - "Your health"
            - "Your job or main activity"
            - "The way you spend your other time"
            - "Your finances"
            - "Your housing"
            - "Your friendships"
            - "Living partner or single status"
            - "Your relationship with other family members"
            - "Yourself (self-esteem)"
          input:
            control: Radio
            labels:
              1: "Very satisfied"
              2: "Somewhat satisfied"
              3: "Somewhat dissatisfied"
              4: "Very dissatisfied"
              5: "No opinion"

        - id: e3_life_satisfaction
          kind: Question
          title: "Now, using the same scale, how do you feel about your life as a whole right now?"
          input:
            control: Radio
            labels:
              1: "Very satisfied"
              2: "Somewhat satisfied"
              3: "Somewhat dissatisfied"
              4: "Very dissatisfied"
              5: "No opinion"

    # =========================================================================
    # SECTION F: Language Knowledge and Use (Filter) — p18
    # This is the critical routing section. F1 determines the language path.
    # =========================================================================
    - id: b_section_f
      title: "Section F: Language Knowledge and Use"
      items:
        - id: f_intro
          kind: Comment
          title: "The following questions are about your knowledge and use of languages at home, school and work."

        - id: f1_main_language
          kind: Question
          title: "What is your main language, that is, the language in which you are most at ease?"
          input:
            control: Radio
            labels:
              1: "English"
              2: "English and French"
              3: "English and Other"
              4: "French"
              5: "French and Other"
              6: "Other"
          codeBlock: |
            if f1_main_language.outcome == 1:
                lang_path = 0
            elif f1_main_language.outcome == 2:
                lang_path = 3
            elif f1_main_language.outcome == 3:
                lang_path = 4
            elif f1_main_language.outcome == 4:
                lang_path = 5
            elif f1_main_language.outcome == 5:
                lang_path = 6
            elif f1_main_language.outcome == 6:
                lang_path = 7

        # F1=English -> ask about other language knowledge
        - id: f1b_other_lang_knowledge
          kind: Question
          title: "Have you ever had any knowledge or understanding of a language other than English?"
          precondition:
            - predicate: f1_main_language.outcome == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"
          codeBlock: |
            if f1b_other_lang_knowledge.outcome == 1:
                lang_path = 2
            else:
                lang_path = 1

    # =========================================================================
    # SECTION G: Language (French knowledge for English speakers) — p18
    # Reached when F1=English AND has other language knowledge (lang_path=2)
    # =========================================================================
    - id: b_section_g
      title: "Section G: Language"
      items:
        - id: g1_french_knowledge
          kind: Question
          title: "Do you have any knowledge or understanding of French?"
          precondition:
            - predicate: lang_path == 2
          input:
            control: Switch
            on: "Yes"
            off: "No"
          codeBlock: |
            knows_french = g1_french_knowledge.outcome

        # G1=No -> Go to G6
        - id: g2_last_french_conversation
          kind: Question
          title: "When was the last time that you had a conversation in French, excluding language courses?"
          precondition:
            - predicate: lang_path == 2 and g1_french_knowledge.outcome == 1
          input:
            control: Radio
            labels:
              1: "During the last week"
              2: "During the last month"
              3: "During the last year"
              4: "More than a year"
              5: "Never"

        - id: g3_french_abilities
          kind: QuestionGroup
          title: "How would you rate yourself in the following language abilities in French?"
          precondition:
            - predicate: lang_path == 2 and g1_french_knowledge.outcome == 1
          questions:
            - "Reading"
            - "Understanding"
            - "Speaking"
          input:
            control: Radio
            labels:
              1: "Very good"
              2: "Good"
              3: "Not very good"
              4: "Not at all"

        - id: g4_french_knowledge_source
          kind: Question
          title: "What would you say contributed the most to your present knowledge of French?"
          precondition:
            - predicate: lang_path == 2 and g1_french_knowledge.outcome == 1
          input:
            control: Radio
            labels:
              1: "Language instruction at school"
              2: "Other language courses"
              3: "Speaking with family"
              4: "Speaking with friends"
              5: "Speaking at work"
              6: "Watching television"
              7: "Other"

        - id: g5_french_change
          kind: QuestionGroup
          title: "Compared to five years ago, would you say that you now ... more French, less French or about the same?"
          precondition:
            - predicate: lang_path == 2 and g1_french_knowledge.outcome == 1
          questions:
            - "Know"
            - "Use"
          input:
            control: Radio
            labels:
              1: "More"
              2: "Less"
              3: "Same"

        - id: g6_other_language
          kind: Question
          title: "Do you have any knowledge or understanding of a language other than English or French?"
          precondition:
            - predicate: lang_path == 2
          input:
            control: Switch
            on: "Yes"
            off: "No"
          codeBlock: |
            knows_other_lang = g6_other_language.outcome

        - id: g6b_how_many_other
          kind: Question
          title: "How many other languages do you know or understand?"
          precondition:
            - predicate: lang_path == 2 and g6_other_language.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 9

        - id: g7_other_lang_conversation
          kind: Question
          title: "When was the last time you had a conversation in that language (reported in G6), excluding language courses?"
          precondition:
            - predicate: lang_path == 2 and g6_other_language.outcome == 1
          input:
            control: Radio
            labels:
              1: "During the last week"
              2: "During the last month"
              3: "During the last year"
              4: "More than a year"
              5: "Never"

        - id: g8_other_lang_abilities
          kind: QuestionGroup
          title: "In that language (reported in G6), how would you rate yourself in the following abilities?"
          precondition:
            - predicate: lang_path == 2 and g6_other_language.outcome == 1
          questions:
            - "Reading"
            - "Understanding"
            - "Speaking"
          input:
            control: Radio
            labels:
              1: "Very good"
              2: "Good"
              3: "Not very good"
              4: "Not at all"

        # G9: INTERVIEWER: If "No" indicated in both G1 and G6, go to SECTION N
        - id: g9_routing
          kind: Comment
          title: "INTERVIEWER: If 'No' indicated in both G1 and G6, go to Section N (Page 17)."
          precondition:
            - predicate: lang_path == 2 and g1_french_knowledge.outcome == 0 and g6_other_language.outcome == 0

        - id: g10_english_use_change
          kind: Question
          title: "Compared to five years ago, would you say that you now use more English, less English or about the same?"
          precondition:
            - predicate: lang_path == 2 and (g1_french_knowledge.outcome == 1 or g6_other_language.outcome == 1)
          input:
            control: Radio
            labels:
              1: "More"
              2: "Less"
              3: "Same"

        # G11: INTERVIEWER: Go to SECTION N (Page 17)

    # =========================================================================
    # SECTION H: Language (English and French bilingual) — p19
    # Reached when F1=English and French (lang_path=3)
    # =========================================================================
    - id: b_section_h
      title: "Section H: Language"
      items:
        - id: h1_english_change
          kind: QuestionGroup
          title: "Compared to five years ago, would you say that you now ... more English, less English or about the same?"
          precondition:
            - predicate: lang_path == 3
          questions:
            - "Know"
            - "Use"
          input:
            control: Radio
            labels:
              1: "More"
              2: "Less"
              3: "Same"

        - id: h2_french_change
          kind: QuestionGroup
          title: "Compared to five years ago, would you say that you now ... more French, less French or about the same?"
          precondition:
            - predicate: lang_path == 3
          questions:
            - "Know"
            - "Use"
          input:
            control: Radio
            labels:
              1: "More"
              2: "Less"
              3: "Same"

        - id: h3_other_lang_knowledge
          kind: Question
          title: "Do you have any knowledge or understanding of a language other than English or French?"
          precondition:
            - predicate: lang_path == 3
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: h3b_how_many_other
          kind: Question
          title: "How many other languages do you know or understand?"
          precondition:
            - predicate: lang_path == 3 and h3_other_lang_knowledge.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 9

        # H3=No -> Go to SECTION N
        - id: h4_other_lang_conversation
          kind: Question
          title: "When was the last time you had a conversation in that language (reported in H3), excluding language courses?"
          precondition:
            - predicate: lang_path == 3 and h3_other_lang_knowledge.outcome == 1
          input:
            control: Radio
            labels:
              1: "During the last week"
              2: "During the last month"
              3: "During the last year"
              4: "More than a year"
              5: "Never"

        - id: h5_other_lang_abilities
          kind: QuestionGroup
          title: "In that language (reported in H3), how would you rate yourself in the following abilities?"
          precondition:
            - predicate: lang_path == 3 and h3_other_lang_knowledge.outcome == 1
          questions:
            - "Reading"
            - "Understanding"
            - "Speaking"
          input:
            control: Radio
            labels:
              1: "Very good"
              2: "Good"
              3: "Not very good"
              4: "Not at all"

        # H6: INTERVIEWER: Go to SECTION N (Page 17)

    # =========================================================================
    # SECTION J: Language (English and Other) — p19
    # Reached when F1=English and Other (lang_path=4)
    # =========================================================================
    - id: b_section_j
      title: "Section J: Language"
      items:
        - id: j1_english_change
          kind: QuestionGroup
          title: "Compared to five years ago, would you say that you now ... more English, less English or about the same?"
          precondition:
            - predicate: lang_path == 4
          questions:
            - "Know"
            - "Use"
          input:
            control: Radio
            labels:
              1: "More"
              2: "Less"
              3: "Same"

        - id: j2_french_knowledge
          kind: Question
          title: "Do you have any knowledge or understanding of French?"
          precondition:
            - predicate: lang_path == 4
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # J2=No -> Go to J7
        - id: j3_last_french_conversation
          kind: Question
          title: "When was the last time you had a conversation in French, excluding language courses?"
          precondition:
            - predicate: lang_path == 4 and j2_french_knowledge.outcome == 1
          input:
            control: Radio
            labels:
              1: "During the last week"
              2: "During the last month"
              3: "During the last year"
              4: "More than a year"
              5: "Never"

        - id: j4_french_abilities
          kind: QuestionGroup
          title: "How would you rate yourself in the following language abilities in French?"
          precondition:
            - predicate: lang_path == 4 and j2_french_knowledge.outcome == 1
          questions:
            - "Reading"
            - "Understanding"
            - "Speaking"
          input:
            control: Radio
            labels:
              1: "Very good"
              2: "Good"
              3: "Not very good"
              4: "Not at all"

        - id: j5_french_knowledge_source
          kind: Question
          title: "What would you say contributed the most to your present knowledge of French?"
          precondition:
            - predicate: lang_path == 4 and j2_french_knowledge.outcome == 1
          input:
            control: Radio
            labels:
              1: "Language instruction at school"
              2: "Other language courses"
              3: "Speaking with family"
              4: "Speaking with friends"
              5: "Speaking at work"
              6: "Watching television"
              7: "Other"

        - id: j6_french_change
          kind: QuestionGroup
          title: "Compared to five years ago, would you say that you now ... more French, less French or about the same?"
          precondition:
            - predicate: lang_path == 4 and j2_french_knowledge.outcome == 1
          questions:
            - "Know"
            - "Use"
          input:
            control: Radio
            labels:
              1: "More"
              2: "Less"
              3: "Same"

        - id: j7_other_languages_count
          kind: Question
          title: "Other than English or French, how many languages do you know or understand?"
          precondition:
            - predicate: lang_path == 4
          input:
            control: Editbox
            min: 0
            max: 9

        # J8: INTERVIEWER: Go to SECTION N (PAGE 17)

    # =========================================================================
    # SECTION K: Language (French only) — p20
    # Reached when F1=French (lang_path=5)
    # =========================================================================
    - id: b_section_k
      title: "Section K: Language"
      items:
        - id: k1_english_reading
          kind: Question
          title: "How would you rate your ability to read in English? Is it ..."
          precondition:
            - predicate: lang_path == 5
          input:
            control: Radio
            labels:
              1: "Very good"
              2: "Good"
              3: "Not very good"
              4: "Not at all"

        - id: k2_english_knowledge_source
          kind: Question
          title: "What would you say contributed the most to your present knowledge of English?"
          precondition:
            - predicate: lang_path == 5
          input:
            control: Radio
            labels:
              1: "Language instruction at school"
              2: "Other language courses"
              3: "Speaking with family"
              4: "Speaking with friends"
              5: "Speaking at work"
              6: "Watching television"
              7: "Other"

        - id: k3_english_change
          kind: QuestionGroup
          title: "Compared to five years ago, would you say that you now ... more English, less English or about the same?"
          precondition:
            - predicate: lang_path == 5
          questions:
            - "Know"
            - "Use"
          input:
            control: Radio
            labels:
              1: "More"
              2: "Less"
              3: "Same"

        - id: k4_other_lang_knowledge
          kind: Question
          title: "Do you have any knowledge or understanding of a language other than English or French?"
          precondition:
            - predicate: lang_path == 5
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: k4b_how_many_other
          kind: Question
          title: "How many other languages do you know or understand?"
          precondition:
            - predicate: lang_path == 5 and k4_other_lang_knowledge.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 9

        # K4=No -> Go to K7
        - id: k5_other_lang_conversation
          kind: Question
          title: "When was the last time you had a conversation in that language (reported in K4), excluding language courses?"
          precondition:
            - predicate: lang_path == 5 and k4_other_lang_knowledge.outcome == 1
          input:
            control: Radio
            labels:
              1: "During the last week"
              2: "During the last month"
              3: "During the last year"
              4: "More than a year"
              5: "Never"

        - id: k6_other_lang_abilities
          kind: QuestionGroup
          title: "In that language (reported in K4), how would you rate yourself in the following abilities?"
          precondition:
            - predicate: lang_path == 5 and k4_other_lang_knowledge.outcome == 1
          questions:
            - "Reading"
            - "Understanding"
            - "Speaking"
          input:
            control: Radio
            labels:
              1: "Very good"
              2: "Good"
              3: "Not very good"
              4: "Not at all"

        - id: k7_french_use_change
          kind: Question
          title: "Compared to five years ago, would you say that you now use more French, less French or about the same?"
          precondition:
            - predicate: lang_path == 5
          input:
            control: Radio
            labels:
              1: "More"
              2: "Less"
              3: "Same"

        # K8: INTERVIEWER: Go to SECTION N (PAGE 17)

    # =========================================================================
    # SECTION L: Language (French and Other) — p20
    # Reached when F1=French and Other (lang_path=6)
    # =========================================================================
    - id: b_section_l
      title: "Section L: Language"
      items:
        - id: l1_french_change
          kind: QuestionGroup
          title: "Compared to five years ago, would you say that you now ... more French, less French or about the same?"
          precondition:
            - predicate: lang_path == 6
          questions:
            - "Know"
            - "Use"
          input:
            control: Radio
            labels:
              1: "More"
              2: "Less"
              3: "Same"

        - id: l2_english_reading
          kind: Question
          title: "How would you rate your ability to read in English? Is it ..."
          precondition:
            - predicate: lang_path == 6
          input:
            control: Radio
            labels:
              1: "Very good"
              2: "Good"
              3: "Not very good"
              4: "Not at all"

        - id: l3_english_knowledge_source
          kind: Question
          title: "What would you say contributed the most to your present knowledge of English?"
          precondition:
            - predicate: lang_path == 6
          input:
            control: Radio
            labels:
              1: "Language instruction at school"
              2: "Other language courses"
              3: "Speaking with family"
              4: "Speaking with friends"
              5: "Speaking at work"
              6: "Watching television"
              7: "Other"

        - id: l4_english_change
          kind: QuestionGroup
          title: "Compared to five years ago, would you say that you now ... more English, less English or about the same?"
          precondition:
            - predicate: lang_path == 6
          questions:
            - "Know"
            - "Use"
          input:
            control: Radio
            labels:
              1: "More"
              2: "Less"
              3: "Same"

        - id: l5_other_languages_count
          kind: Question
          title: "Other than English or French, how many languages do you know or understand?"
          precondition:
            - predicate: lang_path == 6
          input:
            control: Editbox
            min: 0
            max: 9

        # L6: INTERVIEWER: Go to SECTION N (Page 17)

    # =========================================================================
    # SECTION M: Language (Other only) — p21
    # Reached when F1=Other (lang_path=7)
    # =========================================================================
    - id: b_section_m
      title: "Section M: Language"
      items:
        - id: m1_english_reading
          kind: Question
          title: "How would you rate your ability to read in English? Is it ..."
          precondition:
            - predicate: lang_path == 7
          input:
            control: Radio
            labels:
              1: "Very good"
              2: "Good"
              3: "Not very good"
              4: "Not at all"

        - id: m2_english_knowledge_source
          kind: Question
          title: "What would you say contributed the most to your present knowledge of English?"
          precondition:
            - predicate: lang_path == 7
          input:
            control: Radio
            labels:
              1: "Language instruction at school"
              2: "Other language courses"
              3: "Speaking with family"
              4: "Speaking with friends"
              5: "Speaking at work"
              6: "Watching television"
              7: "Other"

        - id: m3_english_change
          kind: QuestionGroup
          title: "Compared to five years ago, would you say that you now ... more English, less English or about the same?"
          precondition:
            - predicate: lang_path == 7
          questions:
            - "Know"
            - "Use"
          input:
            control: Radio
            labels:
              1: "More"
              2: "Less"
              3: "Same"

        - id: m4_french_knowledge
          kind: Question
          title: "Do you have any knowledge or understanding of French?"
          precondition:
            - predicate: lang_path == 7
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # M4=No -> Go to M9
        - id: m5_last_french_conversation
          kind: Question
          title: "When was the last time you had a conversation in French, excluding language courses?"
          precondition:
            - predicate: lang_path == 7 and m4_french_knowledge.outcome == 1
          input:
            control: Radio
            labels:
              1: "During the last week"
              2: "During the last month"
              3: "During the last year"
              4: "More than a year"
              5: "Never"

        - id: m6_french_abilities
          kind: QuestionGroup
          title: "How would you rate yourself in the following language abilities in French?"
          precondition:
            - predicate: lang_path == 7 and m4_french_knowledge.outcome == 1
          questions:
            - "Reading"
            - "Understanding"
            - "Speaking"
          input:
            control: Radio
            labels:
              1: "Very good"
              2: "Good"
              3: "Not very good"
              4: "Not at all"

        - id: m7_french_knowledge_source
          kind: Question
          title: "What would you say contributed the most to your present knowledge of French?"
          precondition:
            - predicate: lang_path == 7 and m4_french_knowledge.outcome == 1
          input:
            control: Radio
            labels:
              1: "Language instruction at school"
              2: "Other language courses"
              3: "Speaking with family"
              4: "Speaking with friends"
              5: "Speaking at work"
              6: "Watching television"
              7: "Other"

        - id: m8_french_change
          kind: QuestionGroup
          title: "Compared to five years ago, would you say that you now ... more French, less French or about the same?"
          precondition:
            - predicate: lang_path == 7 and m4_french_knowledge.outcome == 1
          questions:
            - "Know"
            - "Use"
          input:
            control: Radio
            labels:
              1: "More"
              2: "Less"
              3: "Same"

        - id: m9_other_languages_count
          kind: Question
          title: "Other than English or French, how many languages do you know or understand?"
          precondition:
            - predicate: lang_path == 7
          input:
            control: Editbox
            min: 0
            max: 9

    # =========================================================================
    # SECTION N: Language (Childhood and Adolescence) — p21
    # All language paths (G, H, J, K, L, M) converge here.
    # Also reached by lang_path=1 (English-only, no other lang) via Section T,
    # but Section T is the English-only variant that skips N entirely.
    # Section N is NOT reached by lang_path=1.
    # =========================================================================
    - id: b_section_n
      title: "Section N: Language Use in Childhood and Adolescence"
      items:
        - id: n_intro
          kind: Comment
          title: "The next questions ask about language use in childhood and adolescence."
          precondition:
            - predicate: lang_path >= 2 and lang_path <= 7

        - id: n1_home_languages_age6
          kind: Question
          title: "Before you were six years old, which languages were spoken in your home by people living there?"
          precondition:
            - predicate: lang_path >= 2 and lang_path <= 7
          input:
            control: Radio
            labels:
              1: "English"
              2: "French"
              3: "Other"
          codeBlock: |
            n1_lang_count = 1

        # N2: INTERVIEWER: If only one language reported in N1, go to N4
        - id: n3_languages_spoken_at_home
          kind: Question
          title: "Which languages did you yourself speak at home?"
          precondition:
            - predicate: lang_path >= 2 and lang_path <= 7 and n1_lang_count > 1
          input:
            control: Radio
            labels:
              1: "English"
              2: "French"
              3: "Other"

        - id: n3b_home_lang_90pct
          kind: Question
          title: "Did you speak this language at home more than 90% of the time?"
          precondition:
            - predicate: lang_path >= 2 and lang_path <= 7 and n1_lang_count > 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: n4_languages_age15
          kind: Question
          title: "When you were fifteen years old, which languages did you yourself speak at home?"
          precondition:
            - predicate: lang_path >= 2 and lang_path <= 7
          input:
            control: Radio
            labels:
              1: "English"
              2: "French"
              3: "Other"

        - id: n5_languages_with_friends
          kind: Question
          title: "At that time, which languages did you speak with your friends?"
          precondition:
            - predicate: lang_path >= 2 and lang_path <= 7
          input:
            control: Radio
            labels:
              1: "English"
              2: "French"
              3: "Other"

        # N6: INTERVIEWER: Go to SECTION P (Page 18)

    # =========================================================================
    # SECTION P: Social Mobility (Respondent's education and work) — p22
    # Reached by all language paths (Section N -> P) and
    # by lang_path=1 (Section T -> Section U, but U replaces P+S)
    # Section P is only for lang_path >= 2 (non-English-only paths)
    # =========================================================================
    - id: b_section_p
      title: "Section P: Social Mobility (Respondent's Education and Work)"
      items:
        - id: p1_education_years
          kind: Question
          title: "How many years of elementary and secondary education have you completed?"
          precondition:
            - predicate: lang_path >= 2 and lang_path <= 7
          input:
            control: Radio
            labels:
              0: "No schooling"
              1: "One to five years"
              2: "Six"
              3: "Seven"
              4: "Eight"
              5: "Nine"
              6: "Ten"
              7: "Eleven"
              8: "Twelve"
              9: "Thirteen"
          codeBlock: |
            if p1_education_years.outcome == 0:
                p1_category = 0
                edu_level = 0
            elif p1_education_years.outcome >= 1 and p1_education_years.outcome <= 4:
                p1_category = 1
                edu_level = 1
            elif p1_education_years.outcome >= 5 and p1_education_years.outcome <= 6:
                p1_category = 2
                edu_level = 2
            elif p1_education_years.outcome >= 7 and p1_education_years.outcome <= 9:
                p1_category = 3
                edu_level = 2

        # P1=No schooling -> Go to P14
        # P1=1-5 years or 6 or 7 or 8 -> ask language at primary school, then Go to P4
        # P1=9 or 10 -> Go to P2
        # P1=11 or 12 or 13 -> ask if graduated secondary school, then Go to P2

        - id: p1b_primary_school_language
          kind: Question
          title: "Which languages were used for teaching your courses at primary school, excluding language courses?"
          precondition:
            - predicate: lang_path >= 2 and lang_path <= 7 and p1_category == 1
          input:
            control: Radio
            labels:
              1: "English"
              2: "French"
              3: "Other"

        - id: p1c_graduated_secondary
          kind: Question
          title: "Have you graduated from secondary school?"
          precondition:
            - predicate: lang_path >= 2 and lang_path <= 7 and p1_category == 3
          input:
            control: Switch
            on: "Yes"
            off: "No"
          codeBlock: |
            graduated_secondary = p1c_graduated_secondary.outcome

        # P2: languages at primary school (for those with 9+ years)
        - id: p2_primary_language
          kind: Question
          title: "Which languages were used for teaching your courses at primary school, excluding language courses?"
          precondition:
            - predicate: lang_path >= 2 and lang_path <= 7 and (p1_category == 2 or p1_category == 3)
          input:
            control: Radio
            labels:
              1: "English"
              2: "French"
              3: "Other"

        - id: p3_secondary_language
          kind: Question
          title: "What about languages used for teaching your courses at secondary school, excluding language courses?"
          precondition:
            - predicate: lang_path >= 2 and lang_path <= 7 and (p1_category == 2 or p1_category == 3)
          input:
            control: Radio
            labels:
              1: "English"
              2: "French"
              3: "Other"

        - id: p4_further_schooling
          kind: Question
          title: "Have you had any further schooling beyond elementary/secondary school?"
          precondition:
            - predicate: lang_path >= 2 and lang_path <= 7 and p1_category >= 1
          input:
            control: Switch
            on: "Yes"
            off: "No"
          codeBlock: |
            if p4_further_schooling.outcome == 1:
                edu_level = 3

        # P4=No -> Go to P7
        - id: p5_post_secondary_language
          kind: Question
          title: "Which languages were/are used for teaching your courses at these levels, excluding language courses?"
          precondition:
            - predicate: lang_path >= 2 and lang_path <= 7 and p4_further_schooling.outcome == 1
          input:
            control: Radio
            labels:
              1: "English"
              2: "French"
              3: "Other"

        - id: p6_highest_level
          kind: Question
          title: "What is the highest level you attained?"
          precondition:
            - predicate: lang_path >= 2 and lang_path <= 7 and p4_further_schooling.outcome == 1
          input:
            control: Radio
            labels:
              1: "Some community college, CEGEP or nursing school"
              2: "Diploma or certificate from community college, CEGEP or nursing school"
              3: "Some university"
              4: "Bachelor or undergraduate degree or teacher's college"
              5: "Master's or earned doctorate"
              6: "Other"

        - id: p7_year_highest_education
          kind: Question
          title: "In which year did you reach your highest level of education?"
          precondition:
            - predicate: lang_path >= 2 and lang_path <= 7 and p1_category >= 1
          input:
            control: Editbox
            min: 1900
            max: 1986

        - id: p8_first_job_status
          kind: Question
          title: "Think about the first full-time job you had after reaching your highest level of education. Were you an employee working for someone else or self-employed?"
          precondition:
            - predicate: lang_path >= 2 and lang_path <= 7 and p1_category >= 1
          input:
            control: Radio
            labels:
              1: "An employee working for someone else"
              2: "Self-employed"
              3: "Never had a full-time job after this date"
          codeBlock: |
            p_job_status = p8_first_job_status.outcome

        # P8=Self-employed -> Go to P10; P8=Never -> Go to P13
        - id: p9_employer
          kind: Comment
          title: "For whom did you work? (Name of business, government department or agency or person)"
          precondition:
            - predicate: lang_path >= 2 and lang_path <= 7 and p_job_status == 1

        - id: p10_business_type
          kind: Comment
          title: "What was the main kind of business, industry or service?"
          precondition:
            - predicate: lang_path >= 2 and lang_path <= 7 and (p_job_status == 1 or p_job_status == 2)

        - id: p11_work_type
          kind: Comment
          title: "What kind of work were you doing?"
          precondition:
            - predicate: lang_path >= 2 and lang_path <= 7 and (p_job_status == 1 or p_job_status == 2)

        - id: p12_year_started_job
          kind: Question
          title: "In what year did you begin working at this job?"
          precondition:
            - predicate: lang_path >= 2 and lang_path <= 7 and (p_job_status == 1 or p_job_status == 2)
          input:
            control: Editbox
            min: 1900
            max: 1986

        - id: p13_language_courses_fulltime
          kind: Question
          title: "Have you ever taken any language courses as part of full-time school?"
          precondition:
            - predicate: lang_path >= 2 and lang_path <= 7
          input:
            control: Radio
            labels:
              1: "Yes - English"
              2: "Yes - French"
              3: "Yes - Other"
              4: "No"

        - id: p14_language_courses_outside
          kind: Question
          title: "Have you ever taken any language courses outside of full-time school?"
          precondition:
            - predicate: lang_path >= 2 and lang_path <= 7
          input:
            control: Radio
            labels:
              1: "Yes - English"
              2: "Yes - French"
              3: "Yes - Other"
              4: "No"

    # =========================================================================
    # SECTION Q: Language and Background Characteristics — p23-24
    # For all non-English-only paths (lang_path >= 2)
    # =========================================================================
    - id: b_section_q
      title: "Section Q: Language and Background Characteristics"
      items:
        - id: q1_home_languages
          kind: Question
          title: "Think about the people you live with. Which languages do you speak amongst yourselves at home?"
          precondition:
            - predicate: lang_path >= 2 and lang_path <= 7
          input:
            control: Radio
            labels:
              1: "Live alone"
              2: "English"
              3: "French"
              4: "Other"
          codeBlock: |
            if q1_home_languages.outcome == 1:
                q_live_alone = 1
                home_lang_count = 0
            else:
                q_live_alone = 0
                home_lang_count = 1

        # Q1=Live alone -> Go to Q4
        # Q2: INTERVIEWER: If only one language reported in Q1, go to Q4
        - id: q3_languages_speak_at_home
          kind: Question
          title: "Which languages do you yourself speak at home?"
          precondition:
            - predicate: lang_path >= 2 and lang_path <= 7 and q_live_alone == 0 and home_lang_count > 1
          input:
            control: Radio
            labels:
              1: "English"
              2: "French"
              3: "Other"

        - id: q3b_home_lang_90pct
          kind: Question
          title: "Do you speak this language at home more than 90% of the time?"
          precondition:
            - predicate: lang_path >= 2 and lang_path <= 7 and q_live_alone == 0 and home_lang_count > 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q4_languages_with_friends
          kind: Question
          title: "Which languages do you yourself speak with your friends outside your home?"
          precondition:
            - predicate: lang_path >= 2 and lang_path <= 7
          input:
            control: Radio
            labels:
              1: "English"
              2: "French"
              3: "Other"

        - id: q5_main_activity_7days
          kind: Question
          title: "Which of the following best describes your main activity during the last 7 days? Were you mainly ..."
          precondition:
            - predicate: lang_path >= 2 and lang_path <= 7
          input:
            control: Radio
            labels:
              1: "Working at a job or business"
              2: "Looking for work"
              3: "A student"
              4: "Keeping house"
              5: "Retired"
              6: "Other"

        - id: q6_main_activity_12months
          kind: Question
          title: "What about your main activity during the last 12 months? Were you mainly ..."
          precondition:
            - predicate: lang_path >= 2 and lang_path <= 7
          input:
            control: Radio
            labels:
              1: "Working at a job or business"
              2: "Looking for work"
              3: "A student"
              4: "Keeping house"
              5: "Retired"
              6: "Other"
          codeBlock: |
            if q6_main_activity_12months.outcome == 1:
                q_work_status = 1
            else:
                q_work_status = 0

        # Q6=Working -> Go to Q8
        - id: q7_had_job_12months
          kind: Question
          title: "Did you have a job at any time during the last 12 months?"
          precondition:
            - predicate: lang_path >= 2 and lang_path <= 7 and q_work_status == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"
          codeBlock: |
            if q7_had_job_12months.outcome == 1:
                q_work_status = 2
            else:
                q_work_status = 0

        # Q7=No -> Go to SECTION R
        - id: q8_weeks_worked
          kind: Question
          title: "For how many weeks of those 12 months did you do any work at a job or business? (Include vacation, illness, strikes, lock-outs and paid maternity leave)"
          precondition:
            - predicate: lang_path >= 2 and lang_path <= 7 and (q_work_status == 1 or q_work_status == 2)
          input:
            control: Editbox
            min: 0
            max: 52

        - id: q9_employment_type
          kind: Question
          title: "During those weeks of work were you mainly ..."
          precondition:
            - predicate: lang_path >= 2 and lang_path <= 7 and (q_work_status == 1 or q_work_status == 2)
          input:
            control: Radio
            labels:
              1: "An employee working for someone else"
              2: "Self-employed"
          codeBlock: |
            if q9_employment_type.outcome == 2:
                q9_self_employed = 1
            else:
                q9_self_employed = 0

        # Q9=Self-employed -> Go to Q12
        - id: q10_fulltime_parttime
          kind: Question
          title: "During those weeks of work were you mostly full-time or part-time?"
          precondition:
            - predicate: lang_path >= 2 and lang_path <= 7 and (q_work_status == 1 or q_work_status == 2) and q9_self_employed == 0
          input:
            control: Radio
            labels:
              1: "Full-time"
              2: "Part-time"

        - id: q11_employer
          kind: Comment
          title: "For whom do you/did you last work? (Name of business, government department or agency or person)"
          precondition:
            - predicate: lang_path >= 2 and lang_path <= 7 and (q_work_status == 1 or q_work_status == 2) and q9_self_employed == 0

        - id: q12_business_type
          kind: Comment
          title: "What was the main kind of business, industry or service?"
          precondition:
            - predicate: lang_path >= 2 and lang_path <= 7 and (q_work_status == 1 or q_work_status == 2)

        - id: q13_work_type
          kind: Comment
          title: "What kind of work were you doing?"
          precondition:
            - predicate: lang_path >= 2 and lang_path <= 7 and (q_work_status == 1 or q_work_status == 2)

        - id: q14_languages_at_work
          kind: Question
          title: "Which languages are/were spoken at work by people with whom you have/had regular contact?"
          precondition:
            - predicate: lang_path >= 2 and lang_path <= 7 and (q_work_status == 1 or q_work_status == 2)
          input:
            control: Radio
            labels:
              1: "English"
              2: "French"
              3: "Other"

        - id: q15_languages_spoken_at_work
          kind: Question
          title: "Considering the last 12 months, which languages have you yourself spoken at work?"
          precondition:
            - predicate: lang_path >= 2 and lang_path <= 7 and (q_work_status == 1 or q_work_status == 2)
          input:
            control: Radio
            labels:
              1: "English"
              2: "French"
              3: "Other"

        - id: q15b_work_lang_90pct
          kind: Question
          title: "Did you speak this language at work more than 90% of the time?"
          precondition:
            - predicate: lang_path >= 2 and lang_path <= 7 and (q_work_status == 1 or q_work_status == 2)
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: q16_writing_at_work
          kind: Question
          title: "During the last 12 months have you done any writing at work?"
          precondition:
            - predicate: lang_path >= 2 and lang_path <= 7 and (q_work_status == 1 or q_work_status == 2)
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # Q16=No -> Go to SECTION R
        - id: q17_writing_languages
          kind: Question
          title: "Over this period, which languages did you yourself use for writing at work?"
          precondition:
            - predicate: lang_path >= 2 and lang_path <= 7 and (q_work_status == 1 or q_work_status == 2) and q16_writing_at_work.outcome == 1
          input:
            control: Radio
            labels:
              1: "English"
              2: "French"
              3: "Other"

        - id: q17b_writing_lang_90pct
          kind: Question
          title: "Did you use this language for writing at work more than 90% of the time?"
          precondition:
            - predicate: lang_path >= 2 and lang_path <= 7 and (q_work_status == 1 or q_work_status == 2) and q16_writing_at_work.outcome == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # =========================================================================
    # SECTION R: Federal Government Contact (Full version) — p25
    # For non-English-only paths (lang_path >= 2)
    # =========================================================================
    - id: b_section_r
      title: "Section R: Contact with Federal Government"
      items:
        - id: r_intro
          kind: Comment
          title: "The next questions ask about contacts you have had with federal government agencies during the last 12 months."
          precondition:
            - predicate: lang_path >= 2 and lang_path <= 7

        - id: r1_federal_contacts
          kind: QuestionGroup
          title: "During this period, have you talked with employees of the following federal agencies in connection with the services they provide?"
          precondition:
            - predicate: lang_path >= 2 and lang_path <= 7
          questions:
            - "Post Office (excluding letter carriers)"
            - "Canada Employment or Immigration Centres"
            - "Old age security or family allowance"
            - "National parks"
            - "Federal personal income tax"
            - "Customs, at border crossings only"
            - "R.C.M.P."
            - "Air Canada"
            - "Agriculture Canada"
            - "Via Rail or CN Marine"
            - "Federal Public Service Commission"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # R2-R5 are sub-questions for each agency contacted (complex matrix)
        # Simplified: ask about language of service and preferred language
        - id: r2_service_language
          kind: Question
          title: "In your last contact with these federal agencies, in which language did you obtain service?"
          precondition:
            - predicate: lang_path >= 2 and lang_path <= 7
          input:
            control: Radio
            labels:
              1: "English"
              2: "French"
              3: "Other"

        - id: r3_preferred_language
          kind: Question
          title: "Was this your preferred language?"
          precondition:
            - predicate: lang_path >= 2 and lang_path <= 7
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: r6_federal_services_available
          kind: Question
          title: "Would you say that, in your area, federal services are generally available in your preferred official language?"
          precondition:
            - predicate: lang_path >= 2 and lang_path <= 7
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Don't know"

        - id: r7_tv_languages
          kind: Question
          title: "In which languages are the television programs you watch?"
          precondition:
            - predicate: lang_path >= 2 and lang_path <= 7
          input:
            control: Radio
            labels:
              0: "Never watch television"
              1: "English"
              2: "French"
              3: "Other"

        - id: r7b_tv_lang_90pct
          kind: Question
          title: "Do you watch programs in this language more than 90% of the time?"
          precondition:
            - predicate: lang_path >= 2 and lang_path <= 7 and r7_tv_languages.outcome != 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: r8_doctor_language
          kind: Question
          title: "Which language did the doctor use during your last visit?"
          precondition:
            - predicate: lang_path >= 2 and lang_path <= 7
          input:
            control: Radio
            labels:
              1: "Never visited doctor"
              2: "English"
              3: "French"
              4: "Other"

    # =========================================================================
    # SECTION S: Background Characteristics (Full version) — p26
    # For non-English-only paths (lang_path >= 2)
    # =========================================================================
    - id: b_section_s
      title: "Section S: Background Characteristics"
      items:
        - id: s1_ethnic_group
          kind: Question
          title: "To which ethnic or cultural group do you or did your ancestors belong?"
          precondition:
            - predicate: lang_path >= 2 and lang_path <= 7
          input:
            control: Radio
            labels:
              1: "English"
              2: "French"
              3: "Irish"
              4: "Scottish"
              5: "German"
              6: "Italian"
              7: "Ukrainian"
              8: "Other"
              9: "Don't know"

        - id: s2_religion
          kind: Question
          title: "What, if any, is your religion?"
          precondition:
            - predicate: lang_path >= 2 and lang_path <= 7
          input:
            control: Radio
            labels:
              0: "No religion"
              1: "Roman Catholic"
              2: "United Church"
              3: "Anglican"
              4: "Presbyterian"
              5: "Lutheran"
              6: "Baptist"
              7: "Eastern Orthodox"
              8: "Jewish"
              9: "Other"
          codeBlock: |
            if s2_religion.outcome == 0:
                has_religion = 0
            else:
                has_religion = 1

        # S2=No religion -> Go to S4
        - id: s3_religious_attendance
          kind: Question
          title: "Other than on special occasions, such as weddings, funerals or baptisms, how often do you attend services or meetings connected with your religion?"
          precondition:
            - predicate: lang_path >= 2 and lang_path <= 7 and has_religion == 1
          input:
            control: Radio
            labels:
              1: "At least once a week"
              2: "At least once a month"
              3: "At least once a year"
              4: "Less than once a year"
              5: "Never"

        - id: s4_community_size
          kind: Question
          title: "What is the approximate size of the community in which you are now living? By community I mean city, town or rural area."
          precondition:
            - predicate: lang_path >= 2 and lang_path <= 7
          input:
            control: Radio
            labels:
              1: "Less than 5,000 population or a rural area"
              2: "5,000 to less than 25,000 population"
              3: "25,000 to less than 100,000 population"
              4: "100,000 to 1 million population"
              5: "Over 1 million population"

        - id: s7_dwelling_type
          kind: Question
          title: "In what type of dwelling are you now living? Is it ..."
          precondition:
            - predicate: lang_path >= 2 and lang_path <= 7
          input:
            control: Radio
            labels:
              1: "Single detached house"
              2: "Semi-detached or double (side-by-side)"
              3: "Garden house, town-house or row house"
              4: "Duplex (one above the other)"
              5: "Low-rise apartment (less than five stories)"
              6: "High-rise apartment (five or more stories)"
              7: "Other"

        - id: s8_owned_rented
          kind: Question
          title: "Is this dwelling owned or rented by a member of this household?"
          precondition:
            - predicate: lang_path >= 2 and lang_path <= 7
          input:
            control: Radio
            labels:
              1: "Owned"
              2: "Rented"

        - id: s9_telephones
          kind: Question
          title: "How many telephones, counting extensions, are there in your dwelling?"
          precondition:
            - predicate: lang_path >= 2 and lang_path <= 7
          input:
            control: Radio
            labels:
              1: "One"
              2: "Two or more"
          codeBlock: |
            phone_count = s9_telephones.outcome

        # S9=One -> Go to S14
        - id: s10_same_number
          kind: Question
          title: "Do all the telephones have the same number?"
          precondition:
            - predicate: lang_path >= 2 and lang_path <= 7 and phone_count == 2
          input:
            control: Switch
            on: "Yes"
            off: "No"
          codeBlock: |
            phone_same_number = s10_same_number.outcome

        # S10=Yes -> Go to S14
        - id: s11_different_numbers
          kind: Question
          title: "How many different numbers are there?"
          precondition:
            - predicate: lang_path >= 2 and lang_path <= 7 and phone_count == 2 and phone_same_number == 0
          input:
            control: Editbox
            min: 2
            max: 10

        - id: s12_business_numbers
          kind: Question
          title: "Are any of these numbers for business use only?"
          precondition:
            - predicate: lang_path >= 2 and lang_path <= 7 and phone_count == 2 and phone_same_number == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # S12=No -> Go to S14
        - id: s13_business_phone_count
          kind: Question
          title: "How many are for business use only?"
          precondition:
            - predicate: lang_path >= 2 and lang_path <= 7 and phone_count == 2 and phone_same_number == 0 and s12_business_numbers.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 10

        - id: s14_personal_income
          kind: Question
          title: "What was your income before taxes, from wages, salaries and self-employment during the last 12 months?"
          precondition:
            - predicate: lang_path >= 2 and lang_path <= 7
          input:
            control: Radio
            labels:
              1: "Has income"
              2: "Has loss"
              3: "No income"
              4: "Don't know"

        - id: s15_government_income
          kind: Question
          title: "What was your income from government sources such as Family Allowance, U.I.C., Social Assistance, Canada or Quebec Pension Plan or Old Age Security?"
          precondition:
            - predicate: lang_path >= 2 and lang_path <= 7
          input:
            control: Radio
            labels:
              1: "Has amount"
              2: "No income"
              3: "Don't know"

        - id: s16_investment_income
          kind: Question
          title: "What was your income from investments or private pensions?"
          precondition:
            - predicate: lang_path >= 2 and lang_path <= 7
          input:
            control: Radio
            labels:
              1: "Has income"
              2: "Has loss"
              3: "No income"
              4: "Don't know"

        - id: s17_household_income
          kind: Question
          title: "What is your best estimate of the total income of all household members from all sources during the last 12 months?"
          precondition:
            - predicate: lang_path >= 2 and lang_path <= 7
          input:
            control: Radio
            labels:
              1: "Less than $10,000"
              2: "$10,000 to less than $20,000"
              3: "$20,000 to less than $40,000"
              4: "$40,000 and more"
              5: "No income"
              6: "Don't know"

    # =========================================================================
    # SECTION T: Language (English-only path — Federal gov't contact) — p27
    # Reached when F1=English AND No other language knowledge (lang_path=1)
    # This is the English-only variant of Section R
    # =========================================================================
    - id: b_section_t
      title: "Section T: Contact with Federal Government (English)"
      items:
        - id: t_intro
          kind: Comment
          title: "The next few questions are about contacts you have had with federal government agencies during the last 12 months."
          precondition:
            - predicate: lang_path == 1

        - id: t1_federal_contacts
          kind: QuestionGroup
          title: "During this period, have you talked with employees of the following federal agencies in connection with the services they provide?"
          precondition:
            - predicate: lang_path == 1
          questions:
            - "Post Office (excluding letter carriers)"
            - "Canada Employment or Immigration Centres"
            - "Old age security or family allowance"
            - "National Parks"
            - "Federal personal income tax"
            - "Customs, at border crossings only"
            - "R.C.M.P."
            - "Air Canada"
            - "Agriculture Canada"
            - "Via Rail or CN Marine"
            - "Federal Public Service Commission"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: t2_service_in_english
          kind: Question
          title: "Did you obtain service in English for all these contacts?"
          precondition:
            - predicate: lang_path == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # T2=Yes -> Go to T4
        # T2=No -> Which ones? then T3
        - id: t3_asked_for_english
          kind: Question
          title: "Did you ask for service in English?"
          precondition:
            - predicate: lang_path == 1 and t2_service_in_english.outcome == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: t4_federal_services_available
          kind: Question
          title: "Would you say that, in your area, federal services are generally available in English?"
          precondition:
            - predicate: lang_path == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Don't know"

        - id: t5_tv_languages
          kind: Question
          title: "In which languages are the television programs you watch?"
          precondition:
            - predicate: lang_path == 1
          input:
            control: Radio
            labels:
              0: "Never watch television"
              1: "English"
              2: "French"
              3: "Other"

        - id: t5b_tv_lang_90pct
          kind: Question
          title: "Do you watch programs in this language more than 90% of the time?"
          precondition:
            - predicate: lang_path == 1 and t5_tv_languages.outcome != 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: t6_doctor_language
          kind: Question
          title: "Which language did the doctor use during your last visit?"
          precondition:
            - predicate: lang_path == 1
          input:
            control: Radio
            labels:
              1: "Never visited doctor"
              2: "English"
              3: "French"
              4: "Other"

    # =========================================================================
    # SECTION U: Background Characteristics (English-only variant) — p28-30
    # Reached when lang_path=1 (English-only).
    # This combines education/work (like Section P) + background (like Section S)
    # =========================================================================
    - id: b_section_u
      title: "Section U: Background Characteristics (English)"
      items:
        - id: u1_education_years
          kind: Question
          title: "How many years of elementary and secondary education have you completed?"
          precondition:
            - predicate: lang_path == 1
          input:
            control: Radio
            labels:
              0: "No schooling"
              1: "One to five years"
              2: "Six"
              3: "Seven"
              4: "Eight"
              5: "Nine"
              6: "Ten"
              7: "Eleven"
              8: "Twelve"
              9: "Thirteen"
          codeBlock: |
            if u1_education_years.outcome == 0:
                u_edu_level = 0
            elif u1_education_years.outcome >= 1 and u1_education_years.outcome <= 6:
                u_edu_level = 1
            else:
                u_edu_level = 2

        # U1=No schooling -> Go to U12
        # U1=1-10 -> Go to U3
        # U1=11-13 -> U2 (graduated secondary?)
        - id: u2_graduated_secondary
          kind: Question
          title: "Have you graduated from secondary school?"
          precondition:
            - predicate: lang_path == 1 and u1_education_years.outcome >= 7
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: u3_further_schooling
          kind: Question
          title: "Have you had any further schooling beyond elementary/secondary school?"
          precondition:
            - predicate: lang_path == 1 and u_edu_level >= 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # U3=No -> Go to U5
        - id: u4_highest_level
          kind: Question
          title: "What was the highest level you attained?"
          precondition:
            - predicate: lang_path == 1 and u3_further_schooling.outcome == 1
          input:
            control: Radio
            labels:
              1: "Some community college, CEGEP or nursing school"
              2: "Diploma or certificate from community college, CEGEP or nursing school"
              3: "Some university"
              4: "Bachelor or undergraduate degree or teacher's college"
              5: "Master's or earned doctorate"
              6: "Other"

        - id: u5_year_highest_education
          kind: Question
          title: "In which year did you reach your highest level of education?"
          precondition:
            - predicate: lang_path == 1 and u_edu_level >= 1
          input:
            control: Editbox
            min: 1900
            max: 1986

        - id: u6_first_job_status
          kind: Question
          title: "Think about the first full-time job you had after reaching your highest level of education. Were you an employee working for someone else or self-employed?"
          precondition:
            - predicate: lang_path == 1 and u_edu_level >= 1
          input:
            control: Radio
            labels:
              1: "An employee working for someone else"
              2: "Self-employed"
              3: "Never had a full-time job after this date"
          codeBlock: |
            if u6_first_job_status.outcome == 1:
                u_job_status = 1
            elif u6_first_job_status.outcome == 2:
                u_job_status = 2
            else:
                u_job_status = 3

        # U6=Self-employed -> Go to U8; U6=Never -> Go to U11
        - id: u7_employer
          kind: Comment
          title: "For whom did you work? (Name of business, government department or agency or person)"
          precondition:
            - predicate: lang_path == 1 and u_job_status == 1

        - id: u8_business_type
          kind: Comment
          title: "What was the main kind of business, industry or service?"
          precondition:
            - predicate: lang_path == 1 and (u_job_status == 1 or u_job_status == 2)

        - id: u9_work_type
          kind: Comment
          title: "What kind of work were you doing?"
          precondition:
            - predicate: lang_path == 1 and (u_job_status == 1 or u_job_status == 2)

        - id: u10_year_started_job
          kind: Question
          title: "In what year did you begin working at this job?"
          precondition:
            - predicate: lang_path == 1 and (u_job_status == 1 or u_job_status == 2)
          input:
            control: Editbox
            min: 1900
            max: 1986

        - id: u11_lang_courses_fulltime
          kind: Question
          title: "Have you ever taken any language courses as part of full-time school?"
          precondition:
            - predicate: lang_path == 1
          input:
            control: Radio
            labels:
              1: "Yes - English"
              2: "Yes - French"
              3: "Yes - Other"
              4: "No"

        - id: u12_lang_courses_outside
          kind: Question
          title: "Have you ever taken any language courses outside of full-time school?"
          precondition:
            - predicate: lang_path == 1
          input:
            control: Radio
            labels:
              1: "Yes - English"
              2: "Yes - French"
              3: "Yes - Other"
              4: "No"

        - id: u13_religion
          kind: Question
          title: "What, if any, is your religion?"
          precondition:
            - predicate: lang_path == 1
          input:
            control: Radio
            labels:
              0: "No religion"
              1: "Roman Catholic"
              2: "United Church"
              3: "Anglican"
              4: "Presbyterian"
              5: "Lutheran"
              6: "Baptist"
              7: "Eastern Orthodox"
              8: "Jewish"
              9: "Other"
          codeBlock: |
            if u13_religion.outcome == 0:
                u_has_religion = 0
            else:
                u_has_religion = 1

        # U13=No religion -> Go to U15
        - id: u14_religious_attendance
          kind: Question
          title: "Other than on special occasions, such as weddings, funerals or baptisms, how often do you attend services or meetings connected with your religion?"
          precondition:
            - predicate: lang_path == 1 and u_has_religion == 1
          input:
            control: Radio
            labels:
              1: "At least once a week"
              2: "At least once a month"
              3: "At least once a year"
              4: "Less than once a year"
              5: "Never"

        - id: u15_ethnic_group
          kind: Question
          title: "To which ethnic or cultural group do you or did your ancestors belong?"
          precondition:
            - predicate: lang_path == 1
          input:
            control: Radio
            labels:
              1: "English"
              2: "French"
              3: "Irish"
              4: "Scottish"
              5: "German"
              6: "Italian"
              7: "Ukrainian"
              8: "Other"
              9: "Don't know"

        - id: u16_community_size
          kind: Question
          title: "What is the approximate size of the community in which you are now living?"
          precondition:
            - predicate: lang_path == 1
          input:
            control: Radio
            labels:
              1: "Less than 5,000 population or a rural area"
              2: "5,000 to less than 25,000 population"
              3: "25,000 to less than 100,000 population"
              4: "100,000 to 1 million population"
              5: "Over 1 million population"

        - id: u19_dwelling_type
          kind: Question
          title: "In what type of dwelling are you now living? Is it ..."
          precondition:
            - predicate: lang_path == 1
          input:
            control: Radio
            labels:
              1: "Single detached house"
              2: "Semi-detached or double (side-by-side)"
              3: "Garden house, town-house or row house"
              4: "Duplex (one above the other)"
              5: "Low-rise apartment (less than five stories)"
              6: "High-rise apartment (five or more stories)"
              7: "Other"

        - id: u20_owned_rented
          kind: Question
          title: "Is this dwelling owned or rented by a member of this household?"
          precondition:
            - predicate: lang_path == 1
          input:
            control: Radio
            labels:
              1: "Owned"
              2: "Rented"

        - id: u21_home_languages
          kind: Question
          title: "Is there a language, other than English, spoken in your home by the people living there?"
          precondition:
            - predicate: lang_path == 1
          input:
            control: Radio
            labels:
              1: "Person lives alone"
              2: "Yes - French"
              3: "Yes - Other"
              4: "No"

        - id: u22_telephones
          kind: Question
          title: "How many telephones, counting extensions, are there in your dwelling?"
          precondition:
            - predicate: lang_path == 1
          input:
            control: Radio
            labels:
              1: "One"
              2: "Two or more"
          codeBlock: |
            if u22_telephones.outcome == 1:
                u_phone_count = 1
            else:
                u_phone_count = 2

        # U22=One -> Go to U27
        - id: u23_same_number
          kind: Question
          title: "Do all the telephones have the same number?"
          precondition:
            - predicate: lang_path == 1 and u_phone_count == 2
          input:
            control: Switch
            on: "Yes"
            off: "No"
          codeBlock: |
            u_same_number = u23_same_number.outcome

        # U23=Yes -> Go to U27
        - id: u24_different_numbers
          kind: Question
          title: "How many different numbers are there?"
          precondition:
            - predicate: lang_path == 1 and u_phone_count == 2 and u_same_number == 0
          input:
            control: Editbox
            min: 2
            max: 10

        - id: u25_business_numbers
          kind: Question
          title: "Are any of these numbers for business use only?"
          precondition:
            - predicate: lang_path == 1 and u_phone_count == 2 and u_same_number == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # U25=No -> Go to U27
        - id: u26_business_phone_count
          kind: Question
          title: "How many are for business use only?"
          precondition:
            - predicate: lang_path == 1 and u_phone_count == 2 and u_same_number == 0 and u25_business_numbers.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 10

        - id: u27_main_activity_7days
          kind: Question
          title: "Which of the following best describes your main activity during the last 7 days? Were you mainly ..."
          precondition:
            - predicate: lang_path == 1
          input:
            control: Radio
            labels:
              1: "Working at a job or business"
              2: "Looking for work"
              3: "A student"
              4: "Keeping house"
              5: "Retired"
              6: "Other"

        - id: u28_main_activity_12months
          kind: Question
          title: "What about your main activity during the last 12 months? Were you mainly ..."
          precondition:
            - predicate: lang_path == 1
          input:
            control: Radio
            labels:
              1: "Working at a job or business"
              2: "Looking for work"
              3: "A student"
              4: "Keeping house"
              5: "Retired"
              6: "Other"
          codeBlock: |
            if u28_main_activity_12months.outcome == 1:
                u_work_status = 1
            else:
                u_work_status = 0

        # U28=Working -> Go to U31
        - id: u29_had_job_12months
          kind: Question
          title: "Did you have a job at any time during the last 12 months?"
          precondition:
            - predicate: lang_path == 1 and u_work_status == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"
          codeBlock: |
            if u29_had_job_12months.outcome == 1:
                u_work_status = 2

        # U29=No -> income questions
        - id: u30_personal_income
          kind: Question
          title: "Did you have any income from wages, salaries and self-employment during the last 12 months?"
          precondition:
            - predicate: lang_path == 1 and u_work_status == 0
          input:
            control: Radio
            labels:
              1: "Yes - Income"
              2: "Yes - Loss"
              3: "No income"
              4: "Don't know"

        - id: u31_weeks_worked
          kind: Question
          title: "For how many weeks of those 12 months did you do any work at a job or business?"
          precondition:
            - predicate: lang_path == 1 and (u_work_status == 1 or u_work_status == 2)
          input:
            control: Editbox
            min: 0
            max: 52

        - id: u32_employment_type
          kind: Question
          title: "During those weeks of work were you mainly ..."
          precondition:
            - predicate: lang_path == 1 and (u_work_status == 1 or u_work_status == 2)
          input:
            control: Radio
            labels:
              1: "An employee working for someone else"
              2: "Self-employed"
          codeBlock: |
            if u32_employment_type.outcome == 2:
                u_self_employed = 1
            else:
                u_self_employed = 0

        # U32=Self-employed -> Go to U35
        - id: u33_fulltime_parttime
          kind: Question
          title: "During those weeks of work were you mostly full-time or part-time?"
          precondition:
            - predicate: lang_path == 1 and (u_work_status == 1 or u_work_status == 2) and u_self_employed == 0
          input:
            control: Radio
            labels:
              1: "Full-time"
              2: "Part-time"

        - id: u34_employer
          kind: Comment
          title: "For whom do you/did you last work? (Name of business, government department or agency or person)"
          precondition:
            - predicate: lang_path == 1 and (u_work_status == 1 or u_work_status == 2) and u_self_employed == 0

        - id: u35_business_type
          kind: Comment
          title: "What was the main kind of business, industry or service?"
          precondition:
            - predicate: lang_path == 1 and (u_work_status == 1 or u_work_status == 2)

        - id: u36_work_type
          kind: Comment
          title: "What kind of work were you doing?"
          precondition:
            - predicate: lang_path == 1 and (u_work_status == 1 or u_work_status == 2)

        - id: u37_languages_at_work
          kind: Question
          title: "Which languages are/were spoken at work by people with whom you have/had regular contact?"
          precondition:
            - predicate: lang_path == 1 and (u_work_status == 1 or u_work_status == 2)
          input:
            control: Radio
            labels:
              1: "English"
              2: "French"
              3: "Other"

        - id: u38_personal_income
          kind: Question
          title: "What was your income before taxes from wages, salaries and self-employment during the last 12 months?"
          precondition:
            - predicate: lang_path == 1 and (u_work_status == 1 or u_work_status == 2)
          input:
            control: Radio
            labels:
              1: "Income"
              2: "Loss"
              3: "No income"
              4: "Don't know"

        - id: u39_government_income
          kind: Question
          title: "What was your income from government sources such as Family Allowance, U.I.C., Social Assistance, Canada or Quebec Pension Plan or Old Age Security?"
          precondition:
            - predicate: lang_path == 1
          input:
            control: Radio
            labels:
              1: "Has amount"
              2: "No income"
              3: "Don't know"

        - id: u40_investment_income
          kind: Question
          title: "What was your income from investments or private pensions?"
          precondition:
            - predicate: lang_path == 1
          input:
            control: Radio
            labels:
              1: "Income"
              2: "Loss"
              3: "No income"
              4: "Don't know"

        - id: u41_household_income
          kind: Question
          title: "What is your best estimate of the total income of all household members from all sources during the last 12 months?"
          precondition:
            - predicate: lang_path == 1
          input:
            control: Radio
            labels:
              1: "Less than $10,000"
              2: "$10,000 to less than $20,000"
              3: "$20,000 to less than $40,000"
              4: "$40,000 and more"
              5: "No income"
              6: "Don't know"
