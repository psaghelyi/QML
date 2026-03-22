# Labour Force Survey Questionnaire - Question Inventory

## Document Overview
- **Title**: Labour Force Survey questionnaire (Appendix B)
- **Organization**: Statistics Canada
- **Date**: Catalogue no. 71-543
- **Pages**: 30 (pages 48-77 of the Guide to the Labour Force Survey)
- **Language**: English
- **Type**: CATI (Computer-Assisted Telephone Interviewing) questionnaire

## Structure
The questionnaire consists of 7 major components:
1. **Contact component** (pp.48-49) - Call routing, respondent identification
2. **Household component** (pp.50-52) - Address confirmation, dwelling roster, household membership
3. **Individual demographics** (pp.52-54) - Age, sex, marital status, immigration, Aboriginal identity, education, armed forces
4. **Rent component** (pp.55-57) - Dwelling rent details, parking, utilities (conditional on non-ownership)
5. **Labour force information** (pp.57-67) - Job attachment, job description, absence/separation, work hours, job search, availability, earnings, firm size, other jobs, temporary layoff job search, school attendance, returning students
6. **Exit component** (pp.67-68) - Future contact scheduling, thank-you
7. **Code tables** (pp.69-77) - Response option codes for all questions

## Question Inventory by Section

### Contact Component - 13 questions

1. Q_II_R01A: "Hello, I'm calling from Statistics Canada. My name is ...." - Read/Routing: Interviewer introduction [If interview in person, go to IC_R01; If birth interview by telephone, go to AR_Q01; If subsequent interview by telephone, go to SR_Q01]
2. Q_SR_Q01: "May I speak with ...?" - Choice: 1=Yes speaking to respondent, 2=Yes respondent available, 3=No respondent not available, 4=No respondent no longer a household member, 5=Wrong number [If "Speaking", go to IC_R01; If "Available", go to II_R01B; If "Not available" or "No longer a household member", go to AR_Q01; If "Wrong number", go to TC_Q01]
3. Q_II_R01B: "Hello, I'm calling from Statistics Canada. My name is ...." - Read: Interviewer introduction [Go to IC_R01]
4. Q_TC_Q01: "I would like to make sure I've dialled the right number. Is this ...?" - Choice: Yes/No [If yes, go to AR_Q01; If no, thank person and end call]
5. Q_AR_Q01: "May I speak with an adult member of the household?" - Choice: 1=Yes speaking to an adult member, 2=Yes an adult member is available, 3=No an adult member is not available [If "Speaking" and CATI birth interview, go to TFCC_Q01; If "Speaking" and not CATI birth interview, go to IC_R01; If "Available", go to II_R01C; If "Not available" and birth interview, go to ARA_Q01; If "Not available" and subsequent interview, conditional routing to SRA_Q01 or ARA_Q01]
6. Q_II_R01C: "Hello, I'm calling from Statistics Canada. My name is ...." - Read: Interviewer introduction [If CATI birth interview, go to TFCC_Q01; If not CATI birth interview, go to IC_R01]
7. Q_SRA_Q01: "I would like to contact .... When would he/she be available?" - Choice: 1=Make hard appointment, 2=Make soft appointment, 3=Not available [If "Available", make appointment and end call; If "Not available", go to ARA_Q01]
8. Q_ARA_Q01: "When would an adult member of the household be available?" - Choice: 1=Make hard appointment, 2=Make soft appointment, 3=Not available [If "Available", make appointment and end call; If "Not available", thank person and end call]
9. Q_TFCC_Q01: "In order to make sure I've reached the correct household, I need to confirm your address. Is it ...?" - Choice: Yes/No [If yes, go to IC_R01; If no, go to TFCC_Q02]
10. Q_TFCC_Q02: "I would like to make sure I've dialled the right number. Is this ...?" - Read: Confirmation [Thank person and end call]
11. Q_IC_R01: "I'm calling regarding the Labour Force Survey." - Read: Interviewer statement
12. Q_LP_Q01: "Would you prefer to be interviewed in English or in French?" - Choice: 1=English, 2=French, 3=Other [If CATI interview, go to MON_R01; If not CATI interview, go to Household Component]
13. Q_MON_R01: "My supervisor may listen to this call for the purpose of quality control." - Read: Quality control statement

### Household Component - 22 questions

14. Q_LA_N01: Confirm the listing address. - Routing: [If CATI birth interview, go to MA_Q01; If subsequent interview in person, go to CMA_Q01; If subsequent interview by telephone, go to SD_Q01; Go to MA_Q01]
15. Q_SD_Q01: "I would like to confirm your address. Are you still living at ...?" - Choice: 1=Yes, 2=No, 3=No respondent never lived there [If yes and same as mailing address, go to CHM_Q01; If yes and different from mailing address, go to CMA_Q01; If no, go to SD_Q02; If "Respondent never lived there", go to SD_Q05]
16. Q_SD_Q02: "Does anyone who was living with you at that address still live there?" - Choice: Yes/No [If yes, go to SD_Q03; If no, thank person and end call]
17. Q_SD_Q03: "Can you provide me with the current telephone number for that address?" - Choice: Yes/No [If yes, go to SD_Q04; If no, thank person and end call]
18. Q_SD_Q04: "What is that telephone number, including the area code?" - Open text: Phone number [Thank person and end call]
19. Q_SD_Q05: "I would like to make sure I've dialled the right number. Is this ...?" - Read: Confirmation [Thank person and end call]
20. Q_CHM_Q01: "Is this also your mailing address?" - Choice: Yes/No [If yes, go to TN_Q01; If no, go to MA_Q01]
21. Q_CMA_Q01: "I would like to confirm your mailing address. Is it ...?" - Choice: Yes/No [If yes, go to TN_Q01; If no, go to MA_Q01]
22. Q_MA_Q01: "What is your correct mailing address?" - Open text: Address [If birth interview in person, go to DW_N02; If birth interview by telephone, go to DW_Q01; If subsequent interview, go to TN_Q01]
23. Q_DW_Q01: "What type of dwelling do you live in? Is it a:" - Choice: 01=Single detached, 02=Double, 03=Row or terrace, 04=Duplex, 05=Low rise apartment (fewer than 5 stories) or flat, 06=High rise apartment (5 stories or more), 07=Institution, 08=Hotel/rooming/lodging house/camp, 09=Mobile home, 10=Other-Specify [Go to TN_Q01]
24. Q_DW_N02: Select the dwelling type. - Choice: Same 10 codes as DW_Q01
25. Q_TN_Q01: "Is this dwelling owned by a member of this household?" - Choice: Yes/No
26. Q_RS_R01: "The next few questions ask for important basic information about the people in your household." - Read: Introduction [If birth interview, go to USU_Q01; If subsequent interview, go to PV2_Q01]
27. Q_USU_Q01: "What are the names of all persons who usually live here?" - Open text: Names list
28. Q_RS_Q02: "Is anyone staying here temporarily?" - Choice: Yes/No [If yes, go to TEM_Q01; If no, go to RS_Q04]
29. Q_TEM_Q01: "What are the names of all persons who are staying here temporarily?" - Open text: Names list
30. Q_RS_Q04: "Are there any other persons who usually live here but are now away at school, in hospital, or somewhere else?" - Choice: Yes/No [If yes, go to OTH1_Q01; If no, go to Individual Demographics]
31. Q_OTH1_Q01: "What are the names of the other people who live or stay here?" - Open text: Names list [Go to Individual Demographics]
32. Q_PV2_Q01: "Do the following people still live or stay in this dwelling?" - Choice: Yes/No [If yes, go to RS_Q05; If no, go to RES_Q02]
33. Q_RES_Q02: "Is ... no longer a member of the household or deceased?" - Choice: 1=No longer a member, 2=Deceased
34. Q_RS_Q05: "Does anyone else now live or stay here?" - Choice: Yes/No [If yes, go to OTH2_Q01; If no, go to Individual Demographics]
35. Q_OTH2_Q01: "What are the names of the other people who live or stay here?" - Open text: Names list

### Individual Demographics - 19 questions

36. Q_ANC_Q01: "What is ...'s date of birth?" - Date: Date of birth
37. Q_ANC_Q02: "So ...'s age on [date of last day of reference week] was [calculated age]. Is that correct?" - Choice: Yes/No [If yes, go to SEX_Q01; If no, go to ANC_Q03]
38. Q_ANC_Q03: "What is ...'s age?" - Numeric: Age
39. Q_SEX_Q01: "Enter ...'s sex." - Choice: 1=Male, 2=Female
40. Q_MSNC_Q01: "What is ...'s marital status? Is he/she:" - Choice: 1=Married, 2=Living common-law, 3=Widowed, 4=Separated, 5=Divorced, 6=Single never married [If age<16, go to FI_N01]
41. Q_FI_N01: "Enter ...'s family identifier: A to Z." - Code: Family letter identifier
42. Q_RR_N01: "Determine a reference person for the family and select ...'s relationship to that reference person." - Choice: 1=Reference person, 2=Spouse, 3=Son or daughter (birth/adopted/step), 4=Grandchild, 5=Son-in-law or daughter-in-law, 6=Foster child (less than 18), 7=Parent, 8=Parent-in-law, 9=Brother or sister, 10=Other relative-Specify
43. Q_IMM_Q01: "In what country was ... born?" - Choice: 01=Canada, 02=United States, 03=United Kingdom, 04=Germany, 05=Italy, 06=Poland, 07=Portugal, 08=China (People's Republic of), 09=Hong Kong, 10=India, 11=Philippines, 12=Vietnam, 13=Other-Search [If 01-Canada, go to ABO_Q01]
44. Q_IMM_Q02: "Is ... now, or has he/she ever been, a landed immigrant in Canada?" - Choice: 1=Yes, 2=No [If yes, go to IMM_Q03; If no, go to ABO_Q01]
45. Q_IMM_Q03: "In what year did ... first become a landed immigrant?" - Numeric: Year
46. Q_IMM_Q04: "In what month?" - Numeric: Month [If IMM_Q03 is more than five years ago, go to ABO_Q01]
47. Q_ABO_Q01: "Is ... an Aboriginal person, that is, North American Indian, Metis or Inuit?" - Choice: 1=Yes, 2=No [If Country of Birth is not Canada, USA or Greenland, go to ED_Q01; If yes, go to ABO_Q02; If no, go to ED_Q01]
48. Q_ABO_Q02: "Is ... a North American Indian, Metis or Inuit?" - Multi-select: 1=North American Indian, 2=Metis, 3=Inuit (Eskimo) (Mark all that apply)
49. Q_ED_Q01: "What is the highest grade of elementary or high school ... ever completed?" - Choice: 1=Grade 8 or lower (Quebec: Secondary II or lower), 2=Grade 9-10 (Quebec: Secondary III or IV, Newfoundland and Labrador: 1st year of secondary), 3=Grade 11-13 (Quebec: Secondary V, Newfoundland and Labrador: 2nd to 4th year of secondary) [If age<14, go to CAF_Q01; If "Grade 8 or lower" or "Grade 9-10", go to ED_Q03; If "Grade 11-13", go to ED_Q02]
50. Q_ED_Q02: "Did ... graduate from high school (secondary school)?" - Choice: Yes/No
51. Q_ED_Q03: "Has ... received any other education that could be counted towards a degree, certificate or diploma from an educational institution?" - Choice: Yes/No [If yes, go to ED_Q04; If no, go to CAF_Q01]
52. Q_ED_Q04: "What is the highest degree, certificate or diploma ... has obtained?" - Choice: 1=No postsecondary degree/certificate/diploma, 2=Trade certificate or diploma from a vocational school or apprenticeship training, 3=Non-university certificate or diploma from a community college/CEGEP/school of nursing etc., 4=University certificate below bachelor's level, 5=Bachelor's degree, 6=University degree or certificate above bachelor's degree
53. Q_CHE_Q01: "In what country did ... complete his/her highest degree, certificate or diploma?" - Choice: Same 13-option country list as IMM_Q01 [If Country of Birth is Canada, or IMM_Q02 is No, or respondent has not received a post-secondary degree/certificate/diploma, go to CAF_Q01]
54. Q_CAF_Q01: "Is ... a full-time member of the regular Canadian Armed Forces?" - Choice: Yes/No [If age<16 or age>65, go to ANC_Q01 for next household member]

### Rent Component - 20 questions

55. Q_RRF_R01: "The next few questions are about your rent. The information collected is used to calculate the rent portion of the Consumer Price Index." - Read: Introduction [Rent Component generated only for cases where TN_Q01="No" and province/territory is not Yukon, NWT or Nunavut]
56. Q_RM_Q01: "On which floor do you live?" - Numeric: Floor number [If rent information exists from the previous month, go to RM_Q04; If dwelling type is not "Low-rise apartment" and not "High-rise apartment", go to RM_Q02]
57. Q_RM_Q02: "To the best of your knowledge, how old is your building?" - Choice: 1=No more than 5 years old, 2=More than 5 but no more than 10 years old, 3=More than 10 but no more than 20 years old, 4=More than 20 but no more than 40 years old, 5=More than 40 years old
58. Q_RM_Q03: "How many bedrooms are there in your dwelling?" - Numeric: Number of bedrooms
59. Q_RM_Q04: "This month, is the rent for your dwelling subsidized by government or an employer, or a relative?" - Choice: Yes/No [If yes, go to RM_Q04A; If no, go to RM_Q05]
60. Q_RM_Q04A: "In what manner is the rent for your dwelling subsidized?" - Choice: 1=Income-related/Government agencies, 2=Employer, 3=Owned by a relative, 4=Other-Specify
61. Q_RM_Q05: "This month, is the rent for your dwelling applied to both living and business accommodation?" - Choice: Yes/No [If yes, go to RM_Q05A; If no, go to RM_Q06]
62. Q_RM_Q05A: "Does the business affect the amount of rent paid?" - Choice: Yes/No
63. Q_RM_Q06: "How much is the total monthly rent for your dwelling?" - Numeric: Dollar amount [If $0, go to RM_Q07; If >$0, go to RM_Q08]
64. Q_RM_Q07: "What is the reason that the rent is $0?" - Open text: Reason [If RM_Q04=yes, go to end of Rent Component]
65. Q_RM_Q08: "Since last month, have there been any changes in the amount of rent paid?" - Choice: Yes/No [If rent information does not exist from the previous month, go to RM_Q09B; If there has been a complete change in household membership, go to RM_Q09B; If RM_Q04=yes, go to RM_Q09B; If yes, go to RM_Q08A; If no, go to RM_Q09B]
66. Q_RM_Q08A: "What is the reason for the change in rent since last month?" - Multi-select: 1=Change in utilities/services/appliances/furnishings, 2=Change in parking facilities, 3=New Lease, 4=Other-Specify (Mark all that apply)
67. Q_RM_Q09B: "Does this month's rent include parking facilities?" - Choice: Yes/No [If dwelling type is not "Low-rise apartment" and not "High-rise apartment", go to RM_Q14; If rent information exists from previous month and no complete change in household membership, go to RM_Q09S; If yes, go to RM_Q10; If no, go to RM_Q14]
68. Q_RM_Q09S: "Since last month, have there been any changes in the parking facilities?" - Choice: Yes/No [If yes, go to RM_Q10; If no, go to RM_Q14]
69. Q_RM_Q10: "What types of parking facilities are included in your rent?" - Multi-select: 1=Closed garage or indoor parking, 2=Outside parking with plug-in, 3=Outside parking without plug-in (Mark all that apply)
70. Q_RM_Q11: "How many closed garage or indoor parking spaces are included in your rent?" - Numeric: Number [If "Closed garage or indoor parking" is not marked in RM_Q10, go to RM_Q12]
71. Q_RM_Q12: "How many outside parking spaces with plug-in are included in your rent?" - Numeric: Number [If "Outside parking with plug-in" is not marked in RM_Q10, go to RM_Q13]
72. Q_RM_Q13: "How many outside parking spaces without plug-in are included in your rent?" - Numeric: Number [If "Outside parking without plug-in" is not marked in RM_Q10, go to RM_Q14]
73. Q_RM_Q14: "Since last month, have there been any changes in the utilities, services, appliances, or furnishings included in the rent?" - Choice: Yes/No [If rent information does not exist from the previous month, go to RM_Q15; If complete change in household membership, go to RM_Q15; If "Change in utilities" is marked in RM_Q08A, go to RM_Q15; If yes, go to RM_Q15; If no, go to end of Rent Component]
74. Q_RM_Q15: "Which of the following utilities, services, appliances, or furnishings are included as part of the monthly rent?" - Multi-select: 1=Heat-Electric, 2=Heat-Natural Gas, 3=Heat-Other Specify, 4=Electricity, 5=Cablevision, 6=Refrigerator, 7=Range, 8=Washer, 9=Dryer, 10=Other major appliance-Specify, 11=Furniture, 12=None of the above (Mark all that apply)

### Labour Force Information - Job Attachment - 6 questions

75. Q_100: "Last week, did ... work at a job or business? (regardless of the number of hours)" - Choice: 1=Yes, 2=No, 3=Permanently unable to work [If yes, then PATH=1 and go to 102; If no, go to 101; If "Permanently unable to work", then PATH=7 and go to 104]
76. Q_101: "Last week, did ... have a job or business from which he/she was absent?" - Choice: Yes/No [If no, go to 104]
77. Q_102: "Did he/she have more than one job or business last week?" - Choice: Yes/No [If no, go to 110]
78. Q_103: "Was this a result of changing employers?" - Choice: Yes/No [Go to 110]
79. Q_104: "Has he/she ever worked at a job or business?" - Choice: Yes/No [If no, go to 170]
80. Q_105: "When did he/she last work?" - Date/Choice [If subsequent interview and no change in 105 and last month's PATH=3, go to 131; Else if subsequent interview and no change in 105 and last month's PATH=4 to 7, go to 170; Else if not within past year, go to 170; Else if PATH=7, go to 131; Else if PATH not 7, go to 110]

### Labour Force Information - Job Description - 9 questions

81. Q_110: "Was he/she an employee or self-employed?" - Choice: 1=Employee, 2=Self-employed, 3=Working in a family business without pay [If not "Self-employed", go to 114]
82. Q_111: "Did he/she have an incorporated business?" - Choice: Yes/No
83. Q_112: "Did he/she have any employees?" - Choice: Yes/No
84. Q_113: "What was the name of his/her business?" - Open text: Business name [Go to 115]
85. Q_114: "For whom did he/she work?" - Open text: Employer name
86. Q_115: "What kind of business, industry or service was this?" - Open text: Industry description
87. Q_116: "What kind of work was he/she doing?" - Open text: Occupation description
88. Q_117: "What were his/her most important activities or duties?" - Open text: Duties description
89. Q_118: "When did he/she start working for [name of employer]?" - Date: Start date

### Labour Force Information - Absence/Separation - 8 questions

90. Q_130: "What was the main reason ... was absent from work last week?" - Choice: 01=Own illness/disability, 02=Caring for own children, 03=Caring for elder relative (60+), 04=Maternity or parental leave, 05=Other personal/family responsibilities, 06=Vacation, 07=Labour dispute (strike/lockout) (Employees only), 08=Temporary layoff due to business conditions (Employees only), 09=Seasonal layoff (Employees only), 10=Casual job no work available (Employees only), 11=Work schedule (shift work) (Employees only), 12=Self-employed no work available (Self-employed only), 13=Seasonal business (excluding employees), 14=Other-Specify [If PATH=1, go to 150; If 101=no, go to 131; If "Temporary layoff due to business conditions", go to 134; If "Seasonal layoff", go to 136; If "Casual job, no work available", go to 137; Otherwise PATH=2 and go to 150]
91. Q_131: "What was the main reason ... stopped working at that [job/business]?" - Choice: 01=Own illness/disability, 02=Caring for own children, 03=Caring for elder relative (60+), 04=Pregnancy (Females only), 05=Other personal/family responsibilities, 06=Going to school, 07=Lost job/laid off/job ended (Employees only), 08=Business sold/closed down (excluding employees), 09=Changed residence, 10=Dissatisfied with job, 11=Retired, 12=Other-Specify [If not "Lost job, laid off or job ended", go to 137]
92. Q_132: "Can you be more specific about the main reason for his/her job loss?" - Choice: 1=End of seasonal job, 2=End of temporary/term/contract job (non-seasonal), 3=Casual job, 4=Company moved, 5=Company went out of business, 6=Business conditions (not enough work, drop in orders or retooling), 7=Dismissal by employer (fired), 8=Other-Specify [If PATH=7, go to 137; Else if "Business conditions", go to 133; Otherwise go to 137]
93. Q_133: "Does he/she expect to return to that job?" - Choice: 1=Yes, 2=No, 3=Not sure [If no or "Not sure", go to 137]
94. Q_134: "Has ...'s employer given him/her a date to return?" - Choice: Yes/No [If yes, go to 136]
95. Q_135: "Has he/she been given any indication that he/she will be recalled within the next 6 months?" - Choice: Yes/No
96. Q_136: "As of last week, how many weeks had ... been on layoff?" - Numeric: Weeks [If 130="Seasonal layoff", go to 137; Else if 134=no and 135=no, go to 137; Else if on layoff more than 52 weeks, go to 137; Otherwise PATH=3 and go to 137]
97. Q_137: "Did he/she usually work more or less than 30 hours per week?" - Choice: 1=30 or more hours per week, 2=Less than 30 hours per week [If PATH=3, go to 190; Otherwise go to 170]

### Labour Force Information - Work Hours (Main Job) - 10 questions

98. Q_150: "Does the number of [paid] hours ... works vary from week to week?" - Choice: Yes/No [If yes, go to 152]
99. Q_151: "How many [paid] hours does ... work per week?" - Numeric: Hours [If PATH=2, go to 158; If 110="Employee", go to 153; Otherwise, go to 157]
100. Q_152: "On average, how many [paid] hours does ... usually work per week?" - Numeric: Hours [If PATH=2, go to 158; If 110="Employee", go to 153; Otherwise, go to 157]
101. Q_153: "Last week, how many hours was he/she away from this job because of vacation, illness, or any other reason?" - Numeric: Hours [If 0 hours, go to 155]
102. Q_154: "What was the main reason for that absence?" - Choice: 01=Own illness/disability, 02=Caring for own children, 03=Caring for elder relative (60+), 04=Maternity or parental leave, 05=Other personal/family responsibilities, 06=Vacation, 07=Labour dispute (strike/lockout), 08=Temporary layoff due to business conditions, 09=Holiday (legal or religious), 10=Weather, 11=Job started or ended during week, 12=Working short-time (material shortage, plant maintenance or repair), 13=Other-Specify
103. Q_155: "Last week, how many hours of paid overtime did he/she work at this job?" - Numeric: Hours
104. Q_156: "Last week, how many extra hours without pay did he/she work at this job?" - Numeric: Hours [If 150=no, then actual hours = 151 - 153 + 155 + 156 and go to 158]
105. Q_157: "Last week, how many hours did he/she actually work at his/her [new] [job/business] [at name of employer]?" - Numeric: Hours
106. Q_158: "Does he/she want to work 30 or more hours per week [at a single job]?" - Choice: Yes/No [If 151>=29.5 or 152>=29.5, and PATH=2, go to 162; If 151>=29.5 or 152>=29.5, and PATH=1, go to 200; If yes, go to 160]
107. Q_159: "What is the main reason ... does not want to work 30 or more hours per week [at a single job]?" - Choice: 1=Own illness/disability, 2=Caring for own children, 3=Caring for elder relative (60+), 4=Other personal/family responsibilities, 5=Going to school, 6=Personal preference, 7=Other-Specify [If PATH=2, go to 162; Otherwise go to 200]

### Labour Force Information - Work Hours (continued) - 4 questions

108. Q_160: "What is the main reason ... usually works less than 30 hours per week [at his/her main job]?" - Choice: 1=Own illness/disability, 2=Caring for own children, 3=Caring for elder relative (60+), 4=Other personal/family responsibilities, 5=Going to school, 6=Business conditions, 7=Could not find work with 30 or more hours per week, 8=Other-Specify [If not ("Business conditions" or "Could not find work") and PATH=2, go to 162; If not ("Business conditions" or "Could not find work") and PATH=1, go to 200]
109. Q_161: "At any time in the 4 weeks ending last Saturday, did he/she look for full-time work?" - Choice: Yes/No [If PATH=2, go to 162; Otherwise go to 200]
110. Q_162: "As of last week, how many weeks had ... been continuously absent from work?" - Numeric: Weeks [If 110="Employee" or (110="Self-employed" and 111=yes), go to 163; Otherwise go to 200]
111. Q_163: "Is he/she getting any wages or salary from his/her [employer/business] for any time off last week?" - Choice: Yes/No [Go to 200]

### Labour Force Information - Job Search/Future Start - 9 questions

112. Q_170: "In the 4 weeks ending last Saturday, did ... do anything to find work?" - Choice: Yes/No [If PATH=7, go to 500; If no and age>=65, then PATH=6 and go to 500; If no and age<=64, go to 174; If yes, then PATH=4 and go to 171]
113. Q_171: "What did he/she do to find work in those 4 weeks? Did he/she do anything else to find work?" - Multi-select: 1=Public employment agency, 2=Private employment agency, 3=Union, 4=Employers directly, 5=Friends or relatives, 6=Placed or answered ads, 7=Looked at job ads, 8=Other-Specify
114. Q_172: "As of last week, how many weeks had he/she been looking for work?" - Numeric: Weeks
115. Q_173: "What was his/her main activity before he/she started looking for work?" - Choice: 1=Working, 2=Managing a home, 3=Going to school, 4=Other-Specify [Go to 177]
116. Q_174: "Last week, did ... have a job to start at a definite date in the future?" - Choice: Yes/No [If no, then PATH=6 and go to 176]
117. Q_175: "Will he/she start that job before or after Sunday, [date 4 weeks from reference week end]?" - Choice: 1=Before the date above, 2=On or after the date above [If "Before", then PATH=5 and go to 190; If "On or after", then PATH=6 and go to 500]
118. Q_176: "Did he/she want a job last week?" - Choice: Yes/No [If no, go to 500]
119. Q_177: "Did he/she want a job with more or less than 30 hours per week?" - Choice: 1=30 or more hours per week, 2=Less than 30 hours per week
120. Q_178: "What was the main reason he/she did not look for work last week?" - Choice: 1=Own illness/disability, 2=Caring for own children, 3=Caring for elder relative (60+), 4=Other personal/family responsibilities, 5=Going to school, 6=Waiting for recall (to former employer), 7=Waiting for replies from employers, 8=Believes no work available (in area, or suited to skills), 9=No reason given, 10=Other-Specify [If PATH=4, go to 190; If "Believes no work available", go to 190; Otherwise go to 500]

### Labour Force Information - Availability - 2 questions

121. Q_190: "Could he/she have worked last week [if he/she had been recalled/if a suitable job had been offered]?" - Choice: Yes/No [If yes, go to 400]
122. Q_191: "What was the main reason ... was not available to work last week?" - Choice: 1=Own illness/disability, 2=Caring for own children, 3=Caring for elder relative (60+), 4=Other personal/family responsibilities, 5=Going to school, 6=Vacation, 7=Already has a job, 8=Other-Specify [Go to 400]

### Labour Force Information - Earnings/Union/Permanence - 13 questions

123. Q_200: "Is he/she paid by the hour?" - Choice: Yes/No [If 110 is not "Employee", go to 300; If subsequent interview and no change in 110, 114-118, go to 300]
124. Q_201: "Does he/she usually receive tips or commissions?" - Choice: Yes/No [If 200=no, go to 204]
125. Q_202: "[Including tips and commissions,] what is his/her hourly rate of pay?" - Numeric: Dollar amount [Go to 220]
126. Q_204: "What is the easiest way for you to tell us his/her wage or salary, [including tips and commissions,] before taxes and other deductions?" - Choice: 1=Yearly, 2=Monthly, 3=Semi-monthly, 4=Bi-weekly, 5=Weekly, 6=Other-Specify [Routes to Q205-Q209 based on selection]
127. Q_205: "[Including tips and commissions,] what is his/her weekly wage or salary, before taxes and other deductions?" - Numeric: Dollar amount [Go to 220]
128. Q_206: "[Including tips and commissions,] what is his/her bi-weekly wage or salary, before taxes and other deductions?" - Numeric: Dollar amount [Go to 220]
129. Q_207: "[Including tips and commissions,] what is his/her semi-monthly wage or salary, before taxes and other deductions?" - Numeric: Dollar amount [Go to 220]
130. Q_208: "[Including tips and commissions,] what is his/her monthly wage or salary, before taxes and other deductions?" - Numeric: Dollar amount [Go to 220]
131. Q_209: "[Including tips and commissions,] what is his/her yearly wage or salary, before taxes and other deductions?" - Numeric: Dollar amount [Go to 220]
132. Q_220: "Is he/she a union member at [name of employer]?" - Choice: Yes/No [If yes, go to 240]
133. Q_221: "Is he/she covered by a union contract or collective agreement?" - Choice: Yes/No
134. Q_240: "Is ...'s [new] job [at name of employer] permanent, or is there some way that it is not permanent?" - Choice: Permanent/Not permanent [If "Permanent", go to 260]
135. Q_241: "In what way is his/her job not permanent?" - Choice: 1=Seasonal job, 2=Temporary/term/contract job (non-seasonal), 3=Casual job, 5=Other-Specify [Go to 260]

### Labour Force Information - Firm Size - 3 questions

136. Q_260: "About how many persons are employed at the location where ... works for [name of employer]?" - Choice: 1=Less than 20, 2=20 to 99, 3=100 to 500, 4=Over 500
137. Q_261: "Does [name of employer] operate at more than one location?" - Choice: Yes/No [If no, or 260="Over 500", go to 300]
138. Q_262: "In total, about how many persons are employed at all locations?" - Choice: 1=Less than 20, 2=20 to 99, 3=100 to 500, 4=Over 500 [Go to 300]

### Labour Force Information - Class of Worker/Hours at Other Job - 5 questions

139. Q_300: "Was he/she an employee or self-employed? (other/old job)" - Choice: 1=Employee, 2=Self-employed, 3=Working in a family business without pay [If 102=no, go to 400; If not "Self-employed", go to 320]
140. Q_301: "Did he/she have an incorporated business?" - Choice: Yes/No
141. Q_302: "Did he/she have any employees?" - Choice: Yes/No
142. Q_320: "How many [paid] hours [does/did] ... usually work per week at this [job/business/family business]?" - Numeric: Hours [If PATH=2, go to 400]
143. Q_321: "Last week, how many hours did ... actually work at this [job/business/family business]?" - Numeric: Hours [Go to 400]

### Labour Force Information - Temporary Layoff Job Search - 1 question

144. Q_400: "In the 4 weeks ending last Saturday, did ... look for a job with a different employer?" - Choice: Yes/No [If PATH not 3, go to 500; Go to 500]

### Labour Force Information - School Attendance - 3 questions

145. Q_500: "Last week, was ... attending a school, college or university?" - Choice: Yes/No [If age>=65, go to END; If no, go to 520]
146. Q_501: "Was he/she enrolled as a full-time or part-time student?" - Choice: 1=Full-time, 2=Part-time
147. Q_502: "What kind of school was this?" - Choice: 1=Elementary/junior high school/high school or equivalent, 2=Community college/junior college/CEGEP, 3=University, 4=Other-Specify [Go to 520]

### Labour Force Information - Returning Students - 2 questions

148. Q_520: "Was ... a full-time student in March of this year?" - Choice: Yes/No [If survey month not May through August, go to END; Else if age not 15 to 24, go to END; Else if subsequent interview and 520 in previous month was "no", go to END; Else if subsequent interview and 520 in previous month was "yes", go to 521; If no, go to END]
149. Q_521: "Does ... expect to be a full-time student this fall?" - Choice: 1=Yes, 2=No, 3=Not sure

### Exit Component - 14 questions

150. Q_EI_R01: "Before we finish, I would like to ask you a few other questions." - Read: Introduction [If rotate-out (last month for interview), go to TY_R02]
151. Q_FC_R01: "As part of the Labour Force Survey, we will contact your household next month during the week of [date]. After this month, this dwelling has [N] LFS interview(s) left." - Read: Information statement
152. Q_HC_Q01: "Who would be the best person to contact?" - Open text: Contact name
153. Q_TEL_Q01: "I would like to confirm your telephone number. Is it ...?" - Choice: Yes/No [If no telephone number exists, go to TEL_Q02; If yes, go to PC_Q01; If no, go to TEL_Q02]
154. Q_TEL_Q02: "What is your telephone number, including the area code?" - Open text: Phone number
155. Q_PC_Q01: "May we conduct the next interview by telephone?" - Choice: Yes/No [If CATI interview, go to PTC_Q01; If yes, go to PTC_Q01; If no, go to PV_R01]
156. Q_PV_R01: "In this case we will make a personal visit next month during the week of [date]." - Read: Information statement
157. Q_PTC_Q01: "I would like to confirm the time of day you would prefer that we call. Is it [preferred time to call]?" - Choice: Yes/No [If no previous preferred time, go to PTC_Q02; If yes, go to PTC_N03; If no, go to PTC_Q02]
158. Q_PTC_Q02: "What time of day would you prefer that we call? Would it be the morning, the afternoon, the evening, or ANY TIME?" - Multi-select: 1=Any time, 2=Morning, 3=Afternoon, 4=Evening, 5=Not morning, 6=Not afternoon, 7=Not evening (Mark all that apply)
159. Q_PTC_N03: "Enter any other information about the preferred time to call." - Open text: Notes
160. Q_LQ_Q01: "Is there another set of living quarters within this structure?" - Choice: Yes/No [If CATI interview, go to TY_R01; If subsequent interview, go to TY_R01; If dwelling type is not "Single detached"/"Double"/"Row or terrace"/"Duplex", go to TY_R01; If yes, go to LQ_N02; If no, go to TY_R01]
161. Q_LQ_N02: "Remember to verify the cluster list and add one or more multiples if necessary." - Read: Interviewer note
162. Q_TY_R01: "Thank you for your participation in the Labour Force Survey." - Read: Thank-you [Go to END]
163. Q_TY_R02: "Thank you for your participation in the Labour Force Survey. Although your six months in the Labour Force Survey are over, your household may be contacted by Statistics Canada some time in the future for another survey." - Read: Thank-you (rotate-out)

## TOTAL UNIQUE QUESTION NODES: ~163
