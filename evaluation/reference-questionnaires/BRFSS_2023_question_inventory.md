# BRFSS 2023 Question Inventory

## Document Overview

| Field | Value |
|-------|-------|
| **Full Title** | Behavioral Risk Factor Surveillance System 2023 Questionnaire |
| **Organization** | Centers for Disease Control and Prevention (CDC) |
| **Year** | 2023 |
| **Country** | United States |
| **Mode** | CATI (Computer-Assisted Telephone Interview) |
| **Language** | English |
| **Total Pages** | 127 |
| **Sections** | 20 Core Sections + Additional Core + 20 Optional Modules |

## Structure

| Section | Title | Page(s) |
|---------|-------|---------|
| Introduction | CATI Introduction and Screening | 3-7 |
| Core 1 | Health Status | 8 |
| Core 2 | Healthy Days — Health-Related Quality of Life | 8-9 |
| Core 3 | Health Care Access | 9-10 |
| Core 4 | Inadequate Sleep | 10 |
| Core 5 | Hypertension Awareness | 10-11 |
| Core 6 | Cholesterol Awareness | 11-12 |
| Core 7 | Chronic Health Conditions | 12-14 |
| Core 8 | Demographics | 14-17 |
| Core 9 | Tobacco Use | 17-18 |
| Core 10 | E-Cigarette Use | 18 |
| Core 11 | Alcohol Consumption | 18-20 |
| Core 12 | Immunization | 20-21 |
| Core 13 | Falls | 22 |
| Core 14 | Seatbelt Use | 22 |
| Core 15 | Drinking and Driving | 22-23 |
| Core 16 | Breast and Cervical Cancer Screening | 23-26 |
| Core 17 | Prostate Cancer Screening | 26-27 |
| Core 18 | Colorectal Cancer Screening | 27-29 |
| Core 19 | HIV/AIDS | 29-30 |
| Core 20 | Disability | 30-31 |
| Additional | Emotional Support and Life Satisfaction | 31 |
| Additional | Random Child Selection | 32 |
| Additional | Child Demographics | 32-33 |
| Additional | Childhood Asthma Prevalence | 33-34 |
| Additional | Landline/Cell Phone Introduction | 35-44 |
| Module 1 | Prediabetes | 61-62 |
| Module 2 | Diabetes | 62-64 |
| Module 3 | Healthy Days (Symptoms) | 64-65 |
| Module 4 | Cardiovascular Health | 65-66 |
| Module 5 | Oral Health | 66-67 |
| Module 6 | Firearms | 67-68 |
| Module 7 | Cancer Survivorship | 69-70 |
| Module 8 | Caregiver | 70-72 |
| Module 9 | Cognitive Decline | 72-73 |
| Module 10 | Social Determinants of Health | 73-76 |
| Module 11 | Adverse Childhood Experiences (ACE) | 76-79 |
| Module 12 | Industry and Occupation | 79-80 |
| Module 13 | Physical Activity | 80-83 |
| Module 14 | Marijuana Use | 83-84 |
| Module 15 | Sexual Orientation and Gender Identity | 84-85 |
| Module 16 | Social Isolation | 85-86 |
| Module 17 | Long COVID | 86-87 |
| Module 18 | Mpox | 87-88 |
| Module 19 | Shingles | 88-89 |
| Module 20 | Opioid Use | 89-90 |

---

## Question Inventory by Section

---

### Section 1: Health Status

| # | Variable | Question Text | Type | Response Options |
|---|----------|--------------|------|-----------------|
| 1.1 | GENHLTH | Would you say that in general your health is: | Radio | 1=Excellent, 2=Very good, 3=Good, 4=Fair, 5=Poor, 7=Don't know/Not sure, 9=Refused |

---

### Section 2: Healthy Days — Health-Related Quality of Life

| # | Variable | Question Text | Type | Response Options |
|---|----------|--------------|------|-----------------|
| 2.1 | PHYSHLTH | Now thinking about your physical health, which includes physical illness and injury, for how many days during the past 30 days was your physical health not good? | Numeric | 1-30=Number of days, 88=None, 77=Don't know/Not sure, 99=Refused |
| 2.2 | MENTHLTH | Now thinking about your mental health, which includes stress, depression, and problems with emotions, for how many days during the past 30 days was your mental health not good? | Numeric | 1-30=Number of days, 88=None, 77=Don't know/Not sure, 99=Refused |
| 2.3 | POORHLTH | During the past 30 days, for about how many days did poor physical or mental health keep you from doing your usual activities, such as self-care, work, or recreation? | Numeric | 1-30=Number of days, 88=None, 77=Don't know/Not sure, 99=Refused [If PHYSHLTH >= 1 or MENTHLTH >= 1] |

---

### Section 3: Health Care Access

| # | Variable | Question Text | Type | Response Options |
|---|----------|--------------|------|-----------------|
| 3.1 | HLTHPLN1 | Do you have any kind of health care coverage, including health insurance, prepaid plans such as HMOs, or government plans such as Medicare, or Indian Health Service? | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused |
| 3.2 | PERSDOC3 | Do you have one person or a group of doctors you think of as your personal doctor or health care provider? | Radio | 1=Yes, only one, 2=More than one, 3=No, 7=Don't know/Not sure, 9=Refused |
| 3.3 | MEDCOST1 | Was there a time in the past 12 months when you needed to see a doctor but could not because you could not afford it? | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused |
| 3.4 | CHECKUP1 | About how long has it been since you last visited a doctor for a routine checkup? | Radio | 1=Within past year, 2=Within past 2 years, 3=Within past 5 years, 4=5 or more years ago, 7=Don't know/Not sure, 8=Never, 9=Refused |

---

### Section 4: Inadequate Sleep

| # | Variable | Question Text | Type | Response Options |
|---|----------|--------------|------|-----------------|
| 4.1 | SLEPTIM1 | On average, how many hours of sleep do you get in a 24-hour period? | Numeric | 1-24=Number of hours, 77=Don't know/Not sure, 99=Refused |

---

### Section 5: Hypertension Awareness

| # | Variable | Question Text | Type | Response Options |
|---|----------|--------------|------|-----------------|
| 5.1 | BPHIGH6 | Have you ever been told by a doctor, nurse, or other health professional that you have high blood pressure? | Radio | 1=Yes, 2=Yes, but female told only during pregnancy, 3=No, 4=Told borderline or pre-hypertensive, 7=Don't know/Not sure, 9=Refused |
| 5.2 | BPMEDS1 | Are you currently taking medicine for your high blood pressure? | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused [If BPHIGH6 = 1] |
| 5.3 | BPHIGH4 | Has a doctor, nurse, or other health professional checked your blood pressure in the past year? | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused |

---

### Section 6: Cholesterol Awareness

| # | Variable | Question Text | Type | Response Options |
|---|----------|--------------|------|-----------------|
| 6.1 | BLOODCHO | Blood cholesterol is a fatty substance found in the blood. Have you ever had your blood cholesterol checked? | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused |
| 6.2 | CHOLCHK3 | About how long has it been since you last had your blood cholesterol checked? | Radio | 1=Within past year, 2=Within past 2 years, 3=Within past 5 years, 4=5 or more years ago, 7=Don't know/Not sure, 9=Refused [If BLOODCHO = 1] |
| 6.3 | TOLDHI3 | Have you ever been told by a doctor, nurse, or other health professional that your blood cholesterol is high? | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused [If BLOODCHO = 1] |
| 6.4 | CHOLMED3 | Are you currently taking medicine prescribed by your doctor or other health professional for your blood cholesterol? | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused [If TOLDHI3 = 1] |

---

### Section 7: Chronic Health Conditions

| # | Variable | Question Text | Type | Response Options |
|---|----------|--------------|------|-----------------|
| 7.1 | CVDINFR4 | Has a doctor, nurse, or other health professional ever told you that you had a heart attack, also called a myocardial infarction? | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused |
| 7.2 | CVDCRHD4 | Has a doctor, nurse, or other health professional ever told you that you had angina or coronary heart disease? | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused |
| 7.3 | CVDSTRK3 | Has a doctor, nurse, or other health professional ever told you that you had a stroke? | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused |
| 7.4 | ASTHMA3 | Has a doctor, nurse, or other health professional ever told you that you had asthma? | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused |
| 7.5 | ASTHNOW | Do you still have asthma? | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused [If ASTHMA3 = 1] |
| 7.6 | CHCSCNC1 | Has a doctor, nurse, or other health professional ever told you that you had skin cancer? | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused |
| 7.7 | CHCOCNC1 | Has a doctor, nurse, or other health professional ever told you that you had any other types of cancer? | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused |
| 7.8 | CHCCOPD3 | Has a doctor, nurse, or other health professional ever told you that you have chronic obstructive pulmonary disease or COPD, emphysema, or chronic bronchitis? | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused |
| 7.9 | ADDEPEV3 | Has a doctor, nurse, or other health professional ever told you that you have a depressive disorder, including depression, major depression, dysthymia, or minor depression? | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused |
| 7.10 | HAVARTH5 | Has a doctor, nurse, or other health professional ever told you that you have some form of arthritis, rheumatoid arthritis, gout, lupus, or fibromyalgia? | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused |
| 7.11 | DIABETE4 | Has a doctor, nurse, or other health professional ever told you that you have diabetes? | Radio | 1=Yes, 2=Yes, but female told only during pregnancy, 3=No, 4=No, pre-diabetes or borderline diabetes, 7=Don't know/Not sure, 9=Refused |
| 7.12 | DIABAGE4 | How old were you when you were told you have diabetes? | Numeric | 1-97=Age in years, 98=98 or older, 77=Don't know/Not sure, 99=Refused [If DIABETE4 = 1] |

---

### Section 8: Demographics

| # | Variable | Question Text | Type | Response Options |
|---|----------|--------------|------|-----------------|
| 8.1 | SEX | What is your sex? | Radio | 1=Male, 2=Female, 7=Don't know/Not sure, 9=Refused |
| 8.2 | BIRTHSEX | What sex were you assigned at birth? Was it male or female? | Radio | 1=Male, 2=Female, 7=Don't know/Not sure, 9=Refused [If SEX != 7, 9] |
| 8.3 | PREGNANT | To your knowledge, are you now pregnant? | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused [If female and age 18-49] |
| 8.4 | MARITAL | Are you: married, divorced, widowed, separated, never married, or a member of an unmarried couple? | Radio | 1=Married, 2=Divorced, 3=Widowed, 4=Separated, 5=Never married, 6=A member of an unmarried couple, 9=Refused |
| 8.5 | EDUCA | What is the highest grade or year of school you completed? | Radio | 1=Never attended school or only attended kindergarten, 2=Grades 1 through 8 (Elementary), 3=Grades 9 through 11 (Some high school), 4=Grade 12 or GED (High school graduate), 5=College 1 year to 3 years (Some college or technical school), 6=College 4 years or more (College graduate), 9=Refused |
| 8.6 | RENTHOM1 | Do you own or rent your home? | Radio | 1=Own, 2=Rent, 3=Other arrangement, 7=Don't know/Not sure, 9=Refused |
| 8.7 | VETERAN3 | Have you ever served on active duty in the United States Armed Forces, either in the regular military or in a National Guard or military reserve unit? | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused |
| 8.8 | EMPLOY1 | Are you currently: employed for wages, self-employed, out of work for 1 year or more, out of work for less than 1 year, a homemaker, a student, retired, or unable to work? | Radio | 1=Employed for wages, 2=Self-employed, 3=Out of work for 1 year or more, 4=Out of work for less than 1 year, 5=A homemaker, 6=A student, 7=Retired, 8=Unable to work, 9=Refused |
| 8.9 | CHILDREN | How many children less than 18 years of age live in your household? | Numeric | 1-87=Number of children, 88=None, 99=Refused |
| 8.10 | INCOME3 | Is your annual household income from all sources: | Radio | 1=Less than $10,000, 2=$10,000 to less than $15,000, 3=$15,000 to less than $20,000, 4=$20,000 to less than $25,000, 5=$25,000 to less than $35,000, 6=$35,000 to less than $50,000, 7=$50,000 to less than $75,000, 8=$75,000 to less than $100,000, 9=$100,000 to less than $150,000, 10=$150,000 to less than $200,000, 11=$200,000 or more, 77=Don't know/Not sure, 99=Refused |
| 8.11 | WEIGHT2 | About how much do you weigh without shoes? | Numeric | Weight in pounds or kilograms, 7777=Don't know/Not sure, 9999=Refused |
| 8.12 | HEIGHT3 | About how tall are you without shoes? | Numeric | Height in feet/inches or meters/centimeters, 7777=Don't know/Not sure, 9999=Refused |

---

### Section 9: Tobacco Use

| # | Variable | Question Text | Type | Response Options |
|---|----------|--------------|------|-----------------|
| 9.1 | SMOKE100 | Have you smoked at least 100 cigarettes in your entire life? | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused |
| 9.2 | SMOKDAY2 | Do you now smoke cigarettes every day, some days, or not at all? | Radio | 1=Every day, 2=Some days, 3=Not at all, 7=Don't know/Not sure, 9=Refused [If SMOKE100 = 1] |
| 9.3 | STOPSMK2 | During the past 12 months, have you stopped smoking for one day or longer because you were trying to quit smoking? | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused [If SMOKDAY2 = 1 or 2] |
| 9.4 | LASTSMK2 | How long has it been since you last smoked a cigarette, even one or two puffs? | Radio | 1=Within the past month, 2=Within the past 3 months, 3=Within the past 6 months, 4=Within the past year, 5=Within the past 5 years, 6=Within the past 10 years, 7=10 years or more, 8=Never smoked regularly, 77=Don't know/Not sure, 99=Refused [If SMOKDAY2 = 3] |
| 9.5 | USENOW3 | Do you currently use chewing tobacco, snuff, or snus every day, some days, or not at all? | Radio | 1=Every day, 2=Some days, 3=Not at all, 7=Don't know/Not sure, 9=Refused |

---

### Section 10: E-Cigarette Use

| # | Variable | Question Text | Type | Response Options |
|---|----------|--------------|------|-----------------|
| 10.1 | ECIGNOW2 | Do you now use e-cigarettes or other electronic vaping products every day, some days, or not at all? | Radio | 1=Every day, 2=Some days, 3=Not at all, 4=Never used e-cigarettes in my entire life, 7=Don't know/Not sure, 9=Refused |

---

### Section 11: Alcohol Consumption

| # | Variable | Question Text | Type | Response Options |
|---|----------|--------------|------|-----------------|
| 11.1 | ALCDAY4 | During the past 30 days, how many days per week or per month did you have at least one drink of any alcoholic beverage such as beer, wine, a malt beverage, or liquor? | Numeric | 101-107=Days per week, 201-230=Days per month, 888=No drinks in past 30 days, 777=Don't know/Not sure, 999=Refused |
| 11.2 | AVEDRNK3 | One drink is equivalent to a 12-ounce beer, a 5-ounce glass of wine, or a drink with one shot of liquor. During the past 30 days, on the days when you drank, about how many drinks did you drink on the average? | Numeric | 1-76=Number of drinks, 77=Don't know/Not sure, 99=Refused [If ALCDAY4 indicates any drinking] |
| 11.3 | DRNK3GE5 | Considering all types of alcoholic beverages, how many times during the past 30 days did you have 5 or more drinks for men or 4 or more drinks for women on an occasion? | Numeric | 1-76=Number of times, 88=None, 77=Don't know/Not sure, 99=Refused [If ALCDAY4 indicates any drinking] |
| 11.4 | MAXDRNKS | During the past 30 days, what is the most drinks you had on any occasion? | Numeric | 1-76=Number of drinks, 77=Don't know/Not sure, 99=Refused [If ALCDAY4 indicates any drinking] |

---

### Section 12: Immunization

| # | Variable | Question Text | Type | Response Options |
|---|----------|--------------|------|-----------------|
| 12.1 | FLUSHOT7 | During the past 12 months, have you had either a flu vaccine that was sprayed in your nose or a flu shot injected into your arm? | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused |
| 12.2 | FLSHTMY3 | During what month and year did you receive your most recent flu vaccine? | Numeric | Month/Year coded, 777777=Don't know/Not sure, 999999=Refused [If FLUSHOT7 = 1] |
| 12.3 | PNEUVAC4 | Have you ever had a pneumonia shot also known as a pneumococcal vaccine? | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused [If age >= 65] |
| 12.4 | PNEUTYP1 | Was the pneumonia vaccine you received PCV13, also known as Prevnar 13, or was it PPSV23, also known as Pneumovax? | Radio | 1=PCV13 (Prevnar 13), 2=PPSV23 (Pneumovax), 3=Both, 4=Other, 7=Don't know/Not sure, 9=Refused [If PNEUVAC4 = 1] |

---

### Section 13: Falls

| # | Variable | Question Text | Type | Response Options |
|---|----------|--------------|------|-----------------|
| 13.1 | FALL12MN | In the past 12 months, how many times have you fallen? | Numeric | 1-76=Number of times, 88=None, 77=Don't know/Not sure, 99=Refused [If age >= 45] |
| 13.2 | FALLINJ5 | How many of these falls caused an injury? By an injury, we mean the fall caused you to limit your regular activities for at least a day or you went to see a doctor because of the fall. | Radio | 1-76=Number of falls with injury, 88=None, 77=Don't know/Not sure, 99=Refused [If FALL12MN >= 1] |

---

### Section 14: Seatbelt Use

| # | Variable | Question Text | Type | Response Options |
|---|----------|--------------|------|-----------------|
| 14.1 | SEATBELT | How often do you use seatbelts when you ride in a car? | Radio | 1=Always, 2=Nearly always, 3=Sometimes, 4=Seldom, 5=Never, 7=Don't know/Not sure, 8=Never ride in a car, 9=Refused |

---

### Section 15: Drinking and Driving

| # | Variable | Question Text | Type | Response Options |
|---|----------|--------------|------|-----------------|
| 15.1 | DRNKDRV1 | During the past 30 days, how many times have you driven when you've had perhaps too much to drink? | Numeric | 1-76=Number of times, 88=None, 77=Don't know/Not sure, 99=Refused [If ALCDAY4 indicates any drinking] |

---

### Section 16: Breast and Cervical Cancer Screening

| # | Variable | Question Text | Type | Response Options |
|---|----------|--------------|------|-----------------|
| 16.1 | HADMAM | Have you ever had a mammogram? | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused [If female] |
| 16.2 | HOWLONG | How long has it been since you had your last mammogram? | Radio | 1=Within the past year, 2=Within the past 2 years, 3=Within the past 3 years, 4=Within the past 5 years, 5=5 or more years ago, 7=Don't know/Not sure, 9=Refused [If HADMAM = 1] |
| 16.3 | PROFEXAM | A clinical breast exam is when a doctor, nurse, or other health professional feels the breast for lumps. Have you ever had a clinical breast exam? | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused [If female] |
| 16.4 | LENGEXAM | How long has it been since your last breast exam? | Radio | 1=Within the past year, 2=Within the past 2 years, 3=Within the past 3 years, 4=Within the past 5 years, 5=5 or more years ago, 7=Don't know/Not sure, 9=Refused [If PROFEXAM = 1] |
| 16.5 | HADPAP2 | Have you ever had a Pap test? | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused [If female] |
| 16.6 | LASTPAP2 | How long has it been since you had your last Pap test? | Radio | 1=Within the past year, 2=Within the past 2 years, 3=Within the past 3 years, 4=Within the past 5 years, 5=5 or more years ago, 7=Don't know/Not sure, 9=Refused [If HADPAP2 = 1] |
| 16.7 | HPVTEST | An HPV test is sometimes given with the Pap test for cervical cancer screening. Have you ever had an HPV test? | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused [If female] |
| 16.8 | HPLSTTST | How long has it been since you had your last HPV test? | Radio | 1=Within the past year, 2=Within the past 2 years, 3=Within the past 3 years, 4=Within the past 5 years, 5=5 or more years ago, 7=Don't know/Not sure, 9=Refused [If HPVTEST = 1] |

---

### Section 17: Prostate Cancer Screening

| # | Variable | Question Text | Type | Response Options |
|---|----------|--------------|------|-----------------|
| 17.1 | PCPSADK2 | A Prostate-Specific Antigen test, also known as a PSA test, is a blood test used to check men for prostate cancer. Have you ever heard of a PSA test? | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused [If male and age >= 40] |
| 17.2 | PCPSADI1 | Have you ever had a PSA test? | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused [If PCPSADK2 = 1] |
| 17.3 | PCPSARE1 | What was the main reason you had this PSA test — was it part of a routine exam, because of a prostate problem, or because of a family history of prostate cancer? | Radio | 1=Part of a routine exam, 2=Because of a prostate problem, 3=Because of a family history, 4=Other reason, 7=Don't know/Not sure, 9=Refused [If PCPSADI1 = 1] |
| 17.4 | PCPSARS1 | How long has it been since you had your last PSA test? | Radio | 1=Within the past year, 2=Within the past 2 years, 3=Within the past 3 years, 4=Within the past 5 years, 5=5 or more years ago, 7=Don't know/Not sure, 9=Refused [If PCPSADI1 = 1] |

---

### Section 18: Colorectal Cancer Screening

| # | Variable | Question Text | Type | Response Options |
|---|----------|--------------|------|-----------------|
| 18.1 | HADSIGM4 | Sigmoidoscopy and colonoscopy are exams in which a tube is inserted in the rectum to view the colon for signs of cancer or other health problems. Have you ever had either of these exams? | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused [If age >= 45] |
| 18.2 | LASTSIG4 | Was your most recent exam a sigmoidoscopy or a colonoscopy, and how long has it been since you had this exam? | Radio | 1=Sigmoidoscopy within past 5 years, 2=Sigmoidoscopy within past 10 years, 3=Sigmoidoscopy 10+ years ago, 4=Colonoscopy within past 5 years, 5=Colonoscopy within past 10 years, 6=Colonoscopy 10+ years ago, 7=Don't know/Not sure which, 9=Refused [If HADSIGM4 = 1] |
| 18.3 | BLDSTOL | A blood stool test is a test that may use a special kit at home to determine whether the stool contains blood. Have you ever had this test using a home kit? | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused [If age >= 45] |
| 18.4 | LSTBLDS4 | How long has it been since you had your last blood stool test using a home kit? | Radio | 1=Within the past year, 2=Within the past 2 years, 3=Within the past 5 years, 4=5 or more years ago, 7=Don't know/Not sure, 9=Refused [If BLDSTOL = 1] |
| 18.5 | STADVISE | Has a doctor, nurse, or other health professional ever recommended that you be tested for colorectal cancer? | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused [If age >= 45] |
| 18.6 | HADSIGM3 | A CT colonography, also known as a virtual colonoscopy, uses X-rays and computers to produce images of the entire colon. Have you ever had this exam? | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused [If age >= 45] |
| 18.7 | VIRCOLN1 | How long has it been since you had your last CT colonography or virtual colonoscopy? | Radio | 1=Within the past year, 2=Within the past 2 years, 3=Within the past 5 years, 4=5 or more years ago, 7=Don't know/Not sure, 9=Refused [If HADSIGM3 = 1] |

---

### Section 19: HIV/AIDS

| # | Variable | Question Text | Type | Response Options |
|---|----------|--------------|------|-----------------|
| 19.1 | HIVRISK5 | I am going to read you a list. Please tell me if any of the situations apply to you. You have used intravenous drugs in the past year. You have been treated for a sexually transmitted disease or STD in the past year. You have given or received money or drugs in exchange for sex in the past year. You had anal sex without a condom in the past year. | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused |
| 19.2 | HIVTST7 | Have you ever been tested for HIV? Do not count tests you may have had as part of a blood donation. Include testing fluid from your mouth. | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused |
| 19.3 | HIVTSTD3 | Not including blood donations, in what month and year was your last HIV test? | Numeric | Month/Year coded, 777777=Don't know/Not sure, 999999=Refused [If HIVTST7 = 1] |

---

### Section 20: Disability

| # | Variable | Question Text | Type | Response Options |
|---|----------|--------------|------|-----------------|
| 20.1 | DECIDE | Because of a physical, mental, or emotional condition, do you have serious difficulty concentrating, remembering, or making decisions? | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused |
| 20.2 | DIFFWALK | Do you have serious difficulty walking or climbing stairs? | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused |
| 20.3 | DIFFDRES | Do you have difficulty dressing or bathing? | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused |
| 20.4 | DIFFALON | Because of a physical, mental, or emotional condition, do you have difficulty doing errands alone such as visiting a doctor's office or shopping? | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused |
| 20.5 | BLIND | Are you blind or do you have serious difficulty seeing, even when wearing glasses? | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused |
| 20.6 | DEAF | Are you deaf or do you have serious difficulty hearing? | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused |

---

### Emotional Support and Life Satisfaction

| # | Variable | Question Text | Type | Response Options |
|---|----------|--------------|------|-----------------|
| ES.1 | EMTSUPRT | How often do you get the social and emotional support you need? | Radio | 1=Always, 2=Usually, 3=Sometimes, 4=Rarely, 5=Never, 7=Don't know/Not sure, 9=Refused |
| ES.2 | LSATISFY | In general, how satisfied are you with your life? | Radio | 1=Very satisfied, 2=Satisfied, 3=Dissatisfied, 4=Very dissatisfied, 7=Don't know/Not sure, 9=Refused |

---

### Random Child Selection

| # | Variable | Question Text | Type | Response Options |
|---|----------|--------------|------|-----------------|
| RC.1 | RCSBIRTH | What is the birth date of the child? | Numeric | Month/Day/Year, 77/77/7777=Don't know/Not sure, 99/99/9999=Refused [If CHILDREN >= 1] |
| RC.2 | RCSGENDR | Is the child male or female? | Radio | 1=Male, 2=Female, 7=Don't know/Not sure, 9=Refused [If CHILDREN >= 1] |
| RC.3 | RCSRACE | Which one or more of the following would you say is the race of the child? | Radio | 1=White, 2=Black or African American, 3=Asian, 4=Native Hawaiian or Other Pacific Islander, 5=American Indian or Alaska Native, 7=Don't know/Not sure, 8=No additional races, 9=Refused [If CHILDREN >= 1] |
| RC.4 | RCSRLTN2 | What is the child's relationship to you? | Radio | 1=Son/Daughter, 2=Grandchild, 3=Foster child, 4=Sibling, 5=Other child, 9=Refused [If CHILDREN >= 1] |

---

### Childhood Asthma Prevalence

| # | Variable | Question Text | Type | Response Options |
|---|----------|--------------|------|-----------------|
| CA.1 | CASTESSION | Has a doctor, nurse, or other health professional ever told you that the child has asthma? | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused [If CHILDREN >= 1] |
| CA.2 | CASTHNO2 | Does the child still have asthma? | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused [If CASTESSION = 1] |

---

### Module 1: Prediabetes

| # | Variable | Question Text | Type | Response Options |
|---|----------|--------------|------|-----------------|
| M1.1 | PREDIAB2 | Have you ever been told by a doctor or other health professional that you have pre-diabetes or borderline diabetes? | Radio | 1=Yes, 2=Yes, during pregnancy, 3=No, 7=Don't know/Not sure, 9=Refused |
| M1.2 | INSULIN1 | Are you now taking insulin? | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused [If DIABETE4 = 1] |

---

### Module 2: Diabetes

| # | Variable | Question Text | Type | Response Options |
|---|----------|--------------|------|-----------------|
| M2.1 | DIABEDU1 | Have you ever taken a course or class in how to manage your diabetes yourself? | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused [If DIABETE4 = 1] |
| M2.2 | FETEFOO1 | About how often do you check your feet for any sores or irritations? Include times when checked by a family member or other person. | Radio | 1=Every day, 2=Once a week, 3=Once a month, 4=Several times a year, 5=Rarely or never, 77=Don't know/Not sure, 99=Refused [If DIABETE4 = 1] |
| M2.3 | EYEEXAM1 | When was the last time you had an eye exam in which the pupils were dilated? This would have made you temporarily sensitive to bright light. | Radio | 1=Within the past month, 2=Within the past year, 3=Within the past 2 years, 4=2 or more years ago, 7=Don't know/Not sure, 8=Never, 9=Refused [If DIABETE4 = 1] |
| M2.4 | DIABEYE1 | Has a doctor ever told you that diabetes has affected your eyes or that you had retinopathy? | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused [If DIABETE4 = 1] |
| M2.5 | DIABAGE3 | How old were you when you were told you have diabetes? | Numeric | 1-97=Age in years, 98=98 or older, 77=Don't know/Not sure, 99=Refused [If DIABETE4 = 1] |

---

### Module 3: Healthy Days (Symptoms)

| # | Variable | Question Text | Type | Response Options |
|---|----------|--------------|------|-----------------|
| M3.1 | PAINACT3 | During the past 30 days, for about how many days did pain make it hard for you to do your usual activities, such as self-care, work, or recreation? | Numeric | 1-30=Number of days, 88=None, 77=Don't know/Not sure, 99=Refused |
| M3.2 | QLMENTL3 | During the past 30 days, for about how many days have you felt worried, tense, or anxious? | Numeric | 1-30=Number of days, 88=None, 77=Don't know/Not sure, 99=Refused |
| M3.3 | QLSTRES3 | During the past 30 days, for about how many days have you felt you did not get enough rest or sleep? | Numeric | 1-30=Number of days, 88=None, 77=Don't know/Not sure, 99=Refused |
| M3.4 | QLHLTH3 | During the past 30 days, for about how many days have you felt very healthy and full of energy? | Numeric | 1-30=Number of days, 88=None, 77=Don't know/Not sure, 99=Refused |

---

### Module 4: Cardiovascular Health

| # | Variable | Question Text | Type | Response Options |
|---|----------|--------------|------|-----------------|
| M4.1 | CVDASPRN | Do you take aspirin daily or every other day? | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused |
| M4.2 | ASPUNSAF | Has your doctor or other health professional ever told you that taking aspirin may be unsafe for you? | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused |
| M4.3 | CVHEART3 | Has a doctor, nurse, or other health professional ever told you that you had any of the following: a heart attack, also called a myocardial infarction, angina or coronary heart disease, or a stroke? | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused |

---

### Module 5: Oral Health

| # | Variable | Question Text | Type | Response Options |
|---|----------|--------------|------|-----------------|
| M5.1 | DENTEFPC | How long has it been since you last visited a dentist or a dental clinic for any reason? | Radio | 1=Within the past year, 2=Within the past 2 years, 3=Within the past 5 years, 4=5 or more years ago, 7=Don't know/Not sure, 8=Never, 9=Refused |
| M5.2 | RMVTETH5 | How many of your permanent teeth have been removed because of tooth decay or gum disease? Include teeth lost to infection, but do not include teeth lost for other reasons, such as injury or orthodontics. | Radio | 1=1 to 5, 2=6 or more but not all, 3=All, 8=None, 7=Don't know/Not sure, 9=Refused |
| M5.3 | CRGVPRB2 | Have you had any permanent teeth removed due to tooth decay or gum disease in the past 6 months? | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused [If RMVTETH5 = 1 or 2] |
| M5.4 | CSHTDENT | During the past 12 months, was there a time when you needed dental care but could not get it because you could not afford it? | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused |

---

### Module 6: Firearms

| # | Variable | Question Text | Type | Response Options |
|---|----------|--------------|------|-----------------|
| M6.1 | FIREARM5 | Are any firearms now kept in or around your home? Include those kept in a garage, outdoor storage area, car, truck, or other motor vehicle. | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused |
| M6.2 | GUNLOAD | Are any of these firearms now loaded? | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused [If FIREARM5 = 1] |
| M6.3 | GUNSTORE | Are any of these loaded firearms also unlocked? By unlocked, we mean you do not need a key or combination to get the gun or the gun does not have a trigger lock. | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused [If GUNLOAD = 1] |
| M6.4 | GUNLOCK | Are any of the unloaded firearms stored with the ammunition? | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused [If FIREARM5 = 1] |

---

### Module 7: Cancer Survivorship

| # | Variable | Question Text | Type | Response Options |
|---|----------|--------------|------|-----------------|
| M7.1 | CNCRDIFF | What type of cancer was it? | Radio | 1=Breast, 2=Colon or rectum, 3=Cervical, 4=Endometrial (uterus), 5=Head and neck, 6=Kidney, 7=Leukemia, 8=Liver, 9=Lung, 10=Lymphoma, 11=Melanoma, 12=Non-melanoma skin cancer, 13=Ovarian, 14=Pancreatic, 15=Prostate, 16=Stomach, 17=Thyroid, 18=Other, 77=Don't know/Not sure, 99=Refused [If CHCSCNC1 = 1 or CHCOCNC1 = 1] |
| M7.2 | CNCRAGE | At what age were you told that you had cancer? | Numeric | 1-97=Age in years, 98=98 or older, 77=Don't know/Not sure, 99=Refused [If CHCSCNC1 = 1 or CHCOCNC1 = 1] |
| M7.3 | CNCRTYP2 | Are you currently receiving treatment for cancer? | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused [If CHCSCNC1 = 1 or CHCOCNC1 = 1] |

---

### Module 8: Caregiver

| # | Variable | Question Text | Type | Response Options |
|---|----------|--------------|------|-----------------|
| M8.1 | CRGVREL5 | During the past 30 days, did you provide regular care or assistance to a friend or family member who has a health problem or disability? | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused |
| M8.2 | CRGVLNG2 | For how long have you provided care for that person? | Radio | 1=Less than 30 days, 2=1 month to less than 6 months, 3=6 months to less than 2 years, 4=2 years to less than 5 years, 5=5 or more years, 7=Don't know/Not sure, 9=Refused [If CRGVREL5 = 1] |
| M8.3 | CRGVHRS2 | In an average week, how many hours do you provide care or assistance? | Numeric | 1-96=Hours per week, 97=97 or more, 77=Don't know/Not sure, 99=Refused [If CRGVREL5 = 1] |
| M8.4 | CRGVPRB3 | What is the main health problem, long-term illness, or disability that the person you care for has? | Radio | 1=Arthritis/musculoskeletal, 2=Asthma/COPD/lung disease, 3=Cancer, 4=Dementia/Alzheimer's/confusion, 5=Developmental disability, 6=Diabetes, 7=Heart disease/stroke, 8=HIV/AIDS, 9=Mental illness, 10=Substance abuse, 11=Injuries, 12=Old age/frailty, 13=Other, 77=Don't know/Not sure, 99=Refused [If CRGVREL5 = 1] |
| M8.5 | CRGVEXTN | During the past 30 days, has providing this care caused you to have any emotional or physical difficulties? | Radio | 1=Always, 2=Usually, 3=Sometimes, 4=Rarely, 5=Never, 7=Don't know/Not sure, 9=Refused [If CRGVREL5 = 1] |

---

### Module 9: Cognitive Decline

| # | Variable | Question Text | Type | Response Options |
|---|----------|--------------|------|-----------------|
| M9.1 | CIMEMLOS | During the past 12 months, have you experienced confusion or memory loss that is happening more often or is getting worse? | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused [If age >= 45] |
| M9.2 | CDHELP | During the past 12 months, as a result of confusion or memory loss, how often have you needed help with day-to-day activities, such as household chores, shopping, or taking medications? | Radio | 1=Always, 2=Usually, 3=Sometimes, 4=Rarely, 5=Never, 7=Don't know/Not sure, 9=Refused [If CIMEMLOS = 1] |
| M9.3 | CDHOUSE | During the past 12 months, as a result of confusion or memory loss, have you given up day-to-day household activities or chores you used to do? | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused [If CIMEMLOS = 1] |
| M9.4 | CDSOCIAL | During the past 12 months, as a result of confusion or memory loss, have you given up some of the activities that you previously enjoyed such as visiting friends, going to movies, or eating out? | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused [If CIMEMLOS = 1] |
| M9.5 | CDDISCUS | Have you or anyone else discussed your confusion or memory loss with a health care professional? | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused [If CIMEMLOS = 1] |

---

### Module 10: Social Determinants of Health

| # | Variable | Question Text | Type | Response Options |
|---|----------|--------------|------|-----------------|
| M10.1 | FOODSTMP | During the past 12 months, have you received food stamps, also called SNAP, the Supplemental Nutrition Assistance Program, on an EBT card? | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused |
| M10.2 | FOODSEC1 | During the past 12 months, have you worried about having enough food to eat? | Radio | 1=Always, 2=Usually, 3=Sometimes, 4=Rarely, 5=Never, 7=Don't know/Not sure, 9=Refused |
| M10.3 | FOODSEC2 | During the past 12 months, how often was the food you bought not enough and you didn't have money to buy more? | Radio | 1=Always, 2=Usually, 3=Sometimes, 4=Rarely, 5=Never, 7=Don't know/Not sure, 9=Refused |
| M10.4 | LCSRSNNOT | Was there a time during the past 12 months when you needed to see a doctor but could not because of cost, lack of insurance, or other reasons? What was the main reason? | Radio | 1=Could not afford it, 2=No insurance, 3=Doctor would not accept insurance, 4=Could not get an appointment, 5=Could not get there, 6=Other, 7=Don't know/Not sure, 9=Refused |
| M10.5 | MEDREAS | Do you currently have any medical bills that you are paying off over time? | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused |
| M10.6 | HLTHINS | What is the primary source of your health insurance coverage? | Radio | 1=Employer, 2=Purchased myself, 3=Medicare, 4=Medicaid/Medical Assistance, 5=Military/TRICARE/VA, 6=Alaska Native/Indian Health Service, 7=Other government program, 8=Other, 88=No coverage, 77=Don't know/Not sure, 99=Refused |

---

### Module 11: Adverse Childhood Experiences (ACE)

| # | Variable | Question Text | Type | Response Options |
|---|----------|--------------|------|-----------------|
| M11.1 | ACEDEPRS | Did you live with anyone who was depressed, mentally ill, or suicidal? | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused |
| M11.2 | ACEDRINK | Did you live with anyone who was a problem drinker or alcoholic? | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused |
| M11.3 | ACEDRUGS | Did you live with anyone who used illegal street drugs or who abused prescription medications? | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused |
| M11.4 | ACEPRISN | Did you live with anyone who served time or was sentenced to serve time in a prison, jail, or other correctional facility? | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused |
| M11.5 | ACEDIVRC | Were your parents separated or divorced? | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 8=Parents not married, 9=Refused |
| M11.6 | ACEPUNCH | How often did your parents or adults in your home ever slap, hit, kick, punch, or beat each other up? | Radio | 1=Once, 2=More than once, 3=Never, 7=Don't know/Not sure, 9=Refused |
| M11.7 | ACEHURT2 | Not including spanking, before age 18, how often did a parent or adult in your home ever hit, beat, kick, or physically hurt you in any way? | Radio | 1=Once, 2=More than once, 3=Never, 7=Don't know/Not sure, 9=Refused |
| M11.8 | ACETOUCH | How often did anyone at least 5 years older than you or an adult ever touch you sexually? | Radio | 1=Once, 2=More than once, 3=Never, 7=Don't know/Not sure, 9=Refused |
| M11.9 | ACETTHEM | How often did anyone at least 5 years older than you or an adult try to make you touch them sexually? | Radio | 1=Once, 2=More than once, 3=Never, 7=Don't know/Not sure, 9=Refused |
| M11.10 | ACESWEAR | How often did a parent or adult in your home ever swear at you, insult you, or put you down? | Radio | 1=Once, 2=More than once, 3=Never, 7=Don't know/Not sure, 9=Refused |

---

### Module 12: Industry and Occupation

| # | Variable | Question Text | Type | Response Options |
|---|----------|--------------|------|-----------------|
| M12.1 | INDESSION | What kind of business or industry do you work in? | Open text | Text response, 77=Don't know/Not sure, 99=Refused [If currently employed] |
| M12.2 | OCCESSION | What kind of work do you do? | Open text | Text response, 77=Don't know/Not sure, 99=Refused [If currently employed] |
| M12.3 | EMPLOY2 | During the past 12 months, how many hours per week did you usually work at all jobs or businesses? | Numeric | 1-96=Hours per week, 97=97 or more, 77=Don't know/Not sure, 99=Refused [If currently employed] |

---

### Module 13: Physical Activity

| # | Variable | Question Text | Type | Response Options |
|---|----------|--------------|------|-----------------|
| M13.1 | EXERANY3 | During the past month, other than your regular job, did you participate in any physical activities or exercises such as running, calisthenics, golf, gardening, or walking for exercise? | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused |
| M13.2 | EXRACT22 | What type of physical activity or exercise did you spend the most time doing during the past month? | Radio | Activity code list (two-digit codes for specific activities), 77=Don't know/Not sure, 99=Refused [If EXERANY3 = 1] |
| M13.3 | EXEROFT2 | How many times per week or per month did you take part in this activity during the past month? | Numeric | 101-107=Times per week, 201-230=Times per month, 777=Don't know/Not sure, 999=Refused [If EXERANY3 = 1] |
| M13.4 | EXERHMM2 | And when you took part in this activity, for how many minutes or hours did you usually keep at it? | Numeric | 1-600=Minutes, 777=Don't know/Not sure, 999=Refused [If EXERANY3 = 1] |
| M13.5 | EXRACT23 | What other type of physical activity gave you the next most exercise during the past month? | Radio | Activity code list (two-digit codes for specific activities), 77=Don't know/Not sure, 88=No other activity, 99=Refused [If EXERANY3 = 1] |
| M13.6 | EXEROFT3 | How many times per week or per month did you take part in this second activity during the past month? | Numeric | 101-107=Times per week, 201-230=Times per month, 777=Don't know/Not sure, 999=Refused [If EXRACT23 has activity] |
| M13.7 | EXERHMM3 | And when you took part in this second activity, for how many minutes or hours did you usually keep at it? | Numeric | 1-600=Minutes, 777=Don't know/Not sure, 999=Refused [If EXRACT23 has activity] |
| M13.8 | STRENGTH | During the past month, how many times per week or per month did you do physical activities or exercises to STRENGTHEN your muscles? Do not count aerobic activities like walking, running, or bicycling. Count activities using your own body weight like yoga, sit-ups or push-ups and those using weight machines, free weights, or elastic bands. | Numeric | 101-107=Times per week, 201-230=Times per month, 888=None, 777=Don't know/Not sure, 999=Refused |

---

### Module 14: Marijuana Use

| # | Variable | Question Text | Type | Response Options |
|---|----------|--------------|------|-----------------|
| M14.1 | MARIJAN2 | During the past 30 days, on how many days did you use marijuana or cannabis? | Numeric | 1-30=Number of days, 88=None/Did not use, 77=Don't know/Not sure, 99=Refused |
| M14.2 | MRJUSE | When you used marijuana or cannabis during the past 30 days, how did you usually use it? Did you smoke it, eat or drink it, vaporize it, dab it, or use it some other way? | Radio | 1=Smoke it, 2=Eat or drink it, 3=Vaporize it, 4=Dab it, 5=Some other way, 7=Don't know/Not sure, 9=Refused [If MARIJAN2 >= 1] |
| M14.3 | MRJPERSN | During the past 30 days, did you use marijuana or cannabis for medical reasons, non-medical reasons, or both? | Radio | 1=Medical reasons, 2=Non-medical reasons, 3=Both, 7=Don't know/Not sure, 9=Refused [If MARIJAN2 >= 1] |

---

### Module 15: Sexual Orientation and Gender Identity

| # | Variable | Question Text | Type | Response Options |
|---|----------|--------------|------|-----------------|
| M15.1 | SXORIENT | Do you consider yourself to be: straight, that is not gay; lesbian or gay; bisexual? | Radio | 1=Straight, that is not gay, 2=Lesbian or gay, 3=Bisexual, 4=Something else, 7=Don't know/Not sure, 9=Refused |
| M15.2 | TRNSGNDR | Do you consider yourself to be transgender? | Y/N | 1=Yes, transgender male-to-female, 2=Yes, transgender female-to-male, 3=Yes, transgender gender nonconforming, 4=No, 7=Don't know/Not sure, 9=Refused |

---

### Module 16: Social Isolation

| # | Variable | Question Text | Type | Response Options |
|---|----------|--------------|------|-----------------|
| M16.1 | SOCISOL1 | How often do you feel lonely or isolated from those around you? | Radio | 1=Always, 2=Usually, 3=Sometimes, 4=Rarely, 5=Never, 7=Don't know/Not sure, 9=Refused |
| M16.2 | SOCISOL2 | How often do you feel that you lack companionship? | Radio | 1=Always, 2=Usually, 3=Sometimes, 4=Rarely, 5=Never, 7=Don't know/Not sure, 9=Refused |
| M16.3 | SOCISOL3 | How often do you feel left out? | Radio | 1=Always, 2=Usually, 3=Sometimes, 4=Rarely, 5=Never, 7=Don't know/Not sure, 9=Refused |
| M16.4 | SOCISOL4 | How often do you feel isolated from others? | Radio | 1=Always, 2=Usually, 3=Sometimes, 4=Rarely, 5=Never, 7=Don't know/Not sure, 9=Refused |

---

### Module 17: Long COVID

| # | Variable | Question Text | Type | Response Options |
|---|----------|--------------|------|-----------------|
| M17.1 | COVIDSMP | Has a doctor or other health professional ever told you that you had COVID-19, or did you ever have a positive COVID-19 test? | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused |
| M17.2 | COVIDPRM | Did you have any symptoms lasting 3 months or longer that you did not have prior to having COVID-19? This is sometimes called long COVID. | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused [If COVIDSMP = 1] |
| M17.3 | COVIDACT | Do these long-term symptoms reduce your ability to carry out day-to-day activities compared with the time before you had COVID-19? | Radio | 1=Yes, a lot, 2=Yes, a little, 3=Not at all, 7=Don't know/Not sure, 9=Refused [If COVIDPRM = 1] |

---

### Module 18: Mpox

| # | Variable | Question Text | Type | Response Options |
|---|----------|--------------|------|-----------------|
| M18.1 | MPOXKNOW | Have you heard of mpox, previously known as monkeypox? | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused |
| M18.2 | MPOXVACC | Have you received one or more doses of a mpox vaccine? | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused [If MPOXKNOW = 1] |

---

### Module 19: Shingles

| # | Variable | Question Text | Type | Response Options |
|---|----------|--------------|------|-----------------|
| M19.1 | SHINGLE2 | Have you ever had shingles, also called herpes zoster? | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused |
| M19.2 | SHNGLVAC | Have you ever had a shingles vaccine? | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused |
| M19.3 | SHNGLTYP | Which shingles vaccine did you receive? Was it Zostavax or Shingrix? | Radio | 1=Zostavax, 2=Shingrix, 3=Both, 7=Don't know/Not sure, 9=Refused [If SHNGLVAC = 1] |

---

### Module 20: Opioid Use

| # | Variable | Question Text | Type | Response Options |
|---|----------|--------------|------|-----------------|
| M20.1 | OPIOIDRX | During the past 12 months, were you prescribed any opioid pain medication such as hydrocodone, oxycodone, codeine, tramadol, morphine, or fentanyl? | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused |
| M20.2 | OPIOIDUS | During the past 12 months, did you use the prescribed opioid medication more frequently or in higher doses than directed, or did you use someone else's opioid medication? | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused [If OPIOIDRX = 1] |
| M20.3 | NALOXONE | Naloxone, also known as Narcan, is a medication that reverses the effects of an opioid overdose. Do you have naloxone available at home, in your car, or with you? | Y/N | 1=Yes, 2=No, 7=Don't know/Not sure, 9=Refused |

---

## TOTAL UNIQUE QUESTION NODES

| Category | Count |
|----------|-------|
| Core Section 1: Health Status | 1 |
| Core Section 2: Healthy Days | 3 |
| Core Section 3: Health Care Access | 4 |
| Core Section 4: Inadequate Sleep | 1 |
| Core Section 5: Hypertension Awareness | 3 |
| Core Section 6: Cholesterol Awareness | 4 |
| Core Section 7: Chronic Health Conditions | 12 |
| Core Section 8: Demographics | 12 |
| Core Section 9: Tobacco Use | 5 |
| Core Section 10: E-Cigarette Use | 1 |
| Core Section 11: Alcohol Consumption | 4 |
| Core Section 12: Immunization | 4 |
| Core Section 13: Falls | 2 |
| Core Section 14: Seatbelt Use | 1 |
| Core Section 15: Drinking and Driving | 1 |
| Core Section 16: Breast and Cervical Cancer Screening | 8 |
| Core Section 17: Prostate Cancer Screening | 4 |
| Core Section 18: Colorectal Cancer Screening | 7 |
| Core Section 19: HIV/AIDS | 3 |
| Core Section 20: Disability | 6 |
| Emotional Support and Life Satisfaction | 2 |
| Random Child Selection | 4 |
| Childhood Asthma Prevalence | 2 |
| Module 1: Prediabetes | 2 |
| Module 2: Diabetes | 5 |
| Module 3: Healthy Days (Symptoms) | 4 |
| Module 4: Cardiovascular Health | 3 |
| Module 5: Oral Health | 4 |
| Module 6: Firearms | 4 |
| Module 7: Cancer Survivorship | 3 |
| Module 8: Caregiver | 5 |
| Module 9: Cognitive Decline | 5 |
| Module 10: Social Determinants of Health | 6 |
| Module 11: Adverse Childhood Experiences (ACE) | 10 |
| Module 12: Industry and Occupation | 3 |
| Module 13: Physical Activity | 8 |
| Module 14: Marijuana Use | 3 |
| Module 15: Sexual Orientation and Gender Identity | 2 |
| Module 16: Social Isolation | 4 |
| Module 17: Long COVID | 3 |
| Module 18: Mpox | 2 |
| Module 19: Shingles | 3 |
| Module 20: Opioid Use | 3 |
| **TOTAL** | **176** |
