# ESS Round 12 Source Questionnaire: Declarative Conversion Analysis

**Source:** European Social Survey ERIC, ESS Round 12 Source Questionnaire, 105 pages
**QML File:** `evaluation/reference-questionnaires/ESS12-source-questionnaire.qml`
**Date:** 2026-03-19 (updated with corrections)

## Objective

Transform the ESS Round 12 source questionnaire (105 pages, 7 sections, multi-mode with routing) into a declarative QML representation, then run the Z3-based formal validator to detect structural problems hidden in the imperative version.

## Methodology

1. Full reading of the 105-page PDF across all sections (A through J, plus screening S1-S6 and administrative H)
2. Declarative QML conversion covering sections A-G with GOTO-to-precondition translation
3. Formal validation using the Askalot Z3 QML validator at Level 2
4. Cross-referencing validator findings against PDF page numbers and routing instructions

## Survey Architecture Overview

The ESS12 is a cross-national, multi-mode survey (face-to-face, self-completion web, and paper) covering social attitudes, political engagement, well-being, immigration, human values, and demographics. It uses a multi-mode design where questions appear in all modes but some response categories (Refusal, Don't Know) are F2F-only, and some sections (F, H) are SC WEB and PAPER only.

| Section | Title | Questions | Routing Complexity | PDF Pages |
|---------|-------|-----------|-------------------|-----------|
| S (Screening) | Eligibility / Selection | S1-S6 | Age check, household selection | pp.5-7 |
| A | Media, Politics, Social Trust, Immigration, Religion, Identity | A1-A89 | A5->A6/A8, A9->A10/A11, A26->A27/A28, A36->A37/A39, A70->A71/A72, A72->A73/A74, A77->A78/A79, A80->A81/A83, A85->A86/A87, A87->A88/A89, D22->D23/D24 | pp.8-35 |
| B | Household, Demographics, Employment, Education, Parents | B1-B60 | B1->B5-B7/B9, B7->B8, B8->B9/B10, B16->B17/B18, B18->B19/B21, B19->B20/B37, B21->B22/B23, B25->B26/B27, B37->B38/B40, B45->B46/B47, B47->B48/B53, B54->B55/B56, B57->B58/B59 | pp.36-67 |
| C | Subjective Well-being, Personal Values | C1-C30 | None (ASK ALL) | pp.68-75 |
| D | Immigration, International Attitudes | D1-D30 | D19 conditional on A80=1, D22->D23/D24, D30a-d random assignment | pp.76-86 |
| E | Human Values (Schwartz PVQ-RR) | E1-E20 | None (ASK ALL) | pp.87-93 |
| F | Survey Experience (SC WEB/Paper only) | F1-F6 | F3->F4/F6 | pp.94-95 |
| G | Re-contact Consent | G1-G5 | G1->G2/H1 | pp.96-99 |
| H | Incentive Collection (SC WEB/Paper only) | H1-H3 | Administrative | pp.100-101 |
| J | Interviewer Questionnaire (F2F only) | J1-J10 | J6->J7/J8 | pp.102-104 |

## Validator Results (After Corrections)

### Summary

| Metric | Value |
|--------|-------|
| Items | 247 |
| Blocks | 7 |
| Preconditions | 63 |
| Postconditions | 15 |
| Variables | 20 |
| Cycles | **0** |
| Global Status | **SAT** |
| Issues | **0** |

### Z3 Item Classifications

| Classification | Count |
|---------------|-------|
| Precondition ALWAYS | 184 |
| Precondition CONDITIONAL | 63 |
| Precondition NEVER | 0 |
| Postcondition NONE | 232 |
| Postcondition TAUTOLOGICAL | 14 |
| Postcondition CONSTRAINING | 1 |

**No items are unreachable.** All 247 items have at least one valid path. The 184 ALWAYS items are core questions asked of all respondents. The 63 CONDITIONAL items are gated by voting status, party affiliation, internet use frequency, religion, discrimination, country of birth, employment status, household composition, partner status, and other computed variables. The 14 TAUTOLOGICAL postconditions are range checks on Editbox controls where the control's own min/max already enforces the constraint. The single CONSTRAINING postcondition is the cross-check that household members aged 15+ (B2) must be less than or equal to total household members (B1).

## Problems Exposed by Declarative Conversion

### P1: Screening and Eligibility Layer Omitted -- 6 Questions Lost

**PDF evidence:** Screening questions S1-S6 (pp.5-7), including age check at S5 (age 18 or over) and parental consent at S6 (for under-18s)

**Problem:** The ESS12 has a screening sequence (S1-S6) that handles:
- Household selection via "next birthday" method (S1-S4)
- Age eligibility check: respondent must be aged 18 or over, or have parental consent (S5-S6)
- The S5 routing sends those aged under 18 to S6 for parental consent before proceeding to A1

The QML omits this entire screening layer because:
1. QML represents a survey for a **qualified respondent**, not the screening/selection process
2. The household selection algorithm (next birthday) is a procedural operation external to the survey itself
3. The under-18 consent gate is a binary decision that either grants access to the survey or terminates it entirely -- not a conditional routing within the survey

**Impact:** 6 screening questions and their routing logic are not represented. The survey begins directly at Section A, implicitly assuming a qualified respondent has been selected.

### P2: Household Grid (B5-B7) -- Partially Represented (CORRECTED)

**PDF evidence:** B5-B7 with HHintro instruction (pp.37-39): "Program SC WEB and F2F so that questions B5-B7, including the optional question for a household member's first name or initial, are repeated for each additional member of the household according to the answer at B1. The respondent should be asked about a maximum of 8 other people in the household."

**Problem:** Questions B5 (sex of household member), B6 (month/year of birth), and B7 (relationship to respondent) form a **roster loop** -- they are repeated for each additional household member (up to 8 people beyond the respondent). QML cannot express dynamic-length loops.

**Correction applied:** B5, B6 (month and year), and B7 are now represented for one representative household member (Person 1), gated on `q_b1.outcome >= 2`. The B7 relationship question captures the key routing variable (`has_partner_in_household` and `has_children_in_household`) needed for downstream preconditions on B8, B12, and B44-B52. The full roster loop for up to 8 members remains a QML limitation but the routing-critical relationship data is now captured.

**Remaining limitation:** Only one household member's details are collected. The PDF allows up to 8. This is an inherent QML constraint (no dynamic loops).

### P3: Partner's Employment Sub-Section (B44-B52) -- CORRECTED

**PDF evidence:** B44a/B44b (partner's education, p.57), B45 (partner's activity status, pp.57-58), B46 (partner's main activity, p.58), B47 (partner did paid work, p.59), B48-B50 (partner's job details, p.59), B51 (partner employee/self-employed, p.60), B52 (partner's working hours, p.60)

**Correction applied:** All 9 questions (B44a, B45, B46, B47, B48, B49, B50, B51, B52) have been added to the QML, placed after B43. They are gated on `has_partner_in_household == 1` (set by B7 when relationship = husband/wife/partner). B45 uses Checkbox for multi-select activity status. B46 is gated on `q_b45.outcome >= 3` (multiple selections). B47-B52 use partner-specific routing variables (`partner_in_paid_work`, `partner_had_paid_work`). B48-B50 use Textarea for open-ended job descriptions. B52 uses Editbox with 0-168 range.

### P4: B17 "Best Description" Follow-up -- CORRECTED

**PDF evidence:** B17 (p.44): "ASK IF MORE THAN ONE CODED AT B16. And which of these descriptions best describes your situation in the last 7 days? INSTRUCTIONS: Please select only one."

**Correction applied:** B17 has been added as a Dropdown question gated on `b16_multiple == 1`. The `b16_multiple` variable is set in B16's codeBlock when `q_b16.outcome >= 3` (indicating at least two checkbox bits are set, meaning multiple selections). B17 presents all 9 activity categories for single selection. The dynamic filtering of options to only show those selected at B16 is a UI behavior that cannot be expressed in declarative QML; B17 shows all options and the respondent selects the best description.

**Remaining limitation:** The PDF specifies that B17 should only display the options selected at B16. This dynamic filtering is not expressible in QML, so all 9 options are shown.

### P5: A89a/A89b EU Referendum Split -- Country-Dependent Branching Not Representable

**PDF evidence:** A89a/A89b (p.35): "PROGRAMMING NOTE: Countries ask A89a or A89b depending on EU membership. EU members ask A89a and non-EU countries ask A89b. On SC PAPER, display either question as A89."

**Problem:** The PDF contains two mutually exclusive versions of the EU referendum question:
- **A89a** (EU members): "Would you vote for [country] to remain a member of the European Union or to leave the European Union?" -- Response codes: 01 Remain, 02 Leave, 33 Blank ballot, 44 Spoil ballot, 55 Not vote, 65 Not eligible
- **A89b** (non-EU countries): "Would you vote for [country] to become a member of the European Union or to remain outside the European Union?" -- Response codes: 01 Become member, 02 Remain outside, 33 Blank ballot, 44 Spoil ballot, 55 Not vote, 65 Not eligible

The selection between A89a and A89b is a **country-level configuration**, not a respondent-level routing decision. This is analogous to the BRFSS state-level module selection problem.

**In the QML:** A single combined question (q_a89) merges both versions: "Remain a member / Become a member" and "Leave the European Union / Remain outside." The response codes are simplified to 1-6 sequential values, losing the PDF's distinctive coding (01, 02, 33, 44, 55, 65).

**Impact:** The country-configuration mechanism is lost, and the merged question conflates two semantically different scenarios (leaving an existing membership vs. declining to join). The original response coding (with gaps: 33, 44, 55, 65) is replaced with sequential 1-6 coding.

### P6: D30a-D30d Random Sample Assignment -- Experimental Design Not Representable

**PDF evidence:** D30a-D30d (pp.85-86): "PROGRAMMING NOTE: D30a, D30b, D30c, D30d are four separate question versions which are to be randomly allocated to 25% of the total sample each in advance of fieldwork. Each respondent will only be asked one question."

**Problem:** The PDF implements a **survey experiment** where four versions of a question about accepting migrants from European vs. Middle Eastern countries, fleeing war vs. unemployment, are randomly assigned:
- D30a: Christians from European country fleeing war
- D30b: Christians from European country fleeing unemployment
- D30c: Muslims from Middle Eastern country fleeing war
- D30d: Muslims from Middle Eastern country fleeing unemployment

This is a 2x2 factorial design (religion x reason) randomly assigned at the sample level. The allocation happens before fieldwork begins, not during the survey.

**In the QML:** A single combined question (q_d30) captures only one version: "people from a European country (who had to leave due to conflict or lack of work)." The experimental manipulation (religion, reason for migration) and the random assignment mechanism are entirely lost.

**Impact:** The 2x2 experimental design -- the core methodological innovation of this rotating module item -- cannot be expressed in declarative QML. The survey experiment requires a pre-fieldwork sample assignment mechanism that is external to the questionnaire flow.

### P7: Refusal and Don't Know Response Codes Systematically Omitted

**PDF evidence:** Nearly every question includes codes 7/77/777/7777 (Refusal) and 8/88/888/8888 (Don't Know) in the F2F column. Some questions also include "Prefer not to answer" as a substantive option (e.g., A85 code 7, A87 code 7, B53a code 7777, B54 code 7).

**Problem:** The ESS12 PDF systematically provides Refusal and Don't Know codes for F2F interviews. These are metadata responses that indicate non-substantive answers. The QML omits all of these codes from every question, meaning:

1. **F2F interviewers** cannot record a refusal or "don't know" response through the QML -- the respondent must choose a substantive answer
2. **"Prefer not to answer"** codes (distinct from Refusal in the PDF, appearing as substantive options at A85 code 7, A87 code 7, B53a, B54, B56a, B57) are also omitted, even though they are intended to appear in all modes
3. **Routing affected**: At A5 (p.9), "Don't Know" (code 88) routes to "Go to A6" (same as substantive answers 01-05, 77), while "I don't think climate change is happening" (code 55) routes to "Go to A8." The QML correctly implements the code-55 skip but cannot handle the DK routing because DK is omitted as a response option

**In the QML:** All questions use only the substantive response codes. This is a deliberate design choice (QML is for qualified, willing respondents) but it means the QML cannot fully replicate the F2F interview experience where interviewers may record refusals.

**Impact:** The QML enforces forced-choice responding. For SC WEB mode this is acceptable (the PDF notes respondents can skip by pressing "Next"), but for F2F mode the loss of Refusal/DK codes changes interviewer data entry capabilities.

### P8: B8 Relationship Question Precondition -- CORRECTED

**PDF evidence:** B8 (p.39): "ASK IF LIVING WITH HUSBAND/WIFE/PARTNER AT B7 (IF 01 AT B7)." B8 routing: codes 01-02 go to B9, codes 03-04 go to B10, codes 05-08 go to B9.

**Correction applied:** B8 now has precondition `has_partner_in_household == 1`, which is set by the B7 codeBlock when the respondent identifies a household member as "Husband, wife, or partner" (B7=1). This correctly gates B8 on the presence of a partner, matching the PDF's routing. B8's response options have been expanded to include country-specific options 7 and 8 per the PDF.

### P9: B11 Legal Marital Status Precondition -- CORRECTED

**PDF evidence:** B11 (p.40): "ASK IF NOT LIVING WITH HUSBAND/WIFE/PARTNER AT B7 OR ARE COHABITING AT B8 (IF NOT 01 AT B7, OR IF B8 = 03, 04)"

**Correction applied:** B11 now has precondition `has_partner_in_household == 0 or cohabiting == 1`. Since B8 is now correctly gated on `has_partner_in_household == 1` (P8 fix), and `cohabiting` is set by B8's codeBlock, the cascading error chain is resolved. B11 is correctly shown to respondents who either (a) do not have a partner in the household, or (b) are cohabiting but not legally married. B11's response options have been expanded to include country-specific options 7 and 8 per the PDF.

### P10: B12 Children Question Precondition -- CORRECTED

**PDF evidence:** B12 (p.41): "ASK IF NOT LIVING WITH CHILDREN AT HOME AT B7 (IF NOT 02 at B7)." B7 code 02 = "Son or daughter (including step, adopted, foster, or child of partner)."

**Correction applied:** B12 now has precondition `has_children_in_household == 0`. The `has_children_in_household` variable is set by B7's codeBlock when the respondent identifies a household member as a "Son or daughter" (B7=2). This correctly skips B12 for respondents already known to have children, matching the PDF's routing.

## Impact Assessment (After Corrections)

| Category | Imperative (PDF) | Declarative (QML) | Status |
|----------|------------------|-------------------|--------|
| **Screening logic** | 6 eligibility questions with household selection and age check | Omitted -- not representable as survey flow | Justified omission |
| **Household grid** | Roster loop B5-B7 for up to 8 household members | B5-B7 represented for one member; key routing variable captured | CORRECTED (partial) |
| **Partner employment** | 9+ questions on partner's work, education, occupation | B44a-B52 all added, gated on partner in household | CORRECTED |
| **Multi-select follow-up** | B17 filters to only show selected options from B16 | B17 added with all 9 options (dynamic filtering not expressible) | CORRECTED (partial) |
| **Country configuration** | A89a/A89b selected by EU membership, D30a-d randomly assigned | Merged into single questions -- loses experimental design | Accepted limitation |
| **Refusal/DK codes** | Systematic F2F metadata codes on every question | Omitted -- QML enforces forced-choice responding | By design |
| **Cascading filter errors** | B7 filters B8, B8 filters B9/B11, B7 filters B12 | All preconditions corrected using B7-derived variables | CORRECTED |

## Corrections Applied (2026-03-19)

The following corrections were made to address the identified problems:

1. **B5-B7 household roster added** (P2): Questions B5 (sex), B6 (month/year of birth), and B7 (relationship) added for one representative household member, gated on `q_b1.outcome >= 2`. B7 sets `has_partner_in_household` and `has_children_in_household` variables for downstream routing.

2. **B44a-B52 partner employment added** (P3): All 9 partner questions added -- B44a (partner education, Dropdown), B45 (partner activity, Checkbox), B46 (partner main activity, Dropdown), B47 (partner paid work check, Switch), B48-B50 (partner job details, Textarea), B51 (partner employment type, Radio), B52 (partner hours, Editbox). All gated on `has_partner_in_household == 1`.

3. **B17 multi-select disambiguation added** (P4): B17 added as a Dropdown with all 9 activity categories, gated on `b16_multiple == 1` (set when B16 outcome >= 3).

4. **B8 precondition corrected** (P8): Changed from `q_b1.outcome >= 1` (always true) to `has_partner_in_household == 1`. Added country-specific options 7 and 8.

5. **B9 precondition corrected** (P8/P9): Changed from `living_with_partner == 0 and cohabiting == 0` to `has_partner_in_household == 0 or (has_partner_in_household == 1 and q_b8.outcome in [1, 2, 5, 6, 7, 8])`, matching the PDF routing.

6. **B11 precondition corrected** (P9): Changed from `living_with_partner == 0 or cohabiting == 1` to `has_partner_in_household == 0 or cohabiting == 1`. Added country-specific options 7 and 8.

7. **B12 precondition added** (P10): Added precondition `has_children_in_household == 0` so B12 is skipped for respondents already known to have children.

8. **B8-B12 reordered**: Moved from after B43 to their correct position after B7 (before B13), matching PDF order.

9. **New variables added**: `has_partner_in_household`, `has_children_in_household`, `b16_multiple`, `partner_in_paid_work`, `partner_had_paid_work` (5 new variables).

**Net result**: 14 new items (B5, B6_month, B6_year, B7, B17, B44a, B45, B46, B47, B48, B49, B50, B51, B52), bringing total from 233 to 247. All pass Z3 validation at Level 2.

## Conclusion

The Z3 QML validator found **no structural defects** (no cycles, no unreachable items, no infeasible postconditions) in the corrected ESS12 conversion. All 247 items are reachable, and the single CONSTRAINING postcondition (B2 <= B1 cross-check) is non-trivial but satisfiable. The 14 TAUTOLOGICAL postconditions are redundant range checks that duplicate Editbox min/max constraints.

The following design observations remain after corrections:

1. **Screening layer omission** (P1) -- 6 eligibility and household selection questions cannot be represented in declarative QML. Justified: QML represents qualified respondents.
2. **Household grid partial** (P2) -- Only one household member's details captured (QML cannot express dynamic loops). Key routing variable captured.
3. **B17 dynamic filtering** (P4) -- All 9 options shown instead of only those selected at B16. QML cannot express dynamic option filtering.
4. **Country-dependent branching** (P5) -- A89a/A89b EU referendum merged into single question. Country-level configuration is external to QML.
5. **Experimental design loss** (P6) -- D30a-d 2x2 factorial with random sample assignment cannot be expressed as survey flow.
6. **Systematic Refusal/DK omission** (P7) -- F2F metadata codes removed by design. QML enforces forced-choice responding.

The ESS12's architecture is fundamentally different from CATI-based questionnaires like the LFS or BRFSS. It is a **multi-mode instrument** designed for self-completion (web and paper) as well as face-to-face interviews. Its primary structural complexity lies not in within-survey routing (which is relatively simple: most questions are ASK ALL) but in three areas that resist declarative expression: (1) the household roster loop, (2) country-level configuration (EU membership, education coding, religion categories), and (3) the embedded survey experiment (D30a-d random assignment). The core attitudinal content (Sections A, C, D, E) converts cleanly because it consists almost entirely of unconditional questions with no routing dependencies.
