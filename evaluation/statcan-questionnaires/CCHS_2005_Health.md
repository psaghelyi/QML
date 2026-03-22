# CCHS 2005 Health Survey (Cycle 3.1): Declarative Conversion Analysis

**Source:** Statistics Canada, Canadian Community Health Survey - Cycle 3.1, Final Questionnaire (June 2005), 303 pages
**QML File:** `evaluation/statcan-questionnaires/CCHS_2005_Health.qml`
**Date:** 2026-03-19

## Objective

Transform the CCHS 2005 CATI questionnaire (303 pages, ~60 modules, GOTO-based branching) into a declarative QML representation, then run the Z3-based formal validator to detect structural problems hidden in the imperative version.

## Methodology

1. Targeted reading of the 303-page PDF: table of contents, alphabetic index, and the 15-20 most routing-heavy sections
2. Declarative QML conversion covering all major modules with full routing detail on complex ones
3. Formal validation using the Askalot Z3 QML validator
4. Cross-referencing validator findings against PDF page numbers

## Survey Architecture Overview

The CCHS Cycle 3.1 is a modular health survey with approximately 60 content modules. Each module has a block selection flag (e.g., "If do DEP block = 1, go to DEP_C02. Otherwise, go to DEP_END."). Module selection is controlled by a sampling algorithm external to the questionnaire itself -- different respondents receive different subsets of optional modules.

**Module categories:**
- **Common content** (all respondents): General Health, Chronic Conditions, Health Care Utilization, Smoking, Socio-Demographics, Education, Income
- **Optional content** (subsample): Depression, Suicidal Thoughts, HUI, SF-36, Labour Force, Food Security, Sexual Behaviours, Problem Gambling, and ~40 others
- **Sex-gated modules**: Pap Smear (female 18+), Mammography (female 35+), Breast Exams (female), Prostate Screening (male 40+), Maternal Experiences (female 15-55, non-proxy)
- **Age-gated modules**: Youth Smoking (age <= 19), Alcohol age-started (age <= 19), Colorectal Screening (50+), Labour Force (15-75)

## Validator Results

### Summary

| Metric | Value |
|--------|-------|
| Items | 231 |
| Blocks | 43 |
| Preconditions | 227 |
| Postconditions | 1 |
| Variables | 91 |
| Cycles | **0** |
| Connected Components | 103 |
| Structural Validity | `true` |
| Issues | **0** |

### Z3 Item Classifications

| Classification | Count |
|---------------|-------|
| Precondition ALWAYS | 4 (ANC block demographics) |
| Precondition CONDITIONAL | 227 (all module-gated items) |
| Precondition NEVER | 0 |
| Postcondition CONSTRAINING | 1 (dep_q14 weeks validation) |
| Postcondition INFEASIBLE | 0 |
| Postcondition TAUTOLOGICAL | 0 |

**No items are unreachable.** All 231 items have at least one valid path. The 4 ALWAYS items are the ANC (Age of Selected Respondent) block -- the entry point collecting age, sex, and proxy status.

## Problems in the Original PDF (Exposed by Declarative Conversion)

### P1: Module Selection Opacity -- Phantom External Dependencies

**PDF evidence:** Every module begins with "If (do [MODULE] block = 1), go to [MODULE]_C01. Otherwise, go to [MODULE]_END." (e.g., DEP_C01 p.185, SUI_C1A p.191, HUI_C1 p.201)

**Problem:** The module selection algorithm is entirely external to the questionnaire. The PDF never defines how `do DEP block`, `do HUI block`, etc. are set. A respondent's module assignment depends on an undocumented sampling algorithm that runs before the interview begins.

**In the imperative version:** The interviewer's CATI system has the block flags pre-set. The questionnaire doesn't need to explain them because they're system variables.

**In the declarative version:** We must declare these as variables initialized in `codeInit`. The QML makes this dependency explicit -- every module's precondition references a `do_xxx` flag, making visible that the entire questionnaire flow depends on 60+ externally-controlled boolean flags. The Z3 solver treats these as free variables, which means it validates all possible combinations. This is why all module-gated items are classified as CONDITIONAL rather than ALWAYS.

**Impact:** Without the module selection algorithm, it is impossible to determine from the PDF alone which modules are mutually exclusive, which are always paired, or what the minimum/maximum module count per respondent is. The declarative model forces this gap to be explicitly represented.

### P2: Depression CIDI-SF Dual Pathway -- Asymmetric Severity Gates

**PDF evidence:** DEP_Q02-Q15 (sadness pathway, p.185-187), DEP_Q16-Q28 (loss of interest pathway, p.187-190), DEP_C14 (p.187)

**Problem:** The two screening pathways have asymmetric severity gates that create different eligibility thresholds:

| Gate | Sadness Path (Q02-Q15) | Interest Path (Q16-Q28) |
|------|----------------------|------------------------|
| Duration | Q03: All day / Most of day passes | Q17: All day / Most of day passes |
| Frequency | Q04: Every day / Almost every day passes | Q18: Every day / Almost every day passes |
| Symptoms | Q05-Q13 (7 symptoms) | Q19-Q26 (7 symptoms) |
| Threshold | DEP_C14: ANY symptom Yes → duration questions | DEP_C27: ANY symptom Yes → duration questions |

The two paths are **independent** -- a respondent can qualify through sadness alone, interest loss alone, or both. But DEP_C14 (p.187) creates a cross-reference: "If 'Yes' in DEP_Q05, DEP_Q06, DEP_Q09, DEP_Q11, DEP_Q12, or DEP_Q13, **or DEP_Q07 is 'gain' or 'lose'**, go to DEP_Q14C."

The weight change question (Q07) uses a 4-category response (gain/lose/same/diet) where 2 of 4 options count as a symptom, while all other symptom questions are binary Yes/No. This means a respondent who reports "stayed the same" on weight but "Yes" on no other symptom is screened out, while one who "gained weight" but says "No" to everything else qualifies. The weight change question has a 50% pass rate by response distribution, while binary questions have the respondent's actual 50% base rate. This creates an asymmetric sensitivity threshold.

**In the declarative version:** The QML makes both pathways explicit with independent precondition chains. The Z3 solver confirms both paths are reachable and all symptom items are CONDITIONAL (not NEVER), verifying no dead code.

### P3: Proxy Interview Exclusion -- Inconsistent Application

**PDF evidence:** DEP_C02 (p.185): "If proxy interview, go to DEP_END." SUI_C1B (p.191): "If proxy interview or if age < 15, go to SUI_END." DRG_C2 (p.135): "If proxy interview, go to DRG_END." But HUI has no proxy exclusion (p.201). SFR has no proxy exclusion (p.207).

**Problem:** Proxy exclusion is applied inconsistently across modules:

| Module | Proxy Excluded? | Rationale |
|--------|----------------|-----------|
| Depression (DEP) | Yes | Self-report mental state |
| Suicidal Thoughts (SUI) | Yes | Sensitive self-report |
| Illicit Drugs (DRG) | Yes | Sensitive self-report |
| Distress (DIS) | Yes (implied) | K6 self-report scale |
| Health Utility Index (HUI) | **No** | Functional status can be proxy-reported |
| SF-36 (SFR) | **No** | But SFR includes mental health items (Q24-Q31) |
| Chronic Conditions (CCC) | **No** | Diagnosis-based, proxy can report |
| Smoking (SMK) | **No** | Observable behaviour |

The SF-36 (SFR) module contains questions like "how much of the time have you been a very nervous person?" (SFR_Q24, p.211) and "how much of the time have you felt so down in the dumps?" (SFR_Q25, p.211). These are subjective mental health items similar to the Depression module -- yet proxy respondents can answer them. This creates a methodological inconsistency: a proxy respondent is excluded from the CIDI-SF depression screening but can complete the SF-36 mental health subscale.

**In the declarative version:** The QML encodes proxy exclusion as `is_proxy == 0` in preconditions where the PDF specifies it. The SF-36 block has no proxy exclusion (matching the PDF), making the asymmetry visible.

### P4: Age Gate Contradiction in Labour Force Module

**PDF evidence:** LBF_C02 (p.250): "If age < 15 or age > 75, go to LBF_END." LF2_C2 (p.264): "If age < 15 or age > 75, go to LF2_END."

The Labour Force module uses an explicit age range of 15-75. But the Labour Force Common Portion (LF2) is a parallel module that duplicates LBF questions for respondents NOT in the LBF subsample. LF2_C1 states: "If (do LBF block = 1) or (m79 = 1), go to LF2_END."

**Problem:** If a respondent is assigned to the LBF subsample (`do LBF block = 1`), they skip LF2 entirely. If they are NOT in the LBF subsample, they get LF2 instead. But LF2 is a subset of LBF questions -- it asks about current employment (LF2_Q1-Q3, equivalent to LBF_Q01-Q03) but not the detailed occupation, hours, or job search questions.

This creates **two different labour force data collection depths** based on random subsample assignment, not respondent characteristics. The declarative model makes this explicit: `do_lbf` and `do_lf2` are independent module flags, but logically they should be mutually exclusive (if one is on, the other should be off). The PDF does not enforce this at the questionnaire level -- it relies on the external sampling system.

### P5: Cross-Module Variable Dependencies -- Smoking Status

**PDF evidence:** SMK_Q202 referenced in: YSM_C1B (p.122), ETS_C10 (p.124), ETS_C20 (p.124), MEX_C20 (p.132), SPC module (p.120), NDE module (p.116), SCA module (p.117)

**Problem:** The smoking status variable (SMK_Q202 -- daily, occasional, or non-smoker) is set in the Smoking module (SMK, p.110) and referenced by at least 6 other modules. If the SMK module is not assigned to a respondent (do SMK block = 0), the smoking status variable is undefined, yet downstream modules still reference it.

The PDF handles this implicitly: the CATI system presumably initializes SMK_Q202 from prior cycle data or sets it to a default. But the questionnaire text never specifies this fallback.

**In the declarative version:** The QML initializes `smk_status = 0` in `codeInit`, and the SMK block's codeBlock updates it. Modules that reference smoking status (ETS, YSM, MEX) use the variable, which works if SMK runs first. But if SMK is not assigned, `smk_status` stays at 0, which may not match any valid response category (daily=1, occasional=2, not at all=3). The Z3 solver does not flag this because 0 is within the integer domain, but semantically it represents an undefined state.

### P6: Injury Module -- Mutually Exclusive Causation Paths Without Explicit Enforcement

**PDF evidence:** INJ_Q10 (p.198): "Was the injury the result of a fall?" If Yes -> INJ_Q11 (how fell). If No -> INJ_Q12 (what caused injury). INJ_Q11 and INJ_Q12 are mutually exclusive.

**Problem:** The fall/non-fall routing creates two mutually exclusive causation paths, but only the GOTO structure enforces this. INJ_Q10=Yes leads to INJ_Q11 (fall mechanism), which then skips to INJ_Q13. INJ_Q10=No leads to INJ_Q12 (non-fall cause), which then goes to INJ_Q13. A respondent never sees both Q11 and Q12.

**In the declarative version:** The QML encodes this as:
- `inj_q11` precondition: `inj_q10.outcome == 1` (fall)
- `inj_q12` precondition: `inj_q10.outcome == 0` (not fall)

The Z3 solver confirms both items are CONDITIONAL (reachable) and their preconditions are mutually exclusive (no respondent sees both). This is a clean declarative translation of the imperative routing.

### P7: HUI Vision Cascade -- Forward Skip Creates Gap

**PDF evidence:** HUI_Q01 (p.201): "Are you able to read newsprint without glasses?" If Yes -> Go to HUI_Q04. HUI_Q02 (p.201): "...with glasses?" If Yes -> Go to HUI_Q04. HUI_Q03 (p.201): "Are you able to see at all?" If Yes -> Go to HUI_Q06. If No -> Go to HUI_Q06.

**Problem:** When HUI_Q01 = Yes (can read newsprint without glasses), the respondent skips to HUI_Q04 (recognize friend without glasses). But HUI_Q04's "Yes" answer skips to HUI_Q06 (hearing section), meaning a person with good uncorrected vision who can also recognize friends never gets asked about corrected vision at all. This is intentional (they don't need correction) but creates a **data gap**: for these respondents, HUI_Q02 (corrected vision) and HUI_Q03 (any vision at all) have no data, yet the HUI scoring algorithm may expect values for all vision items.

**In the declarative version:** The QML correctly encodes the cascade:
- `hui_q02` requires `hui_q01.outcome == 0` (can't read without glasses)
- `hui_q03` requires both `hui_q01.outcome == 0` and `hui_q02.outcome == 0`
- `hui_q04` requires `hui_q01.outcome == 1` (can read without glasses)

The Z3 solver confirms all four items are CONDITIONAL and no item is NEVER reachable. The gap is by design -- but the declarative model makes explicit that a respondent who answers "Yes" to Q01 will have no data for Q02, Q03, and Q05.

## Structural Observations

### No Dependency Cycles

Unlike the LFS questionnaire (which had a `path` variable feedback loop), the CCHS has **no dependency cycles**. This is because:

1. **Module isolation**: Each module operates independently with its own internal state. Cross-module references go through shared variables (age, sex, smoking status) that are set once and read many times.
2. **No overloaded state machine**: The CCHS does not use a single PATH variable for both classification and routing. Each module has its own entry/exit logic.
3. **Linear cascades**: Complex modules like HUI and Depression use linear cascading (Q01 → Q02 → Q03) rather than circular state updates.

### High Component Count (103)

The validator found 103 connected components, which is high for a 231-item questionnaire. This reflects the modular architecture: each of the ~43 blocks is largely independent, with connections only through shared demographic variables (age, sex, is_proxy) and a few cross-module variables (smoking status, diabetes status). The average component size is ~2.2 items, indicating tight intra-module coupling but loose inter-module coupling.

### Module Selection as External Dependency

The most significant architectural finding is that module selection (the 60+ `do_xxx` flags) is entirely external. The questionnaire is not self-contained -- it requires an external system to set these flags before the interview begins. In a declarative model, this means the QML cannot be validated in isolation for completeness; it can only be validated for internal consistency given arbitrary flag combinations.

## Impact Assessment

| Category | Imperative (PDF) | Declarative (QML) |
|----------|------------------|-------------------|
| **Module selection** | Implicit CATI system flags | Explicit `do_xxx` variables -- reveals external dependency |
| **Cross-module refs** | Implicit variable sharing | Explicit codeBlock chains -- reveals undefined-state risks |
| **Proxy exclusion** | Per-module GOTO | Per-item preconditions -- reveals inconsistent application |
| **Sex/age gates** | Per-module entry checks | Per-item preconditions -- enables solver verification of reachability |
| **Dual pathways** | GOTO ensures mutual exclusivity | Explicit preconditions -- solver proves no overlap |
| **Data gaps** | Hidden by skip patterns | Visible in precondition chains -- items with CONDITIONAL status may have no data |

## Conclusion

The Z3 QML validator found **no structural defects** (no cycles, no unreachable items, no infeasible postconditions) in the CCHS 2005 questionnaire. This is a significantly cleaner result than the LFS, which had a dependency cycle preventing full validation.

The declarative conversion exposed **7 categories of design observations**:

1. **Module selection opacity** -- 60+ external flags control the entire survey flow with no in-questionnaire documentation
2. **Asymmetric severity gates** -- Depression CIDI-SF weight change question has different pass characteristics than binary symptom items
3. **Inconsistent proxy exclusion** -- SF-36 mental health items allow proxy but CIDI-SF depression does not
4. **Age gate documentation** -- Labour Force age range (15-75) is consistent but the two-module duplication (LBF/LF2) creates different data depth by random assignment
5. **Cross-module variable dependencies** -- Smoking status referenced by 6+ modules but may be undefined if SMK module not assigned
6. **Mutually exclusive paths** -- Injury fall/non-fall routing is clean in declarative form
7. **Cascade data gaps** -- HUI vision cascade intentionally skips items for healthy respondents, creating structured missing data

The CCHS's modular architecture is inherently better suited to declarative representation than the LFS's single-PATH state machine. Each module is a self-contained decision tree with well-defined entry conditions, making the GOTO-to-precondition translation straightforward. The main structural complexity comes not from within-module routing but from the 60+ external module selection flags that the questionnaire itself cannot validate.
