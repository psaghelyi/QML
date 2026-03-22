# DHS-8 Model Man's Questionnaire - Question Inventory

## Document Overview
- **Title**: Demographic and Health Surveys - Model Man's Questionnaire
- **Organization**: DHS Program (ICF)
- **Date**: Formatting Date 03 Feb 2023, English Language 03 Feb 2023
- **Pages**: 24
- **Language**: English
- **Type**: Model interviewer-administered paper questionnaire for male respondents aged 15-59, with GOTO-based skip patterns and CHECK filters. Designed as a country-adaptable template (brackets indicate country-specific items).

## Structure

The questionnaire consists of a cover page (Identification), an Introduction and Consent section, 8 numbered sections of substantive questions, and an Interviewer's Observations page.

- **Cover Page** (M-1): Identification fields, interviewer visits log, language codes, team info
- **Introduction and Consent** (M-2): Informed consent script, respondent agreement gate
- **Section 1**: Respondent's Background (Q101-Q131)
- **Section 2**: Reproduction (Q201-Q219)
- **Section 3**: Contraception (Q301-Q307)
- **Section 4**: Marriage and Sexual Activity (Q401-Q429)
- **Section 5**: Fertility Preferences (Q501-Q515)
- **Section 6**: Employment and Gender Roles (Q601-Q619)
- **Section 7**: HIV/AIDS (Q700-Q736)
- **Section 8**: Other Health Issues (Q801-Q819)
- **Interviewer's Observations** (M-24): Post-interview comments

## Question Inventory by Section

### Introduction and Consent - 1 question

1. Q_CONSENT: Respondent agrees to be interviewed / Respondent does not agree to be interviewed - Radio: Agrees=1, Does not agree=2 [If 2 -> END]

### Section 1. Respondent's Background - 28 questions

1. Q_101: Record the time. - Numeric: Hours, Minutes
2. Q_102: What [Province/Region/State] were you born in? - Radio: [Province/Region/State]=01, [Province/Region/State]=02, [Province/Region/State]=03, Outside of [Country]=96 [If 01-03 -> 104]
3. Q_103: What country were you born in? - Open text: Country name + Numeric code
4. Q_104: How long have you been living continuously in (name of current city, town or village of residence)? If less than one year, record '00' years. - Numeric: Years; Always=95, Visitor=96 [If 95 or 96 -> 110]
5. Q_105: CHECK 104: 00-04 years -> continue; 05 years or more -> 107 - Filter/CHECK [If 05+ years -> 107]
6. Q_106: In what month and year did you move here? - Numeric: Month (Don't Know Month=98), Year (Don't Know Year=9998)
7. Q_107: Just before you moved here, which [Province/Region/State] did you live in? - Radio: [Province/Region/State]=01, [Province/Region/State]=02, [Province/Region/State]=03, Outside of [Country]=96
8. Q_108: Just before you moved here, did you live in a city, in a town, or in a rural area? - Radio: City=1, Town=2, Rural area=3
9. Q_109: Why did you move to this place? - Radio: Employment=01, Education/Training=02, Marriage formation=03, Family reunification/Other family related reason=04, Forced displacement=05, Other=96 (specify)
10. Q_110: In what month and year were you born? - Numeric: Month (Don't Know Month=98), Year (Don't Know Year=9998)
11. Q_111: How old were you at your last birthday? Compare and correct 105 and/or 106 if inconsistent. - Numeric: Age in completed years
12. Q_112: In general, would you say your health is very good, good, moderate, bad, or very bad? - Radio: Very good=1, Good=2, Moderate=3, Bad=4, Very bad=5
13. Q_113: Have you ever attended school? - Radio: Yes=1, No=2 [If No -> 117]
14. Q_114: What is the highest level of school you attended: primary, secondary, or higher? - Radio: Primary=1, Secondary=2, Higher=3
15. Q_115: What is the highest [Grade/Form/Year] you completed at that level? If completed less than one year at that level, record '00'. - Numeric: [Grade/Form/Year]
16. Q_116: CHECK 114: Primary or Secondary -> continue; Higher -> 119 - Filter/CHECK [If Higher -> 119]
17. Q_117: Now I would like you to read this sentence to me. Show card to respondent. - Radio: Cannot read at all=1, Able to read only part of the sentence=2, Able to read whole sentence=3, No card with required language=4 (specify language), Blind/Visually impaired=5
18. Q_118: CHECK 117: Code '2', '3' or '4' circled -> continue; Code '1' or '5' circled -> 120 - Filter/CHECK [If 1 or 5 -> 120]
19. Q_119: Do you read a newspaper or magazine at least once a week, less than once a week or not at all? - Radio: At least once a week=1, Less than once a week=2, Not at all=3
20. Q_120: Do you listen to the radio at least once a week, less than once a week or not at all? - Radio: At least once a week=1, Less than once a week=2, Not at all=3
21. Q_121: Do you watch television at least once a week, less than once a week or not at all? - Radio: At least once a week=1, Less than once a week=2, Not at all=3
22. Q_122: Do you own a mobile phone? - Radio: Yes=1, No=2 [If No -> 127]
23. Q_123: Is your mobile phone a smart phone? - Radio: Yes=1, No=2
24. Q_127: Have you ever used the Internet from any location on any device? - Radio: Yes=1, No=2 [If No -> 130]
25. Q_128: In the last 12 months, have you used the Internet? - Radio: Yes=1, No=2 [If No -> 130]
26. Q_129: During the last one month, how often did you use the Internet: almost every day, at least once a week, less than once a week, or not at all? - Radio: Almost every day=1, At least once a week=2, Less than once a week=3, Not at all=4
27. Q_130: What is your religion? - Radio: [Religion]=01, [Religion]=02, [Religion]=03, Other=96 (specify)
28. Q_131: What is your ethnic group? - Radio: [Ethnic Group]=01, [Ethnic Group]=02, [Ethnic Group]=03, Other=96 (specify)

Note: Q124-Q126 do not appear in this questionnaire (numbers skipped).

### Section 2. Reproduction - 19 questions

1. Q_201: Have you ever fathered any children with any woman? (biologically yours, even if not legally yours or do not have your last name) - Radio: Yes=1, No=2, Don't Know=8 [If No or DK -> 206]
2. Q_202: Do you have any sons or daughters that you have fathered who are now living with you? - Radio: Yes=1, No=2 [If No -> 204]
3. Q_203: a) How many sons live with you? If none, record '00'. b) And how many daughters live with you? If none, record '00'. - Numeric: a) Sons at home, b) Daughters at home
4. Q_204: Do you have any sons or daughters that you have fathered who are alive but do not live with you? - Radio: Yes=1, No=2 [If No -> 206]
5. Q_205: a) How many sons are alive but do not live with you? If none, record '00'. b) And how many daughters are alive but do not live with you? If none, record '00'. - Numeric: a) Sons elsewhere, b) Daughters elsewhere
6. Q_206: Have you ever fathered a son or a daughter who was born alive but later died? If no, probe: Any baby who cried, who made any movement, sound, or effort to breathe, or who showed any other signs of life even if for a very short time? - Radio: Yes=1, No=2, Don't Know=8 [If No or DK -> 208]
7. Q_207: a) How many boys have died? If none, record '00'. b) And how many girls have died? If none, record '00'. - Numeric: a) Boys dead, b) Girls dead
8. Q_208: Sum answers to 203, 205, and 207, and enter total. If none, record '00'. - Numeric: Total children
9. Q_209: CHECK 208: Has had more than one child -> continue; Has had only one child -> 211; Has not had any children -> 301 - Filter/CHECK [If only one child -> 211; If no children -> 301]
10. Q_210: Did all of the children you have fathered have the same biological mother? - Radio: Yes=1, No=2
11. Q_211: CHECK 208: Has had more than one child -> a) How old were you when your first child was born?; Has had only one child -> b) How old were you when your child was born? - Numeric: Age in years
12. Q_212: CHECK 203 and 205: At least one living child -> continue; No living children -> 301 - Filter/CHECK [If no living children -> 301]
13. Q_213: CHECK 203 and 205: More than one living child -> a) How old is your youngest child?; Only one living child -> b) How old is your child? - Numeric: Age in years
14. Q_214: CHECK 213: (Youngest) child is age 0-2 years -> continue; (Youngest) child is age 3 years or older -> 301 - Filter/CHECK [If age 3+ -> 301]
15. Q_215: CHECK 203 and 205: More than one living child -> a) What is the name of your youngest child?; Only one living child -> b) What is the name of your child? - Open text: Name of (youngest) child
16. Q_216: When (name in 215)'s mother was pregnant with (name in 215), did she have any antenatal check-ups? - Radio: Yes=1, No=2, Don't Know=8 [If No or DK -> 218]
17. Q_217: Were you ever present during any of those antenatal check-ups? - Radio: Present=1, Not present=2
18. Q_218: Was (name in 215) born in a hospital or health facility? - Radio: Hospital/Health facility=1, Other=2 [If Other -> 301]
19. Q_219: Did you go with (name in 215)'s mother to the hospital or health facility where she gave birth to (name in 215)? - Radio: Yes=1, No=2

### Section 3. Contraception - 22 questions

1. Q_301: Now I would like to talk about family planning - the various ways or methods that a couple can use to delay or avoid a pregnancy. (Introductory statement, no response) - Comment/Intro
2. Q_301_01: Have you heard of Female Sterilization? Probe: Women can have an operation to avoid having any more children. - Radio: Yes=1, No=2
3. Q_301_02: Have you heard of Male Sterilization? Probe: Men can have an operation to avoid having any more children. - Radio: Yes=1, No=2
4. Q_301_03: Have you heard of IUD? Probe: Women can have a loop or coil placed inside them by a doctor or a nurse which can prevent pregnancy for one or more years. - Radio: Yes=1, No=2
5. Q_301_04: Have you heard of Injectables? Probe: Women can have an injection by a health provider that stops them from becoming pregnant for one or more months. - Radio: Yes=1, No=2
6. Q_301_05: Have you heard of Implants? Probe: Women can have one or more small rods placed in their upper arm by a doctor or nurse which can prevent pregnancy for one or more years. - Radio: Yes=1, No=2
7. Q_301_06: Have you heard of Pill? Probe: Women can take a pill every day to avoid becoming pregnant. - Radio: Yes=1, No=2
8. Q_301_07: Have you heard of Condom? Probe: Men can put a rubber sheath on their penis before sexual intercourse. - Radio: Yes=1, No=2
9. Q_301_08: Have you heard of Female Condom? Probe: Women can place a sheath in their vagina before sexual intercourse. - Radio: Yes=1, No=2
10. Q_301_09: Have you heard of Emergency Contraception? Probe: As an emergency measure, within 3 days after they have unprotected sexual intercourse, women can take special pills to prevent pregnancy. - Radio: Yes=1, No=2
11. Q_301_10: Have you heard of Standard Days Method? Probe: A woman uses a string of colored beads to know the days she can get pregnant. On the days she can get pregnant, she uses a condom or does not have sexual intercourse. - Radio: Yes=1, No=2
12. Q_301_11: Have you heard of Lactational Amenorrhea Method (LAM)? Probe: Up to 6 months after childbirth, before the menstrual period has returned, women use a method requiring frequent breastfeeding day and night. - Radio: Yes=1, No=2
13. Q_301_12: Have you heard of Rhythm Method? Probe: To avoid pregnancy, women do not have sexual intercourse on the days of the month they think they can get pregnant. - Radio: Yes=1, No=2
14. Q_301_13: Have you heard of Withdrawal? Probe: Men can be careful and pull out before climax. - Radio: Yes=1, No=2
15. Q_301_14: Have you heard of any other ways or methods that women or men can use to avoid pregnancy? - Radio: Yes, Modern Method=A (specify), Yes, Traditional Method=B (specify), No=Y
16. Q_302: In the last 12 months have you: a) Heard about family planning on the radio? b) Seen anything about family planning on the television? c) Read about family planning in a newspaper or magazine? d) Received a voice or text message about family planning on a mobile phone? e) Seen anything about family planning on social media such as Facebook, Twitter, or Instagram? f) Seen anything about family planning on a poster, leaflet or brochure? g) Seen anything about family planning on an outdoor sign or billboard? h) Heard anything about family planning at community meetings or events? - Y/N each: Yes=1, No=2 (8 sub-items: a-h)
17. Q_303: In the last few months, have you discussed family planning with a health worker or health professional? - Radio: Yes=1, No=2
18. Q_304: Now I would like to ask you about a woman's risk of pregnancy. From one menstrual period to the next, are there certain days when a woman is more likely to become pregnant when she has sexual relations? - Radio: Yes=1, No=2, Don't Know=8 [If No or DK -> 306]
19. Q_305: Is this time just before her period begins, during her period, right after her period has ended, or halfway between two periods? - Radio: Just before her period begins=1, During her period=2, Right after her period has ended=3, Halfway between two periods=4, Other=6 (specify), Don't Know=8
20. Q_306: After the birth of a child, can a woman become pregnant before her menstrual period has returned? - Radio: Yes=1, No=2, Don't Know=8
21. Q_307a: Contraception is a woman's concern and a man should not have to worry about it. - Radio: Agree=1, Disagree=2, Don't Know=8
22. Q_307b: Women who use contraception may become promiscuous. - Radio: Agree=1, Disagree=2, Don't Know=8

### Section 4. Marriage and Sexual Activity - 29 questions

1. Q_401: Are you currently married or living together with a woman as if married? - Radio: Yes, currently married=1, Yes, living with a woman=2, No, not in union=3 [If 1 or 2 -> 404]
2. Q_402: Have you ever been married or lived together with a woman as if married? - Radio: Yes, formerly married=1, Yes, lived with a woman=2, No=3 [If No -> 413]
3. Q_403: What is your marital status now: are you widowed, divorced, or separated? - Radio: Widowed=1, Divorced=2, Separated=3 [If Divorced or Separated -> 410]
4. Q_404: Is your (wife/partner) living with you now or is she staying elsewhere? - Radio: Living with him=1, Staying elsewhere=2
5. Q_405: Do you have other wives or do you live with other women as if married? - Radio: Yes (more than one wife)=1, No (only one wife)=2 [If No -> 407]
6. Q_406: Altogether, how many wives or live-in partners do you have? - Numeric: Total number of wives and live-in partners
7. Q_407: CHECK 405: One wife/partner -> a) Please tell me the name of your (wife/partner). Record name and line number from household questionnaire. If not listed, record '00'. More than one wife/partner -> b) Please tell me the name of your (first/next) wife or woman you are living with as if married. Record name, line number. Also records Q408 (age) in table for multiple wives. - Open text + Numeric: Name, Line number, Age
8. Q_408: How old was (name in 407) on her last birthday? Return to 407 for the next wife or live-in partner. - Numeric: Age (one entry per wife)
9. Q_409: CHECK 407: One wife/partner -> continue; More than one wife/partner -> 411 - Filter/CHECK [If more than one -> 411]
10. Q_410: Have you been married or lived with a woman only once or more than once? - Radio: More than once=1, Only once=2
11. Q_411: CHECK 405 and 410: Both are code '2' -> a) In what month and year did you start living with your (wife/partner)?; Other -> b) Now I would like to ask about your first wife or partner. In what month and year did you start living with her? - Numeric: Month (Don't Know Month=98), Year (Don't Know Year=9998) [-> 413]
12. Q_412: How old were you when you first started living with her? - Numeric: Age
13. Q_413: CHECK for presence of others. Before continuing, make every effort to ensure privacy. - Interviewer instruction (no response)
14. Q_414: I would like to ask some questions about sexual activity in order to gain a better understanding of some important life issues... How old were you when you had sexual intercourse for the very first time? - Numeric: Never had sexual intercourse=00, Age in years [If 00 -> 501]
15. Q_415: I would like to ask you about your recent sexual activity. When was the last time you had sexual intercourse? - Radio+Numeric: Days ago=1 (number), Weeks ago=2 (number), Months ago=3 (number), Years ago=4 (number) [If Years ago -> 429]
16. Q_416: The last time you had sexual intercourse, did you or your partner do something or use any method to delay or avoid a pregnancy? - Radio: Yes=1, No=2, Don't Know=8 [If No or DK -> 418]
17. Q_417: Do you know of a place where you can obtain a method of family planning? - Radio: Yes=1, No=2 [-> 419]
18. Q_418: What method did you or your partner use? Record all mentioned. If codes 'G' or 'H' are circled, skip to 420 even if another method was also used. - Checkbox: Female sterilization=A, Male sterilization=B, IUD=C, Injectables=D, Implants=E, Pill=F, Condom=G, Female condom=H, Emergency contraception=I, Standard days method=J, Lactational amenorrhea method=K, Rhythm method=L, Withdrawal=M, Other modern method=X, Other traditional method=Y [If G or H -> 420]
19. Q_419: The last time you had sexual intercourse, was a condom used? - Radio: Yes=1, No=2 [If No -> 422]
20. Q_420: What was the brand name of the condom used? If brand not known, ask to see the package. - Radio: Brand A=01, Brand B=02, Brand C=03, Other=96 (specify), Don't Know=98
21. Q_421: From where did you obtain the condom the last time? Probe to identify type of source. - Radio: PUBLIC SECTOR: Government hospital=11, Government health center=12, Family planning clinic=13, Mobile clinic=14, Community health worker/Field worker=15, Other public sector=16 (specify); PRIVATE MEDICAL SECTOR: Private hospital=21, Private clinic=22, Pharmacy=23, Private doctor=24, Mobile clinic=25, Community health worker/Field worker=26, Other private medical sector=27 (specify); NGO MEDICAL SECTOR: NGO hospital=31, NGO clinic=32, Other NGO medical sector=36 (specify); OTHER SOURCE: Shop=41, Church=42, Friend/Relative=43, Other=96 (specify); Don't Know=98
22. Q_422: What was your relationship to this person with whom you had sexual intercourse? If girlfriend: Were you living together as if married? If yes, record '2'. If no, record '3'. - Radio: Wife=1, Live-in partner=2, Girlfriend not living with respondent=3, Casual acquaintance=4, Client/Sex worker=5, Other=6 (specify)
23. Q_423: Apart from this person, have you had sexual intercourse with any other person in the last 12 months? - Radio: Yes=1, No=2 [If No -> 429]
24. Q_424: The last time you had sexual intercourse with this second person, was a condom used? - Radio: Yes=1, No=2
25. Q_425: What was your relationship to this second person with whom you had sexual intercourse? If girlfriend: Were you living together as if married? If yes, record '2'. If no, record '3'. - Radio: Wife=1, Live-in partner=2, Girlfriend not living with respondent=3, Casual acquaintance=4, Client/Sex worker=5, Other=6 (specify)
26. Q_426: Apart from these two people, have you had sexual intercourse with any other person in the last 12 months? - Radio: Yes=1, No=2 [If No -> 429]
27. Q_427: The last time you had sexual intercourse with this third person, was a condom used? - Radio: Yes=1, No=2
28. Q_428: What was your relationship to this third person with whom you had sexual intercourse? If girlfriend: Were you living together as if married? If yes, record '2'. If no, record '3'. - Radio: Wife=1, Live-in partner=2, Girlfriend not living with respondent=3, Casual acquaintance=4, Client/Sex worker=5, Other=6 (specify)
29. Q_429: In total, with how many different people have you had sexual intercourse in your lifetime? If non-numeric answer, probe to get an estimate. If number of partners is 95 or more, record '95'. - Numeric: Number of partners in lifetime, Don't Know=98

### Section 5. Fertility Preferences - 15 questions

1. Q_501: CHECK 401: Currently married or living with a partner -> continue; Not currently married and not living with a partner -> 514 - Filter/CHECK [If not in union -> 514]
2. Q_502: CHECK 418: Man not sterilized or question not asked -> continue; Man sterilized -> 514 - Filter/CHECK [If sterilized -> 514]
3. Q_503: CHECK 407: One wife/partner -> continue (Q504-Q508 track); More than one wife/partner -> 509 - Filter/CHECK [If more than one -> 509]
4. Q_504: Is your (wife/partner) currently pregnant? - Radio: Yes=1, No=2, Don't Know=8 [If No or DK -> 507]
5. Q_505: Now I have some questions about the future. After the child you and your (wife/partner) are expecting now, would you like to have another child, or would you prefer not to have any more children? - Radio: Have another child=1, No more=2, Undecided/Don't Know=8 [If No more or DK -> 514]
6. Q_506: After the birth of the child you are expecting now, how long would you like to wait before the birth of another child? - Radio+Numeric: Months=1 (number), Years=2 (number), Soon/Now=993, Other=996 (specify), Don't Know=998 [-> 514]
7. Q_507: CHECK 208: Has fathered children -> a) Would you like to have another child, or would you prefer not to have any more children?; Has not fathered children -> b) Would you like to have a child, or would you prefer not to have any children? - Radio: Have (a/another) child=1, No more/None=2, Says couple can't get pregnant=3, Wife/Partner sterilized=4, Respondent sterilized=5, Undecided/Don't Know=8 [If 2-5 or 8 -> 514]
8. Q_508: CHECK 208: Has fathered children -> a) How long would you like to wait from now before the birth of another child?; Has not fathered children -> b) How long would you like to wait from now before the birth of a child? - Radio+Numeric: Months=1 (number), Years=2 (number), Soon/Now=993, Says couple can't get pregnant=994, Other=996 (specify), Don't Know=998 [-> 514]
9. Q_509: Are any of your wives or partners currently pregnant? - Radio: Yes=1, No=2, Don't Know=8 [If No or DK -> 512]
10. Q_510: After the child you and your wife or partner are expecting now, would you like to have another child, or would you prefer not to have any more children? - Radio: Have another child=1, No more=2, Undecided/Don't Know=8 [If No more or DK -> 514]
11. Q_511: After the birth of the child you are expecting now, how long would you like to wait before the birth of another child? - Radio+Numeric: Months=1 (number), Years=2 (number), Soon/Now=993, Other=996 (specify), Don't Know=998 [-> 514]
12. Q_512: CHECK 208: Has fathered children -> a) Would you like to have another child?; Has not fathered children -> b) Would you like to have a child? - Radio: Have (a/another) child=1, No more/None=2, Says couple can't get pregnant=3, Wife/Wives/Partner(s) sterilized=4, Respondent sterilized=5, Undecided/Don't Know=8 [If 2-5 or 8 -> 514]
13. Q_513: CHECK 208: Has fathered children -> a) How long would you like to wait?; Has not fathered children -> b) How long would you like to wait? - Radio+Numeric: Months=1 (number), Years=2 (number), Soon/Now=993, Says couple can't get pregnant=994, Other=996 (specify), Don't Know=998 [-> 514]
14. Q_514: CHECK 203 and 205: Has living children -> a) If you could go back to the time you did not have any children and could choose exactly the number of children to have in your whole life, how many would that be?; No living children -> b) If you could choose exactly the number of children to have in your whole life, how many would that be? Probe for a numeric response. - Numeric: None=00, Number, Other=96 (specify) [If 00 or 96 -> 601]
15. Q_515: How many of these children would you like to be boys, how many would you like to be girls and for how many would it not matter if it's a boy or a girl? - Numeric: Boys (number), Girls (number), Either (number), Other=96 (specify)

### Section 6. Employment and Gender Roles - 22 questions

1. Q_601: Have you done any work in the last 7 days? - Radio: Yes=1, No=2 [If Yes -> 604]
2. Q_602: Although you did not work in the last 7 days, do you have any job or business from which you were absent for leave, illness, vacation, or any other such reason? - Radio: Yes=1, No=2 [If Yes -> 604]
3. Q_603: Have you done any work in the last 12 months? - Radio: Yes=1, No=2 [If No -> 607]
4. Q_604: What is your occupation? That is, what kind of work do you mainly do? - Open text: Occupation (with numeric code)
5. Q_605: Do you usually work throughout the year, or do you work seasonally, or only once in a while? - Radio: Throughout the year=1, Seasonally/Part of the year=2, Once in a while=3
6. Q_606: Are you paid in cash or kind for this work or are you not paid at all? - Radio: Cash only=1, Cash and kind=2, In kind only=3, Not paid=4
7. Q_607: CHECK 401: Currently married or living with a partner -> continue; Not currently married and not living with a partner -> 612 - Filter/CHECK [If not in union -> 612]
8. Q_608: CHECK 606: Code '1' or '2' circled -> continue; Other -> 610 - Filter/CHECK [If not paid cash -> 610]
9. Q_609: Who usually decides how the money you earn will be used: you, your (wife/partner), or you and your (wife/partner) jointly? - Radio: Respondent=1, Wife/Partner=2, Respondent and wife/partner jointly=3, Other=6 (specify)
10. Q_610: Who usually makes decisions about health care for yourself: you, your (wife/partner), you and your (wife/partner) jointly, or someone else? - Radio: Respondent=1, Wife/Partner=2, Respondent and wife/partner jointly=3, Someone else=4, Other=6
11. Q_611: Who usually makes decisions about making major household purchases? - Radio: Respondent=1, Wife/Partner=2, Respondent and wife/partner jointly=3, Someone else=4, Other=6
12. Q_612: Do you own this or any other house either alone or jointly with someone else? - Radio: Alone only=01, Jointly with wife/partner only=02, Jointly with someone else only=03, Jointly with wife/partner and someone else=04, Both alone and jointly=05, Does not own=06 [If Does not own -> 615]
13. Q_613: Do you have a title deed or other government recognized document for any house you own? - Radio: Yes=1, No=2, Don't Know=8 [If No or DK -> 615]
14. Q_614: Is your name on this document? - Radio: Yes=1, No=2, Don't Know=8
15. Q_615: Do you own any agricultural or non-agricultural land either alone or jointly with someone else? - Radio: Alone only=01, Jointly with wife/partner only=02, Jointly with someone else only=03, Jointly with wife/partner and someone else=04, Both alone and jointly=05, Does not own=06 [If Does not own -> 617A]
16. Q_616: Do you have a title deed or other government recognized document for any land you own? - Radio: Yes=1, No=2, Don't Know=8 [If No or DK -> 617A]
17. Q_617: Is your name on this document? - Radio: Yes=1, No=2, Don't Know=8
18. Q_617A: Do you have an account in a bank or other financial institution that you yourself use? - Radio: Yes=1, No=2 [If No -> 617C]
19. Q_617B: Did you yourself put money in or take money out of this account in the last 12 months? - Radio: Yes=1, No=2
20. Q_617C: In the last 12 months, have you used a mobile phone to make financial transactions such as sending or receiving money, paying bills, purchasing goods or services, or receiving wages? - Radio: Yes=1, No=2
21. Q_618: In your opinion, is a husband justified in hitting or beating his wife in the following situations: a) If she goes out without telling him? b) If she neglects the children? c) If she argues with him? d) If she refuses to have sex with him? e) If she burns the food? - Y/N/DK each: Yes=1, No=2, Don't Know=8 (5 sub-items: a-e)
22. Q_619: As far as you know did your father ever beat your mother? - Radio: Yes=1, No=2, Don't Know=8

### Section 7. HIV/AIDS - 37 questions

1. Q_700: Now I would like to talk about HIV and AIDS. - Comment/Intro (no response)
2. Q_701: Have you ever heard of HIV or AIDS? - Radio: Yes=1, No=2 [If No -> 729]
3. Q_702: CHECK 111 (Age): 15-24 years -> continue; 25 years or older -> 708 - Filter/CHECK [If 25+ -> 708]
4. Q_703: HIV is the virus that can lead to AIDS. Can people reduce their chance of getting HIV by having just one uninfected sex partner who has no other sex partners? - Radio: Yes=1, No=2, Don't Know=8
5. Q_704: Can people get HIV from mosquito bites? - Radio: Yes=1, No=2, Don't Know=8
6. Q_705: Can people reduce their chance of getting HIV by using a condom every time they have sex? - Radio: Yes=1, No=2, Don't Know=8
7. Q_706: Can people get HIV by sharing food with a person who has HIV? - Radio: Yes=1, No=2, Don't Know=8
8. Q_707: Is it possible for a healthy-looking person to have HIV? - Radio: Yes=1, No=2, Don't Know=8
9. Q_708: Have you heard of ARVs, that is, antiretroviral medicines that treat HIV? - Radio: Yes=1, No=2
10. Q_709: Are there any special medicines that a doctor or a nurse can give to a woman infected with HIV to reduce the risk of transmission to the baby? - Radio: Yes=1, No=2, Don't Know=8
11. Q_710: Have you heard of PrEP, a medicine taken daily that can prevent a person from getting HIV? - Radio: Yes=1, No=2 [If No -> 712]
12. Q_711: Do you approve of people who take a pill every day to prevent getting HIV? - Radio: Yes=1, No=2, Don't Know/Not Sure/Depends=8
13. Q_712: CHECK for presence of others. Before continuing, make every effort to ensure privacy. - Interviewer instruction (no response)
14. Q_713: Have you ever been tested for HIV? - Radio: Yes=1, No=2 [If No -> 721]
15. Q_714: In what month and year was your most recent HIV test? - Numeric: Month (Don't Know Month=98), Year (Don't Know Year=9998)
16. Q_715: Where was the test done? Probe to identify type of source. - Radio: PUBLIC SECTOR: Government hospital=11, Government health center=12, Stand-alone HTC center=13, Family planning clinic=14, Mobile HTC services=15, Other public sector=16 (specify); PRIVATE MEDICAL SECTOR: Private hospital=21, Private clinic=22, Private doctor=23, Stand-alone HTC center=24, Pharmacy=25, Mobile HTC services=26, Other private medical sector=27 (specify); NGO MEDICAL SECTOR: NGO hospital=31, NGO clinic=32, Other NGO medical sector=36 (specify); OTHER SOURCE: Home=41, Workplace=42, Correctional facility=43, Other=96 (specify)
17. Q_716: Did you get the results of the test? - Radio: Yes=1, No=2 [If No -> 720]
18. Q_717: What was the result of the test? - Radio: Positive=1, Negative=2, Indeterminate=3, Declined to answer=4 [If 2, 3, or 4 -> 720]
19. Q_718: In what month and year did you receive your first HIV-positive test result? - Numeric: Month (Don't Know Month=98), Year (Don't Know Year=9998), Same date as most recent HIV test=95
20. Q_719: Are you currently taking ARVs, that is antiretroviral medicines? By currently, I mean that you may have missed some doses but you are still taking ARVs. - Radio: Yes=1, No=2, Don't Know=8
21. Q_720: How many times have you been tested for HIV in your lifetime? If non-numeric answer, probe to get an estimate. If number of tests is 95 or more, record '95'. - Numeric: Number of HIV tests
22. Q_721: Have you heard of test kits people can use to test themselves for HIV? - Radio: Yes=1, No=2 [If No -> 723]
23. Q_722: Have you ever tested yourself for HIV using a self-test kit? - Radio: Yes=1, No=2
24. Q_723: Would you buy fresh vegetables from a shopkeeper or vendor if you knew that this person had HIV? - Radio: Yes=1, No=2, Don't Know/Not Sure/Depends=8
25. Q_724: Do you think children living with HIV should be allowed to attend school with children who do not have HIV? - Radio: Yes=1, No=2, Don't Know/Not Sure/Depends=8
26. Q_725: CHECK 717: Code '1' circled (positive) -> continue; Other -> 729 - Filter/CHECK [If not positive -> 729]
27. Q_726: Now I would like to ask you a few questions about your experiences living with HIV. Have you disclosed your HIV status to anyone other than me? - Radio: Yes=1, No=2
28. Q_727: Do you agree or disagree with the following statement: I have felt ashamed because of my HIV status. - Radio: Agree=1, Disagree=2
29. Q_728: Please tell me if the following things have happened to you, or if you think they have happened to you, because of your HIV status in the last 12 months: a) People have talked badly about me because of my HIV status. b) Someone else disclosed my HIV status without my permission. c) I have been verbally insulted, harassed, or threatened because of my HIV status. d) Healthcare workers talked badly about me because of my HIV status. e) Healthcare workers yelled at me, scolded me, called me names, or verbally abused me in another way because of my HIV status. - Y/N each: Yes=1, No=2 (5 sub-items: a-e)
30. Q_729: CHECK 701: Heard about HIV or AIDS -> a) Apart from HIV, have you heard about other infections that can be transmitted through sexual contact?; Not heard about HIV or AIDS -> b) Have you heard about infections that can be transmitted through sexual contact? - Radio: Yes=1, No=2
31. Q_730: CHECK 414: Has had sexual intercourse -> continue; Never had sexual intercourse -> 735 - Filter/CHECK [If never -> 735]
32. Q_731: CHECK 729: Heard about other sexually transmitted infections? Yes -> continue; No -> 733 - Filter/CHECK [If No -> 733]
33. Q_732: Now I would like to ask you some questions about your health in the last 12 months. During the last 12 months, have you had a disease which you got through sexual contact? - Radio: Yes=1, No=2, Don't Know=8
34. Q_733: Sometimes men experience an abnormal discharge from their penis. During the last 12 months, have you had an abnormal discharge from your penis? - Radio: Yes=1, No=2, Don't Know=8
35. Q_734: Sometimes men have a sore or ulcer on or near their penis. During the last 12 months, have you had a sore or ulcer on or near your penis? - Radio: Yes=1, No=2, Don't Know=8
36. Q_735: If a wife knows her husband has a disease that she can get during sexual intercourse, is she justified in asking that they use a condom when they have sex? - Radio: Yes=1, No=2, Don't Know=8
37. Q_736: Is a wife justified in refusing to have sex with her husband when she knows he has sex with other women? - Radio: Yes=1, No=2, Don't Know=8

### Section 8. Other Health Issues - 19 questions

1. Q_801: Some men are circumcised. Are you circumcised? - Radio: Yes=1, No=2, Don't Know=8 [If No or DK -> 806]
2. Q_802: Some men are traditionally circumcised by a traditional practitioner, family member or friend. Are you traditionally circumcised? - Radio: Yes=1, No=2, Don't Know=8 [If No or DK -> 804]
3. Q_803: How old were you when you got traditionally circumcised? - Numeric: Age in completed years, During childhood (<5 years)=95, Don't Know=98
4. Q_804: Some men are medically circumcised, that is, the foreskin is completely removed from the penis by a healthcare worker. Are you medically circumcised? - Radio: Yes=1, No=2, Don't Know=8 [If No or DK -> 806]
5. Q_805: How old were you when you got medically circumcised? - Numeric: Age in completed years, During childhood (<5 years)=95, Don't Know=98
6. Q_806: Do you currently smoke tobacco every day, some days, or not at all? - Radio: Every day=1, Some days=2, Not at all=3 [If 1 -> 809; If 3 -> 808]
7. Q_807: In the past, have you smoked tobacco every day? - Radio: Yes=1, No=2 [If Yes -> 810]
8. Q_808: In the past, have you ever smoked tobacco every day, some days, or not at all? - Radio: Every day=1, Some days=2, Not at all=3 [-> 811]
9. Q_809: On average, how many of the following products do you currently smoke each day? Also, let me know if you use the product, but not every day. If not every day, record '888'. If not used at all, record '000'. a) Manufactured cigarettes? b) Hand-rolled cigarettes? c) Kreteks? d) Pipes full of tobacco? e) Cigars, cheroots, or cigarillos? f) Number of water pipe sessions? g) Any others? (specify) - Numeric: Number daily for each (7 sub-items: a-g) [-> 811]
10. Q_810: On average, how many of the following products do you currently smoke each week? Also, let me know if you use the product, but not every week. If not every week, record '888'. If not used at all, record '000'. a) Manufactured cigarettes? b) Hand-rolled cigarettes? c) Kreteks? d) Pipes full of tobacco? e) Cigars, cheroots, or cigarillos? f) Number of water pipe sessions? g) Any others? (specify) - Numeric: Number weekly for each (7 sub-items: a-g)
11. Q_811: Do you currently use smokeless tobacco every day, some days, or not at all? - Radio: Every day=1, Some days=2, Not at all=3 [If 2 -> 813; If 3 -> 814]
12. Q_812: On average, how many times a day do you use the following products? Also, let me know if you use the product, but not every day. If not every day, record '888'. If not used at all, record '000'. a) Snuff, by mouth? b) Snuff, by nose? c) Chewing tobacco? d) Betel quid with tobacco? e) Any others? (specify) - Numeric: Times daily for each (5 sub-items: a-e) [-> 814]
13. Q_813: On average, how many times a week do you use the following products? Also, let me know if you use the product, but not every week. If not every week, record '888'. If not used at all, record '000'. a) Snuff, by mouth? b) Snuff, by nose? c) Chewing tobacco? d) Betel quid with tobacco? e) Any others? (specify) - Numeric: Times weekly for each (5 sub-items: a-e)
14. Q_814: Now I would like to ask you some questions about drinking alcohol. Have you ever consumed any alcohol, such as beer, wine, spirits, or [add other local examples]? - Radio: Yes=1, No=2 [If No -> 817]
15. Q_815: During the last one month, on how many days did you have an alcoholic drink? If non-numeric answer, probe to get an estimate. If respondent answers 'every day' or 'almost every day,' code '95'. - Numeric: Did not have even one drink=00, Number of days, Every day/Almost every day=95 [If 00 -> 817]
16. Q_816: We count one drink of alcohol as one can or bottle of beer, one glass of wine, one shot of spirits, or one cup of [add other local examples]. In the last one month, on the days that you drank alcohol, how many drinks did you usually have per day? - Numeric: Number of drinks
17. Q_817: Are you covered by any health insurance? - Radio: Yes=1, No=2 [If No -> 819]
18. Q_818: What type of health insurance are you covered by? Record all mentioned. - Checkbox: Mutual health organization/Community-based health insurance=A, Health insurance through employer=B, Social security=C, Other privately purchased commercial health insurance=D, Other=X (specify)
19. Q_819: Record the time. - Numeric: Hours, Minutes

## TOTAL UNIQUE QUESTION NODES: ~228

Counting methodology: Each independently answerable question or sub-question grid is counted as one node. CHECK filters (105, 116, 118, 209, 211, 212, 213, 214, 409, 411, 501, 502, 503, 507, 508, 512, 513, 514, 607, 608, 702, 725, 729, 730, 731) are counted as nodes since they represent routing decisions. Introductory statements (301, 413, 700, 712) and the consent gate are counted. Multi-part grids (302a-h, 307a-b, 618a-e, 728a-e, 809a-g, 810a-g, 812a-e, 813a-e) are counted as single composite nodes. The 14 contraceptive method awareness questions (301_01 through 301_14) are counted individually.
