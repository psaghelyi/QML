# Canadian Community Health Survey (CCHS) Cycle 3.1 - Question Inventory

## Document Overview
- **Title**: Canadian Community Health Survey - Cycle 3.1
- **Organization**: Statistics Canada
- **Date**: 2005
- **Pages**: 296
- **Language**: English
- **Type**: Computer-Assisted Telephone Interview (CATI) questionnaire with optional content modules and sub-samples

## Structure
The questionnaire is organized into modules covering health topics. Modules are either **common content** (asked of all respondents) or **optional content** (collected as part of a subsample). The instrument uses CATI fill variables (^YOU1, ^YOU2, ^FNAME, etc.) for proxy/non-proxy adaptation. Each module has entry/exit routing conditions. Modules are prefixed with 2-3 letter codes (GEN, CCC, HCU, etc.).

## Question Inventory by Section

---

### GENERAL HEALTH (GEN) - 17 questions

1. GEN_Q01 (GENE_01): In general, would you say your health is: - Single choice: 1=Excellent, 2=Very good, 3=Good, 4=Fair, 5=Poor; DK, R
2. GEN_Q02 (GENE_02): In general, would you say your mental health is: - Single choice: 1=Excellent, 2=Very good, 3=Good, 4=Fair, 5=Poor; DK, R
3. GEN_Q03 (GENE_03): Compared to one year ago, how would you say your health in general is now? - Single choice: 1=Much better now, 2=Somewhat better now, 3=About the same, 4=Somewhat worse now, 5=Much worse now; DK, R
4. GEN_Q04 (GENE_04): How satisfied are you with your life in general? - Single choice: 1=Very satisfied, 2=Satisfied, 3=Neither satisfied nor dissatisfied, 4=Dissatisfied, 5=Very dissatisfied; DK, R [age >= 12]
5. GEN_Q05 (GENE_05): Using a scale of 0 to 10, how would you rate your usual level of stress? - Numeric: 0 (No stress) to 10 (Extremely stressful); DK, R [age >= 15, non-proxy]
6. GEN_Q06 (GENE_06): How would you describe your sense of belonging to your local community? - Single choice: 1=Very strong, 2=Somewhat strong, 3=Somewhat weak, 4=Very weak; DK, R [age >= 12]
7. GEN_Q07 (GENE_07): Do you have a regular medical doctor? - Single choice: 1=Yes, 2=No; DK, R
8. GEN_Q08 (GENE_08): What is your best estimate of your height? (select unit) - Numeric with unit: feet/inches or centimetres; DK, R [if not measured height in MHW]
9. GEN_Q09 (GENE_09): What is your best estimate of your weight? (select unit) - Numeric with unit: pounds or kilograms; DK, R [if not measured weight in MHW]
10. GEN_Q10 (GENE_10): How much did you weigh just before the birth of your baby? - Numeric with unit: pounds or kilograms; DK, R [females currently pregnant, MAM_Q037=1]
11. GEN_Q10A (GENE_10A): How much did you weigh just before your last pregnancy? - Numeric with unit: pounds or kilograms; DK, R [females who gave birth in last 5 years]
12. GEN_Q11 (GENE_11): In the past 12 months, did you receive a flu shot? - Single choice: 1=Yes, 2=No; DK, R
13. GEN_Q12: Did you ever have a mammogram? - Single choice: 1=Yes, 2=No; DK, R [females age >= 35]
14. GEN_Q13: When was the last time? (mammogram) - Single choice: 1=Less than 1 year ago, 2=1 year to less than 2 years ago, 3=2 years to less than 5 years ago, 4=5 or more years ago; DK, R
15. GEN_Q14: Was your last mammogram done: - Single choice: 1=As part of a routine screening/regular checkup, 2=Because of a previous breast problem, 3=Because of a new breast problem, 4=Other; DK, R
16. GEN_Q15: Have you ever had a Pap smear test? - Single choice: 1=Yes, 2=No; DK, R [females age >= 18]
17. GEN_Q16: When was the last time? (Pap smear) - Single choice: 1=Less than 6 months ago, 2=6 months to less than 1 year ago, 3=1 year to less than 3 years ago, 4=3 years or more ago; DK, R

---

### CHRONIC CONDITIONS (CCC) - 32 questions

*For each condition: "Do you have [condition] diagnosed by a health professional?"*
*Single choice: 1=Yes, 2=No; DK, R for each*

1. CCC_Q011 (CCCE_011): Food allergies
2. CCC_Q021 (CCCE_021): Other allergies [if CCC_Q011 != 1]
3. CCC_Q031 (CCCE_031): Asthma
4. CCC_Q041 (CCCE_041): Fibromyalgia
5. CCC_Q051 (CCCE_051): Arthritis or rheumatism (excluding fibromyalgia)
6. CCC_Q061 (CCCE_061): Back problems (excluding fibromyalgia and arthritis)
7. CCC_Q071 (CCCE_071): High blood pressure (hypertension)
8. CCC_Q081 (CCCE_081): Migraine headaches
9. CCC_Q091 (CCCE_091): Chronic bronchitis
10. CCC_Q092 (CCCE_092): Emphysema or COPD
11. CCC_Q093 (CCCE_093): Diabetes [age >= 3]
12. CCC_Q094: Was it diagnosed during pregnancy? - Single choice: 1=Yes, 2=No; DK, R [females with diabetes]
13. CCC_Q095 (CCCE_095): Epilepsy
14. CCC_Q101 (CCCE_101): Heart disease
15. CCC_Q105: Have you ever suffered from the effects of a stroke? - Single choice: 1=Yes, 2=No; DK, R
16. CCC_Q111: Do you have cancer? - Single choice: 1=Yes, 2=No; DK, R
17. CCC_Q112: What type of cancer? - Open text (80 spaces); DK, R [if CCC_Q111=1]
18. CCC_Q121 (CCCE_121): Stomach or intestinal ulcers
19. CCC_Q131 (CCCE_131): Urinary incontinence
20. CCC_Q141 (CCCE_141): A bowel disorder such as Crohn's disease or colitis
21. CCC_Q151: Alzheimer's Disease or any other dementia
22. CCC_Q153: Do you suffer from the effects of a stroke? - Single choice: 1=Yes, 2=No; DK, R
23. CCC_Q155 (CCCE_155): Cataracts
24. CCC_Q156 (CCCE_156): Glaucoma
25. CCC_Q161 (CCCE_161): A thyroid condition
26. CCC_Q171 (CCCE_171): Chronic fatigue syndrome
27. CCC_Q181 (CCCE_181): Multiple chemical sensitivities
28. CCC_Q191: Do you have any other long-term health condition? - Single choice: 1=Yes, 2=No; DK, R
29. CCC_Q192: What condition? (specify) - Open text (240 spaces); DK, R
30. CCC_Q201 (CCCE_201): Mood disorder such as depression, bipolar disorder, mania or dysthymia [age >= 12, non-proxy]
31. CCC_Q211 (CCCE_211): Anxiety disorder such as a phobia, OCD or panic disorder [age >= 15, non-proxy]
32. CCC_Q051A: What type of arthritis? - Single choice: 1=Rheumatoid arthritis, 2=Osteoarthritis, 3=Other; DK, R [if CCC_Q051=1 and optional content]

---

### TWO-WEEK DISABILITY (TWD) - 6 questions

1. TWD_Q01 (TWDE_01): Did you stay in bed all or most of the day because of illness or injury in the past 2 weeks? - Single choice: 1=Yes, 2=No; DK, R
2. TWD_Q02 (TWDE_02): How many days? - Numeric: MIN 1, MAX 14; DK, R
3. TWD_Q03 (TWDE_03): Other days cutting down on things in the past 2 weeks? - Single choice: 1=Yes, 2=No; DK, R
4. TWD_Q04 (TWDE_04): How many days cut down? - Numeric: MIN 1, MAX (14 - TWD_Q02); DK, R
5. TWD_Q05 (TWDE_05): Was this because of your emotional or mental health, physical health, or both? - Single choice: 1=Emotional/mental health, 2=Physical health, 3=Both; DK, R [age >= 12]
6. TWD_Q06 (TWDE_06): Besides injury or illness, other days cutting down in the past 2 weeks? - Single choice: 1=Yes, 2=No; DK, R [females age 15-49]

---

### HEALTH CARE UTILIZATION (HCU) - 18 questions

1. HCU_Q01A (HCUE_01A): Have you been a patient overnight in a hospital, nursing home, or convalescent home in the past 12 months? - Single choice: 1=Yes, 2=No; DK, R
2. HCU_Q01BA (HCUE_01BA): How many nights in total? - Numeric: MIN 1, MAX 365; DK, R
3. HCU_Q02 (HCUE_02): In the past 12 months, how many times have you seen or talked on the telephone to a family doctor or general practitioner about your physical, emotional or mental health? - Numeric: 0=none, MIN 1, MAX 365; DK, R
4. HCU_Q03 (HCUE_03): How many times seen/talked to an eye specialist? - Numeric; DK, R
5. HCU_Q04 (HCUE_04): How many times seen/talked to any other medical doctor or specialist? - Numeric; DK, R
6. HCU_Q05 (HCUE_05): How many times seen a dentist or orthodontist? - Numeric; DK, R
7. HCU_Q06 (HCUE_06): How many times seen a chiropractor? - Numeric; DK, R
8. HCU_Q07 (HCUE_07): How many times seen a physiotherapist, speech or occupational therapist? - Numeric; DK, R [renamed from HCU_Q07A and HCU_Q07B]
9. HCU_Q08 (HCUE_08): How many times seen a psychologist? - Numeric; DK, R [age >= 12, non-proxy]
10. HCU_Q09 (HCUE_09): How many times seen a social worker or counsellor? - Numeric; DK, R [age >= 12, non-proxy]
11. HCU_Q10 (HCUE_10): How many times seen a nurse for care or advice? - Numeric; DK, R
12. HCU_Q11: In the past 12 months, have you used any alternative health care provider such as a massage therapist, acupuncturist, homeopath or naturopath? - Single choice: 1=Yes, 2=No; DK, R
13. HCU_Q12: What type? Mark all that apply. - Multiple choice: 1=Massage therapist, 2=Acupuncturist, 3=Homeopath or naturopath, 4=Feldenkrais or Alexander teacher, 5=Relaxation therapist, 6=Biofeedback teacher, 7=Rolfer, 8=Herbalist, 9=Reflexologist, 10=Spiritual healer, 11=Religious healer, 12=Other-Specify; DK, R
14. HCU_Q13: How many times in the past 12 months? - Numeric; DK, R
15. HCU_Q14: Did any health professional recommend this type of alternative care? - Single choice: 1=Yes, 2=No; DK, R
16. HCU_Q15 (HCUE_15): In the past 12 months, have you ever used a telephone health line (to get health information or advice)? - Single choice: 1=Yes, 2=No; DK, R
17. HCU_Q16: Self-help groups for help with mental health? - Single choice: 1=Yes, 2=No; DK, R [age >= 12, non-proxy]
18. HCU_Q17: Was there ever a time in the past 12 months when you felt that you needed mental health care but you didn't receive it? - Single choice: 1=Yes, 2=No; DK, R [age >= 15, non-proxy]

---

### ACTIVITY LIMITATION (RAC) - 11 questions

1. RAC_Q01 (RACE_01): Does a long-term physical condition, mental condition, or health problem reduce the amount or kind of activity you can do at home? - Single choice: 1=Sometimes, 2=Often, 3=Never; DK, R
2. RAC_Q02 (RACE_02): ...at school? - Single choice: 1=Sometimes, 2=Often, 3=Never, 4=Not applicable; DK, R
3. RAC_Q03 (RACE_03): ...at work? - Single choice: 1=Sometimes, 2=Often, 3=Never, 4=Not applicable; DK, R
4. RAC_Q04 (RACE_04): ...in other activities (transportation, leisure)? - Single choice: 1=Sometimes, 2=Often, 3=Never; DK, R
5. RAC_Q05 (RACE_05): Do you need help with preparing meals, getting to appointments, doing household work, or personal care? - Single choice: 1=Yes, 2=No; DK, R [age >= 65]
6. RAC_Q06 (RACE_06): Do you receive help because of a long-term health problem? - Single choice: 1=Yes, 2=No; DK, R [age >= 65]
7. RAC_Q07A (RACE_07A): Need help with heavy household chores? - Single choice: 1=Yes, 2=No; DK, R [age >= 65, needs help]
8. RAC_Q07B (RACE_07B): Need help with light household chores? - Single choice: 1=Yes, 2=No; DK, R
9. RAC_Q07C (RACE_07C): Need help with personal care? - Single choice: 1=Yes, 2=No; DK, R
10. RAC_Q07D (RACE_07D): Need help with moving about inside the house? - Single choice: 1=Yes, 2=No; DK, R
11. RAC_Q07E (RACE_07E): Need help with looking after personal finances? - Single choice: 1=Yes, 2=No; DK, R

---

### SMOKING (SMK) - 27 questions

1. SMK_Q01 (SMKE_01): At the present time, do you smoke cigarettes daily, occasionally or not at all? - Single choice: 1=Daily, 2=Occasionally, 3=Not at all; DK, R [age >= 12]
2. SMK_Q02 (SMKE_02): How many cigarettes do you smoke each day now? - Numeric: MIN 1, MAX 99; DK, R [daily smokers]
3. SMK_Q03 (SMKE_03): On the days that you do smoke, how many cigarettes do you usually smoke? - Numeric: MIN 1, MAX 99; DK, R [occasional smokers]
4. SMK_Q04 (SMKE_04): Have you ever smoked cigarettes daily? - Single choice: 1=Yes, 2=No; DK, R [occasional or non-smokers]
5. SMK_Q05 (SMKE_05): At what age did you begin smoking cigarettes daily? - Numeric: age; DK, R
6. SMK_Q06 (SMKE_06): How many cigarettes did you usually smoke each day? - Numeric: MIN 1, MAX 99; DK, R
7. SMK_Q07 (SMKE_07): When did you stop smoking daily? How long ago was it? - Numeric: years/months/days or age; DK, R
8. SMK_Q08 (SMKE_08): Have you ever smoked cigarettes at all? (100 or more in lifetime) - Single choice: 1=Yes, 2=No; DK, R [never-daily, non-smokers]
9. SMK_Q09 (SMKE_09): Have you ever smoked a whole cigarette? - Single choice: 1=Yes, 2=No; DK, R [age 12-17]
10. SMK_Q10 (SMKE_10): At what age did you smoke your first whole cigarette? - Numeric; DK, R
11. SMK_Q11 (SMKE_11): At what age did you begin smoking cigarettes daily? - Numeric; DK, R [daily smokers]
12. SMK_Q12 (SMKE_12): How many years have you smoked daily? - Numeric; DK, R [daily, lifetime]
13. SMK_Q20: In the past 12 months, have you stopped smoking for at least 24 hours for any reason, including being in hospital? - Single choice: 1=Yes, 2=No; DK, R [current daily/occasional smokers]
14. SMK_Q21: How many times did you stop for at least 24 hours? - Numeric; DK, R
15. SMK_Q22: Was it to try to quit smoking, for health reasons, or for some other reason? - Single choice: 1=To try to quit, 2=For health reasons, 3=Some other reason; DK, R
16. SMK_Q30: In the past 30 days, did anyone smoke inside your home every day or almost every day? - Single choice: 1=Yes, 2=No; DK, R
17. SMK_Q31: How many people smoke inside your home every day or almost every day? - Numeric; DK, R
18. SMK_Q32: In the past month, were you exposed to second-hand smoke every day or almost every day in a car or other private vehicle? - Single choice: 1=Every day, 2=Almost every day, 3=At least once a week, 4=At least once in the past month, 5=Not in the past month; DK, R
19. SMK_Q33: In the past month, were you exposed to second-hand smoke every day or almost every day in public places? - Single choice: same scale as Q32; DK, R
20. SMK_Q40: At the present time, do you smoke cigarettes or use any other tobacco products or nicotine replacement products? - Multiple choice: 1=Cigarettes (daily), 2=Cigarettes (occasionally), 3=Cigars/cigarillos, 4=Pipe, 5=Chewing tobacco, 6=Snuff, 7=Nicotine patch, 8=Nicotine gum, 9=Other-Specify, 10=None; DK, R [age 12-19]
21. SMK_Q41: Have any of your parents, step-parents, or guardians smoked cigarettes in the last month? - Single choice: 1=Yes, 2=No, 3=N/A; DK, R [age 12-19]
22. SMK_Q42: How many of your 5 closest friends smoke cigarettes? - Single choice: 1=None, 2=One, 3=Two, 4=Three, 5=Four or five; DK, R [age 12-19]
23. SMK_Q43: Where do you usually get your cigarettes? - Single choice: 1=Store/gas station, 2=Vending machine, 3=Friends/relatives, 4=Someone buys them, 5=Take them, 6=Other-Specify; DK, R [age 12-17, current smokers]
24. SMK_Q44: In the past 12 months, have you been refused the purchase of cigarettes from a store, gas station, or vending machine? - Single choice: 1=Yes, 2=No, 3=N/A; DK, R [age 12-17]
25. SMK_Q45: Would you like to quit smoking completely? - Single choice: 1=Yes, 2=No; DK, R [current smokers, age 12-19]
26. SMK_Q46: Have you ever tried to quit smoking? - Single choice: 1=Yes, 2=No; DK, R [age 12-19, current smokers]
27. SMK_Q47: Do you seriously think about quitting within the next 30 days, within the next 6 months, or sometime in the future? - Single choice: 1=Next 30 days, 2=Next 6 months, 3=Sometime in the future, 4=Not at all; DK, R [age 12-19]

---

### ALCOHOL USE (ALC) - 10 questions

1. ALC_Q01 (ALCE_01): During the past 12 months, have you had a drink of beer, wine, liquor or any other alcoholic beverage? - Single choice: 1=Yes, 2=No; DK, R [age >= 12]
2. ALC_Q02 (ALCE_02): During the past 12 months, how often did you drink alcoholic beverages? - Single choice: 1=Less than once a month, 2=Once a month, 3=2-3 times a month, 4=Once a week, 5=2-3 times a week, 6=4-6 times a week, 7=Every day; DK, R
3. ALC_Q03 (ALCE_03): How often in the past 12 months have you had 5 or more drinks on one occasion? - Single choice: 1=Never, 2=Less than once a month, 3=Once a month, 4=2-3 times a month, 5=Once a week, 6=More than once a week; DK, R [males]
4. ALC_Q03 (ALCE_03): How often in the past 12 months have you had 4 or more drinks on one occasion? - Same scale [females]
5. ALC_Q04: Have you ever had a drink? - Single choice: 1=Yes, 2=No; DK, R [non-drinkers past 12 months]
6. ALC_Q05 (ALCE_05): During the past week, did you have a drink of beer, wine, liquor or any other alcoholic beverage? - Single choice: 1=Yes, 2=No; DK, R [past 12 month drinkers]
7. ALC_Q06 (ALCE_06): Starting with yesterday, how many drinks did you have? (Sunday) - Numeric: MIN 0, MAX 99; DK, R [7 days recalled]
8. ALC_Q06 (ALCE_06) repeated: Monday through Saturday - Numeric each day
9. ALC_Q07 (ALCE_07): Was last week typical of the amount of alcohol you drink? - Single choice: 1=Yes, 2=No, 3=Does not drink regularly; DK, R
10. ALC_Q08: Thinking back over the past week, how many drinks in total did you have? - Numeric: MIN 1, MAX 99; DK, R [if ALC_Q07=2, not typical]

---

### PHYSICAL ACTIVITIES (PAC) - 22 questions

1. PAC_Q01: In the past 3 months, did you participate in walking for exercise? - Single choice: 1=Yes, 2=No; DK, R [age >= 12]
2. PAC_Q02: How many times in the past 3 months? (walking) - Numeric; DK, R
3. PAC_Q03: How long on average? (walking) - Numeric: minutes; DK, R
4. PAC_Q04-Q06: Gardening/yard work - same pattern (yes/no, times, duration)
5. PAC_Q07-Q09: Swimming - same pattern
6. PAC_Q10-Q12: Bicycling - same pattern
7. PAC_Q13-Q15: Popular or social dance - same pattern
8. PAC_Q16-Q18: Home exercises - same pattern
9. PAC_Q19-Q21: Ice hockey - same pattern
10. PAC_Q22-Q24: Skating - same pattern
11. PAC_Q25-Q27: Downhill skiing or snowboarding - same pattern
12. PAC_Q28-Q30: Cross-country skiing - same pattern
13. PAC_Q31-Q33: Jogging or running - same pattern
14. PAC_Q34-Q36: Golfing - same pattern
15. PAC_Q37-Q39: Exercise class or aerobics - same pattern
16. PAC_Q40-Q42: Bowling - same pattern
17. PAC_Q43-Q45: Baseball or softball - same pattern
18. PAC_Q46-Q48: Tennis - same pattern
19. PAC_Q49-Q51: Weight training - same pattern
20. PAC_Q52-Q54: Fishing - same pattern
21. PAC_Q55-Q57: Volleyball - same pattern
22. PAC_Q58-Q62: Other activities (up to 3 specify with times and duration)

*Additional physical activity questions:*
23. PAC_Q63 (PACE_63): Hours per day spent walking (transportation) - Single choice: 1=None, 2=Less than 1 hour, 3=1-2 hours, 4=2-3 hours, 5=3-4 hours, 6=4-5 hours, 7=5-6 hours, 8=6 or more hours; DK, R
24. PAC_Q64 (PACE_64): Hours per day spent bicycling (transportation) - Same scale; DK, R
25. PAC_Q65 (PACE_65): Hours per day sitting (in a typical day) - Same scale; DK, R

---

### FRUIT AND VEGETABLE CONSUMPTION (FVC) - 8 questions

1. FVC_Q01 (FVCE_01): How many times per day/week do you usually drink fruit juice? - Numeric with frequency unit; DK, R [age >= 12]
2. FVC_Q02 (FVCE_02): Not counting juice, how many times do you eat fruit? - Numeric with frequency; DK, R
3. FVC_Q03 (FVCE_03): How many times do you eat green salad? - Numeric with frequency; DK, R
4. FVC_Q04 (FVCE_04): How many times do you eat potatoes? (not french fries, fried potatoes, or potato chips) - Numeric with frequency; DK, R
5. FVC_Q05 (FVCE_05): How many times do you eat carrots? - Numeric with frequency; DK, R
6. FVC_Q06 (FVCE_06): Not counting carrots, potatoes, or salad, how many times do you eat other vegetables? - Numeric with frequency; DK, R
7. FVC_N01: Enter unit of time - Single choice: 1=Per day, 2=Per week, 3=Per month, 4=Per year; (DK, R not allowed) [for each Q01-Q06]
8. FVC_Q07: Total daily consumption (computed/verified)

---

### BREASTFEEDING (BFE) - 8 questions

*[Females age 15-55 who have given birth in the last 5 years]*

1. BFE_Q01 (BFEE_01): Did you breastfeed or try to breastfeed your last child? - Single choice: 1=Yes, 2=No; DK, R
2. BFE_Q02 (BFEE_02): For how long? - Numeric: months/weeks; DK, R
3. BFE_Q03 (BFEE_03): How old was the baby when you first introduced any food or liquids other than breast milk? - Numeric: months/weeks; DK, R
4. BFE_Q04 (BFEE_04): How old was the baby when you first introduced liquids other than breast milk? - Numeric: months/weeks; DK, R
5. BFE_Q05 (BFEE_05): How old was the baby when you completely stopped breastfeeding? - Numeric: months/weeks; DK, R
6. BFE_Q06: Are you currently breastfeeding? - Single choice: 1=Yes, 2=No; DK, R
7. BFE_Q07: Why did you stop breastfeeding? - Multiple choice: 1=Not enough milk, 2=Baby not satisfied, 3=Nipple problems, 4=Baby ill, 5=Mother ill, 6=Mother too tired, 7=Returned to work/school, 8=Inconvenient, 9=Baby old enough, 10=Weaned self, 11=Other-Specify; DK, R
8. BFE_Q08: What was the main reason? - Same options as Q07; DK, R

---

### MATERNAL EXPERIENCES (MAM) - 8 questions

*[Females age 15-55]*

1. MAM_Q01: How many times have you been pregnant (including current)? - Numeric: MIN 0, MAX 25; DK, R
2. MAM_Q02: How many live births have you had? - Numeric: MIN 0, MAX 25; DK, R
3. MAM_Q03: In what month and year was your last child born? - Month/Year; DK, R
4. MAM_Q04: What was the birth weight of your last child? - Numeric: kg or lbs/oz; DK, R
5. MAM_Q05: Was it a single or multiple birth? - Single choice: 1=Single, 2=Multiple; DK, R
6. MAM_Q035: Did you receive prenatal care during your last pregnancy? - Single choice: 1=Yes, 2=No; DK, R
7. MAM_Q036: At what stage of pregnancy did you first see a doctor or midwife? - Single choice: 1=First 3 months, 2=4-6 months, 3=7-9 months, 4=After delivery; DK, R
8. MAM_Q037: Are you currently pregnant? - Single choice: 1=Yes, 2=No; DK, R

---

### DRUG USE (DRG) - 7 questions

*[Age >= 15, non-proxy]*

1. DRG_Q01 (DRGE_01): During the past 12 months, have you used marijuana or hash? - Single choice: 1=Yes, 2=No; DK, R
2. DRG_Q02: How many times in the past 12 months? - Single choice: 1=Once, 2=2-3 times, 3=4 or more times; DK, R
3. DRG_Q03: Have you ever in your life used marijuana or hash? - Single choice: 1=Yes, 2=No; DK, R [if DRG_Q01=2]
4. DRG_Q04: During the past 12 months, have you used any drugs listed on the card (cocaine, speed, ecstasy, hallucinogens, heroin, glue/solvents)? - Single choice: 1=Yes, 2=No; DK, R
5. DRG_Q05: Which ones? Mark all that apply. - Multiple choice: 1=Cocaine/crack, 2=Speed (amphetamines), 3=Ecstasy (MDMA), 4=Hallucinogens/LSD/PCP, 5=Heroin, 6=Glue/solvents/gasoline; DK, R
6. DRG_Q06: Have you ever in your life used any of these drugs? - Single choice: 1=Yes, 2=No; DK, R [if DRG_Q04=2]
7. DRG_Q07: Which ones? (ever used) - Same multiple choice as Q05; DK, R

---

### MEDICATION USE (MED) - 4 questions

1. MED_Q01 (MEDE_01): In the past month, did you take any pain relievers such as aspirin or Tylenol? - Single choice: 1=Yes, 2=No; DK, R
2. MED_Q02 (MEDE_02): In the past month, did you take tranquillizers such as Valium or Ativan? - Single choice: 1=Yes, 2=No; DK, R
3. MED_Q03 (MEDE_03): In the past month, did you take diet pills? - Single choice: 1=Yes, 2=No; DK, R
4. MED_Q04 (MEDE_04): In the past month, did you take antidepressants? - Single choice: 1=Yes, 2=No; DK, R
5. MED_Q05 (MEDE_05): In the past month, did you take codeine, Demerol or morphine? - Single choice: 1=Yes, 2=No; DK, R
6. MED_Q06 (MEDE_06): In the past month, did you take sleeping pills? - Single choice: 1=Yes, 2=No; DK, R [age >= 15, non-proxy]

---

### PATIENT SATISFACTION (PSA) - 7 questions

*[Optional content, subsample, age >= 15, non-proxy]*

1. PSA_Q01 (PSAE_01): Overall, how would you rate the health care you have received in the past 12 months? - Single choice: 1=Excellent, 2=Good, 3=Fair, 4=Poor; DK, R
2. PSA_Q02 (PSAE_02): Overall, how would you rate the quality of health care services available in your community? - Single choice: 1=Excellent, 2=Good, 3=Fair, 4=Poor; DK, R
3. PSA_Q03 (PSAE_03): How would you rate the way health care services were provided: the courtesy, respect and sensitivity to your needs? - Single choice: 1=Excellent, 2=Good, 3=Fair, 4=Poor; DK, R
4. PSA_Q04 (PSAE_04): How would you rate the way information was provided about what was wrong? - Single choice: same scale; DK, R
5. PSA_Q05 (PSAE_05): How would you rate the way you were involved in decisions about your care? - Single choice: same scale; DK, R
6. PSA_Q06 (PSAE_06): Thinking about the most recent time, how long did you wait before you received care? - Numeric with unit (MIN 0; days/hours/minutes); DK, R
7. PSA_Q07 (PSAE_07): Did you think the waiting time was: - Single choice: 1=Reasonable, 2=A little long, 3=Much too long; DK, R

---

### DEPRESSION (DEP) - 22 questions

*[Optional content, subsample, age >= 12, non-proxy; based on CIDI-SF]*

1. DEP_Q01 (DEPE_01): During the past 12 months, was there a time when you felt sad, blue, or depressed for 2 weeks or more in a row? - Single choice: 1=Yes, 2=No; DK, R
2. DEP_Q02 (DEPE_02): During the past 12 months, was there a time lasting 2 weeks or more when you lost interest in most things? - Single choice: 1=Yes, 2=No; DK, R
3. DEP_Q03 (DEPE_03): Was this period in the past 12 months or longer? - Single choice: 1=Past 12 months, 2=Longer; DK, R
4. DEP_Q04 (DEPE_04): How long in weeks did the longest period last? - Numeric: weeks; DK, R
5. DEP_Q05 (DEPE_05): Felt tired or low on energy? - Single choice: 1=Yes, 2=No; DK, R
6. DEP_Q06 (DEPE_06): Gained or lost weight? - Single choice: 1=Yes, 2=No; DK, R
7. DEP_Q07 (DEPE_07): Trouble falling asleep or sleeping too much? - Single choice: 1=Yes, 2=No; DK, R
8. DEP_Q08 (DEPE_08): Trouble concentrating? - Single choice: 1=Yes, 2=No; DK, R
9. DEP_Q09 (DEPE_09): Felt down on yourself, no good, or worthless? - Single choice: 1=Yes, 2=No; DK, R
10. DEP_Q10 (DEPE_10): Thought a lot about death? - Single choice: 1=Yes, 2=No; DK, R
11. DEP_Q11 (DEPE_11): How often did you feel this way during those 2 weeks? - Single choice: 1=Every day, 2=Almost every day, 3=About half the days, 4=Less than half the days; DK, R
12. DEP_Q12 (DEPE_12): In the worst 2 weeks, how much of the day did these feelings last? - Single choice: 1=All day long, 2=Most of the day, 3=About half, 4=Less than half; DK, R
13. DEP_Q13 (DEPE_13): Did you feel so sad that nothing could cheer you up? - Single choice: 1=So sad nothing could cheer up, 2=Could be cheered up, 3=In between; DK, R
14. DEP_Q14 (DEPE_14): During that period, did you lose the ability to enjoy having good things happen? - Single choice: 1=Yes, 2=No; DK, R
15. DEP_Q15 (DEPE_15): Did these feelings interfere with your life or activities a lot? - Single choice: 1=A lot, 2=Some, 3=A little, 4=Not at all; DK, R
16. DEP_Q16 (DEPE_16): How many weeks in the past 12 months did you feel this way? - Numeric: weeks; DK, R
17. DEP_Q17 (DEPE_17): Did you talk to a medical doctor about these feelings? - Single choice: 1=Yes, 2=No; DK, R
18. DEP_Q18 (DEPE_18): Did you talk to any other professional? - Single choice: 1=Yes, 2=No; DK, R
19. DEP_Q19: Who? Mark all that apply. - Multiple choice: 1=Psychologist, 2=Psychiatrist, 3=Social worker, 4=Counsellor, 5=Other-Specify; DK, R
20. DEP_Q20: Did you ever take medication for these feelings? - Single choice: 1=Yes, 2=No; DK, R
21. DEP_Q21: In the past 12 months, how many weeks did you take such medication? - Numeric: weeks; DK, R
22. DEP_Q22: At the time of these feelings, did you think that your emotional or mental health was interfering with your life or activities? - Single choice: 1=Yes, 2=No; DK, R

---

### MASTERY AND COPING (MST) - 7 questions

*[Optional content, age >= 18, non-proxy]*

1. MST_Q01 (MSTE_01): You have little control over the things that happen to you. - Single choice: 1=Strongly agree, 2=Agree, 3=Neither agree nor disagree, 4=Disagree, 5=Strongly disagree; DK, R
2. MST_Q02 (MSTE_02): There is really no way you can solve some of the problems you have. - Same scale; DK, R
3. MST_Q03 (MSTE_03): There is little you can do to change many of the important things in your life. - Same scale; DK, R
4. MST_Q04 (MSTE_04): You often feel helpless in dealing with the problems of life. - Same scale; DK, R
5. MST_Q05 (MSTE_05): Sometimes you feel that you are being pushed around in life. - Same scale; DK, R
6. MST_Q06 (MSTE_06): What happens to you in the future mostly depends on you. - Same scale; DK, R
7. MST_Q07 (MSTE_07): You can do just about anything you really set your mind to. - Same scale; DK, R

---

### SELF-ESTEEM (SFE) - 6 questions

*[Optional content, age >= 18, non-proxy]*

1. SFE_Q01 (SFEE_01): You feel that you have a number of good qualities. - Single choice: 1=Strongly agree, 2=Agree, 3=Disagree, 4=Strongly disagree; DK, R
2. SFE_Q02 (SFEE_02): In general, you are inclined to feel that you are a failure. - Same scale; DK, R
3. SFE_Q03 (SFEE_03): You are able to do things as well as most other people. - Same scale; DK, R
4. SFE_Q04 (SFEE_04): You do not have much to be proud of. - Same scale; DK, R
5. SFE_Q05 (SFEE_05): You take a positive attitude toward yourself. - Same scale; DK, R
6. SFE_Q06 (SFEE_06): On the whole, you are satisfied with yourself. - Same scale; DK, R

---

### SOCIAL SUPPORT (SSA) - 6 questions

*[Optional content, age >= 12, non-proxy]*

1. SSA_Q01 (SSAE_01): Do you have someone you can confide in or talk to about your private feelings or concerns? - Single choice: 1=Yes, 2=No; DK, R
2. SSA_Q02 (SSAE_02): Do you have someone you can really count on to help you out in a crisis situation? - Single choice: 1=Yes, 2=No; DK, R
3. SSA_Q03 (SSAE_03): Do you have someone you can really count on to give you advice when you are making important personal decisions? - Single choice: 1=Yes, 2=No; DK, R
4. SSA_Q04 (SSAE_04): Do you have someone who makes you feel loved and cared for? - Single choice: 1=Yes, 2=No; DK, R
5. SSA_Q05: How many close friends and close relatives do you have? - Numeric: MIN 0, MAX 95; DK, R
6. SSA_Q06: In a typical month, how often do you participate in voluntary organizations or associations? - Single choice: 1=At least once a week, 2=At least once a month, 3=At least 3-4 times a year, 4=At least once a year, 5=Not at all; DK, R

---

### INJURIES (INJ) - 17 questions

1. INJ_Q01 (INJE_01): In the past 12 months, did you have any injuries that were serious enough to limit your normal activities? - Single choice: 1=Yes, 2=No; DK, R
2. INJ_Q02 (INJE_02): How many times were you injured in the past 12 months? - Numeric: MIN 1, MAX 30 (warning after 6); DK, R
3. INJ_Q03: Thinking about the most serious injury, what part of the body was injured? - Multiple choice: 1=Head, 2=Eyes, 3=Neck, 4=Shoulder/upper arm, 5=Elbow/lower arm/wrist, 6=Hand/fingers, 7=Upper back/spine, 8=Lower back/spine, 9=Rib cage/chest, 10=Abdomen/pelvis, 11=Hip, 12=Upper leg, 13=Knee, 14=Lower leg, 15=Ankle, 16=Foot/toes, 17=Multiple sites, 18=Other-Specify; DK, R
4. INJ_Q04: What type of injury was it? - Single choice: 1=Broken/fractured bones, 2=Burn/scald, 3=Dislocation, 4=Sprain/strain, 5=Cut/scrape/bruise/blister, 6=Concussion/internal injuries, 7=Poisoning, 8=Multiple injuries, 9=Other-Specify; DK, R
5. INJ_Q05: How did the injury happen? - Multiple choice: 1=Motor vehicle, 2=Bicycle, 3=Pedestrian, 4=ATV/snowmobile, 5=Other-Specify; DK, R [if transportation accident]
6. INJ_Q06: Were you working for pay or on a farm at the time? - Single choice: 1=Yes, 2=No; DK, R
7. INJ_Q07: Were you doing unpaid work, sports, or other activities? - Single choice: various categories; DK, R
8. INJ_Q08 (INJE_08): Where did the injury happen? - Single choice: 1=Home, 2=Residential institution, 3=School/college, 4=Sports area of school, 5=Other sports area, 6=Other institution, 7=Street/highway, 8=Commercial area, 9=Industrial area, 10=Farm, 11=Countryside, 12=Other-Specify; DK, R
9. INJ_Q09 (INJE_09): What type of activity were you doing when injured? - Single choice: 1=Sports/physical exercise, 2=Leisure/hobby, 3=Working at job/business, 4=Travel, 5=Household chores, 6=Sleeping/eating/personal care, 7=Other-Specify; DK, R
10. INJ_Q10 (INJE_10): Was the injury the result of a fall? - Single choice: 1=Yes, 2=No; DK, R
11. INJ_Q11 (INJE_11): How did you fall? - Single choice: 1=Skating/skiing/snowboarding, 2=Going up/down stairs, 3=Slip/trip on ice/snow, 4=Slip/trip on other surface, 5=From furniture, 6=From elevated position, 7=Other-Specify; DK, R
12. INJ_Q12 (INJE_12): What caused the injury? - Single choice: 1=Transportation accident, 2=Accidentally bumped/pushed, 3=Accidentally struck by object, 4=Contact with sharp object/tool, 5=Smoke/fire/flames, 6=Contact with hot object/liquid/gas, 7=Extreme weather, 8=Overexertion, 9=Physical assault, 10=Other-Specify; DK, R
13. INJ_Q13 (INJE_13): Did you receive any medical attention within 48 hours? - Single choice: 1=Yes, 2=No; DK, R
14. INJ_Q14 (INJE_14): Where did you receive treatment? - Multiple choice: 1=Doctor's office, 2=Hospital emergency, 3=Outpatient clinic, 4=Walk-in clinic, 5=Appointment clinic, 6=Community health centre, 7=At work, 8=At school, 9=At home, 10=Telephone consultation, 11=Other-Specify; DK, R
15. INJ_Q15 (INJE_15): Were you admitted to a hospital overnight? - Single choice: 1=Yes, 2=No; DK, R
16. INJ_Q16 (INJE_16): Did you have any other injuries in the past 12 months treated by a health professional but did not limit normal activities? - Single choice: 1=Yes, 2=No; DK, R
17. INJ_Q17 (INJE_17): How many injuries? - Numeric: MIN 1, MAX 30 (warning after 6); DK, R

---

### HEALTH UTILITY INDEX (HUI) - 30 questions

*[Optional content, subsample]*

**Vision (5 questions)**
1. HUI_Q01 (HUIE_01): Usually able to see well enough to read ordinary newsprint without glasses or contact lenses? - Single choice: 1=Yes, 2=No; DK, R
2. HUI_Q02 (HUIE_02): Usually able to see well enough to read with glasses or contact lenses? - Single choice: 1=Yes, 2=No; DK, R
3. HUI_Q03 (HUIE_03): Able to see at all? - Single choice: 1=Yes, 2=No; DK, R
4. HUI_Q04 (HUIE_04): Able to see well enough to recognize a friend on the other side of the street without glasses? - Single choice: 1=Yes, 2=No; DK, R
5. HUI_Q05 (HUIE_05): Usually able to see well enough to recognize a friend with glasses or contact lenses? - Single choice: 1=Yes, 2=No; DK, R

**Hearing (5 questions)**
6. HUI_Q06 (HUIE_06): Usually able to hear what is said in a group conversation with at least 3 people without a hearing aid? - Single choice: 1=Yes, 2=No; DK, R
7. HUI_Q07 (HUIE_07): Usually able to hear what is said in a group conversation with a hearing aid? - Single choice: 1=Yes, 2=No; DK, R
8. HUI_Q07A (HUIE_07A): Able to hear at all? - Single choice: 1=Yes, 2=No; DK, R
9. HUI_Q08 (HUIE_08): Usually able to hear what is said in a conversation with one other person in a quiet room without a hearing aid? - Single choice: 1=Yes, 2=No; DK, R
10. HUI_Q09 (HUIE_09): Usually able to hear what is said in a conversation with one other person with a hearing aid? - Single choice: 1=Yes, 2=No; DK, R

**Speech (4 questions)**
11. HUI_Q10 (HUIE_10): Usually able to be understood completely when speaking with strangers in own language? - Single choice: 1=Yes, 2=No; DK, R
12. HUI_Q11 (HUIE_11): Able to be understood partially when speaking with strangers? - Single choice: 1=Yes, 2=No; DK, R
13. HUI_Q12 (HUIE_12): Able to be understood completely when speaking with those who know you well? - Single choice: 1=Yes, 2=No; DK, R
14. HUI_Q13 (HUIE_13): Able to be understood partially when speaking with those who know you well? - Single choice: 1=Yes, 2=No; DK, R

**Getting Around (8 questions)**
15. HUI_Q14 (HUIE_14): Usually able to walk around the neighbourhood without difficulty and without mechanical support? - Single choice: 1=Yes, 2=No; DK, R
16. HUI_Q15 (HUIE_15): Able to walk at all? - Single choice: 1=Yes, 2=No; DK, R
17. HUI_Q16 (HUIE_16): Require mechanical support (braces, cane, crutches) to walk around neighbourhood? - Single choice: 1=Yes, 2=No; DK, R
18. HUI_Q17 (HUIE_17): Require the help of another person to walk? - Single choice: 1=Yes, 2=No; DK, R
19. HUI_Q18 (HUIE_18): Require a wheelchair to get around? - Single choice: 1=Yes, 2=No; DK, R
20. HUI_Q19 (HUIE_19): How often use a wheelchair? - Single choice: 1=Always, 2=Often, 3=Sometimes, 4=Never; DK, R
21. HUI_Q20 (HUIE_20): Need the help of another person to get around in the wheelchair? - Single choice: 1=Yes, 2=No; DK, R

**Hands and Fingers (4 questions)**
22. HUI_Q21 (HUIE_21): Usually able to grasp and handle small objects such as a pencil or scissors? - Single choice: 1=Yes, 2=No; DK, R
23. HUI_Q22 (HUIE_22): Require the help of another person because of limitations in the use of hands or fingers? - Single choice: 1=Yes, 2=No; DK, R
24. HUI_Q23 (HUIE_23): Require the help of another person with: some tasks, most tasks, almost all tasks, or all tasks? - Single choice: 1=Some, 2=Most, 3=Almost all, 4=All; DK, R
25. HUI_Q24 (HUIE_24): Require special equipment or devices to assist in dressing? - Single choice: 1=Yes, 2=No; DK, R

**Feelings (1 question)**
26. HUI_Q25 (HUIE_25): Would you describe yourself as being usually: - Single choice: 1=Happy and interested in life, 2=Somewhat happy, 3=Somewhat unhappy, 4=Unhappy with little interest in life, 5=So unhappy that life is not worthwhile; DK, R

**Memory (1 question)**
27. HUI_Q26 (HUIE_26): How would you describe your usual ability to remember things? - Single choice: 1=Able to remember most things, 2=Somewhat forgetful, 3=Very forgetful, 4=Unable to remember anything at all; DK, R

**Thinking (1 question)**
28. HUI_Q27 (HUIE_27): How would you describe your usual ability to think and solve problems? - Single choice: 1=Able to think clearly and solve problems, 2=Having a little difficulty, 3=Having some difficulty, 4=Having a great deal of difficulty, 5=Unable to think or solve problems; DK, R

**Pain and Discomfort (3 questions)**
29. HUI_Q28 (HUIE_28): Usually free of pain or discomfort? - Single choice: 1=Yes, 2=No; DK, R
30. HUI_Q29 (HUIE_29): How would you describe the usual intensity of pain or discomfort? - Single choice: 1=Mild, 2=Moderate, 3=Severe; DK, R
31. HUI_Q30 (HUIE_30): How many activities does pain or discomfort prevent? - Single choice: 1=None, 2=A few, 3=Some, 4=Most; DK, R

---

### HEALTH STATUS - SF-36 (SFR) - 34 questions

*[Optional content, subsample]*

**Physical Functioning (10 questions)**
1. SFR_Q03 (SFRE_03): Does health limit vigorous activities (running, lifting heavy objects, strenuous sports)? - Single choice: 1=Limited a lot, 2=Limited a little, 3=Not at all limited; DK, R
2. SFR_Q04 (SFRE_04): ...moderate activities (moving a table, pushing a vacuum cleaner, bowling, golf)? - Same scale; DK, R
3. SFR_Q05 (SFRE_05): ...lifting or carrying groceries? - Same scale; DK, R
4. SFR_Q06 (SFRE_06): ...climbing several flights of stairs? - Same scale; DK, R
5. SFR_Q07 (SFRE_07): ...climbing one flight of stairs? - Same scale; DK, R
6. SFR_Q08 (SFRE_08): ...bending, kneeling, or stooping? - Same scale; DK, R
7. SFR_Q09 (SFRE_09): ...walking more than one kilometre? - Same scale; DK, R
8. SFR_Q10 (SFRE_10): ...walking several blocks? - Same scale; DK, R
9. SFR_Q11 (SFRE_11): ...walking one block? - Same scale; DK, R
10. SFR_Q12 (SFRE_12): ...bathing or dressing yourself? - Same scale; DK, R

**Role - Physical (4 questions)**
11. SFR_Q13 (SFRE_13): Because of physical health, during the past 4 weeks, cut down on time spent on work or other activities? - Single choice: 1=Yes, 2=No; DK, R
12. SFR_Q14 (SFRE_14): ...accomplish less than you would like? - Single choice: 1=Yes, 2=No; DK, R
13. SFR_Q15 (SFRE_15): ...limited in kind of work or other activities? - Single choice: 1=Yes, 2=No; DK, R
14. SFR_Q16 (SFRE_16): ...had difficulty performing work or other activities? - Single choice: 1=Yes, 2=No; DK, R

**Role - Emotional (3 questions)**
15. SFR_Q17 (SFRE_17): Because of emotional problems, cut down on time spent on work or activities in the past 4 weeks? - Single choice: 1=Yes, 2=No; DK, R
16. SFR_Q18 (SFRE_18): ...accomplish less than would like? - Single choice: 1=Yes, 2=No; DK, R
17. SFR_Q19 (SFRE_19): ...not do work or other activities as carefully as usual? - Single choice: 1=Yes, 2=No; DK, R

**Social Functioning (1 question)**
18. SFR_Q20 (SFRE_20): How much has physical health or emotional problems interfered with social activities in the past 4 weeks? - Single choice: 1=Not at all, 2=A little bit, 3=Moderately, 4=Quite a bit, 5=Extremely; DK, R

**Bodily Pain (2 questions)**
19. SFR_Q21 (SFRE_21): During the past 4 weeks, how much bodily pain have you had? - Single choice: 1=None, 2=Very mild, 3=Mild, 4=Moderate, 5=Severe, 6=Very severe; DK, R
20. SFR_Q22 (SFRE_22): How much did pain interfere with normal work? - Single choice: 1=Not at all, 2=A little bit, 3=Moderately, 4=Quite a bit, 5=Extremely; DK, R

**Vitality (4 questions)**
21. SFR_Q23 (SFRE_23): During the past 4 weeks, how much of the time did you feel full of pep? - Single choice: 1=All of the time, 2=Most of the time, 3=A good bit, 4=Some of the time, 5=A little of the time, 6=None of the time; DK, R
22. SFR_Q27 (SFRE_27): ...did you have a lot of energy? - Same scale; DK, R
23. SFR_Q29 (SFRE_29): ...did you feel worn out? - Same scale; DK, R
24. SFR_Q31 (SFRE_31): ...did you feel tired? - Same scale; DK, R

**Mental Health (5 questions)**
25. SFR_Q24 (SFRE_24): ...have you been a very nervous person? - Same scale; DK, R
26. SFR_Q25 (SFRE_25): ...felt so down in the dumps that nothing could cheer you up? - Same scale; DK, R
27. SFR_Q26 (SFRE_26): ...have you felt calm and peaceful? - Same scale; DK, R
28. SFR_Q28 (SFRE_28): ...have you felt downhearted and blue? - Same scale; DK, R
29. SFR_Q30 (SFRE_30): ...have you been a happy person? - Same scale; DK, R

**Social Functioning (1 question)**
30. SFR_Q32 (SFRE_32): How much of the time has health limited social activities? - Same scale; DK, R

**General Health (4 questions)**
31. SFR_Q33 (SFRE_33): I seem to get sick a little easier than other people. - Single choice: 1=Definitely true, 2=Mostly true, 3=Not sure, 4=Mostly false, 5=Definitely false; DK, R
32. SFR_Q34 (SFRE_34): I am as healthy as anybody I know. - Same scale; DK, R
33. SFR_Q35 (SFRE_35): I expect my health to get worse. - Same scale; DK, R
34. SFR_Q36 (SFRE_36): My health is excellent. - Same scale; DK, R

---

### SEXUAL BEHAVIOURS (SXB) - 13 questions

*[Age 15-49, non-proxy]*

1. SXB_Q01 (SXBE_1): Have you ever had sexual intercourse? - Single choice: 1=Yes, 2=No; DK, R
2. SXB_Q02 (SXBE_2): How old were you the first time? - Numeric: age (MIN 1, MAX current age); DK, R
3. SXB_Q03 (SXBE_3): In the past 12 months, have you had sexual intercourse? - Single choice: 1=Yes, 2=No; DK, R
4. SXB_Q04 (SXBE_4): With how many different partners? - Single choice: 1=1, 2=2, 3=3, 4=4 or more; DK, R
5. SXB_Q05: The last time, did you use a condom? - Single choice: 1=Yes, 2=No; DK, R [if multiple partners or unmarried]
6. SXB_Q06: In the past 12 months, how often did you use a condom? - Single choice: 1=Always, 2=Most of the time, 3=About half the time, 4=Rarely, 5=Never; DK, R
7. SXB_Q07 (SXBE_07): Have you ever been diagnosed with a sexually transmitted disease? - Single choice: 1=Yes, 2=No; DK, R
8. SXB_Q08 (SXBE_7A): Did you use a condom the last time you had sexual intercourse? - Single choice: 1=Yes, 2=No; DK, R
9. SXB_Q09 (SXBE_09): It is important to me to avoid getting pregnant right now. (females) - Single choice: 1=Strongly agree, 2=Agree, 3=Neither agree nor disagree, 4=Disagree, 5=Strongly disagree; DK, R
10. SXB_Q10 (SXBE_10): It is important to me to avoid getting my partner pregnant right now. (males) - Single choice: same as Q09 plus 6=Doesn't have a partner; DK, R
11. SXB_Q11 (SXBE_11): In the past 12 months, did you and your partner usually use birth control? - Single choice: 1=Yes, 2=No; DK, R
12. SXB_Q12: What kind of birth control usually used? Mark all that apply. - Multiple choice: 1=Condom, 2=Birth control pill, 3=Diaphragm, 4=Spermicide, 5=Birth control injection (Deprovera), 6=Other-Specify; DK, R
13. SXB_Q13: What kind of birth control used last time? Mark all that apply. - Multiple choice: 1=Condom, 2=Birth control pill, 3=Diaphragm, 4=Spermicide, 5=Birth control injection, 6=Nothing, 7=Other-Specify; DK, R

---

### ACCESS TO HEALTH CARE SERVICES (ACC) - 38 questions

*[Optional content, subsample, age >= 15, non-proxy]*

**Specialist Care (5 questions)**
1. ACC_Q10 (ACCE_10): In the past 12 months, did you require a visit to a medical specialist for a diagnosis or consultation? - Single choice: 1=Yes, 2=No; DK, R
2. ACC_Q11 (ACCE_11): Did you ever experience any difficulties getting the specialist care you needed? - Single choice: 1=Yes, 2=No; DK, R
3. ACC_Q12: What type of difficulties? Mark all that apply. - Multiple choice: 1=Difficulty getting referral, 2=Difficulty getting appointment, 3=No specialists in area, 4=Waited too long (booking to visit), 5=Waited too long (in-office), 6=Transportation, 7=Language, 8=Cost, 9=Personal/family responsibilities, 10=General deterioration of health, 11=Appointment cancelled/deferred, 12=Still waiting, 13=Unable to leave house, 14=Other-Specify; DK, R

**Non-Emergency Surgery (4 questions)**
4. ACC_Q20 (ACCE_20): In the past 12 months, did you require any non-emergency surgery? - Single choice: 1=Yes, 2=No; DK, R
5. ACC_Q21 (ACCE_21): Did you experience any difficulties getting the surgery you needed? - Single choice: 1=Yes, 2=No; DK, R
6. ACC_Q22: What type of difficulties? Mark all that apply. - Multiple choice: 15 options (similar to Q12 with surgery-specific items); DK, R

**Diagnostic Tests (MRI, CT, angiography) (4 questions)**
7. ACC_Q30 (ACCE_30): In the past 12 months, did you require one of these tests? - Single choice: 1=Yes, 2=No; DK, R
8. ACC_Q31 (ACCE_31): Did you experience any difficulties getting the tests you needed? - Single choice: 1=Yes, 2=No; DK, R
9. ACC_Q32: What type of difficulties? Mark all that apply. - Multiple choice: 14 options; DK, R

**Health Information/Advice (13 questions)**
10. ACC_Q40 (ACCE_40): In the past 12 months, have you required health information or advice? - Single choice: 1=Yes, 2=No; DK, R
11. ACC_Q40A: Who did you contact? Mark all that apply. - Multiple choice: 1=Doctor's office, 2=Community health centre/CLSC, 3=Walk-in clinic, 4=Telephone health line, 5=Hospital emergency room, 6=Other hospital service, 7=Other-Specify; DK, R
12. ACC_Q41 (ACCE_41): Did you experience any difficulties? - Single choice: 1=Yes, 2=No; DK, R
13. ACC_Q42 (ACCE_42): Difficulties during regular office hours (9-5, M-F)? - Single choice: 1=Yes, 2=No, 3=Not required at this time; DK, R
14. ACC_Q43: What type of difficulties? (regular hours) Mark all that apply. - Multiple choice: 9 options; DK, R
15. ACC_Q44 (ACCE_44): Difficulties during evenings and weekends? - Single choice: 1=Yes, 2=No, 3=Not required at this time; DK, R
16. ACC_Q45: What type of difficulties? (evenings/weekends) - Multiple choice: 9 options; DK, R
17. ACC_Q46 (ACCE_46): Difficulties during the middle of the night? - Single choice: 1=Yes, 2=No, 3=Not required at this time; DK, R
18. ACC_Q47: What type of difficulties? (night) - Multiple choice: 9 options; DK, R

**Routine/Ongoing Care (12 questions)**
19. ACC_Q50A (ACCE_50A): Do you have a regular family doctor? - Single choice: 1=Yes, 2=No; DK, R
20. ACC_Q50 (ACCE_50): In the past 12 months, did you require any routine or on-going care? - Single choice: 1=Yes, 2=No; DK, R
21. ACC_Q51 (ACCE_51): Did you experience difficulties getting routine care? - Single choice: 1=Yes, 2=No; DK, R
22. ACC_Q52 (ACCE_52): Difficulties during regular office hours? - Single choice: 1=Yes, 2=No, 3=Not required; DK, R
23. ACC_Q53: What type of difficulties? (regular hours, routine) - Multiple choice: 13 options; DK, R
24. ACC_Q54 (ACCE_54): Difficulties during evenings and weekends? - Single choice: same; DK, R
25. ACC_Q55: What type of difficulties? (evenings/weekends, routine) - Multiple choice: 13 options; DK, R

**Immediate Care (8 questions)**
26. ACC_Q60 (ACCE_60): In the past 12 months, have you required immediate health care for a minor health problem? - Single choice: 1=Yes, 2=No; DK, R
27. ACC_Q61 (ACCE_61): Did you experience any difficulties? - Single choice: 1=Yes, 2=No; DK, R
28. ACC_Q62 (ACCE_62): Difficulties during regular office hours? - Single choice: 1=Yes, 2=No, 3=Not required; DK, R
29. ACC_Q63: What type of difficulties? (regular hours, immediate) - Multiple choice: 13 options; DK, R
30. ACC_Q64 (ACCE_64): Difficulties during evenings and weekends? - Single choice: same; DK, R
31. ACC_Q65: What type of difficulties? (evenings/weekends, immediate) - Multiple choice: 13 options; DK, R
32. ACC_Q66 (ACCE_66): Difficulties during middle of the night? - Single choice: 1=Yes, 2=No, 3=Not required; DK, R
33. ACC_Q67: What type of difficulties? (night, immediate) - Multiple choice: 13 options; DK, R

---

### WAITING TIMES (WTM) - 45 questions

*[Optional content, subsample]*

**Specialist Wait Times (16 questions)**
1. WTM_Q01 (WTME_01): Did you require a visit to a medical specialist for a new illness or condition? - Single choice: 1=Yes, 2=No; DK, R
2. WTM_Q02 (WTME_02): For what type of condition? - Single choice: 1=Heart/stroke, 2=Cancer, 3=Asthma/breathing, 4=Arthritis/rheumatism, 5=Cataract/eye, 6=Mental health, 7=Skin conditions, 8=Gynaecological, 9=Other-Specify; DK, R
3. WTM_Q03 (WTME_03): Were you referred by: - Single choice: 1=Family doctor, 2=Another specialist, 3=Another health care provider, 4=Did not require referral; DK, R
4. WTM_Q04 (WTME_04): Have you already visited the specialist? - Single choice: 1=Yes, 2=No; DK, R
5. WTM_Q05 (WTME_05): Thinking about this visit, did you experience any difficulties seeing the specialist? - Single choice: 1=Yes, 2=No; DK, R
6. WTM_Q06: What type of difficulties? Mark all that apply. - Multiple choice: 13 options; DK, R
7. WTM_Q07A (WTME_07A): How long did you have to wait (between decision/referral and seeing specialist)? - Numeric: MIN 1, MAX 365; DK, R
8. WTM_N07B (WTME_07B): Enter unit of time. - Single choice: 1=Days, 2=Weeks, 3=Months; (DK, R not allowed)
9. WTM_Q08A (WTME_08A): How long have you been waiting (still waiting)? - Numeric: MIN 1, MAX 365; DK, R
10. WTM_N08B (WTME_08B): Enter unit of time. - Single choice: 1=Days, 2=Weeks, 3=Months
11. WTM_Q10 (WTME_10): In your view, was the waiting time acceptable or not acceptable? - Single choice: 1=Acceptable, 2=Not acceptable, 3=No view; DK, R
12. WTM_Q11A (WTME_11A): What do you think is an acceptable waiting time? - Numeric: MIN 1, MAX 365; DK, R
13. WTM_N11B (WTME_11B): Enter unit of time. - Single choice: 1=Days, 2=Weeks, 3=Months
14. WTM_Q12 (WTME_12): Was your visit cancelled or postponed at any time? - Single choice: 1=Yes, 2=No; DK, R
15. WTM_Q13: Was it cancelled or postponed by: - Multiple choice: 1=Yourself, 2=The specialist, 3=Other-Specify; DK, R
16. WTM_Q14 (WTME_14): Do you think your health or other aspects of your life have been affected due to waiting? - Single choice: 1=Yes, 2=No; DK, R
17. WTM_Q15: How was your life affected? Mark all that apply. - Multiple choice: 12 options (worry, pain, loss of work, etc.); DK, R

**Surgery Wait Times (15 questions)**
18. WTM_Q16 (WTME_16): What type of surgery did you require? - Single choice: 1=Cardiac, 2=Cancer related, 3=Hip/knee replacement, 4=Cataract/eye, 5=Hysterectomy, 6=Removal of gall bladder, 7=Other-Specify; DK, R
19. WTM_Q17 (WTME_17): Did you already have the surgery? - Single choice: 1=Yes, 2=No; DK, R
20. WTM_Q18 (WTME_18): Did the surgery require an overnight hospital stay? - Single choice: 1=Yes, 2=No; DK, R
21. WTM_Q19 (WTME_19): Did you experience any difficulties getting this surgery? - Single choice: 1=Yes, 2=No; DK, R
22. WTM_Q20: What type of difficulties? Mark all that apply. - Multiple choice: 14 options; DK, R
23. WTM_Q21A (WTME_21A): How long did you have to wait (between decision and day of surgery)? - Numeric: MIN 1, MAX 365; DK, R
24. WTM_N21B (WTME_21B): Unit of time. - Single choice: 1=Days, 2=Weeks, 3=Months
25. WTM_Q22 (WTME_22): Will the surgery require an overnight hospital stay? (still waiting) - Single choice: 1=Yes, 2=No; DK, R
26. WTM_Q23A (WTME_23A): How long have you been waiting? - Numeric; DK, R
27. WTM_N23B: Unit of time.
28. WTM_Q24 (WTME_24): Was the waiting time acceptable or not acceptable? - Same scale as Q10; DK, R
29. WTM_Q25A (WTME_25A): What do you think is an acceptable waiting time? - Numeric; DK, R
30. WTM_N25B: Unit of time.
31. WTM_Q26 (WTME_26): Was your surgery cancelled or postponed? - Single choice: 1=Yes, 2=No; DK, R
32. WTM_Q27: Cancelled or postponed by: - Multiple choice: 1=Yourself, 2=The surgeon, 3=The hospital, 4=Other-Specify; DK, R
33. WTM_Q28 (WTME_28): Health or life affected due to waiting for surgery? - Single choice: 1=Yes, 2=No; DK, R
34. WTM_Q29: How was your life affected? Mark all that apply. - Multiple choice: 12 options; DK, R

**Diagnostic Test Wait Times (14 questions)**
35. WTM_Q30 (WTME_30): What type of test did you require? - Single choice: 1=MRI, 2=CAT Scan, 3=Angiography; DK, R
36. WTM_Q31 (WTME_31): For what type of condition? - Single choice: 1=Heart disease/stroke, 2=Cancer, 3=Joints/fractures, 4=Neurological/brain disorders, 5=Other-Specify; DK, R
37. WTM_Q32 (WTME_32): Did you already have this test? - Single choice: 1=Yes, 2=No; DK, R
38. WTM_Q33 (WTME_33): Where was the test done? - Single choice: 1=Hospital, 2=Public clinic, 3=Private clinic, 4=Other-Specify; DK, R
39. WTM_Q34 (WTME_34): Was the clinic located in your province, another province, or other? - Single choice: 1=Your province, 2=Another province, 3=Other-Specify; DK, R
40. WTM_Q35 (WTME_35): Were you a patient in a hospital at the time of the test? - Single choice: 1=Yes, 2=No; DK, R
41. WTM_Q36 (WTME_36): Did you experience any difficulties getting this test? - Single choice: 1=Yes, 2=No; DK, R
42. WTM_Q37: What type of difficulties? Mark all that apply. - Multiple choice: 13 options; DK, R
43. WTM_Q38A (WTME_38A): How long did you have to wait? - Numeric; DK, R
44. WTM_N38B (WTME_38B): Unit of time.
45. WTM_Q39A (WTME_39A): How long have you been waiting? (still waiting) - Numeric; DK, R
46. WTM_N39B: Unit of time.
47. WTM_Q40 (WTME_40): Was the waiting time acceptable? - Same scale; DK, R
48. WTM_Q41A (WTME_41A): What do you think is an acceptable waiting time? - Numeric; DK, R
49. WTM_N41B: Unit of time.
50. WTM_Q42 (WTME_42): Was your test cancelled or postponed? - Single choice: 1=Yes, 2=No; DK, R
51. WTM_Q43 (WTME_43): Cancelled or postponed by: - Multiple choice: 1=Yourself, 2=The specialist, 3=The hospital, 4=The clinic, 5=Other-Specify; DK, R
52. WTM_Q44 (WTME_44): Health or life affected due to waiting? - Single choice: 1=Yes, 2=No; DK, R
53. WTM_Q45: How was your life affected? Mark all that apply. - Multiple choice: 12 options; DK, R

---

### MEASURED HEIGHT AND WEIGHT (MHW) - 18 questions

*[Subsample, non-proxy, in-person only]*

1. MHW_N1A (MHWZ_N1): Are there any reasons that make it impossible to measure weight? - Single choice: 1=Yes, 2=No; (DK, R not allowed)
2. MHW_N1B: Reasons why impossible to measure weight. - Multiple choice: 1=Unable to stand, 2=In wheelchair, 3=Bedridden, 4=Interview setting, 5=Safety concerns, 6=Already refused, 7=Other-Specify; (DK, R not allowed)
3. MHW_Q2A (MHWZ_2): Do I have your permission to measure your weight? - Single choice: 1=Yes, 2=No; (DK, R not allowed)
4. MHW_N2A (MHWZ_N2A): Record weight to nearest 0.01 kg. - Numeric: MIN 1.00, MAX 261.00 kg (warning under 27.00 or above 136.00); DK
5. MHW_N3A (MHWZ_N3): Were there any articles of clothing or physical characteristics which affected the accuracy? (weight) - Single choice: 1=Yes, 2=No; (DK, R not allowed)
6. MHW_N3B: Select reasons. - Multiple choice: 1=Shoes or boots, 2=Heavy sweater or jacket, 3=Jewellery, 4=Other-Specify; (DK, R not allowed)
7. MHW_N4 (MHWZ_N4): Reason for not weighing. - Single choice: 1=Scale not functioning, 2=Other-Specify; (DK, R not allowed)
8. MHW_N5A (MHWZ_N5): Are there any reasons that make it impossible to measure height? - Single choice: 1=Yes, 2=No; (DK, R not allowed)
9. MHW_N5B: Reasons why impossible. - Multiple choice: 1=Too tall, 2=Interview setting, 3=Safety concerns, 4=Already refused, 5=Other-Specify; (DK, R not allowed)
10. MHW_Q6A (MHWZ_6): Do I have your permission to measure your height? - Single choice: 1=Yes, 2=No; (DK, R not allowed)
11. MHW_N6B (MHWZ_N6): Enter height to nearest 0.5 cm. - Numeric: MIN 90.0, MAX 250.0 cm; DK, R
12. MHW_N7A (MHWZ_N7): Were there any articles of clothing or physical characteristics which affected accuracy? (height) - Single choice: 1=Yes, 2=No; (DK, R not allowed)
13. MHW_N7B: Select reasons. - Multiple choice: 1=Shoes or boots, 2=Hairstyle, 3=Hat, 4=Other-Specify; (DK, R not allowed)

---

### LABOUR FORCE (LBF) - 46 questions

*[Optional content, sub-sample, age 15-75]*

**Job Attachment (11 questions)**
1. LBF_Q01 (LBFZ_01): Last week, did you work at a job or a business? - Single choice: 1=Yes, 2=No, 3=Permanently unable to work; DK, R
2. LBF_Q02 (LBFZ_02): Last week, did you have a job or business from which you were absent? - Single choice: 1=Yes, 2=No; DK, R
3. LBF_Q03 (LBFZ_03): Did you have more than one job or business last week? - Single choice: 1=Yes, 2=No; DK, R

**Job Search (3 questions)**
4. LBF_Q11 (LBFZ_11): In the past 4 weeks, did you do anything to find work? - Single choice: 1=Yes, 2=No; DK, R
5. LBF_Q13 (LBFZ_13): What is the main reason you are not currently working? - Single choice: 1=Own illness/disability, 2=Caring for children, 3=Caring for elder relatives, 4=Pregnancy, 5=Other personal/family, 6=Vacation, 7=School/educational leave, 8=Retired, 9=Believes no work available, 10=Other-Specify; DK, R
6. LBF_Q13A (LBFZ_13A): Is this due to your physical health, emotional/mental health, use of alcohol or drugs, or another reason? - Single choice: 1=Physical health, 2=Emotional/mental health, 3=Alcohol or drugs, 4=Another reason; DK, R

**Occupation, Smoking Restrictions at Work (12 questions)**
7. LBF_Q31 (LBFZ_31): Are you an employee or self-employed? - Single choice: 1=Employee, 2=Self-employed, 3=Working in family business without pay; DK, R
8. LBF_Q31A (LBFZ_31A): Do you have any employees? - Single choice: 1=Yes, 2=No; DK, R
9. LBF_Q32: What is the name of your business? - Open text (50 spaces); DK, R
10. LBF_Q33: For whom do you currently/last work? - Open text (50 spaces); DK, R
11. LBF_Q34: What kind of business, industry or service is this? - Open text (50 spaces); DK, R
12. LBF_Q35: What kind of work are you doing? - Open text (50 spaces); DK, R
13. LBF_Q36: What are your most important activities or duties? - Open text (50 spaces); DK, R
14. LBF_Q36A (LBFZ_36A): Is your job permanent or not permanent? - Single choice: 1=Permanent, 2=Not permanent; DK, R
15. LBF_Q36B (LBFZ_36B): In what way is your job not permanent? - Single choice: 1=Seasonal, 2=Temporary/term/contract, 3=Casual, 4=Through temp agency, 5=Other; DK, R
16. LBF_Q37 (ETSZ_7): At your place of work, what are the restrictions on smoking? - Single choice: 1=Restricted completely, 2=Allowed in designated areas, 3=Restricted only in certain places, 4=Not restricted at all; DK, R

**Absence/Hours (4 questions)**
17. LBF_Q41 (LBFZ_41): What was the main reason you were absent from work last week? - Single choice: 1=Own illness/disability, 2=Caring for children, 3=Caring for elder relatives, 4=Maternity leave, 5=Other personal/family, 6=Vacation, 7=Labour dispute, 8=Temporary layoff, 9=Seasonal layoff, 10=Casual job/no work available, 11=Work schedule, 12=Self-employed/no work available, 13=Seasonal business, 14=School/educational leave, 15=Other-Specify; DK, R
18. LBF_Q41A (LBFZ_41A): Was that due to physical health, emotional/mental health, alcohol/drugs, or another reason? - Single choice: 1=Physical health, 2=Emotional/mental health, 3=Alcohol or drugs, 4=Another reason; DK, R
19. LBF_Q42 (LBFZ_42): About how many hours a week do you usually work? - Numeric: MIN 1, MAX 168 (warning after 84); DK, R
20. LBF_Q44 (LBFZ_44): Which of the following best describes the hours you usually work? - Single choice: 1=Regular daytime, 2=Regular evening, 3=Regular night, 4=Rotating shift, 5=Split shift, 6=On call, 7=Irregular schedule, 8=Other-Specify; DK, R
21. LBF_Q45 (LBFZ_45): What is the main reason you work this schedule? - Single choice: 1=Requirement of job, 2=Going to school, 3=Caring for children, 4=Caring for other relatives, 5=To earn more money, 6=Likes to work this schedule, 7=Other-Specify; DK, R
22. LBF_Q46 (LBFZ_46): Do you usually work on weekends? - Single choice: 1=Yes, 2=No; DK, R

**Other Job (5 questions)**
23. LBF_Q51 (LBFZ_51): How many weeks in a row have/has/had you had more than one job? - Numeric: MIN 1, MAX 52; DK, R
24. LBF_Q52 (LBFZ_52): What is the main reason for more than one job? - Single choice: 1=Meet regular expenses, 2=Pay off debts, 3=Buy something special, 4=Save for future, 5=Gain experience, 6=Build up business, 7=Enjoys work, 8=Other-Specify; DK, R
25. LBF_Q53 (LBFZ_53): How many hours a week at other job(s)? - Numeric: MIN 1, MAX (168-LBF_Q42); DK, R
26. LBF_Q54 (LBFZ_54): Do you usually work on weekends at your other job(s)? - Single choice: 1=Yes, 2=No; DK, R

**Weeks Worked (3 questions)**
27. LBF_Q61 (LBFZ_61): During the past 52 weeks, how many weeks did you do any work? - Numeric: MIN 1, MAX 52; DK, R
28. LBF_Q71 (LBFZ_71): During the past 52 weeks, how many weeks were you looking for work? - Numeric: MIN 0, MAX (52-LBF_Q61); DK, R
29. LBF_Q72 (LBFZ_72): That leaves [WEEKS] weeks during which you were neither working nor looking for work. Is that correct? - Single choice: 1=Yes, 2=No; DK, R

**Looking For Work (3 questions)**
30. LBF_Q73 (LBFZ_73): What is the main reason you were not looking for work? - Single choice: 1=Own illness/disability, 2=Caring for children, 3=Caring for elder relatives, 4=Pregnancy, 5=Other personal/family, 6=Vacation, 7=Labour dispute, 8=Temporary layoff, 9=Seasonal layoff, 10=Casual job/no work, 11=Work schedule, 12=School/educational leave, 13=Retired, 14=Believes no work available, 15=Other-Specify; DK, R
31. LBF_Q73A (LBFZ_73A): Was that due to physical health, emotional/mental health, alcohol/drugs, or another reason? - Single choice: 1=Physical health, 2=Emotional/mental health, 3=Alcohol or drugs, 4=Another reason; DK, R

---

### LABOUR FORCE - Common Portion (LF2) - 7 questions

*[Age 15-75, not in LBF sub-sample]*

1. LF2_Q1 (LBSE_01): Last week, did you work at a job or a business? - Single choice: 1=Yes, 2=No, 3=Permanently unable to work; DK, R
2. LF2_Q2 (LBSE_02): Last week, did you have a job from which you were absent? - Single choice: 1=Yes, 2=No; DK, R
3. LF2_Q3 (LBSE_03): Did you have more than one job last week? - Single choice: 1=Yes, 2=No; DK, R
4. LF2_Q4 (LBSE_11): In the past 4 weeks, did you do anything to find work? - Single choice: 1=Yes, 2=No; DK, R
5. LF2_Q5 (LBSE_42): About how many hours a week do you usually work? - Numeric: MIN 1, MAX 168 (warning after 84); DK, R
6. LF2_Q6 (ETSE_7): At your place of work, what are the restrictions on smoking? - Single choice: 1=Restricted completely, 2=Allowed in designated areas, 3=Restricted only in certain places, 4=Not restricted at all; DK, R
7. LF2_Q7 (LBSE_53): How many hours a week at your other job(s)? - Numeric: MIN 1, MAX (168-LF2_Q5); DK, R

---

### SOCIO-DEMOGRAPHIC CHARACTERISTICS (SDC) - 14 questions

1. SDC_Q1 (SDCE_1): In what country were you born? - Single choice: 1=Canada, 2=China, 3=France, 4=Germany, 5=Greece, 6=Guyana, 7=Hong Kong, 8=Hungary, 9=India, 10=Italy, 11=Jamaica, 12=Netherlands/Holland, 13=Philippines, 14=Poland, 15=Portugal, 16=United Kingdom, 17=United States, 18=Viet Nam, 19=Sri Lanka, 20=Other-Specify; DK, R
2. SDC_Q2 (SDCE_2): Were you born a Canadian citizen? - Single choice: 1=Yes, 2=No; DK, R
3. SDC_Q3 (SDCE_3): In what year did you first come to Canada to live? - Numeric: year (MIN: year of birth, MAX: current year); DK, R
4. SDC_Q4 (SDCE_4): To which ethnic or cultural group(s) did your ancestors belong? - Multiple choice: 1=Canadian, 2=French, 3=English, 4=German, 5=Scottish, 6=Irish, 7=Italian, 8=Ukrainian, 9=Dutch, 10=Chinese, 11=Jewish, 12=Polish, 13=Portuguese, 14=South Asian, 15=Norwegian, 16=Welsh, 17=Swedish, 18=North American Indian, 19=Metis, 20=Inuit, 21=Other-Specify; DK, R
5. SDC_Q4_1 (SDCE_41): Are you an Aboriginal person, that is, North American Indian, Metis or Inuit? - Single choice: 1=Yes, 2=No; DK, R
6. SDC_Q4_2: Are you: - Multiple choice: 1=North American Indian, 2=Metis, 3=Inuit; DK, R
7. SDC_Q4_3: People living in Canada come from many different cultural and racial backgrounds. Are you: - Multiple choice: 1=White, 2=Chinese, 3=South Asian, 4=Black, 5=Filipino, 6=Latin American, 7=Southeast Asian, 8=Arab, 9=West Asian, 10=Japanese, 11=Korean, 12=Other-Specify; DK, R
8. SDC_Q5: In what languages can you conduct a conversation? - Multiple choice: 1=English, 2=French, 3=Arabic, 4=Chinese, 5=Cree, 6=German, 7=Greek, 8=Hungarian, 9=Italian, 10=Korean, 11=Persian (Farsi), 12=Polish, 13=Portuguese, 14=Punjabi, 15=Spanish, 16=Tagalog, 17=Ukrainian, 18=Vietnamese, 19=Dutch, 20=Hindi, 21=Russian, 22=Tamil, 23=Other-Specify; DK, R
9. SDC_Q5A (SDCE_5AA): What language do you speak most often at home? - Single choice: same 23 options; DK, R
10. SDC_Q6: What is the language you first learned at home in childhood and can still understand? - Multiple choice: same 23 options; DK, R
11. SDC_Q7: People living in Canada come from many different cultural and racial backgrounds. Are you: (revised version) - Multiple choice: 1=White, 2=Chinese, 3=South Asian, 4=Black, 5=Filipino, 6=Latin American, 7=Southeast Asian, 8=Arab, 9=West Asian, 10=Japanese, 11=Korean, 12=Aboriginal, 13=Other-Specify; DK, R
12. SDC_Q7B (SDCE_7BA): Are you: - Multiple choice: 1=North American Indian, 2=Metis, 3=Inuit, 4=Other-Specify; DK, R
13. SDC_Q7A (SDCE_7AA): Do you consider yourself to be: - Single choice: 1=Heterosexual, 2=Homosexual (lesbian or gay), 3=Bisexual; DK, R [age 18-59, non-proxy]

---

### EDUCATION (EDU) - 10 questions

**Education Sub Block 1 (selected respondent)**
1. EDU_Q01 (EDUE_01): What is the highest grade of elementary or high school you have ever completed? - Single choice: 1=Grade 8 or lower, 2=Grade 9-10, 3=Grade 11-13; DK, R
2. EDU_Q02 (EDUE_02): Did you graduate from high school? - Single choice: 1=Yes, 2=No; DK, R
3. EDU_Q03 (EDUE_03): Have you received any other education (degree, certificate, diploma from an educational institution)? - Single choice: 1=Yes, 2=No; DK, R
4. EDU_Q04 (EDUE_04): What is the highest degree, certificate or diploma you have obtained? - Single choice: 1=No post-secondary, 2=Trade certificate/diploma, 3=Non-university certificate/diploma, 4=University certificate below bachelor's, 5=Bachelor's degree, 6=University degree or certificate above bachelor's; DK, R
5. EDU_Q05 (SDCE_08): Are you currently attending a school, college or university? - Single choice: 1=Yes, 2=No; DK, R
6. EDU_Q06 (SDCE_09): Are you enrolled as a full-time or part-time student? - Single choice: 1=Full-time, 2=Part-time; DK, R

**Education Sub Block 2 (other household members age >= 14)**
7. EDU_Q07 (EDUE_01): Highest grade of elementary or high school ever completed? - Same as Q01; DK, R
8. EDU_Q08 (EDUE_02): Did they graduate from high school? - Single choice: 1=Yes, 2=No; DK, R
9. EDU_Q09 (EDUE_03): Have they received any other education? - Single choice: 1=Yes, 2=No; DK, R
10. EDU_Q10 (EDUE_04): What is the highest degree, certificate or diploma obtained? - Same as Q04; DK, R

---

### INSURANCE COVERAGE (INS) - 8 questions

1. INS_Q1 (INSE_1): Do you have insurance that covers all or part of your prescription medications? - Single choice: 1=Yes, 2=No; DK, R
2. INS_Q1A: Is it a government-sponsored plan, employer-sponsored plan, or private plan? - Multiple choice: 1=Government, 2=Employer, 3=Private; DK, R
3. INS_Q2 (INSE_2): Do you have insurance that covers dental expenses? - Single choice: 1=Yes, 2=No; DK, R
4. INS_Q2A: Is it a government-sponsored plan, employer-sponsored plan, or private plan? - Multiple choice: 1=Government, 2=Employer, 3=Private; DK, R
5. INS_Q3 (INSE_3): Do you have insurance covering eye glasses or contact lenses? - Single choice: 1=Yes, 2=No; DK, R
6. INS_Q3A: Is it a government-sponsored plan, employer-sponsored plan, or private plan? - Multiple choice: 1=Government, 2=Employer, 3=Private; DK, R
7. INS_Q4 (INSE_4): Do you have insurance covering hospital charges for a private or semi-private room? - Single choice: 1=Yes, 2=No; DK, R
8. INS_Q4A: Is it a government-sponsored plan, employer-sponsored plan, or private plan? - Multiple choice: 1=Government, 2=Employer, 3=Private; DK, R

---

### INCOME (INC) - 14 questions

1. INC_Q1: From which sources did your household receive any income in the past 12 months? - Multiple choice: 1=Wages/salaries, 2=Self-employment, 3=Dividends/interest, 4=Employment insurance, 5=Worker's compensation, 6=Canada/Quebec Pension, 7=Retirement pensions, 8=Old Age Security/GIS, 9=Child Tax Benefit, 10=Provincial social assistance/welfare, 11=Child support, 12=Alimony, 13=Other (rental, scholarships), 14=None; DK, R
2. INC_Q2 (INCE_2): What was the main source of income? - Single choice: same 14 options; DK, R
3. INC_Q3 (INCE_3): What is your best estimate of total household income, before taxes and deductions, from all sources in the past 12 months? - Numeric: MIN 0, MAX 500,000 (warning after 150,000); DK, R
4. INC_Q3A (INCE_3A): Was the total household income less than $20,000 or $20,000 or more? - Single choice: 1=Less than $20,000, 2=$20,000 or more, 3=No income; DK, R
5. INC_Q3B (INCE_3B): Less than $10,000 or $10,000 or more? - Single choice: 1=Less than $10,000, 2=$10,000 or more; DK, R
6. INC_Q3C (INCE_3C): Less than $5,000 or $5,000 or more? - Single choice: 1=Less than $5,000, 2=$5,000 or more; DK, R
7. INC_Q3D (INCE_3D): Less than $15,000 or $15,000 or more? - Single choice: 1=Less than $15,000, 2=$15,000 or more; DK, R
8. INC_Q3E (INCE_3E): Less than $40,000 or $40,000 or more? - Single choice: 1=Less than $40,000, 2=$40,000 or more; DK, R
9. INC_Q3F (INCE_3F): Less than $30,000 or $30,000 or more? - Single choice: 1=Less than $30,000, 2=$30,000 or more; DK, R
10. INC_Q3G (INCE_3G): Was the total household income: - Single choice: 1=Less than $50,000, 2=$50,000-$59,999, 3=$60,000-$79,999, 4=$80,000-$99,999, 5=$100,000 or more; DK, R
11. INC_Q4 (INCE_4): What is your best estimate of total personal income, before taxes and deductions? - Numeric: MIN 0, MAX 500,000; DK, R [age >= 15]
12. INC_Q4A (INCE_4A): Was total personal income less than $20,000 or $20,000 or more? - Single choice: 1=Less than $20,000, 2=$20,000 or more, 3=No income; DK, R
13. INC_Q4B-Q4F: Cascading personal income brackets (same pattern as Q3B-Q3F)
14. INC_Q4G (INCE_4G): Was your total personal income: - Single choice: 1=Less than $50,000, 2=$50,000-$59,999, 3=$60,000-$79,999, 4=$80,000-$99,999, 5=$100,000 or more; DK, R

---

### FOOD SECURITY (FSC) - 18 questions

**Adult Food Security (8 questions)**
1. FSC_Q010 (FSCE_010): Which best describes the food eaten in your household in the past 12 months? - Single choice: 1=Always had enough of the kinds wanted, 2=Enough but not always the kinds wanted, 3=Sometimes did not have enough, 4=Often didn't have enough; DK, R
2. FSC_Q020 (FSCE_020): Worried that food would run out before you got money to buy more. Often, sometimes, or never true? - Single choice: 1=Often true, 2=Sometimes true, 3=Never true; DK, R
3. FSC_Q030 (FSCE_030): The food bought just didn't last, and there wasn't money to get more. - Single choice: 1=Often, 2=Sometimes, 3=Never; DK, R
4. FSC_Q040 (FSCE_040): Couldn't afford to eat balanced meals. - Single choice: 1=Often, 2=Sometimes, 3=Never; DK, R
5. FSC_Q080 (FSCE_080): Did you ever cut the size of your meals or skip meals because there wasn't enough money for food? - Single choice: 1=Yes, 2=No; DK, R
6. FSC_Q081 (FSCE_081): How often? - Single choice: 1=Almost every month, 2=Some months but not every month, 3=Only 1 or 2 months; DK, R
7. FSC_Q090 (FSCE_090): Did you personally ever eat less than you felt you should because there wasn't enough money? - Single choice: 1=Yes, 2=No; DK, R
8. FSC_Q100 (FSCE_100): Were you personally ever hungry but didn't eat because you couldn't afford enough food? - Single choice: 1=Yes, 2=No; DK, R
9. FSC_Q110 (FSCE_110): Did you personally lose weight because you didn't have enough money for food? - Single choice: 1=Yes, 2=No; DK, R
10. FSC_Q120 (FSCE_120): Did you ever not eat for a whole day because there wasn't enough money for food? - Single choice: 1=Yes, 2=No; DK, R
11. FSC_Q121 (FSCE_121): How often? - Single choice: 1=Almost every month, 2=Some months, 3=Only 1 or 2 months; DK, R

**Child Food Security (7 questions)** [if children in household]
12. FSC_Q050 (FSCE_050): Relied on only a few kinds of low-cost food to feed children. Often, sometimes, or never true? - Single choice: 1=Often, 2=Sometimes, 3=Never; DK, R
13. FSC_Q060 (FSCE_060): Couldn't feed children a balanced meal because you couldn't afford it. - Single choice: same; DK, R
14. FSC_Q070 (FSCE_070): Children were not eating enough because you just couldn't afford enough food. - Single choice: same; DK, R
15. FSC_Q130 (FSCE_130): Did you ever cut the size of children's meals because there wasn't enough money? - Single choice: 1=Yes, 2=No; DK, R
16. FSC_Q140 (FSCE_140): Did any child ever skip meals? - Single choice: 1=Yes, 2=No; DK, R
17. FSC_Q141 (FSCE_141): How often? - Single choice: 1=Almost every month, 2=Some months, 3=Only 1 or 2 months; DK, R
18. FSC_Q150 (FSCE_150): Were any children ever hungry but you just couldn't afford more food? - Single choice: 1=Yes, 2=No; DK, R
19. FSC_Q160 (FSCE_160): Did any child ever not eat for a whole day because there wasn't enough money? - Single choice: 1=Yes, 2=No; DK, R

---

### DWELLING CHARACTERISTICS (DWL) - 3 questions

1. DWL_Q01 (DHHEDDWE): What type of dwelling do you live in? - Single choice: 1=Single detached, 2=Double, 3=Row or terrace, 4=Duplex, 5=Low-rise apartment (<5 stories), 6=High-rise apartment (5+ stories), 7=Institution, 8=Hotel/rooming/lodging house, 9=Mobile home, 10=Other-Specify; DK, R
2. DWL_Q02 (DHHE_BED): How many bedrooms are there in this dwelling? - Numeric: MIN 0, MAX 20; DK, R
3. DWL_Q03 (DHHE_OWN): Is this dwelling owned by a member of this household? - Single choice: 1=Yes, 2=No; DK, R

---

### ADMINISTRATION (ADM) - 11 questions

**Health Number (3 questions)**
1. ADM_Q01A: Statistics Canada and your provincial/territorial ministry of health would like your permission to link information collected during this interview. - Read statement. INTERVIEWER: Press Enter.
2. ADM_Q01B (SAMEDLNK): This linked information will be kept confidential and used only for statistical purposes. Do we have your permission? - Single choice: 1=Yes, 2=No; DK, R
3. ADM_Q03A: Do you have a provincial/territorial health number? - Single choice: 1=Yes, 2=No; DK, R
4. ADM_Q03B (LNKE_HNP): For which province/territory is your health number? - Single choice: 10=NL, 11=PEI, 12=NS, 13=NB, 24=QC, 35=ON, 46=MB, 47=SK, 48=AB, 59=BC, 60=YK, 61=NWT, 62=NU, 88=Do not have one; DK, R
5. HN: What is your health number? - Open text (8-12 spaces); DK, R

**Data Sharing (1 question)**
6. ADM_Q04A: Statistics Canada would like your permission to share the information collected in this survey with provincial and territorial ministries of health, Health Canada and the Public Health Agency of Canada. - Read statement.
7. ADM_Q04B (SAMEDSHR): Do you agree to share the information provided? - Single choice: 1=Yes, 2=No; DK, R

**Frame Evaluation (4 questions)**
8. FRE_Q1 (ADME_FE1): How many different telephone numbers are there for your household? - Single choice: 1=1, 2=2, 3=3 or more, 4=None; DK, R
9. FRE_Q2: What is your main phone number, including area code? - Telephone number; DK, R
10. FRE_Q3: What is your other phone number(s)? - Telephone number; DK, R
11. FRE_Q4 (ADME_F4): Do you have a working cellular phone that can place and receive calls? - Single choice: 1=Yes, 2=No; DK, R

**Administration (3 questions)**
12. ADM_N05 (ADME_N05): Is this a fictitious name for the respondent? - Single choice: 1=Yes, 2=No; DK, R
13. ADM_N06 (ADME_N06): Do you want to make corrections to: - Single choice: 1=First name only, 2=Last name only, 3=Both names, 4=No corrections; DK, R
14. ADM_N07: Enter the first name only. - Open text (25 spaces); DK, R
15. ADM_N08: Enter the last name only. - Open text (25 spaces); DK, R

---

## Summary of Modules and Question Counts

| Module | Code | Type | Questions |
|--------|------|------|-----------|
| General Health | GEN | Common | 17 |
| Chronic Conditions | CCC | Common | 32 |
| Two-Week Disability | TWD | Common | 6 |
| Health Care Utilization | HCU | Common | 18 |
| Activity Limitation | RAC | Common | 11 |
| Smoking | SMK | Common | 27 |
| Alcohol Use | ALC | Common | 10 |
| Physical Activities | PAC | Common | 25 |
| Fruit & Vegetable Consumption | FVC | Common | 8 |
| Breastfeeding | BFE | Optional | 8 |
| Maternal Experiences | MAM | Optional | 8 |
| Drug Use | DRG | Optional | 7 |
| Medication Use | MED | Common | 6 |
| Patient Satisfaction | PSA | Optional | 7 |
| Depression (CIDI-SF) | DEP | Optional | 22 |
| Mastery and Coping | MST | Optional | 7 |
| Self-Esteem | SFE | Optional | 6 |
| Social Support | SSA | Optional | 6 |
| Injuries | INJ | Common | 17 |
| Health Utility Index | HUI | Optional | 31 |
| Health Status SF-36 | SFR | Optional | 34 |
| Sexual Behaviours | SXB | Optional | 13 |
| Access to Health Care | ACC | Optional | 38 |
| Waiting Times | WTM | Optional | 53 |
| Measured Height and Weight | MHW | Optional | 13 |
| Labour Force (sub-sample) | LBF | Optional | 46 |
| Labour Force (common) | LF2 | Common | 7 |
| Socio-Demographics | SDC | Common | 14 |
| Education | EDU | Common | 10 |
| Insurance Coverage | INS | Common | 8 |
| Income | INC | Common | 14 |
| Food Security | FSC | Optional | 19 |
| Dwelling Characteristics | DWL | Common | 3 |
| Administration | ADM | Common | 15 |

## TOTAL UNIQUE QUESTION NODES: ~611
