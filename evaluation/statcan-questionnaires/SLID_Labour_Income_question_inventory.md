# SLID (Survey of Labour and Income Dynamics) - 1994 Preliminary Interview Questionnaire - Question Inventory

## Document Overview
- **Title**: 1994 Preliminary Interview Questionnaire
- **Catalogue No.**: 94-10
- **Organization**: Statistics Canada, Household Surveys Division
- **Authors**: Alison Hale, Debbie Lutz, Mike Brule
- **Date**: June 1994
- **Pages**: 60 (46 pages of questionnaire content + appendix flowcharts)
- **Language**: English
- **Type**: Computer-Assisted Interviewing (CAI) Preliminary Interview questionnaire for the Survey of Labour and Income Dynamics (SLID)

## Structure
The questionnaire is organized into 4 modules collected sequentially:
1. **EMPPRE** (Employment) - Current or recent work activity; information on up to two employers (Job 1 = J1, Job 2 = J2)
2. **EXPRE** (Experience) - Work experience history since first started working
3. **DEMPRE** (Demographics) - Marital history, birth history, mother tongue, place of birth, ethnic origin, parents' education
4. **EDUPRE** (Education) - Educational attainment and current educational activity

Pre-fill items (in square brackets) include: [respondent], [current year], [reference year], [age], and [response given in ...]. Internal logic nodes (marked with *) are computer-determined routing decisions invisible to the interviewer. Questions in CAPS are read aloud; those prefixed "Interviewer:" are interviewer instructions.

---

## Question Inventory by Section

### EMPPRE Module (Employment) - 62 questions

**Entry gate and initial employment status:**

1. **START-EMPPRE**: [Internal logic] [age] = 15 or more? - Binary routing: Yes -> EMPPRE-Q1; No -> EXPRE-Q1A

2. **EMPPRE-Q1**: DID [respondent] WORK AT A JOB OR BUSINESS AT THE BEGINNING OF JANUARY OF THIS YEAR? [Interviewer: Enter a job regardless of the number of hours worked.] - Choice: Yes -> EMPPRE-J1.Q1; No -> EMPPRE-Q2; Permanently unable to work -> EMPPRE-Q5; DK/R -> EMPPRE-N12

3. **EMPPRE-Q2**: DID [respondent] HAVE A JOB OR BUSINESS AT WHICH HE/SHE DID NOT WORK AT THE BEGINNING OF JANUARY? - Choice: Yes -> EMPPRE-Q3; No/DK/R -> EMPPRE-Q5

4. **EMPPRE-Q3**: WHY WAS [respondent] ABSENT FROM WORK AT THE BEGINNING OF JANUARY? - Single choice: Own illness or disability; Pregnancy; Caring for own children; Caring for elder relatives; Other personal or family responsibilities; School or educational leave; Labour dispute; Temporary layoff due to seasonal conditions; Temporary layoff - non seasonal; Unpaid or partially paid vacation; Other (Specify) [If "School or educational leave" -> EMPPRE-Q5; Otherwise -> EMPPRE-Q4]

5. **EMPPRE-Q4**: DID [respondent] RECEIVE ANY PAY FROM HIS/HER EMPLOYER FOR THIS ABSENCE? - Choice: Yes/No/DK/R

6. **EMPPRE-N4**: [Internal logic] EMPPRE-Q3 = Temporary Layoff? - Routing: Yes -> EMPPRE-Q8; Otherwise -> EMPPRE-J1.Q1

7. **EMPPRE-Q5**: DID [respondent] EVER WORK AT A JOB OR BUSINESS? - Choice: Yes/DK/R -> EMPPRE-Q6; No -> EMPPRE-N7

8. **EMPPRE-Q6**: WHEN DID [respondent] LAST WORK AT A JOB OR BUSINESS? - Date (DD/MM/YY): Hard range: Min = current year-(age-10), Max = current year

9. **EMPPRE-N6**: [Internal logic] Date in EMPPRE-Q6 is before January [current year] minus 5 and EMPPRE-Q1 = permanently unable to work? - Routing: Yes -> EMPPRE-N12; Otherwise -> EMPPRE-Q7

10. **EMPPRE-Q7**: WHAT WAS [respondent]'S MAIN REASON FOR LEAVING THIS JOB? - Single choice: Own illness, disability; Caring for own children; Caring for elder relatives; Other personal or family responsibilities; Going to school; Quit job for no specific reason; Lost job or laid off job - Paid workers only; Changed residence; Dissatisfied with job; Retired; Other - Specify

11. **EMPPRE-N7**: [Internal logic] EMPPRE-Q1 = permanently unable to work? - Routing: Yes -> EMPPRE-N12; Otherwise -> EMPPRE-Q8

12. **EMPPRE-Q8**: DID [respondent] LOOK FOR WORK IN JANUARY OF THIS YEAR? - Choice: Yes -> EMPPRE-Q9; No/DK/R -> EMPPRE-Q10

13. **EMPPRE-Q9**: WHAT DID [respondent] DO TO FIND WORK? - Single choice: Contacted employer directly; Friend or relative; Placed or answered newspaper ad; Employment agency; Referral from another employer; Other - specify

14. **EMPPRE-N11A**: [Internal logic] EMPPRE-Q5=no (never worked) or dates last worked (EMPPRE-Q6) is before January [reference year]? - Routing: Yes -> EMPPRE-N12; Otherwise -> EMPPRE-J1.Q1A

15. **EMPPRE-Q10**: DID [respondent] LOOK FOR WORK AT ANY TIME IN THE 6 MONTHS BEFORE THAT? - Choice: Yes/DK/R -> EMPPRE-Q11; No -> EMPPRE-N11A

16. **EMPPRE-Q11**: WHAT WERE THE REASONS [respondent] DID NOT LOOK FOR WORK IN JANUARY OF THIS YEAR? [Interviewer: if only answered Own illness or Personal responsibilities, probe for other reasons.] - Multiple choice: Own illness, disability; Caring for own children; Caring for elder relatives; Other personal or family responsibilities; Going to school; No longer interested in finding work; Waiting for recall (to former job); Has found new job; Waiting for replies from employers; Believes no work available (in area, or suited to skills); No reason given; Other - Specify [-> EMPPRE-N11A]

17. **EMPPRE-N12**: [Internal logic] [age] is greater than 64 years? - Routing: Yes -> EXPRE-Q1; Otherwise -> EMPPRE-Q12

18. **EMPPRE-Q12**: IN JANUARY OF THIS YEAR, WAS [respondent] ATTENDING A SCHOOL, COLLEGE OR UNIVERSITY? - Choice: Yes -> EMPPRE-Q13; No/DK/R -> EXPRE-Q1A

19. **EMPPRE-Q13**: WAS [respondent] ENROLLED AS A FULL-TIME OR PART-TIME STUDENT? - Choice: Full-time student; Part-time student; Some of each [-> EXPRE-Q1A]

**Job 1 questions (J1 series):**

20. **EMPPRE-J1.Q1**: I WOULD LIKE TO ASK A FEW QUESTIONS ABOUT [respondent]'S MAIN JOB OR BUSINESS IN EARLY JANUARY. FOR WHOM DID [respondent] WORK? (name of business, government department, or agency, or person) - Open text [-> EMPPRE-J1.Q2]

21. **EMPPRE-J1.Q1A**: I WOULD LIKE TO ASK A FEW QUESTIONS ABOUT THE LAST JOB OR BUSINESS HELD BY [respondent] IN [reference year]. FOR WHOM DID [respondent] WORK? (name of business, government department, or agency, or person) - Open text

22. **EMPPRE-J1.Q2**: WHEN WAS THE FIRST TIME [respondent] STARTED WORKING FOR THIS EMPLOYER? - Date (DD/MM/YY): Hard range: Min = [current year]-[age]-10, Max = [current year]

23. **EMPPRE-J1.N2**: [Internal logic] Date first started working (EMPPRE-J1.Q2) is before date last worked (EMPPRE-Q6)? - Routing: Yes -> EMPPRE-J1.Q3; No -> EMPPRE-J1.Q2A; Otherwise -> EMPPRE-J1.Q3

24. **EMPPRE-J1.Q2A**: [Interviewer: Date first started working for this employer (EMPPRE-J1.Q2) is after the date last worked (EMPPRE-Q6). Go back to EMPPRE-Q6 and/or EMPPRE-J1.Q2 to correct inconsistencies, or press Enter to continue.] - Consistency check / interviewer instruction

25. **EMPPRE-J1.Q3**: WHAT KIND OF BUSINESS, INDUSTRY OR SERVICE WAS THIS? (e.g., federal government, canning industry, forestry service) - Open text

26. **EMPPRE-J1.Q4**: WHAT KIND OF WORK WAS [respondent] DOING? (e.g., office clerk, factory worker, forestry technician) - Open text

27. **EMPPRE-J1.Q5**: WHAT WERE [respondent]'S MOST IMPORTANT ACTIVITIES OR DUTIES? (e.g., filing documents, drying vegetables, forest examiner) - Open text

28. **EMPPRE-J1.Q6**: IN THIS JOB, WAS [respondent] A PAID WORKER, SELF-EMPLOYED OR AN UNPAID FAMILY WORKER? - Single choice: Paid worker; Unpaid family worker; Self-employed Incorporated - With paid help; Self-employed Incorporated - No paid help; Self-employed Unincorporated - With paid help; Self-employed Unincorporated - No paid help [If paid worker or DK/R -> EMPPRE-J1.Q7A; Otherwise -> EMPPRE-N12]

29. **EMPPRE-J1.Q7A**: IN WHICH MONTHS OF [reference year] DID [respondent] WORK AT THIS JOB? - Choice: All months/DK/R -> EMPPRE-J1.Q8; Started in [current year] -> EMPPRE-N12; Specify months -> EMPPRE-J1.Q7B; Last worked before [reference year] -> EMPPRE-J1.Q7B

30. **EMPPRE-J1.Q7B**: [Interviewer: Specify months [respondent] worked in [reference year]] - Multiple choice (month checkboxes): January; February; March; April; May; June; July; August; September; October; November; December

31. **EMPPRE-J1.Q8**: AT THIS JOB, DID [respondent] USUALLY WORK EVERY WEEK OF THE MONTH? - Choice: Yes/DK/R -> EMPPRE-J1.Q10; No -> EMPPRE-J1.Q9

32. **EMPPRE-J1.Q9**: HOW MANY WEEKS DID [respondent] USUALLY WORK EACH MONTH? - Numeric: Hard range: Min = 1, Max = 3

33. **EMPPRE-J1.Q10**: HOW MANY HOURS PER WEEK DID [respondent] USUALLY GET PAID? - Numeric: Hard range: Min = 1.0, Max = 99.9

34. **EMPPRE-J1.Q11A**: AT THIS JOB, WHAT WAS [respondent]'S WAGE OR SALARY BEFORE TAXES AND DEDUCTIONS? (As of January of this year or when they last worked for this employer in [reference year]). - Numeric (currency): Hard range: Min = 0.01, Max = 999999.99

35. **EMPPRE-J1.Q11B**: [Interviewer: Select the appropriate category for reported wage or salary] - Single choice: Hourly; Weekly; Every two weeks/twice a month; Monthly; Yearly; Other (specify) [If Other -> EMPPRE-J1.Q12; Otherwise -> EMPPRE-J1.Q13]

36. **EMPPRE-J1.Q12**: WHAT WERE [respondent]'S TOTAL EARNINGS FROM THIS JOB IN [reference year]? - Numeric (currency): Hard range: Min = 0.01, Max = 999999.99

37. **EMPPRE-J1.Q13**: DID [respondent] RECEIVE ANY COMMISSIONS, TIPS, BONUSES OR PAID OVERTIME FROM THIS JOB IN [reference year]? - Choice: Yes -> EMPPRE-J1.Q14; No/DK/R -> EMPPRE-J2.Q1

38. **EMPPRE-J1.Q14**: WERE THESE COMMISSIONS, TIPS, BONUSES OR PAID OVERTIME INCLUDED IN THE AMOUNT JUST REPORTED? - Choice: Yes/DK/R -> EMPPRE-J2.Q1; No -> EMPPRE-J1.Q15

39. **EMPPRE-J1.Q15**: WHAT WERE [respondent]'S TOTAL EARNINGS IN [reference year] FROM THESE COMMISSIONS, TIPS, BONUSES, OR PAID OVERTIME? - Numeric (currency): Hard range: Min = 0.01, Max = 999999.99 [-> EMPPRE-N12]

**Job 2 questions (J2 series):**

40. **EMPPRE-J2.Q1**: DID [respondent] HAVE MORE THAN ONE JOB OR BUSINESS IN JANUARY OF THIS YEAR? - Choice: Yes -> EMPPRE-J2.Q2; No/DK/R -> EMPPRE-N12

41. **EMPPRE-J2.Q2**: I WOULD LIKE TO ASK A FEW QUESTIONS ABOUT [respondent]'S OTHER JOB OR BUSINESS IN JANUARY OF THIS YEAR. FOR WHOM DID [respondent] WORK? (name of business, government department, or agency, or person) - Open text

42. **EMPPRE-J2.Q3**: WHEN DID [respondent] FIRST START WORKING FOR THIS EMPLOYER? - Date (DD/MM/YY): Hard range: Min = [current year]-[age]-10, Max = [current year]

43. **EMPPRE-J2.Q4**: WHAT KIND OF BUSINESS, INDUSTRY OR SERVICE WAS THIS? (e.g., federal government, canning industry, forestry services) - Open text

44. **EMPPRE-J2.Q5**: WHAT KIND OF WORK WAS [respondent] DOING? (e.g., office clerk, factory worker, forestry technician) - Open text

45. **EMPPRE-J2.Q6**: WHAT WERE [respondent]'S MOST IMPORTANT ACTIVITIES OR DUTIES? (e.g., filing documents, drying vegetables, forest examiner) - Open text

46. **EMPPRE-J2.Q7**: IN THIS JOB, WAS [respondent] A PAID WORKER, SELF-EMPLOYED OR AN UNPAID FAMILY WORKER? - Single choice: Paid worker; Unpaid family worker; Self-employed Incorporated - With paid help; Self-employed Incorporated - No paid help; Self-employed Unincorporated - With paid help; Self-employed Unincorporated - No paid help [If paid worker or DK/R -> EMPPRE-J2.Q8A; Otherwise -> EMPPRE-Q12]

47. **EMPPRE-J2.Q8A**: IN WHICH MONTHS OF [reference year] DID [respondent] WORK AT THIS JOB? - Choice: All months/DK/R -> EMPPRE-J2.Q9; Started in [current year] -> EMPPRE-N12; Specify months -> EMPPRE-J2.Q8B; Last worked before [reference year] -> EMPPRE-J2.Q8B

48. **EMPPRE-J2.Q8B**: [Interviewer: Specify months [respondent] worked in [reference year]?] - Multiple choice (month checkboxes): January; February; March; April; May; June; July; August; September; October; November; December

49. **EMPPRE-J2.Q9**: AT THIS JOB, DID [respondent] USUALLY WORK EVERY WEEK OF THE MONTH? - Choice: Yes/DK/R -> EMPPRE-J2.Q11; No -> EMPPRE-J2.Q10

50. **EMPPRE-J2.Q10**: HOW MANY WEEKS DID [respondent] USUALLY WORK EACH MONTH? - Numeric: Hard range: Min = 1, Max = 3

51. **EMPPRE-J2.Q11**: HOW MANY HOURS PER WEEK DID [respondent] USUALLY GET PAID? - Numeric: Hard range: Min = 1.0, Max = 99.9

52. **EMPPRE-J2.Q12A**: AT THIS JOB, WHAT WAS [respondent]'S WAGE OR SALARY BEFORE TAXES AND DEDUCTIONS? - Numeric (currency): Hard range: Min = 0.01, Max = 999999.99

53. **EMPPRE-J2.Q12B**: [Interviewer: Select the appropriate category for reported wage or salary.] - Single choice: Hourly; Weekly; Every two weeks/twice a month; Monthly; Yearly; Other (specify) [If Other -> EMPPRE-J2.Q13; Otherwise -> EMPPRE-J2.Q14]

54. **EMPPRE-J2.Q13**: WHAT WERE [respondent]'S TOTAL EARNINGS FROM THIS JOB IN [reference year]? - Numeric (currency): Hard range: Min = 0.01, Max = 999999.99

55. **EMPPRE-J2.Q14**: DID [respondent] RECEIVE ANY COMMISSIONS, TIPS, BONUSES OR PAID OVERTIME FROM THIS JOB IN [reference year]? - Choice: Yes -> EMPPRE-J2.Q15; No/DK/R -> EMPPRE-N12

56. **EMPPRE-J2.Q15**: WERE THESE COMMISSIONS, TIPS, BONUSES OR PAID OVERTIME INCLUDED IN THE AMOUNT JUST REPORTED? - Choice: Yes/DK/R -> EMPPRE-N12; No -> EMPPRE-J2.Q16

57. **EMPPRE-J2.Q16**: WHAT WERE [respondent]'S TOTAL EARNINGS IN [reference year] FROM THESE COMMISSIONS, TIPS, BONUSES, OR PAID OVERTIME? - Numeric (currency): Hard range: Min = 0.01, Max = 999999.99 [-> EMPPRE-N12]

---

### EXPRE Module (Experience) - 16 questions

58. **EXPRE-N1**: [Internal logic] [age] is greater than 69 years? - Routing: Yes -> DEMPRE-Q1A; Otherwise -> EXPRE-Q1A

59. **EXPRE-Q1A**: THE NEXT FEW QUESTIONS ARE ABOUT [respondent]'S WORK EXPERIENCE, THINKING BACK TO WHEN HE/SHE FIRST STARTED WORKING AT A JOB OR BUSINESS. DID [respondent] EVER WORK FULL-TIME? (Exclude summer jobs while in school) - Choice: Yes -> EXPRE-Q1B; No, never worked full-time -> DEMPRE-Q1A; No, only worked full-time at summer jobs while in school -> DEMPRE-Q1A; DK/R -> DEMPRE-Q1A

60. **EXPRE-Q1B**: HOW MANY YEARS AGO DID [respondent] FIRST START WORKING FULL-TIME? (Exclude summer jobs while in school) [Interviewer: Enter 00 if less than one year] - Numeric: Hard range: Min = 0, Max = [age]-10 [If DK/R or 0 -> DEMPRE-Q1A; If answered 1 year -> EXPRE-Q3; Otherwise -> EXPRE-Q2A]

61. **EXPRE-Q2A**: IN THOSE [response given in EXPRE-Q1B] YEARS, WERE THERE ANY YEARS WHEN [respondent] DID NOT WORK AT A JOB OR BUSINESS? - Choice: Yes -> EXPRE-Q2B; No/DK/R -> EXPRE-Q3

62. **EXPRE-Q2B**: HOW MANY YEARS DID [respondent] NOT WORK AT A JOB OR BUSINESS? - Numeric: Hard range: Min = 1, Max = [response given in EXPRE-Q1B] [-> EXPRE-Q5A]

63. **EXPRE-Q3**: IN THOSE [response given in EXPRE-Q1B] YEARS, DID [respondent] WORK AT LEAST 6 MONTHS EACH AND EVERY YEAR? - Choice: Yes/DK/R -> EXPRE-Q4A; No -> EXPRE-Q5A

64. **EXPRE-Q4A**: HOW MANY YEARS DID HE/SHE WORK ONLY FULL-TIME? (by full-time I mean 30 or more hours per week) [Interviewer: If none enter 00] - Numeric: Hard range: Min = 0, Max = [response given in EXPRE-Q1B]

65. **EXPRE-Q4B**: HOW MANY YEARS DID HE/SHE WORK ONLY PART-TIME? [Interviewer: If none enter 00] - Numeric: Hard range: Min = 0, Max = [response given in EXPRE-Q1B]

66. **EXPRE-Q4C**: HOW MANY YEARS DID HE/SHE ONLY WORK SOME OF EACH (full-time and part-time) [Interviewer: If none enter 00] - Numeric: Hard range: Min = 0, Max = [response given in EXPRE-Q1B]

67. **EXPRE-N4**: [Internal logic] Sum of Q4A/B/C = EXPRE-Q1B? - Routing: Yes -> DEMPRE-Q1A; Otherwise -> EXPRE-Q4D

68. **EXPRE-Q4D**: [Interviewer: [respondent] has worked full-time for [answer in EXPRE-Q4A] years, part-time for [answer in EXPRE-Q4B] years, and some of each for [answer in EXPRE-Q4C] years. Conflict with when started working full-time [answer in EXPRE-Q1B] years ago. If incorrect go back to previous questions and make necessary changes. Otherwise press Enter to continue.] - Consistency check / interviewer instruction

69. **EXPRE-Q5A**: SINCE [respondent] FIRST STARTED WORKING, HOW MANY YEARS DID HE/SHE WORK AT LEAST 6 MONTHS OF THE YEAR? [Interviewer: If none enter 00] - Numeric: Hard range: Min = 0, Max = [response given in EXPRE-Q1B] minus [response given in EXPRE-Q2B] (if Q2B not answered use Q1B as maximum) [If 0/DK/R -> DEMPRE-Q1A; Otherwise -> EXPRE-Q6A]

70. **EXPRE-Q6A**: IN THOSE [response given in EXPRE-Q5A] YEARS, HOW MANY DID HE/SHE WORK ONLY FULL-TIME? (by full-time I mean 30 or more hours per week) [Interviewer: If none enter 00] - Numeric: Hard range: Min = 0, Max = [response given in EXPRE-Q5A]

71. **EXPRE-Q6B**: IN THOSE [response given in EXPRE-Q5A] YEARS, HOW MANY DID HE/SHE WORK ONLY PART-TIME? [Interviewer: If none enter 00] - Numeric: Hard range: Min = 0, Max = [response given in EXPRE-Q5A]

72. **EXPRE-Q6C**: IN THOSE [response given in EXPRE-Q5A] YEARS, HOW MANY DID HE/SHE ONLY WORK SOME OF EACH? (full-time and part-time) [Interviewer: If none enter 00] - Numeric: Hard range: Min = 0, Max = [response given in EXPRE-Q5A]

73. **EXPRE-N6**: [Internal logic] Sum of Q6A/B/C = EXPRE-Q5A? - Routing: Yes -> DEMPRE-Q1A; Otherwise -> EXPRE-Q6D

74. **EXPRE-Q6D**: [Interviewer: [respondent] is shown working full-time for [answer in EXPRE-Q6A] years, part-time for [answer in EXPRE-Q6B] years, and some of each for [answer in EXPRE-Q6C] years. Conflicts with # of years they worked more than six months [answer in EXPRE-Q5A]. If incorrect go back to previous questions and make necessary changes. Otherwise press Enter to continue.] - Consistency check / interviewer instruction

---

### DEMPRE Module (Demographics) - 38 questions

**Introduction and marital status routing:**

75. **DEMPRE-Q1A**: THE NEXT FEW QUESTIONS ARE ABOUT [respondent]'S FAMILY BACKGROUND AND ARE BASED ON THE DATE OF BIRTH AND MARITAL STATUS REPORTED EARLIER IN THE INTERVIEW. - Introduction / read-aloud statement

76. **DEMPRE-N1**: [Internal logic] Marital status = married? - Routing: Yes -> DEMPRE-Q2B

77. **DEMPRE-N1A**: [Internal logic] Marital status = common-in-law? - Routing: Yes -> DEMPRE-Q5

78. **DEMPRE-N1B**: [Internal logic] Marital status = separated? - Routing: Yes -> DEMPRE-Q1

79. **DEMPRE-N1C**: [Internal logic] Marital status = divorced? - Routing: Yes -> DEMPRE-Q1

80. **DEMPRE-N1D**: [Internal logic] Marital status = widowed? - Routing: Yes -> DEMPRE-Q7

81. **DEMPRE-N1E**: [Internal logic] Marital status = single (never married)? - Routing: Yes -> DEMPRE-N11A

82. **DEMPRE-N1F**: [Internal logic] Marital status = DK/R? - Routing: Yes -> DEMPRE-N11A

**Separation/divorce path:**

83. **DEMPRE-Q1**: WHAT WAS THE DATE OF [respondent]'S SEPARATION? (Not the date of divorce) - Date (DD/MM/YY): Hard range: Min = [current year] minus [age] minus 14, Max = [current year]

84. **DEMPRE-Q2**: WHAT WAS THE DATE OF THIS MARRIAGE? - Date (DD/MM/YY): Hard range: Min = [current year] minus [age] minus 14, Max = [current year] [-> COMPARE-Q2]

85. **COMPARE-Q2**: [Internal logic] Date of this marriage (DEMPRE-Q2) is before date of separation (DEMPRE-Q1)? - Routing: No -> DEMPRE-Q2A; Otherwise -> DEMPRE-Q3

86. **DEMPRE-Q2A**: [Interviewer: Date of marriage [response in DEMPRE-Q2] is after date of separation [response in DEMPRE-Q1]. If information is incorrect go to previous questions to correct inconsistencies. Otherwise press Enter to continue.] - Consistency check / interviewer instruction

**Married path:**

87. **DEMPRE-Q2B**: WHAT WAS THE DATE OF [respondent]'S MARRIAGE? - Date (DD/MM/YY): Hard range: Min = [current year] minus [age] minus 14, Max = [current year]

88. **DEMPRE-Q3**: WAS THIS [respondent]'S FIRST MARRIAGE? - Choice: Yes/DK/R -> DEMPRE-N11A; No -> DEMPRE-Q4

89. **DEMPRE-Q4**: WHAT WAS THE DATE OF [respondent]'S FIRST MARRIAGE? - Date (DD/MM/YY): Hard range: Min = [current year] minus [age] minus 14, Max = [current year]

90. **COMPARE-Q4**: [Internal logic] Date of first marriage (DEMPRE-Q4) is before date of current marriage (DEMPRE-Q2)? - Routing: No -> DEMPRE-Q4A; Otherwise -> DEMPRE-N11A

91. **DEMPRE-Q4A**: [Interviewer: Date of marriage [response in DEMPRE-Q4] should be before date of current marriage [response in DEMPRE-Q2B]. If information is incorrect go to previous questions to correct inconsistencies. Otherwise press Enter to continue.] - Consistency check / interviewer instruction

**Common-law path:**

92. **DEMPRE-Q5**: WHEN DID [respondent] AND HIS/HER PARTNER BEGIN TO LIVE TOGETHER? - Date (DD/MM/YY): Hard range: Min = [current year] minus [age] minus 14, Max = [current year]

93. **DEMPRE-Q6**: HAS [respondent] EVER BEEN MARRIED? - Choice: Yes -> DEMPRE-Q8; No/DK/R -> DEMPRE-N11A

**Widowed path:**

94. **DEMPRE-Q7**: WHEN WAS [respondent] WIDOWED? - Date (DD/MM/YY): Hard range: Min = [current year] minus [age] minus 14, Max = [current year]

95. **DEMPRE-Q8**: WAS THIS [respondent]'S FIRST MARRIAGE? - Choice: Yes/DK/R -> DEMPRE-Q9; No -> DEMPRE-Q10

96. **DEMPRE-Q9**: WHAT WAS THE DATE OF [respondent]'S MARRIAGE? - Date (DD/MM/YY): Hard range: Min = [current year] minus [age] minus 14, Max = [current year]

97. **COMPARE9A**: [Internal logic] Date of marriage (DEMPRE-Q9) is before date widowed (DEMPRE-Q7)? - Routing: No -> DEMPRE-Q9A; Otherwise -> COMPARE9B

98. **DEMPRE-Q9A**: [Interviewer: Date of previous marriage [answer in DEMPRE-Q9] should be before date widowed [answer in DEMPRE-Q7]. If information is incorrect go to previous questions to correct inconsistencies. Otherwise press Enter to continue.] - Consistency check / interviewer instruction

99. **COMPARE9B**: [Internal logic] Date of marriage (DEMPRE-Q9) is before date living together (DEMPRE-Q5)? - Routing: No -> DEMPRE-Q9B; Otherwise -> DEMPRE-N11A

100. **DEMPRE-Q9B**: [Interviewer: Date of previous marriage [answer in DEMPRE-Q9] should be before date started living together [answer in DEMPRE-Q5]. If information is incorrect go to previous questions to correct inconsistencies. Otherwise press Enter to continue.] - Consistency check / interviewer instruction

101. **DEMPRE-Q10**: WHAT WAS THE DATE OF [respondent]'S FIRST MARRIAGE? - Date (DD/MM/YY): Hard range: Min = [current year] minus [age] minus 14, Max = [current year]

102. **COMPARE10A**: [Internal logic] Date of first marriage (DEMPRE-Q10) is before date started living together (DEMPRE-Q5)? - Routing: No -> DEMPRE-Q10A; Otherwise -> COMPARE10B

103. **DEMPRE-Q10A**: [Interviewer: Date of first marriage [answer in DEMPRE-Q10] should be before date started living together [answer in DEMPRE-Q5]. If information is incorrect go to previous questions to correct inconsistencies. Otherwise press Enter to continue.] - Consistency check / interviewer instruction

104. **COMPARE10B**: [Internal logic] Date of first marriage (DEMPRE-Q10) is before date widowed (DEMPRE-Q7)? - Routing: No -> DEMPRE-Q10B; Otherwise -> DEMPRE-N11A

105. **DEMPRE-Q10B**: [Interviewer: Date of first marriage [answer in DEMPRE-Q10] should be before date widowed [answer in DEMPRE-Q7]. If information is incorrect go to previous questions to correct inconsistencies. Otherwise press Enter to continue.] - Consistency check / interviewer instruction

**Birth history (females 18+):**

106. **DEMPRE-N11A**: [Internal logic] Respondent is female 18 years of age and over? - Routing: Yes -> DEMPRE-Q11; Otherwise -> DEMPRE-Q16

107. **DEMPRE-Q11**: HAS [respondent] HAD ANY CHILDREN? - Choice: Yes -> DEMPRE-Q12; No -> DEMPRE-Q14; DK/R -> DEMPRE-Q16

108. **DEMPRE-Q12**: HOW MANY CHILDREN WERE EVER BORN TO [respondent]? [Interviewer: Enter 00 if none] - Numeric: Hard range: Min = 0, Max = 20 [If 0/DK/R -> DEMPRE-Q14; Otherwise -> DEMPRE-Q13]

109. **DEMPRE-Q13**: IN WHAT YEAR DID [respondent] GIVE BIRTH TO HER FIRST CHILD? - Year: Hard range: Min = [current year] minus [age] minus 14, Max = [current year]

110. **DEMPRE-Q14**: (Other than children [respondent] has given birth to) HAS [respondent] ADOPTED OR RAISED ANY CHILDREN? - Choice: Yes -> INPATH-Q12; No/DK/R -> DEMPRE-Q16

111. **INPATH-Q12**: [Internal logic] DEMPRE-Q11=yes and DEMPRE-Q14=no and DEMPRE-Q12 = 0? - Routing: Yes -> DEMPRE-Q14A; Otherwise -> DEMPRE-Q15

112. **DEMPRE-Q14A**: [Interviewer: In previous questions (DEMPRE-Q11 and Q12) respondent stated that she had children, but none were born to her, therefore she should have raised or adopted children (DEMPRE-Q14). If incorrect go to previous questions to correct inconsistencies. Otherwise press Enter to continue.] - Consistency check / interviewer instruction

113. **DEMPRE-Q15**: HOW MANY (other) CHILDREN HAS [respondent] ADOPTED OR RAISED? - Numeric: Hard range: Min = 1, Max = 20

**Language, birthplace, ethnicity:**

114. **DEMPRE-Q16**: WHAT IS THE LANGUAGE THAT [respondent] FIRST LEARNED AT HOME IN CHILDHOOD AND STILL UNDERSTANDS? - Choice: English; French; Other (SPECIFY)

115. **DEMPRE-Q17**: IN WHAT COUNTRY WAS [respondent] BORN? - Choice: Canada; United Kingdom; Italy; U.S.A.; Germany; Poland; Other (SPECIFY) [If Canada -> DEMPRE-Q19; Otherwise -> DEMPRE-Q18]

116. **DEMPRE-Q18**: DID [respondent] IMMIGRATE TO CANADA? - Choice: Yes -> DEMPRE-Q18B; No (never immigrated - Canadian citizen by birth) -> DEMPRE-Q19; DK/R -> DEMPRE-Q19

117. **DEMPRE-Q18B**: IN WHAT YEAR WAS THAT? - Year: Hard range: Min = [current year] minus [age], Max = [current year]

118. **DEMPRE-Q19**: IS [respondent] A REGISTERED INDIAN AS DEFINED BY THE INDIAN ACT OF CANADA? - Choice: Yes, Registered Indian; No/DK/R

119. **DEMPRE-Q20**: CANADIANS COME FROM MANY ETHNIC, CULTURAL AND RACIAL BACKGROUNDS. FOR EXAMPLE, ENGLISH, FRENCH, NORTH AMERICAN INDIAN, CHINESE, BLACK, FILIPINO OR LEBANESE. WHAT IS [respondent]'S BACKGROUND? [Interviewer: if indian, probe for North American or East. Mark all that apply.] - Multiple choice: English; French; German; Scottish; Italian; Irish; Ukrainian; Chinese; Canadian (probe for any other background); Dutch (Netherlands); Jewish; Polish; Black; Metis; Inuit/Eskimo; North American Indian; East Indian; Other (specify) [If Other -> DEMPRE-Q20A; Otherwise -> EDUPRE-Q1]

120. **DEMPRE-Q20A**: [Interviewer: Enter other ethnic background not already given in previous question.] - Open text [-> EDUPRE-Q1]

---

### EDUPRE Module (Education) - 27 questions

121. **EDUPRE-Q1**: HOW MANY YEARS OF ELEMENTARY AND HIGH SCHOOL DID [respondent] COMPLETE? - Numeric: Hard range: Min = 0, Max = 15

122. **VERIFY-Q1**: [Internal logic] Years of schooling (EDUPRE-Q1) is greater than [age] minus 5? - Routing: No -> EDUPRE-Q1A; Otherwise: if answered "0" -> EDUPRE-Q17; otherwise -> EDUPRE-Q2

123. **EDUPRE-Q1A**: [Interviewer: Years of education does not correspond with [respondent]'s age. Verify that this information is correct. If incorrect go back to previous question (EDUPRE-Q1) and make the necessary changes. Otherwise press Enter to continue.] - Consistency check / interviewer instruction

124. **EDUPRE-Q2**: IN WHICH PROVINCE OR TERRITORY DID [respondent] GET MOST OF HIS/HER ELEMENTARY AND HIGH SCHOOL EDUCATION? - Single choice: Newfoundland; Prince Edward Island; Nova Scotia; New Brunswick; Quebec; Ontario; Manitoba; Saskatchewan; Alberta; British Columbia; Yukon; Northwest Territories; Outside Canada

125. **EVAL-Q1**: [Internal logic] EDUPRE-Q1 = 1 to 9? - Routing: Yes -> EDUPRE-Q4; Otherwise -> EDUPRE-Q3

126. **EDUPRE-Q3**: DID [respondent] COMPLETE HIGH SCHOOL? - Choice: Yes; No

127. **EDUPRE-Q4**: EXCLUDING UNIVERSITY, HAS [respondent] EVER BEEN ENROLLED IN ANY OTHER KIND OF SCHOOL, FOR EXAMPLE, A COMMUNITY COLLEGE, BUSINESS SCHOOL, TRADE OR VOCATIONAL SCHOOL, OR CEGEP? - Choice: Yes/DK/R -> EDUPRE-Q5; No -> EDUPRE-Q12

128. **EDUPRE-Q5**: HAS [respondent] RECEIVED ANY CERTIFICATES OR DIPLOMAS AS A RESULT OF THIS EDUCATION? - Choice: Yes/DK/R -> EDUPRE-Q6; No -> EDUPRE-Q11

129. **EDUPRE-Q6**: THINKING OF THE MOST RECENT CERTIFICATE OR DIPLOMA (EXCLUDING UNIVERSITY) COULD YOU TELL ME WHAT TYPE OF SCHOOL OR COLLEGE [respondent] ATTENDED? WAS IT A... - Single choice: COMMUNITY COLLEGE OR INSTITUTE OF APPLIED ARTS AND TECHNOLOGY?; BUSINESS OR COMMERCIAL SCHOOL?; TRADE OR VOCATIONAL SCHOOL?; CEGEP?; SOME OTHER TYPE (Specify)

130. **EDUPRE-Q7**: HOW LONG DID IT TAKE [respondent] TO COMPLETE THIS PROGRAM? - Choice of unit: Answer given in months -> EDUPRE-Q7A; Answer given in years -> EDUPRE-Q7B; DK/R -> EDUPRE-Q8

131. **EDUPRE-Q7A**: [Interviewer: Enter # of months it took [respondent] to complete this program.] - Numeric: Hard range: Min = 1, Max = 99 [-> EDUPRE-Q8]

132. **EDUPRE-Q7B**: [Interviewer: Enter # of years it took [respondent] to complete this program.] - Numeric: Hard range: Min = 1, Max = 9 [-> EDUPRE-Q8]

133. **EDUPRE-Q8**: WAS THIS FULL-TIME, PART-TIME OR SOME OF EACH? - Single choice: Full-time; Part-time; Some of each

134. **EDUPRE-Q9**: IN WHAT YEAR DID [respondent] RECEIVE HIS/HER CERTIFICATE OR DIPLOMA? - Year: Hard range: Min = [current year] minus [age] minus 14, Max = [current year]

135. **VERIFY-Q9**: [Internal logic] Year received diploma is between current year minus age minus 14 and current year minus age minus 20? - Routing: Yes -> EDUPRE-Q9A; Otherwise -> EDUPRE-Q10

136. **EDUPRE-Q9A**: [Interviewer: Year respondent received certificate or diploma indicates he/she was [age - current year - EDUPRE-Q9] years old when they graduated. If year received certificate/diploma [answer in EDUPRE-Q9] is incorrect, go back to previous question (EDUPRE-Q9) and make necessary changes. Otherwise press Enter to continue.] - Consistency check / interviewer instruction

137. **EDUPRE-Q10**: WHAT WAS THE MAJOR SUBJECT OR FIELD OF STUDY? - Open text

138. **EDUPRE-Q11**: IN TOTAL, HOW MANY YEARS OF SCHOOLING DID [respondent] COMPLETE AT A COMMUNITY COLLEGE, TECHNICAL INSTITUTE, TRADE OR VOCATIONAL SCHOOL, OR CEGEP? [Interviewer: Enter 00 if less than one year] - Numeric: Hard range: Min = 0, Max = 20

139. **VERIFY-Q11**: [Internal logic] Years of schooling (EDUPRE-Q11) is greater than [age] minus 14? - Routing: Yes -> EDUPRE-Q11A; Otherwise -> EDUPRE-Q12

140. **EDUPRE-Q11A**: [Interviewer: Years of schooling completed in a community college etc. [EDUPRE-Q11] does not correspond to [respondent]'s age [age]. Verify that this is correct. If incorrect, go back to previous question (EDUPRE-Q11) and make necessary changes. Otherwise press Enter to continue.] - Consistency check / interviewer instruction

141. **EDUPRE-Q12**: HAS [respondent] EVER BEEN ENROLLED IN A UNIVERSITY? - Choice: Yes/DK/R -> EDUPRE-Q13; No -> EDUPRE-Q17

142. **EDUPRE-Q13**: HOW MANY YEARS OF UNIVERSITY HAS [respondent] COMPLETED? [Interviewer: Enter 00 if attended university but didn't complete the year] - Numeric: Hard range: Min = 0, Max = 20

143. **VERIFY-Q13**: [Internal logic] Years of university is greater than [age] minus 14? - Routing: Yes -> EDUPRE-Q13A; Otherwise -> EDUPRE-Q14

144. **EDUPRE-Q13A**: [Interviewer: Years of university [EDUPRE-Q13] does not correspond to [respondent]'s age [age]. Verify that this is correct. If incorrect, go back to previous question (EDUPRE-Q13) and make necessary changes. Otherwise press Enter to continue.] - Consistency check / interviewer instruction

145. **EDUPRE-Q14**: WHAT DEGREES, CERTIFICATES OR DIPLOMAS HAS [respondent] RECEIVED FROM A UNIVERSITY? - Choice: None -> EDUPRE-Q17; Specify Degrees -> EDUPRE-Q14A; DK/R -> EDUPRE-Q15

146. **EDUPRE-Q14A**: [Interviewer: Specify degrees, certificates or diplomas [respondent] has received from a university. Mark all that apply.] - Multiple choice: University certificate/diploma below Bachelor level; Bachelor's degree(s); University certificate/diploma above Bachelor level; Master's degree(s); Degree in medicine, dentistry, veterinary medicine or optometry; Doctorate (PhD)

147. **EDUPRE-Q15**: WHAT YEAR DID [respondent] RECEIVE HIS/HER [highest response category given in EDUPRE-Q14A]? - Year: Hard range: Min = [current year] minus [age] minus 18, Max = [current year]

148. **EDUPRE-Q16**: WHAT WAS THE MAJOR FIELD OF STUDY? - Open text

149. **EDUPRE-Q17**: WHAT WAS THE HIGHEST LEVEL OF EDUCATION COMPLETED BY [respondent]'S MOTHER? WAS IT... - Single choice: ELEMENTARY SCHOOL (includes no schooling)?; SOME HIGH SCHOOL?; COMPLETED HIGH SCHOOL?; TRADE/VOCATIONAL SCHOOL?; POST-SECONDARY CERTIFICATE OR DIPLOMA? (e.g., community college, Cegep, teachers' college, school of nursing, etc.); UNIVERSITY DEGREE?

150. **EDUPRE-Q18**: WHAT WAS THE HIGHEST LEVEL OF EDUCATION COMPLETED BY [respondent]'S FATHER? WAS IT... - Single choice: ELEMENTARY SCHOOL (includes no schooling)?; SOME HIGH SCHOOL?; COMPLETED HIGH SCHOOL?; TRADE/VOCATIONAL SCHOOL?; POST-SECONDARY CERTIFICATE OR DIPLOMA? (e.g., community college, Cegep, teachers' college, school of nursing, etc.); UNIVERSITY DEGREE?

---

## Summary Statistics

| Module | Asked Questions | Internal Logic Nodes | Consistency Checks | Total Nodes |
|--------|----------------|---------------------|--------------------|-------------|
| EMPPRE | 39 | 7 | 2 | 48 + 14 (J2 mirrors) = 62 |
| EXPRE | 10 | 3 | 2 | 16 (incl. 1 entry gate) |
| DEMPRE | 22 | 12 | 6 | 38 (incl. 2 intro/routing) |
| EDUPRE | 16 | 5 | 5 | 27 (incl. 1 entry gate) |

Note: The EMPPRE module contains parallel question sequences for Job 1 (J1.Q1-J1.Q15) and Job 2 (J2.Q1-J2.Q16). Internal logic nodes (marked with *) are computer-evaluated routing decisions not read to respondents. Consistency checks are interviewer-facing error messages for date/count validation.

## TOTAL UNIQUE QUESTION NODES: ~143
