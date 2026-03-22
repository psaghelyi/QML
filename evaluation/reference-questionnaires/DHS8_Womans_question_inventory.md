# DHS-8 Model Woman's Questionnaire - Question Inventory

## Document Overview
- **Title**: Demographic and Health Surveys Model Woman's Questionnaire
- **Organization**: Demographic and Health Surveys (DHS) Program
- **Date**: 14 Feb 2023
- **Pages**: 71 (W-1 through W-71)
- **Language**: English
- **Type**: Interviewer-administered household survey questionnaire for women age 15-49, covering reproductive health, contraception, maternal/child health, HIV/AIDS, and related topics (DHSQ8)

## Structure
The questionnaire consists of a cover page with identification and interviewer visit tracking, an introduction and consent section, 11 substantive sections organized by topic, a contraceptive calendar (72 months), and interviewer/supervisor observation pages. Sections use a numbering system where the first digit(s) indicate the section (e.g., 1xx = Section 1, 10xx = Section 10). Many sections contain CHECK filters (interviewer routing instructions), looped sub-sections (per pregnancy, per child), and extensive skip patterns.

## Question Inventory by Section

### Introduction and Consent (p. W-2) - 2 questions
1. Q_CONSENT: Respondent agrees to be interviewed - Radio: 1=Respondent agrees to be interviewed, 2=Respondent does not agree to be interviewed [If 2, END]
2. Q_102_TIME: Record the time - Numeric: Hours, Minutes

### Section 1. Respondent's Background (pp. W-2 to W-4) - 27 questions
1. Q_102: What [province/region/state] were you born in? - Radio: 01=[Province/Region/State], 02=[Province/Region/State], 03=[Province/Region/State], 96=Outside of [Country] [If not 96, skip to 104]
2. Q_103: What country were you born in? - Open text: Country
3. Q_104: How long have you been living continuously in (name of current city, town or village of residence)? - Numeric: Years; 95=Always, 96=Visitor [If 95 or 96, skip to 110]
4. Q_105: CHECK 104 - Filter: 00-04 years -> continue; 05 years or more -> skip to 107
5. Q_106: In what month and year did you move here? - Numeric: Month (98=Don't know month), Year (9998=Don't know year)
6. Q_107: Just before you moved here, which [province/region/state] did you live in? - Radio: 01=[Province/Region/State], 02=[Province/Region/State], 03=[Province/Region/State], 96=Outside of [Country]
7. Q_108: Just before you moved here, did you live in a city, in a town, or in a rural area? - Radio: 1=City, 2=Town, 3=Rural area
8. Q_109: Why did you move to this place? - Radio: 01=Employment, 02=Education/Training, 03=Marriage formation, 04=Family reunification/other family-related reason, 05=Forced displacement, 96=Other (specify)
9. Q_110: In what month and year were you born? - Numeric: Month (98=Don't know month), Year (9998=Don't know year)
10. Q_111: How old were you at your last birthday? - Numeric: Age in completed years
11. Q_112: In general, would you say your health is very good, good, moderate, bad, or very bad? - Radio: 1=Very good, 2=Good, 3=Moderate, 4=Bad, 5=Very bad
12. Q_113: Have you ever attended school? - Y/N: 1=Yes, 2=No [If No, skip to 117]
13. Q_114: What is the highest level of school you attended: primary, secondary, or higher? - Radio: 1=Primary, 2=Secondary, 3=Higher
14. Q_115: What is the highest [grade/form/year] you completed at that level? - Numeric: [Grade/Form/Year]
15. Q_116: CHECK 114 - Filter: Primary or Secondary -> continue; Higher -> skip to 119
16. Q_117: Now I would like you to read this sentence to me (literacy test) - Radio: 1=Cannot read at all, 2=Able to read only part of the sentence, 3=Able to read whole sentence, 4=No card with required language (specify), 5=Blind/visually impaired
17. Q_118: CHECK 117 - Filter: Code 2/3/4 -> continue; Code 1 or 5 -> skip to 120
18. Q_119: Do you read a newspaper or magazine at least once a week, less than once a week or not at all? - Radio: 1=At least once a week, 2=Less than once a week, 3=Not at all
19. Q_120: Do you listen to the radio at least once a week, less than once a week or not at all? - Radio: 1=At least once a week, 2=Less than once a week, 3=Not at all
20. Q_121: Do you watch television at least once a week, less than once a week or not at all? - Radio: 1=At least once a week, 2=Less than once a week, 3=Not at all
21. Q_122: Do you own a mobile phone? - Y/N: 1=Yes, 2=No [If No, skip to 127]
22. Q_123: Is your mobile phone a smart phone? - Y/N: 1=Yes, 2=No
23. Q_127: Have you ever used the Internet from any location on any device? - Y/N: 1=Yes, 2=No [If No, skip to 130]
24. Q_128: In the last 12 months, have you used the Internet? - Y/N: 1=Yes, 2=No [If No, skip to 130]
25. Q_129: During the last one month, how often did you use the Internet? - Radio: 1=Almost every day, 2=At least once a week, 3=Less than once a week, 4=Not at all
26. Q_130: What is your religion? - Radio: 01=[Religion], 02=[Religion], 03=[Religion], 96=Other (specify)
27. Q_131: What is your ethnic group? - Radio: 01=[Ethnic group], 02=[Ethnic group], 03=[Ethnic group], 96=Other (specify)

### Section 2. Reproduction (pp. W-5 to W-9) - 32 questions
1. Q_201: Have you ever given birth? - Y/N: 1=Yes, 2=No [If No, skip to 206]
2. Q_202: Do you have any sons or daughters to whom you have given birth who are now living with you? - Y/N: 1=Yes, 2=No [If No, skip to 204]
3. Q_203a: How many sons live with you? - Numeric: Sons at home
4. Q_203b: And how many daughters live with you? - Numeric: Daughters at home
5. Q_204: Do you have any sons or daughters to whom you have given birth who are alive but do not live with you? - Y/N: 1=Yes, 2=No [If No, skip to 206]
6. Q_205a: How many sons are alive but do not live with you? - Numeric: Sons elsewhere
7. Q_205b: And how many daughters are alive but do not live with you? - Numeric: Daughters elsewhere
8. Q_206: Have you ever given birth to a boy or girl who was born alive but later died? - Y/N: 1=Yes, 2=No [If No, skip to 208]
9. Q_207a: How many boys have died? - Numeric: Boys dead
10. Q_207b: And how many girls have died? - Numeric: Girls dead
11. Q_208: SUM ANSWERS TO 203, 205, AND 207. TOTAL LIVE BIRTHS - Numeric: Total live births
12. Q_209: Confirmation of total births - Y/N: Yes/No [If No, probe and correct 201-208]
13. Q_210: Have you ever had a pregnancy that did not end in a live birth? - Y/N: 1=Yes, 2=No [If No, skip to 212]
14. Q_211: How many miscarriages, abortions, and stillbirths have you had? - Numeric: Pregnancy losses
15. Q_212: SUM ANSWERS TO 208 AND 211. TOTAL PREGNANCY OUTCOMES - Numeric: Total pregnancy outcomes
16. Q_213: CHECK 212 - Filter: One or more past pregnancies -> continue; No past pregnancies -> skip to 232
17. Q_214: Pregnancy history table introduction - Instruction
18. Q_215: Was that a single pregnancy, twins, or triplets? (per pregnancy row) - Radio: 1=Single, 2=Twins, 3=Triplets, 4=Quadruplets, 5=Quintuplets
19. Q_216: Was the baby born alive, born dead, or did you have a miscarriage or abortion? (per row) - Radio: 1=Born alive, 2=Born dead, 3=Miscarriage, 4=Abortion [If 3 or 4, skip to 220]
20. Q_217: Did the baby cry, move, or breathe? (per row) - Y/N: 1=Yes, 2=No [If No, skip to 220]
21. Q_218: What name was given to the baby? (per row) - Open text: Name
22. Q_219: Is (NAME) a boy or a girl? (per row) - Radio: 1=Boy, 2=Girl
23. Q_220: CHECK 216 AND 217: Type of pregnancy outcome (per row) - Computed: Born alive date / Born dead/miscarriage/abortion date
24. Q_221: How long did this pregnancy last in weeks or months? (per row) - Numeric: Weeks (1) or Months (2)
25. Q_222: Were there any other pregnancies before/between this pregnancy? (per row) - Y/N: 1=Yes (add pregnancy), 2=No (next row)
26. Q_222A: Have you had any pregnancies that ended since the last pregnancy? - Y/N: 1=Yes (add to table), 2=No
27. Q_222B: Pregnancy history verification - Instruction
28. Q_223: CHECK 216, 217 AND 221: Pregnancy outcome classification (per row) - Filter
29. Q_224: Is (NAME) still alive? (per row) - Y/N: 1=Yes, 2=No [If No, skip to 228]
30. Q_225: How old was (NAME) at his/her last birthday? (per row) - Numeric: Age in completed years
31. Q_226: Is (NAME) living with you? (per row) - Y/N: 1=Yes (record household line number), 2=No [If No, skip to 223 in next row]
32. Q_227: Record household line number of child (per row) - Numeric: Household line number
33. Q_228: How old was (NAME) when he/she died? (per row, if 224=No) - Numeric: Days/Months/Years
34. Q_230: COMPARE 212 WITH NUMBER OF PREGNANCY OUTCOMES IN PREGNANCY HISTORY - Filter
35. Q_231: Calendar entry instruction for births and pregnancies - Instruction (calendar)
36. Q_232: Are you pregnant now? - Radio: 1=Yes, 2=No, 8=Unsure [If 2 or 8, skip to 236]
37. Q_233: How many weeks or months pregnant are you? - Numeric: Weeks (1) or Months (2)
38. Q_234: When you got pregnant, did you want to get pregnant at that time? - Y/N: 1=Yes, 2=No [If Yes, skip to 236]
39. Q_235: CHECK 208: Total number of live births - Filter: One or more -> 235a; None -> 235b; Radio: 1=Later, 2=No more/None
40. Q_236: When did your last menstrual period start? - Radio: 1=Days ago, 2=Weeks ago, 3=Months ago, 4=Years ago, 994=In menopause/has had hysterectomy, 995=Before last pregnancy, 996=Never menstruated [If 994/995, skip to 240; If 996, skip to 241]
41. Q_237: CHECK 236: Was the last menstrual period within the last year? - Filter: Yes within last year -> continue; No, one year or more -> skip to 240
42. Q_238: During your last menstrual period, what did you use to collect or absorb your menstrual blood? - Checkbox: A=Reusable sanitary pads, B=Disposable sanitary pads, C=Tampons, D=Menstrual cup, E=Cloth, F=Toilet paper, G=Cotton wool, H=Underwear only, X=Other (specify), Y=Nothing
43. Q_239: During your last menstrual period, were you able to wash and change in privacy while at home? - Radio: 1=Yes, 2=No, 3=Away from home during last menstrual period
44. Q_240: How old were you when you had your first menstrual period? - Numeric: Age (98=Don't know)
45. Q_241: From one menstrual period to the next, are there certain days when a woman is more likely to become pregnant? - Radio: 1=Yes, 2=No, 8=Don't know [If 2 or 8, skip to 243]
46. Q_242: Is this time just before her period begins, during her period, right after her period has ended, or halfway between two periods? - Radio: 1=Just before her period begins, 2=During her period, 3=Right after her period has ended, 4=Halfway between two periods, 6=Other (specify), 8=Don't know
47. Q_243: After the birth of a child, can a woman become pregnant before her menstrual period has returned? - Radio: 1=Yes, 2=No, 8=Don't know

### Section 3. Contraception (pp. W-10 to W-18) - 49 questions
1. Q_301: Introduction to family planning - Instruction
2. Q_301_01: Have you heard of Female Sterilization? - Y/N: 1=Yes, 2=No
3. Q_301_02: Have you heard of Male Sterilization? - Y/N: 1=Yes, 2=No
4. Q_301_03: Have you heard of IUD? - Y/N: 1=Yes, 2=No
5. Q_301_04: Have you heard of Injectables? - Y/N: 1=Yes, 2=No
6. Q_301_05: Have you heard of Implants? - Y/N: 1=Yes, 2=No
7. Q_301_06: Have you heard of Pill? - Y/N: 1=Yes, 2=No
8. Q_301_07: Have you heard of Condom? - Y/N: 1=Yes, 2=No
9. Q_301_08: Have you heard of Female Condom? - Y/N: 1=Yes, 2=No
10. Q_301_09: Have you heard of Emergency Contraception? - Y/N: 1=Yes, 2=No
11. Q_301_10: Have you heard of Standard Days Method? - Y/N: 1=Yes, 2=No
12. Q_301_11: Have you heard of Lactational Amenorrhea Method (LAM)? - Y/N: 1=Yes, 2=No
13. Q_301_12: Have you heard of Rhythm Method? - Y/N: 1=Yes, 2=No
14. Q_301_13: Have you heard of Withdrawal? - Y/N: 1=Yes, 2=No
15. Q_301_14: Have you heard of any other ways or methods? - Radio: A=Yes modern method (specify), B=Yes traditional method (specify), Y=No
16. Q_302: CHECK 232 - Filter: Not pregnant or unsure -> continue; Pregnant -> skip to 317
17. Q_303: Are you or your partner currently doing something or using any method to delay or avoid getting pregnant? - Y/N: 1=Yes, 2=No [If Yes, skip to 307]
18. Q_304: Are you or your partner sterilized? - Radio: 1=Yes respondent sterilized only, 2=Yes partner sterilized only, 3=Yes both sterilized, 4=No neither sterilized [If 4, skip to 306]
19. Q_305: CHECK 304 - Filter: Routes to 307 based on sterilization status
20. Q_306: Just to check, are you or your partner doing any of the following to avoid pregnancy? - Y/N: 1=Yes, 2=No [If No, skip to 317]
21. Q_307: Which method are you using? - Checkbox/Radio: A=Female sterilization, B=Male sterilization, C=IUD, D=Injectables, E=Implants, F=Pill, G=Condom, H=Female condom, I=Emergency contraception, J=Standard days method, K=Lactational amenorrhea method, L=Rhythm method, M=Withdrawal, X=Other modern method, Y=Other traditional method [Skip varies by method: A/B->312, C/E->314, D->314, F->310, G->311, others->314]
22. Q_308: Type of injectable used (show pictures) - Radio: 1=DMPA-SC/Sayana Press, 2=Needle and syringe, 8=Don't know [If 2 or 8, skip to 314]
23. Q_309: Did you inject DMPA-SC/Sayana Press yourself or did a health care provider do it? - Radio: 1=Self-injection, 2=Injection given by health care provider, 8=Don't know [Skip to 314]
24. Q_310: What is the brand name of the pills you are using? - Radio: 01=Brand A, 02=Brand B, 03=Brand C, 96=Other (specify), 98=Don't know [Skip to 314]
25. Q_311: What is the brand name of the condoms you are using? - Radio: 01=Brand A, 02=Brand B, 03=Brand C, 96=Other (specify), 98=Don't know [Skip to 314]
26. Q_312: In what facility did the sterilization take place? - Radio: Public sector (11-16), Private medical sector (21-26), NGO medical sector (31-36), 96=Other, 98=Don't know
27. Q_313: In what month and year was the sterilization performed? - Numeric: Month, Year [Skip to 315]
28. Q_314: Since what month and year have you been using (METHOD) without stopping? - Numeric: Month, Year
29. Q_315: CHECK 313 AND 314 AND 220: Any birth/pregnancy after start of use? - Filter: No -> continue; Yes -> go back to 313/314
30. Q_316: CHECK 313 AND 314: Calendar entry - Filter (Calendar instruction)
31. Q_317: Calendar probing for contraceptive use history - Instruction (Calendar)
32. Q_317A: Month and year of start of interval of use or non-use - Numeric: Month, Year
33. Q_317B: Between (EVENT ONE) and (EVENT TWO), did you or your partner use any method? - Y/N: 1=Yes, 2=No [If No, skip to 317I]
34. Q_317C: Which method was that? - Numeric: Method code
35. Q_317D: How many months after (EVENT ONE) did you start to use the (METHOD)? - Numeric: 00=Immediately, Months, 95=Date given [If 00, skip to 317F]
36. Q_317E: Record month and year respondent started using method - Numeric: Month, Year
37. Q_317F: For how many months did you use the (METHOD) continuously? - Numeric: Months, 95=Date given [Skip to 317H]
38. Q_317G: Record month and year respondent stopped using method - Numeric: Month, Year
39. Q_317H: Why did you stop using (METHOD)? - Numeric: Reason stopped
40. Q_317I: GO BACK TO 317A FOR NEXT GAP; OR, IF NO MORE GAPS, GO TO 318 - Loop control
41. Q_318: Have you used emergency contraception in the last 12 months? - Y/N: 1=Yes, 2=No
42. Q_319: CHECK THE CALENDAR FOR USE OF ANY CONTRACEPTIVE METHOD - Filter: No method used -> continue; Any method used -> skip to 321
43. Q_320: Have you ever used anything or tried in any way to delay or avoid getting pregnant? - Y/N: 1=Yes, 2=No [If No, skip to 331]
44. Q_321: CHECK 307: Circle method code (highest method in list) - Radio: 00=No code circled (->331), 01=Female sterilization (->324), 02=Male sterilization (->332), 03-13=various methods (->332), 95=Other modern (->332), 96=Other traditional (->332)
45. Q_322: Where did you first started using (METHOD)? Where did you get it? - Radio: Public sector (11-16), Private medical sector (21-27), NGO medical sector (31-36), Other source (41-43), 96=Other
46. Q_323: At that time, were you told about side effects or problems you might have with the method? - Y/N: 1=Yes, 2=No [If Yes, skip to 325]
47. Q_324: When you got sterilized, were you told about side effects or problems you might have with the method? - Y/N: 1=Yes, 2=No
48. Q_325: Were you told what to do if you experienced side effects or problems? - Y/N: 1=Yes, 2=No
49. Q_326: At that time, were you told about other methods of family planning that you could use? - Y/N: 1=Yes, 2=No
50. Q_327: CHECK 307: Circle method code - Filter: 01=Female sterilization (->332), 03-10/95=various methods (->332)
51. Q_328: At that time, were you told that you could switch to another method if you wanted to or needed to? - Y/N: 1=Yes, 2=No [If Yes, skip to 330]
52. Q_329: CHECK 307: Circle method code - Radio: 01-02=Sterilization (->332), 03-13/95-96=various methods (->332)
53. Q_330: Where did you obtain (METHOD) the last time? - Radio: Public sector (11-16), Private medical sector (21-27), NGO medical sector (31-36), Other source (41-43), 96=Other [Skip to 332]
54. Q_331: Do you know of a place where you can obtain a method of family planning? - Y/N: 1=Yes, 2=No
55. Q_332: In the last 12 months, were you visited by a fieldworker? - Y/N: 1=Yes, 2=No [If No, skip to 334]
56. Q_333: Did the fieldworker talk to you about family planning? - Y/N: 1=Yes, 2=No
57. Q_334: CHECK 202: Children living with respondent - Filter: Yes -> 334a; No -> 334b; Y/N: 1=Yes, 2=No [If No, skip to 401]
58. Q_335: Did any staff member at the health facility speak to you about family planning methods? - Y/N: 1=Yes, 2=No

### Section 4. Pregnancy and Postnatal Care (pp. W-19 to W-32) - 80 questions
1. Q_401: CHECK 220 AND 225: Any pregnancy outcomes 0-35 months before the survey? - Filter: One or more -> continue; None -> skip to 601
2. Q_402: CHECK 220: List pregnancy history numbers and classify by type - Table: Up to 8 entries (Pregnancy history number, Pregnancy outcome type 1-5)
3. Q_403: Introduction to pregnancy questions - Instruction
4. Q_404: Pregnancy history number from 402 - Numeric: Pregnancy history number
5. Q_405: Pregnancy outcome type from 402 - Radio: 1=Most recent live birth, 2=Prior live birth, 3=Most recent stillbirth, 4=Prior stillbirth, 5=Miscarriage/Abortion [If 1 or 2, skip to 407; If 3 or 4, skip to 407; If 5, skip to 475]
6. Q_406: Record date pregnancy ended from 220 - Numeric: Day, Month, Year [Skip to 408]
7. Q_407: Record name from 218 - Open text: Name
8. Q_408: CHECK 405: Pregnancy type 1 or 2 vs 3, 4, or 5 - Filter with question: Did you want to get pregnant at that time? - Y/N: 1=Yes, 2=No [If Yes, skip to 411]
9. Q_409: Did you want to have a baby later on, or not at all? - Radio: 1=Later, 2=Not at all [If 2, skip to 411]
10. Q_410: How much longer did you want to wait? - Numeric: Months (1), Years (2), 998=Don't know
11. Q_411: CHECK 405: Pregnancy outcome type - Filter: Type 1 -> continue; Type 2 -> skip to 434; Type 3 -> continue; Type 4 -> skip to 434; Type 5 -> skip to 475
12. Q_412: Did you see anyone for antenatal care for this pregnancy? - Y/N: 1=Yes, 2=No [If Yes, skip to 414]
13. Q_413: CHECK 405: Pregnancy outcome type - Filter: Most recent live birth -> skip to 420; Most recent stillbirth -> skip to 426
14. Q_414: Whom did you see? (ANC provider) - Checkbox: A=Doctor, B=Nurse/Midwife, C=Auxiliary midwife, D=Traditional birth attendant, E=Community health worker/field worker, X=Other (specify)
15. Q_415: Where did you receive antenatal care for this pregnancy? - Checkbox: Home (A-B), Public sector (C-F), Private medical sector (G-I), NGO medical sector (J-L), X=Other (specify)
16. Q_416: How many weeks or months pregnant were you when you first received antenatal care? - Numeric: Weeks (1), Months (2), 998=Don't know
17. Q_417: How many times did you receive antenatal care during this pregnancy? - Numeric: Number of times, 98=Don't know
18. Q_418a: As part of ANC, did a healthcare provider measure your blood pressure? - Radio: 1=Yes, 2=No, 8=Don't know
19. Q_418b: Take a urine sample? - Radio: 1=Yes, 2=No, 8=Don't know
20. Q_418c: Take a blood sample? - Radio: 1=Yes, 2=No, 8=Don't know
21. Q_418d: Listen to the baby's heartbeat? - Radio: 1=Yes, 2=No, 8=Don't know
22. Q_418e: Talk with you about which foods or how much food you should eat? - Radio: 1=Yes, 2=No, 8=Don't know
23. Q_418f: Talk with you about breastfeeding? - Radio: 1=Yes, 2=No, 8=Don't know
24. Q_418g: Ask you if you had vaginal bleeding? - Radio: 1=Yes, 2=No, 8=Don't know
25. Q_419: CHECK 405: Pregnancy outcome type - Filter: Most recent live birth -> continue; Most recent stillbirth -> skip to 426
26. Q_420: Were you given an injection in the arm to prevent the baby from getting tetanus after birth? - Y/N: 1=Yes, 2=No, 8=Don't know [If 2 or 8, skip to 423]
27. Q_421: How many times did you get a tetanus injection during this pregnancy? - Numeric: Times, 8=Don't know
28. Q_422: CHECK 421 - Filter: One time or DK -> continue; Two or more times -> skip to 426
29. Q_423: At any time before this pregnancy, did you receive any tetanus injections? - Y/N: 1=Yes, 2=No, 8=Don't know [If 2 or 8, skip to 426]
30. Q_424: Before this pregnancy, how many times did you receive a tetanus injection? - Numeric: Times, 8=Don't know
31. Q_425: CHECK 424 - Filter: Only one -> 425a (years ago last injection); More than one -> 425b (years ago last injection prior to pregnancy)
32. Q_426: Were you given or did you buy any iron tablets or iron syrup? - Y/N: 1=Yes, 2=No, 8=Don't know [If 2 or 8, skip to 429]
33. Q_427: Where did you get the iron tablets or syrup? - Checkbox: Public sector (A-F), Private medical sector (G-M), NGO medical sector (N-P), Other source (Q-S), X=Other
34. Q_428: For how many days did you take the iron tablets or syrup? - Numeric: Days, 998=Don't know
35. Q_429: Did you take any medicine for intestinal worms? - Y/N: 1=Yes, 2=No, 8=Don't know
36. Q_430: Did you receive food or cash assistance through [program name]? - Y/N: 1=Yes, 2=No, 8=Don't know
37. Q_431: Did you take SP/Fansidar to keep you from getting malaria? - Y/N: 1=Yes, 2=No, 8=Don't know [If 2 or 8, skip to 434]
38. Q_432: How many times did you take SP/Fansidar during this pregnancy? - Numeric: Times
39. Q_433: Did you get the SP/Fansidar during any antenatal care visit, during another visit to a health facility or from another source? - Radio: 1=Antenatal visit, 2=Another facility visit, 6=Other source
40. Q_434: CHECK 405: Who assisted with the delivery? - Checkbox: A=Doctor, B=Nurse/Midwife, C=Auxiliary midwife, D=Traditional birth attendant, E=Relative/Friend, X=Other (specify), Y=No one assisted
41. Q_435: CHECK 405: Where did you give birth/deliver stillbirth? - Radio: Home (11-12), Public sector (21-23, 26), Private medical sector (31-32, 36), NGO medical sector (41-42, 46), 96=Other [If 11/12, skip to 437; If 96, skip to 437]
42. Q_436: CHECK 405: Was this delivered by caesarean? - Y/N: 1=Yes, 2=No
43. Q_437: CHECK 405: Pregnancy outcome type - Radio: 1=Most recent live birth, 2=Prior live birth (->441), 3=Most recent stillbirth (->445), 4=Prior stillbirth (->487)
44. Q_438: After the birth, was (NAME) put on your chest? - Y/N: 1=Yes, 2=No, 8=Don't know [If 2 or 8, skip to 441]
45. Q_439: Was (NAME)'s bare skin touching your bare skin? - Y/N: 1=Yes, 2=No, 8=Don't know [If 2 or 8, skip to 441]
46. Q_440: How long after birth was (NAME) put on the bare skin of your chest? - Numeric: 00=Immediately, Hours
47. Q_441: When (NAME) was born, was (NAME) very large, larger than average, average, smaller than average, or very small? - Radio: 1=Very large, 2=Larger than average, 3=Average, 4=Smaller than average, 5=Very small, 8=Don't know
48. Q_442: Was (NAME) weighed at birth? - Y/N: 1=Yes, 2=No, 8=Don't know [If 2 or 8, skip to 444]
49. Q_443: How much did (NAME) weigh? - Numeric: KG from card (1), KG from recall (2), 99998=Don't know
50. Q_444: CHECK 405: Pregnancy outcome type - Filter: Most recent live birth -> continue; Prior live birth -> skip to 480
51. Q_445: CHECK 435: Place of delivery - Filter: Facility birth (21-46) -> continue; Home/Other (11/12/96) -> skip to 464
52. Q_447: CHECK 405: How long after (NAME) was delivered did you stay in the (FACILITY)? - Numeric: Hours (1), Days (2), Weeks (3), 998=Don't know
53. Q_448: Before you left the facility, did anyone check on your health? - Y/N: 1=Yes, 2=No [If No, skip to 451]
54. Q_449: How long after delivery did the first check take place? - Numeric: Hours (1), Days (2), Weeks (3), 998=Don't know
55. Q_450: Who checked on your health at that time? - Radio: 11=Doctor, 12=Nurse/Midwife, 13=Auxiliary midwife, 21=Traditional birth attendant, 22=Community health worker/field worker, 96=Other (specify)
56. Q_451: CHECK 405: Pregnancy outcome type - Filter: Most recent live birth -> continue; Most recent stillbirth -> skip to 455
57. Q_452: Before (NAME) left the facility, did anyone check on (NAME)'s health? - Y/N: 1=Yes, 2=No, 8=Don't know [If 2 or 8, skip to 455]
58. Q_453: How long after delivery was (NAME)'s health first checked? - Numeric: Hours (1), Days (2), Weeks (3), 998=Don't know
59. Q_454: Who checked on (NAME)'s health at that time? - Radio: 11=Doctor, 12=Nurse/Midwife, 13=Auxiliary midwife, 21=Traditional birth attendant, 22=Community health worker/field worker, 96=Other (specify)
60. Q_455: Did anyone check on your health after you left the facility? - Y/N: 1=Yes, 2=No [If No, skip to 459]
61. Q_456: How long after delivery did that check take place? - Numeric: Hours (1), Days (2), Weeks (3), 998=Don't know
62. Q_457: Who checked on your health at that time? - Radio: 11=Doctor, 12=Nurse/Midwife, 13=Auxiliary midwife, 21=Traditional birth attendant, 22=Community health worker/field worker, 96=Other
63. Q_458: Where did the check take place? - Radio: Home (11-12), Public sector (21-23, 26), Private medical sector (31-32, 36), NGO medical sector (41-42, 46), 96=Other
64. Q_459: CHECK 405: Pregnancy outcome type - Filter: Most recent live birth -> continue; Most recent stillbirth -> skip to 474
65. Q_460: After (NAME) left the facility, did any health care provider check on (NAME)'s health? - Y/N: 1=Yes, 2=No, 8=Don't know [If 2 or 8, skip to 473]
66. Q_461: How long after the birth did that check take place? - Numeric: Hours (1), Days (2), Weeks (3), 998=Don't know
67. Q_462: Who checked on (NAME)'s health at that time? - Radio: 11=Doctor, 12=Nurse/Midwife, 13=Auxiliary midwife, 21=Traditional birth attendant, 22=Community health worker/field worker, 96=Other
68. Q_463: Where did this check of (NAME) take place? - Radio: Home (11-12), Public sector (21-23, 26), Private medical sector (31-32, 36), NGO medical sector (41-42, 46), 96=Other [Skip to 473]
69. Q_464: CHECK 405: Did anyone check on your health after delivery? (home birth path) - Y/N: 1=Yes, 2=No [If No, skip to 468]
70. Q_465: How long after delivery did the first check take place? - Numeric: Hours (1), Days (2), Weeks (3), 998=Don't know
71. Q_466: Who checked on your health at that time? - Radio: 11=Doctor, 12=Nurse/Midwife, 13=Auxiliary midwife, 21=Traditional birth attendant, 22=Community health worker/field worker, 96=Other
72. Q_467: Where did this first check take place? - Radio: Home (11-12), Public sector (21-23, 26), Private medical sector (31-32, 36), NGO medical sector (41-42, 46), 96=Other
73. Q_468: CHECK 405: Pregnancy outcome type - Filter: Most recent live birth -> continue; Most recent stillbirth -> skip to 474
74. Q_469: After (NAME) was born, did any health care provider or traditional birth attendant check on (NAME)'s health? - Y/N: 1=Yes, 2=No, 8=Don't know [If 2 or 8, skip to 473]
75. Q_470: How long after the birth did that check take place? - Numeric: Hours (1), Days (2), Weeks (3), 998=Don't know
76. Q_471: Who checked on (NAME)'s health at that time? - Radio: 11=Doctor, 12=Nurse/Midwife, 13=Auxiliary midwife, 21=Traditional birth attendant, 22=Community health worker/field worker, 96=Other
77. Q_472: Where did this first check of (NAME) take place? - Radio: Home (11-12), Public sector (21-23, 26), Private medical sector (31-32, 36), NGO medical sector (41-42, 46), 96=Other
78. Q_473: During the first 2 days after (NAME)'s birth, did any health care provider do the following: - Matrix Y/N/DK: a) Examine the cord (1/2/8), b) Measure temperature (1/2/8), c) Tell you how to recognize if baby needs immediate medical attention (1/2/8), d) Talk with you about breastfeeding (1/2/8), e) Observe breastfeeding (1/2/8)
79. Q_474a: During the first 2 days after the birth, did any healthcare provider measure your blood pressure? - Radio: 1=Yes, 2=No, 8=Don't know
80. Q_474b: Discuss your vaginal bleeding with you? - Radio: 1=Yes, 2=No, 8=Don't know
81. Q_474c: Discuss family planning with you? - Radio: 1=Yes, 2=No, 8=Don't know
82. Q_475: CHECK 215: Is this pregnancy the woman's last pregnancy? - Filter: Yes -> continue; No -> skip to 479
83. Q_476: CHECK 405: Has your menstrual period returned since the birth/pregnancy? - Y/N: 1=Yes, 2=No
84. Q_477: CHECK 232: Is respondent pregnant? - Filter: Not pregnant -> continue; Pregnant or unsure -> skip to 479
85. Q_478: CHECK 405: Have you had sexual intercourse since the birth/pregnancy? - Y/N: 1=Yes, 2=No
86. Q_479: CHECK 405: Pregnancy outcome type - Filter: Most recent live birth -> continue; Most recent stillbirth/miscarriage/abortion -> skip to 487
87. Q_480: Did you ever breastfeed (NAME)? - Y/N: 1=Yes, 2=No [If No, skip to 482]
88. Q_481: CHECK 224 for child - Filter: Living -> skip to 486; Dead -> skip to 487
89. Q_482: How long after birth did you first put (NAME) to the breast? - Numeric: 000=Immediately, Hours (1), Days (2)
90. Q_483: In the first 2 days after delivery, was (NAME) given anything other than breast milk to eat or drink? - Y/N: 1=Yes, 2=No
91. Q_484: CHECK 224 for child - Filter: Living -> continue; Dead -> skip to 487
92. Q_485: Are you still breastfeeding (NAME)? - Y/N: 1=Yes, 2=No
93. Q_486: Did (NAME) drink anything from a bottle with a nipple yesterday during the day or at night? - Y/N: 1=Yes, 2=No, 8=Don't know
94. Q_487: CHECK 402: Any more pregnancy outcomes 0-35 months before the survey? - Filter: More -> go to 404 for next pregnancy; No more -> skip to 501

### Section 5. Child Immunization (pp. W-33 to W-37) - 28 questions
1. Q_501: CHECK 220, 224, AND 225: Any surviving children born 0-35 months before the survey? - Filter: One or more -> continue; None -> skip to 601
2. Q_502: Introduction to immunization questions - Instruction
3. Q_503: Record name and pregnancy history number of surviving children born 0-35 months - Open text: Name, Numeric: Pregnancy history number
4. Q_504: Do you have a card or other document where (NAME)'s vaccinations are written down? - Radio: 1=Yes has only a card (->507), 2=Yes has only another document (->507), 3=Yes has card and other document (->507), 4=No, no card and no other document
5. Q_505: Did you ever have a vaccination card for (NAME)? - Y/N: 1=Yes, 2=No
6. Q_506: CHECK 504 - Filter: Code 2 circled -> continue; Code 4 circled -> skip to 513
7. Q_507: May I see the card or other document where (NAME)'s vaccinations are written down? - Radio: 1=Yes only card seen, 2=Yes only other document seen, 3=Yes card and other document seen, 4=No card and no other document seen [If 4, skip to 513]
8. Q_508: Record date of birth from vaccination card or other document - Numeric: Day, Month, Year, 95=Date of birth not on card
9. Q_509: Copy vaccination dates from the card for (NAME) - Table: BCG, Hepatitis B at birth, OPV 0-3, IPV, DPT-HepB-Hib (Pentavalent) 1-4, Pneumococcal 1-3, Rotavirus 1-3, Measles containing vaccine 1-2, Vitamin A (most recent) - each with Day, Month, Year columns
10. Q_510: Ask permission to photograph vaccination card - Radio: 1=Photograph taken, 2=Photograph not taken permission not received, 6=Photograph not taken other reason (specify)
11. Q_511: CHECK 509: All vaccinations have a date or '44' recorded? - Filter: No -> continue; Yes -> skip to 529
12. Q_512: In addition to what is recorded, did (NAME) receive any other vaccinations? - Y/N: 1=Yes (select from list, then skip to 529), 2=No, 8=Don't know
13. Q_512A: CHECK 509: Any vaccinations recorded on the card? - Filter: Yes -> skip to 529; No -> skip to 530
14. Q_513: Did (NAME) ever receive any vaccinations to prevent diseases? - Y/N: 1=Yes, 2=No, 8=Don't know [If 2 or 8, skip to 530]
15. Q_514: Has (NAME) ever received a BCG vaccination against tuberculosis? - Y/N: 1=Yes, 2=No, 8=Don't know
16. Q_515: At or soon after birth, did (NAME) receive a Hepatitis B vaccination? - Y/N: 1=Yes, 2=No, 8=Don't know [If 2 or 8, skip to 517]
17. Q_516: Did (NAME) receive it within 24 hours of birth? - Y/N: 1=Yes, 2=No, 8=Don't know
18. Q_517: Has (NAME) ever received oral polio vaccine? - Y/N: 1=Yes, 2=No, 8=Don't know [If 2 or 8, skip to 521]
19. Q_518: Did (NAME) receive the first oral polio vaccine in the first 2 weeks after birth or later? - Radio: 1=First two weeks, 2=Later
20. Q_519: How many times did (NAME) receive the oral polio vaccine? - Numeric: Number of times
21. Q_520: The last time (NAME) received the polio drops, did (NAME) also get an IPV injection in the arm? - Y/N: 1=Yes, 2=No, 8=Don't know
22. Q_521: Has (NAME) ever received a pentavalent vaccination? - Y/N: 1=Yes, 2=No, 8=Don't know [If 2 or 8, skip to 523]
23. Q_522: How many times did (NAME) receive the pentavalent vaccine? - Numeric: Number of times
24. Q_523: Has (NAME) ever received a pneumococcal vaccination? - Y/N: 1=Yes, 2=No, 8=Don't know [If 2 or 8, skip to 525]
25. Q_524: How many times did (NAME) receive the pneumococcal vaccine? - Numeric: Number of times
26. Q_525: Has (NAME) ever received a rotavirus vaccination? - Y/N: 1=Yes, 2=No, 8=Don't know [If 2 or 8, skip to 527]
27. Q_526: How many times did (NAME) receive the rotavirus vaccine? - Numeric: Number of times
28. Q_527: Has (NAME) ever received a measles vaccination? - Y/N: 1=Yes, 2=No, 8=Don't know [If 2 or 8, skip to 529]
29. Q_528: How many times did (NAME) receive the measles vaccine? - Numeric: Number of times
30. Q_528A: Country-specific additional vaccines - Instruction
31. Q_529: Where did (NAME) receive most of his/her vaccinations? - Radio: Public sector (11-16), Private medical sector (21-27), NGO medical sector (31-36), Other source (41=Vaccination campaign), 96=Other
32. Q_530: CHECK 220 AND 224: Any more surviving children born 0-35 months? - Filter: More -> go to 503 for next child; No more -> skip to 601

### Section 6. Child Health and Nutrition (pp. W-38 to W-50) - 42 questions
1. Q_601: CHECK 220, 224, AND 225: Any surviving children born 0-59 months before the survey? - Filter: One or more -> continue; None -> skip to 643
2. Q_602: Introduction to child health questions - Instruction
3. Q_603: Record name and pregnancy history number of surviving children born 0-59 months - Open text: Name, Numeric: Pregnancy history number
4. Q_604a: In the last 12 months, was (NAME) given iron tablets/syrup? - Radio: 1=Yes, 2=No, 8=Don't know
5. Q_604b: In the last 12 months, was (NAME) given multiple micronutrient powders? - Radio: 1=Yes, 2=No, 8=Don't know
6. Q_605: In the last 6 months, was (NAME) given a vitamin A dose? - Y/N: 1=Yes, 2=No, 8=Don't know
7. Q_606: In the last 6 months, was (NAME) given any medicine for intestinal worms? - Y/N: 1=Yes, 2=No, 8=Don't know
8. Q_607a: In the last 3 months, has any healthcare provider measured (NAME)'s weight? - Radio: 1=Yes, 2=No, 8=Don't know
9. Q_607b: (NAME)'s length or height? - Radio: 1=Yes, 2=No, 8=Don't know
10. Q_607c: Around (NAME)'s upper arm? - Radio: 1=Yes, 2=No, 8=Don't know
11. Q_608: Has (NAME) had diarrhea in the last 2 weeks? - Y/N: 1=Yes, 2=No, 8=Don't know [If 2 or 8, skip to 618]
12. Q_609: CHECK 485: Currently breastfeeding? - Filter with question about amount given to drink during diarrhea - Radio: 1=Much less, 2=Somewhat less, 3=About the same, 4=More, 5=Nothing to drink, 8=Don't know
13. Q_610: During the diarrhea, was (NAME) given less/same/more to eat? - Radio: 1=Much less, 2=Somewhat less, 3=About the same, 4=More, 5=Stopped food, 6=Never gave food, 8=Don't know
14. Q_611: Did you seek advice or treatment for the diarrhea from any source? - Y/N: 1=Yes, 2=No [If No, skip to 615]
15. Q_612: Where did you seek advice or treatment? - Checkbox: Public sector (A-F), Private medical sector (G-M), NGO medical sector (N-P), Other source (Q-T), X=Other
16. Q_613: CHECK 612 - Filter: Two or more codes circled -> continue; Only one code -> skip to 615
17. Q_614: Where did you first seek advice or treatment? - Radio: Letter code from 612
18. Q_615a: Was (NAME) given fluid from ORS packet? - Radio: 1=Yes, 2=No, 8=Don't know
19. Q_615b: Was (NAME) given pre-packaged ORS liquid? - Radio: 1=Yes, 2=No, 8=Don't know
20. Q_615c: Was (NAME) given zinc tablets or syrup? - Radio: 1=Yes, 2=No, 8=Don't know
21. Q_615d: Was (NAME) given a government-recommended homemade fluid? - Radio: 1=Yes, 2=No, 8=Don't know
22. Q_616: CHECK 615: Any YES -> was anything else given? / All NO or DK -> was anything given? - Y/N: 1=Yes, 2=No, 8=Don't know [If 2 or 8, skip to 618]
23. Q_617: CHECK 615: What (else) was given to treat the diarrhea? - Checkbox: Pill/Syrup (A-D), Injection (E-G), H=IV intravenous, I=Home remedy/herbal medicine, X=Other (specify)
24. Q_618: Has (NAME) been ill with a fever at any time in the last 2 weeks? - Y/N: 1=Yes, 2=No, 8=Don't know [If 2 or 8, skip to 621]
25. Q_619: At any time during the illness, did (NAME) have blood taken from finger or heel for testing? - Y/N: 1=Yes, 2=No, 8=Don't know
26. Q_620: Were you told by a healthcare provider that (NAME) had malaria? - Y/N: 1=Yes, 2=No, 8=Don't know
27. Q_621: Has (NAME) had an illness with a cough at any time in the last 2 weeks? - Y/N: 1=Yes, 2=No, 8=Don't know
28. Q_622: Has (NAME) had fast, short, rapid breaths or difficulty breathing at any time in the last 2 weeks? - Y/N: 1=Yes, 2=No, 8=Don't know [If 2 or 8, skip to 624]
29. Q_623: Was the fast or difficult breathing due to a problem in the chest or to a blocked or runny nose? - Radio: 1=Chest only, 2=Nose only, 3=Both, 6=Other (specify), 8=Don't know [Skip to 625]
30. Q_624: CHECK 618: Had fever? - Filter: Yes -> continue; No or Don't know -> skip to 634
31. Q_625: Did you seek advice or treatment for the illness from any source? - Y/N: 1=Yes, 2=No [If No, skip to 630]
32. Q_626: Where did you seek advice or treatment? - Checkbox: Public sector (A-F), Private medical sector (G-M), NGO medical sector (N-P), Other source (Q-T), X=Other
33. Q_627: CHECK 626 - Filter: Two or more codes -> continue; Only one code -> skip to 629
34. Q_628: Where did you first seek advice or treatment? - Radio: Letter code from 626
35. Q_629: How many days after the illness began did you first seek advice or treatment? - Numeric: Days (00=same day)
36. Q_630: At any time during the illness, did (NAME) take any medicine for the illness? - Y/N: 1=Yes, 2=No, 8=Don't know [If 2 or 8, skip to 634]
37. Q_631: What medicine did (NAME) take? - Checkbox: Antimalarial (A-I), Antibiotic (J-K), Other pill/syrup (L), Other injection/IV (M), Other medicine (N-P), X=Other (specify), Z=Don't know
38. Q_632: CHECK 631: Artemisinin combination therapy (A) given? - Filter: Code A circled -> continue; Code A not circled -> skip to 634
39. Q_633: How long after the fever started did (NAME) first take an artemisinin combination therapy? - Radio: 0=Same day, 1=Next day, 2=Two days after fever, 3=Three or more days after fever, 8=Don't know
40. Q_634: CHECK 220, 224, AND 225: Any more surviving children born 0-59 months? - Filter: More -> go to 603 for next child; No more -> skip to 635
41. Q_635: CHECK 220, 225, AND 226: Number of children born 0-23 months living with the respondent - Filter: One or more -> continue (name youngest child); None -> skip to 643
42. Q_636: Liquids given to (NAME) yesterday (dietary recall) - Matrix Y/N/DK: a) Plain water, b) Infant formula (if yes: b1=number of times, 8=DK), c) Milk from animals (if yes: c1=number of times, c2=sweet/flavored 1/2/8), e) Soymilk/nutmilks (if yes: e1=sweet/flavored), f) Chocolate flavored drinks, g) Fruit juice, h) Sodas/malt/sports/energy drinks, i) Tea/coffee/herbal drinks (if yes: i1=sweetened), j) Clear broth/clear soup, k) Any other liquids (if yes: k1=what drink, k2=sweetened)
43. Q_637: Foods given to (NAME) yesterday (dietary recall) - Matrix Y/N/DK: a) Yogurt/yogurt drinks (if yes: a1=number of times, a2=had as drink, a3=sweetened), b) Porridge/bread/rice/noodles/pasta/grains, c) Pumpkin/carrots/squash/sweet potatoes (orange), d) Plantains/white potatoes/white yams/manioc/cassava, e) Dark green leafy vegetables, f) Other vegetables, g) Ripe mangoes/ripe papayas/vitamin A-rich fruits, h) Other fruits, i) Fresh or dried fish or shellfish, j) Liver/kidney/heart/organ meats, k) Sausages/hot dogs/processed meats, l) Other meat (beef/pork/lamb/goat/chicken/duck/game), m) Eggs, n) Beans/peas/lentils, o) Nuts/seeds, p) Hard or soft cheese, q) Insects, r) Chocolates/candies/pastries/cakes/biscuits/frozen treats, s) Other sentinel sweet foods, t) Chips/crisps/puffs/French fries/fried dough/instant noodles, u) Red palm oil, v) Any other solid food (if yes: v1=what food)
44. Q_638: CHECK 637 (categories a through v) - Filter: Not a single YES -> continue; At least one YES -> skip to 640
45. Q_639: Did (NAME) eat any solid, semi-solid, or soft foods yesterday? - Y/N: 1=Yes (go back to 637), 2=No [If No, skip to 641]
46. Q_640: How many times did (NAME) eat solid, semi-solid, or soft foods yesterday? - Numeric: Number of times, 8=Don't know
47. Q_641: In the last 6 months, did any healthcare provider or community health worker talk with you about how or what to feed (NAME)? - Y/N: 1=Yes, 2=No, 8=Don't know
48. Q_642: The last time (NAME) passed stools, what was done to dispose of the stools? - Radio: 01=Child used toilet or latrine, 02=Put/rinsed into toilet or latrine, 03=Put/rinsed into drain or ditch, 04=Thrown into garbage, 05=Buried, 06=Left in the open, 96=Other (specify)
49. Q_643: Woman's dietary recall - foods and drinks consumed yesterday - Matrix Y/N/DK: a) Porridge/bread/rice/noodles/pasta/grains, b) Pumpkin/carrots/squash/sweet potatoes (orange), c) Plantains/white potatoes/white yams/manioc/cassava, d) Dark green leafy vegetables, e) Other vegetables, f) Ripe mangoes/ripe papayas/vitamin A-rich fruits, g) Other fruits, h) Fresh or dried fish or shellfish, i) Liver/kidney/heart/organ meats, j) Sausages/hot dogs/processed meats, k) Other meat, l) Eggs, m) Beans/peas/lentils, n) Nuts/seeds, o) Milk/cheese/yogurt/milk products, p) Insects, q) Chocolates/candies/pastries/cakes/biscuits/frozen treats, r) Other sentinel sweet foods, s) Chips/crisps/puffs/French fries/fried dough/instant noodles, t) Fruit juice/fruit-flavored drinks, u) Sodas/malt/sports/energy drinks, v) Sweetened tea/coffee/herbal/chocolate/flavored drinks, w) Red palm oil, x) Any other liquids (if yes: x1=what drink, x2=sweetened), y) Any other food (if yes: y1=what food)

### Section 7. Marriage and Sexual Activity (pp. W-51 to W-55) - 34 questions
1. Q_701: Are you currently married or living together with a man as if married? - Radio: 1=Yes currently married, 2=Yes living with a man, 3=No not in union [If 1 or 2, skip to 706A]
2. Q_702: Have you ever been married or lived together with a man as if married? - Radio: 1=Yes formerly married, 2=Yes lived with a man, 3=No [If 3, skip to 721]
3. Q_703: What is your marital status now: are you widowed, divorced, or separated? - Radio: 1=Widowed, 2=Divorced, 3=Separated [If 2 or 3, skip to 714]
4. Q_706A: Do you have a marriage certificate or other document recognizing this (marriage/union)? - Y/N: 1=Yes, 2=No, 8=Don't know [If 2 or 8, skip to 707]
5. Q_706B: What document or documents do you have? - Checkbox: A=Marriage certificate from a church/mosque/other religious institution, B=Marriage certificate from a civil authority, C=Other document from a religious institution, D=Other document from a civil authority, X=Other (specify) [Skip to 709]
6. Q_707: Was this marriage ever registered with the civil authority? - Y/N: 1=Yes, 2=No, 8=Don't know
7. Q_709: Is your (husband/partner) living with you now or is he staying elsewhere? - Radio: 1=Living with her, 2=Staying elsewhere
8. Q_710: Please tell me the name of your (husband/partner). Record husband's line number - Open text: Name, Numeric: Line number
9. Q_711: Does your (husband/partner) have other wives or does he live with other women as if married? - Y/N: 1=Yes, 2=No, 8=Don't know [If 2 or 8, skip to 714]
10. Q_712: Including yourself, in total, how many wives or live-in partners does he have? - Numeric: Total number, 98=Don't know
11. Q_713: Are you the first, second, ... wife? - Numeric: Rank, 98=Don't know
12. Q_714: Have you been married or lived with a man only once or more than once? - Radio: 1=Only once, 2=More than once
13. Q_715: CHECK 714 - Filter: Married/lived with a man only once -> 715a; More than once -> 715b; Numeric: Month, Year (98=Don't know month, 9998=Don't know year) [Skip to 717]
14. Q_716: How old were you when you first started living with him? - Numeric: Age
15. Q_717: CHECK 714 - Filter: Married/lived with a man more than once -> continue; Only once -> skip to 721
16. Q_718: CHECK 701 - Filter: Currently married -> continue; Living with a man -> continue; Not in union -> skip to 721
17. Q_719: In what month and year did you start living with your current (husband/partner)? - Numeric: Month, Year (98=Don't know month, 9998=Don't know year) [Skip to 721]
18. Q_720: How old were you when you first started living with your current (husband/partner)? - Numeric: Age
19. Q_721: CHECK FOR PRESENCE OF OTHERS - Instruction
20. Q_722: How old were you when you had sexual intercourse for the very first time? - Numeric: Age in years, 00=Never had sexual intercourse [If 00, skip to 738]
21. Q_723: When was the last time you had sexual intercourse? - Numeric: Days ago (1), Weeks ago (2), Months ago (3), Years ago (4) [If years ago, skip to 737]
22. Q_724: CHECK 232: Pregnant? - Filter: Not pregnant or unsure -> continue; Pregnant -> skip to 727
23. Q_725: The last time you had sexual intercourse, did you or your partner do something or use any method to delay or avoid getting pregnant? - Y/N: 1=Yes, 2=No [If No, skip to 727]
24. Q_726: Which method did you use? - Checkbox: A=Female sterilization, B=Male sterilization, C=IUD, D=Injectables, E=Implants, F=Pill, G=Condom, H=Female condom, I=Emergency contraception, J=Standard days method, K=Lactational amenorrhea method, L=Rhythm method, M=Withdrawal, X=Other modern method, Y=Other traditional method [If G or H, skip to 728]
25. Q_727: The last time you had sexual intercourse, was a condom used? - Y/N: 1=Yes, 2=No [If No, skip to 730]
26. Q_728: What is the brand name of the condom used? - Radio: 01=Brand A, 02=Brand B, 03=Brand C, 96=Other (specify), 98=Don't know
27. Q_729: From where did you obtain the condom the last time? - Radio: Public sector (11-16), Private medical sector (21-27), NGO medical sector (31-36), Other source (41-43), 96=Other, 98=Don't know
28. Q_730: What was your relationship to this person with whom you had sexual intercourse? - Radio: 1=Husband, 2=Live-in partner, 3=Boyfriend not living with respondent, 4=Casual acquaintance, 5=Client/sex worker, 6=Other (specify)
29. Q_731: Apart from this person, have you had sexual intercourse with any other person in the last 12 months? - Y/N: 1=Yes, 2=No [If No, skip to 737]
30. Q_732: The last time you had sexual intercourse with this second person, was a condom used? - Y/N: 1=Yes, 2=No
31. Q_733: What was your relationship to this second person? - Radio: 1=Husband, 2=Live-in partner, 3=Boyfriend not living with respondent, 4=Casual acquaintance, 5=Client/sex worker, 6=Other (specify)
32. Q_734: Apart from these two people, have you had sexual intercourse with any other person in the last 12 months? - Y/N: 1=Yes, 2=No [If No, skip to 737]
33. Q_735: The last time you had sexual intercourse with this third person, was a condom used? - Y/N: 1=Yes, 2=No
34. Q_736: What was your relationship to this third person? - Radio: 1=Husband, 2=Live-in partner, 3=Boyfriend not living with respondent, 4=Casual acquaintance, 5=Client/sex worker, 6=Other (specify)
35. Q_737: In total, with how many different people have you had sexual intercourse in your lifetime? - Numeric: Number of partners in lifetime, 98=Don't know
36. Q_738: PRESENCE OF OTHERS DURING THIS SECTION - Matrix Y/N: Children <10 (1/2), Husband (1/2), Other males (1/2), Other females (1/2)

### Section 8. Fertility Preferences (pp. W-56 to W-58) - 18 questions
1. Q_801: CHECK 307: Using a contraceptive method? - Filter: Not asked / Neither sterilized -> continue; He or she sterilized -> skip to 813
2. Q_802: CHECK 232: Pregnant? - Filter: Pregnant -> continue; Not pregnant or unsure -> skip to 804
3. Q_803: After the child you are expecting now, would you like to have another child or would you prefer not to have any more children? - Radio: 1=Have another child (->805), 2=No more (->812), 8=Undecided/Don't know (->812)
4. Q_804: CHECK 208: Has had a child / Has not had a child - Radio: 1=Have (a/another) child, 2=No more/None (->807), 3=Says she can't get pregnant (->813), 8=Undecided/Don't know (->811)
5. Q_805: CHECK 208 AND 232 - Filter with question: How long would you like to wait? - Numeric: Months (1), Years (2), 993=Soon/now (->811), 994=Says she can't get pregnant (->813), 995=After marriage, 996=Other (specify) (->811), 998=Don't know (->811)
6. Q_806: CHECK 232 - Filter: Not pregnant or unsure -> continue; Pregnant -> skip to 812
7. Q_807: CHECK 307: Using a contraceptive method? - Filter: Not asked -> continue; Currently using -> skip to 813
8. Q_808: CHECK 805 - Filter: 24 or more months / 02 or more years / Not asked -> continue; 00-23 months / 00-01 year -> skip to 812
9. Q_809: CHECK 723 - Filter: Days/weeks/months ago -> continue; Years ago / Not asked -> skip to 811
10. Q_810: Reasons for not using a method to prevent pregnancy - Checkbox: A=Not married; Fertility-related (B-H): Not having sex, Infrequent sex, Menopausal/hysterectomy, Can't get pregnant, Not menstruated since last birth, Breastfeeding, Up to God/fatalistic; Opposition (I-L): Respondent opposed, Husband/partner opposed, Others opposed, Religious prohibition; Lack of knowledge (M-N): Knows no method, Knows no source; Method-related (O-S): Inconvenient, Changes in menstrual bleeding, Methods could cause infertility, Interferes with body's normal processes, Other side effects; Cost/access (T-W): Lack of access/too far, Costs too much, Preferred method not available, No method available; X=Other (specify), Z=Don't know
11. Q_811: CHECK 307: Using a contraceptive method? - Filter: Not asked -> continue; Currently using -> skip to 813
12. Q_812: Do you think you will use a contraceptive method to delay or avoid pregnancy at any time in the future? - Y/N: 1=Yes, 2=No, 8=Don't know
13. Q_813: CHECK 224: Living children? - Filter: Has living children -> 813a; No living children -> 813b; Numeric: Number (00=None -> skip to 815), 96=Other (specify) (-> skip to 815)
14. Q_814: How many of these children would you like to be boys, how many would you like to be girls and for how many would it not matter? - Numeric: Boys, Girls, Either; 96=Other (specify)
15. Q_815: In the last 12 months have you: - Matrix Y/N: a) Heard about FP on the radio (1/2), b) Seen anything about FP on television (1/2), c) Read about FP in newspaper or magazine (1/2), d) Received voice or text message about FP on mobile phone (1/2), e) Seen anything about FP on social media (1/2), f) Seen anything about FP on a poster/leaflet/brochure (1/2), g) Seen anything about FP on an outdoor sign or billboard (1/2), h) Heard anything about FP at community meetings or events (1/2)
16. Q_816: OPTIONAL COUNTRY-SPECIFIC QUESTIONS ON MEDIA MESSAGES ABOUT FP - Instruction
17. Q_817: CHECK 701 - Filter: Currently married / Living with a man -> continue; Not in union -> skip to 901
18. Q_818: Who usually makes the decision on whether or not you should use contraception? - Radio: 1=Respondent (->820), 2=Husband/partner, 3=Respondent and husband/partner jointly, 4=Someone else (->820), 6=Other (specify) (->820)
19. Q_819: When making this decision with your (husband/partner), would you say that your opinion is more important, equally important, or less important? - Radio: 1=More important, 2=Equally important, 3=Less important
20. Q_820: Has your (husband/partner) or any other family member ever tried to force or pressure you to become pregnant when you did not want to become pregnant? - Y/N: 1=Yes, 2=No
21. Q_821: CHECK 307 - Filter: Not asked / Neither sterilized -> continue; He or she sterilized -> skip to 901
22. Q_822: Does your (husband/partner) want the same number of children that you want, or does he want more or fewer? - Radio: 1=Same number, 2=More children, 3=Fewer children, 8=Don't know

### Section 9. Husband's Background and Woman's Work (pp. W-59 to W-61) - 28 questions
1. Q_901: CHECK 701 - Filter: Currently married/living with a man -> continue; Not in union -> skip to 909
2. Q_902: How old was your (husband/partner) on his last birthday? - Numeric: Age in completed years
3. Q_903: Did your (husband/partner) ever attend school? - Y/N: 1=Yes, 2=No [If No, skip to 906]
4. Q_904: What was the highest level of school he attended: primary, secondary, or higher? - Radio: 1=Primary, 2=Secondary, 3=Higher, 8=Don't know [If 8, skip to 906]
5. Q_905: What was the highest [grade/form/year] he completed at that level? - Numeric: [Grade/Form/Year], 98=Don't know
6. Q_906: Has your (husband/partner) done any work in the last 7 days? - Y/N: 1=Yes, 2=No, 8=Don't know [If Yes, skip to 908]
7. Q_907: Has your (husband/partner) done any work in the last 12 months? - Y/N: 1=Yes, 2=No, 8=Don't know [If 2 or 8, skip to 909]
8. Q_908: What is your (husband/partner's) occupation? - Open text: Occupation (coded)
9. Q_909: Aside from your own housework, have you done any work in the last 7 days? - Y/N: 1=Yes, 2=No [If Yes, skip to 913]
10. Q_910: As you know, some women take up jobs for which they are paid in cash or kind. In the last 7 days, have you done any of these things or any other work? - Y/N: 1=Yes, 2=No [If Yes, skip to 913]
11. Q_911: Although you did not work in the last 7 days, do you have any job or business from which you were absent? - Y/N: 1=Yes, 2=No [If Yes, skip to 913]
12. Q_912: Have you done any work in the last 12 months? - Y/N: 1=Yes, 2=No [If No, skip to 917]
13. Q_913: What is your occupation? - Open text: Occupation (coded)
14. Q_914: Do you do this work for a member of your family, for someone else, or are you self-employed? - Radio: 1=For family member, 2=For someone else, 3=Self-employed
15. Q_915: Do you usually work throughout the year, or do you work seasonally, or only once in a while? - Radio: 1=Throughout the year, 2=Seasonally/part of the year, 3=Once in a while
16. Q_916: Are you paid in cash or kind for this work or are you not paid at all? - Radio: 1=Cash only, 2=Cash and kind, 3=In kind only, 4=Not paid
17. Q_917: CHECK 701 - Filter: Currently married/living with a man -> continue; Not in union -> skip to 925
18. Q_918: CHECK 916 - Filter: Code 1 or 2 circled -> continue; Other -> skip to 921
19. Q_919: Who usually decides how the money you earn will be used? - Radio: 1=Respondent, 2=Husband/partner, 3=Respondent and husband/partner jointly, 6=Other (specify)
20. Q_920: Would you say that the money that you earn is more than what your (husband/partner) earns, less than what he earns, or about the same? - Radio: 1=More than him, 2=Less than him, 3=About the same, 4=Husband/partner has no earnings, 8=Don't know [If 4, skip to 922]
21. Q_921: Who usually decides how your (husband's/partner's) earnings will be used? - Radio: 1=Respondent, 2=Husband/partner, 3=Respondent and husband/partner jointly, 4=Husband/partner has no earnings, 6=Other (specify)
22. Q_922: Who usually makes decisions about health care for yourself? - Radio: 1=Respondent, 2=Husband/partner, 3=Respondent and husband/partner jointly, 4=Someone else, 6=Other
23. Q_923: Who usually makes decisions about making major household purchases? - Radio: 1=Respondent, 2=Husband/partner, 3=Respondent and husband/partner jointly, 4=Someone else, 6=Other
24. Q_924: Who usually makes decisions about visits to your family or relatives? - Radio: 1=Respondent, 2=Husband/partner, 3=Respondent and husband/partner jointly, 4=Someone else, 6=Other
25. Q_925: Do you own this or any other house either alone or jointly with someone else? - Radio: 01=Alone only, 02=Jointly with husband/partner only, 03=Jointly with someone else only, 04=Jointly with husband/partner and someone else, 05=Both alone and jointly, 06=Does not own [If 06, skip to 928]
26. Q_926: Do you have a title deed or other government recognized document for any house you own? - Y/N: 1=Yes, 2=No, 8=Don't know [If 2 or 8, skip to 928]
27. Q_927: Is your name on this document? - Y/N: 1=Yes, 2=No, 8=Don't know
28. Q_928: Do you own any agricultural or non-agricultural land either alone or jointly with someone else? - Radio: 01=Alone only, 02=Jointly with husband/partner only, 03=Jointly with someone else only, 04=Jointly with husband/partner and someone else, 05=Both alone and jointly, 06=Does not own [If 06, skip to 930A]
29. Q_929: Do you have a title deed or other government recognized document for any land you own? - Y/N: 1=Yes, 2=No, 8=Don't know [If 2 or 8, skip to 930A]
30. Q_930: Is your name on this document? - Y/N: 1=Yes, 2=No, 8=Don't know
31. Q_930A: Do you have an account in a bank or other financial institution that you yourself use? - Y/N: 1=Yes, 2=No [If No, skip to 930C]
32. Q_930B: Did you yourself put money in or take money out of this account in the last 12 months? - Y/N: 1=Yes, 2=No
33. Q_930C: In the last 12 months, have you used a mobile phone to make financial transactions? - Y/N: 1=Yes, 2=No
34. Q_931: PRESENCE OF OTHERS AT THIS POINT - Matrix: Children <10 (1=Pres/Listen, 2=Pres/Not listen, 3=Not pres), Husband (1/2/3), Other males (1/2/3), Other females (1/2/3)
35. Q_932: In your opinion, is a husband justified in hitting or beating his wife in the following situations: - Matrix Y/N/DK: a) If she goes out without telling him (1/2/8), b) If she neglects the children (1/2/8), c) If she argues with him (1/2/8), d) If she refuses to have sex with him (1/2/8), e) If she burns the food (1/2/8)

### Section 10. HIV/AIDS (pp. W-62 to W-67) - 46 questions
1. Q_1000: Introduction to HIV/AIDS section - Instruction
2. Q_1001: Have you ever heard of HIV or AIDS? - Y/N: 1=Yes, 2=No [If No, skip to 1040]
3. Q_1002: CHECK 111: Age - Filter: 15-24 years -> continue; 25 years or older -> skip to 1008
4. Q_1003: Can people reduce their chance of getting HIV by having just one uninfected sex partner who has no other sex partners? - Y/N: 1=Yes, 2=No, 8=Don't know
5. Q_1004: Can people get HIV from mosquito bites? - Y/N: 1=Yes, 2=No, 8=Don't know
6. Q_1005: Can people reduce their chance of getting HIV by using a condom every time they have sex? - Y/N: 1=Yes, 2=No, 8=Don't know
7. Q_1006: Can people get HIV by sharing food with a person who has HIV? - Y/N: 1=Yes, 2=No, 8=Don't know
8. Q_1007: Is it possible for a healthy-looking person to have HIV? - Y/N: 1=Yes, 2=No, 8=Don't know
9. Q_1008: Have you heard of ARVs, that is, antiretroviral medicines that treat HIV? - Y/N: 1=Yes, 2=No
10. Q_1009: Are there any special medicines that a doctor or a nurse can give to a woman infected with HIV to reduce the risk of transmission to the baby? - Y/N: 1=Yes, 2=No, 8=Don't know
11. Q_1010: Have you heard of PrEP, a medicine taken daily that can prevent a person from getting HIV? - Y/N: 1=Yes, 2=No [If No, skip to 1012]
12. Q_1011: Do you approve of people who take a pill every day to prevent getting HIV? - Y/N: 1=Yes, 2=No, 8=Don't know/Not sure/Depends
13. Q_1012: CHECK 220 AND 223 - Filter: Last live birth 0-23 months before the survey -> continue; Last live birth 24 months or more / No live births -> skip to 1024
14. Q_1013: CHECK 412 FOR LAST LIVE BIRTH (Type 1) - Filter: Had antenatal care -> continue; No antenatal care -> skip to 1018
15. Q_1014: CHECK FOR PRESENCE OF OTHERS - Instruction
16. Q_1015: Were you tested for HIV as part of your antenatal care while you were pregnant with (CHILD NAME)? - Y/N: 1=Yes, 2=No [If No, skip to 1018]
17. Q_1016: Where was the test done? - Radio: Public sector (11-16), Private medical sector (21-27), NGO medical sector (31-36), Other source (41-43), 96=Other
18. Q_1017: Did you get the results of the test? - Y/N: 1=Yes, 2=No
19. Q_1018: CHECK 435 FOR LAST LIVE BIRTH (Type 1): Place of delivery - Filter: Any code 21-46 circled -> continue; Other -> skip to 1021
20. Q_1019: Between the time you went for delivery but before the baby was born, were you tested for HIV? - Y/N: 1=Yes, 2=No [If No, skip to 1021]
21. Q_1020: Did you get the results of the test? - Y/N: 1=Yes, 2=No [If Yes, skip to 1022]
22. Q_1021: CHECK 1015 - Filter: Yes -> continue; No or Not asked -> skip to 1024
23. Q_1022: Have you been tested for HIV since that time you were tested during your pregnancy? - Y/N: 1=Yes, 2=No [If No, skip to 1025]
24. Q_1023: In what month and year was your most recent HIV test? - Numeric: Month (98=Don't know month), Year (9998=Don't know year) [Skip to 1028]
25. Q_1024: Have you ever been tested for HIV? - Y/N: 1=Yes, 2=No [If No, skip to 1032]
26. Q_1025: In what month and year was your most recent HIV test? - Numeric: Month (98=Don't know month), Year (9998=Don't know year)
27. Q_1026: Where was the test done? - Radio: Public sector (11-16), Private medical sector (21-27), NGO medical sector (31-36), Other source (41-43), 96=Other
28. Q_1027: Did you get the results of the test? - Y/N: 1=Yes, 2=No [If No, skip to 1031]
29. Q_1028: What was the result of the test? - Radio: 1=Positive, 2=Negative, 3=Indeterminate, 4=Declined to answer, 5=Did not receive test result [If 2-5, skip to 1031]
30. Q_1029: In what month and year did you receive your first HIV-positive test result? - Numeric: Month (98=Don't know month), Year (9998=Don't know year), 95=Same date as last HIV test
31. Q_1030: Are you currently taking ARVs? - Y/N: 1=Yes, 2=No, 8=Don't know
32. Q_1031: How many times have you been tested for HIV in your lifetime? - Numeric: Number of HIV tests
33. Q_1032: Have you heard of test kits people can use to test themselves for HIV? - Y/N: 1=Yes, 2=No [If No, skip to 1034]
34. Q_1033: Have you ever tested yourself for HIV using a self-test kit? - Y/N: 1=Yes, 2=No
35. Q_1034: Would you buy fresh vegetables from a shopkeeper or vendor if you knew that this person had HIV? - Y/N: 1=Yes, 2=No, 8=Don't know/Not sure/Depends
36. Q_1035: Do you think children living with HIV should be allowed to attend school with children who do not have HIV? - Y/N: 1=Yes, 2=No, 8=Don't know/Not sure/Depends
37. Q_1036: CHECK 1028 - Filter: Code 1 circled -> continue; Other -> skip to 1040
38. Q_1037: Have you disclosed your HIV status to anyone other than me? - Y/N: 1=Yes, 2=No
39. Q_1038: Do you agree or disagree: I have felt ashamed because of my HIV status - Radio: 1=Agree, 2=Disagree
40. Q_1039: Please tell me if the following things have happened to you because of your HIV status in the last 12 months: - Matrix Y/N: a) People have talked badly about me (1/2), b) Someone else disclosed my status without my permission (1/2), c) I have been verbally insulted, harassed, or threatened (1/2), d) Healthcare workers talked badly about me (1/2), e) Healthcare workers yelled at me, scolded me, or verbally abused me (1/2)
41. Q_1040: CHECK 1001 - Filter with question: Apart from HIV, have you heard about other infections that can be transmitted through sexual contact? - Y/N: 1=Yes, 2=No
42. Q_1041: CHECK 722 - Filter: Has had sexual intercourse -> continue; Never had sexual intercourse -> skip to 1046
43. Q_1042: CHECK 1040: Heard about other STIs? - Filter: Yes -> continue; No -> skip to 1044
44. Q_1043: During the last 12 months, have you had a disease which you got through sexual contact? - Y/N: 1=Yes, 2=No, 8=Don't know
45. Q_1044: During the last 12 months, have you had a bad-smelling abnormal genital discharge? - Y/N: 1=Yes, 2=No, 8=Don't know
46. Q_1045: During the last 12 months, have you had a genital sore or ulcer? - Y/N: 1=Yes, 2=No, 8=Don't know
47. Q_1046: If a wife knows her husband has a disease that she can get during sexual intercourse, is she justified in asking that they use a condom? - Y/N: 1=Yes, 2=No, 8=Don't know
48. Q_1047: Is a wife justified in refusing to have sex with her husband when she knows he has sex with other women? - Y/N: 1=Yes, 2=No, 8=Don't know
49. Q_1048: CHECK 701 - Filter: Currently married/living with a man -> continue; Not in union -> skip to 1101
50. Q_1049: Can you say no to your (husband/partner) if you do not want to have sexual intercourse? - Radio: 1=Yes, 2=No, 8=Depends/Not sure
51. Q_1050: Could you ask your (husband/partner) to use a condom if you wanted him to? - Radio: 1=Yes, 2=No, 8=Depends/Not sure

### Section 11. Other Health Issues (pp. W-68 to W-69) - 16 questions
1. Q_1101: How long does it take in minutes to go from your home to the nearest healthcare facility? - Numeric: Minutes
2. Q_1102: How do you travel to this healthcare facility from your home? - Radio: Motorized (01=Car/truck, 02=Public bus, 03=Motorcycle/scooter, 04=Boat with motor); Not motorized (05=Animal-drawn cart, 06=Bicycle, 07=Boat without motor, 08=Walking); 96=Other (specify)
3. Q_1103: Has a doctor or other healthcare provider examined your breasts to check for breast cancer? - Y/N: 1=Yes, 2=No, 8=Don't know
4. Q_1104: Description of cervical cancer and testing methods - Instruction (Comment)
5. Q_1105: Has a doctor or other healthcare worker ever tested you for cervical cancer? - Y/N: 1=Yes, 2=No, 8=Don't know
6. Q_1106: Do you currently smoke cigarettes every day, some days, or not at all? - Radio: 1=Every day, 2=Some days, 3=Not at all [If 2, skip to 1108]
7. Q_1107: On average, how many cigarettes do you currently smoke each day? - Numeric: Number of cigarettes
8. Q_1108: Do you currently smoke or use any other type of tobacco every day, some days, or not at all? - Radio: 1=Every day, 2=Some days, 3=Not at all [If 3, skip to 1110]
9. Q_1109: What other type of tobacco do you currently smoke or use? - Checkbox: A=Kreteks, B=Pipes full of tobacco, C=Cigars/cheroots/cigarillos, D=Water pipe, E=Snuff by mouth, F=Snuff by nose, G=Chewing tobacco, H=Betel quid with tobacco, X=Other (specify)
10. Q_1110: Have you ever consumed any alcohol? - Y/N: 1=Yes, 2=No [If No, skip to 1113]
11. Q_1111: During the last one month, on how many days did you have an alcoholic drink? - Numeric: 00=Did not drink alcohol [If 00, skip to 1113], Number of days, 95=Every day/almost every day
12. Q_1112: In the last one month, on the days that you drank alcohol, how many drinks did you usually have per day? - Numeric: 00=Less than one standard drink, Number of drinks
13. Q_1113: Many different factors can prevent women from getting medical advice or treatment. Is each of the following a big problem or not a big problem: - Matrix: a) Getting permission to go to the doctor (1=Big problem, 2=Not a big problem), b) Getting money needed for advice or treatment (1/2), c) The distance to the health facility (1/2), d) Not wanting to go alone (1/2)
14. Q_1114: Are you covered by any health insurance? - Y/N: 1=Yes, 2=No [If No, skip to 1116]
15. Q_1115: What type of health insurance are you covered by? - Checkbox: A=Mutual health organization/community-based health insurance, B=Health insurance through employer, C=Social security, D=Other privately purchased commercial health insurance, X=Other (specify)
16. Q_1116: RECORD THE TIME - Numeric: Hours, Minutes

### Contraceptive Calendar (p. W-70) - 1 instrument
1. CALENDAR: Month-by-month contraceptive use history (72 months) - Two columns: Column 1 = Births/pregnancies/contraceptive use code per month (B/P/T/0-13/J-M/X/Y); Column 2 = Discontinuation of contraceptive use code (0-8/N/F/A/D/X/Z)

### Interviewer's Observations (p. W-71) - 0 questions
(Free-text observation forms for interviewer and supervisor; no coded questions)

## TOTAL UNIQUE QUESTION NODES: ~400

Counting methodology: Each numbered question (including sub-parts like 203a/203b, 418a-g, 637a-v, 643a-y) is counted as a separate question node. CHECK filters are counted when they involve a routing decision. Pregnancy history table rows (215-228) and vaccination card entries (509) are counted once each as they repeat per pregnancy/child. The contraceptive calendar is counted as 1 instrument. Matrix/battery items (e.g., 932a-e, 1039a-e, 1113a-d) are counted as individual sub-items within their parent question. Interviewer instructions without response fields are excluded. The total reflects the full complexity of the instrument including all sub-parts, CHECK filters, and looped sections counted once.
