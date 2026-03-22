# Basic CPS Items Booklet -- Demographic Items: Question Inventory

## Document Overview
- **Title**: Basic CPS Items Booklet -- Demographic Items
- **Organization**: U.S. Census Bureau, Current Population Survey (CPS)
- **Date**: Undated (current CPS cycle)
- **Pages**: 14
- **Language**: English
- **Type**: CATI interviewer-administered household demographics booklet
- **QML File**: `evaluation/reference-questionnaires/Demographics.qml`

## Structure
The booklet is a flat field enumeration of demographic variables collected per person in a household roster loop. It contains no explicit routing instructions -- all skip logic is implicit in the CATI system. The QML conversion organizes the 51 items into 10 blocks:

- **Block 1** -- Person Status (roster maintenance)
- **Block 2** -- Household Roster (person enumeration, missed-person probes, tenure)
- **Block 3** -- Respondent Identification (who is answering)
- **Block 4** -- Relationship and Family (relationship to reference person, subfamily, parents)
- **Block 5** -- Date of Birth and Age (birth date, age verification)
- **Block 6** -- Marital Status (marital status, spouse/partner identification)
- **Block 7** -- Military Service (veteran status, service periods)
- **Block 8** -- Education (attainment, diploma type, college years, certifications)
- **Block 9** -- Hispanic Origin (Hispanic ethnicity, specific origin group)
- **Block 10** -- Race (multi-race selection, Asian/Pacific Islander/Other detail)

## Question Inventory by Block

### Block 1 -- Person Status (b_person_status) - 1 question

1. Q_PERSTAT (q_perstat): Are all of these persons still living here? / Person status - Radio: (1) Person deceased; (2) Person moved out; (3) Person left - was a URE last month; (4) Delete person - to correct previous mistake; (5) Person is a URE this month; (9) Reinstate person [ALWAYS; no precondition]

### Block 2 -- Household Roster (b_household_roster) - 11 questions

2. Q_FNAME (q_fname): What are the names of all persons living or staying here? / What is the name of the next person? - Textarea: free text, max 100 chars; placeholder "Enter first name (enter 999 if no more persons)" [ALWAYS; no precondition]

3. Q_LNAME (q_lname): What is the last name of this person? - Textarea: free text, max 100 chars; placeholder "Enter last name" [ALWAYS; no precondition]

4. Q_S_HHMEM (q_s_hhmem): Is this person's usual place of residence? - Radio: (1) Yes; (2) No; (3) Proxy [ALWAYS; no precondition]

5. Q_URE (q_ure): Does this person have a usual place of residence elsewhere? - Radio: (1) Yes; (2) No [ALWAYS; no precondition]

6. Q_SEX (q_sex): What is this person's sex? - Radio: (1) Male; (2) Female [ALWAYS; no precondition]

7. Q_NROS2B (q_nros2b): Are there any other persons 15 years old or older now living or staying there who have not been listed? - Radio: (1) Yes; (2) No [ALWAYS; no precondition]

8. Q_CNT2BG (q_cnt2bg): How many other persons 15 years old or older have not been listed? - Editbox: numeric, min 1, max 20 [CONDITIONAL; precondition: q_nros2b.outcome == 1]

9. Q_MCHILD (q_mchild): Have I missed any babies or small children? - Radio: (1) Yes; (2) No [ALWAYS; no precondition]

10. Q_MAWAY (q_maway): Have I missed anyone who usually lives here but is away now - traveling, at school, or in a hospital? - Radio: (1) Yes; (2) No [ALWAYS; no precondition]

11. Q_MLODGE (q_mlodge): Have I missed any lodgers, boarders, or persons you employ who live here? - Radio: (1) Yes; (2) No [ALWAYS; no precondition]

12. Q_MELSE (q_melse): Have I missed anyone else staying here? - Radio: (1) Yes; (2) No [ALWAYS; no precondition]

13. Q_OWNREN1 (q_ownren1): What is the name of the person or one of the persons who owns or rents that home? - Dropdown: (1) Owner/Renter not a HH member; (2) Person 1's name; (3) Person 2's name; (4) Person 3's name; (5) Person 4's name; (6) Person 5's name; (7) Person 6's name; (8) Person 7's name; (9) Person 8's name; (10) Person 9's name; (11) Person 10's name; (12) Person 11's name; (13) Person 12's name; (14) Person 13's name; (15) Person 14's name; (16) Person 15's name; (17) Person 16's name [ALWAYS; no precondition]

### Block 3 -- Respondent Identification (b_respondent) - 2 questions

14. Q_HHRESP (q_hhresp): With whom am I speaking? - Dropdown: (1) Under_15; (2) Person 1's name; (3) Person 2's name; (4) Person 3's name; (5) Person 4's name; (6) Person 5's name; (7) Person 6's name; (8) Person 7's name; (9) Person 8's name; (10) Person 9's name; (11) Person 10's name; (12) Person 11's name; (13) Person 12's name; (14) Person 13's name; (15) Person 14's name; (16) Person 15's name; (17) Person 16's name [ALWAYS; no precondition]

15. Q_HHRESP_VERIFY (q_hhresp_verify): Are all persons under 15 years of age, or non-household members? - Radio: (1) Under 15 years of age; (2) Non-household members [CONDITIONAL; precondition: q_hhresp.outcome == 1]

### Block 4 -- Relationship and Family (b_relationship) - 9 questions

16. Q_S_RRP (q_s_rrp): How is this person related to the reference person? - Dropdown: (42) Opposite-sex Spouse (Husband/Wife); (43) Opposite-sex Unmarried Partner; (44) Same-sex Spouse (Husband/Wife); (45) Same-sex Unmarried Partner; (46) Child; (47) Grandchild; (48) Parent (Mother/Father); (49) Brother/Sister; (50) Other relative (Aunt, Cousin, Nephew, Mother-in-law, etc.); (51) Foster Child; (52) Housemate/Roommate; (53) Roomer/Boarder; (54) Other nonrelative [ALWAYS; no precondition] [codeBlock: sets is_nonrelative = 1 if outcome in {52, 53, 54}]

17. Q_S_SUBFAM (q_s_subfam): Earlier you said this person was not related to the reference person. Is this person related to anyone else in this household? - Radio: (1) Yes; (2) No [CONDITIONAL; precondition: is_nonrelative == 1] [codeBlock: sets is_subfam = 1 if outcome == 1]

18. Q_SUBFAM_WHO (q_subfam_who): Who is this person related to in the household? - Dropdown: (1) Person 1's name; (2) Person 2's name; (3) Person 3's name; (4) Person 4's name; (5) Person 5's name; (6) Person 6's name; (7) Person 7's name; (8) Person 8's name; (9) Person 9's name; (10) Person 10's name; (11) Person 11's name; (12) Person 12's name; (13) Person 13's name; (14) Person 14's name; (15) Person 15's name; (16) Person 16's name [CONDITIONAL; precondition: is_nonrelative == 1 AND is_subfam == 1]

19. Q_PAR1 (q_par1): Is this person's parent a member of this household? Enter the line number of the parent. - Dropdown: (0) No_One; (1) Person1; (2) Person2; (3) Person3; (4) Person4; (5) Person5; (6) Person6; (7) Person7; (8) Person8; (9) Person9; (10) Person10; (11) Person11; (12) Person12; (13) Person13; (14) Person14; (15) Person15; (16) Person16 [ALWAYS; no precondition] [codeBlock: sets has_par1 = 1 if outcome != 0]

20. Q_PAR1TYP (q_par1typ): Is this person a biological, step, or adopted child of the mother listed? - Radio: (1) Biological; (2) Step; (3) Adopted [CONDITIONAL; precondition: has_par1 == 1]

21. Q_PAR2 (q_par2): Is this person's other parent a member of this household? Enter the line number of the other parent. - Dropdown: (0) No_One; (1) Person1; (2) Person2; (3) Person3; (4) Person4; (5) Person5; (6) Person6; (7) Person7; (8) Person8; (9) Person9; (10) Person10; (11) Person11; (12) Person12; (13) Person13; (14) Person14; (15) Person15; (16) Person16 [ALWAYS; no precondition] [codeBlock: sets has_par2 = 1 if outcome != 0]

22. Q_PAR2TYP (q_par2typ): Is this person a biological, step, or adopted child of the father listed? - Radio: (1) Biological; (2) Step; (3) Adopted [CONDITIONAL; precondition: has_par2 == 1]

23. Q_PARENT2 (q_parent2): The reference person's parent is also this person's parent, is that correct? - Radio: (1) Yes; (2) No [CONDITIONAL; precondition: has_par2 == 1]

### Block 5 -- Date of Birth and Age (b_birth_age) - 6 questions

24. Q_BIRTHM (q_birthm): What is this person's date of birth? (Birth Month) - Dropdown: (1) Jan; (2) Feb; (3) Mar; (4) Apr; (5) May; (6) June; (7) July; (8) Aug; (9) Sept; (10) Oct; (11) Nov; (12) Dec [ALWAYS; no precondition]

25. Q_BIRTHD (q_birthd): What is this person's date of birth? (Birth Day) - Editbox: numeric, min 1, max 31 [ALWAYS; no precondition]

26. Q_BIRTHY (q_birthy): What is this person's date of birth? (Birth Year - enter 4 digit year, e.g. 1964) - Editbox: numeric, min 1900, max 2025 [ALWAYS; no precondition]

27. Q_VERIFY_AGE (q_verify_age): As of last week, that would make this person approximately (AGE) years old. Is that correct? - Radio: (1) Yes; (2) No [ALWAYS; no precondition] [codeBlock: sets age_verified = 1 if outcome == 1, age_verified = 0 if outcome == 2]

28. Q_AGEGSS (q_agegss): Even though you don't know the exact birthdate, what is your best guess as to how old this person was on their last birthday? - Editbox: numeric, min 0, max 99; right label "years old (99 = 99 years or older)" [CONDITIONAL; precondition: q_verify_age.outcome == 2]

29. Q_AGE2 (q_age2): Is this person under 15? - Radio: (1) Yes; (2) No [ALWAYS; no precondition]

### Block 6 -- Marital Status (b_marital) - 4 questions

30. Q_PREMARTL (q_premartl): Since our last interview, has any household member had any changes in his or her Marital Status? - Radio: (1) Yes; (2) No [ALWAYS; no precondition]

31. Q_MARITL (q_maritl): Is this person now married, widowed, divorced, separated or never married? - Radio: (1) Married - Spouse PRESENT; (2) Married - Spouse ABSENT; (3) Widowed; (4) Divorced; (5) Separated; (6) Never married [ALWAYS; no precondition]

32. Q_SPOUSE (q_spouse): What is the line number of this person's spouse in the household? - Dropdown: (0) No_One; (1) Person1; (2) Person2; (3) Person3; (4) Person4; (5) Person5; (6) Person6; (7) Person7; (8) Person8; (9) Person9; (10) Person10; (11) Person11; (12) Person12; (13) Person13; (14) Person14; (15) Person15; (16) Person16 [CONDITIONAL; precondition: q_maritl.outcome in {1, 2}]

33. Q_COHAB (q_cohab): Do you have a boyfriend, girlfriend or partner in this household? - Dropdown: (0) No; (1) Person 1's name; (2) Person 2's name; (3) Person 3's name; (4) Person 4's name; (5) Person 5's name; (6) Person 6's name; (7) Person 7's name; (8) Person 8's name; (9) Person 9's name; (10) Person 10's name; (11) Person 11's name; (12) Person 12's name; (13) Person 13's name; (14) Person 14's name; (15) Person 15's name; (16) Person 16's name [CONDITIONAL; precondition: q_maritl.outcome != 1 AND q_maritl.outcome != 2]

### Block 7 -- Military Service (b_military) - 3 questions

34. Q_AFEVER (q_afever): Did this person ever serve on active duty in the U.S. Armed Forces? - Radio: (1) Yes; (2) No [ALWAYS; no precondition] [codeBlock: sets is_veteran = 1 if outcome == 1]

35. Q_AFWHEN (q_afwhen): When did this person serve on active duty in the U.S. Armed Forces? (Select all that apply) - Checkbox (bitwise): (1) September 2001 or later; (2) August 1990 to August 2001; (4) May 1975 to July 1990; (8) Vietnam Era (August 1964 to April 1975); (16) February 1955 to July 1964; (32) Korean War (July 1950 to January 1955); (64) January 1947 to June 1950; (128) World War II (December 1941 to December 1946); (256) November 1941 or earlier [CONDITIONAL; precondition: is_veteran == 1] [PDF uses sequential codes 1-9; QML converts to power-of-2 bitwise encoding]

36. Q_AFNOW (q_afnow): Is this person now/still in the Armed Forces? - Radio: (1) Yes; (2) No [CONDITIONAL; precondition: is_veteran == 1]

### Block 8 -- Education (b_education) - 6 questions

37. Q_EDUCA (q_educa): What is the highest level of school this person has completed or the highest degree received? - Dropdown: (31) Less than 1st grade; (32) 1st, 2nd, 3rd or 4th grade; (33) 5th or 6th grade; (34) 7th or 8th grade; (35) 9th grade; (36) 10th grade; (37) 11th grade; (38) 12th grade NO DIPLOMA; (39) HIGH SCHOOL GRADUATE - high school DIPLOMA or the equivalent (e.g. GED); (40) Some college but no degree; (41) Associate degree in college - Occupational/vocational program; (42) Associate degree in college - Academic program; (43) Bachelor's degree (e.g. BA, AB, BS); (44) Master's degree (e.g. MA, MS, MEng, MEd, MSW, MBA); (45) Professional School Degree (e.g. MD, DDS, DVM, LLB, JD); (46) Doctorate degree (e.g. PhD, EdD) [ALWAYS; no precondition] [codeBlock: sets has_ged = 1 if outcome == 39; sets has_some_college = 1 if outcome >= 40]

38. Q_DIPGED (q_dipged): People can get a High School diploma in a variety of ways. How did this person get their High School diploma? - Radio: (1) Graduation from High School; (2) GED or other equivalent [CONDITIONAL; precondition: has_ged == 1]

39. Q_HGCOMP (q_hgcomp): What was the highest grade of regular school completed before receiving the GED? - Radio: (1) Less than 1st grade; (2) 1st, 2nd, 3rd or 4th grade; (3) 5th or 6th grade; (4) 7th or 8th grade; (5) 9th grade; (6) 10th grade; (7) 11th grade; (8) 12th grade NO DIPLOMA [CONDITIONAL; precondition: has_ged == 1 AND q_dipged.outcome == 2]

40. Q_CYC (q_cyc): How many years of college CREDIT has this person completed? (Including any time spent getting an Associate's Degree) - Radio: (1) Less than 1 year (include 0 years completed); (2) The first, or FRESHMAN year; (3) The second, or SOPHOMORE year; (4) The third, or JUNIOR year; (5) Four or more years [CONDITIONAL; precondition: has_some_college == 1]

41. Q_CERT1 (q_cert1): Does this person have a currently active professional certification or a state or industry license? (Do not include business licenses such as a liquor license or vending license.) - Radio: (1) Yes; (2) No [ALWAYS; no precondition] [codeBlock: sets has_cert = 1 if outcome == 1]

42. Q_CERT2 (q_cert2): Were any of this person's certifications or licenses issued by the federal, state, or local government? - Radio: (1) Yes; (2) No [CONDITIONAL; precondition: has_cert == 1]

### Block 9 -- Hispanic Origin (b_ethnicity) - 4 questions

43. Q_HSPNON (q_hspnon): Is this person of Hispanic, Latino, or Spanish origin? - Radio: (1) Yes; (2) No [ALWAYS; no precondition] [codeBlock: sets is_hispanic = 1 if outcome == 1]

44. Q_ORISPN (q_orispn): Is this person Mexican, Mexican American, or Chicano, Puerto Rican, Cuban, Cuban American, or another Hispanic, Latino, or Spanish origin group? - Radio: (1) Mexican; (2) Mexican American; (3) Chicano; (4) Puerto Rican; (5) Cuban; (6) Cuban-American; (7) Other Spanish, Hispanic, or Latino group [CONDITIONAL; precondition: is_hispanic == 1] [codeBlock: sets hispanic_other = 1 if outcome == 7]

45. Q_S_OROTSP (q_s_orotsp): What is the name of this person's other Spanish, Hispanic, or Latino group? - Textarea: free text, max 200 chars; placeholder "Specify other Spanish, Hispanic, or Latino group" [CONDITIONAL; precondition: is_hispanic == 1 AND hispanic_other == 1]

46. Q_OROTSS (q_orotss): Please specify the other Spanish, Hispanic, or Latino group: - Textarea: free text, max 200 chars; placeholder "Specify Other Spanish, Hispanic, or Latino group" [CONDITIONAL; precondition: is_hispanic == 1 AND hispanic_other == 1]

### Block 10 -- Race (b_race) - 5 questions

47. Q_RACE (q_race): I am going to read you a list of five race categories. You may choose one or more races. Is this person White; Black or African American; American Indian or Alaska Native; Asian; OR Native Hawaiian or Other Pacific Islander? - Checkbox (bitwise): (1) White; (2) Black or African American; (4) American Indian or Alaska Native; (8) Asian; (16) Native Hawaiian or Other Pacific Islander; (32) Other [ALWAYS; no precondition] [codeBlock: sets race_asian = 1 if outcome % 16 >= 8; sets race_pi = 1 if outcome % 32 >= 16; sets race_other = 1 if outcome % 64 >= 32] [PDF uses sequential codes 1-6; QML converts to power-of-2 bitwise encoding]

48. Q_RACEAS (q_raceas): Which of the following Asian groups is this person? (Select all that apply) - Checkbox (bitwise): (1) Asian Indian; (2) Chinese; (4) Filipino; (8) Japanese; (16) Korean; (32) Vietnamese; (64) Other Asian [CONDITIONAL; precondition: race_asian == 1] [PDF uses sequential codes 1-7; QML converts to power-of-2 bitwise encoding]

49. Q_RACEPI (q_racepi): Which of the following Native Hawaiian or Other Pacific Islander groups is this person? (Select all that apply) - Checkbox (bitwise): (1) Native Hawaiian; (2) Guamanian or Chamorro; (4) Samoan; (8) Other Pacific Islander [CONDITIONAL; precondition: race_pi == 1] [PDF uses sequential codes 1-4; QML converts to power-of-2 bitwise encoding]

50. Q_S_RACEOT (q_s_raceot): What is this person's race? (Read only if necessary) - Comment (no input control) [CONDITIONAL; precondition: race_other == 1]

51. Q_RACEOS (q_raceos): Please specify other race: - Textarea: free text, max 200 chars; placeholder "Specify other race" [CONDITIONAL; precondition: race_other == 1]

## TOTAL QUESTION NODES: 51

## Variables (codeInit)
The questionnaire initializes 14 variables in `codeInit`, all set to 0:

| Variable | Set By | Purpose |
|----------|--------|---------|
| is_veteran | Q_AFEVER codeBlock | Gates military service detail questions |
| has_ged | Q_EDUCA codeBlock | Gates diploma type question |
| has_some_college | Q_EDUCA codeBlock | Gates college years question |
| has_cert | Q_CERT1 codeBlock | Gates government certification question |
| is_hispanic | Q_HSPNON codeBlock | Gates Hispanic origin detail questions |
| hispanic_other | Q_ORISPN codeBlock | Gates other Hispanic origin text entry |
| race_asian | Q_RACE codeBlock | Gates Asian sub-group question |
| race_pi | Q_RACE codeBlock | Gates Pacific Islander sub-group question |
| race_other | Q_RACE codeBlock | Gates other race text entry |
| age_verified | Q_VERIFY_AGE codeBlock | Tracks age verification status |
| has_par1 | Q_PAR1 codeBlock | Gates parent 1 type question |
| has_par2 | Q_PAR2 codeBlock | Gates parent 2 type and confirmation questions |
| is_nonrelative | Q_S_RRP codeBlock | Gates subfamily questions |
| is_subfam | Q_S_SUBFAM codeBlock | Gates subfamily member identification |

## Z3 Classification Summary

| Classification | Count | Items |
|---------------|-------|-------|
| Precondition ALWAYS | 28 | Q_PERSTAT, Q_FNAME, Q_LNAME, Q_S_HHMEM, Q_URE, Q_SEX, Q_NROS2B, Q_MCHILD, Q_MAWAY, Q_MLODGE, Q_MELSE, Q_OWNREN1, Q_HHRESP, Q_S_RRP, Q_PAR1, Q_PAR2, Q_BIRTHM, Q_BIRTHD, Q_BIRTHY, Q_VERIFY_AGE, Q_AGE2, Q_PREMARTL, Q_MARITL, Q_AFEVER, Q_EDUCA, Q_CERT1, Q_HSPNON, Q_RACE |
| Precondition CONDITIONAL | 23 | Q_CNT2BG, Q_HHRESP_VERIFY, Q_S_SUBFAM, Q_SUBFAM_WHO, Q_PAR1TYP, Q_PAR2TYP, Q_PARENT2, Q_AGEGSS, Q_SPOUSE, Q_COHAB, Q_AFWHEN, Q_AFNOW, Q_DIPGED, Q_HGCOMP, Q_CYC, Q_CERT2, Q_ORISPN, Q_S_OROTSP, Q_OROTSS, Q_RACEAS, Q_RACEPI, Q_S_RACEOT, Q_RACEOS |
| Precondition NEVER | 0 | (none) |
| Postcondition NONE | 51 | (all items -- no postconditions defined) |
