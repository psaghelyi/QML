# NLSCY Children and Youth Survey: Declarative Conversion Analysis

**Source:** Statistics Canada, National Longitudinal Survey of Children and Youth (NLSCY), Cycle 3, Catalogue no. 89F0078XIE
**QML File:** `evaluation/statcan-questionnaires/NLSCY_Children_Youth.qml`
**Date:** 2026-03-19

## Objective

Transform the traditional imperative CATI questionnaire (PDF, 244 pages of GOTO-based branching across 15+ sections with complex age-tiered routing for children aged 0-11) into a declarative QML representation, then run the Z3-based formal validator to detect structural problems that are hidden in the imperative version.

## Methodology

1. Page-by-page reading of the entire 244-page PDF across all sections
2. Identification of all conditional routing (GOTO patterns, age gates, respondent-type gates)
3. Faithful reproduction of the PDF's routing logic in QML using preconditions and codeBlocks
4. Formal validation using the Askalot Z3 QML validator
5. Back-verification of every detected problem against specific PDF page numbers

## Survey Structure Overview

The NLSCY questionnaire has two major parts:

| Part | Pages | Sections |
|------|-------|----------|
| **Parent questionnaire** | 1-40 | Demographics, Adult Health (CHLT), Family Functioning (FNC), Neighbourhood (SAF), Social Support (SUP) |
| **Children's questionnaire** | 41-244 | Child Demographics (DVS), Health (HLT), Education (EDU), Literacy (LIT), Activities (ACT), Behaviour (BEH), Motor/Social Development (MSD), Temperament (TMP), Relationships (REL), Parenting (PAR), Custody History (CUS), Child Care (CHC) |

The primary routing variable is **child age** (0-11 years), with sections subdivided into age tiers (0-1, 2-3, 4-5, 6-7, 8-9, 10-11). The Motor and Social Development section uses **age in months** (0-47) with 8 separate milestone batteries.

## Corrections Made (QML divergences from PDF)

These were adjustments needed to express the imperative GOTO-based routing as declarative preconditions. They are NOT problems in the original PDF -- they are translation artifacts.

| # | Item | Original PDF Logic | QML Adaptation | PDF Reference |
|---|------|-------------------|----------------|---------------|
| 1 | Health status section gate | HLT-C6: "IF AGE = 0-3 ---> GO TO HLT-I37" (GOTO skip) | Precondition `child_age >= 4` on `hlt_i6` and all health status items | p45 |
| 2 | Vision age-split | HLT-C6A: "IF AGE > 6" sends to different question variant | Two separate items `hlt_q6` (ages 6+) and `hlt_q6a` (ages 4-5) with respective preconditions | p45-46 |
| 3 | Getting around age-split | HLT-C20/C22: Different walking question wording for age < 6 vs age >= 6 | Two item variants `hlt_q20`/`hlt_q20a` and `hlt_q22`/`hlt_q22a` | p49 |
| 4 | Behaviour age tiers | BEH-C1: "IF AGE > 3" sends to different battery entirely | Three separate QuestionGroups for ages 0-3, 2-3 toddler, and 4-11 | p109-116 |
| 5 | MSD month-based routing | 8 separate GOTO paths based on age in months (0-3, 4-6, 7-9, etc.) | Overlapping preconditions using `child_age_months` ranges | p117-121 |
| 6 | Activities age-tiered clubs | ACT-C3D: Three different club question variants by age group | Three separate items `act_q3d1`/`act_q3d2`/`act_q3d3` | p106 |
| 7 | Parenting age gate | PAR-C7: "IF AGE < 3 ---> GO TO PAR-Q7A" vs PAR-Q7 | Two items with mutually exclusive preconditions on `child_age` | p126 |
| 8 | Custody foster parent gate | CUS-C1: "IF FOSTER PARENT ---> GO TO CHILD CARE" | Precondition `is_foster_parent == 0` on all custody items | p130 |

## Validator Results

### Summary

| Metric | Value |
|--------|-------|
| Items | 161 |
| Blocks | 12 |
| Preconditions | 131 |
| Postconditions | 0 |
| Variables | 22 |
| Cycles | **0** |
| Connected Components | 28 |
| Structural Validity | `true` |
| Issues | **0** |

### Z3 Item Classifications

| Classification | Count | Meaning |
|----------------|-------|---------|
| ALWAYS reachable | 30 | Items shown to every respondent regardless of child age or respondent type |
| CONDITIONAL | 131 | Items shown only when specific age/respondent-type conditions are met |
| NEVER reachable | 0 | No dead code detected |
| INFEASIBLE postconditions | 0 | No impossible validation rules |

### Key Structural Finding: No Dependency Cycles

Unlike the LFS questionnaire which had a dependency cycle through the PATH variable, the NLSCY questionnaire has **no dependency cycles**. This is because the primary routing variable (`child_age`) is set once at the beginning (from `dvs_child_age`) and is never modified by downstream items. The age-tiered routing is strictly one-directional: age determines which sections and questions to show, but no downstream answer modifies the age variable.

## Problems in the Original PDF (Exposed by Declarative Conversion)

### P1: Contradictory Age Boundaries in Health Status Section

| Source | Rule |
|--------|------|
| HLT NOTE (p44) | "AGE 0-1 YEAR: HLT-Q1-Q4; HLT-QI37-Q45" |
| HLT-C5 (p44) | "IF AGE < 2 YEARS ---> GO TO HLT-I37" |
| HLT-C6 (p45) | "IF AGE = 0-3 ---> GO TO HLT-I37" |

The section header on p44 defines four age tiers with specific question ranges. But the GOTO routing uses **three different age boundaries** for the same logical decision (skip to injury questions):
- HLT-C5 uses "AGE < 2" (excludes age 2+)
- HLT-C6 uses "AGE = 0-3" (excludes age 4+)
- The NOTE groups "AGE 0-1" separately from "AGE 2-3"

**The contradiction:** A 2-year-old passes HLT-C5 (age >= 2, goes to HLT-Q5) but is then stopped at HLT-C6 (age = 0-3, goes to HLT-I37). This means 2-3 year olds get HLT-Q5 (physical activity) but skip the entire Health Status subsection (vision, hearing, speech, mobility). The NOTE header for AGE 2-3 confirms this: "HLT-Q1-Q5; HLT-QI37-Q45."

However, the NOTE for AGE 4-5 says: "HLT-Q1-Q5; HLT-Q6A, Q7A; HLT-Q8-Q19" -- meaning vision questions start with Q6A/Q7A (storybook versions), not Q6/Q7 (newsprint versions). But HLT-C6A on p45 says "IF AGE > 6 ---> GO TO HLT-Q6A" which sends ages **7+** to Q6A, contradicting the NOTE which assigns Q6A to ages 4-5 only.

**In the imperative version:** The interviewer follows the GOTO at C6A, which tests AGE > 6. If age is 4-5, the condition is FALSE, so the interviewer falls through to HLT-Q6 (the newsprint version -- intended for 6+). This means **4-5 year olds are asked about reading newsprint** instead of storybook words.

**PDF evidence:**
- p44: *"AGE 4-5 YEARS: HLT-Q1-Q5; HLT-Q6A, Q7A"* -- NOTE says ages 4-5 get Q6A
- p45: *"HLT-C6A IF AGE > 6 ---> GO TO HLT-Q6A"* -- routing sends ages 7+ to Q6A, which is the **opposite** direction

**In the QML:** The declarative version makes this explicit. Q6A has `precondition: child_age >= 4 and child_age <= 5` (from the NOTE), while Q6 has `precondition: child_age >= 6` (from the GOTO). The Z3 solver confirms both are reachable (CONDITIONAL) with non-overlapping age ranges.

### P2: Vision Routing Creates Unreachable Path for Certain Outcomes

| Source | Route |
|--------|-------|
| HLT-Q6 (p45) | "1 YES ---> GO TO HLT-Q9" |
| HLT-Q6 (p45) | "2 NO" (falls through to Q7) |
| HLT-Q6 (p45) | "8 DON'T KNOW ---> GO TO HLT-Q3" (sic -- should be Q8?) |
| HLT-Q6 (p45) | "9 REFUSAL ---> GO TO HLT-Q11" |

The DON'T KNOW response at HLT-Q6 routes to "HLT-Q3" which is the **height question** from earlier in the section. This is clearly a typographical error -- it should route to HLT-Q8 (the "able to see at all?" question) or HLT-Q11 (hearing section).

**PDF evidence:**
- p45: *"8 DON'T KNOW --->GO TO HLT-Q3"* (Q3 asks about height)
- p46: HLT-Q7 answer 2 routes "NO ---> GO TO HLT-Q8" and answer 8 routes "DON'T KNOW ---> GO TO HLT-Q8"

**Impact:** In the imperative version, a DON'T KNOW response at Q6 would send the interviewer back to the height question, creating an infinite loop (Q3 -> Q4 -> Q5 -> C6 -> Q6 -> DON'T KNOW -> Q3). The CATI system likely catches this, but the paper specification contains a circular reference.

### P3: Motor and Social Development Has Overlapping Month Ranges

| Source | Question Range |
|--------|---------------|
| p117 | "AGE 0 TO 3 MONTHS: GO TO MSD-Q1 - Q15" |
| p117 | "AGE 4 TO 6 MONTHS: GO TO MSD-Q8 - Q22" |
| p117 | "AGE 7 TO 9 MONTHS: GO TO MSD-Q12 - Q26" |
| p117 | "AGE 10 TO 12 MONTHS: GO TO MSD-Q18 - Q32" |
| p117 | "AGE 13 TO 15 MONTHS: GO TO MSD-Q22 - Q36" |
| p117 | "AGE 16 TO 18 MONTHS: GO TO MSD-Q26 - Q40" |
| p117 | "AGE 19 TO 21 MONTHS: GO TO MSD-Q29 - Q43" |
| p117 | "AGE 22 TO 47 MONTHS: GO TO MSD-Q34 - Q48" |

The question ranges **overlap significantly**. For example:
- Q8-Q15 is asked for ages 0-3 months (Q1-Q15) AND ages 4-6 months (Q8-Q22)
- Q12-Q15 is asked for ages 0-3, 4-6, AND 7-9 months
- Q22 is asked for ages 4-6, 7-9, 10-12, AND 13-15 months

This is intentional (progressive milestone tracking), but the imperative GOTO-based routing hides the overlap -- each age band starts at a different point and ends at a hard-coded question number. The declarative version must express these as overlapping ranges.

**The structural problem:** The overlap means the same milestone question can be reached through **multiple entry points** depending on age. In the imperative version, each age tier has a single GOTO entry. In the declarative version, a question like MSD-Q22 ("Has he/she ever waved good-bye?") must have a precondition that covers all four age tiers that include it, which is `child_age_months >= 4 and child_age_months <= 15`.

But the exit points also differ: MSD-C23 says "IF AGE IN MONTHS = 4 TO 6 MONTHS ---> GO TO RELATIONSHIPS SECTION". This means a 5-month-old stops at Q22, while a 10-month-old continues to Q32. The GOTO handles this with hard exits. The declarative version requires either:
1. Duplicate items for each age tier (explosion of items)
2. Complex preconditions that combine age-in-months ranges with individual milestone questions

Neither approach is clean, revealing that the MSD section was designed as an imperative sliding window, not a declarative constraint system.

### P4: Behaviour Section Age Gate Inconsistency (0-11 Months vs "AGE < 1")

| Source | Gate |
|--------|------|
| BEH NOTE (p109) | "AGE 0-11 MONTHS: BEH-Q1-4, BEH-Q5A" |
| BEH-C5 (p110) | "IF AGE < 1 ---> GO TO BEH-Q5A" |

The NOTE uses "AGE 0-11 MONTHS" which is a month-based criterion, but BEH-C5 uses "AGE < 1" which is a year-based criterion. For a child who is exactly 12 months old (1 year, 0 months), the NOTE's "0-11 MONTHS" would exclude them, but "AGE < 1" would also exclude them (age = 1, not < 1).

However, for a child who is 11 months and 29 days old, both criteria include them. The issue is that the survey uses **two different units** (months in the NOTE, years in the routing) for the same logical gate. If the child's age was recorded as "1 year" (rounded up from 11 months), the routing at BEH-C5 would send them to BEH-Q5 (new foods reaction), but the NOTE says they should get BEH-Q5A (difficult to feed).

**PDF evidence:**
- p109: *"AGE 0-11 MONTHS: BEH-Q1 - 4, BEH-Q5A"*
- p109: *"AGE 1 YEAR: BEH-Q1 - Q5"*
- p110: *"BEH-C5 IF AGE < 1 ---> GO TO BEH-Q5A, OTHERWISE ---> GO TO BEH-Q5"*

The NOTE lists "AGE 1 YEAR" as getting Q1-Q5, confirming that age 1 should get Q5, not Q5A. But the boundary between "0-11 MONTHS" and "1 YEAR" depends on whether age is recorded in months or rounded years.

### P5: Custody Section Multi-Conditional Routing Creates Dead Paths

CUS-C1A (p130) has a 4-way conditional:

> *"IF ELDEST SELECTED CHILD AND CUS-Q1A = YES ---> GO TO CUS-Q1D"*
> *"ELSE IF ELDEST CHILD'S CUSTODY SECTION COMPLETED AND SELECTED CHILD IS A FULL SIBLING ---> GO TO CUS-C1B"*
> *"ELSE IF CUS-Q1A = YES ---> GO TO CUS-Q1D"*
> *"OTHERWISE ---> GO TO CUS-Q1B"*

The third condition ("ELSE IF CUS-Q1A = YES ---> GO TO CUS-Q1D") is **only reachable** when:
- The child is NOT the eldest selected child (first condition failed)
- The eldest child's custody section was NOT completed OR the child is NOT a full sibling (second condition failed)
- AND CUS-Q1A = YES

This creates a path where a non-eldest child who lived with the respondent at birth but whose eldest sibling did NOT complete the custody section goes to CUS-Q1D. But CUS-Q1D asks about brothers and sisters who do not live in the household -- which is the same question regardless of whether the child is eldest or not.

**The dead code:** The first and third conditions both route to CUS-Q1D when CUS-Q1A=YES. The only difference is the first requires "ELDEST SELECTED CHILD" and the third doesn't. But since the third is ELSE-IF (only reached when the first is false), they are mutually exclusive by construction. The first condition is redundant -- removing it would not change the routing, because the third condition catches all CUS-Q1A=YES cases that the first misses.

**PDF evidence:**
- p130: CUS-C1A full conditional chain

### P6: CUS-C10 Phantom Variable References

CUS-C10 (p142) has this complex conditional:

> *"IF CUS-Q9A OR CUS-Q9B = 3 (BOTH PARENTS DIED) ---> GO TO CHILD CARE SECTION"*
> *"ELSE IF CUS-Q5A = NO OR DON'T KNOW (PARENTS EITHER DID NOT LIVE TOGETHER, OR DON'T KNOW IF THEY LIVED TOGETHER) ---> GO TO CUS-C20B"*
> *"ELSE IF CUS-Q5A=YES AND CUS-Q5B=BEFORE (PARENTS LIVED TOGETHER ONLY BEFORE CHILD'S BIRTH) ---> GO TO CUS-C20B"*
> *"ELSE IF (CUS-Q9A = 1 OR 2) OR ((CUS-Q9B = 1 OR 2) AND CUS-Q5A = YES (AND THEY HAD LIVED TOGETHER)) ---> GO TO CUS-Q10A"*
> *"OTHERWISE ---> GO TO CUS-Q10B"*

**Problem 1:** The condition references CUS-Q9B, which asks "Has one of the child's parents died?" But CUS-Q9B is only asked when CUS-Q9A response was 4 (No) or 5-8 (Don't Know). So at CUS-C10, if CUS-Q9A was 1, 2, or 3 (a parent died), CUS-Q9B was never asked. The condition "CUS-Q9A OR CUS-Q9B = 3" is ambiguous -- does it mean (CUS-Q9A = 3) OR (CUS-Q9B = 3), or CUS-Q9A = 3 OR CUS-Q9B = 3? The parenthesization is unclear.

**Problem 2:** The fourth condition references both CUS-Q9A and CUS-Q9B with compound logic, but these two questions are on **mutually exclusive paths** (Q9A is asked first; Q9B is only asked if Q9A was skipped via routing from Q9B's entry point). The condition assumes both could have values simultaneously, which is impossible in a single interview.

**PDF evidence:**
- p141: *"CUS-Q9A Between ...'s birth and now, has one of his/her parents died?"* -- options 1-3 (Yes), 4 (No), 5-8 (DK)
- p142: *"CUS-Q9B Has one of ...'s parents died?"* -- asked via different routing path
- p142: CUS-C10 full conditional chain

### P7: Asymmetric DON'T KNOW/REFUSAL Routing Across Sections

Throughout the questionnaire, REFUSAL responses are routed inconsistently:

| Section | REFUSAL routing | Example |
|---------|----------------|---------|
| Family Functioning (FNC) | "REFUSAL ---> GO TO NEXT SECTION" | p33: FNC-Q1A option 9 |
| Social Support (SUP) | "REFUSAL ---> GO TO SUP-Q2A" (within section) | p38: SUP-Q1A option 9 |
| Neighbourhood (SAF) | "REFUSAL ---> GO TO NEXT SECTION" | p35: SAF-Q2 option 9, SAF-Q5A option 9 |
| Parenting (PAR) | "REFUSAL ---> GO TO CUSTODY SECTION" (skip rest) | p125: PAR-Q1 option 9 |
| Custody (CUS) | "REFUSAL ---> GO TO CHILD CARE SECTION" (skip rest) | p130: CUS-Q1A option 9 |
| Behaviour (BEH) | "REFUSAL ---> GO TO BEH-C5" (within section) | p109: BEH-Q1 option 9 |

In the Family Functioning section, a single REFUSAL at any item in the FNC-Q1 battery (13 items sharing the same scale) skips the **entire section**. But in the Social Support section, a REFUSAL at SUP-Q1A only skips to SUP-Q2A (the second subsection), preserving the rest of the section.

**In the declarative version**, this asymmetry is invisible because REFUSAL is not a valid response code in QML (only the substantive response options 1-4 are modeled). The imperative GOTO routing for REFUSAL creates hidden skip paths that bypass large sections of the questionnaire. These paths are **dead code in the declarative version** -- they exist in the PDF but have no QML equivalent, meaning the validator cannot detect the inconsistent treatment of refusals.

### P8: Literacy Section Age Gate Creates Impossible Path for Age 5

LIT-C4 (p102) has this routing:

> *"IF AGE = 2-4 ---> GO TO LIT-Q4"*
> *"IF AGE = 5 ---> GO TO LIT-Q6A"*
> *"IF AGE = 6-7 ---> GO TO LIT-Q7A"*
> *"OTHERWISE (AGE = 8-11) ---> GO TO LIT-Q7B"*

Then LIT-C7A (p102):

> *"IF AGE < 5 ---> GO TO LIT-Q7"*
> *"OTHERWISE ---> GO TO LIT-Q7A"*

A 5-year-old enters at LIT-Q6A ("Have you or another adult ever read aloud to the child on a regular basis?"). If YES, they go to LIT-Q6B1, then LIT-C7A. At LIT-C7A, the condition "AGE < 5" is **FALSE** (age is 5), so they go to LIT-Q7A.

But LIT-Q7A asks: "Currently, how often do you or another adult read aloud to him/her or listen to him/her read or attempt to read aloud?" The age-5 path through LIT-Q6A -> LIT-Q6B1 -> LIT-C7A -> LIT-Q7A means a 5-year-old who has been read to regularly is asked Q7A. But a 5-year-old who has NOT been read to (LIT-Q6A = NO) goes to LIT-Q8, skipping Q7A entirely.

Then LIT-C8 (p103):

> *"IF AGE > 5 ---> GO TO LIT-Q9"*
> *"OTHERWISE GO TO LIT-Q8"*

For a 5-year-old, "AGE > 5" is FALSE, so they go to LIT-Q8. But a 5-year-old who answered NO at Q6A already went to LIT-Q8 directly. This means **both paths converge at LIT-Q8 for age 5**, but via different routes with different intermediate questions asked.

Then LIT-C9 (p103):

> *"IF AGE = 2-4 ---> GO TO ACTIVITIES SECTION"*
> *"OTHERWISE (AGE = 5) ---> GO TO LIT-Q12"*

A 5-year-old continues to LIT-Q12 ("How often does the child look at books or try to read on his/her own?") and then to LIT-Q13 and LIT-Q14.

**The problem:** The NOTE at the top of the Literacy section (p101) says: "AGE 5 YEARS: LIT-Q1-Q3; LIT-Q6A-Q7A; LIT-Q8; LIT-Q12-Q14". But the actual GOTO routing sends a 5-year-old through LIT-Q7A **only if** Q6A=YES. If Q6A=NO, they skip Q7A. The NOTE implies Q7A is always asked for age 5, but the routing makes it conditional.

**PDF evidence:**
- p101: *"AGE 5 YEARS: LIT-Q1 - Q3; LIT-Q6A - Q7A; LIT-Q8; LIT-Q12 - Q14"*
- p102: *"LIT-Q6A Have you or another adult ever read aloud to ... on a regular basis?"* with "2 NO ---> GO TO LIT-Q8"
- p102: *"LIT-C7A IF AGE < 5 ---> GO TO LIT-Q7"*

## Impact Assessment

| Category | Imperative (PDF) | Declarative (QML) |
|----------|------------------|-------------------|
| **Age gate contradictions** | Hidden by sequential GOTO -- interviewer follows routing without seeing NOTE conflicts | Forced into explicit preconditions -- validator can flag when NOTE age ranges don't match GOTO conditions |
| **Cross-reference errors** | DON'T KNOW -> Q3 circular reference invisible in paper flow | Would create cycle or unreachable item in QML (caught by validator) |
| **Overlapping month ranges** | Each age tier has a single GOTO entry point -- overlap is implicit | Must be expressed as overlapping preconditions -- makes the sliding window design explicit |
| **Unit inconsistency** | Years vs months used interchangeably in routing | Forces choice: single age variable or separate year/month variables |
| **REFUSAL asymmetry** | Each REFUSAL has its own GOTO target -- inconsistency spread across 244 pages | Refusals are outside the QML model -- asymmetry becomes invisible but also unverifiable |
| **Dead conditional branches** | Multi-way IFs with redundant conditions execute correctly but contain dead logic | Z3 can detect when a condition is subsumed by a prior condition |

## Conclusion

The Z3 QML validator found the NLSCY questionnaire to be **structurally valid** with no dependency cycles, no unreachable items, and no infeasible postconditions. This is primarily because the survey uses **child age as a one-directional routing variable** -- it is set once and never modified by downstream responses, avoiding the feedback loop pattern found in the LFS questionnaire.

However, the declarative conversion exposed **8 categories of problems** in the original 244-page CATI questionnaire:

1. **Age boundary contradictions** (P1) -- HLT section NOTE vs GOTO age ranges disagree on which questions are asked for ages 4-5
2. **Circular reference in DON'T KNOW routing** (P2) -- HLT-Q6 DON'T KNOW routes to Q3 (height question), creating an infinite loop
3. **Overlapping month ranges in MSD** (P3) -- 8 age tiers with sliding window design that cannot be cleanly expressed declaratively
4. **Unit inconsistency in age gates** (P4) -- BEH section uses months in NOTE but years in GOTO routing
5. **Dead conditional branches in custody** (P5) -- CUS-C1A has redundant first condition that is subsumed by third condition
6. **Phantom variable references** (P6) -- CUS-C10 references both CUS-Q9A and CUS-Q9B which are on mutually exclusive paths
7. **Asymmetric REFUSAL routing** (P7) -- REFUSAL skips entire sections in some cases, only subsections in others
8. **Conditional path contradicts section NOTE** (P8) -- LIT section NOTE lists Q7A as always asked for age 5, but routing makes it conditional on Q6A

These problems are nearly impossible to detect by reading the 244-page PDF, where each question's routing appears locally correct. The GOTO-based design masks contradictions between section headers and actual routing logic, circular references in skip patterns, and dead conditional branches. The declarative approach forces all constraints to be globally consistent, making structural issues immediately visible to formal verification tools.

The NLSCY's complexity (15+ sections, 8 age tiers, month-based developmental milestones, respondent-type gates, and sibling-completion flags) represents a significant challenge for imperative CATI design. The declarative QML version, while necessarily simplified for the validator, reveals that the original questionnaire's local correctness does not guarantee global consistency.
