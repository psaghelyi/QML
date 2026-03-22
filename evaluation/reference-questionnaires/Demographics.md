# CPS Basic Demographic Items Booklet: Declarative Conversion Analysis

**Source:** U.S. Census Bureau, Current Population Survey (CPS), Basic Demographic Items Booklet, 14 pages
**QML File:** `evaluation/reference-questionnaires/Demographics.qml`
**Date:** 2026-03-19

## Objective

Transform the CPS Basic Demographic Items booklet (14 pages, ~40 field definitions, implicit CATI routing) into a declarative QML representation, then run the Z3-based formal validator to detect structural problems hidden in the imperative version.

## Methodology

1. Full reading of the 14-page PDF booklet
2. Declarative QML conversion with inferred skip logic (the booklet contains no explicit GOTO instructions)
3. Formal validation using the Askalot Z3 QML validator at Level 2
4. Cross-referencing validator findings against PDF field definitions

## Survey Architecture Overview

The CPS Demographics booklet is a **flat field enumeration** -- unlike CATI questionnaires with explicit GOTO instructions, this booklet lists field definitions (variable name, question text, response codes) with no explicit routing logic. All skip patterns are implicit in the CATI system.

**Section structure:**

| Block | Fields | Purpose |
|-------|--------|---------|
| Person Status | PERSTAT | Roster maintenance (deceased, moved, URE) |
| Household Roster | FNAME through OWNREN1 | Enumerate all persons, missed-person probes, tenure |
| Respondent ID | HHRESP, HHRESP_VERIFY | Identify who is answering |
| Relationship | S_RRP through PARENT2 | Relationship to reference person, subfamily, parents |
| Birth/Age | BIRTHM through AGE2 | Date of birth, age verification |
| Marital Status | PREMARTL through COHAB | Marital status, spouse/partner identification |
| Military | AFEVER through AFNOW | Veteran status, service periods |
| Education | EDUCA through CERT2 | Attainment, diploma type, certifications |
| Hispanic Origin | HSPNON through OROTSS | Hispanic ethnicity, specific origin group |
| Race | RACE through RACEOS | Multi-race selection, Asian/PI/Other detail |

The booklet is designed to be administered **per person in a household roster loop**. Each field is asked for each household member. The loop mechanism is entirely external to the booklet.

## Validator Results

### Summary

| Metric | Value |
|--------|-------|
| Items | 51 |
| Blocks | 10 |
| Preconditions | 23 |
| Postconditions | 0 |
| Variables | 14 |
| Dependencies | 22 |
| Cycles | **0** |
| Connected Components | 31 |
| Structural Validity | `true` |
| Global Status | **SAT** |
| Issues | **0** |

### Z3 Item Classifications

| Classification | Count |
|---------------|-------|
| Precondition ALWAYS | 28 |
| Precondition CONDITIONAL | 23 |
| Precondition NEVER | 0 |
| Postcondition NONE | 51 |

**No items are unreachable.** All 51 items have at least one valid path. The 28 ALWAYS items are fields with no skip logic (asked for every person). The 23 CONDITIONAL items are gated by responses to prior questions or computed variables.

## Problems Exposed by Declarative Conversion

### P1: Entirely Implicit Skip Logic -- No Routing Documentation

**PDF evidence:** The entire 14-page booklet contains **zero** explicit routing instructions -- no "Go to," "Skip to," or "If...then" directives. Fields are listed sequentially with only response codes.

**Problem:** All skip logic is embedded in the CATI system and undocumented in the booklet itself. For example:
- SPOUSE (p.9) should only be asked if MARITL = 1 or 2 (married), but the PDF shows no such condition
- COHAB (p.9) should only be asked if NOT married, but the PDF shows no gating
- AFWHEN/AFNOW (p.10) should only be asked if AFEVER = Yes, but the PDF lists them unconditionally
- DIPGED (p.11) should only be asked if EDUCA = 39, but no condition is shown

**In the declarative version:** The QML had to **infer** all 23 preconditions from survey methodology knowledge and field semantics. These inferred conditions include:
- `q_cnt2bg` visible when `q_nros2b.outcome == 1` (more unlisted persons)
- `q_spouse` visible when `q_maritl.outcome in [1, 2]` (married)
- `q_cohab` visible when `q_maritl.outcome != 1` and `q_maritl.outcome != 2` (not married)
- `q_afwhen`/`q_afnow` visible when `is_veteran == 1` (AFEVER = Yes)
- `q_dipged` visible when `has_ged == 1` (EDUCA = 39)

**Impact:** Any implementer working from this PDF alone would have to guess the routing logic or consult external CATI specifications. The declarative model makes all inferred conditions explicit and verifiable.

### P2: Roster Loop Abstraction -- Person-Level Iteration Not Representable

**PDF evidence:** FNAME (p.1): "What are the names of all persons living or staying here? / What is the next person?" with "Enter 999 if no more persons."

**Problem:** The booklet is designed for a household roster loop where every field from FNAME through RACEOS is asked for each household member. This iteration mechanism is:
1. Controlled by the CATI system (not documented in the booklet)
2. Not representable in a single QML pass (QML represents one respondent's path)
3. Dependent on an external person count variable

**In the declarative version:** The QML represents a **single person's pass** through the demographics. The roster enumeration (FNAME loop), missed-person probes (MCHILD, MAWAY, MLODGE, MELSE), and person-count (NROS2B/CNT2BG) are included as items but without the loop structure. This means the QML is semantically a **template** that would need to be instantiated per household member.

### P3: Multi-Select Encoding Transformation -- AFWHEN and RACE

**PDF evidence:** AFWHEN (p.10) uses sequential codes 1-9 for military service periods with "Enter all that apply, separate with commas. Mark up to 4 that apply." RACE (p.13) uses codes 1-6 with "Enter all that apply, separate with commas."

**Problem:** The PDF uses sequential integer codes for multi-select fields, relying on comma-separated entry in the CATI system. The QML must transform these to power-of-2 bitwise encoding for the Checkbox control:

| Field | PDF Codes | QML Checkbox Codes |
|-------|----------|--------------------|
| AFWHEN | 1-9 sequential | 1, 2, 4, 8, 16, 32, 64, 128, 256 |
| RACE | 1-6 sequential | 1, 2, 4, 8, 16, 32 |
| RACEAS | 1-7 sequential | 1, 2, 4, 8, 16, 32, 64 |
| RACEPI | 1-4 sequential | 1, 2, 4, 8 |

This encoding change means that downstream analysis code referencing the original sequential codes would break. The QML's `codeBlock` for RACE uses bitwise arithmetic (`q_race.outcome % 16 >= 8`) to decode selections, which is correct but introduces complexity that the original sequential encoding did not have.

### P4: Race Sub-Category Gating via Bitwise Arithmetic -- Fragile Pattern

**PDF evidence:** RACEAS (p.13) is asked if RACE includes "Asian" (code 4). RACEPI (p.14) is asked if RACE includes "Native Hawaiian or Other Pacific Islander" (code 5). S_RACEOT/RACEOS (p.14) are asked if RACE includes "Other" (code 6).

**Problem:** The QML decodes race selections using bitwise arithmetic in a `codeBlock`:
```python
if q_race.outcome % 16 >= 8:
    race_asian = 1
if q_race.outcome % 32 >= 16:
    race_pi = 1
if q_race.outcome % 64 >= 32:
    race_other = 1
```

This is mathematically correct for power-of-2 encoded checkboxes, but it creates a **fragile coupling** between the checkbox encoding scheme and the precondition variables. If the checkbox encoding ever changes (e.g., adding a new race category), the bitwise masks must be updated in lockstep.

The original PDF avoids this by using simple sequential codes where "RACE includes 4" is a trivial check. The declarative model's choice of Checkbox control forces the bitwise encoding, creating an artifact of the representation that doesn't exist in the source.

### P5: S_OROTSP and OROTSS Redundancy

**PDF evidence:** S_OROTSP (p.12): "What is the name of (your/his/her) other Spanish, Hispanic, or Latino group?" OROTSS (p.13): "Specify 'Other' Spanish, Hispanic, or Latino group."

**Problem:** Both fields serve the same purpose -- capturing the "other" Hispanic origin when ORISPN = 7. The PDF lists them as separate fields, and the QML creates two separate items with identical preconditions (`is_hispanic == 1` AND `hispanic_other == 1`). In practice, S_OROTSP appears to be the interviewer-facing prompt and OROTSS the data entry field, but the distinction is unclear from the PDF alone.

**In the declarative version:** Both items are reachable (CONDITIONAL) and have identical gating, making the redundancy explicit.

### P6: Subfamily Chain Dependency -- Three-Variable Gate

**PDF evidence:** S_SUBFAM (p.5) is asked for non-relatives. SUBFAM_WHO (p.5) is asked if the person is related to someone else in the household.

**Problem:** The QML creates a three-step dependency chain:
1. `q_s_rrp.codeBlock` sets `is_nonrelative = 1` if relationship code is 52, 53, or 54
2. `q_s_subfam` requires `is_nonrelative == 1`; its `codeBlock` sets `is_subfam = 1` if answer is Yes
3. `q_subfam_who` requires BOTH `is_nonrelative == 1` AND `is_subfam == 1`

The Z3 solver confirms this chain is satisfiable (both items are CONDITIONAL, not NEVER). However, the `is_subfam` variable can only be set to 1 when `is_nonrelative == 1` is already true, making the `is_nonrelative == 1` precondition on `q_subfam_who` technically redundant -- if `is_subfam == 1`, then `is_nonrelative == 1` must already hold. The redundant precondition doesn't cause harm but reveals that the QML encodes defensive conditions beyond what's strictly necessary.

### P7: PAR1/PAR2 Parent Identification Without Age Gating

**PDF evidence:** PAR1 (p.6): "Is (name's/your) parent a member of this household?" PAR2 (p.7): "Is (name's/your) other parent a member of this household?"

**Problem:** The parent identification questions (PAR1, PAR2) are asked for all household members regardless of age. A 75-year-old respondent would be asked "Is your parent a member of this household?" -- technically valid (elderly parents can live with adult children) but semantically unlikely for most respondents. The CATI system may have had age-based optimizations (e.g., skip PAR1 for persons over 60) that are not documented in the booklet.

**In the declarative version:** PAR1 and PAR2 are ALWAYS items (no preconditions), matching the PDF's lack of any age gate. This may represent a real design choice (the CPS captures multigenerational households) or a documentation gap.

## Structural Observations

### No Dependency Cycles

The Demographics booklet has **no dependency cycles**. This is expected for a flat field enumeration where:
1. All routing is forward-only (no field references a later field)
2. Variables are set once and read later (no feedback loops)
3. There is no state machine or PATH variable

### High ALWAYS-to-CONDITIONAL Ratio (28:23)

Over half the items (28 of 51) are ALWAYS -- asked for every person. This reflects the booklet's nature as a universal demographics collection instrument. The 23 CONDITIONAL items are concentrated in:
- Education details (DIPGED, HGCOMP, CYC -- gated by education level)
- Race/ethnicity sub-categories (RACEAS, RACEPI, RACEOS -- gated by race selection)
- Relationship details (S_SUBFAM, SUBFAM_WHO -- gated by non-relative status)
- Military details (AFWHEN, AFNOW -- gated by veteran status)

### 31 Connected Components

The 31 connected components in a 51-item questionnaire reflect high modularity. Each thematic section (military, education, ethnicity, race) operates independently with connections only through the items' own response values or computed variables. No section depends on another section's state.

## Impact Assessment

| Category | Imperative (PDF) | Declarative (QML) |
|----------|------------------|-------------------|
| **Skip logic** | Entirely implicit in CATI system | Explicit preconditions -- reveals 23 inferred conditions |
| **Roster loop** | External CATI iteration | Single-person template -- reveals non-representable loop |
| **Multi-select encoding** | Sequential codes + comma entry | Bitwise Checkbox codes -- requires arithmetic decoding |
| **Race sub-categories** | Simple "if includes code X" | Bitwise mask arithmetic -- fragile coupling to encoding |
| **Field redundancy** | Two fields for same purpose (S_OROTSP/OROTSS) | Explicit duplication with identical preconditions |
| **Parent questions** | No age gate documented | ALWAYS classification confirms no age restriction |

## Conclusion

The Z3 QML validator found **no structural defects** (no cycles, no unreachable items, no infeasible postconditions) in the CPS Demographics booklet conversion. All 51 items are reachable under at least one valid assignment.

The declarative conversion exposed **7 categories of design observations**:

1. **Entirely implicit routing** -- zero explicit skip instructions in the 14-page booklet; all 23 preconditions were inferred from field semantics
2. **Roster loop abstraction** -- the per-person iteration mechanism is external and not representable in a single QML pass
3. **Multi-select encoding transformation** -- sequential codes must be converted to power-of-2 bitwise encoding, changing the data representation
4. **Fragile bitwise race decoding** -- checkbox encoding forces arithmetic masks for race sub-category gating
5. **Field redundancy** -- S_OROTSP and OROTSS have identical preconditions and overlapping purpose
6. **Defensive precondition chains** -- subfamily routing encodes a redundant three-variable gate
7. **Missing age gates on parent identification** -- PAR1/PAR2 asked universally despite low relevance for elderly respondents

The CPS Demographics booklet is an unusual case: it is a **documentation-light field enumeration** where all intelligence resides in the CATI system. The declarative conversion's primary value is making the implicit routing explicit, enabling formal verification that the inferred conditions are internally consistent.
