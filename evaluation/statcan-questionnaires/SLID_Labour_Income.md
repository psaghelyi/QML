# SLID 1994 Preliminary Interview: Declarative Conversion Analysis

**Source:** Statistics Canada, Catalogue No. 94-10, 1994 Preliminary Interview Questionnaire
**QML File:** `evaluation/statcan-questionnaires/SLID_Labour_Income.qml`
**Date:** 2026-03-19

## Objective

Transform the SLID (Survey of Labour and Income Dynamics) 1994 Preliminary Interview from its imperative GOTO-based CAI format (PDF, 60 pages across 4 modules) into a declarative QML representation, then run the Z3-based formal validator to detect structural problems hidden in the imperative version.

## Methodology

1. Page-by-page reading of all 60 PDF pages (4 modules: EMPPRE, EXPRE, DEMPRE, EDUPRE)
2. Faithful QML conversion reproducing the PDF's GOTO-based routing as declarative preconditions
3. Formal validation using the Askalot Z3 QML validator
4. Back-verification of every finding against specific PDF page numbers with exact quotes

## Corrections Made (QML divergences from PDF)

These were necessary adaptations to express the imperative GOTO-based flow in declarative QML. They are NOT problems in the original PDF -- they reflect the structural gap between imperative and declarative paradigms.

| # | Item | PDF Logic | QML Adaptation | PDF Reference |
|---|------|-----------|----------------|---------------|
| 1 | START-EMPPRE age gate | `[age] = 15 or more? Yes -> Q1; No -> EXPRE-Q1A` | Precondition `age >= 15` on all EMPPRE items; under-15 respondents skip to DEMPRE/EDUPRE | p5: "Internal logic: [age] = 15 or more?" |
| 2 | EMPPRE-N4 temp layoff routing | `Q3=Temporary Layoff? Yes -> Q8; Otherwise -> J1.Q1` | Encoded as precondition on `q_emppre_q8`: checks `q_emppre_q3.outcome == 7 or == 8` | p6: "Internal logic: EMPPRE-Q3=Temporary Layoff" |
| 3 | EMPPRE-N6 date check | `Date in Q6 is before January [current year] minus 5 AND Q1=permanently unable?` | Encoded as codeBlock: `if q_emppre_q6.outcome <= 1988 and perm_unable == 1` | p7: "Internal logic: Date in EMPPRE-Q6 is before January [current year] minus 5" |
| 4 | EMPPRE-N7 routing | `Q1=permanently unable? Yes -> N12; Otherwise -> Q8` | Merged into `q_emppre_q8` precondition: `perm_unable == 0` | p8: "Internal logic: EMPPRE-Q1=permanently unable to work?" |
| 5 | EMPPRE-N11A work-in-reference-year check | `Q5=no OR dates last worked before January [reference year]?` | Encoded via `worked_ref_year` variable set in Q6 codeBlock | p9: "Internal logic: EMPPRE-Q5=no...or dates last worked...is before January" |
| 6 | EMPPRE-N12 age-65 gate | `[age] > 64? Yes -> EXPRE-Q1; Otherwise -> Q12` | Precondition `age <= 64` on Q12/Q13; over-64 respondents proceed to EXPRE | p10: "Internal logic: [age] is greater than 64 years?" |
| 7 | EXPRE-N1 age-69 gate | `[age] > 69? Yes -> DEMPRE-Q1A; Otherwise -> Q1A` | Precondition `age <= 69` on all EXPRE items | p21: "Internal logic: [age] is greater than 69 years?" |
| 8 | DEMPRE-N1 through N1F marital routing | 6 sequential internal logic checks on marital status | Single `marital_status` variable with preconditions on each branch | p27-28: "Internal logic: Marital status = married/common-law/separated/divorced/widowed/single?" |
| 9 | DEMPRE-N11A female-18+ gate | `Respondent is female 18 years of age and over?` | Precondition `sex == 2 and age >= 18` | p32: "Internal logic: Respondent is female 18 years of age and over?" |
| 10 | EDUPRE EVAL-Q1 years check | `EDUPRE-Q1 = 1 to 9? Yes -> Q4; Otherwise -> Q3` | Precondition `years_elem_hs >= 10` on Q3 | p38: "Internal logic: EDUPRE-Q1 = 1 to 9?" |
| 11 | J1.Q7A "Started in [current year]" routing | `Started in [current year] -> N12` | Encoded as label option 2; month-specific questions gated on outcome 1 or 3 | p13: "Started in [current year] Go to EMPPRE-N12" |
| 12 | DEMPRE COMPARE nodes | Date comparison internal logic nodes (COMPARE-Q2, Q4, 9A, 9B, 10A, 10B) | Omitted as interviewer error-correction prompts; cannot be expressed as preconditions | p28-32: "Internal logic: Date of this marriage...is before date of separation" |

## Validator Results

### Summary

| Metric | Value |
|--------|-------|
| Items | 108 |
| Blocks | 11 |
| Preconditions | 97 |
| Postconditions | 0 |
| Variables | 24 |
| Cycles | **0** |
| Connected Components | 10 |
| Structural Validity | `true` |
| NEVER reachable items | **0** |
| INFEASIBLE postconditions | **0** |

### Z3 Item Classifications

| Classification | Count |
|----------------|-------|
| ALWAYS reachable | 11 |
| CONDITIONAL reachable | 97 |
| NEVER reachable | 0 |

**ALWAYS reachable items (11):** `q_age`, `q_sex`, `q_marital_status_roster`, `q_dempre_q1a` (intro comment), `q_dempre_q16` (mother tongue), `q_dempre_q17` (country of birth), `q_dempre_q19` (registered Indian), `q_dempre_q20` (ethnic background), `q_edupre_q1` (years of school), `q_edupre_q17` (mother's education), `q_edupre_q18` (father's education).

These are the universal questions asked of every respondent regardless of age, sex, or employment status. All other 97 items are conditionally gated.

### Key Structural Finding: No Dependency Cycles

Unlike the LFS questionnaire (which had a PATH variable feedback loop), the SLID Preliminary Interview avoids cycles because it does not use a single overloaded state variable for routing. Instead, the SLID uses **independent routing variables** (`emp_status`, `ever_worked`, `perm_unable`, `temp_layoff`, `worked_ref_year`, `is_paid_worker_j1`, etc.) that are each written once and read downstream. This design avoids the write-then-read-then-write feedback pattern that creates cycles.

## Problems in the Original PDF (Exposed by Declarative Conversion)

### P1: Asymmetric Age Gates Across Modules

| Module | Age Gate | PDF Reference |
|--------|----------|---------------|
| EMPPRE | `[age] = 15 or more` | p5: "START-EMPPRE Internal logic: [age] = 15 or more?" |
| EMPPRE-N12 | `[age] > 64` (skip school questions) | p10: "Internal logic: [age] is greater than 64 years?" |
| EXPRE | `[age] > 69` (skip entire module) | p21: "EXPRE-N1 Internal logic: [age] is greater than 69 years?" |
| DEMPRE-N11A | `female AND [age] >= 18` (childbirth questions) | p32: "Internal logic: Respondent is female 18 years of age and over?" |

The age thresholds are **inconsistent across modules**:

- **Ages 15-64**: Full EMPPRE (with school questions) + full EXPRE + full DEMPRE + full EDUPRE
- **Ages 65-69**: EMPPRE (without school) + EXPRE (work experience) + DEMPRE + EDUPRE
- **Age 70+**: EMPPRE (without school) + skip EXPRE entirely + DEMPRE + EDUPRE

The gap at age 65-69 is notable: these respondents are asked detailed work experience questions (EXPRE) but are explicitly skipped from the school attendance question (Q12). The rationale is presumably that retirees are not "in school in January" -- but a 66-year-old enrolled in continuing education would be incorrectly excluded from Q12 while being asked Q1A ("Did you ever work full-time?").

**In the imperative version:** The GOTO at N12 (p10) silently skips Q12 for over-64s. The GOTO at EXPRE-N1 (p21) silently skips the entire EXPRE module for over-69s. These are **separate, uncoordinated gates** -- each was designed independently without a unified age-routing policy.

**In the declarative version:** The preconditions make these asymmetries explicit: `age >= 15`, `age <= 64`, `age <= 69`. The Z3 solver confirms all are reachable (CONDITIONAL), but the age-band gaps are visible in the precondition structure.

### P2: Self-Employed Workers Bypass All Earnings Questions

PDF p12, EMPPRE-J1.Q6: *"If paid worker or DK/R Go to EMPPRE-J1.Q7A. Otherwise Go to EMPPRE-N12"*

When a respondent answers "Self-employed" or "Unpaid family worker" at J1.Q6, the GOTO sends them directly to EMPPRE-N12 (the age/school gate), **bypassing all earnings questions** (J1.Q7A through J1.Q15). This means:

- No months worked (J1.Q7A/Q7B)
- No hours per week (J1.Q10)
- No wage/salary (J1.Q11A)
- No total earnings (J1.Q12)
- No commissions/bonuses (J1.Q13-Q15)

The same pattern repeats for the second job: PDF p17, EMPPRE-J2.Q7: *"If paid worker or DK/R Go to EMPPRE-J2.Q8A. Otherwise Go to EMPPRE-Q12."*

This is a **deliberate design choice** for the Preliminary Interview (the annual Labour and Income interviews would capture self-employment income separately), but it creates an **asymmetric data gap**: the questionnaire collects detailed occupation information (J1.Q3-Q5: industry, occupation, duties) for self-employed workers but zero financial data. A researcher examining the resulting dataset would see complete job descriptions for self-employed respondents with entirely missing income fields, without any flag indicating the omission was by design rather than non-response.

**In the declarative version:** The precondition `is_paid_worker_j1 == 1` on all earnings questions makes this gap structurally explicit. The Z3 solver confirms these items are CONDITIONAL -- reachable only for paid workers.

### P3: Temporary Layoff Workers Have Truncated Employment Path

PDF p6, EMPPRE-N4: *"Internal logic: EMPPRE-Q3=Temporary Layoff Yes Go to EMPPRE-Q8 Otherwise go to EMPPRE-J1.Q1"*

Workers on temporary layoff (seasonal or non-seasonal) at EMPPRE-Q3 are routed directly to Q8 (job search), **skipping all job description questions** (J1.Q1 through J1.Q15). This means a temporarily laid-off worker provides:
- Reason for absence (Q3)
- Whether they received pay during absence (Q4)
- Whether they looked for work (Q8)

But they provide **no information about the job they were laid off from**: no employer name, industry, occupation, class of worker, hours, or earnings.

Meanwhile, workers absent for other reasons (illness, pregnancy, vacation, labour dispute) go through J1.Q1 and the full job description sequence.

**In the imperative version:** The GOTO at N4 (p6) sends temp layoff workers to Q8 without any indication that job information was intentionally skipped. The flowchart on p48 (Appendix 1, EMPPRE Page 1 of 2) confirms this routing: the "Temporary layoff?" diamond sends "Yes" directly to Q8.

**In the declarative version:** The precondition on `q_j1_q1` explicitly excludes `q_emppre_q3.outcome == 7 or == 8` (temp layoff codes), making the skip visible. However, Q8's precondition must use a complex disjunction to capture all paths that reach it, revealing the tangled routing.

### P4: DK/R Responses Create Inconsistent Routing

Multiple questions treat DK/R (Don't Know / Refusal) inconsistently:

| Question | DK/R Treatment | PDF Reference |
|----------|---------------|---------------|
| EMPPRE-Q1 | DK/R routes to EMPPRE-N12 (same as "Permanently unable") | p5: "DK/R Go to EMPPRE-N12" |
| EMPPRE-Q2 | "No/DK/R" routes to Q5 (same as "No") | p5: "No/DK/R Go to EMPPRE-Q5" |
| EMPPRE-Q5 | "Yes/DK/R" routes to Q6 (same as "Yes") | p7: "Yes/DK/R Go to EMPPRE-Q6" |
| EMPPRE-Q8 | "No/DK/R" routes to Q10 | p8: "No/DK/R Go to EMPPRE-Q10" |
| EMPPRE-Q12 | "No/DK/R" routes to EXPRE-Q1A | p10: "No/DK/R Go to EXPRE-Q1A" |

At Q1, a respondent who says "Don't know" is treated identically to one who is permanently unable to work -- both are routed to N12, completely bypassing the employment section. This is a **lossy routing decision**: the system cannot distinguish between "genuinely unable to answer" and "permanently disabled," yet both receive the same truncated questionnaire path.

At Q5, DK/R is merged with "Yes" -- a respondent who doesn't know if they ever worked is treated as having worked, triggering Q6 ("When did you last work?"). This creates a logical contradiction: asking a date for a work history the respondent couldn't confirm.

**In the imperative version:** These DK/R routings are locally reasonable shortcuts. The interviewer can use the "Comment" function key (p4) to note the ambiguity.

**In the declarative version:** The merged response codes (e.g., label `1: "Yes/DK/R"`) preserve the PDF's routing faithfully, but the Z3 solver cannot distinguish between a genuine "Yes" and a "DK/R" that was merged into the same code. The asymmetric treatment is embedded in the label structure.

### P5: EMPPRE-N11A Complex Routing Condition Creates a Hidden Path Split

PDF p9, EMPPRE-N11A: *"Internal logic: EMPPRE-Q5=no (never worked at a job or business) or dates last worked (EMPPRE-Q6) is before January [reference year]?"*

This internal logic node merges two very different populations:

1. **Never worked (Q5=no)**: These respondents have no employment history at all
2. **Last worked before reference year**: These respondents have employment history but not in the reference year

Both groups are sent to EMPPRE-N12 (the age gate), but group 2 has already answered Q6 (date last worked) and Q7 (reason for leaving), while group 1 has not. The merged routing means both groups bypass J1.Q1A (the "last job in reference year" employer questions), which is correct -- but the logic conflates "no work history" with "stale work history" into a single exit point.

**If N11A = Otherwise** (worked in reference year), the respondent goes to J1.Q1A -- the alternative employer-name introduction for workers who were NOT working in January but DID work in the reference year.

**In the declarative version:** This is encoded via the `worked_ref_year` variable. The precondition on `q_j1_q1a` checks `ever_worked == 1 and worked_ref_year == 1` to distinguish respondents who actually worked in the reference year from those who didn't.

### P6: EXPRE Consistency Checks Are Error Messages, Not Logic Gates

PDF p24, EXPRE-N4: *"Internal logic: Sum of Q4A/B/C = EXPRE-Q1B? Yes Go to DEMPRE-Q1A Otherwise Go to EXPRE-Q4D"*

PDF p26, EXPRE-N6: *"Internal logic: Sum of Q6A/B/C = EXPRE-Q5A? Yes Go to DEMPRE-Q1A Otherwise Go to EXPRE-Q6D"*

Both N4 and N6 check whether the full-time + part-time + some-of-each year counts add up to the total. When they don't match, the system shows an error message (Q4D or Q6D) asking the interviewer to go back and correct the inconsistency.

These are **runtime validation checks** that function as postconditions, but in the imperative version they create a loop: if the sum doesn't match, the interviewer is instructed to go back and re-enter values. The "Otherwise press Enter to continue" instruction means the interviewer can **override the error** and proceed with inconsistent data.

**In the declarative version:** These would be postconditions like `q_expre_q4a.outcome + q_expre_q4b.outcome + q_expre_q4c.outcome == years_working`. However, because QML postconditions are strict (they block progression until satisfied), while the PDF's error messages are soft (the interviewer can override), the QML cannot faithfully reproduce the "warn but allow" behavior. The QML omits these as postconditions to avoid creating INFEASIBLE conditions that don't exist in the original.

### P7: DEMPRE Date Comparison Nodes Cannot Prevent Invalid Data

The DEMPRE module contains 6 date comparison internal logic nodes:

| Node | Check | PDF Reference |
|------|-------|---------------|
| COMPARE-Q2 | Date of marriage (Q2) before date of separation (Q1)? | p28 |
| COMPARE-Q4 | Date of first marriage (Q4) before date of current marriage (Q2)? | p29 |
| COMPARE9A | Date of marriage (Q9) before date widowed (Q7)? | p31 |
| COMPARE9B | Date of marriage (Q9) before date living together (Q5)? | p31 |
| COMPARE10A | Date of first marriage (Q10) before date living together (Q5)? | p32 |
| COMPARE10B | Date of first marriage (Q10) before date widowed (Q7)? | p32 |

Each comparison follows the same pattern: if the dates are inconsistent, show an error message asking the interviewer to go back and correct. If the dates are consistent (or the interviewer presses Enter to override), continue.

This creates the same problem as P6: the checks are advisory, not enforceable. An interviewer under time pressure can override all 6 date comparisons, resulting in a respondent whose first marriage date is after their widowing date.

**In the declarative version:** These are omitted because QML postconditions are strict gates -- they would make legitimate paths infeasible if the date data is simply unavailable or estimated. The absence of these checks means the QML version is more permissive than the PDF intends, but the PDF's own enforcement is soft enough that the difference is minor.

### P8: EDUPRE-Q4 "No" Path Skips Both College Details AND University

PDF p38-39, EDUPRE-Q4: *"EXCLUDING UNIVERSITY, HAS [respondent] EVER BEEN ENROLLED IN ANY OTHER KIND OF SCHOOL...? Yes/DK/R Go to EDUPRE-Q5 No Go to EDUPRE-Q12"*

When a respondent answers "No" to Q4, the GOTO sends them to Q12 (university enrollment). This correctly skips Q5-Q11 (college/trade certificate details). However, the routing **from Q5 "No"** also goes to Q11 (total years of college):

PDF p39, EDUPRE-Q5: *"Has [respondent] received any certificates or diplomas...? Yes/DK/R Go to EDUPRE-Q6 No Go to EDUPRE-Q11"*

A respondent who was enrolled in college (Q4=Yes) but received no certificates (Q5=No) is sent to Q11 (total years of schooling at college), then to Q12 (university). But a respondent who was NEVER enrolled (Q4=No) skips Q11 entirely and goes directly to Q12.

This means Q11 ("total years of schooling at community college") is asked of people who enrolled but got no certificate, but NOT of people who never enrolled. This is logically correct but creates an **ambiguous zero**: if Q11 is blank in the dataset, it could mean either "never enrolled" (Q4=No) or "not asked because Q4 was skipped for another reason."

**In the declarative version:** The precondition `enrolled_other_school == 1` on Q11 makes this explicit. The Z3 solver confirms Q11 is CONDITIONAL, reachable only when Q4 was answered Yes.

## Impact Assessment

| Category | Imperative (PDF) | Declarative (QML) |
|----------|------------------|-------------------|
| **Age asymmetries** | Hidden across 3 separate GOTO nodes in different modules (p5, p10, p21) | Visible as explicit age-band preconditions; Z3 confirms all ages have valid paths |
| **Self-employed data gaps** | Single GOTO at Q6 (p12) silently bypasses 9 earnings questions | `is_paid_worker_j1 == 1` precondition makes the exclusion structurally visible |
| **DK/R routing** | Locally reasonable shortcuts, inconsistent across questions | Merged labels preserve routing but lose the ability to distinguish DK/R from genuine responses |
| **Soft validation** | Error messages with override capability (Enter to continue) | Cannot be faithfully reproduced; QML postconditions are strict gates |
| **Temp layoff bypass** | GOTO skips job description without indication | Complex precondition disjunction reveals the routing tangle |
| **Date comparisons** | 6 advisory checks with interviewer override | Omitted; QML would make them infeasible if data is approximate |

## Comparison with LFS Analysis

The SLID Preliminary Interview has a fundamentally **cleaner** structure than the LFS Labour Force questionnaire:

| Aspect | LFS | SLID |
|--------|-----|------|
| **Dependency cycles** | 1 cycle (PATH variable feedback loop) | **0 cycles** |
| **State variables** | 1 overloaded PATH (7 values, read + written across 4 blocks) | 24 independent routing variables, each written once |
| **Items stuck in cycles** | 14 of 83 | 0 of 108 |
| **Age contradictions** | 15 vs 16 age gate conflict | Consistent thresholds but asymmetric across modules |
| **Dead code** | PATH=4 check at Q178 was unreachable | No NEVER-reachable items detected |

The SLID avoids cycles because it uses **single-assignment routing variables** (each variable is set by exactly one codeBlock and read by downstream preconditions). The LFS used a **mutable PATH variable** that was both read and written across multiple blocks, creating the circular dependency.

## Conclusion

The Z3 QML validator processed all 108 items across 11 blocks with **no cycles, no unreachable items, and no infeasible conditions**. The SLID Preliminary Interview is structurally sound at the routing level.

The declarative conversion exposed **8 categories of structural observations** in the original 60-page CAI questionnaire:

1. **Asymmetric age gates** (15/64/69) designed independently across modules without unified policy
2. **Self-employed earnings gap** -- complete job descriptions with zero financial data, by design but undocumented in the data
3. **Temporary layoff truncation** -- laid-off workers skip all job description questions
4. **Inconsistent DK/R routing** -- "Don't know" merged with different categories at different questions
5. **Hidden path splits** (N11A) -- merging "never worked" with "worked before reference year"
6. **Soft validation as error messages** -- EXPRE year-count consistency checks that interviewers can override
7. **Advisory date comparisons** -- 6 DEMPRE date checks with override capability
8. **Ambiguous zeros in education** -- Q11 missing vs Q11 not asked indistinguishable in output data

These observations are nearly invisible when reading the 60-page PDF, where each GOTO appears locally correct. The declarative approach forces all constraints to be globally explicit, making structural asymmetries visible to both human reviewers and formal verification tools.
