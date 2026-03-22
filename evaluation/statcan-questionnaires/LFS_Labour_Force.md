# LFS Labour Force Survey: Declarative Conversion Analysis

**Source:** Statistics Canada, Catalogue no. 71-543, Appendix B
**QML File:** `evaluation/statcan-questionnaires/LFS_Labour_Force.qml`
**Date:** 2026-03-21 (revised)

## Objective

Transform the traditional imperative CATI questionnaire (PDF, 20 pages of GOTO-based branching) into a declarative QML representation, then run the Z3-based formal validator to detect structural problems that are hidden in the imperative version.

## Methodology

1. Page-by-page comparison of the PDF flow against the QML preconditions/postconditions
2. Formal validation using the Askalot Z3 QML validator

## Validator Results

### Summary

| Metric | Value |
|--------|-------|
| Items | 83 |
| Blocks | 13 |
| Preconditions | 79 |
| Postconditions | 2 |
| Variables | 10 |
| Dependencies | 585 |
| Cycles | **39** |
| Connected Components | 3 |
| Structural Validity | `false` |
| Z3 Global Satisfiability | `true` (SAT) |
| Block Precondition Items | 68 |
| Z3 Item Classifications | ALWAYS: 4, CONDITIONAL: 79 |

**Note on block-level precondition propagation:** 68 of the 83 items inherit preconditions from their enclosing blocks (112 block-level precondition expressions total). This explains why only 4 items are classified as ALWAYS reachable — the remaining 79 are CONDITIONAL because block-level preconditions gate entire sections (e.g., `b_job_description` requires `q104 == 1`, making all items within it conditional on prior employment).

### Key Finding: Dependency Cycles Detected

The validator found **39 cycle paths** through **1 strongly connected component** of 10 items in the questionnaire. Despite the cycles, Kahn's algorithm computed a valid topological order for all 83/83 items, Z3 classified every item, and the global formula is satisfiable (SAT).

**Strongly connected component** (10 items all linked through the `path` variable):

`q130_reason_absent`, `q131_reason_stopped`, `q132_job_loss_detail`, `q133_expect_return`, `q134_given_return_date`, `q135_recall_indication`, `q136_weeks_on_layoff`, `q170_looked_for_work`, `q174_future_job`, `q175_start_within_4weeks`

All 10 items both **read** `path` in their preconditions and **write** `path` in their codeBlocks (directly or via transitive block-level preconditions), creating a fully connected bidirectional dependency cluster. The 39 reported cycles are the enumeration of all simple cycle paths through this 10-node SCC — they represent a single structural pattern, not 39 independent problems.

**Representative cycles** (from topological sort):
```
Cycle 1:  q130 → q134 → q133 → q132 → q130  (3-hop, through job loss detail)
Cycle 30: q135 → q136 → q135                   (2-hop, layoff classification)
Cycle 39: q174 → q175 → q174                   (2-hop, job search outcome)
```

**The `path` variable state machine:**

| Item | Writes | Reads (precondition) | PDF Reference |
|------|--------|---------------------|---------------|
| `q100` | `path = 1` (employed) or `path = 7` (unable) | — | Q100 p57 |
| `q130` | `path = 2` (temporary layoff) | `path` via block | Q130 p59 |
| `q132` | — | `path != 7` | Q132 p60 |
| `q136` | `path = 3` (layoff classified) | `path` via block | Q136 p60 |
| `q170` | `path = 4` (looked) or `path = 6` (didn't) | `path != 1, != 2, != 7` | Q170 p61 |
| `q174` | `path = 6` (no future job) | `path != 1, != 2, != 7` | Q174 p61 |
| `q175` | `path = 5` or `path = 6` | `path != 1, != 2, != 7` | Q175 p61 |

**This cycle exists in the original PDF.** The `PATH` variable is progressively refined through the questionnaire: Q100 sets the initial classification, then Q130/Q136/Q170/Q174/Q175 update it as more information is gathered. Items that read `path` (to determine which section the respondent enters) depend on items that write `path` (to refine the classification), and vice versa through shared block-level preconditions.

**Why this works in the imperative version:** The GOTO-based execution guarantees a fixed time ordering. Q132 always reads PATH **before** Q136 writes it. Q132 reads `PATH_v1` (set by Q100), and Q136 creates `PATH_v2` (=3). The imperative model implicitly separates these into temporal snapshots of the same variable.

**Why the declarative model detects cycles:** The QML dependency graph has **one `path` node**, not versioned snapshots. Every item that reads `path` depends on every item that writes `path`, and since several items do both, the result is a strongly connected component. The 39 cycle paths are the combinatorial enumeration of all simple cycles through these 10 items.

**Impact on validation:** The `valid` flag is `false` due to the detected cycles. However, Kahn's algorithm still computed a topological order for all 83/83 items, and Z3 classified every item (ALWAYS: 4, CONDITIONAL: 79). The cycle is a structural property of the `path` variable's dual read-write usage, not a design error — it faithfully represents the original PDF's state machine pattern.

## Cross-Check Fixes (QML Authoring Errors)

These are errors introduced during the QML conversion that were discovered by cross-checking the QML against the question inventory and PDF. They have been corrected.

| # | Item(s) | Error | Fix | PDF Reference |
|---|---------|-------|-----|---------------|
| 1 | Q110 | Missing response option 3 "Working in a family business without pay". The Radio control only had options 1 (Working for wages/salary/tips/commission) and 2 (Working for self-employment). | Added option `3: "Working in a family business without pay"` to the Radio control. | Q110 p58: Class of Worker — three options including "Working in a family business without pay" |

## Problems in the Original PDF (Exposed by Declarative Conversion)

These are genuine issues in the Statistics Canada LFS questionnaire that are hidden by the imperative GOTO-based design but become visible when expressed declaratively.

### P1: Age Cutoff Contradiction (15 vs 16)

| Source | Rule |
|--------|------|
| CAF_Q01 (p54) | "If age < 16 or age > 65, go to ANC_Q01 for next household member" |
| Labour Force section header (p57) | "For each person aged 15 or over who is not a full-time member of the regular armed forces" |

The CATI routing at CAF_Q01 **excludes 15-year-olds** from the labour force component, but the section header **includes them**. In the imperative version, the interviewer follows CAF_Q01 and skips 15-year-olds without noticing the contradiction in the header text.

**In the QML:** The postcondition `q_age.outcome >= 15` (from the header) allows 15-year-olds into the survey, but `b_job_attachment` requires `age >= 16` (from CAF_Q01). A 15-year-old respondent completes demographics but then has no forward path — they skip all labour force blocks and only answer school attendance questions. The Z3 validator would flag labour force items as having paths where they are unreachable for age=15.

### P2: PATH Variable as Overloaded State Machine

The `path` variable (values 1-7) serves as both a **respondent classification** (employed at work, absent, temp layoff, etc.) and a **routing mechanism** (controlling GOTO jumps). This dual use creates several issues:

**Undefined intermediate state (path=0):** Multiple flow paths leave `path` at its initial value of 0 for extended periods:
- Q100=No → Q101=Yes → Q130=temp layoff (8) → Q134-Q136 chain. If Q136 doesn't set PATH=3 (seasonal, no recall, >52 weeks), `path` stays at 0 through Q137 and into Q170.
- In the imperative version, GOTO jumps carry the respondent forward despite the undefined state. In the declarative version, blocks with preconditions like `path == 3 or path == 4` must explicitly handle path=0, or respondents fall through.

**Cross-cutting write points:** The `path` variable is written by items across 4 different blocks (b_job_attachment, b_absence_separation, b_job_search), creating the dependency cycle detected by the validator.

### P3: Discouraged Workers Break the PATH Taxonomy

PDF Q178 (p64): *"If PATH = 4, go to 190. If 'Believes no work available', go to 190. Otherwise go to 500."*

Discouraged workers (those who want work but "believe no work is available") reach Q190 (availability check) with **PATH=6** ("not in labour force, able to work"). But the availability section is designed for PATHs 3, 4, and 5. The ILO concept of "marginally attached workers" requires an availability check for discouraged workers, but the PATH taxonomy (1-7) doesn't have a dedicated value for this state.

**In the imperative version:** GOTO bypasses the PATH check — the interviewer jumps directly to Q190 regardless of PATH value.

**In the declarative version:** The QML requires an additional variable (`discouraged_worker`) to route these respondents to the availability block, because `path == 6` isn't sufficient to distinguish discouraged workers from other "not in labour force" respondents. This reveals that the 7-value PATH taxonomy is **incomplete** for the actual classification needs.

### P4: Q178 Dead Condition Check

PDF Q178: *"If PATH = 4, go to 190"*

This condition is checked at Q178, but Q178 is reached from Q177, which is reached from **two paths**:
1. Q170=Yes → Q171-Q173 → Q177 → Q178 (PATH=4, seekers)
2. Q170=No → Q174=No → Q176=Yes → Q177 → Q178 (PATH=6, non-seekers who want work)

For path 2, PATH was set to 6 at Q174. The "If PATH = 4" check at Q178 is **only true for path 1**. For path 2, it falls through to the "Believes no work available" check. This is correct behavior but misleading — the code suggests PATH=4 respondents reach Q178, but they actually arrive via a completely different route (Q173 goes to Q177, not Q178 directly — it goes "Go to 177" which then continues to Q178).

The declarative version makes this explicit: Q178's precondition is `q170 == 0 AND q176 == 1`, which **excludes PATH=4 entirely**. The "If PATH=4" check in the PDF is dead code at Q178.

### P5: PATH=7 Phantom Job Description

PDF Q105 (p58): *"Else if PATH = 7, go to 131"*

Permanently unable workers (PATH=7) who worked within the past year are routed **directly** to Q131 (separation reasons), **skipping Q110-Q118 entirely** (job description). This means Q131 asks "why did you stop working at that job?" without ever describing the job.

Meanwhile, all other past-job respondents go through Q110-Q118 first. The GOTO hides this asymmetry — the interviewer for PATH=7 never sees the job description questions. In the declarative version, the QML needs a separate variable (`past_job_path7`) to express this bypass, making the inconsistency explicit.

### P6: Q136 PATH=3 Classification Logic

PDF Q136 (p60) sets PATH=3 (temporary layoff) only when ALL of:
1. Not seasonal layoff
2. Layoff duration <= 52 weeks
3. Employer gave return date (Q134=Yes) **OR** recall indication within 6 months (Q135=Yes)

If Q134=No AND Q135=No → PATH stays undefined (goes to Q137 with path=0). This means a worker laid off due to business conditions, with no return date, no recall indication, but only 10 weeks of layoff is **NOT** classified as PATH=3 (temporary layoff). They fall through to Q137 → Q170 as if they were never employed.

This classification rule is arguably too strict — short-duration layoffs without explicit recall indication are excluded from the "temporary layoff" classification. The declarative version makes this explicit through the nested codeBlock conditions.

## Impact Assessment

| Category | Imperative (PDF) | Declarative (QML) |
|----------|------------------|-------------------|
| **Contradictions** | Hidden by GOTO — interviewer follows routing without seeing header text conflicts | Forced into explicit preconditions — validator can flag inconsistencies |
| **State machine gaps** | PATH=0 is invisible — GOTO carries respondent forward regardless | PATH=0 creates unmatched preconditions — validator detects unreachable items |
| **Cross-cutting concerns** | GOTO handles ad-hoc routing (discouraged workers → availability) | Requires additional variables — reveals taxonomy limitations |
| **Circular dependencies** | Impossible by construction — each GOTO is unidirectional | Detected by topological sort — the `path` variable creates read/write cycles within blocks |
| **Dead code** | Not detectable without manual trace through all 20+ pages | Z3 solver classifies each item as ALWAYS/CONDITIONAL/NEVER reachable |

## Conclusion

The Z3 QML validator detected **39 dependency cycles**, all rooted in the mutual dependency between `q132_job_loss_detail` and `q133_expect_return` through multiple intermediate items (q134, q135, q136, q170, q174, q175). These cycles are a direct consequence of the `path` variable being used as both a classification AND routing mechanism in the original questionnaire — a design pattern that works with imperative GOTO but creates circular dependencies in a declarative constraint system. The `valid` flag is `false`, though Z3 still computed global satisfiability (SAT) and per-item classifications for all 83 items.

The declarative conversion exposed **6 categories of problems** in the original 20-page CATI questionnaire:

1. **Age cutoff contradiction** (15 vs 16) — invisible in GOTO-based flow
2. **PATH variable overloading** — undefined intermediate states hidden by GOTO
3. **Incomplete taxonomy** — discouraged workers need state beyond the 7-value PATH
4. **Dead condition checks** — PATH=4 test at Q178 is unreachable
5. **Asymmetric routing** — PATH=7 skips job description without explicit justification
6. **Strict classification thresholds** — short layoffs without recall indication are unclassified

These problems are nearly impossible to detect by reading the 20-page PDF, where each question's routing appears locally correct. The declarative approach forces all constraints to be globally consistent, making structural issues immediately visible to formal verification tools.
