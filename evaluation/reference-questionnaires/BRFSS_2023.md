# 2023 BRFSS Questionnaire: Declarative Conversion Analysis

**Source:** CDC, Behavioral Risk Factor Surveillance System (BRFSS), 2023 Questionnaire, 127 pages
**QML File:** `evaluation/reference-questionnaires/BRFSS_2023.qml`
**Date:** 2026-03-19

## Objective

Transform the 2023 BRFSS CATI questionnaire (127 pages, 15 core sections + 32 optional modules, GOTO-based branching) into a declarative QML representation, then run the Z3-based formal validator to detect structural problems hidden in the imperative version.

## Methodology

1. Full reading of the 127-page PDF across all core sections and optional modules
2. Declarative QML conversion covering all sections with GOTO-to-precondition translation
3. Formal validation using the Askalot Z3 QML validator at Level 2
4. Cross-referencing validator findings against PDF page numbers and CATI notes

## Survey Architecture Overview

The BRFSS is the world's largest continuously conducted health survey, administered via telephone (landline and cell phone). It has a two-layer architecture:

**Core component** (15 sections, asked of all respondents):
- Health Status, Healthy Days, Health Care Access, Exercise
- Hypertension Awareness, Cholesterol Awareness, Chronic Health Conditions
- Demographics, Disability, Falls, Tobacco Use, Alcohol Consumption
- Immunization, H.I.V./AIDS, Seat Belt / Drinking and Driving
- Emerging Core: Long-term COVID Effects

**Optional modules** (32 modules, state-selected):
- Modules 1-32 covering: Prediabetes, Diabetes Extended, Arthritis, Cancer Screening (Lung, Breast/Cervical, Prostate, Colorectal), Cancer Survivorship (3 modules), Indoor Tanning, Sun Exposure, Cognitive Decline, Caregiver, Tobacco Cessation, Firearm Safety, Industry/Occupation, Heart Attack/Stroke, Aspirin for CVD, Sex at Birth, SOGI, Marijuana Use, ACE (Adverse Childhood Experiences), Vaccination modules (Flu, HPV, Tdap, COVID), Social Determinants, Reactions to Race, Random Child Selection, Childhood Asthma

**Screening/introduction layer** (LL01-LL10 landline, CP01-CP12 cell phone): eligibility screening with multiple TERMINATE paths.

## Validator Results

### Summary

| Metric | Value |
|--------|-------|
| Items | 181 |
| Blocks | 35 |
| Preconditions | 76 |
| Postconditions | 1 |
| Variables | 21 |
| Dependencies | 88 |
| Cycles | **0** |
| Connected Components | 104 |
| Structural Validity | `true` |
| Global Status | **SAT** |
| Issues | **0** |

### Z3 Item Classifications

| Classification | Count |
|---------------|-------|
| Precondition ALWAYS | 105 |
| Precondition CONDITIONAL | 76 |
| Precondition NEVER | 0 |
| Postcondition NONE | 180 |
| Postcondition CONSTRAINING | 1 (diabetes diagnosis age) |

**No items are unreachable.** All 181 items have at least one valid path. The 105 ALWAYS items are core questions asked of all respondents (health status, healthy days, chronic conditions, demographics). The 76 CONDITIONAL items are gated by block-level preconditions (optional module membership) and item-level conditions (chronic condition flags, smoking status, alcohol use, and other computed variables).

## Problems Exposed by Declarative Conversion

### P1: Screening/Eligibility Layer Entirely Omitted -- 23 Questions Lost

**PDF evidence:** Landline Introduction LL01-LL10 (pp.5-9), Cell Phone Introduction CP01-CP12 (pp.11-16)

**Problem:** The BRFSS has two parallel eligibility screening sequences:
- **Landline** (LL01-LL10): verifies phone number, private residence, college housing, state residency, not a cell phone, age 18+, random adult selection
- **Cell phone** (CP01-CP12): verifies cell phone, safe to talk, state residency, age 18+, driving check

These sequences contain 6+ TERMINATE paths each (wrong number, business phone, non-private residence, out of state, under 18, etc.). The QML omits this entire layer because:
1. QML represents a survey for a **qualified respondent**, not the screening process
2. TERMINATE is not a QML concept -- it requires ending the survey entirely
3. The dual-path (landline vs cell) structure would require a mode variable to select which introduction to use

**Impact:** 23 screening questions and their complex GOTO logic are not representable in the declarative model. The random adult selection algorithm (LL07-LL08: "how many adults 18+ in household" then birthday-based selection) is a procedural operation that cannot be encoded as declarative preconditions.

### P2: Age-Gated Sections Without Computed Age Variable

**PDF evidence:** Falls section header (p.38): "Skip Section if CDEM.01 (age), coded 18-44." Immunization CIMM.04 (p.42): "If CDEM.01(age) <50 Go to next section."

**Problem:** Multiple sections and individual questions in the BRFSS are gated by the respondent's age:
- Falls (Core 10): skip entire section if age 18-44
- Shingles vaccine (CIMM.04): skip if age < 50
- Various optional modules have age eligibility

The QML declares `age_years = 0` in `codeInit` but relies on the Demographics section (CDEM.01) to set it. However, age is collected as a computed variable in the CATI system (calculated from date of birth), not as a direct question response. The QML's age-dependent preconditions may reference `age_years` before it's been set, creating a temporal dependency that's implicit in CATI (where age is a system variable) but must be explicit in QML.

**In the declarative version:** The Z3 solver treats `age_years` as a free variable initialized to 0. Preconditions like `age_years >= 45` are satisfiable (CONDITIONAL) but only if the Demographics block sets the variable before age-gated blocks execute. The block ordering in the QML matches the PDF section ordering, so this works in practice, but there's no formal guarantee of execution order across blocks.

### P3: Sex-Dependent Question Text -- Binge Drinking Threshold

**PDF evidence:** CALC.03 (p.41): "how many times during the past 30 days did you have [CATI X = 5 for men, X = 4 for women] or more drinks on an occasion?"

**Problem:** The binge drinking question has a **sex-dependent threshold** embedded in the question text. The CATI system inserts "5" for men and "4" for women at runtime. The PDF notes: "states may use sex at birth to determine sex if module is adopted."

This creates three issues:
1. The question text itself changes based on a prior response -- not representable in static QML labels
2. The threshold for what constitutes "binge drinking" differs by sex, affecting data interpretation
3. The reference variable (sex at birth vs gender identity) is state-configurable

**In the declarative version:** The QML uses a single static question text that mentions both thresholds ("5 or more drinks for men or 4 or more drinks for women"). This preserves information content but loses the CATI's ability to personalize the question, potentially reducing respondent comprehension.

### P4: Optional Module Selection -- State-Level Configuration Not Representable

**PDF evidence:** Closing Statement (p.48): "Read if no optional modules follow, otherwise continue to optional modules." Module descriptions note state selection.

**Problem:** Each U.S. state selects a subset of the 32 optional modules to administer. This creates a combinatorial configuration space: 2^32 possible module combinations (over 4 billion). The BRFSS questionnaire PDF lists all modules, but any given respondent only receives their state's selected subset.

**In the declarative version:** The QML includes all 32 optional modules as separate blocks. Without module selection flags (analogous to the CCHS `do_xxx` pattern), all optional modules appear as ALWAYS blocks -- meaning the QML implies every respondent gets all 32 modules, which never happens in practice.

**Correct encoding would require:** 32 boolean `do_module_X` variables in `codeInit`, with each optional block's items having `precondition: do_module_X == 1`. The current QML's omission of module selection flags means the validator cannot verify module-level reachability constraints.

### P5: Cross-Module Variable Dependencies -- Disease Flag Propagation

**PDF evidence:** Core Section 7 (p.28) sets diabetes/asthma/cancer/COPD/arthritis/depression status. Optional Modules 2-3 (pp.52-56) reference these conditions for extended questions.

**Problem:** The QML correctly uses 12 disease flag variables (`has_diabetes`, `has_asthma`, `has_skin_cancer`, `has_other_cancer`, `has_copd`, `has_arthritis`, `has_depression`, `has_kidney_disease`, `has_heart_disease`, `has_stroke`, `drinks_alcohol`, `currently_smoke`) set in core sections and referenced in optional modules. This creates a long dependency chain:

```
Core chronic conditions → disease flags → optional module preconditions
```

If a respondent answers "Don't know/Not sure" (code 7) or "Refused" (code 9) to a chronic condition question, the disease flag stays at 0 (no disease). This means **uncertain or refused responses are treated identically to negative responses** for routing purposes. A respondent who refuses to disclose their diabetes status will never see the Diabetes Extended Module.

**In the declarative version:** The QML's codeBlock only sets flags for affirmative responses (outcome == 1). The Z3 solver confirms this is satisfiable, but the semantic issue -- that "Don't know" and "Refused" are treated as "No" for routing -- is a design decision inherited from the CATI system, now made explicit.

### P6: E-Cigarette Question Restructuring -- Combined Question Split

**PDF evidence:** CTOB.04 (p.39): Combined 4-category question: "1 Never used e-cigarettes in your entire life / 2 Use them every day / 3 Use them some days / 4 Not at all (right now)"

**Problem:** The PDF's CTOB.04 combines ever-use and current-use into a single 4-category question. The QML splits this into two questions: `q_ecigaret` (ever used?) and `q_ecignow` (currently use?), with the second gated by the first.

This restructuring changes the question semantics:
- PDF: a single question captures both lifetime and current use
- QML: two questions create a filter-funnel pattern

The split is **arguably better** (simpler per-question logic) but means the QML is not a faithful 1:1 translation of the PDF. Response code 4 in the PDF ("Not at all right now") maps to q_ecigaret=Yes + q_ecignow="Not at all" in the QML, but response code 1 ("Never used") maps to q_ecigaret=No with q_ecignow never asked.

### P7: "Don't Know / Not Sure" and "Refused" as Regular Response Codes

**PDF evidence:** Nearly every question includes codes 7 (Don't know / Not sure) and 9 (Refused). Some questions use 77/99 or 777/999 for multi-digit fields.

**Problem:** The BRFSS uniquely encodes "Don't know" and "Refused" as **response categories** rather than as system-level metadata. This means:
1. Every Radio control has 2 extra options (7 and 9) that are not substantive responses
2. Routing logic must explicitly handle these codes (e.g., CTOB.01 "If No/DK/Refused → Go to CTOB.03")
3. The diabetes age postcondition (`q_diabage.outcome >= 1 AND q_diabage.outcome <= 97`) must carve out codes 98 (DK) and 99 (Refused) from the valid range

**In the declarative version:** The QML preserves these codes as regular option labels, which is faithful to the PDF but means the Z3 solver treats "Refused" as a valid path through the survey. This is technically correct (the survey continues after a refusal) but inflates the number of valid paths the solver must consider.

## Structural Observations

### No Dependency Cycles

The BRFSS has **no dependency cycles**. All variable flow is forward-only: core sections set disease flags, and optional modules consume them. There is no feedback where an optional module's response changes a core variable.

### High ALWAYS-to-CONDITIONAL Ratio (105:76)

Over half of items (105 of 181) are ALWAYS -- asked of every respondent. This reflects the BRFSS's design as a broad surveillance instrument where most questions are universal. The 76 CONDITIONAL items are concentrated in:
- Disease-specific follow-ups (diabetes insulin/monitoring, asthma current status)
- Tobacco use cascades (current smoking → quit attempts; ever e-cig → current e-cig)
- Alcohol consumption details (any drinking → frequency/amount/binge)
- Immunization follow-ups (flu shot → date; HIV test → date)

### Single Postcondition

Only one item (`q_diabage`) has a postcondition -- validating that diabetes diagnosis age is between 1 and 97. This is the only numeric range validation in the entire questionnaire. The BRFSS generally relies on CATI system validation rather than questionnaire-level constraints, which means the QML has minimal self-validation capability.

### 104 Connected Components

The 104 connected components reflect the BRFSS's flat architecture -- many independent questions with minimal inter-question dependencies create a highly disconnected dependency graph. Most conditional chains are short (1-2 items gated by a single flag).

## Impact Assessment

| Category | Imperative (PDF) | Declarative (QML) |
|----------|------------------|-------------------|
| **Screening logic** | 23 eligibility questions with TERMINATE paths | Omitted -- not representable as survey flow |
| **Age gating** | CATI system variable, referenced inline | Explicit `age_years` variable -- reveals temporal dependency |
| **Sex-dependent text** | CATI inserts X=5/4 at runtime | Static combined text -- loses personalization |
| **Module selection** | State-level configuration, external | All modules included as ALWAYS -- missing selection flags |
| **Disease flags** | Implicit CATI variable propagation | Explicit codeBlock chains -- reveals DK/Refused = No equivalence |
| **DK/Refused codes** | Standard CATI metadata | Regular response options -- inflates valid path count |

## Conclusion

The Z3 QML validator found **no structural defects** (no cycles, no unreachable items, no infeasible postconditions) in the BRFSS 2023 conversion. All 181 items are reachable, and the single postcondition (diabetes age range) is CONSTRAINING (non-trivial but satisfiable).

The declarative conversion exposed **7 categories of design observations**:

1. **Screening layer omission** -- 23 eligibility questions with TERMINATE paths cannot be represented in declarative QML
2. **Age variable temporal dependency** -- age-gated sections rely on Demographics block executing first, with no formal ordering guarantee
3. **Sex-dependent question text** -- binge drinking threshold varies by sex, requiring runtime text substitution not available in QML
4. **Missing module selection flags** -- 32 optional modules appear unconditionally; state-level configuration not encoded
5. **Disease flag propagation semantics** -- "Don't know" and "Refused" silently treated as "No" for routing, excluding uncertain respondents from follow-up modules
6. **Question restructuring** -- e-cigarette combined question split into two, changing response structure
7. **Pervasive DK/Refused codes** -- encoded as regular response options rather than metadata, affecting solver path analysis

The BRFSS's architecture is fundamentally different from modular questionnaires like the CCHS. It is a **flat, broad surveillance instrument** where most questions are universal and conditional routing is limited to disease-specific follow-ups. The main structural complexity lies not in within-survey routing but in the dual-channel screening layer (landline vs cell phone) and state-level module selection -- both of which are external to the core questionnaire and not representable in declarative form.
