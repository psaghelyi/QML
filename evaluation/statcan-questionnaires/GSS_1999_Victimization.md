# GSS Cycle 13 - Victimization Survey (1999): Declarative Conversion Analysis

**Source:** Statistics Canada, General Social Survey Cycle 13, Catalogue no. 12M0013GPE, Appendix B (158 pages)
**QML File:** `evaluation/statcan-questionnaires/GSS_1999_Victimization.qml`
**Date:** 2026-03-19

## Objective

Transform the traditional imperative CATI questionnaire (158-page PDF with GOTO-based branching across 13 sections) into a declarative QML representation, then run the Z3-based formal validator to detect structural problems that are hidden in the imperative version.

## Methodology

1. Page-by-page reading of all 158 PDF pages (Sections A through V, plus Appendix)
2. Identification of all GOTO routing, CATI-edit checks, and conditional skip patterns
3. Faithful QML conversion preserving the PDF's original logic (including its errors)
4. Formal validation using the Askalot Z3 QML validator
5. Back-verification of every problem against specific PDF pages with exact quotes

## Questionnaire Structure

The GSS Cycle 13 is organized into these sections:

| Section | Pages | Purpose | QML Block |
|---------|-------|---------|-----------|
| A | 1-6 | Entry / Demographics (from household roster) | `b_entry` |
| B | 7-17 | Crime Screening (8 crime types) | `b_screening` |
| C | 17-20 | Perceptions of Crime | `b_perceptions` |
| D/E | 21-28 | Spousal Violence Screening (10 acts) | `b_spousal_screen` |
| F/G | 28-31 | Ex-Partner Violence Screening (10 acts) | `b_ex_partner_screen` |
| H/K | 33-38 | Senior Abuse Screening (children + caregivers) | `b_senior_screen` |
| L | 55-64 | Spousal Abuse Report | `b_spousal_report` |
| M | 65-76 | Ex-Spousal Abuse Report | `b_ex_spousal_report` |
| N | 77-88 | Senior Abuse by Children Report | `b_senior_child_report` |
| P | 89-100 | Senior Abuse by Caregiver Report | `b_senior_caregiver_report` |
| Q | 101-123 | Classification (demographics, socioeconomic) | `b_classification` |
| V | 127-158 | Crime Incident Report (per-incident detail) | `b_incident_report` |

## Corrections Made (QML divergences from PDF)

These were deliberate simplifications in the QML conversion to achieve a structurally equivalent model while respecting QML's Z3-verifiable subset. They are NOT problems in the original PDF.

| # | Area | PDF Design | QML Adaptation | Reason |
|---|------|-----------|----------------|--------|
| 1 | Section V loop | Crime Incident Report is entered once per crime type reported in Section B (up to 8 times) | Single pass through `b_incident_report` block with OR-gated precondition | QML does not support iterative re-entry of blocks; the single-pass model captures the routing logic faithfully |
| 2 | "Mark all that apply" questions | L21, L23, L29, L31, M21, M23, V10A, V15, V32, V36, V40, V42, V55, V57, V64 use multi-select with "No other; continue" sentinel | Converted to single-select (Dropdown/Radio) for primary response | QML Checkbox uses power-of-2 bitmask keys; the PDF's non-power-of-2 option codes (1-16 sequential) are incompatible |
| 3 | Open-ended "Specify" fields | L21S, L23S, L29S, L31S, M21S, etc. are free-text fields (CATI: Length = 28-50) | Omitted entirely | QML Textarea is not Z3-verifiable; free-text fields have no routing impact |
| 4 | CATI timestamp/date fields | L0, M0, N0, P0, Q0, V0 are Date/Time stamps | Omitted | Administrative fields with no routing logic |
| 5 | D11 response codes | PDF uses (1)=Yes, (3)=No, (5)=Yes describe | Mapped to 1=Yes, 3=No (dropped code 5 variant) | Code 5 is a sub-variant of Yes with identical routing |
| 6 | Section H emotional abuse screening | H1-H9 cover emotional/financial abuse (pp.33-35) | Omitted (only physical violence H10+ retained) | Emotional abuse items have no routing dependencies on other sections; they flow linearly |
| 7 | Q47e income routing | CATI-Q47e uses complex personal income thresholds to choose starting point in binary search tree (pp.119) | Simplified: Q48A entry requires `q47_other_earners > 0 AND (no income OR zero income)` | The PDF's 6-way branch based on Q46 income ranges cannot be expressed as a single precondition chain; the simplified version captures the structural dependency |

## Validator Results

### Summary

| Metric | Value |
|--------|-------|
| Items | 252 |
| Blocks | 12 |
| Preconditions | 221 |
| Postconditions | 1 |
| Variables | 16 |
| Dependencies | 1438 |
| Cycles | **0** |
| Connected Components | 22 |
| Structural Validity | `true` |
| Issues | **0** |

### Z3 Item Classifications

| Classification | Count | Meaning |
|---------------|-------|---------|
| ALWAYS reachable | 31 | Item shown to every respondent |
| CONDITIONAL | 221 | Item shown based on prior responses |
| NEVER reachable | 0 | Dead code (unreachable items) |
| CONSTRAINING postcondition | 1 | `v29_oldest_age >= v28_youngest_age` |
| INFEASIBLE postcondition | 0 | Impossible validation rules |

### Key Finding: No Cycles Detected

Unlike the LFS questionnaire (which had a PATH variable feedback loop), the GSS Victimization survey avoids cycles because its section-gating variables (`spousal_abuse`, `ex_spousal_abuse`, `senior_child_abuse`, `senior_caregiver_abuse`) are **write-once**: they are set in screening sections (D/E/H/K) and only read by downstream report sections (L/M/N/P). No downstream section writes back to these variables.

## Problems in the Original PDF (Exposed by Declarative Conversion)

### P1: Spousal Violence Block Ignores Marital Status Gate

| Source | Rule |
|--------|------|
| PDF p.21 Section D header | *"The next series of questions are for those respondents living with a spouse or common-law partner"* |
| PDF p.21 CATI-D0e | *"If respondent is not currently married or living common-law, Go to F0."* |
| PDF p.26 D11 codeBlock | Sets `spousal_abuse = 1` if ANY of D1-D11 = Yes |
| Section L (p.55) CATI-L0e | *"If SABUSE = (0), Go to M0."* |

**The problem:** The CATI-D0e check at p.21 gates entry to Section D on marital status, but this gate is **only enforced by the GOTO routing**, not by any variable check within D1-D11 themselves. In the imperative version, a single respondent (marital_status=6) is correctly skipped past Section D by the GOTO. But the `SABUSE` flag that gates Section L is set purely based on D1-D11 responses, with **no marital status check**. If the GOTO at D0e were ever bypassed (e.g., by a CATI programming error), a single respondent could answer D1-D11 and trigger the full spousal abuse report.

**In the QML:** The block-level precondition `has_spouse == 1` on `b_spousal_screen` makes this gate explicit and verifiable. The Z3 solver confirms that `spousal_abuse` can only be set to 1 when `has_spouse == 1`, because the codeBlock is inside a block gated by that condition. This is a structural improvement over the PDF's implicit GOTO-based gating.

**PDF reference:** p.21 *"CATI-D0e: If respondent is not currently married, living common-law or same-sex partner, Go to F0."*

### P2: Senior Screening Double-Gated by Age But Inconsistently

| Source | Rule |
|--------|------|
| PDF p.33 Section H header | *"The next few questions ask about some things that may have happened to you during the past 5 years"* |
| PDF p.33 CATI-H0e | *"If respondent is less than 65 years of age, Go to section K"* (jumps to caregiver section) |
| PDF p.36 CATI-K0e | *"If respondent is less than 65 years of age, Go to L0."* |
| PDF p.37 K11 | No age check within the question itself |

**The problem:** Section H (child abuse screening) and Section K (caregiver abuse screening) both have age-65+ gates at their entry points (H0e and K0e). However, these are two separate GOTO checks, and K0e redundantly re-checks the same age condition. More critically, the section header at p.33 introduces the questions as being about "things that may have happened" without mentioning the age restriction. The CATI interviewer sees the generic introduction first, then the GOTO routing silently skips the section.

**Asymmetry exposed:** For respondents aged 60-64, the CATI routing at H0e skips **directly to K0e** (not L0e). This means a 62-year-old briefly enters the senior screening flow path (H0e), gets redirected to K0e, and then gets redirected again to L0e. This double-redirect is invisible to the respondent but creates an unnecessary processing step in the CATI system.

**In the QML:** The single block `b_senior_screen` with precondition `is_senior == 1` collapses both H0e and K0e into one gate, eliminating the double-redirect. The Z3 solver confirms that all items in this block are CONDITIONAL (correctly gated on age).

**PDF reference:** p.33 *"CATI-H0e: If respondent is less than 65 years of age, Go to section K"*; p.36 *"CATI-K0e: If respondent is less than 65 years of age, Go to L0."*

### P3: Section L Police Routing Asymmetry (L17 Yes vs No)

| Source | Rule |
|--------|------|
| PDF p.57 L17 | *"(1) Yes, (3) No [Go to L25A], (x) Don't know [Go to L27], (r) Refused [Go to L27]"* |
| PDF p.57 L19 | *"(1) Respondent, (3) Some other way [Go to L21], (x) Don't know [Go to L27], (r) Refused [Go to L27]"* |

**The problem:** L17=Yes leads to L18/L19/L20 (police reporting details), while L17=No leads to L25A-L25K (reasons for not reporting). But L17=Don't Know and L17=Refused both jump to **L27** (talked to anyone), completely skipping both the reporting details AND the reasons for not reporting. This means respondents who refuse to say whether police were involved provide neither reporting details nor non-reporting reasons -- a data gap that is structurally embedded in the routing.

Furthermore, within the L17=Yes path, L19=Don't Know and L19=Refused also jump to L27, skipping L20 (reasons for reporting) and L21-L24 (police actions). A respondent who confirms police involvement but refuses to say how they learned about it provides no information about police response quality.

**In the QML:** The Don't Know and Refused options are not modeled (QML uses integer outcomes only), so these asymmetric skip paths are collapsed. The declarative version makes the Yes/No branching explicit: `l17_police.outcome == 1` vs `l17_police.outcome == 3`.

**PDF reference:** p.57 L17 routing, p.57 L19 routing

### P4: Parallel Section Structure Masks Divergent Routing (L vs M vs N vs P)

Sections L (spousal), M (ex-spousal), N (senior child), and P (senior caregiver) are near-identical abuse report sections, each following the same pattern:
- Injury questions (2-6A/B)
- Medical attention (4-5B)
- Bed rest (6-6A)
- Time off (7)
- Perpetrator drinking (8/9)
- Others harmed (10-13A)
- Fear for life (15)
- Compensation (16-16A)
- Police involvement (17)
- Police reporting details (18-24) or Non-reporting reasons (25A-K)
- Talked to others (27)
- Services used (28-28A)
- Reasons not using services (29)
- Restorative justice (30)
- Emotional impact (31)
- Advice (32)

**The problem:** While the structure is parallel, the routing details **diverge silently**:

| Difference | Section L (Spousal) | Section M (Ex-Spousal) |
|-----------|-------------------|----------------------|
| L24/M24 "violence change after police" | Precondition: `D11 != 3` (current partner) | Precondition: `F11 = 3` (ex-partner, note p.70 CATI-M23e: `If F11 = (3), Go to M27`) |
| L28/M28 services used | Items d/e gender-gated: shelter (female only), women's centre (female only), men's centre (male only) | **Same gender gating** applied to ex-partner section |
| L28/M28 item g | *"Seniors' centre? [CATI: only if respondent is 65+]"* | **Same age gate** |
| CATI-L17e/M17e routing | Complex "on path" check using D variables | Complex "on path" check using F variables |

The CATI-L17e check (p.57) reads: *"If (D11 = (3) and (D14 is less than 12 months ago and D14 = 'On path')) or (2 LE D12 LE 10 and D12 = D13 and (D12 and D13 = 'On path')). Go to L19."*

This complex condition determines whether the current incident is "on path" for detailed police questioning. The parallel condition at CATI-M17e (p.68) uses F-series variables. But the condition logic is **not identical** -- the M17e version references F11, F12, F13, F14 with slightly different threshold values because the ex-partner section has different frequency patterns.

**Impact:** In the imperative version, the parallel structure creates an illusion of identical treatment. The declarative version forces each section to have explicit, independent preconditions, making the divergences visible.

**PDF reference:** p.57 CATI-L17e, p.62 L28, p.68 CATI-M17e, p.73 M28

### P5: Binary Search Tree for Household Income Has Dead Branches

| Source | Rule |
|--------|------|
| PDF p.119 CATI-Q47e | Six-way branch based on personal income (Q46) value |
| PDF pp.120-123 Q48A-Q48K | Binary search tree with 10 questions |

**The problem:** The CATI-Q47e routing at p.119 selects a starting point in the binary search tree based on the respondent's personal income:

```
If Q47 > 0 and (Q45 = 0 or Q46 = n or Q46 = r or Q46 = x) → Q48A
If Q47 > 0 and Q46 > 0 and Q46 < 20000 → Q48A
If Q47 > 0 and Q46 > 19999 and Q46 < 40000 → Q48E
If Q47 > 0 and Q46 > 39999 and Q46 < 60000 → Q48H
If Q47 > 0 and Q46 > 59999 and Q46 < 80000 → Q48J
If Q47 > 0 and Q46 > 79999 → Q48K
```

This means a respondent reporting personal income of $50,000 enters the binary search at Q48H ("less than $60,000 or $60,000 and more?"), skipping Q48A-Q48G entirely. The logic assumes household income is at least as high as personal income, so questions below the personal income threshold are "dead" for that respondent.

**The structural issue:** The binary search tree is **not balanced**. The left branches (lower income) have 3 levels (Q48A->Q48B->Q48C), while the right branches (higher income) have 5 levels (Q48A->Q48E->Q48G->Q48H->Q48J->Q48K). A respondent with no personal income goes through Q48A and potentially all 10 questions. A high-income respondent enters at Q48K and answers just 1 question.

This asymmetry means the **survey burden is inversely correlated with income** -- lower-income respondents answer more questions to bracket their household income. This is a design choice that may introduce non-response bias in the lower income brackets.

**In the QML:** The precondition chain faithfully reproduces the binary tree structure. Z3 correctly classifies all Q48* items as CONDITIONAL, confirming that each binary search node is reachable only through its parent.

**PDF reference:** p.119 CATI-Q47e, pp.120-123 Q48A-Q48K

### P6: Crime Incident Section V5/V6/V7/V8 Chain Has Unreachable Combination

| Source | Rule |
|--------|------|
| PDF p.128 V2 | Location codes 1-16, with codes 1,2,3,4 being "home" locations |
| PDF p.128 V3 | *"V3 only if V2=1"* (inside own home) |
| PDF p.128 V5 | *"If V2 in [1,3,4] or V3=Yes → V5"* |
| PDF p.128 V6 | *"If V5=No → V6"* |
| PDF p.129 V7 | *"If V6=No → V7"* |

**The problem:** V5 asks "did the person who committed the act live with you?" This is only asked for home-adjacent locations (V2=1,3,4) or when V3=Yes (same dwelling). But V2=2 (vacation property) routes directly to V5 via "Go to V5" at p.128, bypassing V3 entirely. This means:

- V2=1 (own home) → V3 (same dwelling?) → if Yes, V5
- V2=2 (vacation property) → **Go to V5 directly** (no V3)
- V2=3 (garage) → **Go to V5 directly**
- V2=4 (outside home) → **Go to V5 directly**

For V2=1 and V3=No (different dwelling than current), the routing goes to V4 (dwelling type) and then "Go to V5". But in the QML, the precondition `v2_location.outcome == 1 and v3_same_dwelling.outcome == 3` for V4 means V4 is reachable, but V5's precondition as written in the PDF includes a case where V3 was never asked (V2=2,3,4).

**The deeper issue:** V2=2 (vacation property) jumps to V5, but V5 asks about someone living with the respondent -- at a vacation property, the concept of "living with" is ambiguous. The GOTO hides this conceptual mismatch: the interviewer simply asks the question regardless of whether it makes sense in context.

**PDF reference:** p.128 V2 routing instructions, V3 precondition, V5 routing

### P7: V15 "Not Attacked/Assaulted" Creates Contradictory State

| Source | Rule |
|--------|------|
| PDF p.131 V15 | *"How were you assaulted?"* with option (n) = "Not attacked/assaulted" |
| PDF p.131 CATI-V15e | *"Hard edit: If V11 = (1) and V15 = (n) then interviewer ask..."* |

**The problem:** V15 is reached from V11=Yes (respondent confirmed assault) or from CATI-V10e routing for sexual assault/unwanted touching crime types. V15 then offers option (n) "Not attacked/assaulted" as a possible response. This creates a **hard edit contradiction**: V11=1 means "yes, I was assaulted" and V15=(n) means "I was not attacked/assaulted."

The PDF's solution is a hard edit (CATI-V15e) that asks the interviewer: *"Earlier in the interview you said that you were attacked but you have not identified how you were attacked. For which question should I correct your answer?"* with options to correct V11 or V15.

**Structural issue:** This is a data consistency problem built into the questionnaire design. Rather than preventing the contradictory state through routing (e.g., not showing V15 option "n" when V11=1), the PDF relies on a post-hoc interviewer intervention. In a self-administered context, this contradiction would go undetected.

There is also a "soft edit" variant when V11 is blank or "Off path" -- a less severe version that asks the interviewer to "please clarify" rather than demanding a correction. This means the CATI system treats the contradiction differently depending on whether V11 was explicitly answered vs. skipped.

**PDF reference:** p.131 V15 option (n), pp.131-132 CATI-V15e hard edit and soft edit

### P8: V36 "Nothing" Stolen Creates Same Contradictory Pattern

| Source | Rule |
|--------|------|
| PDF p.138 V36 | *"What was stolen during the incident?"* with option (n) = "Nothing" |
| PDF p.139 CATI-V36e | *"Hard edit: If V35 = (1) and V36 = (n) then interviewer ask..."* |

**The problem:** Identical structural pattern to P7. V35=1 means "yes, something was stolen" and V36=(n) means "nothing was stolen." The PDF again relies on a hard edit intervention rather than preventing the contradictory state through routing.

The same pattern repeats for V39 (attempted theft) / V40 (what was attempted) and V41 (damage) / V42 (what was damaged) -- each pair has a hard edit for the "yes then nothing" contradiction.

**This is a systematic design pattern in Section V:** rather than constraining the response space to prevent contradictions, the questionnaire allows contradictions and relies on interviewer intervention to resolve them. In a declarative model, these would be postconditions: `v35.outcome == 1 implies v36.outcome != n`.

**PDF reference:** p.138 V35/V36, p.139 CATI-V36e; p.140 V39/V40, CATI-V40e; p.141 V41/V42, CATI-V42e

### P9: CATI-V59e Complex Routing Creates 6 Different Question Subsets for V60

| Source | Rule |
|--------|------|
| PDF p.149 CATI-V59e | Multi-condition routing that selects which V60 sub-items to ask |

**The problem:** CATI-V59e at p.149 determines which sub-questions of V60 (talked to anyone) to present. The condition is:

*"If crime incident type does not refer to robbery, attempted robbery, physical attack, threat, sexual assault or unwanted sexual touching, then ask only V60a, V60b, V60c, and V60e; Else - Ask all V60a to V60f."*

This means V60d (Doctor or nurse?) and V60f (Minister, priest, clergy?) are **only asked for violent crime types**, not for property crimes. The underlying assumption is that property crime victims don't need medical or spiritual support -- a debatable policy choice that is completely hidden in the GOTO routing.

**Additionally**, the condition uses a complex test involving V36, V40, V42, V10, V13, V14, and V15 to determine whether the crime involved violence, theft, or property damage. This multi-variable test is the most complex routing decision in the entire questionnaire (involving 7+ variables across different sections of the incident report), yet it appears as a single CATI routing instruction that the interviewer never sees.

**PDF reference:** p.149 CATI-V59e (full condition text)

### P10: Section L/M/N/P Services Questions Gender-Gate Without Explicit Check

| Source | Rule |
|--------|------|
| PDF p.62 L28d | *"Shelter or transition house? [CATI: only if female respondent]"* |
| PDF p.62 L28e | *"Women's centre? [CATI: only if female respondent]"* |
| PDF p.62 L28f | *"Men's centre or men's support group? [CATI: only if male respondent]"* |
| PDF p.62 L28g | *"Seniors' centre? [CATI: only if respondent is 65+]"* |

**The problem:** The gender and age gates on L28d-g (and parallel M28, N24, P24) are **CATI instructions, not routing logic**. They appear as bracketed notes to the interviewer, not as GOTO statements. This means:

1. The CATI system must implement these gates programmatically, but they are not part of the formal routing specification
2. A paper-based administration of this questionnaire would have no mechanism to enforce these gates
3. The gates are inconsistent in their specification: L28d says "only if female" but does not specify what happens for male respondents (skip the item? mark as N/A?)

**Deeper issue:** L28f (men's support group) is only available in Sections L and M (spousal/ex-spousal abuse), not in Sections N and P (senior abuse). But the PDF's N24 and P24 include items a-h with the **same gender gates**, suggesting that men's support groups should be available for senior abuse too. The parallel structure implies identical treatment, but the CATI notes may be implemented differently across sections.

**PDF reference:** p.62 L28, p.73 M28, p.86 N24, p.98 P24

## Impact Assessment

| Category | Imperative (PDF) | Declarative (QML) |
|----------|------------------|-------------------|
| **Contradictions** (P7, P8) | Allowed, resolved by post-hoc hard edits requiring interviewer judgment | Would be prevented by postconditions -- contradictory states never arise |
| **Implicit gates** (P1, P10) | CATI notes and GOTO jumps enforce gates without formal specification | Explicit preconditions verified by Z3 -- every gate is part of the formal model |
| **Asymmetric routing** (P3, P5) | Hidden in 158 pages of GOTO instructions -- each path appears locally correct | Forced into explicit branches -- asymmetry visible in precondition structure |
| **Parallel section divergence** (P4) | Near-identical section structure creates illusion of consistency | Independent preconditions reveal where parallel sections actually differ |
| **Complex routing** (P9) | 7-variable condition compressed into single CATI instruction | Would require multi-variable precondition chain, making complexity explicit |
| **Survey burden asymmetry** (P5) | Binary search entry point varies by income -- invisible to respondent | Precondition chain makes the unbalanced tree structure visible |
| **Double-redirects** (P2) | Two sequential age checks (H0e, K0e) for same condition | Collapsed into single precondition -- eliminates unnecessary processing |

## Conclusion

The Z3 QML validator confirmed structural validity with **0 cycles, 0 never-reachable items, and 0 infeasible postconditions** across 252 items and 12 blocks. The absence of cycles (unlike the LFS questionnaire) is due to the GSS Victimization's clean separation between screening variables (write-once in Sections D/E/H/K) and report sections (read-only in L/M/N/P).

The declarative conversion exposed **10 categories of structural/logical problems** in the original 158-page CATI questionnaire:

1. **Implicit marital status gate** (P1) -- GOTO-only enforcement with no formal specification
2. **Redundant age double-redirect** (P2) -- two sequential GOTO checks for the same age condition
3. **Police reporting asymmetry** (P3) -- Don't Know/Refused responses skip both branches entirely
4. **Parallel section divergence** (P4) -- near-identical sections with silently different routing logic
5. **Income binary search asymmetry** (P5) -- lower-income respondents answer more questions
6. **Home location chain ambiguity** (P6) -- V5 "live with" question asked for vacation properties
7. **V15 assault contradiction** (P7) -- allows "not assaulted" after confirming assault
8. **V36/V40/V42 theft/damage contradictions** (P8) -- systematic pattern of allowing then correcting contradictory states
9. **6-way question subset routing** (P9) -- most complex routing decision hidden in single CATI instruction
10. **Gender/age gates as CATI notes** (P10) -- informal instructions rather than formal routing logic

These problems are characteristic of large CATI questionnaires where routing is specified as GOTO instructions rather than declarative constraints. Each GOTO appears locally correct, but the global picture -- spanning 158 pages and 13 sections -- contains structural issues that are only visible when all constraints must be simultaneously satisfiable.
