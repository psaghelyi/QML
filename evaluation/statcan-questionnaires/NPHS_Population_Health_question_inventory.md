# National Population Health Survey - Question Inventory

## Document Overview
- **Title**: National Population Health Survey - Content For Main Survey
- **Organization**: Statistics Canada
- **Date**: May 1, 1994
- **Pages**: 56 (plus Appendix A for ages 0-11)
- **Language**: English
- **Type**: CATI household health survey questionnaire (two forms: General Component H05 and Health Component H06)

## Structure

The questionnaire consists of two main forms:

1. **Household Record Variables** (pp. 3-5): Demographics and dwelling characteristics collected from a knowledgeable household member
2. **General Component (Form H05)** (pp. 6-19): Completed for all household members, covering two-week disability, health care utilization, restriction of activities, chronic conditions, socio-demographic characteristics, education, labour force, income, and administration
3. **Health Component (Form H06)** (pp. 20-56): For selected respondent aged 12+ only, covering general health, height/weight, preventive health practices, smoking, alcohol, physical activities, injuries, stress (ongoing problems, recent life events, childhood traumas), work stress, self-esteem and mastery, sense of coherence, health status (vision, hearing, speech, getting around, hands/fingers, feelings, memory, thinking, pain/discomfort), drug use, mental health (K6 distress scale, CIDI-SF depression screening), social support, health number, agreement to share, and provincial buy-in modules (Manitoba, Alberta)

## Question Inventory by Section

### Household Record Variables (pp. 3-5) - 14 questions

1. DEMO_INT: Introduction text (interviewer preamble)
2. DEMO_Q1: What are the names of all persons now living or staying here? - Open text: First and last names
3. DEMO_Q2: Are there any persons away from this household attending school, visiting, travelling or in hospital who usually live here? - Radio: Yes (go to DEMO-Q1), No
4. DEMO_Q3: Does anyone else live at this dwelling such as young children, relatives, roomers, boarders or employees? - Radio: Yes (go to DEMO-Q1), No
5. DEMO_Q4: What is ...'s date of birth? - Date: DD/MM/YY (derives DHC4_DOB, DHC4_MOB, DHC4_YOB, DHC4_AGE)
6. DEMO_Q5: Enter or ask ...'s sex. - Radio: Male, Female
7. DEMO_Q6: What is ...'s current marital status? - Radio: Now married, Common-law, Living with a partner, Single (never married), Widowed, Separated, Divorced [Note: if age < 15, marital status automatically = single]
8. DEMO_Q7: Enter ...'s family Id code. - Open text: A to Z
9. DEMO_Q8: Relationships of everyone to everyone else - Matrix: Birth Parent, Step Parent, Foster Parent, Birth Child, Step Child, Foster Child, Sister/brother, Grandparent, Grandchild, Common law partner, In-law, Other Related, Unrelated, Husband/Wife, Adopted Child, Adoptive Parent, Same-sex Partner
10. HHLD_Q1: Is this dwelling owned by a member of this household (even if being paid for)? - Radio: Yes, No
11. HHLD_Q3: How many bedrooms are there in this dwelling? - Numeric: 2-digit number
12. HHLD_Q4: Is there a pet in this household? - Radio: Yes, No [No -> HHLD-Q6]
13. HHLD_Q5: What kind of pet? (Mark all that apply) - Checkbox: Dog, Cat, Other [Other -> HHLD-Q6]
14. HHLD_Q5a: Does this pet or do any of these pets live mainly indoors? - Radio: Yes, No
15. HHLD_Q6: Record type of dwelling (by interviewer observation) - Radio: Single detached house, Semi-detached or double (side-by-side), Garden house/town-house/row house, Duplex (one above the other), Low-rise apartment (less than 5 stories), High-rise apartment (5 or more stories), Institution, Hotel/rooming or lodging house/logging or construction camp/Hutterite Colony, Mobile home, Other (Specify)
16. HHLD_Q7: Information Source Indicator (who is providing the information) - Administrative
17. HHLD_Q8: Record language of interview - Radio: English, French, Arabic, Chinese, Cree, German, Greek, Hungarian, Italian, Korean, Persian (Farsi), Polish, Portuguese, Punjabi, Spanish, Tagalog (Filipino), Ukrainian, Vietnamese, Other (Specify)

### General Component (Form H05) (pp. 6-19)

#### Two-Week Disability - 5 questions

1. TWOWK-Q1: During that period, did ... stay in bed at all because of illness or injury including any nights spent as a patient in a hospital? - Radio: Yes, No [No -> TWOWK-Q3], DK/R [-> TWOWK-Q5]
2. TWOWK-Q2: How many days did ... stay in bed for all or most of the day? - Numeric: Days (enter <0> if less than a day) [If = 14 days -> TWOWK-Q5; DK/R -> TWOWK-Q5]
3. TWOWK-Q3: (Not counting days spent in bed) During those 14 days, were there any days that ... cut down on things you/he/she normally do/does because of illness or injury? - Radio: Yes, No [No -> TWOWK-Q5], DK/R [-> TWOWK-Q5]
4. TWOWK-Q4: How many days did ... cut down on things for all or most of the day? - Numeric: Days (enter <0> if less than a day)
5. TWOWK-Q5: Does ... have a regular medical doctor? - Radio: Yes, No

#### Health Care Utilization (p. 6-9) - 14 questions

[UTIL-CINT: If age < 12, go to next section]

1. UTIL-Q1: In the past 12 months, have/has ... been a patient overnight in a hospital, nursing home or convalescent home? - Radio: Yes, No [No -> UTIL-Q2], DK [-> UTIL-Q2], R [-> next section]
2. UTIL-Q1a: For how many nights in the past 12 months? - Numeric: nights
3. UTIL-Q2: (Not counting when ... were/was an overnight patient) In the past 12 months, how many times have/has ... seen or talked on the telephone with [fill category] about your/his/her physical, emotional or mental health: - Numeric (for each sub-item a-j):
   - a) General practitioner or family physician
   - b) Eye specialist (such as an ophthalmologist or optometrist)
   - c) Other medical doctor (such as surgeon, allergist, gynaecologist, psychiatrist, etc.)
   - d) A nurse for care or advice
   - e) Dentist or orthodontist
   - f) Chiropractor
   - g) Physiotherapist
   - h) Social worker or counsellor
   - i) Psychologist
   - j) Speech, audiology or occupational therapist
4. UTIL-Q3: Where did the most recent contact take place? (for each response >0 in a, c, or d) - Radio: Walk-in clinic, Outpatient clinic in hospital, Hospital emergency room, Health professional's office, Community health centre/CLSC, At home, Telephone consultation only, Other (Specify)
5. UTIL-Q4: Have/has ... seen or talked to an alternative health care provider such as an acupuncturist, naturopath, homeopath or massage therapist? - Radio: Yes, No [No -> UTIL-Q6], DK/R [-> UTIL-Q6]
6. UTIL-Q5: Who did ... see or talk to? (Mark all that apply) - Checkbox: Massage therapist, Acupuncturist, Homeopath or naturopath, Feldenkrais or Alexander teacher, Relaxation therapist, Biofeedback teacher, Rolfer, Herbalist, Reflexologist, Spiritual healer, Religious healer, Self help group (such as AA, cancer therapy, etc.), Other (Specify)
7. UTIL-Q6: Was there ever a time when you/he/she needed health care or advice but did not receive it? - Radio: Yes, No [No -> UTIL-C9], DK/R [-> UTIL-C9]
8. UTIL-Q7: Thinking of the most recent time, why did ... not get care? - Checkbox: Difficulty getting access to health professional, Financial constraints, Felt health care provided inadequate, Chose not to see health professional, Other
9. UTIL-Q8: Again, thinking of the most recent time, what was the type of care that was needed? (Mark all that apply) - Checkbox: Treatment of a physical health problem, Treatment of an emotional or mental health problem, A regular check-up (or for regular pre-natal care), Care of an injury, Any other reason (Specify)

[UTIL-C9: IF age < 18 then go to next section]

10. UTIL-Q9: Have/Has ... received any home care services in the past 12 months? - Radio: Yes, No [No -> next section], DK/R [-> next section]
11. UTIL-Q10: What type of services have/has ... received? (Specify, Mark all that apply) - Checkbox: Nursing care, Personal care, Housework, Meal preparation, Shopping, Other

#### Restriction of Activities (pp. 9-10) - 8 questions

[RESTR-CINT: If age < 12, go to next section]

1. RESTR-Q1: Because of a long-term physical or mental condition or a health problem, are/is ... limited in the kind or amount of activity you/he/she can do: - QuestionGroup (4 sub-items, each Yes/No/Not applicable/R):
   - a) at home?
   - b) at school?
   - c) at work?
   - d) in other activities such as transportation to or from work or leisure time activities?
   [R on any -> next section]
2. RESTR-Q2: Do(es) ... have any long term disabilities or handicaps? - Radio: Yes, No, R [R -> next section]
3. RESTR-Q3: What is the main condition or health problem causing ... to be limited in your/his/her activities? - Open text: 25 spaces [Go to RESTR-Q5]
4. RESTR-Q4: What is the main condition or health problem causing ... to have a long term disability or handicap? - Open text: 25 spaces
5. RESTR-Q5: Which one of the following is the best description of the cause of this condition? (Read list. Mark one only.) - Radio: Injury - at home, Injury - sports or recreation, Injury - motor vehicle, Injury - work-related, Existed at birth, Work environment, Disease or illness, Natural aging process, Psychological or physical abuse, Other (Specify)
6. RESTR-Q6: The next question asks about help received. Because of any condition or health problem, do(es) ... need the help of another person in: (Read list. Mark all that apply.) - Checkbox: Preparing meals?, Shopping for groceries or other necessities?, Doing normal everyday housework?, Doing heavy household chores such as washing walls, yard work, etc.?, Personal care such as washing, dressing or eating?, Moving about inside the house?, None of the above
   [Routing: If any yes in RESTR-Q1(a)-(d), ask RESTR-Q3. If yes in RESTR-Q2 only, ask RESTR-Q4. Otherwise go to RESTR-Q6.]

#### Chronic Conditions (pp. 10-11) - 4 questions

[CHRON-CINT: If age < 12 go to next section]

1. CHRON-Q1: Do(es) ... have any of the following long-term conditions that have been diagnosed by a health professional: (Read list. Mark all that apply.) - Checkbox (items a-q for all ages 12+, items r-u for ages 18+):
   - (a) Food allergies?
   - (b) Other allergies?
   - (c) Asthma? [If YES ask CHRON-Q1cc1]
   - (d) Arthritis or rheumatism?
   - (e) Back problems excluding arthritis?
   - (f) High blood pressure?
   - (g) Migraine headaches?
   - (h) Chronic bronchitis or emphysema?
   - (i) Sinusitis?
   - (j) Diabetes?
   - (k) Epilepsy?
   - (l) Heart disease?
   - (m) Cancer? [If yes ask CHRON-Q1mm]
   - (n) Stomach or intestinal ulcers?
   - (o) Effects of stroke?
   - (p) Urinary incontinence?
   - (q) Acne requiring prescription medication? [Ask if age < 30]
   - (r) Alzheimer's disease or other dementia? [age >= 18]
   - (s) Cataracts? [age >= 18]
   - (t) Glaucoma? [age >= 18]
   - (u) Any other long term condition? (Specify) [age >= 18]
   - (v) None
   - DK, R [Go to next section]
2. CHRON-Q1mm: What type(s) of cancer is this? For example, skin, lung or colon cancer. - Open text
3. CHRON-Q1cc1: Have/Has ... had an attack of asthma in the past 12 months? - Radio: Yes, No
4. CHRON-Q1cc2: Have/Has ... had wheezing or whistling in the chest at any time in the past 12 months? - Radio: Yes, No

#### Socio-demographic Characteristics (pp. 11-13) - 7 questions

**Country of Birth/Year of Immigration**

1. SOCIO-Q1: In what country were/was ... born? (Do not read list. Mark one only.) - Radio: Canada [Go to next section], China, France, Germany, Greece, Guyana, Hong Kong, Hungary, India, Italy, Jamaica, Netherlands, Philippines, Poland, Portugal, United Kingdom, United States, Viet Nam, Other (Specify), DK/R [Go to SOCIO-Q4]
2. SOCIO-Q3: In what year did ... first immigrate to Canada? - Numeric: Year (4 digits) [Enter <1999> if Canadian citizen by birth]

**Ethnicity**

3. SOCIO-Q4: To which ethnic or cultural group(s) did your/his/her ancestors belong? (Do not read list. Mark all that apply.) - Checkbox: Canadian, French, English, German, Scottish, Irish, Italian, Ukrainian, Dutch (Netherlands), Chinese, Jewish, Polish, Portuguese, South Asian, Black, North American Indian, Metis, Inuit/Eskimo, Other ethnic or cultural group(s) (Specify)

**Language**

4. SOCIO-Q5: In which languages can ... conduct a conversation? (Do not read list. Mark all that apply.) - Checkbox: English, French, Arabic, Chinese, Cree, German, Greek, Hungarian, Italian, Korean, Persian (Farsi), Polish, Portuguese, Punjabi, Spanish, Tagalog (Filipino), Ukrainian, Vietnamese, Other (Specify)
5. SOCIO-Q6: What is the language that ... first learned at home in childhood and can still understand? (Do not read list. Mark all that apply.) - Checkbox: (same language list as SOCIO-Q5)

**Race**

6. SOCIO-Q7: How would you best describe ...(r/'s) race or colour? (Do not read list. Mark all that apply.) - Checkbox: White, Black, Korean, Filipino, Japanese, Chinese, Native/Aboriginal Peoples of North America, South Asian, South East Asian, West Asian or North African, Other (Specify)

**Education**

[EDUC-C1: If age < 12, go to next section]

7. EDUC-Q1: Excluding kindergarten, how many years of elementary and high school have/has ... successfully completed? (Do not read list. Mark one only.) - Radio: No schooling [Go to next section], One to five years, Six, Seven, Eight, Nine, Ten, Eleven, Twelve, Thirteen, DK/R [Go to next section]

[If age < 15 then go to next section]

8. EDUC-Q2: Have/has ... graduated from high school? - Radio: Yes, No
9. EDUC-Q3: Have/has ... ever attended any other kind of school such as university, community college, business school, trade or vocational school, CEGEP or other post-secondary institution? - Radio: Yes, No [No -> EDUC-C5], DK/R [-> next section]
10. EDUC-Q4: What is the highest level of education that ... have/has attained? (Do not read list. Mark one only.) - Radio: Some trade/technical/vocational school or business college, Some community college/CEGEP/nursing school, Some university, Diploma or certificate from trade/technical/vocational school or business college, Diploma or certificate from community college/CEGEP or nursing school, Bachelor's or undergraduate degree or teacher's college, Master's, Degree in medicine/dentistry/veterinary medicine/optometry, Earned doctorate, Other (Specify)

[EDUC-C5: If age >= 65, go to next section]

11. EDUC-Q5: Are/Is ... currently attending a school, college or university? - Radio: Yes, No [No -> next section], DK/R [-> next section]
12. EDUC-Q6: Are/Is ... enrolled as a full-time or part-time student? - Radio: full-time, part-time

#### Labour Force (pp. 14-17) - 21 questions

[LFS-C1: If age < 15 go to next section]

1. LFS-Q1: What do/does ... consider to be your/his/her current main activity? (Do not read list. Mark one only.) - Radio: Caring for family, Working for pay or profit, Caring for family and working for pay or profit, Going to school, Recovering from illness/on disability, Looking for work, Retired, Other (Specify)

[LFS-C2: If LFS-Q1 = 2 or 3 ---> go to LFS-Q3.1]

2. LFS-Q2: Have/has you/he/she worked for pay or profit at any time in the past 12 months? - Radio: Yes [Go to LFS-Q3.1], No, DK/R [-> next section]

[LFS-C2A: If LFS-Q1=7 (retired) ---> go to LFS-C18 else go to LFS-Q17B]

Note: Questions LFS-Q3 to LFS-Q11 are done as a roster allowing up to 6 jobs to be entered.

3. LFS-Q3.n: For whom/whom else have/has you/he/she worked for pay or profit in the past 12 months? - Open text: 50 chars
4. LFS-Q4.n: Did you/he/she have that job 1 year ago, that is, on %12MOSAGO% without a break in employment since then? - Radio: Yes [Go to LFS-Q6.n], No, DK/R [-> next section]
5. LFS-Q5.n: When did you/he/she start working at this job or business? - Date: MM/DD/YY, DK/R [Go to next section]
6. LFS-Q6.n: Do/Does you/he/she now have that job? - Radio: Yes [Go to LFS-Q8.n], No, DK/R [-> next section]
7. LFS-Q7.n: When did you/he/she stop working at this job or business? - Date: MM/DD/YY, DK/R [Go to next section]
8. LFS-Q8.n: About how many hours per week do/does/did you/he/she usually work at this job? - Numeric: hours
9. LFS-Q9.n: Which of the following best describes the hours you/he/she usually work/works/worked at this job? (Read list. Mark one only.) - Radio: Regular daytime schedule or shift, Regular evening shift, Regular night, Rotating shift, Split shift, On call, Irregular schedule, Other (Specify)
10. LFS-Q10.n: Do/Does/Did you/he/she usually work on weekends at this job? - Radio: Yes, No
11. LFS-Q11.n: Did you/he/she do any other work for pay or profit in the past 12 months? - Radio: Yes, No, DK/R [-> LFS-Q12]

[LFS-C12: If LFS-Q11.1 = No go to LFS-Q13]

12. LFS-Q12: Which was the main job? - Selection from roster of jobs
13. LFS-Q13: Thinking about this/the main job, what kind of business, service or industry is this? - Open text: 50 chars
14. LFS-Q14: Again, thinking about this/the main job, what kind of work was/were ... doing? - Open text: 50 chars
15. LFS-Q15: In this work, what were your/his/her most important duties or activities? - Open text: 50 chars
16. LFS-Q16: Did you/he/she work mainly for others for wages or commission or in your/his/her own business, farm or practice? (Do not read list. Mark one only.) - Radio: For others for wages/salary/commission, In own business/farm/professional practice, Unpaid family worker

[LFS-C17: Check the calendar for gaps > 6 days. If # gaps = 0 ---> go to LFS-C18]
[LFS-C17A: If any LFS-Q6 = 1 (currently employed) ---> go to LFS-Q17A. Otherwise ---> go to LFS-Q17B]

17. LFS-Q17A: What was the reason that ... were/was not working for pay or profit during the most recent period away from work in the past year? (Do not read list. Mark one only.) - Radio: Own illness or disability, Pregnancy, Caring for own children, Caring for elder relative(s), Other personal or family responsibilities, School or educational leave, Labour dispute, Temporary layoff due to seasonal conditions, Temporary layoff - non-seasonal, Permanent layoff, Unpaid or partially paid vacation, Other (Specify), No period not working for pay or profit in the past year
18. LFS-Q17B: What is the reason that ... are/is currently not working for pay or profit? (Do not read list. Mark one only.) - Radio: (same options as LFS-Q17A)

[LFS-C18: Derives %LFS-WORK% variable: If LFS-Q1 = 2 or 3 or any LFS-Q6 = 1 (currently working) then %LFS-WORK%=1; Otherwise %LFS-WORK%=0]

#### Income (pp. 18-19) - 3 questions

1. INCOM-Q1: Thinking about your total household income, from which of the following sources did your household receive any income in the past 12 months? (Read list. Mark all that apply.) - Checkbox: Wages and salaries, Income from self-employment, Dividends and interest on bonds/deposits/savings/stocks/mutual funds, Unemployment insurance, Worker's compensation, Benefits from Canada or Quebec Pension Plan, Retirement pensions/superannuation/annuities, Old Age Security and Guaranteed Income Supplement, Child Tax Benefit, Provincial or municipal social assistance or welfare, Child Support, Alimony, Other Income, None [None -> next section], DK/R [-> next section]
2. INCOM-Q2: What was the main source of income? (Do not read list. Mark one only.) - Radio: (same 13 source options) [asked if more than one source indicated]
3. INCOM-Q3: What is your best estimate of the total income before taxes and deductions of all household members from all sources in the past 12 months? Was the total household income: - Hierarchical Radio: Less than $20,000 -> Less than $10,000 -> Less than $5,000 / $5,000 and more; $10,000 and more -> Less than $15,000 / $15,000 and more; $20,000 and more -> Less than $40,000 -> Less than $30,000 / $30,000 and more; $40,000 and more -> Less than $50,000, $50,000 to less than $60,000, $60,000 to less than $80,000, $80,000 and more; No income; DK/R [-> next section]

#### Administration (p. 19) - 2 questions

1. H05-P1: Was this interview conducted on the telephone or in person? - Radio: On telephone, In person, Both (Specify in comments)
2. H05-P2: Record language of interview - Radio: (same 20 language options as HHLD_Q8)

### Health Component (Form H06) (pp. 20-56)

[For selected respondent only and age >= 12. Proxy for those unable to answer due to special circumstances.]

#### H06 Administration - 2 questions

1. H06-P1: Who is providing the information for this person's form? - Open text (interviewer field)
2. H06-INT: Introductory text about the health survey

#### General Health (p. 20) - 3 questions

1. GENHLT-Q1: In general, would you say ... r/'s health is: (Read list. Mark one only.) - Radio: Excellent, Very good, Good, Fair, Poor

[GENHLT-C2: Check item: If sex = female & age >= 15 & age <= 49 ask GENHLT-Q2. Otherwise go to next section.]

2. GENHLT-Q2: Are/Is ... pregnant? - Radio: Yes, No [No -> next section], DK/R [-> next section]
3. GENHLT-Q3: Are/Is you/she planning to use the services of a physician, midwife or both? (Do not read list. Mark one only.) - Radio: Physician only, Midwife only, Both physician and midwife, Neither

#### Height/Weight (p. 20) - 2 questions

1. HTWT-Q1: How tall are/is ... without shoes on? - Numeric: feet + inches OR centimetres
2. HTWT-Q2: How much do/does you/he/she weigh? - Numeric: pounds OR kilograms

#### Preventive Health Practices (pp. 21-22) - 6 questions

(Non-proxy only)

1. PHP-Q1: When did you last have your blood pressure checked by a health professional? (Do not read list. Mark one only.) - Radio: Less than 6 months ago, 6 months to less than a year ago, 1 year to less than 2 years ago, 2 years to less than 5 years ago, 5 years or more ago, Never, R [-> next section]

[PHP-C2: If sex = female and age >= 35 then ask PHP-Q2. If sex = female and age >= 18 and age < 35 then ask PHP-Q3. If sex=male or females <= 17 then go to next section.]

2. PHP-Q2: Have you ever had a mammogram, that is, a breast X-ray? - Radio: Yes, No [No -> PHP-Q3], DK [-> PHP-Q3], R [-> next section]
3. PHP-Q2a: When was the last time? (Do not read list. Mark one only.) - Radio: Less than 6 months ago, 6 months to less than one year ago, 1 year to less than 2 years ago, 2 years or more ago
4. PHP-Q2b: Why did you have your last mammogram? (Read list. Mark one only.) - Radio: Breast problem, Check-up/no particular problem, Other (specify)
5. PHP-Q3: Have you ever had a PAP smear test? - Radio: Yes, No [No -> next section], DK/R [-> next section]
6. PHP-Q3a: When was the last time? (Do not read list. Mark one only.) - Radio: Less than 6 months ago, 6 months to less than one year ago, 1 year to less than 3 years ago, 3 years to less than 5 years ago, 5 years or more ago

#### Smoking (pp. 22-23) - 8 questions

1. SMOK-Q1: Does anyone in this household smoke regularly inside the house? - Radio: Yes, No
2. SMOK-Q2: At the present time do/does ... smoke cigarettes daily, occasionally or not at all? - Radio: Daily, Occasionally [-> SMOK-Q5], Not at all [-> SMOK-Q4a], DK/R [-> next section]
3. SMOK-Q3: At what age did you/he/she begin to smoke cigarettes daily? - Numeric: Age
4. SMOK-Q4: How many cigarettes do/does you/he/she smoke each day now? - Numeric: Number of cigarettes [Go to next section]
5. SMOK-Q4a: Have/has you/he/she ever smoked cigarettes at all? - Radio: Yes, No [No -> next section], DK/R [-> next section]
6. SMOK-Q5: Have/has you/he/she ever smoked cigarettes daily? - Radio: Yes, No [No -> next section], DK/R [-> next section]
7. SMOK-Q6: At what age did you/he/she begin to smoke (cigarettes) daily? - Numeric: Age
8. SMOK-Q7: How many cigarettes did you/he/she usually smoke each day? - Numeric: Number of cigarettes
9. SMOK-Q8: At what age did you/he/she stop smoking (cigarettes) daily? - Numeric: Age

#### Alcohol (pp. 23-24) - 9 questions

1. ALCO-Q1: During the past 12 months, have/has ... had a drink of beer, wine, liquor or any other alcoholic beverage? - Radio: Yes, No [No -> ALCO-Q5B], DK/R [-> next section]
2. ALCO-Q2: During the past 12 months, how often did you/he/she drink alcoholic beverages? (Do not read list. Mark one only.) - Radio: Every day, 4-6 times a week, 2-3 times a week, Once a week, 2-3 times a month, Once a month, Less than once a month
3. ALCO-Q3: How many times in the past 12 months have/has you/he/she had 5 or more drinks on one occasion? - Numeric: Number of times
4. ALCO-Q4: In the past 12 months, what is the highest number of drinks you had on one occasion? - Numeric: Number of drinks [If PROXY=yes then go to ALCO-Q5]
5. ALCO-Q5: Thinking back over the past week, that is, from %1WKAGO% to yesterday, did ... have a drink of beer, wine, liquor or any other alcoholic beverage? - Radio: Yes, No [No -> next section], DK/R [-> next section]
6. ALCO-Q5A: Starting with yesterday, how many drinks did ... have on: - QuestionGroup (7 sub-items, each Numeric):
   - Monday?
   - Tuesday?
   - Wednesday?
   - Thursday?
   - Friday?
   - Saturday?
   - Sunday?
   [R on first day -> next section; then Go to next section]
7. ALCO-Q5B: Did you/he/she ever have a drink? - Radio: Yes, No [No -> next section], DK/R [-> next section]
8. ALCO-Q6: Did you/he/she ever regularly drink more than 12 drinks a week? - Radio: Yes, No [No -> next section], DK/R [-> next section]
9. ALCO-Q7: Why did you/he/she reduce or quit drinking altogether? (Do not read list. Mark all that apply.) - Checkbox: Dieting, Athletic training, Pregnancy, Getting older, Drinking too much/drinking problem, Affected work/studies/employment opportunities, Interfered with family or home life, Affected physical health, Affected friendships or social relationships, Affected financial position, Affected outlook on life/happiness, Because of influence of family or friends, Other (specify)

#### Physical Activities (pp. 24-26) - 7 questions

(Non-proxy only)

1. PHYS-Q1: Have you done any of the following in the past 3 months? (Read list. Mark all that apply.) - Checkbox: Walking for exercise, Gardening/yard work, Swimming, Bicycling, Popular or social dance, Home exercises, Ice hockey, Skating, Downhill skiing, Jogging/running, Golfing, Exercise class/aerobics, Cross-country skiing, Bowling, Baseball/softball, Tennis, Weight-training, Fishing, Volleyball, Yoga or tai-chi, Other (specify) x3, None, DK/R [-> next section]
   [For each response ask PHYS-Q2 to PHYS-Q3. If "none" go to PHYS-INTb.]
2. PHYS-Q2: In the past 3 months, how many times did you participate in %ACTIVITY%? - Numeric: Number of times, DK/R [-> next activity]
3. PHYS-Q3: About how much time did you usually spend on each occasion? (Do not read list. Mark one only.) - Radio: 1 to 15 minutes, 16 to 30 minutes, 31 to 60 minutes, More than one hour
4. PHYS-Q4a: In a typical week in the past 3 months, how many hours did you usually spend walking to work or to school or while doing errands? (Do not read list. Mark one only.) - Radio: None, Less than 1 hour, From 1 to 5 hours, From 6 to 10 hours, From 11 to 20 hours, More than 20 hours
5. PHYS-Q4b: In a typical week, how much time did you usually spend bicycling to work or to school or while doing errands? (Do not read list. Mark one only.) - Radio: None, Less than 1 hour, From 1 to 5 hours, From 6 to 10 hours, From 11 to 20 hours, More than 20 hours

[PHYS-C1: If Bicycling was indicated as an activity in PHYS-Q1 or not a "none" in PHYS-Q4b, ask PHYS-Q5. Otherwise go to PHYS-Q6.]

6. PHYS-Q5: When riding a bicycle how often did you wear a helmet? (Read list. Mark one only.) - Radio: Always, Most of the time, Rarely, Never
7. PHYS-Q6: Thinking back over the past 3 months, which of the following best describes your usual daily activities or work habits? (Read list. Mark one only.) - Radio: Usually sit during day and do not walk about very much, Stand or walk about quite a lot during the day but do not have to carry or lift things very often, Usually lift or carry light loads or have to climb stairs or hills often, Do heavy work or carry very heavy loads

#### Injuries (pp. 26-28) - 8 questions

1. INJ-Q1: In the past 12 months, did ... have any injuries that were serious enough to limit your/his/her normal activities? - Radio: Yes, No [No -> next section], DK/R [-> next section]
2. INJ-Q2: How many times were/was you/he/she injured? - Numeric: times, DK/R [-> next section]
3. INJ-Q3: Thinking about the most serious injury, what type of injury did you/he/she have? (Do not read list. Mark one only.) - Radio: Multiple injuries, Broken or fractured bones, Burn or scald, Dislocation, Sprain or strain, Cut or scrape, Bruise or abrasion, Concussion, Poisoning by substance or liquid, Internal injury, Other (specify)
4. INJ-Q4: What part of your/his/her body was injured? (Do not read list. Mark one only.) - Radio: Multiple sites, Eyes, Head (excluding eyes), Neck, Shoulder, Arms or hands, Hip, Legs or feet, Back or spine, Trunk (excluding back or spine)
5. INJ-Q5: Where did the injury happen? (Do not read list. Mark one only.) - Radio: Home and surrounding area, Farm, Place for recreation or sport, Street or highway, Building used by general public, Residential institution, Mine, Industrial place or premise, Other (specify)
6. INJ-Q6: What happened? (Do not read list. Mark one only.) - Radio: Motor vehicle accident, Accidental fall, Fire/flames or resulting fumes, Accidentally struck by an object/person, Physical assault, Suicide attempt, Accidental injury caused by explosion, Accidental injury caused by natural/environmental factors, Accidental drowning or submersion, Accidental suffocation, Hot or corrosive liquids/foods/substances, Accident caused by machinery, Accident caused by cutting and piercing instruments or objects, Accidental poisoning, Other (specify)
7. INJ-Q7: Was this a work-related injury? - Radio: Yes, No
8. INJ-Q8: What precautions are/is you/he/she taking? (Do not read list. Mark all that apply.) - Checkbox: Gave up the activity, Being more careful, Took safety training, Increased supervision of child, Using protective gear/safety equipment, Changing physical situation, Other (specify), No precautions

#### Stress - Ongoing Problems (pp. 28-30) - 18 questions

(Age >= 18 and non-proxy only)

1. CSTRESS-Q1: You are trying to take on too many things at once. - Radio: True, False, R [R -> next section]
2. CSTRESS-Q2: There is too much pressure on you to be like other people. - Radio: True, False
3. CSTRESS-Q3: Too much is expected of you by others. - Radio: True, False
4. CSTRESS-Q4: You don't have enough money to buy the things you need. - Radio: True, False

[Routing: If marital status = married/living with partner/common-law -> CSTRESS-Q5. If marital status = single/widowed/separated/divorced -> CSTRESS-Q8. Otherwise (unknown) -> CSTRESS-Q9.]

5. CSTRESS-Q5: Your partner doesn't understand you. - Radio: True, False
6. CSTRESS-Q6: Your partner doesn't show enough affection. - Radio: True, False
7. CSTRESS-Q7: Your partner is not committed enough to your relationship. - Radio: True, False [Go to CSTRESS-Q9]
8. CSTRESS-Q8: You find it is very difficult to find someone compatible with you. - Radio: True, False
9. CSTRESS-Q9: Do you have any children? - Radio: Yes, No [No -> CSTRESS-Q12], DK/R [-> CSTRESS-Q12]
10. CSTRESS-Q10: One of your children seems very unhappy. - Radio: True, False
11. CSTRESS-Q11: A child's behaviour is a source of serious concern to you. - Radio: True, False
12. CSTRESS-Q12: Your work around the home is not appreciated. - Radio: True, False
13. CSTRESS-Q13: Your friends are a bad influence. - Radio: True, False
14. CSTRESS-Q14: You would like to move but you cannot. - Radio: True, False
15. CSTRESS-Q15: Your neighbourhood or community is too noisy or too polluted. - Radio: True, False
16. CSTRESS-Q16: You have a parent, a child or partner who is in very bad health and may die. - Radio: True, False
17. CSTRESS-Q17: Someone in your family has an alcohol or drug problem. - Radio: True, False
18. CSTRESS-Q18: People are too critical of you or what you do. - Radio: True, False

#### Stress - Recent Life Events (pp. 31-32) - 10 questions

1. RECENT-Q1: In the past 12 months, was any one of you beaten up or physically attacked? - Radio: Yes, No, R [R -> next section]
2. RECENT-Q2: In the past 12 months, did you or someone in your family have an unwanted pregnancy? - Radio: Yes, No
3. RECENT-Q3: In the past 12 months, did you or someone in your family have an abortion or miscarriage? - Radio: Yes, No
4. RECENT-Q4: In the past 12 months, did you or someone in your family have a major financial crisis? - Radio: Yes, No
5. RECENT-Q5: In the past 12 months, did you or someone in your family fail school or a training program? - Radio: Yes, No

[If marital status = married/living together/common-law ask RECENT-Q6 and RECENT-Q7 with partner phrase. Otherwise go to RECENT-Q8 routing below.]

6. RECENT-Q6: In the past 12 months, did you (or your partner) experience a change of job for a worse one? - Radio: Yes, No
7. RECENT-Q7: In the past 12 months, were you (or your partner) demoted at work or did you/either of you take a cut in pay? - Radio: Yes, No

[If marital status = married/living together/common-law ask RECENT-Q8. Otherwise go to RECENT-Q9.]

8. RECENT-Q8: In the past 12 months, did you have increased arguments with your partner? - Radio: Yes, No
9. RECENT-Q9: Now, just you personally, in the past 12 months, did you go on Welfare? - Radio: Yes, No

[IF CSTRESS-Q9 = yes (have children) ask RECENT-Q10. Otherwise go to next section.]

10. RECENT-Q10: In the past 12 months, did you have a child move back into the house? - Radio: Yes, No

#### Stress - Childhood and Adult Stressors ("traumas") (pp. 32-33) - 7 questions

1. TRAUM-Q1: Did you spend 2 weeks or more in the hospital? - Radio: Yes, No, R [R -> next section]
2. TRAUM-Q2: Did your parents get a divorce? - Radio: Yes, No
3. TRAUM-Q3: Did your father or mother not have a job for a long time when they wanted to be working? - Radio: Yes, No
4. TRAUM-Q4: Did something happen that scared you so much you thought about it for years after? - Radio: Yes, No
5. TRAUM-Q5: Were you sent away from home because you did something wrong? - Radio: Yes, No
6. TRAUM-Q6: Did either of your parents drink or use drugs so often that it caused problems for the family? - Radio: Yes, No
7. TRAUM-Q7: Were you ever physically abused by someone close to you? - Radio: Yes, No

#### Work Stress (p. 33) - 2 questions

(Age >= 15 and non-proxy only. Ask only of those currently employed; if more than one job, ask for main job.)

1. WSTRESS-Q1: Now I am going to read you a series of statements that might describe your job situation. Please tell me if you STRONGLY AGREE, AGREE, NEITHER AGREE NOR DISAGREE, DISAGREE, or STRONGLY DISAGREE with each of the following: - QuestionGroup (12 sub-items, each 5-point Likert: Strongly Agree to Strongly Disagree; R on first item -> next section):
   - a) Your job requires that you learn new things
   - b) Your job requires a high level of skill
   - c) Your job allows you freedom to decide how you do your job
   - d) Your job requires that you do things over and over
   - e) Your job is very hectic
   - f) You are free from conflicting demands that others make
   - g) Your job security is good
   - h) Your job requires a lot of physical effort
   - i) You have a lot to say about what happens in your job
   - j) You are exposed to hostility or conflict from the people you work with
   - k) Your supervisor is helpful in getting the job done
   - l) The people you work with are helpful in getting the job done
2. WSTRESS-Q2: How satisfied are you with your job? (Read list. Mark one only.) - Radio: Very satisfied, Somewhat satisfied, Not too satisfied, Not at all satisfied

#### Self-Esteem and Mastery (pp. 33-34) - 2 questions

(Age >= 12 and non-proxy only)

1. ESTEEM-Q1: (Rosenberg self-esteem scale, 5-point Likert: Strongly Agree to Strongly Disagree; R on first item -> next section) - QuestionGroup (6 sub-items):
   - a) You feel that you have a number of good qualities.
   - b) You feel that you're a person of worth at least equal to others.
   - c) You are able to do things as well as most other people.
   - d) You take a positive attitude toward yourself.
   - e) On the whole you are satisfied with yourself.
   - f) All in all, you're inclined to feel you're a failure.

(Age > 12 and non-proxy only)

2. MAST-Q1: (Pearlin mastery scale, 5-point Likert: Strongly Agree to Strongly Disagree; R on first item -> next section) - QuestionGroup (7 sub-items):
   - a) You have little control over the things that happen to you
   - b) There is really no way you can solve some of the problems you have
   - c) There is little you can do to change many of the important things in your life
   - d) You often feel helpless in dealing with problems of life
   - e) Sometimes you feel that you are being pushed around in life
   - f) What happens to you in the future mostly depends on you
   - g) You can do just about anything you really set your mind to

#### Sense of Coherence (pp. 34-37) - 13 questions

(Age >= 18 and non-proxy only)

1. SCOH-Q1: How often do you have the feeling that you don't really care about what goes on around you? - Scale: 1 (Very seldom or never) to 7 (Very often), DK/R [-> next section]
2. SCOH-Q2: How often in the past were you surprised by the behaviour of people whom you thought you knew well? - Scale: 1 (Never happened) to 7 (Always happened)
3. SCOH-Q3: How often have people you counted on disappointed you? - Scale: 1 (Never happened) to 7 (Always happened)
4. SCOH-Q4: How often do you have the feeling you're being treated unfairly? - Scale: 1 (Very often) to 7 (Very seldom or never)
5. SCOH-Q5: How often do you have the feeling you are in an unfamiliar situation and don't know what to do? - Scale: 1 (Very often) to 7 (Very seldom or never)
6. SCOH-Q6: How often do you have very mixed-up feelings and ideas? - Scale: 1 (Very often) to 7 (Very seldom or never)
7. SCOH-Q7: How often do you have feelings inside that you would rather not feel? - Scale: 1 (Very often) to 7 (Very seldom or never)
8. SCOH-Q8: Many people -- even those with a strong character -- sometimes feel like sad sacks (losers) in certain situations. How often have you felt this way in the past? - Scale: 1 (Very seldom or never) to 7 (Very often)
9. SCOH-Q9: How often do you have the feeling that there's little meaning in the things you do in your daily life? - Scale: 1 (Very often) to 7 (Very seldom or never)
10. SCOH-Q10: How often do you have feelings that you're not sure you can keep under control? - Scale: 1 (Very often) to 7 (Very seldom or never)
11. SCOH-Q11: Until now your life has had no clear goals or purpose or has it had very clear goals and purpose? - Scale: 1 (No clear goals or no purpose at all) to 7 (Very clear goals and purpose)
12. SCOH-Q12: When something happens, you generally find that you overestimate or underestimate its importance or you see things in the right proportion? - Scale: 1 (Overestimate or underestimate its importance) to 7 (See things in the right proportion)
13. SCOH-Q13: Is doing the things you do every day a source of great pleasure and satisfaction or a source of pain and boredom? - Scale: 1 (A great deal of pleasure and satisfaction) to 7 (A source of pain and boredom)

#### Health Status - Vision (pp. 37-38) - 5 questions

1. HSTAT-Q1: Are/Is ... usually able to see well enough to read ordinary newsprint without glasses or contact lenses? - Radio: Yes [Go to HSTAT-Q4], No, DK/R [-> HSTAT-Q6]
2. HSTAT-Q2: Are/Is you/he/she usually able to see well enough to read ordinary newsprint with glasses or contact lenses? - Radio: Yes [Go to HSTAT-Q4], No
3. HSTAT-Q3: Are/Is you/he/she able to see at all? - Radio: Yes, No [No -> HSTAT-Q6], DK/R [-> HSTAT-Q6]
4. HSTAT-Q4: Are/Is you/he/she able to see well enough to recognize a friend on the other side of the street without glasses or contact lenses? - Radio: Yes [Go to HSTAT-Q6], No, DK/R [-> HSTAT-Q6]
5. HSTAT-Q5: Are/Is you/he/she usually able to see well enough to recognize a friend on the other side of the street with glasses or contact lenses? - Radio: Yes, No

#### Health Status - Hearing (pp. 38-39) - 4 questions

6. HSTAT-Q6: Are/Is ... usually able to hear what is said in a group conversation with at least three other people without a hearing aid? - Radio: Yes [Go to HSTAT-Q10], No, DK/R [-> HSTAT-Q10]
7. HSTAT-Q7: Are/Is you/he/she usually able to hear what is said in a group conversation with at least three other people with a hearing aid? - Radio: Yes [Go to HSTAT-Q8], No
8. HSTAT-Q7a: Are/Is you/he/she able to hear at all? - Radio: Yes, No [No -> HSTAT-Q10], DK/R [-> HSTAT-Q10]
9. HSTAT-Q8: Are/Is you/he/she usually able to hear what is said in a conversation with one other person in a quiet room without a hearing aid? - Radio: Yes [Go to HSTAT-Q10], No, R [-> HSTAT-Q10]
10. HSTAT-Q9: Are/Is you/he/she usually able to hear what is said in a conversation with one other person in a quiet room with a hearing aid? - Radio: Yes, No

#### Health Status - Speech (p. 39) - 4 questions

11. HSTAT-Q10: Are/Is ... usually able to be understood completely when speaking with strangers in your own language? - Radio: Yes [Go to HSTAT-Q14], No, R [-> HSTAT-Q14]
12. HSTAT-Q11: Are/Is you/he/she able to be understood partially when speaking with strangers? - Radio: Yes, No
13. HSTAT-Q12: Are/Is you/he/she able to be understood completely when speaking with those who know you/him/her well? - Radio: Yes [Go to HSTAT-Q14], No, R [-> HSTAT-Q14]
14. HSTAT-Q13: Are/Is you/he/she able to be understood partially when speaking with those who know you/him/her well? - Radio: Yes, No

#### Health Status - Getting Around (pp. 39-40) - 7 questions

15. HSTAT-Q14: Are/Is ... usually able to walk around the neighbourhood without difficulty and without mechanical support such as braces, a cane or crutches? - Radio: Yes [Go to HSTAT-Q21], No, DK/R [-> HSTAT-Q21]
16. HSTAT-Q15: Are/Is you/he/she able to walk at all? - Radio: Yes, No [No -> HSTAT-Q18], DK/R [-> HSTAT-Q18]
17. HSTAT-Q16: Do/Does you/he/she require mechanical support such as braces, a cane or crutches to be able to walk around the neighbourhood? - Radio: Yes, No
18. HSTAT-Q17: Do/Does you/he/she require the help of another person to be able to walk? - Radio: Yes, No
19. HSTAT-Q18: Do/Does you/he/she require a wheelchair to get around? - Radio: Yes, No [No -> HSTAT-Q21], DK/R [-> HSTAT-Q21]
20. HSTAT-Q19: How often do/does you/he/she use a wheelchair? (Read list. Mark one only.) - Radio: Always, Often, Sometimes, Never
21. HSTAT-Q20: Do/Does you/he/she need the help of another person to get around in the wheelchair? - Radio: Yes, No

#### Health Status - Hands and Fingers (p. 40) - 4 questions

22. HSTAT-Q21: Are/Is ... usually able to grasp and handle small objects such as a pencil and scissors? - Radio: Yes [Go to HSTAT-Q25], No, DK/R [-> HSTAT-Q25]
23. HSTAT-Q22: Do/Does you/he/she require the help of another person because of limitations in the use of hands or fingers? - Radio: Yes, No [No -> HSTAT-Q24], DK/R [-> HSTAT-Q24]
24. HSTAT-Q23: Do/Does you/he/she require the help of another person with: (Read list. Mark one only.) - Radio: Some tasks?, Most tasks?, Almost all tasks?, All tasks?
25. HSTAT-Q24: Do/Does you/he/she require special equipment, for example, devices to assist in dressing because of limitations in the use of hands or fingers? - Radio: Yes, No

#### Health Status - Feelings (p. 41) - 1 question

26. HSTAT-Q25: Would you describe yourself/... as being usually: (Read list. Mark one only.) - Radio: Happy and interested in life?, Somewhat happy?, Somewhat unhappy?, Unhappy with little interest in life?, So unhappy that life is not worthwhile?

#### Health Status - Memory (p. 41) - 1 question

27. HSTAT-Q26: How would you describe your/his/her usual ability to remember things? Are/Is you/he/she: (Read list. Mark one only.) - Radio: Able to remember most things?, Somewhat forgetful?, Very forgetful?, Unable to remember anything at all?

#### Health Status - Thinking (p. 41) - 1 question

28. HSTAT-Q27: How would you describe your/his/her usual ability to think and solve day to day problems? Are/Is you/he/she: (Read list. Mark one only.) - Radio: Able to think clearly and solve problems?, Having a little difficulty?, Having some difficulty?, Having a great deal of difficulty?, Unable to think or solve problems?

#### Health Status - Pain and Discomfort (pp. 41-42) - 3 questions

29. HSTAT-Q28: Are/Is ... usually free of pain or discomfort? - Radio: Yes [Go to next section], No, DK/R [-> next section]
30. HSTAT-Q29: How would you describe the usual intensity of your/his/her pain or discomfort? (Read list. Mark one only.) - Radio: Mild, Moderate, Severe
31. HSTAT-Q30: How many activities does your/his/her pain or discomfort prevent? (Read list. Mark one only.) - Radio: None, A few, Some, Most

#### Drug Use (pp. 42-43) - 5 questions

1. DRUG-Q1: In the past month, did ... take any of the following medications? (Read list. Mark all that apply.) - Checkbox: Pain relievers such as aspirin or tylenol, Tranquilizers such as valium, Diet pills, Anti-depressants, Codeine/Demerol or Morphine, Allergy medicine such as "Sinutab", Asthma medications, Cough or cold remedies, Penicillin or other antibiotic, Medicine for the heart, Medicine for blood pressure, Diuretics or water pills, Steroids, Insulin, Pills to control diabetes, Sleeping pills, Stomach remedies, Laxatives, Hormones for menopause or aging symptoms [sex=female, age >= 30], Birth control pills [sex=female, age >= 12 & age <= 49], Any other medication (Specify), None of the above

[DRUG-C1: If any drug(s) specified in DRUG-Q1 go to DRUG-Q2. Otherwise go to DRUG-Q4.]

2. DRUG-Q2: Now, I am referring to yesterday and the day before yesterday. During those two days, how many different medications did you/he/she take? - Numeric: Number of different medications, DK/R [-> DRUG-Q4] [If number=0 then go to DRUG-Q4. For each number >0 ask DRUG-Q3...up to a maximum of 12.]
3. DRUG-Q3: What is the exact name of the medication that ... took? (Ask the person to look at the bottle, tube or box.) - Open text [DK/R to any medication -> next section]
4. DRUG-Q4: There are many other health products such as ointments, vitamins, herbs, minerals, teas or protein drinks which people use to prevent illness or to improve or maintain their health. Do/Does ... use any of these or other health products? - Radio: Yes, No [No -> next section], DK/R [-> next section]
5. DRUG-Q5: What is the exact name of the health product that ... use(s)? (Ask the person to look at the bottle, tube or box.) (up to 12 products) - Open text

#### Mental Health - K6 Distress Scale (pp. 43-45) - 11 questions

(Non-proxy only)

During the past month, about how often did you feel:

1. MHLTH-Q1a: ...so sad that nothing could cheer you up? (Read list. Mark one only.) - Radio: All of the time, Most of the time, Some of the time, A little of the time, None of the time, DK/R [-> MHLTH-Q1k]
2. MHLTH-Q1b: ...nervous? - Radio: (same 5-point scale), DK/R [-> MHLTH-Q1k]
3. MHLTH-Q1c: ...restless or fidgety? - Radio: (same 5-point scale), DK/R [-> MHLTH-Q1k]
4. MHLTH-Q1d: ...hopeless? - Radio: (same 5-point scale), DK/R [-> MHLTH-Q1k]
5. MHLTH-Q1e: ...worthless? - Radio: (same 5-point scale), DK/R [-> MHLTH-Q1k]
6. MHLTH-Q1f: ...everything was an effort? - Radio: (same 5-point scale), DK/R [-> MHLTH-Q1k]

[MHLTH-C1g: IF MHLTH-Q1a to MHLTH-Q1f are all "none" go to MHLTH-Q1k]

7. MHLTH-Q1g: We have just been talking about feelings and experiences that occurred to different degrees during the past month. Taking them altogether, did these feelings occur more often in the past month than is usual for you, less often than usual, or about the same as usual? (Do not read list. Mark one only.) - Radio: More often, Less often [-> MHLTH-Q1i], About the same [-> MHLTH-Q1j], Never have had any [-> MHLTH-Q1k], DK/R [-> MHLTH-Q1k]
8. MHLTH-Q1h: Is that a lot more, somewhat or only a little more often than usual? (Do not read list. Mark one only.) - Radio: A lot more, Somewhat more, A little more, DK/R [-> MHLTH-Q1k] [Go to Q1j]
9. MHLTH-Q1i: Is that a lot less, somewhat or only a little less often than usual? (Do not read list. Mark one only.) - Radio: A lot less, Somewhat less, A little less, DK/R [-> MHLTH-Q1k]
10. MHLTH-Q1j: How much do these experiences usually interfere with your life or activities? (Read list. Mark one only.) - Radio: A lot, Some, A little, Not at all
11. MHLTH-Q1k: In the past 12 months, have you seen or talked on the telephone to a health professional about your emotional or mental health? - Radio: Yes, No [No -> MHLTH-Q2], DK/R [-> MHLTH-Q2]
12. MHLTH-Q1l: How many times (in the past 12 months)? - Numeric: # of times

#### Mental Health - CIDI-SF Depression Screening: Sadness Pathway (pp. 45-47) - 11 questions

13. MHLTH-Q2: During the past 12 months, was there ever a time when you felt sad, blue, or depressed for 2 weeks or more in a row? - Radio: Yes, No [No -> MHLTH-Q16], DK/R [-> next section]
14. MHLTH-Q3: For the next few questions, please think of the 2-week period during the past 12 months when these feelings were worst. During that time how long did these feelings usually last? (Read list. Mark one only.) - Radio: All day long, Most of the day, About half of the day [-> MHLTH-Q16], Less than half the day [-> MHLTH-Q16], DK/R [-> next section]
15. MHLTH-Q4: How often did you feel this way during those 2 weeks? (Read list. Mark one only.) - Radio: Every day, Almost every day, Less often [-> MHLTH-Q16], DK/R [-> next section]
16. MHLTH-Q5: During those 2 weeks did you lose interest in most things? - Radio: Yes (KEY PHRASE = LOSING INTEREST), No, DK/R [-> next section]
17. MHLTH-Q6: Did you feel tired out or low on energy all of the time? - Radio: Yes (KEY PHRASE = FEELING TIRED), No, DK/R [-> next section]
18. MHLTH-Q7: Did you gain weight, lose weight or stay about the same? (Do not read list. Mark one only.) - Radio: Gained weight (KEY PHRASE = GAINING WEIGHT), Lost weight (KEY PHRASE = LOSING WEIGHT), Stayed about the same [-> MHLTH-Q9], Was on a diet [-> MHLTH-Q9], DK/R [-> next section]
19. MHLTH-Q8: About how much did you (gain/lose)? - Numeric: pounds or kilograms
20. MHLTH-Q9: Did you have more trouble falling asleep than you usually do? - Radio: Yes (KEY PHRASE = TROUBLE FALLING ASLEEP), No [-> MHLTH-Q11], DK/R [-> next section]
21. MHLTH-Q10: How often did that happen? (Read list. Mark one only.) - Radio: Every night, Nearly every night, Less often, DK/R [-> next section]
22. MHLTH-Q11: Did you have a lot more trouble concentrating than usual? - Radio: Yes (KEY PHRASE = TROUBLE CONCENTRATING), No, DK/R [-> next section]
23. MHLTH-Q12: At these times, people sometimes feel down on themselves, no good, or worthless. Did you feel this way? - Radio: Yes (KEY PHRASE = FEELING DOWN ON YOURSELF), No, DK/R [-> next section]
24. MHLTH-Q13: Did you think a lot about death - either your own, someone else's, or death in general? - Radio: Yes (KEY PHRASE = THOUGHTS ABOUT DEATH), No, DK/R [-> next section]

[MHLTH-C14: If any "yes" in Q5, Q6, Q9, Q11, Q12 or Q13, or Q7 is "gain" or "lose" then go to MHLTH-Q14. Otherwise go to next section.]

25. MHLTH-Q14: Reviewing what you just told me, you had 2 weeks in a row during the past 12 months when you were sad, blue, or depressed and also had some other things like (KEY PHRASES). About how many weeks altogether did you feel this way during the past 12 months? - Numeric: # of weeks [IF >51 weeks then go to next section], DK/R [-> next section]
26. MHLTH-Q15: Think about the last time you felt this way for 2 weeks or more in a row. In what month was that? - Radio: January through December [Go to next section]

#### Mental Health - CIDI-SF Depression Screening: Interest Pathway (pp. 47-49) - 12 questions

27. MHLTH-Q16: During the past 12 months, was there ever a time lasting 2 weeks or more when you lost interest in most things like hobbies, work, or activities that usually give you pleasure? - Radio: Yes, No [No -> next section], DK/R [-> next section]
28. MHLTH-Q17: For the next few questions, please think of the 2-week period during the past 12 months when you had the most complete loss of interest in things. During that 2-week period, how long did the loss of interest usually last? (Read list. Mark one only.) - Radio: All day long, Most of the day, About half of the day [-> next section], Less than half the day [-> next section], DK/R [-> next section]
29. MHLTH-Q18: How often did you feel this way during those 2 weeks? (Read list. Mark one only.) - Radio: Every day, Almost every day, Less often [-> next section], DK/R [-> next section]
30. MHLTH-Q19: During those 2 weeks did you feel tired out or low on energy all the time? - Radio: Yes (KEY PHRASE = FEELING TIRED), No, DK/R [-> next section]
31. MHLTH-Q20: Did you gain weight, lose weight, or stay about the same? - Radio: Gained weight (KEY PHRASE = GAINING WEIGHT), Lost weight (KEY PHRASE = LOSING WEIGHT), Stayed about the same [-> MHLTH-Q22], Was on a diet [-> MHLTH-Q22], DK/R [-> next section]
32. MHLTH-Q21: About how much did you (gain/lose)? - Numeric: pounds or kilograms
33. MHLTH-Q22: Did you have more trouble falling asleep than you usually do? - Radio: Yes (KEY PHRASE = TROUBLE FALLING ASLEEP), No [-> MHLTH-Q24], DK/R [-> next section]
34. MHLTH-Q23: How often did that happen during those 2 weeks? (Read list. Mark one only.) - Radio: Every night, Nearly every night, Less often, DK/R [-> next section]
35. MHLTH-Q24: Did you have a lot more trouble concentrating than usual? - Radio: Yes (KEY PHRASE = TROUBLE CONCENTRATING), No, DK/R [-> next section]
36. MHLTH-Q25: At these times, people sometimes feel down on themselves, no good, or worthless. Did you feel this way? - Radio: Yes (KEY PHRASE = FEELING DOWN ON YOURSELF), No, DK/R [-> next section]
37. MHLTH-Q26: Did you think a lot about death - either your own, someone else's, or death in general? - Radio: Yes (KEY PHRASE = THOUGHTS ABOUT DEATH), No, DK/R [-> next section]

[MHLTH-C27: If any "yes" in Q19, Q22, Q24, Q25 or Q26, or Q20 is "gain" or "lose" then go to MHLTH-Q27. Otherwise go to next section.]

38. MHLTH-Q27: Reviewing what you just told me, you had 2 weeks in a row during the past 12 months when you lost interest in most things and also had some other things like (KEY PHRASES). About how many weeks did you feel this way during the past 12 months? - Numeric: # of weeks [IF >51 weeks then go to next section], DK/R [-> next section]
39. MHLTH-Q28: Think about the last time you had 2 weeks in a row when you felt this way. In what month was that? - Radio: January through December

#### Social Support (pp. 49-50) - 8 questions

(Non-proxy only)

1. SOCSUP-Q1: Are you a member of any voluntary organizations or associations such as school groups, church social groups, community centres, ethnic associations, or social, civic or fraternal clubs? - Radio: Yes, No [No -> SOCSUP-Q2a], DK/R [-> SOCSUP-Q2a]
2. SOCSUP-Q2: How often did you participate in meetings or activities sponsored by these groups in the past 12 months? (Read list. Mark one only.) - Radio: At least once a week, At least once a month, At least 3 or 4 times a year, At least once a year, Not at all
3. SOCSUP-Q2a: Other than on special occasions (such as weddings, funerals or baptisms), how often did you attend religious services or religious meetings in the past 12 months? (Read list. Mark one only.) - Radio: At least once a week, At least once a month, At least 3 or 4 times a year, At least once a year, Not at all
4. SOCSUP-Q3: Do you have someone you can confide in, or talk to about your private feelings or concerns? - Radio: Yes, No
5. SOCSUP-Q4: Do you have someone you can really count on to help you out in a crisis situation? - Radio: Yes, No
6. SOCSUP-Q5: Do you have someone you can really count on to give you advice when you are making important personal decisions? - Radio: Yes, No
7. SOCSUP-Q6: Do you have someone that makes you feel loved and cared for? - Radio: Yes, No
8. SOCSUP-Q7: The next few questions are about your contact in the past 12 months with persons who do not live with you. How often did you have contact with [fill with categories below]? - QuestionGroup (8 sub-items, each Radio: Don't have any, Every day, At least once a week, 2 or 3 times a month, Once a month, A few times a year, Once a year, Never):
   - Your parents or parents-in-law
   - Your grandparents
   - Your daughters or daughters-in-law
   - Your sons or sons-in-law
   - Your brothers or sisters
   - Other relatives (including in-laws)
   - Your close friends
   - Your neighbours

#### Health Number (p. 50) - 2 questions

1. H06-HLTH#: We are seeking your permission to link information collected during this interview with provincial health information. Do we have your permission? - Radio: Yes, No [No -> H06-SHARE], DK/R [-> next section]
2. H06-HLTH#l: What is ...r/s provincial health number? - Open text

#### Agreement to Share (p. 51) - 1 question

1. H06-SHARE: Do you agree to share the information you have provided? (with provincial ministries of health, Health Canada, and Employment and Immigration Canada) - Radio: Yes, No

#### H06 Administration (p. 51) - 4 questions

1. H06-TEL: Was this interview conducted on the telephone or in person? - Radio: On telephone, In person, Both (Specify reason)
2. H06-CTEXT: Was the respondent alone when you asked this health questionnaire? - Radio: Yes [Go to H06-P2], No
3. H06-CTEXT1: Do you think that the answers of the respondent were affected by someone else being there? - Radio: Yes (Specify), No
4. H06-P2: Record language of interview - Radio: (same 20 language options)

#### Manitoba Buy-in Questions (pp. 52-54) - 14 questions

(Age >= 18 and non-proxy only)

1. SPR6-Q1: Do you always try to do what is reasonable and logical? - Radio: Yes, No
2. SPR6-Q2: Do you always try to understand people and their behaviour, to avoid responding emotionally? - Radio: Yes, No
3. SPR6-Q3: When dealing with other people do you always try to act rationally? - Radio: Yes, No
4. SPR6-Q4: Do you try to overcome all conflicts with other people by intelligence and reason, trying hard not to show your emotions? - Radio: Yes, No
5. SPR6-Q5: If someone deeply hurts your feelings, do you nevertheless try to treat him or her rationally and to understand his or her way of behaving? - Radio: Yes, No
6. SPR6-Q6: Do you succeed in avoiding most conflicts with other people by relying on your reason and logic, even if this is not how you feel at the time? - Radio: Yes, No
7. SPR6-Q7: If someone acts against your needs and desires, do you nevertheless try to understand that person? - Radio: Yes, No
8. SPR6-Q8: Do you behave so rationally in most life situations that your behaviour is rarely influenced by only your emotions? - Radio: Yes, No
9. SPR6-Q9: Do your emotions frequently influence your behaviour to such a degree that your behaviour might be considered harmful to yourself and others? - Radio: Yes, No
10. SPR6-Q10: Do you try to understand others even if you don't like them? - Radio: Yes, No
11. SPR6-Q11: Does your rationality prevent you from verbally attacking or criticizing others, even if there are sufficient reasons for doing so? - Radio: Yes, No
12. SPR6-Q12: Imagine you are afraid of the dentist and you have to get some dental work done. Which of the following things would you do to help you overcome your fears? (Read list. Mark all that apply.) - Checkbox: Ask the dentist exactly what he is doing, Take a tranquilizer or have a drink before going, Try to think about other things like pleasant memories, Have the dentist tell you when you would feel pain, Try to sleep, Watch all the dentist's movements and listen for the sound of the drill, Watch the flow of water from your mouth to see if it contained blood, Do mental puzzles in your mind, Other (Specify)
13. SPR6-Q13: Imagine that you are a salesperson and get along well with your fellow workers. It has been rumoured that, due to a large drop in sales, several people in your department will be laid off. Which of the following would you do? (Read list. Mark all that apply.) - Checkbox: Talk to your fellow workers to see if they know anything about the supervisor's evaluation of you, Review the list of duties for your present job and try to figure out if you had accomplished all of them, Watch TV/go to the movies or do something like that to take your mind off things, Try to remember any arguments or disagreements you might have had with your supervisor, Push all thoughts of being laid off out of your mind, If it came up during a conversation say that you would rather not discuss your chances of being laid off, Try to think which employees in your department the supervisor might evaluate more poorly than you, Continue doing your work as if nothing special was happening, Other (Specify)

#### Alberta Buy-in Questions (pp. 55) - 4 questions

(Age >= 18 and non-proxy only)

1. SPR8-Q1: How would you rate your ability to handle the day-to-day demands in your life, for example, work, family and volunteer responsibilities? (Read list. Mark one only.) - Radio: Excellent, Very Good, Good, Fair, Poor
2. SPR8-Q2: If the day-to-day demands in your life were causing you to feel under stress, which of the following would you do? (Read list. Mark all that apply.) - Checkbox: Try not to think about the situation and keep yourself busy, Try to see the situation in a different light, Think about ways to change the situation or do something to solve the problem, Express your emotions to reduce your tension/anxiety/frustration, Admit to yourself that the situation is stressful but otherwise do nothing, Talk about the situation with others, Do something you enjoy in order to relax, Pray or otherwise seek comfort or strength through religious faith, Do something else (Specify)
3. SPR8-Q3: How would you rate your ability to handle unexpected and difficult problems, for example, family or personal crisis? (Read list. Mark one only.) - Radio: Excellent, Very Good, Good, Fair, Poor
4. SPR8-Q4: If an unexpected problem or situation was causing you to feel under stress, which of the following would you do? (Read list. Mark all that apply.) - Checkbox: (same 9 coping options as SPR8-Q2)

## TOTAL UNIQUE QUESTION NODES: ~280

Breakdown by section:
- Household Record Variables: 17
- Two-Week Disability: 5
- Health Care Utilization: 11 (plus UTIL-Q2 with 10 sub-items, UTIL-Q10 with 6 sub-items)
- Restriction of Activities: 6 (plus RESTR-Q1 with 4 sub-items, RESTR-Q6 with 7 sub-items)
- Chronic Conditions: 4 (CHRON-Q1 with 21+ sub-items)
- Socio-demographic: 7 (SOCIO-Q4 with 19 sub-items, SOCIO-Q5/Q6 with 20 sub-items each, SOCIO-Q7 with 11 sub-items)
- Education: 6
- Labour Force: 18 (Q3-Q11 as roster for up to 6 jobs)
- Income: 3 (INCOM-Q1 with 14 sub-items)
- Administration (H05): 2
- General Health: 3
- Height/Weight: 2
- Preventive Health Practices: 6
- Smoking: 9
- Alcohol: 9 (ALCO-Q5A with 7 sub-items, ALCO-Q7 with 13 sub-items)
- Physical Activities: 7 (PHYS-Q1 with 24+ sub-items)
- Injuries: 8
- Stress - Ongoing Problems: 18
- Stress - Recent Life Events: 10
- Stress - Childhood Traumas: 7
- Work Stress: 2 (WSTRESS-Q1 with 12 sub-items)
- Self-Esteem: 1 (ESTEEM-Q1 with 6 sub-items)
- Mastery: 1 (MAST-Q1 with 7 sub-items)
- Sense of Coherence: 13
- Health Status (Vision/Hearing/Speech/Getting Around/Hands/Feelings/Memory/Thinking/Pain): 31
- Drug Use: 5 (DRUG-Q1 with 22 sub-items)
- Mental Health (K6 + CIDI-SF): 39
- Social Support: 8 (SOCSUP-Q7 with 8 sub-items)
- Health Number: 2
- Agreement to Share: 1
- H06 Administration: 4
- Manitoba Buy-in: 14 (SPR6-Q12 with 9 sub-items, SPR6-Q13 with 9 sub-items)
- Alberta Buy-in: 4 (SPR8-Q2/Q4 with 9 sub-items each)

Note: Check items (UTIL-CINT, UTIL-C9, RESTR-CINT, CHRON-CINT, EDUC-C1, EDUC-C5, LFS-C1, LFS-C2, LFS-C2A, LFS-C12, LFS-C17, LFS-C17A, LFS-C18, PHP-C2, PHYS-C1, GENHLT-C2, MHLTH-C1g, MHLTH-C14, MHLTH-C27, DRUG-C1) are routing/computation items, not respondent-facing questions.
