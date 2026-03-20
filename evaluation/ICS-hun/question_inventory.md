# ICS Kérdezési Protokoll v2.0 - Question Inventory

## Document Overview
- **Title**: ICS Kérdezési Protokoll v2.0 (Emergency Medical Dispatch Triage Protocol)
- **Organization**: Hungarian Ambulance Service (Mentőszolgálat)
- **Date**: 2023.12.19
- **Pages**: 66
- **Language**: Hungarian
- **Type**: Flowchart-based dispatcher triage decision trees

## Structure
The protocol has 3 parallel assessment tracks by age group:
- **Adult (Felnőtt)**: Pages 2-23, shared pages
- **Child (Gyerek, 1-18)**: Pages 44-51, shared pages
- **Infant (Csecsemő, <1 year)**: Pages 52-59, shared pages

Pages shared across all age groups: 1, 7-8, 11, 13-43, 60-66

## Age-Specific Parallel Sections (Structurally Identical)
| Section | Adult Pages | Child Pages | Infant Pages |
|---------|------------|-------------|--------------|
| ABCDE Assessment | 2 | 44 | 52 |
| T-CPR I | 3-4 | 45-46 | 53-54 |
| T-CPR II (COVID) | 5-6 | 47-48 | 55-56 |
| Breathing Difficulty I | 9 | 49 | 57 |
| Breathing Difficulty II | 10 | 50 | 58 |
| Nervous System | 12 | 51 | 59 |

## Procedural Pages (Justified Omissions - Not Questions)
- **T-CPR I/II (p3-6, 45-48, 53-56)**: Step-by-step CPR instructions with real-time feedback loops
- **Recovery Position (p7)**: Physical positioning instructions with illustrations
- **AED (p8)**: Defibrillator operation instructions
- **Newborn CPR (p39)**: Neonatal resuscitation procedure
- **Seizure Management (p40)**: Patient protection instructions (1 question: "seized stopped?")
- **EpiPen/Anapen Use (p64-66)**: Auto-injector administration instructions

## Question Inventory by Page

### P1 - Hívásfogadás (Call Reception) - 5 questions
1. Q_P1_01: Riasztó tünet/esemény? (Alarming symptom/event?) - Y/N
2. Q_P1_02: Lát-e nyilvánvaló veszélyt? (Visible danger?) - Y/N
3. Q_P1_03: Megszűnt a veszély? (Danger resolved?) - Y/N [if danger=Y]
4. Q_P1_04: Esemény típusa (Event type) - Radio: Baleset/Akasztás/Áramütés/Vízbefulladás/Egyik sem
5. Q_P1_05: Beteg kora (Patient age) - Radio: Felnőtt/Gyerek/Csecsemő

### P2/44/52 - ABCDE Assessment (unified) - 14 questions
6. Q_ABCDE_01: Tud beszélni/sír/gügyög? (Can speak/cry?) - Radio: Speaks/Responds/No response
7. Q_ABCDE_02: Furcsa hang? (Strange voice?) - Y/N
8. Q_ABCDE_03: Hang típusa (Voice type) - Radio: Hoarse/Noisy/Wheeze/Gurgle/Other
9. Q_ABCDE_04: Fulladás/nehézlégzés? (Breathing difficulty?) - Y/N
10. Q_ABCDE_05: Szokatlan bőr? (Unusual skin?) - Y/N
11. Q_ABCDE_06: Bőr típusa (Skin type) - Radio: Pale/Purple/Cold/Flushed
12. Q_ABCDE_07: Verejtékezik? (Sweating?) - Y/N
13. Q_ABCDE_08: Viselkedésváltozás? (Behavior changed?) - Y/N
14. Q_ABCDE_09: Görcsöl? (Seizures?) - Y/N
15. Q_ABCDE_10: Kar gyengeség? (Arm weakness - FAST) - Y/N
16. Q_ABCDE_11: Arc aszimmetria? (Facial asymmetry - FAST) - Y/N
17. Q_ABCDE_12: Beszéd változás? (Speech changed - FAST) - Y/N
18. Q_ABCDE_13: Fájdalom? (Pain?) - Y/N
19. Q_ABCDE_14: Sérülés? (Injury?) - Y/N

### P9/49/57 - Nehézlégzés I (Breathing Difficulty I) - 9 questions
20. Q_BD1_01: Fulladás? (Choking/breathing difficulty?) - Y/N
21. Q_BD1_02: Félrenyelhetett? (Choking on food/object?) - Y/N
22. Q_BD1_03: Dagad a torka? (Swollen throat?) - Y/N
23. Q_BD1_04: Tud folyamatosan beszélni? (Can speak continuously?) - Radio: Words only/Short phrases/Full sentences/Cannot speak
24. Q_BD1_05: Légzési munka? (Breathing effort) - Radio: Exhausted-severe/Moderate/Mild
25. Q_BD1_06: SpO2 mérhető? (SpO2 available?) - Y/N
26. Q_BD1_07: SpO2 szint (SpO2 level) - Radio: <90%/90-92%/92-94%
27. Q_BD1_08: Szokatlan bőr? (Unusual skin?) - Y/N [ANAFILAXIA check]
28. Q_BD1_09: Verejtékezik? (Sweating?) - Y/N

### P10/50/58 - Nehézlégzés II (Breathing Difficulty II) - 8 questions
29. Q_BD2_01: Vérnyomás mérhető? (BP available?) - Y/N
30. Q_BD2_02: Vérnyomás szint (BP level) - Radio: SBP≥220/200-220/<200
31. Q_BD2_03: Viselkedésváltozás? (Behavior changed?) - Y/N
32. Q_BD2_04: Görcsöl? (Seizures?) - Y/N
33. Q_BD2_05: Kar gyengeség? (Arm weakness?) - Y/N
34. Q_BD2_06: Arc aszimmetria? (Facial asymmetry?) - Y/N
35. Q_BD2_07: Beszéd változás? (Speech changed?) - Y/N
36. Q_BD2_08: Fájdalom? (Pain?) - Y/N
37. Q_BD2_09: Sérülés? (Injury?) - Y/N

### P11 - Légúti idegentest (Foreign Body Airway) - 3 questions
38. Q_AIR_01: Képes beszélni/köhögni? (Can speak/cough?) - Y/N
39. Q_AIR_02: Eszméleténél van? (Conscious?) - Y/N
40. Q_AIR_03: Kor (Age) - Radio: Adult-child(>1yr)/Infant(<1yr)

### P12/51/59 - Idegrendszer (Nervous System) - 14 questions
41. Q_NEURO_01: Görcsöl? (Seizures?) - Y/N
42. Q_NEURO_02: Mikor kezdődtek panaszok? (Symptom onset) - Radio: <24h/within 1 week/>1 week
43. Q_NEURO_03: GCS szint (if <24h) - Radio: 3-9(P1)/10-13 aggresszív(P2)/14-15 moderate(P3)/14-15 mild(P4)
44. Q_NEURO_04: Kar gyengeség? (Arm weakness - FAST) - Y/N
45. Q_NEURO_05: Arc aszimmetria? (Facial asymmetry - FAST) - Y/N
46. Q_NEURO_06: Beszéd változás? (Speech changed?) - Y/N
47. Q_NEURO_07: Látászavar? (Vision disturbance?) - Y/N
48. Q_NEURO_08: Fejfájás? / Fájdalom skála (Headache? / Pain scale 1-10) - mixed
49. Q_NEURO_09: Szédülés? (Dizziness?) - Y/N
50. Q_NEURO_10: Ájulás? (Syncope?) - Y/N
51. Q_NEURO_11: Lázas? (Fever?) - Y/N → route to fever
52. Q_NEURO_12: Fejsérülés? (Head injury?) - Y/N → route to head injury
53. Q_NEURO_13: Máshol fájdalom? (Other pain?) - Y/N → route to pain
54. Q_NEURO_14: Pszichiátriai betegség? (Psychiatric illness?) - Y/N
55. Q_NEURO_15: TIA lehetséges? (TIA possible?) - Y/N [adult only, p13]

### P13 - Stroke - 13 questions (overlaps with neuro, adds onset-specific routing)
[Stroke-specific items are integrated into neuro block with onset-based preconditions]

### P14 - Fájdalom routing (Pain Routing) - 1 question
56. Q_PAIN_01: Fájdalom helye (Pain location) - Radio: Head/Chest/Abdomen/Spine/Limb/Other/Pregnancy

### P15 - Fejfájás (Headache) - 10 questions
57. Q_HEAD_01: Fejsérülés? (Head injury?) - Y/N → route to head injury p27
58. Q_HEAD_02: Mikor kezdődtek? (Onset) - Radio: <24h/<1week/>1week
59. Q_HEAD_03: Fájdalom erőssége 1-10 (Pain intensity) - Radio: Severe(8-10)/Moderate(4-7)/Mild(1-3)
60. Q_HEAD_04: Látászavar? (Vision disturbance?) - Y/N
61. Q_HEAD_05: Szédülés? (Dizziness?) - Y/N
62. Q_HEAD_06: Ájulás? (Syncope?) - Y/N
63. Q_HEAD_07: Hányinger? (Nausea?) - Y/N
64. Q_HEAD_08: Vérnyomás mérhető? (BP available?) - Y/N + levels
65. Q_HEAD_09: Lázas? (Fever?) - Y/N → route to fever
66. Q_HEAD_10: Máshol fájdalom? (Other pain?) - Y/N

### P16 - Mellkasi fájdalom (Chest Pain) - 12 questions
67. Q_CHEST_01: Mellkas sérülés? (Chest injury?) - Y/N → p28
68. Q_CHEST_02: Mikor kezdődtek? (Onset) - Radio: <24h/<1week/>1week
69. Q_CHEST_03: Fájdalom erőssége (Pain intensity) - Radio: Severe/Moderate/Mild
70. Q_CHEST_04: Hirtelen lépett fel? (Sudden onset?) - Y/N
71. Q_CHEST_05: Fájdalom típusa (Pain type) - Radio: Retrosternal-angina/Atypical
72. Q_CHEST_06: Vérnyomás mérhető? (BP available?) - Y/N + levels
73. Q_CHEST_07: MVT/PE kockázat? (DVT/PE risk factors?) - Y/N
74. Q_CHEST_08: Ájulás? (Syncope?) - Y/N
75. Q_CHEST_09: Hányinger? (Nausea?) - Y/N
76. Q_CHEST_10: Lázas? (Fever?) - Y/N
77. Q_CHEST_11: Máshol fájdalom? (Other pain?) - Y/N

### P17-18 - Hasi fájdalom I-II (Abdominal Pain) - 12 questions
78. Q_ABDO_01: Hasi sérülés? (Abdominal injury?) - Y/N → p29
79. Q_ABDO_02: Terhesség? (Pregnancy?) - Y/N → p37
80. Q_ABDO_03: Mikor kezdődtek? (Onset) - Radio
81. Q_ABDO_04: Fájdalom erőssége (Pain intensity) - Radio
82. Q_ABDO_05: Ájulás? (Syncope?) - Y/N
83. Q_ABDO_06: Hányinger típusa (Nausea type) - Radio: Bloody-coffee/Small-coffee/Food-water-unstoppable/Food-water-small/None
84. Q_ABDO_07: Vizelet elakadás? (Urinary retention?) - Y/N + duration
85. Q_ABDO_08: Utolsó székelés? (Last stool?) - Radio: >3 days/1-3 days
86. Q_ABDO_09: Széklet típusa (Stool type) - Radio: Bloody-black-large/Black-small/Bloody-small/Diarrhea-unstoppable/Diarrhea-mild/Normal
87. Q_ABDO_10: Hüvelyi vérzés? (Vaginal bleeding?) - Radio: Heavy/Ectopic/Moderate/Mild/None
88. Q_ABDO_11: Lázas? (Fever?) - Y/N
89. Q_ABDO_12: Máshol fájdalom? (Other pain?) - Y/N

### P19 - Gerincfájdalom (Back Pain) - 11 questions
90. Q_BACK_01: Gerinc sérülés? (Spine injury?) - Y/N → p30
91. Q_BACK_02: Mikor kezdődtek? (Onset) - Radio
92. Q_BACK_03: Fájdalom erőssége (Pain intensity) - Radio
93. Q_BACK_04: Ájulás? (Syncope?) - Y/N
94. Q_BACK_05: Végtagzsibbadás? (Numbness/paralysis?) - Y/N
95. Q_BACK_06: Tartja székletét/vizeletét? (Continence?) - Y/N
96. Q_BACK_07: Vérhígító? (Blood thinners?) - Y/N
97. Q_BACK_08: Vérzékenység? (Bleeding disorder?) - Y/N
98. Q_BACK_09: Lázas? (Fever?) - Y/N
99. Q_BACK_10: Kockázati tényezők? (Risk factors? - tumors, infection, immunosuppression, etc.) - Y/N
100. Q_BACK_11: Máshol fájdalom? (Other pain?) - Y/N

### P20 - Végtagfájdalom (Limb Pain) - 10 questions
101. Q_LIMB_P_01: Végtag sérülés? (Limb injury?) - Y/N → p31
102. Q_LIMB_P_02: Mikor/Erősség (Onset/Intensity) - Radio combo
103. Q_LIMB_P_03: Ájulás? (Syncope?) - Y/N
104. Q_LIMB_P_04: Mozgatni tudja? (Can move?) - Y/N
105. Q_LIMB_P_05: Duzzadt? (Swollen?) - Y/N
106. Q_LIMB_P_06: Szín változás (Color change) - Radio: Purple/Pale/Red/None
107. Q_LIMB_P_07: Hőmérséklet változás (Temp change) - Radio: Cold/Hot/None
108. Q_LIMB_P_08: Lázas? (Fever?) - Y/N
109. Q_LIMB_P_09: Máshol fájdalom? (Other pain?) - Y/N

### P21 - Egyéb fájdalom (Other Pain) - 6 questions
110. Q_OTHER_P_01: Megsérülhetett? (Injury?) - Y/N → p26
111. Q_OTHER_P_02: Mikor kezdődtek? (Onset) - Radio
112. Q_OTHER_P_03: Fájdalom erőssége (Intensity) - Radio
113. Q_OTHER_P_04: Ájulás? (Syncope?) - Y/N
114. Q_OTHER_P_05: Lázas? (Fever?) - Y/N
115. Q_OTHER_P_06: Máshol fájdalom? (Other pain?) - Y/N

### P22-23 - Láz I-II (Fever) - 12 questions
116. Q_FEVER_01: Hány éves a lázas beteg? (Age of febrile patient) - Radio: 0-3mo/3mo-3yr/3-18yr/18+
117. Q_FEVER_02: Betegnek tűnik? (Looks sick?) - Y/N [for 3mo-18yr]
118. Q_FEVER_03: 39°C feletti láz? (Fever >39°C?) - Y/N
119. Q_FEVER_04: Mióta lázas? (Fever duration) - Radio: >5days/3-5days/<3days
120. Q_FEVER_05: Lázcsillapító csökkenti? (Antipyretics effective?) - Y/N
121. Q_FEVER_06: Antibiotikum 24h belül? (Antibiotics in 24h?) - Y/N
122. Q_FEVER_07: Utolsó vizelet? (Last urination) - Radio: >24h/6-12h/<6h
123. Q_FEVER_08: Vérképzőszervi betegség? (Blood disease?) - Y/N
124. Q_FEVER_09: Kemoterápia? (Chemotherapy?) - Y/N
125. Q_FEVER_10: Szteroid? (Steroids?) - Y/N
126. Q_FEVER_11: Műtét 1 hónapon belül? (Surgery in past month?) - Y/N
127. Q_FEVER_12: Műbillentyű? (Artificial valve?) - Y/N
128. Q_FEVER_13: Bőrkiütés/bevérzés? (Skin rash/petechiae?) - Y/N
129. Q_FEVER_14: Nyakmerevség? (Neck stiffness?) - Y/N

### P24 - Baleset (Accident) - 3 questions
130. Q_ACC_01: Súlyos baleset? (Severe accident?) - Y/N
131. Q_ACC_02: Hány sérült? (How many injured?) - Radio: 1/2-3/4+
132. Q_ACC_03: Vérzés? (Bleeding?) - Radio: None-mild/Moderate/Severe

### P25 - Több sérültes (Mass Casualty) - 5 questions
133. Q_MASS_01: Meg tudja számolni? (Can count?) - Radio: 4+/2-3
134. Q_MASS_02: Gyermek sérült? (Child injured?) - Y/N
135. Q_MASS_03: Mozdulatlan sérült? (Immobile injured?) - Y/N
136. Q_MASS_04: Beszorult sérült? (Trapped?) - Y/N
137. Q_MASS_05: Vérzés? (Bleeding?) - Radio

### P26 - Sérülés routing (Injury Routing) - 2 questions
138. Q_INJ_01: Vérzés? (Bleeding?) - Radio: None-mild/Moderate/Severe
139. Q_INJ_02: Sérülés helye (Injury location) - Radio: Head/Spine/Chest/Abdomen/Limb/Burn

### P27 - Fejsérülés (Head Injury) - 10 questions
140. Q_HINJ_01: Mikor/Erősség (Onset/Pain intensity) - combo
141. Q_HINJ_02: Látászavar? (Vision disturbance?) - Y/N
142. Q_HINJ_03: Szédülés? (Dizziness?) - Y/N
143. Q_HINJ_04: Ájulás? (Syncope?) - Y/N
144. Q_HINJ_05: Hányinger? (Nausea?) - Y/N
145. Q_HINJ_06: Vérhígító? (Blood thinners?) - Y/N
146. Q_HINJ_07: Vérzékenység? (Bleeding disorder?) - Y/N
147. Q_HINJ_08: Máshol sérült? (Injured elsewhere?) - Y/N

### P28 - Mellkassérülés (Chest Injury) - 8 questions
148. Q_CINJ_01: Mikor/Fájdalom (Onset/Pain) - combo
149. Q_CINJ_02: Ájulás? (Syncope?) - Y/N
150. Q_CINJ_03: Vérhígító? (Blood thinners?) - Y/N
151. Q_CINJ_04: Vérzékenység? (Bleeding disorder?) - Y/N
152. Q_CINJ_05: Máshol sérült? (Injured elsewhere?) - Y/N

### P29 - Hasi sérülés (Abdominal Injury) - 8 questions
153. Q_AINJ_01: Mikor/Fájdalom (Onset/Pain) - combo
154. Q_AINJ_02: Ájulás? (Syncope?) - Y/N
155. Q_AINJ_03: Vérhígító? (Blood thinners?) - Y/N
156. Q_AINJ_04: Vérzékenység? (Bleeding disorder?) - Y/N
157. Q_AINJ_05: Máshol sérült? (Injured elsewhere?) - Y/N

### P30 - Gerincsérülés (Spine Injury) - 8 questions
158. Q_SINJ_01: Mikor/Fájdalom (Onset/Pain) - combo
159. Q_SINJ_02: Ájulás? (Syncope?) - Y/N
160. Q_SINJ_03: Végtagzsibbadás? (Numbness?) - Y/N
161. Q_SINJ_04: Vérhígító? (Blood thinners?) - Y/N
162. Q_SINJ_05: Vérzékenység? (Bleeding disorder?) - Y/N
163. Q_SINJ_06: Máshol sérült? (Injured elsewhere?) - Y/N

### P31 - Végtagsérülés (Limb Injury) - 11 questions
164. Q_LINJ_01: Amputáció? (Amputation?) - Y/N
165. Q_LINJ_02: Mikor/Fájdalom (Onset/Pain) - combo
166. Q_LINJ_03: Ájulás? (Syncope?) - Y/N
167. Q_LINJ_04: Vérhígító/vérzékenység? (Blood thinners/disorder?) - Y/N
168. Q_LINJ_05: Mozgatni tudja? (Can move?) - Y/N
169. Q_LINJ_06: Duzzadt/deformált? (Swollen/deformed?) - Y/N
170. Q_LINJ_07: Szín változás (Color change) - Radio: Purple/Pale/Red/None
171. Q_LINJ_08: Hőmérséklet változás (Temp change) - Radio: Cold/Hot/None
172. Q_LINJ_09: Máshol sérült? (Injured elsewhere?) - Y/N

### P32 - Égési sérülés (Burns) - 7 questions
173. Q_BURN_01: Mikor? (When?) - Radio: <24h/>24h
174. Q_BURN_02: Hogyan? (How?) - Radio: Fire-closed/Explosion/Electrical/Hot liquid/Chemical
175. Q_BURN_03: Hogyan néz ki? (Appearance?) - Radio: Grey-black/Blisters/Redness
176. Q_BURN_04: Hol sérült? (Location?) - Radio: Face-neck/Chest/Abdomen-genitals/Limbs
177. Q_BURN_05: Fájdalom erőssége (Pain intensity) - Radio: 4-10/0-3
178. Q_BURN_06: Ájulás? (Syncope?) - Y/N
179. Q_BURN_07: Máshol sérült? (Injured elsewhere?) - Y/N

### P33 - Pszichiátria (Psychiatry) - 6 questions
180. Q_PSYCH_01: Fenyegetőzik/agresszív? (Threatening/aggressive?) - Radio: Dangerous/Unknown/Thoughts only/No
181. Q_PSYCH_02: Öngyilkossággal fenyegetőzik? (Suicidal?) - Radio: Attempt/Active intent/Unknown/Thoughts/No
182. Q_PSYCH_03: Szorongás/hallucináció? (Anxiety/hallucination?) - Radio: Severe/Acute psychosis/Unknown/Moderate/Mild/Chronic/No
183. Q_PSYCH_04: Bántalmazás/álmatlanság? (Abuse/insomnia?) - Radio: Abuse/Acute insomnia/Chronic insomnia/No
184. Q_PSYCH_05: Tudatmódosító szer? (Substance use?) - Y/N
185. Q_PSYCH_06: Megsérülhetett? (Injury?) - Y/N

### P34-35 - Súlyos allergiás reakció I-II (Severe Allergic Reaction) - 10 questions
186. Q_ALRG_01: Allergiás reakció felmerül? (Allergic reaction suspected?) - Y/N
187. Q_ALRG_02: Tud beszélni? (Can speak?) - Radio: Words only/Short phrases/Full sentences
188. Q_ALRG_03: Légzési munka (Breathing effort) - Radio: Exhausted-severe/Moderate/Mild
189. Q_ALRG_04: Szokatlan bőr? (Unusual skin?) - Y/N
190. Q_ALRG_05: Verejtékezik? (Sweating?) - Y/N
191. Q_ALRG_06: Viselkedésváltozás? (Behavior changed?) - Y/N
192. Q_ALRG_07: Ájulás? (Syncope?) - Y/N
193. Q_ALRG_08: Hasi panasz? (Abdominal complaint?) - Y/N
194. Q_ALRG_09: Adrenalin elérhető? (Adrenaline available?) - Y/N
195. Q_ALRG_10: Képzett személy elérhető? (Trained person?) - Y/N
196. Q_ALRG_11: Ismert allergia? (Known allergy?) - Y/N [p35]

### P36 - Enyhe allergiás reakció (Mild Allergic Reaction) - 5 questions
197. Q_MALRG_01: Ismert allergia? (Known allergy?) - Y/N
198. Q_MALRG_02: Bőrpír/csalánkiütés? (Skin rash/hives?) - Y/N
199. Q_MALRG_03: Mikor kezdődtek? (Onset) - Radio: <24h/>24h
200. Q_MALRG_04: Ájulás? (Syncope?) - Y/N
201. Q_MALRG_05: Hasi panasz? (Abdominal?) - Y/N
202. Q_MALRG_06: Csak helyi reakció? (Local reaction only?) - Y/N

### P37 - Várandósság (Pregnancy) - 10 questions
203. Q_PREG_01: Magzati rész látható? (Visible fetal part?) - Y/N
204. Q_PREG_02: Mennyi idős a terhesség? (Gestational age) - Radio: <36 weeks/≥36 weeks
205. Q_PREG_03: Hányadik terhesség? (Which pregnancy?) - Radio: First/Subsequent
206. Q_PREG_04: Veszélyeztetett terhesség? (High-risk?) - Y/N
207. Q_PREG_05: Elfolyt a magzatvíz? (Water broken?) - Y/N
208. Q_PREG_06: Fájások gyakorisága (Contraction frequency) - Radio: <2min/>2min
209. Q_PREG_07: Székelési inger? (Urge to push?) - Y/N
210. Q_PREG_08: Vérzés? (Bleeding?) - Radio: Heavy/Mild-none
211. Q_PREG_09: Magzat fekvése (Fetal position) - open
212. Q_PREG_10: Preeclampsia tünetek? (Preeclampsia symptoms?) - Y/N

### P38 - Helyszíni szülés (On-Scene Birth) - 3 questions
213. Q_BIRTH_01: Lélegzik/sír a baba? (Baby breathing/crying?) - Y/N
214. Q_BIRTH_02: Időre született? (Full term?) - Y/N
215. Q_BIRTH_03: Baba tónusa? (Baby muscle tone?) - Radio: Good/Floppy

### P40 - Görcsroham (Seizure) - 1 question
216. Q_SEIZ_01: Megszűnt a görcsroham? (Seizure stopped?) - Y/N

### P41 - Akasztás (Hanging) - 1 question
217. Q_HANG_01: Levágták? (Cut down?) - Y/N

### P42 - Áramütés (Electrocution) - 2 questions
218. Q_ELEC_01: Ipari áram? (Industrial power?) - Radio: Industrial/Household/Unknown
219. Q_ELEC_02: Áramtalanítva? (Power off?) - Y/N

### P43 - Vízbefulladás (Drowning) - 1 question
220. Q_DROWN_01: Kihúzták? (Rescued?) - Y/N

### P60-63 - Kórállapot Áttekintő (Condition Overview) - routing questions
221. Q_COND_01: Állapot típusa (Condition type) - Radio: multiple options from overview tables

## TOTAL UNIQUE QUESTION NODES: ~221

## Priority/Resource Assignment
The protocol assigns:
- **Priority**: P1 (immediate) through P5 (non-urgent/advice)
- **Resource**: ALS (Advanced Life Support), BLS (Basic Life Support), Ügyelet (on-call/ER referral)
These are computed outputs based on question answers, modeled as codeBlock variables.
