# Survey of Approaches to Educational Planning (SAEP) - Question Inventory

## Document Overview
- **Title**: Survey of Approaches to Educational Planning
- **Organization**: Statistics Canada, Special Surveys Division (jointly with Human Resources Development Canada)
- **Date**: 1999-07-06 (form 8-5300-368.1)
- **Pages**: 52
- **Language**: English (Version francaise disponible)
- **Type**: Telephone interview questionnaire (CATI-style paper instrument)
- **Authority**: Statistics Act, Revised Statutes of Canada, 1985, Chapter S19
- **Reference Number**: STC/SSD-040-75166

## Structure

The questionnaire is organized into 7 sections:

- **Section A** (Introduction): Household screening - identifies eligible children and most knowledgeable respondent
- **Section B** (Child 1): General questions about the first selected child - school experience, activities, parental involvement, and planning/savings for post-secondary education
- **Section C** (Child 2): Identical structure to Section B, repeated for the second selected child
- **Section D** (Child 3): Identical structure to Section B, repeated for the third selected child
- **Section E** (Remaining children): Savings questions for any additional children in the household beyond the 3 selected
- **Section F** (Children outside household): Savings questions for children aged 18 or younger who do not live in the household
- **Section G** (General information): Household-level demographics - computer access, ethnicity, language, financial priorities, income, and consent

Sections B, C, and D are structurally identical (same questions with different prefixes B/C/D). Up to 3 children can be selected for detailed questioning. The unique question template is defined once in Section B and replicated for Sections C and D.

## Question Inventory by Section

### Section A - Introduction / Screening - 3 questions

1. Q_A1: How many children 18 years of age or younger usually live at this dwelling? This includes children who usually live here but are now away at school, in the hospital or somewhere else. - **Type**: Numeric (open entry) [If 00, go to Section F, page 47. If 01 or more children, go to A2.]
2. Q_A2: I would like to speak to the person who is the most knowledgeable about these children and about any plans made for their post-secondary education. Would this person be you? - **Type**: Radio - 1=Yes [Go to A3 (page 2)], 2=No [Ask who would be the right person, fill in fields below and schedule an interview with this person: First Name, Last Name, Age, Sex (1=Male, 2=Female)]
3. Q_A3: Interviewer Check Item - **Type**: Routing logic (not a respondent question) - 1) If there are 01-03 children in A1, go to CHILD 1, CHILD 2 and CHILD 3 and fill in appropriate name, age and sex. Then go to SECTION B (CHILD 1) and start interview. 2) If there are 04 or more children in A1: Fill in name, sex and age of each child 18 years of age or younger and use selection grid on label to choose 3 children. Mark the 3 selected children with an X. Go to CHILD 1, CHILD 2 and CHILD 3 and fill in appropriate name, age and sex for each selected child. Then go to SECTION B (CHILD 1) and start interview.

**Children's Information for Selection table**: Grid for up to 9 children with columns: #, Selected=X, First Name, Sex (1=Male, 2=Female), Age

**CHILD 1/2/3 header blocks**: First Name, Sex (1=Male, 2=Female), Age (in years, if age is less than 1 year enter 00)

**Administrative items on cover page**:
- RO, Sample ID, Line #, Telephone, First Name, Last Name, Assignment #
- Record of Calls and Appointments (Date/Notes grid)
- Final Status of Interview: 1=Fully completed, 2=Unable to contact, 3=Partially completed, 4=Other non-response, 5=Refused
- Language: 01=English

### Section B - General Questions (Child 1) - 44 questions

#### General Questions (B1-B19)

1. Q_B1: What is ...'s relationship to you? - **Type**: Radio - 1=Son/daughter (biological, adoptive, stepchild), 2=Foster child, 3=Grandchild, 4=Brother/sister, 5=Other family member or relative, 6=Unrelated
2. Q_B2: Does ... have any long-term conditions or health problems which prevent or limit his/her participation in school, at play, or in any other activity for a child of his/her age? - **Type**: Radio - 01=Yes, 02=No, 07=Don't know, 08=Refused
3. Q_B3: How far do ...'s parents/guardians hope that he/she will go in school? - **Type**: Radio - 1=Primary school, 2=Secondary or high school, 3=Community college, technical college or CEGEP, 4=University, 5=Learn a trade, 7=Don't know, 8=Refused
4. Q_B4: Interviewer Check Item - **Type**: Routing logic - 1=If age is 00-04, go to B20 (page 11), 2=If age is 05-08, go to B6, 3=If age is 09 or more, go to B5
5. Q_B5: How far do ...'s parents/guardians expect that he/she will go in school? - **Type**: Radio - 1=Primary school, 2=Secondary or high school, 3=Community college, technical college or CEGEP, 4=University, 5=Learn a trade, 7=Don't know, 8=Refused [age >= 09]
6. Q_B6: Did ... attend school last year? (include home schooling) - **Type**: Radio - 01=Yes [Go to B9 (page 6)], 02=No, 07=Don't know, 08=Refused [02/07/08 -> Go to B20 (page 11)] [age >= 05]
7. Q_B7: Why did ... not attend school last year? - **Type**: Radio - 1=Too young for school [Go to B20 (page 11)], 2=Physical, mental, emotional or behavioral problem [Go to B20 (page 11)], 3=Left school before graduating, 4=Graduated from school, 5=Other - Specify (open text) [B6 = No]
8. Q_B8: In what grade was ... last enrolled? - **Type**: Radio - 01=Junior kindergarten, 02=Kindergarten, 03=Grade 1, 04=Grade 2, 05=Grade 3, 06=Grade 4, 07=Grade 5, 08=Grade 6, 09=Grade 7 (in Quebec = Secondary 1), 10=Grade 8 (in Quebec = Secondary 2), 11=Grade 9 (in Quebec = Secondary 3), 12=Grade 10 (in Quebec = Secondary 4), 13=Grade 11 (in Quebec = Secondary 5), 14=Grade 12, 15=OAC Grade 13 (in Ontario), 16=Ungraded, CEGEP technical program: 17=1st year, 18=2nd year, 19=3rd year, CEGEP academic program (pre-university): 20=1st year, 21=2nd year, 22=3rd year, University/college: 23=1st year, 24=2nd year, 25=3rd year, Apprenticeship: 26=1st year, 27=2nd year, 28=3rd year, Trades-technology training: 29=1st year, 30=2nd year, 31=3rd year, OR 32=Other, 97=Don't know, 98=Refused, 33=N/A [All -> Go to B20 (page 11)] [B6=No and B7 in {3,4,5}]
9. Q_B9: In what grade was he/she enrolled last year? - **Type**: Radio - 34=Junior kindergarten [Go to B20 (page 11)], 35=Kindergarten [Go to B20 (page 11)], 36=Grade 1, 37=Grade 2, 38=Grade 3, 39=Grade 4, 40=Grade 5, 41=Grade 6, 42=Grade 7 (in Quebec = Secondary 1), 43=Grade 8 (in Quebec = Secondary 2), 44=Grade 9 (in Quebec = Secondary 3), 45=Grade 10 (in Quebec = Secondary 4), 46=Grade 11 (in Quebec = Secondary 5), 47=Grade 12, 48=OAC Grade 13 (in Ontario), 49=Ungraded, CEGEP technical program: 50=1st year, 51=2nd year, 52=3rd year, CEGEP academic program (pre-university): 53=1st year, 54=2nd year, 55=3rd year, University/college: 56=1st year, 57=2nd year, 58=3rd year, Apprenticeship: 59=1st year, 60=2nd year, 61=3rd year, Trades-technology training: 62=1st year, 63=2nd year, 64=3rd year, OR 65=Other, 97=Don't know, 98=Refused, 66=N/A [All (except Jr K/K) -> Go to B20 (page 11)] [B6=Yes]
10. Q_B10: Based on your knowledge of ...'s schoolwork, including report cards, how did he/she do overall in school? (READ LIST.) - **Type**: Radio - 01=Above average, 02=Average, 03=Below average, 07=Don't know, 08=Refused [B9 >= Grade 1]
11. Q_B11: How did ... feel about his/her schoolwork? (READ LIST.) - **Type**: Radio - 1=Liked it very much, 2=Liked it, 3=Neither liked nor disliked it, 4=Disliked it, 5=Disliked it very much, 7=Don't know, 8=Refused
12. Q_B12: Overall, did ...'s close friends do well in their schoolwork? - **Type**: Radio - 01=Yes, 02=No, 07=Don't know, 08=Refused
13. Q_B13: How often were ...'s parents/guardians in contact with his/her teachers to discuss his/her academic performance or behaviour? (READ LIST.) - **Type**: Radio - 1=Often, 2=A few times, 3=Once, 4=Never, 7=Don't know, 8=Refused
14. Q_B14: Did ...'s parents/guardians set aside a place in the home for him/her to use for studying or doing homework? - **Type**: Radio - 01=Yes, 02=No, 07=Don't know, 08=Refused
15. Q_B15a: In a typical week during the last school year, how often did ... participate in organized activities that were not run by the school such as: Sports or physical activities like Little League, swim club or hockey league? (READ LIST.) - **Type**: Radio - 1=More than once a week, 2=About once a week, 3=Less than once a week, 4=Never, 7=Don't know, 8=Refused
16. Q_B15b: Social club activities like scouts, girl guides, boys and girls clubs or church groups? (READ LIST.) - **Type**: Radio - 01=More than once a week, 02=About once a week, 03=Less than once a week, 04=Never, 07=Don't know, 08=Refused
17. Q_B15c: Cultural activities like music lessons, art lessons, dance lessons or drama lessons? (READ LIST.) - **Type**: Radio - 1=More than once a week, 2=About once a week, 3=Less than once a week, 4=Never, 7=Don't know, 8=Refused
18. Q_B16: In a typical week during the last school year, how often did ... participate in organized activities that were run by the school outside of school hours? This includes any activity such as sports teams, social clubs, music, band or school plays run by the school. (READ LIST.) - **Type**: Radio - 01=More than once a week, 02=About once a week, 03=Less than once a week, 04=Never, 07=Don't know, 08=Refused
19. Q_B17a: Using the categories very often, often, sometimes and never, how often did ...'s parents/guardians... Praise ... if he/she did well in school? (READ LIST.) - **Type**: Radio - 1=Very often, 2=Often, 3=Sometimes, 4=Never, 7=Don't know, 8=Refused
20. Q_B17b: Praise ... for trying in school, even if he/she did not succeed? (READ LIST.) - **Type**: Radio - 01=Very often, 02=Often, 03=Sometimes, 04=Never, 07=Don't know, 08=Refused
21. Q_B17c: Help ... with homework when he/she did not understand? (READ LIST.) - **Type**: Radio - 1=Very often, 2=Often, 3=Sometimes, 4=Never, 7=Don't know, 8=Refused
22. Q_B17d: Remind ... to begin or complete homework? (READ LIST.) - **Type**: Radio - 01=Very often, 02=Often, 03=Sometimes, 04=Never, 07=Don't know, 08=Refused
23. Q_B17e: Help ... plan his/her time for getting homework done? (READ LIST.) - **Type**: Radio - 1=Very often, 2=Often, 3=Sometimes, 4=Never, 7=Don't know, 8=Refused
24. Q_B17f: Decide how much television ... could watch on school days? (READ LIST.) - **Type**: Radio - 01=Very often, 02=Often, 03=Sometimes, 04=Never, 07=Don't know, 08=Refused
25. Q_B17g: Tell or remind ... that he/she was not working to his/her full potential or ability? (READ LIST.) - **Type**: Radio - 1=Very often, 2=Often, 3=Sometimes, 4=Never, 7=Don't know, 8=Refused
26. Q_B18: In general, how much time did ... spend doing homework? (READ LIST.) - **Type**: Radio - 01=A lot, 02=A fair amount, 03=Very little, 04=None at all, 07=Don't know, 08=Refused
27. Q_B19: How much leisure time did ...'s parents/guardians usually spend with him/her in a week? Leisure time means doing things together like playing a game, going shopping together, or other activities. (READ LIST.) - **Type**: Radio - 1=A lot, 2=A fair amount, 3=Very little, 4=None at all, 7=Don't know, 8=Refused

#### Planning for Post-Secondary Education (B20-B29)

28. Q_B20: Have you or anyone else living in your household ever saved money for ...'s post-secondary education? - **Type**: Radio - 1=Yes [Go to B22], 2=No, 3=Don't know, 4=Refused
29. Q_B21: Are you or anyone else living in your household planning to save or pay for ...'s post-secondary education? - **Type**: Radio - 5=Yes, 6=No, 7=Don't know, 8=Refused [6/7/8 -> Go to B42 (page 15)] [B20 != Yes]
30. Q_B22: If ... were to go on to post-secondary education, do his/her parents/guardians expect that he/she will live away from home? - **Type**: Radio - 01=Yes, 02=No, 07=Don't know, 08=Refused [02/07/08 -> Go to B24]
31. Q_B23: Assuming that ... lives away from home, how much do his/her parents/guardians expect that the total cost of his/her education and living expenses would be? - **Type**: Currency (open entry, $___,___) - 1=Don't know, 2=Refused [All -> Go to B25 (page 12)] [B22=Yes]
32. Q_B24: Assuming that ... lives at home, how much do his/her parents/guardians expect that the total cost of his/her education would be? - **Type**: Currency (open entry, $___,___) - 3=Don't know, 4=Refused [B22 != Yes]
33. Q_B25: Do ...'s parents/guardians expect that he/she will pay for any part of his/her education costs himself/herself in the following ways: - **Type**: Matrix (4 sub-items x 4 responses)
    - Q_B25a: He/she will work before starting his/her post-secondary studies? This includes part-time jobs while in high school. - Yes(01)/No(02)/Don't know(03)/Refused(04)
    - Q_B25b: He/she will work during his/her post-secondary studies? This includes part-time jobs, summer jobs or co-op work programs. - Yes(05)/No(06)/Don't know(07)/Refused(08)
    - Q_B25c: He/she will interrupt his/her studies to work? - Yes(09)/No(10)/Don't know(11)/Refused(12)
    - Q_B25d: He/she will take out loans that will be repaid after his/her studies are finished? - Yes(13)/No(14)/Don't know(15)/Refused(16)
34. Q_B26: Interviewer Check Item - **Type**: Routing logic - 1=If B25d = "Yes", go to B27, 2=Otherwise, go to B28
35. Q_B27: Are the loans expected to be: - **Type**: Matrix (4 sub-items x 4 responses) [B25d=Yes]
    - Q_B27a: Government student loans (federal or provincial)? - Yes(01)/No(02)/Don't know(03)/Refused(04)
    - Q_B27b: Non-student loans from a financial institution (e.g. bank, trust company, credit union)? - Yes(05)/No(06)/Don't know(07)/Refused(08)
    - Q_B27c: Loans from family or friends? - Yes(09)/No(10)/Don't know(11)/Refused(12)
    - Q_B27d: Other? - Yes(13)/No(14)/Don't know(15)/Refused(16)
36. Q_B28: Do ...'s parents/guardians expect that they will pay for any part of his/her education costs in the following ways: - **Type**: Matrix (3 sub-items x 4 responses)
    - Q_B28a: Savings or investments they make before ... starts post-secondary studies? - Yes(17)/No(18)/Don't know(19)/Refused(20)
    - Q_B28b: Income they earn while ... is attending post-secondary? - Yes(21)/No(22)/Don't know(23)/Refused(24)
    - Q_B28c: Loans they take out and pay back after ... finishes post-secondary studies? This does not include loans taken out by ... such as a student loan. - Yes(25)/No(26)/Don't know(27)/Refused(28)
37. Q_B29: Do ...'s parents/guardians expect that any part of his/her post-secondary education will be paid for by the following sources? - **Type**: Matrix (3 sub-items x 4 responses)
    - Q_B29a: Scholarships or awards based on academic performance - Yes(01)/No(02)/Don't know(03)/Refused(04)
    - Q_B29b: Grants or bursaries based on financial need - Yes(05)/No(06)/Don't know(07)/Refused(08)
    - Q_B29c: Gifts or inheritances - Yes(09)/No(10)/Don't know(11)/Refused(12)

#### Savings for Post-Secondary Education (B30-B44)

38. Q_B30: Interviewer Check Item - **Type**: Routing logic - 1=If B20 = "Yes", go to B31, 2=Otherwise, go to B42 (page 15)
39. Q_B31: How old was ... when these savings were first started? - **Type**: Numeric (open entry, years old; if less than 1 year, enter 00) - 1=Don't know, 2=Refused [B20=Yes]
40. Q_B32: How much money was saved for ...'s post-secondary education in 1998? Do not include any earnings or interest. - **Type**: Currency (open entry, $___,___) - 3=Don't know, 4=Refused [B20=Yes]
41. Q_B33: How much money has been saved for ...'s post-secondary education so far in 1999? Do not include any earnings or interest. - **Type**: Currency (open entry, $___,___) - 5=Don't know, 6=Refused [B20=Yes]
42. Q_B34: How much money will be saved for ... in the rest of 1999? - **Type**: Currency (open entry, $___,___) - 7=Don't know, 8=Refused [B20=Yes]
43. Q_B35: Since starting to save for ..., how much in total has been saved for his/her post-secondary education? Do not include any earnings or interest. - **Type**: Currency (open entry, $___,___) - 5=Don't know, 6=Refused [B20=Yes]
44. Q_B36: How much do you expect to have saved for ...'s education by the time he/she starts post-secondary studies? Include all earnings and interest. - **Type**: Currency (open entry, $___,___) - 7=Don't know, 8=Refused [B20=Yes]
45. Q_B37: What types of savings plans are being used to save for ...'s post-secondary education? - **Type**: Matrix (4 sub-items x 4 responses) [B20=Yes]
    - Q_B37a: RESPs (Registered Education Savings Plans) - Yes(01)/No(02)/Don't know(03)/Refused(04)
    - Q_B37b: RRSPs (Registered Retirement Savings Plans) - Yes(05)/No(06)/Don't know(07)/Refused(08)
    - Q_B37c: "In-trust for" accounts - Yes(09)/No(10)/Don't know(11)/Refused(12)
    - Q_B37d: Other - Yes(13)/No(14)/Don't know(15)/Refused(16)
    [If B37a,b,c,d are all answered "No", "Don't know" or "Refused", go to B42 (page 15)]
46. Q_B38: Within these plans, how are the savings invested? - **Type**: Matrix (5 sub-items x 4 responses) [B37 has at least one Yes]
    - Q_B38a: Mutual funds - Yes(17)/No(18)/Don't know(19)/Refused(20)
    - Q_B38b: Shares of corporations - Yes(21)/No(22)/Don't know(23)/Refused(24)
    - Q_B38c: Savings or chequing accounts - Yes(25)/No(26)/Don't know(27)/Refused(28)
    - Q_B38d: Savings bonds - Yes(29)/No(30)/Don't know(31)/Refused(32)
    - Q_B38e: Other - Yes(33)/No(34)/Don't know(35)/Refused(36)
47. Q_B39: Interviewer Check Item - **Type**: Routing logic - 1=If B37a = "Yes", go to B40, 2=Otherwise, go to B42
48. Q_B40: For the RESP only, how much money in total has been contributed to RESPs for ... by people living in your household? - **Type**: Currency (open entry, $___,___) - 7=Don't know, 8=Refused [B37a=Yes]
49. Q_B41: Which types of RESPs are being used? - **Type**: Matrix (2 sub-items x 4 responses) [B37a=Yes]
    - Q_B41a: Individual plan (includes individual non-family and family RESPs) - Yes(01)/No(02)/Don't know(03)/Refused(04)
    - Q_B41b: Group plan (education scholarship trust or foundation) - Yes(05)/No(06)/Don't know(07)/Refused(08)
50. Q_B42: Does anyone who does not live in your household have savings put aside for ...'s post-secondary education? - **Type**: Radio - 1=Yes, 2=No, 7=Don't know, 8=Refused [2/7/8 -> Go to B44]
51. Q_B43: How much money in total have the people who don't live in your household put aside for ...'s post-secondary education? - **Type**: Currency (open entry, $___,___) - 7=Don't know, 8=Refused [B42=Yes]
52. Q_B44: Interviewer Check Item - **Type**: Routing logic - 1=If there is more than one child in the household, go to SECTION C - CHILD 2, 2=Otherwise, go to SECTION F (page 47)

### Section C - General Questions (Child 2) - 44 questions

Section C is structurally identical to Section B, with question IDs prefixed "C" instead of "B". All question texts, response options, and routing logic mirror Section B exactly, applied to the second selected child.

1. Q_C1: What is ...'s relationship to you? - **Type**: Radio - Same options as B1
2. Q_C2: Does ... have any long-term conditions or health problems? - **Type**: Radio - Same options as B2
3. Q_C3: How far do ...'s parents/guardians hope that he/she will go in school? - **Type**: Radio - Same options as B3
4. Q_C4: Interviewer Check Item - **Type**: Routing logic - Same as B4 [routes to C20/C6/C5]
5. Q_C5: How far do ...'s parents/guardians expect that he/she will go in school? - **Type**: Radio - Same options as B5
6. Q_C6: Did ... attend school last year? - **Type**: Radio - Same options as B6 [Yes -> C9 (page 20); No/DK/Ref -> C20 (page 25)]
7. Q_C7: Why did ... not attend school last year? - **Type**: Radio - Same options as B7 [1/2 -> C20 (page 25)]
8. Q_C8: In what grade was ... last enrolled? - **Type**: Radio - Same options as B8 [All -> C20 (page 25)]
9. Q_C9: In what grade was he/she enrolled last year? - **Type**: Radio - Same options as B9 [Jr K/K -> C20 (page 25)]
10. Q_C10: How did he/she do overall in school? - **Type**: Radio - Same options as B10
11. Q_C11: How did ... feel about his/her schoolwork? - **Type**: Radio - Same options as B11
12. Q_C12: Overall, did ...'s close friends do well in their schoolwork? - **Type**: Radio - Same options as B12
13. Q_C13: How often were ...'s parents/guardians in contact with teachers? - **Type**: Radio - Same options as B13
14. Q_C14: Did ...'s parents/guardians set aside a place for studying? - **Type**: Radio - Same options as B14
15. Q_C15a: Non-school sports or physical activities? - **Type**: Radio - Same options as B15a
16. Q_C15b: Non-school social club activities? - **Type**: Radio - Same options as B15b
17. Q_C15c: Non-school cultural activities? - **Type**: Radio - Same options as B15c
18. Q_C16: School-run organized activities outside school hours? - **Type**: Radio - Same options as B16
19. Q_C17a: Praise if did well in school? - **Type**: Radio - Same options as B17a
20. Q_C17b: Praise for trying? - **Type**: Radio - Same options as B17b
21. Q_C17c: Help with homework? - **Type**: Radio - Same options as B17c
22. Q_C17d: Remind to begin/complete homework? - **Type**: Radio - Same options as B17d
23. Q_C17e: Help plan time for homework? - **Type**: Radio - Same options as B17e
24. Q_C17f: Decide how much television? - **Type**: Radio - Same options as B17f
25. Q_C17g: Remind not working to full potential? - **Type**: Radio - Same options as B17g
26. Q_C18: How much time doing homework? - **Type**: Radio - Same options as B18
27. Q_C19: How much leisure time with parents/guardians? - **Type**: Radio - Same options as B19
28. Q_C20: Have you or anyone else saved money for ...'s post-secondary education? - **Type**: Radio - Same options as B20 [Yes -> C22]
29. Q_C21: Planning to save or pay for post-secondary education? - **Type**: Radio - Same options as B21 [No/DK/Ref -> C42 (page 29)]
30. Q_C22: Expect child will live away from home for PSE? - **Type**: Radio - Same options as B22 [No/DK/Ref -> C24]
31. Q_C23: Expected total cost if lives away from home? - **Type**: Currency - Same as B23 [All -> C25 (page 26)]
32. Q_C24: Expected total cost if lives at home? - **Type**: Currency - Same as B24
33. Q_C25: Child expected to pay for education costs? - **Type**: Matrix - Same sub-items as B25 (a-d)
34. Q_C26: Interviewer Check Item - **Type**: Routing logic - Same as B26 [C25d=Yes -> C27; else -> C28]
35. Q_C27: Are the loans expected to be? - **Type**: Matrix - Same sub-items as B27 (a-d)
36. Q_C28: Parents/guardians expected to pay education costs? - **Type**: Matrix - Same sub-items as B28 (a-c)
37. Q_C29: Expected external funding sources? - **Type**: Matrix - Same sub-items as B29 (a-c)
38. Q_C30: Interviewer Check Item - **Type**: Routing logic - Same as B30 [C20=Yes -> C31; else -> C42 (page 29)]
39. Q_C31: How old was child when savings started? - **Type**: Numeric - Same as B31
40. Q_C32: How much saved in 1998? - **Type**: Currency - Same as B32
41. Q_C33: How much saved in 1999 so far? - **Type**: Currency - Same as B33
42. Q_C34: How much will be saved rest of 1999? - **Type**: Currency - Same as B34
43. Q_C35: Total saved since starting? - **Type**: Currency - Same as B35
44. Q_C36: Expected total saved by start of PSE? - **Type**: Currency - Same as B36
45. Q_C37: Types of savings plans? - **Type**: Matrix - Same sub-items as B37 (a-d) [All No/DK/Ref -> C42 (page 29)]
46. Q_C38: How are savings invested? - **Type**: Matrix - Same sub-items as B38 (a-e)
47. Q_C39: Interviewer Check Item - **Type**: Routing logic - Same as B39 [C37a=Yes -> C40; else -> C42]
48. Q_C40: Total RESP contributions? - **Type**: Currency - Same as B40
49. Q_C41: Types of RESPs? - **Type**: Matrix - Same sub-items as B41 (a-b)
50. Q_C42: Savings by people outside household? - **Type**: Radio - Same options as B42 [No/DK/Ref -> C44]
51. Q_C43: How much put aside by people outside household? - **Type**: Currency - Same as B43
52. Q_C44: Interviewer Check Item - **Type**: Routing logic - 1=If there are more than two children in the household, go to SECTION D - CHILD 3, 2=Otherwise, go to SECTION F (page 47)

### Section D - General Questions (Child 3) - 44 questions

Section D is structurally identical to Sections B and C, with question IDs prefixed "D" instead of "B" or "C". All question texts, response options, and routing logic mirror Section B exactly, applied to the third selected child.

1. Q_D1: What is ...'s relationship to you? - **Type**: Radio - Same options as B1
2. Q_D2: Does ... have any long-term conditions or health problems? - **Type**: Radio - Same options as B2
3. Q_D3: How far do ...'s parents/guardians hope? - **Type**: Radio - Same options as B3
4. Q_D4: Interviewer Check Item - **Type**: Routing logic - Same as B4 [routes to D20/D6/D5]
5. Q_D5: How far do ...'s parents/guardians expect? - **Type**: Radio - Same options as B5
6. Q_D6: Did ... attend school last year? - **Type**: Radio - Same options as B6 [Yes -> D9 (page 34); No/DK/Ref -> D20 (page 39)]
7. Q_D7: Why did ... not attend school last year? - **Type**: Radio - Same options as B7 [1/2 -> D20 (page 39)]
8. Q_D8: In what grade was ... last enrolled? - **Type**: Radio - Same options as B8 [All -> D20 (page 39)]
9. Q_D9: In what grade was he/she enrolled last year? - **Type**: Radio - Same options as B9 [Jr K/K -> D20 (page 39)]
10. Q_D10: How did he/she do overall in school? - **Type**: Radio - Same options as B10
11. Q_D11: How did ... feel about schoolwork? - **Type**: Radio - Same options as B11
12. Q_D12: Close friends do well in schoolwork? - **Type**: Radio - Same options as B12
13. Q_D13: Parent/teacher contact frequency? - **Type**: Radio - Same options as B13
14. Q_D14: Place set aside for studying? - **Type**: Radio - Same options as B14
15. Q_D15a: Non-school sports activities? - **Type**: Radio - Same options as B15a
16. Q_D15b: Non-school social club activities? - **Type**: Radio - Same options as B15b
17. Q_D15c: Non-school cultural activities? - **Type**: Radio - Same options as B15c
18. Q_D16: School-run activities outside hours? - **Type**: Radio - Same options as B16
19. Q_D17a: Praise if did well? - **Type**: Radio - Same options as B17a
20. Q_D17b: Praise for trying? - **Type**: Radio - Same options as B17b
21. Q_D17c: Help with homework? - **Type**: Radio - Same options as B17c
22. Q_D17d: Remind to do homework? - **Type**: Radio - Same options as B17d
23. Q_D17e: Help plan homework time? - **Type**: Radio - Same options as B17e
24. Q_D17f: Decide TV time? - **Type**: Radio - Same options as B17f
25. Q_D17g: Remind about potential? - **Type**: Radio - Same options as B17g
26. Q_D18: Time doing homework? - **Type**: Radio - Same options as B18
27. Q_D19: Leisure time with parents? - **Type**: Radio - Same options as B19
28. Q_D20: Ever saved money for PSE? - **Type**: Radio - Same options as B20 [Yes -> D22]
29. Q_D21: Planning to save for PSE? - **Type**: Radio - Same options as B21 [No/DK/Ref -> D42 (page 43)]
30. Q_D22: Expect to live away from home? - **Type**: Radio - Same options as B22 [No/DK/Ref -> D24]
31. Q_D23: Cost if away from home? - **Type**: Currency - Same as B23 [All -> D25 (page 40)]
32. Q_D24: Cost if at home? - **Type**: Currency - Same as B24
33. Q_D25: Child expected to pay (work/loans)? - **Type**: Matrix - Same sub-items as B25 (a-d)
34. Q_D26: Interviewer Check Item - **Type**: Routing logic - Same as B26 [D25d=Yes -> D27; else -> D28]
35. Q_D27: Expected loan types? - **Type**: Matrix - Same sub-items as B27 (a-d)
36. Q_D28: Parents expected to pay? - **Type**: Matrix - Same sub-items as B28 (a-c)
37. Q_D29: External funding sources? - **Type**: Matrix - Same sub-items as B29 (a-c)
38. Q_D30: Interviewer Check Item - **Type**: Routing logic - Same as B30 [D20=Yes -> D31; else -> D42 (page 43)]
39. Q_D31: Age when savings started? - **Type**: Numeric - Same as B31
40. Q_D32: Amount saved in 1998? - **Type**: Currency - Same as B32
41. Q_D33: Amount saved in 1999? - **Type**: Currency - Same as B33
42. Q_D34: Amount to save rest of 1999? - **Type**: Currency - Same as B34
43. Q_D35: Total saved overall? - **Type**: Currency - Same as B35
44. Q_D36: Expected total by PSE start? - **Type**: Currency - Same as B36
45. Q_D37: Types of savings plans? - **Type**: Matrix - Same sub-items as B37 (a-d) [All No/DK/Ref -> D42 (page 43)]
46. Q_D38: How savings invested? - **Type**: Matrix - Same sub-items as B38 (a-e)
47. Q_D39: Interviewer Check Item - **Type**: Routing logic - Same as B39 [D37a=Yes -> D40; else -> D42]
48. Q_D40: Total RESP contributions? - **Type**: Currency - Same as B40
49. Q_D41: Types of RESPs? - **Type**: Matrix - Same sub-items as B41 (a-b)
50. Q_D42: Savings by people outside household? - **Type**: Radio - Same options as B42 [No/DK/Ref -> D44]
51. Q_D43: Amount from people outside household? - **Type**: Currency - Same as B43
52. Q_D44: Interviewer Check Item - **Type**: Routing logic - 1=If there are more than three children in the household, go to SECTION E, 2=Otherwise, go to SECTION F (page 47)

### Section E - Remaining Children in Household: Savings for Post-Secondary Education - 11 questions

1. Q_E1: Have you or anyone else living in your household ever saved money for the post-secondary education of the other children in your household who are 18 years of age or younger? - **Type**: Radio - 1=Yes, 2=No, 7=Don't know, 8=Refused [2/7/8 -> Go to SECTION F (page 47)]
2. Q_E2: For how many of these children is money being saved? - **Type**: Numeric (open entry) [If 00, go to Section F (page 47)]
3. Q_E3: How much money was saved for these children's post-secondary education in 1998? Do not include any earnings or interest. - **Type**: Currency (open entry, $___,___) - 1=Don't know, 2=Refused
4. Q_E4: How much money has been saved for these children's post-secondary education so far in 1999? Do not include any earnings or interest. - **Type**: Currency (open entry, $___,___) - 3=Don't know, 4=Refused
5. Q_E5: How much money will be saved for these children in the rest of 1999? - **Type**: Currency (open entry, $___,___) - 5=Don't know, 6=Refused
6. Q_E6: Since starting to save for these children, how much in total has been saved for their post-secondary education? Do not include any earnings or interest. - **Type**: Currency (open entry, $___,___) - 7=Don't know, 8=Refused
7. Q_E7: What types of savings plans are being used to save for these children's post-secondary education? - **Type**: Matrix (4 sub-items x 4 responses)
    - Q_E7a: RESPs (Registered Education Savings Plans) - Yes(01)/No(02)/Don't know(03)/Refused(04)
    - Q_E7b: RRSPs (Registered Retirement Savings Plans) - Yes(05)/No(06)/Don't know(07)/Refused(08)
    - Q_E7c: "In-trust for" accounts - Yes(09)/No(10)/Don't know(11)/Refused(12)
    - Q_E7d: Other - Yes(13)/No(14)/Don't know(15)/Refused(16)
    [If E7a,b,c,d are all answered "No", "Don't know" or "Refused", go to SECTION F (page 47)]
8. Q_E8: Within these plans, how are the savings invested? - **Type**: Matrix (5 sub-items x 4 responses)
    - Q_E8a: Mutual funds - Yes(17)/No(18)/Don't know(19)/Refused(20)
    - Q_E8b: Shares of corporations - Yes(21)/No(22)/Don't know(23)/Refused(24)
    - Q_E8c: Savings or chequing accounts - Yes(25)/No(26)/Don't know(27)/Refused(28)
    - Q_E8d: Savings bonds - Yes(29)/No(30)/Don't know(31)/Refused(32)
    - Q_E8e: Other - Yes(33)/No(34)/Don't know(35)/Refused(36)
9. Q_E9: Interviewer Check Item - **Type**: Routing logic - 1=If E7a = "Yes", go to E10, 2=Otherwise, go to SECTION F (page 47)
10. Q_E10: For the RESP only, how much money in total has been contributed to RESPs for these children by people living in your household? - **Type**: Currency (open entry, $___,___) - 7=Don't know, 8=Refused [E7a=Yes]
11. Q_E11: Which types of RESPs are being used? - **Type**: Matrix (2 sub-items x 4 responses) [E7a=Yes]
    - Q_E11a: Individual plan (includes individual non-family and family RESPs) - Yes(01)/No(02)/Don't know(03)/Refused(04)
    - Q_E11b: Group plan (education scholarship trust or foundation) - Yes(05)/No(06)/Don't know(07)/Refused(08)

### Section F - Children Outside the Household - 12 questions

1. Q_F1: Are you or anyone else living in your household saving for the post-secondary education of any children 18 years of age or younger who do not live in your household? - **Type**: Radio - 1=Yes, 2=No [No -> Go to SECTION G (page 49)]
2. Q_F2: For how many children is money being saved? - **Type**: Numeric (open entry) [F1=Yes]
3. Q_F3: What is the relationship of these children to the people saving money for them? (MARK ALL THAT APPLY) - **Type**: Checkbox (multi-select) - 01=Son, 02=Daughter, 03=Grandson, 04=Granddaughter, 05=Brother, 06=Sister, 07=Niece, 08=Nephew, 09=Other family member or relative, 10=Unrelated [F1=Yes]
4. Q_F4: How much money was saved for these children's education in 1998 by you or anyone else living in your household? Do not include any earnings or interest. - **Type**: Currency (open entry, $___,___) - 1=Don't know, 2=Refused [F1=Yes]
5. Q_F5: How much money was saved for these children's education so far in 1999 by you or anyone else living in your household? Do not include any earnings or interest. - **Type**: Currency (open entry, $___,___) - 3=Don't know, 4=Refused [F1=Yes]
6. Q_F6: How much money will you or anyone else in your household save for these children in the rest of 1999? - **Type**: Currency (open entry, $___,___) - 5=Don't know, 6=Refused [F1=Yes]
7. Q_F7: Since starting to save for these children, how much money in total has been saved by you or anyone else living in your household for their education? Do not include any earnings or interest. - **Type**: Currency (open entry, $___,___) - 7=Don't know, 8=Refused [F1=Yes]
8. Q_F8: What types of savings plans are being used by people in your household to save for these children's post-secondary education? - **Type**: Matrix (4 sub-items x 4 responses) [F1=Yes]
    - Q_F8a: RESPs (Registered Education Savings Plans) - Yes(01)/No(02)/Don't know(03)/Refused(04)
    - Q_F8b: RRSPs (Registered Retirement Savings Plans) - Yes(05)/No(06)/Don't know(07)/Refused(08)
    - Q_F8c: "In-trust for" accounts - Yes(09)/No(10)/Don't know(11)/Refused(12)
    - Q_F8d: Other - Yes(13)/No(14)/Don't know(15)/Refused(16)
    [If F8a,b,c,d are all answered "No", "Don't know" or "Refused", go to SECTION G (page 49)]
9. Q_F9: Within these plans, how are the savings invested? - **Type**: Matrix (5 sub-items x 4 responses)
    - Q_F9a: Mutual funds - Yes(17)/No(18)/Don't know(19)/Refused(20)
    - Q_F9b: Shares of corporations - Yes(21)/No(22)/Don't know(23)/Refused(24)
    - Q_F9c: Savings or chequing accounts - Yes(25)/No(26)/Don't know(27)/Refused(28)
    - Q_F9d: Savings bonds - Yes(29)/No(30)/Don't know(31)/Refused(32)
    - Q_F9e: Other - Yes(33)/No(34)/Don't know(35)/Refused(36)
10. Q_F10: Interviewer Check Item - **Type**: Routing logic - 1=If F8a = "Yes", go to F11, 2=Otherwise, go to SECTION G (page 49)
11. Q_F11: For the RESPs only, how much money in total has been contributed to RESPs for these children by people living in your household? - **Type**: Currency (open entry, $___,___) - 7=Don't know, 8=Refused [F8a=Yes]
12. Q_F12: Which types of RESPs are being used? - **Type**: Matrix (2 sub-items x 4 responses) [F8a=Yes]
    - Q_F12a: Individual plan (includes individual non-family and family RESPs) - Yes(01)/No(02)/Don't know(03)/Refused(04)
    - Q_F12b: Group plan (education scholarship trust or foundation) - Yes(05)/No(06)/Don't know(07)/Refused(08)

### Section G - General Information - 13 questions

1. Q_G1: Interviewer Check Item - **Type**: Routing logic - No children 0-18 in household: 1=No educational savings in SECTION F (F1=NO), go to G11 (page 52), 2=Otherwise, go to G6 (page 50). Children 0-18 in household: 3=Ages of ALL children in household 00-04, go to G4, 4=Otherwise, go to G2
2. Q_G2: Is there a computer available in your household that the children can use to do their school work or assignments? - **Type**: Radio - 5=Yes, 6=No, 7=Don't know, 8=Refused [children 0-18 in household, at least one age >= 05]
3. Q_G3: Are there books or other reading materials in the home for the children to use to do school work or assignments? (e.g. encyclopaedias, reference books, CD ROMs) - **Type**: Radio - 1=Yes, 2=No, 7=Don't know, 8=Refused [children 0-18 in household, at least one age >= 05]
4. Q_G4: Thinking of the children in your household, to which ethnic or cultural group(s) do the ancestors of their mother belong? (MARK ALL THAT APPLY.) - **Type**: Checkbox (multi-select) - 01=Canadian, 02=Chinese, 03=Dutch (Netherlands), 04=English, 05=French, 06=German, 07=Inuit/Eskimo, 08=Irish, 09=Italian, 10=Jewish, 11=Metis, 12=North American Indian, 13=Polish, 14=Scottish, 15=South Asian, 16=Ukrainian, 17=Other - Specify (open text), 97=Don't know, 98=Refused
5. Q_G5: Thinking of the children in your household, to which ethnic or cultural group(s) do the ancestors of their father belong? (MARK ALL THAT APPLY.) - **Type**: Checkbox (multi-select) - 18=Canadian, 19=Chinese, 20=Dutch (Netherlands), 21=English, 22=French, 23=German, 24=Inuit/Eskimo, 25=Irish, 26=Italian, 27=Jewish, 28=Metis, 29=North American Indian, 30=Polish, 31=Scottish, 32=South Asian, 33=Ukrainian, 34=Other - Specify (open text), 97=Don't know, 98=Refused
6. Q_G6: What is the language spoken most often in your household? (ACCEPT MULTIPLE RESPONSES ONLY IF LANGUAGES ARE SPOKEN EQUALLY.) - **Type**: Checkbox (multi-select) - 01=English, 02=French, 03=Arabic, 04=Chinese, 05=German, 06=Italian, 07=Polish, 08=Portuguese, 09=Punjabi, 10=Spanish, 11=Tagalog (Filipino), 12=Vietnamese, 13=Other language - Specify (open text), 97=Don't know, 98=Refused
7. Q_G7: What other languages are spoken in your household? (MARK ALL THAT APPLY.) - **Type**: Checkbox (multi-select) - 14=No other languages spoken, 15=English, 16=French, 17=Arabic, 18=Chinese, 19=German, 20=Italian, 21=Polish, 22=Portuguese, 23=Punjabi, 24=Spanish, 25=Tagalog (Filipino), 26=Vietnamese, 27=Other language - Specify (open text), 97=Don't know, 98=Refused
8. Q_G8: From the following list, what is your household's highest financial priority? (READ LIST.) - **Type**: Radio - 1=Everyday budget, 2=Savings for post-secondary education, 3=Retirement savings, 4=Other savings, 7=Don't know, 8=Refused
9. Q_G9: Thinking about your total household income, from which of the following sources did your household receive any income in the past 12 months? (READ LIST. MARK ALL THAT APPLY.) - **Type**: Checkbox (multi-select) - 01=Wages and salaries, 02=Income from self-employment, 03=Dividends and interest (e.g. on bonds, deposits, etc.), 04=Employment insurance, 05=Workers' compensation, 06=Benefits from Canada or Quebec Pension Plan, 07=Retirement pensions, superannuation and annuities, 08=Old Age Security and Guaranteed Income Supplement, 09=Child Tax Benefit, 10=Provincial or municipal social assistance or welfare, 11=Child support, 12=Alimony, 13=Other, 14=None
10. Q_G10: What is your best estimate of the total income before taxes and deductions of all household members from all sources in the past 12 months? Was the total household income... - **Type**: Radio (branching/unfolding) - 01=Less than $20,000, 02=$20,000 or more, 03=No income, 97=Don't know, 98=Refused. If 01: 04=Less than $10,000, 05=$10,000 or more. If 04: 08=Less than $5,000, 09=$5,000 or more. If 05: 10=Less than $15,000, 11=$15,000 or more. If 02: 06=Less than $40,000, 07=$40,000 or more. If 06: 12=Less than $30,000, 13=$30,000 or more. If 07: 14=Less than $50,000, 15=$50,000 to less than $60,000, 16=$60,000 to less than $80,000, 17=$80,000 or more
11. Q_G11: Do you agree to let Statistics Canada share your information? (data sharing agreement under Section 12 of the Statistics Act with Human Resources Development Canada) - **Type**: Radio - 4=Yes, 5=No, 7=Don't know, 8=Refused
12. Q_G12: Interviewer Check Item - **Type**: Routing logic - 1=If no children 0-18 years old in the household, END INTERVIEW, 2=Otherwise, go to G13
13. Q_G13: Do you agree to let Statistics Canada combine this information? (combine interview data with post-secondary school records from ministries of education or educational institutions, for aggregate statistics) - **Type**: Radio - 1=Yes, 2=No, 7=Don't know, 8=Refused

## Summary Statistics

### Unique question template counts (by section):
| Section | Description | Respondent Questions | Interviewer Check Items | Total Items |
|---------|-------------|---------------------|------------------------|-------------|
| A | Introduction/Screening | 2 | 1 | 3 |
| B | Child 1 - General & Savings | 38 | 6 | 44 |
| C | Child 2 (repeat of B) | 38 | 6 | 44 |
| D | Child 3 (repeat of B) | 38 | 6 | 44 |
| E | Remaining children savings | 9 | 2 | 11 |
| F | Children outside household | 10 | 2 | 12 |
| G | General information | 11 | 2 | 13 |

### Sub-question breakdown for Section B template (applies to B, C, D):
- B15: 3 sub-items (a-c)
- B17: 7 sub-items (a-g)
- B25: 4 sub-items (a-d)
- B27: 4 sub-items (a-d)
- B28: 3 sub-items (a-c)
- B29: 3 sub-items (a-c)
- B37: 4 sub-items (a-d)
- B38: 5 sub-items (a-e)
- B41: 2 sub-items (a-b)

### Sub-question breakdown for Section E:
- E7: 4 sub-items (a-d)
- E8: 5 sub-items (a-e)
- E11: 2 sub-items (a-b)

### Sub-question breakdown for Section F:
- F8: 4 sub-items (a-d)
- F9: 5 sub-items (a-e)
- F12: 2 sub-items (a-b)

### Sub-question breakdown for Section G:
- G4: 17 options (multi-select)
- G5: 17 options (multi-select)
- G6: 13 options (multi-select)
- G7: 14 options (multi-select)
- G9: 14 options (multi-select)
- G10: branching tree with up to 17 leaf codes

## TOTAL UNIQUE QUESTION NODES: ~171

Counting each numbered question (including sub-questions as individual nodes):
- Section A: 3 (A1, A2, A3)
- Section B: 44 top-level items, expanding to ~63 with sub-questions (B1-B3, B4-B7, B8-B9, B10-B14, B15a-c, B16, B17a-g, B18-B19, B20-B24, B25a-d, B26, B27a-d, B28a-c, B29a-c, B30, B31-B36, B37a-d, B38a-e, B39, B40, B41a-b, B42-B44)
- Section C: ~63 (identical to B)
- Section D: ~63 (identical to B)
- Section E: 11 top-level, expanding to ~22 with sub-questions
- Section F: 12 top-level, expanding to ~23 with sub-questions
- Section G: 13 top-level items (G1-G13)

**Unique question template nodes** (deduplicating B/C/D since they are identical): **~124**
**Total instantiated question nodes** (all sections): **~250**
