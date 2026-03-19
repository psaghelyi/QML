qmlVersion: "1.0"
questionnaire:
  title: "Basic CPS Items Booklet - Demographic Items"
  codeInit: |
    is_veteran = 0
    has_ged = 0
    has_some_college = 0
    has_cert = 0
    is_hispanic = 0
    hispanic_other = 0
    race_asian = 0
    race_pi = 0
    race_other = 0
    age_verified = 0
    has_par1 = 0
    has_par2 = 0
    is_nonrelative = 0
    is_subfam = 0
  blocks:
    - id: b_person_status
      title: "Person Status"
      items:
        - id: q_perstat
          kind: Question
          title: "Are all of these persons still living here? / Person status"
          input:
            control: Radio
            labels:
              1: "Person deceased"
              2: "Person moved out"
              3: "Person left - was a URE last month"
              4: "Delete person - to correct previous mistake"
              5: "Person is a URE this month"
              9: "Reinstate person"

    - id: b_household_roster
      title: "Household Roster"
      items:
        - id: q_fname
          kind: Question
          title: "What are the names of all persons living or staying here? / What is the name of the next person?"
          input:
            control: Textarea
            placeholder: "Enter first name (enter 999 if no more persons)"
            maxLength: 100

        - id: q_lname
          kind: Question
          title: "What is the last name of this person?"
          input:
            control: Textarea
            placeholder: "Enter last name"
            maxLength: 100

        - id: q_s_hhmem
          kind: Question
          title: "Is this person's usual place of residence?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Proxy"

        - id: q_ure
          kind: Question
          title: "Does this person have a usual place of residence elsewhere?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: q_sex
          kind: Question
          title: "What is this person's sex?"
          input:
            control: Radio
            labels:
              1: "Male"
              2: "Female"

        - id: q_nros2b
          kind: Question
          title: "Are there any other persons 15 years old or older now living or staying there who have not been listed?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: q_cnt2bg
          kind: Question
          title: "How many other persons 15 years old or older have not been listed?"
          precondition:
            - predicate: q_nros2b.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 20

        - id: q_mchild
          kind: Question
          title: "Have I missed any babies or small children?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: q_maway
          kind: Question
          title: "Have I missed anyone who usually lives here but is away now - traveling, at school, or in a hospital?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: q_mlodge
          kind: Question
          title: "Have I missed any lodgers, boarders, or persons you employ who live here?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: q_melse
          kind: Question
          title: "Have I missed anyone else staying here?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: q_ownren1
          kind: Question
          title: "What is the name of the person or one of the persons who owns or rents that home?"
          input:
            control: Dropdown
            labels:
              1: "Owner/Renter not a HH member"
              2: "Person 1's name"
              3: "Person 2's name"
              4: "Person 3's name"
              5: "Person 4's name"
              6: "Person 5's name"
              7: "Person 6's name"
              8: "Person 7's name"
              9: "Person 8's name"
              10: "Person 9's name"
              11: "Person 10's name"
              12: "Person 11's name"
              13: "Person 12's name"
              14: "Person 13's name"
              15: "Person 14's name"
              16: "Person 15's name"
              17: "Person 16's name"

    - id: b_respondent
      title: "Respondent Identification"
      items:
        - id: q_hhresp
          kind: Question
          title: "With whom am I speaking?"
          input:
            control: Dropdown
            labels:
              1: "Under_15"
              2: "Person 1's name"
              3: "Person 2's name"
              4: "Person 3's name"
              5: "Person 4's name"
              6: "Person 5's name"
              7: "Person 6's name"
              8: "Person 7's name"
              9: "Person 8's name"
              10: "Person 9's name"
              11: "Person 10's name"
              12: "Person 11's name"
              13: "Person 12's name"
              14: "Person 13's name"
              15: "Person 14's name"
              16: "Person 15's name"
              17: "Person 16's name"

        - id: q_hhresp_verify
          kind: Question
          title: "Are all persons under 15 years of age, or non-household members?"
          precondition:
            - predicate: q_hhresp.outcome == 1
          input:
            control: Radio
            labels:
              1: "Under 15 years of age"
              2: "Non-household members"

    - id: b_relationship
      title: "Relationship and Family"
      items:
        - id: q_s_rrp
          kind: Question
          title: "How is this person related to the reference person?"
          input:
            control: Dropdown
            labels:
              42: "Opposite-sex Spouse (Husband/Wife)"
              43: "Opposite-sex Unmarried Partner"
              44: "Same-sex Spouse (Husband/Wife)"
              45: "Same-sex Unmarried Partner"
              46: "Child"
              47: "Grandchild"
              48: "Parent (Mother/Father)"
              49: "Brother/Sister"
              50: "Other relative (Aunt, Cousin, Nephew, Mother-in-law, etc.)"
              51: "Foster Child"
              52: "Housemate/Roommate"
              53: "Roomer/Boarder"
              54: "Other nonrelative"
          codeBlock: |
            if q_s_rrp.outcome in [52, 53, 54]:
                is_nonrelative = 1

        - id: q_s_subfam
          kind: Question
          title: "Earlier you said this person was not related to the reference person. Is this person related to anyone else in this household?"
          precondition:
            - predicate: is_nonrelative == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
          codeBlock: |
            if q_s_subfam.outcome == 1:
                is_subfam = 1

        - id: q_subfam_who
          kind: Question
          title: "Who is this person related to in the household?"
          precondition:
            - predicate: is_nonrelative == 1
            - predicate: is_subfam == 1
          input:
            control: Dropdown
            labels:
              1: "Person 1's name"
              2: "Person 2's name"
              3: "Person 3's name"
              4: "Person 4's name"
              5: "Person 5's name"
              6: "Person 6's name"
              7: "Person 7's name"
              8: "Person 8's name"
              9: "Person 9's name"
              10: "Person 10's name"
              11: "Person 11's name"
              12: "Person 12's name"
              13: "Person 13's name"
              14: "Person 14's name"
              15: "Person 15's name"
              16: "Person 16's name"

        - id: q_par1
          kind: Question
          title: "Is this person's parent a member of this household? Enter the line number of the parent."
          input:
            control: Dropdown
            labels:
              0: "No_One"
              1: "Person1"
              2: "Person2"
              3: "Person3"
              4: "Person4"
              5: "Person5"
              6: "Person6"
              7: "Person7"
              8: "Person8"
              9: "Person9"
              10: "Person10"
              11: "Person11"
              12: "Person12"
              13: "Person13"
              14: "Person14"
              15: "Person15"
              16: "Person16"
          codeBlock: |
            if q_par1.outcome != 0:
                has_par1 = 1

        - id: q_par1typ
          kind: Question
          title: "Is this person a biological, step, or adopted child of the mother listed?"
          precondition:
            - predicate: has_par1 == 1
          input:
            control: Radio
            labels:
              1: "Biological"
              2: "Step"
              3: "Adopted"

        - id: q_par2
          kind: Question
          title: "Is this person's other parent a member of this household? Enter the line number of the other parent."
          input:
            control: Dropdown
            labels:
              0: "No_One"
              1: "Person1"
              2: "Person2"
              3: "Person3"
              4: "Person4"
              5: "Person5"
              6: "Person6"
              7: "Person7"
              8: "Person8"
              9: "Person9"
              10: "Person10"
              11: "Person11"
              12: "Person12"
              13: "Person13"
              14: "Person14"
              15: "Person15"
              16: "Person16"
          codeBlock: |
            if q_par2.outcome != 0:
                has_par2 = 1

        - id: q_par2typ
          kind: Question
          title: "Is this person a biological, step, or adopted child of the father listed?"
          precondition:
            - predicate: has_par2 == 1
          input:
            control: Radio
            labels:
              1: "Biological"
              2: "Step"
              3: "Adopted"

        - id: q_parent2
          kind: Question
          title: "The reference person's parent is also this person's parent, is that correct?"
          precondition:
            - predicate: has_par2 == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

    - id: b_birth_age
      title: "Date of Birth and Age"
      items:
        - id: q_birthm
          kind: Question
          title: "What is this person's date of birth? (Birth Month)"
          input:
            control: Dropdown
            labels:
              1: "Jan"
              2: "Feb"
              3: "Mar"
              4: "Apr"
              5: "May"
              6: "June"
              7: "July"
              8: "Aug"
              9: "Sept"
              10: "Oct"
              11: "Nov"
              12: "Dec"

        - id: q_birthd
          kind: Question
          title: "What is this person's date of birth? (Birth Day)"
          input:
            control: Editbox
            min: 1
            max: 31

        - id: q_birthy
          kind: Question
          title: "What is this person's date of birth? (Birth Year - enter 4 digit year, e.g. 1964)"
          input:
            control: Editbox
            min: 1900
            max: 2025

        - id: q_verify_age
          kind: Question
          title: "As of last week, that would make this person approximately (AGE) years old. Is that correct?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
          codeBlock: |
            if q_verify_age.outcome == 2:
                age_verified = 0
            else:
                age_verified = 1

        - id: q_agegss
          kind: Question
          title: "Even though you don't know the exact birthdate, what is your best guess as to how old this person was on their last birthday?"
          precondition:
            - predicate: q_verify_age.outcome == 2
          input:
            control: Editbox
            min: 0
            max: 99
            right: "years old (99 = 99 years or older)"

        - id: q_age2
          kind: Question
          title: "Is this person under 15?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

    - id: b_marital
      title: "Marital Status"
      items:
        - id: q_premartl
          kind: Question
          title: "Since our last interview, has any household member had any changes in his or her Marital Status?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: q_maritl
          kind: Question
          title: "Is this person now married, widowed, divorced, separated or never married?"
          input:
            control: Radio
            labels:
              1: "Married - Spouse PRESENT"
              2: "Married - Spouse ABSENT"
              3: "Widowed"
              4: "Divorced"
              5: "Separated"
              6: "Never married"

        - id: q_spouse
          kind: Question
          title: "What is the line number of this person's spouse in the household?"
          precondition:
            - predicate: q_maritl.outcome in [1, 2]
          input:
            control: Dropdown
            labels:
              0: "No_One"
              1: "Person1"
              2: "Person2"
              3: "Person3"
              4: "Person4"
              5: "Person5"
              6: "Person6"
              7: "Person7"
              8: "Person8"
              9: "Person9"
              10: "Person10"
              11: "Person11"
              12: "Person12"
              13: "Person13"
              14: "Person14"
              15: "Person15"
              16: "Person16"

        - id: q_cohab
          kind: Question
          title: "Do you have a boyfriend, girlfriend or partner in this household?"
          precondition:
            - predicate: q_maritl.outcome != 1
            - predicate: q_maritl.outcome != 2
          input:
            control: Dropdown
            labels:
              0: "No"
              1: "Person 1's name"
              2: "Person 2's name"
              3: "Person 3's name"
              4: "Person 4's name"
              5: "Person 5's name"
              6: "Person 6's name"
              7: "Person 7's name"
              8: "Person 8's name"
              9: "Person 9's name"
              10: "Person 10's name"
              11: "Person 11's name"
              12: "Person 12's name"
              13: "Person 13's name"
              14: "Person 14's name"
              15: "Person 15's name"
              16: "Person 16's name"

    - id: b_military
      title: "Military Service"
      items:
        - id: q_afever
          kind: Question
          title: "Did this person ever serve on active duty in the U.S. Armed Forces?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
          codeBlock: |
            if q_afever.outcome == 1:
                is_veteran = 1

        - id: q_afwhen
          kind: Question
          title: "When did this person serve on active duty in the U.S. Armed Forces? (Select all that apply)"
          precondition:
            - predicate: is_veteran == 1
          input:
            control: Checkbox
            labels:
              1: "September 2001 or later"
              2: "August 1990 to August 2001"
              4: "May 1975 to July 1990"
              8: "Vietnam Era (August 1964 to April 1975)"
              16: "February 1955 to July 1964"
              32: "Korean War (July 1950 to January 1955)"
              64: "January 1947 to June 1950"
              128: "World War II (December 1941 to December 1946)"
              256: "November 1941 or earlier"

        - id: q_afnow
          kind: Question
          title: "Is this person now/still in the Armed Forces?"
          precondition:
            - predicate: is_veteran == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

    - id: b_education
      title: "Education"
      items:
        - id: q_educa
          kind: Question
          title: "What is the highest level of school this person has completed or the highest degree received?"
          input:
            control: Dropdown
            labels:
              31: "Less than 1st grade"
              32: "1st, 2nd, 3rd or 4th grade"
              33: "5th or 6th grade"
              34: "7th or 8th grade"
              35: "9th grade"
              36: "10th grade"
              37: "11th grade"
              38: "12th grade NO DIPLOMA"
              39: "HIGH SCHOOL GRADUATE - high school DIPLOMA or the equivalent (e.g. GED)"
              40: "Some college but no degree"
              41: "Associate degree in college - Occupational/vocational program"
              42: "Associate degree in college - Academic program"
              43: "Bachelor's degree (e.g. BA, AB, BS)"
              44: "Master's degree (e.g. MA, MS, MEng, MEd, MSW, MBA)"
              45: "Professional School Degree (e.g. MD, DDS, DVM, LLB, JD)"
              46: "Doctorate degree (e.g. PhD, EdD)"
          codeBlock: |
            if q_educa.outcome == 39:
                has_ged = 1
            if q_educa.outcome >= 40:
                has_some_college = 1

        - id: q_dipged
          kind: Question
          title: "People can get a High School diploma in a variety of ways. How did this person get their High School diploma?"
          precondition:
            - predicate: has_ged == 1
          input:
            control: Radio
            labels:
              1: "Graduation from High School"
              2: "GED or other equivalent"

        - id: q_hgcomp
          kind: Question
          title: "What was the highest grade of regular school completed before receiving the GED?"
          precondition:
            - predicate: has_ged == 1
            - predicate: q_dipged.outcome == 2
          input:
            control: Radio
            labels:
              1: "Less than 1st grade"
              2: "1st, 2nd, 3rd or 4th grade"
              3: "5th or 6th grade"
              4: "7th or 8th grade"
              5: "9th grade"
              6: "10th grade"
              7: "11th grade"
              8: "12th grade NO DIPLOMA"

        - id: q_cyc
          kind: Question
          title: "How many years of college CREDIT has this person completed? (Including any time spent getting an Associate's Degree)"
          precondition:
            - predicate: has_some_college == 1
          input:
            control: Radio
            labels:
              1: "Less than 1 year (include 0 years completed)"
              2: "The first, or FRESHMAN year"
              3: "The second, or SOPHOMORE year"
              4: "The third, or JUNIOR year"
              5: "Four or more years"

        - id: q_cert1
          kind: Question
          title: "Does this person have a currently active professional certification or a state or industry license? (Do not include business licenses such as a liquor license or vending license.)"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
          codeBlock: |
            if q_cert1.outcome == 1:
                has_cert = 1

        - id: q_cert2
          kind: Question
          title: "Were any of this person's certifications or licenses issued by the federal, state, or local government?"
          precondition:
            - predicate: has_cert == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

    - id: b_ethnicity
      title: "Hispanic Origin"
      items:
        - id: q_hspnon
          kind: Question
          title: "Is this person of Hispanic, Latino, or Spanish origin?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
          codeBlock: |
            if q_hspnon.outcome == 1:
                is_hispanic = 1

        - id: q_orispn
          kind: Question
          title: "Is this person Mexican, Mexican American, or Chicano, Puerto Rican, Cuban, Cuban American, or another Hispanic, Latino, or Spanish origin group?"
          precondition:
            - predicate: is_hispanic == 1
          input:
            control: Radio
            labels:
              1: "Mexican"
              2: "Mexican American"
              3: "Chicano"
              4: "Puerto Rican"
              5: "Cuban"
              6: "Cuban-American"
              7: "Other Spanish, Hispanic, or Latino group"
          codeBlock: |
            if q_orispn.outcome == 7:
                hispanic_other = 1

        - id: q_s_orotsp
          kind: Question
          title: "What is the name of this person's other Spanish, Hispanic, or Latino group?"
          precondition:
            - predicate: is_hispanic == 1
            - predicate: hispanic_other == 1
          input:
            control: Textarea
            placeholder: "Specify other Spanish, Hispanic, or Latino group"
            maxLength: 200

        - id: q_orotss
          kind: Question
          title: "Please specify the other Spanish, Hispanic, or Latino group:"
          precondition:
            - predicate: is_hispanic == 1
            - predicate: hispanic_other == 1
          input:
            control: Textarea
            placeholder: "Specify Other Spanish, Hispanic, or Latino group"
            maxLength: 200

    - id: b_race
      title: "Race"
      items:
        - id: q_race
          kind: Question
          title: "I am going to read you a list of five race categories. You may choose one or more races. Is this person White; Black or African American; American Indian or Alaska Native; Asian; OR Native Hawaiian or Other Pacific Islander?"
          input:
            control: Checkbox
            labels:
              1: "White"
              2: "Black or African American"
              4: "American Indian or Alaska Native"
              8: "Asian"
              16: "Native Hawaiian or Other Pacific Islander"
              32: "Other"
          codeBlock: |
            if q_race.outcome % 16 >= 8:
                race_asian = 1
            if q_race.outcome % 32 >= 16:
                race_pi = 1
            if q_race.outcome % 64 >= 32:
                race_other = 1

        - id: q_raceas
          kind: Question
          title: "Which of the following Asian groups is this person? (Select all that apply)"
          precondition:
            - predicate: race_asian == 1
          input:
            control: Checkbox
            labels:
              1: "Asian Indian"
              2: "Chinese"
              4: "Filipino"
              8: "Japanese"
              16: "Korean"
              32: "Vietnamese"
              64: "Other Asian"

        - id: q_racepi
          kind: Question
          title: "Which of the following Native Hawaiian or Other Pacific Islander groups is this person? (Select all that apply)"
          precondition:
            - predicate: race_pi == 1
          input:
            control: Checkbox
            labels:
              1: "Native Hawaiian"
              2: "Guamanian or Chamorro"
              4: "Samoan"
              8: "Other Pacific Islander"

        - id: q_s_raceot
          kind: Comment
          title: "What is this person's race? (Read only if necessary)"
          precondition:
            - predicate: race_other == 1

        - id: q_raceos
          kind: Question
          title: "Please specify other race:"
          precondition:
            - predicate: race_other == 1
          input:
            control: Textarea
            placeholder: "Specify other race"
            maxLength: 200
