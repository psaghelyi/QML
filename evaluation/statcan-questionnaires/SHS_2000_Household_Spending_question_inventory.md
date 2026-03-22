# Survey of Household Spending in 2000 (SHS 1) - Question Inventory

## Document Overview
- **Title**: Survey of Household Spending in 2000
- **Organization**: Statistics Canada
- **Date**: 2000-07-26 (form 8-5400-77.1)
- **Pages**: 60
- **Language**: English (French option noted on cover)
- **Type**: Household expenditure survey questionnaire (interviewer-administered)
- **Catalogue**: STC/HLD-045-60118

## Structure
The questionnaire is organized into 20 lettered sections (A through Y, skipping some letters):
- **A** - Household Composition (per-person demographic roster, up to 6 persons)
- **B** - Dwelling Characteristics (dwelling type, rooms, heating)
- **C** - Facilities Associated with the Dwelling (appliances, equipment)
- **D** - Tenure (ownership/rental status, previous dwellings)
- **E** - Owned Principal Residences (property taxes, insurance, condominium)
- **F** - Purchase and Sale of Homes
- **G** - Mortgages on Owned Principal Residences
- **H** - Renovations and Repairs of Owned Principal Residences
- **I** - Rented Principal Residences (rent, tenant expenses)
- **J** - Utilities and Other Rented Accommodation
- **K** - Owned Secondary Residences and Other Property
- **L** - Household Furnishings and Equipment (47 expenditure items)
- **M** - Home Operation (communications, child care, garden, pets, cleaning, supplies)
- **N** - Food and Alcohol
- **O** - Clothing (per-person by age/sex group)
- **P** - Personal and Health Care
- **Q** - Automobiles and Trucks (per-vehicle, up to 4)
- **R** - Recreational Vehicles and Transportation Services
- **S** - Recreation, Reading Materials and Education
- **T** - Tobacco and Miscellaneous
- **U** - Personal Income (per-person, up to 5)
- **V** - Personal Taxes, Security and Money Gifts (per-person, up to 5)
- **W** - Change in Assets
- **X** - Unincorporated Business
- **Y** - Loans and Other Debts

## Administrative Fields (Cover Page)
1. ADM_001: Stratum / Type / Cluster / Rot. / List - Numeric: [sampling design fields]
2. ADM_002: M (Month) - Numeric: [interview month]
3. ADM_003: C.C. (Collection Centre) - Numeric: [collection centre code]
4. ADM_004: P.C. (Province Code) - Numeric: [province code]
5. ADM_005: If more than one questionnaire, indicate number __ - Numeric
6. ADM_006: of __ - Numeric: [total questionnaires]

## Question Inventory by Section

### Section A - Household Composition - 12 questions (repeated for up to 6 persons)

1. Q_A1: What are the first names of all members of your household? Include in your household everyone who currently lives here and anyone who was part of your household at any time during 2000. - Open text: [First Name per person]
2. Q_A2: What is ___'s relationship to the household reference person? - Radio: {1: "Reference Person", 2: "Spouse", 3: "Son/Daughter", 4: "Other relative", 5: "Not related"} [Person 01 is pre-coded as Reference Person]
3. Q_A3: In what year was ___ born? (If born in 1900 or earlier, enter 1900) - Numeric: [4-digit year]
4. Q_A4: Is ___ male or female? - Radio: {1: "Male", 2: "Female"}
5. Q_A5: What was ___'s marital status on December 31, 2000? Mark one circle. - Radio: {1: "Married spouse of a household member", 2: "Common-law spouse of a household member", 3: "Never married (single)", 4: "Other (separated, divorced or widowed)"}
6. Q_A6: Economic Family Code (at time of interview or last day the person was a member of the household). - Code entry: [letter code, e.g. A]
7. Q_A7: Was ___ a member of this household on December 31, 2000? - Radio: {1: "Yes", 2: "No"}
8. Q_A8: Is ___ a member of this household today? - Radio: {3: "Yes", 4: "No"}
9. Q_A9: For how many weeks in 2000 was ___ a member of this household? - Numeric: [weeks, 00-52] [If one-person household, go to Q.11 after asking this question. If Q.9 is 52, go to Q.12; otherwise ask Q.10]
10. Q_A10: For how many weeks in 2000 did ___ live apart from this household, either as a one-person household, or in another household that no longer exists elsewhere? - Numeric: [weeks] [If total weeks (Q.9 plus Q.10) is 52, go to Q.12; otherwise ask Q.11]
11. Q_A11: Why is total weeks (Q.9 plus Q.10) less than 52? - Radio: {1: "Child born in 2000 or 2001", 2: "Immigrated in 2000 or 2001", 3: "Belonged to a household in existence elsewhere", 4: "Other - Explain in notes"}
12. Q_A12: Use questions 8, 9 and 10 to determine the data collection code and the procedure to follow for each person. - Radio: {1: "Report data for total weeks (Q.9 plus Q.10) - Q.8=Yes and Q.9 is not equal to 00", 2: "Report data only for weeks a member of this household (Q.9) - Q.8=No and Q.9 is not equal to 00", 3: "Report data only for the weeks this person lived apart from this household (Q.10) - Q.8=Yes, Q.9=00 and Q.10 is not equal to 00", 4: "End questions for this person since they became a household member after 2000 - Q.8=Yes, Q.9=00 and Q.10=00", 5: "End questions for this person since not a household member - Q.8=No, Q.9=00 and Q.10=00"}

### Section B - Dwelling Characteristics - 11 questions

13. Q_B1: What type of dwelling did your household live in on December 31, 2000? Mark one circle. - Radio: {01: "Single detached", 02: "Double", 03: "Row or terrace", 04: "Duplex", 05: "Apartment in a building that has less than five storeys", 06: "Apartment in a building that has five or more storeys", 07: "Hotel, rooming or lodging house, camp (e.g., logging, construction)", 08: "Mobile home", 09: "Other - Specify"}
14. Q_B1_specify: Other type of dwelling - Specify - Open text
15. Q_B2: When was this dwelling originally built? Mark one circle. - Radio: {10: "1920 or before", 11: "1921-1945", 12: "1946-1960", 13: "1961-1970", 14: "1971-1980", 15: "1981-1990", 16: "1991-1999", 17: "2000"}
16. Q_B3: Was this dwelling in need of any repairs on December 31, 2000? Exclude remodelling and energy improvements. - Radio: {18: "Yes, major repairs were needed (e.g., corroded pipes, damaged electrical wiring, sagging floors, bulging walls, damp walls and ceilings, crumbling foundation, rotting porches and steps)", 19: "Yes, minor repairs were needed (e.g., small cracks in interior walls and ceilings, broken light fixtures and switches, leaking sinks, cracked or broken window panes, some missing shingles or siding, some peeling paint)", 20: "No, only regular maintenance was needed (e.g., painting, leaking faucets, clogged gutters or eavestroughs)"}
17. Q_B4: How many rooms were there in this dwelling? Include kitchen, bedrooms and finished rooms in the attic or basement. Exclude bathrooms, halls, vestibules and rooms used solely for business purposes. - Numeric: [count]
18. Q_B5: How many bedrooms were there in this dwelling? (If a bachelor apartment, enter "00" bedrooms) - Numeric: [count]
19. Q_B6: How many bathrooms with a bathtub or shower were there in this dwelling? - Numeric: [count]
20. Q_B7: What was the principal heating equipment for this dwelling? Mark one circle. - Radio: {01: "Steam or hot water furnace", 02: "Forced hot air furnace", 03: "Other hot air furnace", 04: "Heating stove (include wood stove)", 05: "Electric heating (include electric baseboard heaters)", 06: "Cookstove", 07: "Other - Specify"}
21. Q_B7_specify: Other heating equipment - Specify - Open text
22. Q_B8: How old was this heating equipment? Mark one circle. - Radio: {08: "5 years or less (1995-2000)", 09: "6 to 10 years (1990-1994)", 10: "11 to 15 years (1985-1989)", 11: "16 to 20 years (1980-1984)", 12: "Over 20 years (Before 1980)"}
23. Q_B9: What was the principal fuel for this heating equipment? Mark one circle. - Radio: {13: "Oil or other liquid fuel", 14: "Piped gas (natural gas)", 15: "Bottled gas (propane)", 16: "Electricity", 17: "Wood", 18: "Other - Specify"}
24. Q_B9_specify: Other principal fuel for heating - Specify - Open text
25. Q_B10: What was the principal fuel for the hot water supply? Mark one circle. - Radio: {19: "Oil or other liquid fuel", 20: "Piped gas (natural gas)", 21: "Bottled gas (propane)", 22: "Electricity", 23: "Wood", 24: "Other - Specify", 25: "No running hot water"}
26. Q_B10_specify: Other principal fuel for hot water - Specify - Open text
27. Q_B11: What was the main fuel used for cooking? Mark one circle. - Radio: {26: "Oil or other liquid fuel", 27: "Piped gas (natural gas)", 28: "Bottled gas (propane)", 29: "Electricity", 30: "Wood", 31: "Other - Specify"}
28. Q_B11_specify: Other main fuel for cooking - Specify - Open text

### Section C - Facilities Associated with the Dwelling - 17 questions

29. Q_C1: How many Refrigerators? (If none, enter 0; if 10 or more, enter 9) - Numeric: [0-9]
30. Q_C2: How many Colour TV sets? - Numeric: [0-9]
31. Q_C3: How many VCRs? - Numeric: [0-9]
32. Q_C4: How many Telephones? Include phones used for business. Exclude cellular phones. - Numeric: [0-9] [If Q.4 is zero, specify reason and go to Q.6; otherwise go to Q.5]
33. Q_C4_specify: Specify reason for zero telephones - Open text
34. Q_C5: How many Telephone numbers for this dwelling? Include phone numbers used for business. Exclude cellular phone numbers. - Numeric: [count]
35. Q_C6: Did you have a cellular phone for personal use? Exclude cordless phones. - Radio: {1: "Yes", 2: "No"}
36. Q_C7: Did you have a microwave oven? - Radio: {3: "Yes", 4: "No"}
37. Q_C8: Did you have a freezer separate from the refrigerator? - Radio: {5: "Yes", 6: "No"}
38. Q_C9: Did you have Cable TV? - Radio: {7: "Yes", 8: "No"}
39. Q_C10: Did you have a CD player? - Radio: {1: "Yes", 2: "No"}
40. Q_C11: Did you have a home computer? Exclude computers used exclusively for business. - Radio: {3: "Yes", 4: "No"} [If No, go to Q.14]
41. Q_C12: Did you have a modem? - Radio: {5: "Yes", 6: "No"} [If No, go to Q.14]
42. Q_C13: Did you use the Internet from home? - Radio: {7: "Yes", 8: "No"}
43. Q_C14: Did you have air conditioning? Mark one circle. - Radio: {1: "Window-type air conditioning units", 2: "Central air conditioning", 3: "None"}
44. Q_C15: Did you have a dishwasher? Mark one circle. - Radio: {4: "A built-in automatic dishwasher", 5: "A portable automatic dishwasher", 6: "None"}
45. Q_C16: Did you have a washing machine (inside your dwelling)? Mark one circle. - Radio: {7: "An automatic washing machine", 8: "Any other kind of washing machine", 9: "None"}
46. Q_C17: Did you have a clothes dryer (inside your dwelling)? Mark one circle. - Radio: {1: "An electric clothes dryer", 2: "A gas clothes dryer", 3: "None"}

### Section D - Tenure - 14 questions

47. Q_D1: On December 31, 2000 was your dwelling: - Radio: {1: "Owned without a mortgage by your household", 2: "Owned with (a) mortgage(s) by your household", 3: "Rented by your household", 4: "Occupied rent-free by your household (i.e. where no member owned the dwelling and no rent was charged)"}
48. Q_D2: In what year did your household move to this dwelling? - Numeric: [4-digit year] [If before 1995, go to instructions after Q.7.4 (page 12)]
49. Q_D3: Did the reference person own or rent their previous dwelling? Mark one circle. - Radio: {1: "Owned", 2: "Rented", 3: "Did not maintain their own dwelling"}
50. Q_D4: Did the spouse of the reference person own or rent their previous dwelling? Mark one circle. - Radio: {4: "Owned", 5: "Rented", 6: "Did not maintain their own dwelling"} [If no spouse, go to Q.5]
51. Q_D5: Did anyone in this household report TOTAL WEEKS equal to 52? (See Section A, Q.9 plus Q.10) - Radio: {1: "Yes", 2: "No"} [If Yes, go to Q.6]
52. Q_D5.1: For the total weeks reported earlier (Section A, Q.9 plus Q.10), did anyone live in another dwelling? - Radio: {3: "Yes", 4: "No"} [If No, go to instructions after Q.7.4 (page 12)]
53. Q_D6.1: Were any of the dwellings previously occupied in 2000: Owned with (a) mortgage(s) by your household? - Radio: {5: "Yes", 6: "No"}
54. Q_D6.2: Owned without a mortgage by your household? - Radio: {7: "Yes", 8: "No"}
55. Q_D6.3: Rented by your household? - Radio: {1: "Yes", 2: "No"}
56. Q_D6.4: Occupied rent-free by your household (i.e. where no member owned the dwelling and no rent was charged)? - Radio: {3: "Yes", 4: "No"} [If Q.6.1 and Q.6.2 are both "No", go to the instructions after Q.7.4]
57. Q_D7.1: Were any of the dwellings previously owned and occupied in 2000: Sold? - Radio: {5: "Yes", 6: "No"}
58. Q_D7.2: Rented to others? - Radio: {7: "Yes", 8: "No"}
59. Q_D7.3: Left vacant? - Radio: {1: "Yes", 2: "No"}
60. Q_D7.4: Other? - Radio: {3: "Yes", 4: "No"}
61. Q_D7.4_specify: Other disposition of previously occupied dwelling - Specify - Open text

### Section E - Owned Principal Residences - 11 questions

62. Q_E1: How many dwellings did members of your household own and occupy in 2000? - Numeric: [count, if none enter "00" and go to Section I (page 19)]
63. Q_E2: For how many months in 2000 did your household own and occupy the dwelling(s)? - Numeric: [months]
64. Q_E3.1: Total amount billed for property taxes in 2000? Include school taxes, special service charges and local improvements billed in 2000. - Dollar amount ($)
65. Q_E3.1_explain: If none, explain - Open text
66. Q_E3.2: Total premiums paid in 2000 for homeowners' insurance covering fire, theft and other perils? - Dollar amount ($)
67. Q_E3.3: Amount paid for condominium charges? Include special levies. - Dollar amount ($)
68. Q_E4: Were any of the expenses just mentioned (in Q.3) charged against income from businesses owned by household members? Exclude rooms rented out (see Q.5). - Radio: {1: "Yes", 2: "No"} [If No, go to Q.5]
69. Q_E4.1: What amount or percentage of the total (Q.3.1 to Q.3.3) was charged against income from your businesses? - Dollar amount ($) OR Percentage (%)
70. Q_E5: Were any of the expenses just mentioned (in Q.3) charged against income from rooms rented out? - Radio: {1: "Yes", 2: "No"} [If No, go to Section F]
71. Q_E5.1.1: What amount or percentage of the total (Q.3.1 to Q.3.3) was charged against income from rooms rented to: Household member(s) excluding relatives? - Dollar amount ($) OR Percentage (%)
72. Q_E5.1.2: Persons who were not members of your household, e.g., students who are members of an eligible household elsewhere? - Dollar amount ($) OR Percentage (%)

### Section F - Purchase and Sale of Homes - 10 questions

73. Q_F1: Did your household purchase a home in 2000? - Radio: {1: "Yes", 2: "No"} [If No, go to Q.2]
74. Q_F1.1: Was this purchase made by (a) person(s) who had never previously owned a dwelling which they occupied? - Radio: {3: "Yes", 4: "No"}
75. Q_F1.2: What was the purchase price of your home? Exclude adjustments to property taxes and fuel oil (see Sections E and J). - Dollar amount ($)
76. Q_F1.3: How much was paid for land transfer taxes and land registration fees? - Dollar amount ($)
77. Q_F2: Did your household sell a home in 2000? - Radio: {1: "Yes", 2: "No"} [If No, go to Q.3]
78. Q_F2.1: What was the selling price of your home? - Dollar amount ($)
79. Q_F2.2: How much was paid for real estate commissions? - Dollar amount ($)
80. Q_F3: In 2000, how much did your household spend on: Legal charges related to the dwelling(s), e.g., title searches and mortgage registration fees? - Dollar amount ($)
81. Q_F4: Other expenses related to the dwelling(s), e.g., surveying, appraisals, renewal fees and early renewal or closing penalties associated with mortgage payments? - Dollar amount ($)
82. Q_F4_specify: Specify other dwelling expenses - Open text

### Section G - Mortgages on Owned Principal Residences - 10 questions

83. Q_G1: In 2000, did your household have any mortgages on dwellings which it owned and occupied? Exclude all other loans (see Sections X and Y). - Radio: {1: "Yes", 2: "No"} [If No, go to Section H]
84. Q_G2.1: In 2000, what payments did your household make on its mortgages? Regular payments? (Amount $ and Number, up to 3 mortgages) - Dollar amount ($) and Numeric [number of payments]
85. Q_G2.2: Irregular and lump sum payments including payments made to close the mortgage? (Amount $ and Number, up to 3 mortgages) - Dollar amount ($) and Numeric [number of payments]
86. Q_G3.1: Did the mortgage payments just reported (in Q.2) include: Property taxes? - Radio: {1: "Yes", 2: "No"}
87. Q_G3.2: Mortgage life and/or disability insurance? - Radio: {3: "Yes", 4: "No"}
88. Q_G3.3: What was the total premium paid in 2000 for mortgage life and/or disability insurance? - Dollar amount ($)
89. Q_G4: Were any amounts added to your mortgage(s) in 2000? Include the amount borrowed if the mortgage started in 2000. Exclude amounts pertaining to business. - Radio: {5: "Yes", 6: "No"} [If No, go to Section H]
90. Q_G4.1: What amounts were added? (up to 4 entries) - Dollar amount ($)

### Section H - Renovations and Repairs of Owned Principal Residences - 3 questions

91. Q_H1: In 2000, how much did your household spend on additions, renovations and other alterations? (Specify description and total cost, up to 3 entries) - Open text [description] + Dollar amount ($) [total cost]
92. Q_H2: In 2000, how much did your household spend on installations of built-in equipment, appliances and fixtures? (Specify description, Replacement $ and New installation $, up to 3 entries) - Open text [description] + Dollar amount ($) [replacement] + Dollar amount ($) [new installation]
93. Q_H3: In 2000, how much did your household spend on repairs and maintenance? (Specify description and total cost, up to 3 entries) - Open text [description] + Dollar amount ($) [total cost]

### Section I - Rented Principal Residences - 14 questions

94. Q_I1: For how many months in 2000 did your household occupy a rented dwelling? - Numeric: [months, if none enter "00" and go to Section J (page 21)]
95. Q_I2: What monthly rental payments were made for the principal residences which your household occupied in 2000? (12-month grid: January through December) - Dollar amount ($) [per month, total calculated]
96. Q_I3: In 2000, what additional amount was paid to the landlord that was not included in the payments just reported, e.g., security deposits? - Dollar amount ($)
97. Q_I4: In 2000, how much of the rent which you paid was returned to your household for any reason, e.g., rent overpayment and return of damage deposit? Exclude provincial tax credits for rent paid and provincial or municipal rent allowances. - Dollar amount ($)
98. Q_I5: Did your household pay reduced rent in 2000 for any of the following reasons: - Radio: {1: "Government subsidized housing? Include federal, provincial and municipal programs.", 2: "Other reasons, e.g., services to landlord and company housing?", 3: "No reduced rent?"}
99. Q_I6.1: In 2000, how much did your household spend on: Additions, renovations, alterations, installations and replacements of equipment and fixtures, and repairs and maintenance for rented dwelling(s) occupied in 2000? Exclude amounts reimbursed by the landlord. - Dollar amount ($)
100. Q_I6.2: Tenants' insurance? - Dollar amount ($)
101. Q_I6.3: Parking at your place of residence? Exclude any amount that was included in previous answers on rent expenses. - Dollar amount ($)
102. Q_I7: In 2000, was any part of the rent expense charged against income from businesses owned by the household members? Exclude rooms rented out (see Q.8). - Radio: {1: "Yes", 2: "No"} [If No, go to Q.8]
103. Q_I7.1: What amount or percentage of the rent expense (Q.2 plus Q.3 plus Q.6 less Q.4) was charged against income from your businesses? - Dollar amount ($) OR Percentage (%)
104. Q_I8: In 2000, was any part of the rent expenses charged against income from rooms rented to others? - Radio: {1: "Yes", 2: "No"} [If No, go to Section J]
105. Q_I8.1.1: What amount or percentage of the rent expense (Q.2 plus Q.3 plus Q.6 less Q.4) was charged against income from rooms rented to: Household member(s) excluding relatives? - Dollar amount ($) OR Percentage (%)
106. Q_I8.1.2: Persons who were not members of your household, e.g., students who are members of an eligible household elsewhere? - Dollar amount ($) OR Percentage (%)

### Section J - Utilities and Other Rented Accommodation - 7 questions

107. Q_J1.1: In 2000, how much did your household spend on: Water and sewage charges (not included in property tax bill), e.g., pumping services? - Dollar amount ($)
108. Q_J1.2: Electricity? - Dollar amount ($)
109. Q_J1.3: Other fuel for heating and cooking, e.g., oil, gas, propane and wood? - Dollar amount ($)
110. Q_J1.4: Rental of heating equipment? - Dollar amount ($)
111. Q_J2.1: In 2000, while away from home overnight or longer, how much did your household spend on: Hotels and motels? - Dollar amount ($)
112. Q_J2.2: Other accommodation? - Dollar amount ($)
113. Q_J2.3: Of this amount (Q.2.1 plus Q.2.2), how much was spent in this province? - Dollar amount ($) OR Percentage (%)

### Section K - Owned Secondary Residences and Other Property - 18 questions

114. Q_K1: In 2000, did any member of your household own a vacation home or other secondary residence? - Radio: {1: "Yes", 2: "No"} [If No, go to Q.7 (page 24)]
115. Q_K2: In 2000, did any member of your household purchase a vacation home or other secondary residence? - Radio: {3: "Yes", 4: "No"} [If No, go to Q.3]
116. Q_K2.1: What was the purchase price? - Dollar amount ($)
117. Q_K3: How much money was borrowed in 2000 for expenses associated with the dwelling(s)? Include purchase as well as mortgage and other financial obligations. - Dollar amount ($)
118. Q_K4: How much were the mortgage payments in 2000? Exclude payments made at time of sale. - Dollar amount ($)
119. Q_K5: Was (were) the dwelling(s) sold in 2000? - Radio: {1: "Yes", 2: "No"} [If No, go to Q.6]
120. Q_K5.1: What was the selling price? - Dollar amount ($)
121. Q_K5.2: What was the net amount received from the sale (the selling price less the amount paid on the outstanding mortgage and the real estate commissions)? - Dollar amount ($)
122. Q_K6.1: In 2000, how much did your household spend on: Additions, renovations and new installations? - Dollar amount ($)
123. Q_K6.2: Repairs, maintenance and replacements? - Dollar amount ($)
124. Q_K6.3: Property taxes and sewage charges? - Dollar amount ($)
125. Q_K6.4: Insurance? - Dollar amount ($)
126. Q_K6.5: Electricity, water and fuel? - Dollar amount ($)
127. Q_K6.6: Other expenses associated with the property, e.g., condominium charges, survey costs, real estate commissions, legal fees and mortgage insurance premiums? - Dollar amount ($)
128. Q_K7: In 2000, did any member of your household own any other property? Exclude principal and secondary residences, rental or other business property, and farm property. - Radio: {1: "Yes", 2: "No"} [If No, go to Section L (page 26)]
129. Q_K8: In 2000, did any member of your household purchase any other property? - Radio: {3: "Yes", 4: "No"} [If No, go to Q.9]
130. Q_K8.1: What was the purchase price? - Dollar amount ($)
131. Q_K9: How much money was borrowed in 2000 for expenses associated with the property (including purchase)? - Dollar amount ($)
132. Q_K10: How much were the mortgage payments in 2000? Exclude payments made at time of sale. - Dollar amount ($)
133. Q_K11: How much did your household spend on additions or major alterations to the property in 2000, e.g., servicing of land? - Dollar amount ($)
134. Q_K12: How much was spent in 2000 on other expenses associated with the property, e.g., property taxes, survey costs, appraisal fees and utilities? - Dollar amount ($)
135. Q_K13: Was any of the property sold in 2000? - Radio: {1: "Yes", 2: "No"} [If No, go to Section L (page 26)]
136. Q_K13.1: What was the selling price? - Dollar amount ($)
137. Q_K13.2: What was the net amount received from the sale (the selling price less the amount paid on the outstanding mortgage and real estate commissions)? - Dollar amount ($)

### Section L - Household Furnishings and Equipment - 47 questions

**Household Furnishings, Art and Antiques**

138. Q_L1: Furniture for indoor or outdoor use? Include mattresses. - Dollar amount ($)
139. Q_L2: Glass mirrors, and mirror and picture frames? - Dollar amount ($)
140. Q_L3: Lamps and lampshades? Exclude light fixtures (see Section H). - Dollar amount ($)
141. Q_L4: Rugs, mats and underpadding? Exclude wall-to-wall carpeting (see Section H). - Dollar amount ($)
142. Q_L5: Window coverings, and household textiles e.g., curtains, blinds, bedding, towels, tablecloths, cushions and bathroom accessories? Include cloth material used to make household furnishings. - Dollar amount ($)
143. Q_L6: Works of art, carvings and vases? - Dollar amount ($)
144. Q_L7: Antiques, e.g., furniture and jewellery that are at least 100 years old? - Dollar amount ($)
145. Q_L8: Maintenance and repair of furniture, carpeting and household textiles? Include cleaning of carpets and furniture. Include re-upholstering of furniture. - Dollar amount ($)

**Audio, Video and Other Home Entertainment Equipment**

146. Q_L9: Audio combinations, components and radios, e.g., tape recorder/players, CD players, receivers, amplifiers and speakers? Include clock and telephone combinations and console systems. Exclude car radios (see Section Q, Q.11, page 43). - Dollar amount ($) [net purchase price]
147. Q_L10: Televisions, VCRs, camcorders and other television/video components? Include combinations, projection and monitor style TVs. - Dollar amount ($) [net purchase price]
148. Q_L11: Compact discs, pre-recorded audiotapes, videos and videodiscs? - Dollar amount ($)
149. Q_L12: Blank audio and video tapes? - Dollar amount ($)
150. Q_L13: Other home entertainment equipment, attachments, accessories and parts purchased separately, e.g., satellite dishes, headphones, microphones, cases, cleaners and coaxial cable? - Dollar amount ($)

**Computer Equipment**

151. Q_L14.1: Computer hardware, e.g., monitors, keyboards, disk drives, printers and mouses: Purchased new? - Dollar amount ($)
152. Q_L14.2: Computer hardware: Purchased used? - Dollar amount ($)
153. Q_L14.3: How much was received from the sale of computer hardware equipment? Exclude items that were traded-in. - Dollar amount ($)
154. Q_L15: Computer software, e.g., operating systems, word-processing, spreadsheet and utilities programs, and multimedia software? - Dollar amount ($)
155. Q_L16: Computer supplies and other equipment, e.g., diskettes, computer paper and diskette storage boxes? - Dollar amount ($)

**Home Entertainment Services**

156. Q_L17: Rental of videos and videodiscs? - Dollar amount ($)
157. Q_L18: Maintenance and repair of home entertainment equipment? Include service contracts. - Dollar amount ($)
158. Q_L19: Rental of cablevision and satellite services in 2000? Include pay TV. - Dollar amount ($)
159. Q_L20: Rental of home entertainment equipment, and other services related to home entertainment equipment and supplies? Include all types of audio, video and computer equipment and supplies mentioned earlier. Exclude rental of video games (see Section S, Q.13, page 49). - Dollar amount ($)
160. Q_L20_specify: Specify rental of home entertainment equipment - Open text

**Major Household Appliances**

161. Q_L21: Refrigerators and freezers? - Dollar amount ($) [net purchase price]
162. Q_L22: Cooking stoves and ranges? - Dollar amount ($) [net purchase price]
163. Q_L23: Microwave and convection ovens? - Dollar amount ($) [net purchase price]
164. Q_L24: Washers and dryers? - Dollar amount ($) [net purchase price]
165. Q_L25: Vacuum cleaners and other rug cleaning equipment? Exclude central vacuum cleaner systems (see Section H, page 17). - Dollar amount ($) [net purchase price]
166. Q_L26: Sewing machines? - Dollar amount ($) [net purchase price]
167. Q_L27: Portable dishwashers? - Dollar amount ($) [net purchase price]
168. Q_L28: Gas barbecues? Exclude electric and charcoal barbecues (see Q.32 and Q.45). - Dollar amount ($)
169. Q_L29: Room air conditioners, portable humidifiers and dehumidifiers? - Dollar amount ($)
170. Q_L30.1: Attachments and parts purchased separately for major household appliances? Include vacuum cleaner bags. - Dollar amount ($)
171. Q_L30.2: Maintenance and repair of major household appliances? Include service contracts. - Dollar amount ($)
172. Q_L31: If your household sold any major household appliances, what was the total amount received in 2000? Exclude appliances that were traded-in. - Dollar amount ($)

**Small Electrical Appliances**

173. Q_L32: Electric food preparation appliances, e.g., toasters, coffee makers, kettles, processors, blenders, electric knives and barbecues? Exclude gas and charcoal barbecues (see Q.28 and Q.45). - Dollar amount ($)
174. Q_L33: Electric hairstyling and personal care appliances, e.g., dryers, clippers, razors, vaporisers and heating pads? Exclude butane and other non-electric hairstyling equipment (see Section P, Q.4, page 39). - Dollar amount ($)
175. Q_L34: All other electric appliances and equipment, e.g., irons, floor polishers, fans, blankets, can openers, extension cords and portable electric space heaters? - Dollar amount ($)

**Equipment for Serving and Preparing Food**

176. Q_L35: Tableware, flatware and knives? Exclude disposable tableware. - Dollar amount ($)
177. Q_L36: Non-electric kitchen and cooking equipment, e.g., pots and pans, mixing bowls, chopping boards, canisters, food keepers, spice racks, food choppers and measuring cups? Exclude knives (see Q.35). - Dollar amount ($)

**Lawn, Garden and Snow Removal Tools, Equipment and Accessories**

178. Q_L37: Power lawn and garden equipment, e.g., mowers, tractors, tillers and hedge trimmers? - Dollar amount ($)
179. Q_L38: Snow blowers? - Dollar amount ($)
180. Q_L39: Other lawn, garden and snow removal tools and equipment, attachments, accessories and parts purchased separately? Include non-power lawn mowers, hoses, sprinklers, clippers, shovels, flower pots, stakes, sprayers and spreaders. - Dollar amount ($)

**Workshop/Garage Tools and Equipment**

181. Q_L40: Power tools and equipment, e.g., electric drills, circular saws, sanders, jigsaws, motors and pumps? - Dollar amount ($)
182. Q_L41: Other tools, e.g., hammers, screwdrivers, measuring tools, tool chests, workbenches, hand saws, soldering irons, scissors, saw blades and drill bits? - Dollar amount ($)

**Other Household Equipment**

183. Q_L42: Non-electric cleaning equipment, e.g., brooms, mops, dish racks, paint rollers, pails and garbage cans? - Dollar amount ($)
184. Q_L43: Luggage, e.g., suitcases, briefcases, trunks, baby carriers? - Dollar amount ($)
185. Q_L44: Home security equipment, e.g., portable smoke detectors, fire extinguishers, burglar alarms, padlocks, safes and security boxes, and escape ladders? Exclude security services (see Q.47) and built-in devices (see Section H, page 17). - Dollar amount ($)
186. Q_L45: Other household equipment, parts and accessories? Include measuring equipment, clocks, timers, non-clinical thermometers; non-electric laundry equipment; calculators, typewriters, drapery hardware, strollers, hangers, fireplace tools, house decorations, ladders, flashlights and charcoal barbecues. - Dollar amount ($)

**Services Related to Household Equipment**

187. Q_L46: Maintenance and repair of household equipment not previously reported? Exclude major home appliances and home entertainment equipment. - Dollar amount ($)
188. Q_L47: Other services related to household furnishings and equipment? Include home security services (including installation), making of keys and draperies, installation of stoves, draperies and other non-fixture equipment, rental of household furnishings, appliances and equipment (excluding home entertainment equipment). - Dollar amount ($)

### Section M - Home Operation - 20 questions

**Communications**

189. Q_M1.1: Telephone services? Include basic and enhanced service charges, long distance charges (net of discounts), equipment rentals, calls from hotels and pay phones, and phone cards. - Dollar amount ($)
190. Q_M1.2: Cellular services? - Dollar amount ($)
191. Q_M1.3: Purchase of equipment, e.g., telephone sets, cellular phones, fax machines and answering machines? - Dollar amount ($)
192. Q_M1.4: Internet services (including access and other charges related to the Internet)? - Dollar amount ($)
193. Q_M1.5: Other charges, e.g., wiring and installation fees, and repairs? Include rental of communication equipment not reported elsewhere. - Dollar amount ($)
194. Q_M2: Postage stamps and other postal and communications services? Include registered mail, special delivery mail, post office boxes, telegrams, couriers, fax services and parcel delivery. - Dollar amount ($)

**Child Care Expenses**

195. Q_M3: Day care centres? - Dollar amount ($)
196. Q_M4: Other child care outside the home? Exclude children's camps, e.g., day camps and summer camps (see Section S, Q.19, page 49). - Dollar amount ($)
197. Q_M5: Child care in the home? - Dollar amount ($)

**Home and Garden Services**

198. Q_M6: Expenses for domestic help, e.g., housekeepers, cleaners, paid companions and house-sitters? Exclude child care (see Q.3 to Q.5). - Dollar amount ($)
199. Q_M7: Horticultural services, snow and garbage removal, e.g., groundskeeping, planting, pruning, tree removal, spraying, consulting services, soil and plant testing, and floral design services? - Dollar amount ($)

**Flowers and Garden Supplies**

200. Q_M8: Nursery and greenhouse stock, cut flowers, floral arrangements and decorative plants? Include shrubs, trees, bulbs, seeds, sod, real Christmas trees, dried arrangements and funeral flowers. - Dollar amount ($)
201. Q_M9: Fertilizers, weed controls, herbicides, soils and soil conditioners? - Dollar amount ($)
202. Q_M10: Insecticides, pesticides and insect repellents? - Dollar amount ($)

**Pet Expenses**

203. Q_M11: Pet food? Include birdseed. - Dollar amount ($)
204. Q_M12: Pet purchase? - Dollar amount ($)
205. Q_M13: Pet related goods, e.g., leashes, litter, collars, aquariums, grooming equipment and doghouses? - Dollar amount ($)
206. Q_M14: Veterinarian services and kennels, grooming and other pet related services? - Dollar amount ($)

**Cleaning Services**

207. Q_M15: Laundry and dry-cleaning services? Include diaper service. - Dollar amount ($)
208. Q_M16: Coin-operated washers and dryers, and self-service dry-cleaning? - Dollar amount ($)

**Household Supplies**

209. Q_M17: Household cleaning supplies? Include detergent, cleaners, waxes, bleach, fabric softeners, drain cleaners, oven cleaners and water softener salt. - Dollar amount ($)
210. Q_M18: Stationery supplies, e.g., giftwrap, greeting cards, writing paper, pens, markers, binders and tape? Exclude school supplies (see Section S, Q.26 and Q.27, page 50). - Dollar amount ($)
211. Q_M19: Other paper and plastic supplies, e.g., facial tissue, paper towels, waxed paper, napkins, foil and plastic wraps, garbage bags and disposable cutlery? - Dollar amount ($)
212. Q_M20: Other household supplies, e.g., light bulbs, dry cell batteries, candles, ice, road salt, adhesives and string? - Dollar amount ($)

### Section N - Food and Alcohol - 12 questions

**Food Purchased from Stores**

213. Q_N1: In 2000, how much did your household spend on food and other groceries purchased from stores, farmer stalls and home delivery? (Average weekly or monthly expenditure x number of weeks or months) - Dollar amount ($)
214. Q_N1.1: Of this grocery expenditure, how much did your household spend on non-food items, e.g., paper products, cleaners, pet food, alcoholic beverages and cigarettes? - Dollar amount ($)
215. Q_N2.1: What additional amounts did your household spend on: Bulk food purchases, e.g., meat in excess of 25 kg (55 lb.) and bulk quantities of produce for freezing? Include charges for cutting, wrapping and freezing. - Dollar amount ($)
216. Q_N2.2: Prepared food and non-alcoholic beverages for parties, weddings, etc. not already reported? - Dollar amount ($)
217. Q_N2.3: Food and non-alcoholic beverages purchased from stores while away from home overnight or longer? - Dollar amount ($)

**Alcohol Purchased from Stores**

218. Q_N3: How much did your household spend on alcoholic beverages purchased from stores (e.g., liquor, beer, wine and grocery stores)? Exclude non-alcoholic beer and wine (see Q.1). - Dollar amount ($)
219. Q_N4: How much did your household spend on supplies and fees for self-made beer, wine or liquor? - Dollar amount ($)

**Food Purchased from Restaurants, etc.**

220. Q_N5: How much did your household spend on meals and snacks? - Dollar amount ($)
221. Q_N5.1: Of this amount, how much did your household spend in this province? - Dollar amount ($) OR Percentage (%)

**Alcoholic Beverages Purchased from Restaurants, etc.**

222. Q_N6: How much did your household spend on alcoholic beverages purchased and consumed in bars, cocktail lounges, restaurants, etc.? Include all taxes and tips. - Dollar amount ($)
223. Q_N6.1: Of this amount, how much did your household spend in this province? - Dollar amount ($) OR Percentage (%)

**Board**

224. Q_N7.1: How much board did your household pay to other private households: For day board and children's lunches? Exclude board paid while away from home overnight or longer (see Q.7.2). Exclude child care expenses already reported (in Section M). - Dollar amount ($)
225. Q_N7.2: While away from home overnight or longer? - Dollar amount ($)

### Section O - Clothing - 16 questions (per-person grids)

**Women and Girls 4 Years and Over (born before 1997) - up to 5 persons**

226. Q_O1: Clothing, e.g., outerwear, suits, dresses, skirts, slacks, sweaters, sleepwear, sportswear, specialized clothing and hosiery? Exclude footwear and accessories. - Dollar amount ($) [per person]
227. Q_O2: Footwear? - Dollar amount ($) [per person]
228. Q_O3: Accessories, e.g., gloves, hats, mitts, purses and umbrellas? - Dollar amount ($) [per person]
229. Q_O4: Jewellery and watches? - Dollar amount ($) [per person]

**Men and Boys 4 Years and Over (born before 1997) - up to 5 persons**

230. Q_O5: Clothing, e.g., outerwear, suits, pants, shirts, sweaters, socks and sportswear? Exclude footwear and accessories. - Dollar amount ($) [per person]
231. Q_O6: Footwear? - Dollar amount ($) [per person]
232. Q_O7: Accessories, e.g., gloves, hats, ties, belts, wallets and umbrellas? - Dollar amount ($) [per person]
233. Q_O8: Jewellery and watches? - Dollar amount ($) [per person]

**Children Under 4 Years (born in 1997 or later) - up to 4 persons**

234. Q_O9: Outerwear, daywear, sleepwear and cloth diapers? - Dollar amount ($) [per person]
235. Q_O10: Disposable diapers? - Dollar amount ($) [per person]
236. Q_O11: Footwear, e.g., shoes, sandals, boots and slippers? - Dollar amount ($) [per person]

**Gifts of Clothing**

237. Q_O12.1: In 2000, how much did your household spend to purchase gifts of clothing for people who were not members of your household: For women and girls 4 years and over on December 31, 2000? - Dollar amount ($)
238. Q_O12.2: For men and boys 4 years and over on December 31, 2000? - Dollar amount ($)
239. Q_O12.3: For children under 4 years on December 31, 2000? - Dollar amount ($)

**Clothing Materials and Services**

240. Q_O13: Clothing material? Exclude cloth for curtains, draperies and furnishings (see Section L, Q.5, page 26). - Dollar amount ($)
241. Q_O14: Notions, e.g., patterns, buttons, zippers, sewing and knitting needles, and tape measures? - Dollar amount ($)
242. Q_O15: Dressmaking, tailoring, clothing storage and other clothing services, e.g., rental of clothing and costumes, and engraving of jewellery? Exclude repairs and alterations (see Q.16). - Dollar amount ($)
243. Q_O16: Maintenance, repair and alteration of clothing, footwear, watches and jewellery? Exclude laundry and dry-cleaning (see Section M, Q.15 and Q.16, page 33). - Dollar amount ($)

### Section P - Personal and Health Care - 16 questions

**Personal Care**

244. Q_P1: Hair grooming services? Include washing, cutting, styling, perming and colouring of hair. Include tips. - Dollar amount ($)
245. Q_P2: Other personal services? Include hair removal, manicures, facials and tanning salons. - Dollar amount ($)
246. Q_P3: Personal care preparations, e.g., soap, shampoo, makeup, skin cream, perfume, shaving cream, sunscreen and nail polish? - Dollar amount ($)
247. Q_P4: Personal care supplies and equipment, e.g., brushes, wigs, hair scissors, razors and razor blades? Include butane hairstyling equipment. Exclude electric equipment (see Section L, Q.33, page 29). - Dollar amount ($)

**Health Insurance Premiums**

248. Q_P5.1: In 2000, how much did your household spend on premiums for: Provincially or Territorially administered hospital, medical and drug plans? - Dollar amount ($)
249. Q_P5.2: Private health insurance plans? Include supplementary coverage to public hospital and medical plans (e.g., semi-private or private bed differential and drugs), extended health benefit packages, drug plans, out-of-country benefits and visitors' benefits. - Dollar amount ($)
250. Q_P5.3: Dental plans (sold as separate policies)? - Dollar amount ($)
251. Q_P5.4: Accident and disability insurance? - Dollar amount ($)

**Direct Costs for Health Care - Eye Care**

252. Q_P6: Prescription eye wear, e.g., contact lenses, eyeglasses and insurance on lenses? - Dollar amount ($)
253. Q_P7: Other eye care goods, e.g., non-prescription eye wear, eyeglass cases and supplies for contact lenses? - Dollar amount ($)
254. Q_P8: Eye exams, eye surgery (e.g., laser surgery), and other eye care services? - Dollar amount ($)

**Dental Care**

255. Q_P9: Dental services and orthodontic and periodontal procedures, e.g., examinations, cleanings, fillings, extractions, x-rays, root canals, and the prescription and fitting of dentures? - Dollar amount ($)

**Other Medical and Health Care**

256. Q_P10: Physicians' care? Include general practitioners and specialists. - Dollar amount ($)
257. Q_P11: Other health care practitioners, e.g., nurses, therapists, chiropractors, osteopaths and podiatrists? - Dollar amount ($)
258. Q_P12: Hospital care (all direct pay charges included in hospital bill)? - Dollar amount ($)
259. Q_P13: Weight control programs, quit-smoking programs and other medical services, e.g., ambulances, rental of medical equipment, laboratory services and nursing homes? - Dollar amount ($)
260. Q_P14: Medicines, drugs and pharmaceutical products prescribed by a doctor? - Dollar amount ($)
261. Q_P15: Other medicines, drugs and pharmaceutical products, e.g., headache or pain remedies, herbal and homeopathic remedies, and vitamins? - Dollar amount ($)
262. Q_P16: Health care supplies and goods, e.g., first aid kits, bandages, hearing aids, thermometers, wheelchairs and other appliances, bathroom scales and elastic hosiery? - Dollar amount ($)

### Section Q - Automobiles and Trucks - 22 questions (per-vehicle, up to 4)

263. Q_Q1: In 2000, did anyone in your household own, lease or operate a car, van or truck and use it completely or partially for private use? Exclude rented vehicles (see Q.20). - Radio: {1: "Yes", 2: "No"} [If No, go to Q.20 (page 44)]
264. Q_Q2: Which of the following best describes this vehicle? - Radio: {1: "Car", 2: "Van/mini-van", 3: "Truck/sport utility vehicle"} [per vehicle]
265. Q_Q3: When you bought or leased this vehicle, was it new or used? - Radio: {4: "New", 5: "Used"} [per vehicle]
266. Q_Q4: Did you buy this vehicle in 2000? - Radio: {6: "Yes", 7: "No"} [If No, go to Q.6] [per vehicle]
267. Q_Q5: What was the purchase price after the trade-in allowance was deducted? Include all sales taxes. - Dollar amount ($) [per vehicle]
268. Q_Q6: Was this vehicle leased in 2000? - Radio: {1: "Yes", 2: "No"} [If No, go to Q.7] [per vehicle]
269. Q_Q6.1: What was the total leasing cost paid in 2000? Include down payment. Exclude operating costs and any amount charged to business. - Dollar amount ($) [per vehicle]
270. Q_Q7: What was the status of this vehicle at December 31, 2000? - Radio: {1: "Owned", 2: "Leased", 3: "Returned to lessor", 4: "Sold separately or traded-in on lease", 5: "Traded-in on purchase", 6: "Owned/leased by non-household member", 7: "Other - Specify"} [per vehicle; codes 2,3 go to Q.10; code 4 go to Q.8; code 5 go to Q.9; code 6 go to Q.10]
271. Q_Q7_specify: Other vehicle status - Specify - Open text [per vehicle]
272. Q_Q8: If sold separately or traded-in on lease, what was the net amount received? Exclude any amount paid to business. - Dollar amount ($) [per vehicle]
273. Q_Q9: If traded-in on purchase, what was the vehicle's trade-in value? - Dollar amount ($) [per vehicle]

**Automobile and Truck Operation (per vehicle)**

274. Q_Q10: Gas and other fuels, e.g., diesel fuel and propane? - Dollar amount ($) [per vehicle]
275. Q_Q11: Accessories and attachments, e.g., radios, CD players, block and other heaters, baby seats, car top carriers and seat covers? - Dollar amount ($) [per vehicle]
276. Q_Q12: Tires, batteries and other automotive parts and supplies purchased separately, e.g., mufflers, spark plugs, oil and antifreeze? - Dollar amount ($) [per vehicle]
277. Q_Q13: Other maintenance and repair expenses, e.g., oil changes, tune-ups, brakes and body work? Include repairs to other parties' vehicles which were paid by household members. Exclude amounts paid by insurance or by persons who were not members of your household. - Dollar amount ($) [per vehicle]
278. Q_Q14: Vehicle registration fees? Include insurance that is paid with registration fees. - Dollar amount ($) [per vehicle]
279. Q_Q15: Vehicle insurance premiums? Exclude insurance that is paid with registration fees (see Q.14). - Dollar amount ($) [per vehicle]
280. Q_Q16: Parking costs, e.g., at work, at school, park-ride and parking meters? Exclude parking at place of residence. - Dollar amount ($) [per vehicle]
281. Q_Q17: Other operation services, e.g., auto association fees, towing, and toll and bridge fees? - Dollar amount ($) [per vehicle]
282. Q_Q18: What amount or percentage of the total operating expenses (Q.10 to Q.17) was charged to business or reimbursed? Exclude leasing fees charged to business. - Dollar amount ($) OR Percentage (%) [per vehicle]
283. Q_Q19: What was the value of repair jobs which were covered by insurance and not paid by this household? - Dollar amount ($) [per vehicle]

**Expenditures for Rented Vehicles**

284. Q_Q20.1: In 2000, how much did your household spend on: Rented cars? (Rental Fees / Gas and Other Fuels / Other Expenses) - Dollar amount ($) [3 columns]
285. Q_Q20.2: Rented trucks or vans? (Rental Fees / Gas and Other Fuels / Other Expenses) - Dollar amount ($) [3 columns]

**Miscellaneous Vehicle Expenses**

286. Q_Q21: Drivers' licences and tests? Report government insurance if included. - Dollar amount ($)
287. Q_Q22: Driving lessons? - Dollar amount ($)

### Section R - Recreational Vehicles and Transportation Services - 17 questions

**Bicycles**

288. Q_R1: Purchase of bicycles, parts and accessories? Exclude children's bicycles with wheels under 14 inches (see Section S, Q.9, page 48). - Dollar amount ($)
289. Q_R2: Bicycle maintenance and repairs? - Dollar amount ($)

**Other Recreational Vehicles**

290. Q_R3: In 2000, did anyone in your household own or operate any of the following and use it completely or partially for private use? Exclude rented or leased vehicles (see Q.14). - Radio: {1: "Yes", 2: "No"} [If No, go to Q.14 (page 46)] (Types: 1-Motorcycle, 2-Snowmobile, 3-Tent trailer, 4-Travel trailer, 5-Truck camper, 6-Boat or canoe, 7-Outboard motor/personal water craft, 8-Motor home, 9-Other)
291. Q_R4: Type of vehicle? (Enter code from Q.3) - Numeric: [code 1-9, per vehicle up to 4]
292. Q_R4.1: If code 9, specify vehicle type - Open text [per vehicle]
293. Q_R5: If purchased in 2000, what was the price after the trade-in allowance was deducted? Include all sales taxes. - Dollar amount ($) [per vehicle]

**Operating Expenses (per vehicle, up to 4)**

294. Q_R6: Accessories, attachments, supplies and parts purchased separately for maintenance and repair? - Dollar amount ($) [per vehicle]
295. Q_R7: Gasoline, diesel fuel, etc.? Exclude fuels for cooking, heating, etc. (see Section S, Q.12, page 49). - Dollar amount ($) [per vehicle]
296. Q_R8: Maintenance and repair jobs not covered by insurance? - Dollar amount ($) [per vehicle]
297. Q_R9: Vehicle insurance premiums paid for in 2000? - Dollar amount ($) [per vehicle]
298. Q_R10: Registration fees and licences paid for in 2000? - Dollar amount ($) [per vehicle]
299. Q_R11: Other expenses, e.g., parking, hangar and airport fees, mooring and boat storage, and harbour dues? - Dollar amount ($) [per vehicle]
300. Q_R12: What amount or percentage of the total operating expenses (Q.6 to Q.11) was charged to business? - Dollar amount ($) OR Percentage (%) [per vehicle]
301. Q_R13: If sold separately (not traded-in) in 2000, what was the net amount received? - Dollar amount ($) [per vehicle]

302. Q_R14: In 2000, how much were your household's total expenses for rented or leased recreational vehicles? - Dollar amount ($)

**Transportation Services**

303. Q_R15.1: In 2000, how much did your household spend on transportation by: City or commuter bus, subway, streetcar or commuter train? - Dollar amount ($)
304. Q_R15.2: Taxi (including tips)? - Dollar amount ($)
305. Q_R15.3: Airplane? - Dollar amount ($)
306. Q_R15.4: Train (including sleeping car)? - Dollar amount ($)
307. Q_R15.5: Highway bus? - Dollar amount ($)
308. Q_R15.6: Other passenger transportation, e.g., carpooling, airport bus or limousine service, ferry service, sightseeing tours and travel insurance? - Dollar amount ($)
309. Q_R16: In 2000, how much did your household spend on household moving, storage services and delivery services? - Dollar amount ($)

**Package Trips**

310. Q_R17: In 2000, did any member of your household take a trip that included a package? - Radio: {1: "Yes", 2: "No"} [If No, go to Section S (page 48)]
311. Q_R17.1: What was the cost of the package trips taken by your household in 2000? - Dollar amount ($)

### Section S - Recreation, Reading Materials and Education - 29 questions

**Sports, Athletic, Camping and Picnic Equipment**

312. Q_S1: Sports and athletic equipment? Include equipment for golf, racquet sports, ice skating, skiing, fishing, home exercise and other sporting and athletic equipment and accessories. Exclude athletic/running shoes (see Section O). Exclude rentals (see Q.14). - Dollar amount ($)
313. Q_S2: Camping and picnic equipment and accessories, e.g., tents, backpacks, sleeping bags, camp stoves, lanterns, coolers, mattresses and utensils? Include attachments and parts. - Dollar amount ($)

**Photographic Goods and Services**

314. Q_S3: Cameras, camera parts, attachments, accessories and other photographic goods, e.g., lenses, tripods, projectors, albums and darkroom supplies? - Dollar amount ($)
315. Q_S4: Photographic film, processing, extra prints and enlargements? - Dollar amount ($)
316. Q_S5: Photographers' services and other photographic services, e.g., passport photos and school pictures? - Dollar amount ($)

**Musical Instruments and Accessories**

317. Q_S6: Musical instruments, parts and accessories, e.g., pianos and guitars? - Dollar amount ($)

**Other Recreation Equipment**

318. Q_S7: Artists' materials and handicraft or hobbycraft kits and materials? Exclude school supplies (see Q.26 and Q.27, page 50). - Dollar amount ($)
319. Q_S8: Electronic games and parts, e.g., video game machines, plug-in cartridges and games on tape or disk? - Dollar amount ($)
320. Q_S9: Toys and other games? Include children's vehicles and bicycles with wheels under 14 inches. - Dollar amount ($)
321. Q_S9_specify: Specify toys - Open text
322. Q_S10: Playground equipment, above-ground swimming pools and accessories for swimming pools, e.g., swings, slides, pool covers, vacuum heads and wading pools? Exclude pool chemicals (see Q.12). - Dollar amount ($)
323. Q_S11: Collectors' items, e.g., stamps and coins? Exclude works of art and antiques (see Section L, Q.6 and Q.7, page 26). - Dollar amount ($)
324. Q_S12: Parts and supplies for recreation equipment, e.g., camp fuels, ski wax, pool chemicals, ammunition and bait? - Dollar amount ($)
325. Q_S13: Rental of video games, e.g., plug-in cartridges and games on disk? - Dollar amount ($)
326. Q_S14: Rental, maintenance and repair of recreation, sports and health equipment? - Dollar amount ($)

**Recreation Services**

327. Q_S15.1: In 2000, how much did your household spend on admissions to: Movie theatres? - Dollar amount ($)
328. Q_S15.2: Live performing arts, e.g., plays, concerts, festivals and dance performances? - Dollar amount ($)
329. Q_S15.3: Heritage facilities and other activities and venues, e.g., museums, zoos, ice shows, craft shows, fairs and historic sites? - Dollar amount ($)
330. Q_S15.4: Live sports events? - Dollar amount ($)
331. Q_S16: Fees for coin-operated and carnival games, e.g., pinball and video games? Exclude gambling machines (see Section T, Q.4.4, page 51). - Dollar amount ($)
332. Q_S17: Membership fees and dues for sports activities, sports and recreation facilities, and health clubs? - Dollar amount ($)
333. Q_S18: Single usage fees for sports activities, sports and recreation facilities, and health clubs? - Dollar amount ($)
334. Q_S19: Children's camps, e.g., day camps and summer camps? - Dollar amount ($)
335. Q_S20: Other cultural and recreational services, e.g., fishing and hunting licenses and guide service, party planning and other rental of sports facilities? - Dollar amount ($)

**Reading Materials and Other Printed Matter**

336. Q_S21: Newspapers? - Dollar amount ($)
337. Q_S22: Magazines and periodicals? - Dollar amount ($)
338. Q_S23: Books and pamphlets? Exclude school books (see Q.26 and Q.27). - Dollar amount ($)
339. Q_S24: Maps, sheet music and other printed matter, e.g., posters, globes and charts? - Dollar amount ($)
340. Q_S25: Services, e.g., duplicating services, library charges, book rentals, bookbinding, advertisements and announcements? - Dollar amount ($)

**Education**

341. Q_S26: Kindergarten, nursery school, and elementary and secondary education? (Tuition Fees / Books / Supplies) - Dollar amount ($) [3 columns]
342. Q_S27: Post-secondary education, e.g., university, trade and professional courses? (Tuition Fees / Books / Supplies) - Dollar amount ($) [3 columns]
343. Q_S28: Other courses and lessons, e.g., music, dancing, sports and crafts? Exclude driving lessons (see Section Q, Q.22, page 44). - Dollar amount ($)
344. Q_S29: Other educational services, e.g., rental of school books and equipment? - Dollar amount ($)
345. Q_S29_specify: Specify other educational services - Open text

### Section T - Tobacco and Miscellaneous - 20 questions

**Tobacco and Smokers' Supplies**

346. Q_T1: Cigarettes, tobacco, cigars and similar products? - Dollar amount ($)
347. Q_T2: Smokers' supplies, e.g., matches, pipes, lighters, ashtrays, cigarette papers and tubes? - Dollar amount ($)

**Miscellaneous Expenses**

348. Q_T3.1: In 2000, how much did your household spend on the following financial services: Service charges for banks and other financial institutions? - Dollar amount ($)
349. Q_T3.2: Stock and bond commissions? - Dollar amount ($)
350. Q_T3.3: Administration fees for brokers and others? - Dollar amount ($)
351. Q_T3.4: Other financial services, e.g., financial planning, tax preparation and advice, accounting services and safety deposit box charges? - Dollar amount ($)
352. Q_T4.1: In 2000, how much were your household's expenses and winnings from the following: Government-run lotteries? - Dollar amount ($) [Expenses] + Dollar amount ($) [Winnings]
353. Q_T4.2: Bingos? - Dollar amount ($) [Expenses] + Dollar amount ($) [Winnings]
354. Q_T4.3: Non-government lotteries, raffle tickets and other games of chance? - Dollar amount ($) [Expenses] + Dollar amount ($) [Winnings]
355. Q_T4.4: Casinos, slot machines and video lottery terminals? - Dollar amount ($) [Expenses] + Dollar amount ($) [Winnings]
356. Q_T5: Loss of deposits, fines, and money lost or stolen? - Dollar amount ($)
357. Q_T6: Contributions and dues for social clubs, co-operatives, political and fraternal organizations and alumni associations? Exclude charitable organizations (see Section V, Q.13, page 56). - Dollar amount ($)
358. Q_T7: Tools and equipment purchased for work (by wage or salaried workers)? Exclude items reported previously. - Dollar amount ($)
359. Q_T8: Legal services not related to dwellings? Exclude legal services related to house purchase, sale, etc. (see Section F, Q.3, page 15). - Dollar amount ($)
360. Q_T9: What other expenses did you have for goods? - Dollar amount ($)
361. Q_T9_specify: Specify other goods - Open text
362. Q_T10: What other expenses did you have for services, e.g., passports, funeral services and rental of halls? - Dollar amount ($)
363. Q_T10_specify: Specify other services - Open text

**Purchases Through Direct Sales**

364. Q_T11: In 2000, did your household purchase any goods through direct sales, e.g., door-to-door sales people, factory outlets, mail order companies, catalogue sales, book clubs and the Internet? - Radio: {01: "Yes", 02: "No"} [If No, go to Q.12]
365. Q_T11.1.1: Did your household purchase the following goods through direct sales: Food and beverages? - Radio: {03: "Yes", 04: "No"}
366. Q_T11.1.2: Books, newspapers and magazines? - Radio: {05: "Yes", 06: "No"}
367. Q_T11.1.3: Clothing, cosmetics and jewellery? - Radio: {07: "Yes", 08: "No"}
368. Q_T11.1.4: Home entertainment products, e.g., CD's, audio equipment and computers? - Radio: {09: "Yes", 10: "No"}
369. Q_T11.1.5: Other products used inside the home, e.g., appliances, cleaners, toys and crafts? - Radio: {11: "Yes", 12: "No"}
370. Q_T11.1.6: Other products used outside the home, e.g., greenhouse and nursery products? - Radio: {13: "Yes", 14: "No"}
371. Q_T11.2: In 2000, how much did your household spend on goods purchased through direct sales? - Dollar amount ($)

**Purchases Outside Canada**

372. Q_T12: In 2000, how much did your household spend on goods and services purchased outside Canada? - Dollar amount ($)

### Section U - Personal Income - 16 questions (per-person, up to 5)

373. Q_U1.1: For how many weeks in 2000 did this member work: full-time, including holidays with pay? - Numeric: [weeks, per person]
374. Q_U1.2: part-time, including holidays with pay? - Numeric: [weeks, per person]
375. Q_U2: Wages and Salaries before deductions, including bonuses, tips, commissions, and military pay and allowances? - Dollar amount ($) [per person]
376. Q_U3: NET Income from Farm and Non-farm Self-employment? - Dollar amount ($) [per person]
377. Q_U4.1: GROSS Income from Roomers and Boarders who were: household members (non-relatives)? - Dollar amount ($) [per person]
378. Q_U4.2: not members of your household? - Dollar amount ($) [per person]
379. Q_U5: Dividends; Interest on bonds, accounts and GICs; and Other Investment Income, e.g., net rental income and interest received from loans or mortgages? - Dollar amount ($) [per person]
380. Q_U6: Child Tax Benefit (including Quebec Family Allowance)? - Dollar amount ($) [per person]
381. Q_U7: Old Age Security Pension, Guaranteed Income Supplement, Spouse's Allowance from federal government only? Exclude provincial supplements (see Q.12). - Dollar amount ($) [per person]
382. Q_U8: Canada or Quebec Pension Plan Benefits? - Dollar amount ($) [per person]
383. Q_U9: Employment Insurance Benefits (before deductions)? - Dollar amount ($) [per person]
384. Q_U10: Goods and Services Tax Credit (received in 2000)? - Dollar amount ($) [per person]
385. Q_U11: Provincial Tax Credits, including Quebec Real Estate Tax Refund (claimed on 1999 income tax returns)? - Dollar amount ($) [per person]
386. Q_U12: Social Assistance, Provincial Income Supplements, Workers' Compensation Benefits, Veterans' Pensions, Civilian War Pensions and Allowances, and Other Income from Government Sources? - Dollar amount ($) [per person]
387. Q_U12_specify: Specify government sources - Open text
388. Q_U13: Retirement Pensions, Superannuation, Annuities and RRIF Withdrawals? Exclude RRSP withdrawals (see Section W, Q.2, page 57). - Dollar amount ($) [per person]
389. Q_U14: Personal Income Tax Refunds? - Dollar amount ($) [per person]
390. Q_U15: Other Money Income, e.g., alimony, separation allowance, child support, retirement allowances, severance pay, income maintenance plan payments, scholarships, bursaries and income from outside Canada? - Dollar amount ($) [per person]
391. Q_U15_specify: Specify other money income - Open text
392. Q_U16: Other Money Receipts, e.g., money gifts received from persons outside your household, cash inheritances and life insurance settlements? - Dollar amount ($) [per person]
393. Q_U16_specify: Specify other money receipts - Open text

### Section V - Personal Taxes, Security and Money Gifts - 13 questions (per-person, up to 5)

**Personal Taxes**

394. Q_V1: Income tax on 2000 income? Exclude taxes paid in 2001 on 2000 income. - Dollar amount ($) [per person]
395. Q_V2: Income tax on income for years prior to 2000? Include taxes paid in 2000 on income earned in 1999 or earlier. - Dollar amount ($) [per person]
396. Q_V3: Other personal taxes, e.g., gift tax? - Dollar amount ($) [per person]
397. Q_V3_specify: Specify other personal taxes - Open text

**Security and Employment-related Payments**

398. Q_V4: Premiums on life, term and endowment insurance? Include loan and group insurance. Report premiums for persons 14 years or under by the household member paying the premiums. - Dollar amount ($) [per person]
399. Q_V5: Annuity contracts and transfers to RRIFs? - Dollar amount ($) [per person]
400. Q_V6: Employment insurance (deductions from pay)? - Dollar amount ($) [per person]
401. Q_V7: Government retirement or pension fund, including federal, provincial and municipal government funds? - Dollar amount ($) [per person]
402. Q_V8: Canada/Quebec pension plan? - Dollar amount ($) [per person]
403. Q_V9: Other retirement or pension funds? - Dollar amount ($) [per person]
404. Q_V10: Dues to unions and professional associations? - Dollar amount ($) [per person]

**Money Gifts, Contributions and Support Payments**

405. Q_V11: In 2000, how much did each member pay for support payments to a former spouse or partner? Include alimony, separation allowance or child support. - Dollar amount ($) [per person]
406. Q_V12.1: In 2000, how much did each member spend on money gifts, contribution and other support payments to persons who were not household members: Money given to persons living in Canada? - Dollar amount ($) [per person]
407. Q_V12.2: Money given to persons living outside Canada? - Dollar amount ($) [per person]
408. Q_V13.1: In 2000, how much did each member spend on charitable contributions to: Religious organizations? - Dollar amount ($) [per person]
409. Q_V13.2: Other charitable organizations, e.g., the United Way, heart fund? - Dollar amount ($) [per person]

### Section W - Change in Assets - 8 questions

410. Q_W1.1: In 2000, what was the NET CHANGE (increase or decrease) in the following household assets: Cash held in accounts in banks and trust and loan companies, and cash on hand? Include guaranteed investment certificates (GICs). Exclude RRSPs (see Q.2). - Dollar amount ($) [net increase or net decrease]
411. Q_W1.2: Money owed to your household by persons outside your household? Report principal amounts or change in principal amounts. Exclude interest received (see Section U, Q.5, page 53). - Dollar amount ($) [net increase or net decrease]
412. Q_W1.3: Money deposited as a pledge against future purchases of goods and services? - Dollar amount ($) [net increase or net decrease]
413. Q_W2: In 2000, how much did your household contribute to and withdraw from RRSPs? - Dollar amount ($) [Contributions] + Dollar amount ($) [Withdrawals]
414. Q_W3.1: In 2000, what was the value of your household's purchases and sales of the following: Savings bonds, and treasury bills? - Dollar amount ($) [Purchase] + Dollar amount ($) [Sale]
415. Q_W3.2: Publicly traded stocks, mutual funds and shares in investment clubs? - Dollar amount ($) [Purchase] + Dollar amount ($) [Sale]
416. Q_W3.3: Sales of personal property not traded in on new items in 2000? Exclude sales of appliances and vehicles (see Sections L, Q and R). - Dollar amount ($) [Sale only]

### Section X - Unincorporated Business - 9 questions

417. Q_X1: In 2000, did any members of your household have investments in unincorporated businesses, professional practices, farms or rental property? - Radio: {1: "Yes", 2: "No"} [If No, go to Section Y]
418. Q_X1.1: In 2000, how much did your household: Repay on the principal of your mortgage(s) or loan(s)? Include all lump sum payments. - Dollar amount ($)
419. Q_X1.2: Pay to purchase assets? Include machinery, trucks, cars, buildings and other income-earning properties. - Dollar amount ($)
420. Q_X1.3: Borrow for the business or farm? Include mortgages and loans. - Dollar amount ($)
421. Q_X1.4: Receive (after commissions) from the sale of assets? Include machinery, trucks, cars, buildings and other income-earning properties. - Dollar amount ($)
422. Q_X1.5: Estimate for capital cost allowance (depreciation) in the determination of net income from self-employment? - Dollar amount ($)
423. Q_X2.1: In 2000, what was the NET CHANGE (increase or decrease) in the following: Accounts receivable? - Dollar amount ($) [net increase or net decrease]
424. Q_X2.2: Accounts payable? - Dollar amount ($) [net increase (D) or net decrease (C)] [NOTE: C and D are deliberately reversed for Q.2.2]

### Section Y - Loans and Other Debts - 9 questions

**Loans with Regular Payments (per loan, up to 5)**

425. Q_Y1: In 2000, did your household have any loans with regular payments? Include installment payment plans and student loans if repayment has begun. Exclude lines of credit, credit cards and accounts, and any outstanding bills (see Q.6 to Q.9). - Radio: {1: "Yes", 2: "No"} [If No, go to Q.6 (page 60)]
426. Q_Y2: Description, e.g., car, boat. - Open text [per loan]
427. Q_Y3: Was this loan taken out in 2000? - Radio: {1: "Yes", 2: "No"} [If No, go to Q.4] [per loan]
428. Q_Y3.1: What was the amount of the loan? - Dollar amount ($) [per loan]
429. Q_Y4: How much were the total payments made on this loan in 2000? Include lump sum payments. - Dollar amount ($) [per loan]
430. Q_Y5: Was there any additional amount borrowed in 2000 on this loan? - Radio: {1: "Yes", 2: "No"} [If No, go to Q.6] [per loan]
431. Q_Y5.1: What was the additional amount? - Dollar amount ($) [per loan]

**Other Money Owed by Your Household**

432. Q_Y6: Loans from financial institutions? Include lines of credit and student loans that are not yet being repaid. (Amount Owed Jan 1, 2000 / Amount Owed Dec 31, 2000 / Difference if Jan 1 larger / Difference if Dec 31 larger / Amount of Interest Charges in 2000) - Dollar amount ($) [5 columns]
433. Q_Y7: Credit cards from financial institutions? (Amount Owed Jan 1, 2000 / Amount Owed Dec 31, 2000 / Difference if Jan 1 larger / Difference if Dec 31 larger / Amount of Interest Charges in 2000) - Dollar amount ($) [5 columns]
434. Q_Y8: Credit cards and other debts with stores, service stations and other retail establishments? Include all revolving budget accounts. (Amount Owed Jan 1, 2000 / Amount Owed Dec 31, 2000 / Difference if Jan 1 larger / Difference if Dec 31 larger / Amount of Interest Charges in 2000) - Dollar amount ($) [5 columns]
435. Q_Y9: Rents, taxes and other bills, e.g., hospital? (Amount Owed Jan 1, 2000 / Amount Owed Dec 31, 2000 / Difference if Jan 1 larger / Difference if Dec 31 larger / Amount of Interest Charges in 2000) - Dollar amount ($) [5 columns]

## TOTAL UNIQUE QUESTION NODES: ~435
