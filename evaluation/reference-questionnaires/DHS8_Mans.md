# DHS-8 Model Man's Questionnaire: Declarative Conversion Analysis

**Source:** DHS Program (ICF), DHS-8 Model Man's Questionnaire, Formatting Date 03 Feb 2023, 24 pages
**QML File:** `evaluation/reference-questionnaires/DHS8_Mans_QRE_EN_03Feb2023_DHSQ8.qml`
**Date:** 2026-03-21 (revised)

## Objective

Transform the DHS-8 Model Man's Questionnaire (24-page interviewer-administered paper questionnaire with GOTO-based skip patterns) into a declarative QML representation, then run the Z3-based formal validator to detect structural problems hidden in the imperative version.

## Methodology

1. Full reading of the 24-page PDF across all 8 sections plus introduction/consent
2. Declarative QML conversion with GOTO-to-precondition translation for all skip patterns, CHECK filters, and cross-question routing
3. Formal validation using the Askalot Z3 QML validator at Level 2
4. Cross-referencing validator findings against PDF page numbers and question IDs
## Survey Architecture Overview

The DHS-8 Man's Questionnaire is a model interviewer-administered questionnaire for the Demographic and Health Surveys Program. It covers male respondents aged 15-59 and uses paper-based GOTO routing with CHECK filters -- interviewer instructions that evaluate prior responses to determine which question to ask next.

| Section | Title | Questions | Key Skip Logic |
|---------|-------|-----------|----------------|
| Intro | Introduction and Consent | Consent gate | Non-consent terminates |
| 1 | Respondent's Background | 101-131 | Residence duration gates migration questions; education level gates literacy test; mobile ownership gates smartphone; internet use cascades |
| 2 | Reproduction | 201-219 | Fathered children gates child counts; living children gates youngest child details; youngest child age 0-2 gates antenatal/birth questions |
| 3 | Contraception | 301-307 | Knowledge of 14 methods (all asked); fertile period awareness gates timing question |
| 4 | Marriage and Sexual Activity | 401-429 | Marital status branches (currently married/formerly married/never married); sexual experience gates partner history; Q415 years-ago skip to Q429; condom use cascades through 3 partners |
| 5 | Fertility Preferences | 501-515 | 3-way gate: currently married + not sterilized + one wife vs. multiple wives; pregnancy status branches wanting-more vs. timing questions |
| 6 | Employment and Gender Roles | 601-619 | Work status cascade (7 days -> absent -> 12 months); currently married gates household decision questions; ownership gates title deed questions |
| 7 | HIV/AIDS | 700-736 | Heard of HIV gates knowledge questions; age 15-24 gates youth HIV knowledge; HIV testing cascades to results/ARVs; sexual experience gates STI questions |
| 8 | Other Health Issues | 801-819 | Circumcision type cascades; smoking status branches daily/weekly product counts; smokeless tobacco parallel cascade; alcohol ever-use gates consumption |

## Validator Results

### Summary

| Metric | Value |
|--------|-------|
| Items | 228 |
| Blocks | 9 |
| Preconditions | 226 |
| Postconditions | 0 |
| Variables | 63 |
| Dependencies | 430 |
| Cycles | **0** |
| Structural Validity | `true` |
| Global Status | **SAT** |
| Issues | **0** |

### Z3 Item Classifications

| Classification | Count |
|---------------|-------|
| Precondition ALWAYS | 2 |
| Precondition CONDITIONAL | 226 |
| Precondition NEVER | 0 |
| Postcondition NONE | 228 |
| Postcondition CONSTRAINING | 0 |

**No items are unreachable.** All 228 items have at least one valid path. The 2 ALWAYS items are the introduction and consent question (asked unconditionally). The 226 CONDITIONAL items inherit the consent block precondition (`q_consent.outcome == 1`) — every post-consent item is gated by the respondent's agreement to participate. Within the consent-gated blocks, items are further conditioned by marital status, sexual experience, fatherhood, circumcision status, smoking behavior, and other classification variables.

## Cross-Check Fixes (QML Authoring Errors)

These are errors introduced during the QML conversion that were discovered by cross-checking the QML against the question inventory and PDF. They have been corrected.

| # | Item(s) | Error | Fix | PDF Reference |
|---|---------|-------|-----|---------------|
| 1 | Q804 | Precondition included `trad_circumcised == 0`, preventing Q804 from being asked if respondent was traditionally circumcised. The PDF allows both traditionally and medically circumcised men to answer Q804 (age at circumcision). | Removed `trad_circumcised == 0` from precondition. Q804 now only requires `circumcised_yes == 1`. | Q802 p21: Yes→Q803; Q803→Q804; Q802 No→Q804. Both paths lead to Q804. |
| 2 | Q713 | Missing `heard_hiv == 1` precondition. Q713 (reduce risk by having one uninfected partner) is in the HIV knowledge section, which should only be asked if respondent has heard of HIV (Q701=Yes). The b_hiv block precondition only had `consent == 1`. | Added `heard_hiv == 1` to Q713's precondition. | Q701 p16: No→Q729 (skip entire HIV knowledge section) |

## Problems Exposed by Declarative Conversion

### P1: Dependency Cycle Between Fertility Preference Questions -- Sterilization Variable Feedback Loop

**PDF evidence:** CHECK 502 (p.13): "MAN NOT STERILIZED OR QUESTION NOT ASKED -> continue; MAN STERILIZED -> 514." Q507 (p.13): response option 5 "RESPONDENT STERILIZED." Q418 (p.10): method list includes "MALE STERILIZATION ... B."

**Problem:** The original questionnaire creates a latent feedback loop:
- CHECK 502 reads the man's sterilization status (derived from Q418, the contraceptive method used at last intercourse)
- Q504 ("Is your wife currently pregnant?") is gated by CHECK 502 (man not sterilized)
- Q504 sets the pregnancy flag that gates Q507
- Q507 ("Would you like to have another child?") includes option 5 "Respondent sterilized" -- which would update the sterilization status

In the declarative conversion, this creates a cycle: `man_sterilized -> q504 -> wife_pregnant -> q507 -> man_sterilized`. The Z3 solver correctly detected this cycle during initial validation.

**Resolution:** The sterilization variable was anchored to its original source (Q418, contraception method used) rather than allowing Q507 to write back to it. Q507's "respondent sterilized" option remains as informational data but does not modify the routing variable. This matches the PDF's intent: CHECK 502 references Q418 specifically, not Q507.

**Impact:** This reveals an ambiguity in the paper questionnaire: if a man was not sterilized at last intercourse (Q418) but reports being sterilized at Q507, the CHECK 502 filter would have already been passed, so the inconsistency would go undetected. In the imperative version, this is masked by sequential execution. The declarative version exposes the temporal dependency.

### P2: CHECK Filters as Implicit Computed Variables -- 12 Checks Require Explicit State

**PDF evidence:** CHECK 105 (p.2), CHECK 116 (p.3), CHECK 118 (p.3), CHECK 209 (p.5), CHECK 212 (p.6), CHECK 213 (p.6), CHECK 214 (p.6), CHECK 405 (p.9), CHECK 407 (p.9), CHECK 409 (p.9), CHECK 502 (p.13), CHECK 508 (p.13)

**Problem:** The DHS questionnaire uses 12 CHECK filters that evaluate prior responses to gate downstream questions. In the paper version, these are interviewer instructions that reference specific question numbers. In QML, each CHECK must be converted into either:
1. A precondition on downstream items (referencing prior outcomes directly), or
2. A classification variable set in a codeBlock (when the CHECK evaluates a complex expression)

For example, CHECK 214 (p.6) determines whether the youngest child is age 0-2 years or 3+ years. This requires a variable (`youngest_child_under3`) set from Q213's codeBlock and read as a precondition on Q215-Q219. The paper version simply says "CHECK 213" with two branches, hiding the fact that this is a computed state variable.

The conversion required 63 global variables to model what the paper questionnaire handles through 12 unnamed CHECK filters and implicit sequential state.

### P3: Three-Way Fertility Preference Branch -- Polygyny Creates Parallel Question Tracks

**PDF evidence:** Q503/CHECK 407 (p.13): "ONE WIFE/PARTNER -> [504-508]; MORE THAN ONE WIFE/PARTNER -> [509-513]." Q507/Q512 have identical structure but different wording. Q508/Q513 similarly parallel.

**Problem:** Section 5 (Fertility Preferences) has a three-way branching structure based on:
1. Currently married/in union vs. not (CHECK 501, from Q401)
2. Man sterilized vs. not (CHECK 502, from Q418)
3. One wife vs. multiple wives (CHECK 503, from Q405/Q407)

This creates parallel question tracks: Q504-Q508 for monogamous men and Q509-Q513 for polygynous men. The questions are semantically identical but with different wording ("your wife/partner" vs. "your wives or partners"). In QML, this requires separate items with mutually exclusive preconditions (`one_wife == 1` vs. `one_wife == 0`), doubling the item count for this section.

The PDF handles this with a visual split on the page (two columns), but the routing logic is identical. A more compact QML representation would use a single question track with dynamic text substitution, but QML's static item titles cannot vary at runtime.

### P4: Multi-Partner Sexual History -- Cascading Skip Pattern Across Three Partners

**PDF evidence:** Q422-Q423 (p.11): first partner relationship + "had another partner?" Q424-Q426 (pp.11-12): second partner details + "had another partner?" Q427-Q428 (p.12): third partner details.

**Problem:** The DHS questionnaire asks about the respondent's last three sexual partners in sequence, with each partner's details gated by the previous "had another partner?" question. This creates a chain dependency:
```
has_had_sex -> recent_sex -> q422/q423 -> had_second_partner -> q424/q425/q426 -> had_third_partner -> q427/q428
```

The questionnaire arbitrarily caps at three partners, even though Q429 asks for total lifetime partners (which can be up to 95+). This is a deliberate design trade-off between data richness and interview burden, but it means the detailed partner-level data (relationship type, condom use) is only collected for the three most recent partners.

In the declarative version, this cascading structure maps cleanly to chain preconditions. The Q415 skip (years ago -> 429) is modeled with a `recent_sex` variable that gates the partner detail questions.

### P5: Tobacco Use Section -- Parallel Daily/Weekly Product Grids With Three-Way Split

**PDF evidence:** Q806 (p.21): current smoking status (every day/some days/not at all). Q809 (p.21): daily product counts for every-day smokers. Q807 (p.21): past daily smoking for some-days smokers. Q810 (p.22): weekly product counts for some-days smokers who smoked daily in the past. Q808 (p.21-22): past smoking for those who didn't smoke daily.

**Problem:** The tobacco section has a three-way split:
1. Currently smokes every day (Q806=1) -> Q809 (daily product counts) -> Q811
2. Currently smokes some days (Q806=2) -> Q807 -> if past daily (Q807=1) -> Q810 (weekly counts) -> Q811; if not past daily (Q807=2) -> Q808 -> Q811
3. Does not currently smoke (Q806=3) -> Q808 (past smoking history) -> Q811

The QML separates every-day (`smokes_every_day`) from some-days (`smokes_some_days`) smoking paths with distinct preconditions. The same pattern applies to smokeless tobacco (Q811-Q813): Q812 uses `uses_smokeless_daily` for daily users only, Q813 uses `uses_smokeless_some_days` for some-days users.

### P6: Absent Postconditions -- No Cross-Question Validation in 228 Items

**PDF evidence:** Q208 (p.5): "SUM ANSWERS TO 203, 205, AND 207, AND ENTER TOTAL." Q111 (p.3): "COMPARE AND CORRECT 105 AND/OR 106 IF INCONSISTENT."

**Problem:** The DHS questionnaire contains two explicit cross-check instructions:
1. Q208 requires the interviewer to sum children from Q203, Q205, and Q207
2. Q111 requires comparing age against residence duration (Q105) and move date (Q106)

Neither of these can be enforced as QML postconditions because:
- Q208's sum spans questions that may not have been asked (Q203 requires Q202=Yes; Q205 requires Q204=Yes; Q207 requires Q206=Yes). A postcondition cannot reference outcomes of items that may have been skipped.
- Q111's consistency check involves a computed comparison between age, years of residence, and move year -- all of which have "don't know" codes (98, 9998) that would need special handling.

The result is that the QML has **zero postconditions** across all 228 items, meaning no formal validation of response consistency. The paper questionnaire relies entirely on interviewer judgment for data quality checks.

### P7: "Don't Know" as a Regular Response Code Conflated With Numeric Ranges

**PDF evidence:** Q110 (p.3): "DON'T KNOW MONTH ... 98" and "DON'T KNOW YEAR ... 9998." Q104 (p.2): "ALWAYS ... 95, VISITOR ... 96." Q803 (p.21): "DURING CHILDHOOD (<5 YEARS) ... 95, DON'T KNOW ... 98."

**Problem:** The DHS questionnaire uses numeric fields that overload the value space. For example, Q104 (years of residence) uses 0-94 for actual years but reserves 95 for "always" and 96 for "visitor." Q803 (age at circumcision) uses 0-94 for actual age but reserves 95 for "during childhood" and 98 for "don't know."

In QML, these are modeled as Editbox controls with min/max ranges that include the sentinel values. This means the Z3 solver treats "Don't know" (98) as a valid numeric response, which inflates the set of satisfying assignments. For example, Q803 with `min: 0, max: 98` allows outcome=98, which is semantically different from "age 98" but indistinguishable to the solver.

A more rigorous encoding would use separate Radio options for sentinel values and an Editbox for the numeric range, but this would double the number of items for each such question.

### P8: Country-Specific Adaptation Placeholders -- 15+ Questions Have Placeholder Labels

**PDF evidence:** Q102 (p.2): "[PROVINCE/REGION/STATE]" with codes 01-03, 96. Q130 (p.4): "[RELIGION]" with codes 01-03, 96. Q131 (p.4): "[ETHNIC GROUP]" with codes 01-03, 96. Q818 (p.23): insurance types "to be adapted to the country environment."

**Problem:** The DHS-8 is a model questionnaire designed for country-specific adaptation. At least 15 questions use placeholder labels like "[PROVINCE/REGION/STATE]", "[RELIGION]", "[ETHNIC GROUP]", and "[GRADE/FORM/YEAR]". The coding categories shown (01, 02, 03, 96) are templates, not final values.

In the QML conversion, these placeholders are preserved as generic labels ("Province/Region/State 1", etc.). This means the QML is not a deployable survey but rather a structural template. Any real deployment would require replacing these placeholders with country-specific values, which would change the number of options and potentially affect skip logic (e.g., if a country adds more provinces, the Radio control might need to become a Dropdown).

## Impact Assessment

| Category | Imperative (PDF) | Declarative (QML) |
|----------|------------------|-------------------|
| **CHECK filters** | 12 interviewer instructions referencing question numbers | 63 explicit variables with codeBlock assignments |
| **Sterilization routing** | CHECK 502 implicitly references Q418 | Explicit variable anchored to Q418; cycle exposed and resolved |
| **Polygyny branching** | Visual column split on page | Parallel items with mutually exclusive preconditions |
| **Partner cascading** | Sequential GOTO chain capped at 3, years-ago skip | Chain preconditions with `recent_sex` gate; cap-at-3 preserved |
| **Tobacco routing** | Three-way split (daily/some-days/none) with parallel grids | Separate `smokes_every_day`/`smokes_some_days` variables; mutually exclusive paths |
| **Cross-checks** | Interviewer instructions ("COMPARE AND CORRECT") | No postconditions -- validation gap |
| **Sentinel values** | Overloaded numeric fields (95=always, 98=DK) | Editbox ranges include sentinels; solver treats as valid numerics |
| **Country adaptation** | Bracket placeholders ([RELIGION], etc.) | Generic placeholder labels; not deployable without customization |

## Conclusion

The Z3 QML validator found **no structural defects** (no cycles, no unreachable items, no infeasible postconditions). All 228 items are reachable, and the global formula is satisfiable (SAT).

The declarative conversion exposed **8 categories of design observations** in the source questionnaire:
1. **Sterilization variable feedback loop** (P1)
2. **Implicit CHECK filter state** (P2) -- 12 CHECK instructions required 63 explicit variables
3. **Polygyny parallel tracks** (P3) -- doubled item count for fertility preferences
4. **Partner cascade cap** (P4) -- three-partner limit with years-ago skip
5. **Tobacco routing complexity** (P5) -- three-way daily/some-days/none split
6. **Zero postconditions** (P6) -- no formal data quality validation
7. **Sentinel value conflation** (P7) -- numeric "Don't know" codes
8. **Country adaptation placeholders** (P8) -- 15+ template questions
