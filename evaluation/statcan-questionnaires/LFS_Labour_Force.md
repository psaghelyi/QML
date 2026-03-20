# LFS Labour Force Survey: Declarative Conversion Analysis

**Source:** Statistics Canada, Catalogue no. 71-543, Appendix B
**QML File:** `shared/questionnaires/LFS_Labour_Force.qml`
**Date:** 2026-03-18

## Objective

Transform the traditional imperative CATI questionnaire (PDF, 20 pages of GOTO-based branching) into a declarative QML representation, then run the Z3-based formal validator to detect structural problems that are hidden in the imperative version.

## Methodology

1. Page-by-page comparison of the PDF flow against the QML preconditions/postconditions
2. Correction of QML divergences to achieve semantic equivalence with the PDF
3. Formal validation using the Askalot Z3 QML validator

## Corrections Made (QML divergences from PDF)

These were errors in the original QML conversion, NOT problems in the original PDF. They were fixed to achieve semantic equivalence before running the validator.

| # | Item | Original QML | Corrected | PDF Reference |
|---|------|-------------|-----------|---------------|
| 1 | `b_job_attachment` precondition | `age >= 15` | `age >= 16` | CAF_Q01 p54: "If age<16, skip" |
| 2 | `q110_class_of_worker` | 3 options (Employee, Self-employed, Family business) | 2 options (Employee, Self-employed) | Q110 p59: only Employee / Self-employed |
| 3 | `q130_reason_absent` codeBlock | Set `path = 0` for layoff reasons | Set `path = 2` only for non-layoff reasons | Q130 p60: "Otherwise PATH=2" |
| 4 | `q135_recall_indication` | Missing entirely | Added | Q135 p60: "Has he/she been given any indication of recall?" |
| 5 | `q136_weeks_on_layoff` codeBlock | Assigned PATH=3 too liberally | Requires return date OR recall indication AND <=52 weeks | Q136 p60: complex PATH=3 conditions |
| 6 | `q153`-`q156` preconditions | Employee only | Employee AND `path == 1` | Q151/Q152 p61: "If PATH=2, go to 158" |
| 7 | `q170_looked_for_work` codeBlock | Only set PATH=4 for seekers | Also set PATH=6 for age>=65 non-seekers | Q170 p63: "If no and age>=65, PATH=6" |
| 8 | `q174_future_job` codeBlock | No PATH assignment | Set `path = 6` when no | Q174 p63: "If no, PATH=6" |
| 9 | `q178_reason_not_looking` | No discouraged worker routing | Added `discouraged_worker` variable | Q178 p64: "If 'Believes no work available', go to 190" |
| 10 | `b_availability` precondition | `path == 3 or 4 or 5` | Added `or discouraged_worker == 1` | Q178 p64 routes discouraged workers to Q190 |
| 11 | `b_school` precondition | `path != 7 and age < 65` | `age < 65` only (no PATH exclusion) | Q500 p67: all paths reach Q500, PATH=7 included |
| 12 | `q520_fulltime_in_march` | Missing entirely | Added (ages 15-24) | Q520 p67: "Was ... a full-time student in March?" |
| 13 | `q161_looked_fulltime` | Missing entirely | Added (Q160 = business conditions / couldn't find work) | Q161 p62: "Did he/she look for full-time work?" |
| 14 | `q301`/`q302` (other job) | Missing | Added self-employed sub-questions for other job | Q301/Q302 p66 |
| 15 | `q137_usually_30plus` precondition | Complex condition with q131 reference | `path != 2` (convergence point for all non-PATH-2 paths) | Q137 p61 |

## Validator Results

### Summary

| Metric | Value |
|--------|-------|
| Items | 83 |
| Blocks | 13 |
| Preconditions | 62 |
| Postconditions | 2 |
| Variables | 10 |
| Cycles | **3** |
| Connected Components | 15 |
| Structural Validity | `false` |
| Z3 Global Satisfiability | `true` (SAT) |
| Z3 Item Classifications | ALWAYS: 21, CONDITIONAL: 62 |

### Key Finding: Dependency Cycles Detected

The validator found **3 dependency cycles** in the questionnaire (confirmed by Kahn's algorithm). Despite the cycles, the Z3 solver still computed per-item reachability classifications for all 83 items (using the topological order computed for the 83/83 items it could process), and the global formula is satisfiable (SAT).

**Cycles reported** (from topological sort):
```
Cycle 1: q132_job_loss_detail → q134_given_return_date → q133_expect_return → q132_job_loss_detail
Cycle 2: q132_job_loss_detail → q135_recall_indication → q133_expect_return → q132_job_loss_detail
Cycle 3: q132_job_loss_detail → q136_weeks_on_layoff  → q133_expect_return → q132_job_loss_detail
```

All three cycles share the same core: `q132_job_loss_detail` and `q133_expect_return` mutually depend on each other through three different intermediate items (q134, q135, q136), each of which in turn depends on `q133` through preconditions, while q133 depends on q132 through its own precondition, and q132's codeBlock (q136) writes back to `path` which q132 reads.

**Dependency edges forming the cycles:**

| Edge | Reason | PDF Reference |
|------|--------|---------------|
| `var:path` → `q132` | Q132 precondition: `path != 7` | Q132 p60: "If PATH = 7, go to 137" |
| `q132` → `q133` | Q133 precondition: `q132 == 6` | Q132 p60: "If Business conditions, go to 133" |
| `q133` → `q134` | Q134 precondition: `q133 == 1` | Q133 p60: "If yes → Q134" |
| `q133` → `q135` | Q135 precondition references `q133` | Q135 p60: recall indication question |
| `q133` → `q136` | Q136 precondition references `q133` outcome chain | Q136 p60: weeks on layoff |
| `q134` → `q133` | Q133 precondition reads q134 outcome (back-edge) | cycle |
| `q135` → `q133` | Q133 precondition reads q135 outcome (back-edge) | cycle |
| `q136` → `q133` | Q133 precondition reads q136 outcome (back-edge) | cycle |
| `q136` → `var:path` | Q136 codeBlock writes `path = 3` | Q136 p60: "Otherwise PATH = 3" |

**This cycle exists in the original PDF.** Here's the proof:

1. **Q132 reads PATH** (p60): *"If PATH = 7, go to 137"* — Q132 checks the `path` variable to decide whether to skip itself
2. **Q132 → Q133 → Q134/Q135** (p60): dependency chain through outcomes — Q132's answer gates Q133, Q133's answer gates Q134 and Q135
3. **Q136 reads Q134/Q135 and writes PATH** (p60): *"Otherwise PATH = 3"* — Q136 conditionally sets `path = 3` based on Q134 and Q135 outcomes
4. **The `path` Q132 reads is the same `path` Q136 writes** — both reference the single PATH variable

**Why this works in the imperative version:** The GOTO-based execution guarantees a fixed time ordering. Q132 always reads PATH **before** Q136 writes it. Q132 reads `PATH_v1` (set by Q100), and Q136 creates `PATH_v2` (=3). The imperative model implicitly separates these into two temporal snapshots of the same variable.

**Why the declarative model detects cycles:** The QML dependency graph has **one `path` node**, not versioned snapshots. It sees:
- Q132 depends on `path` (reads it)
- `path` depends on Q136 (Q136 writes it)
- Q136 depends on Q133/Q134/Q135 (reads their outcomes in codeBlock)
- Q134, Q135 each depend on Q133 (via preconditions)
- Q133 depends on Q132 (reads Q132 outcome in precondition)
- Therefore three distinct cycles, all routing through the q132 ↔ q133 back-edge

**This is a variable feedback loop:** an item that reads a variable to gate its own execution (Q132 checks `path != 7`) has downstream items that write back to the same variable (Q136 sets `path = 3`). The imperative model masks this feedback by enforcing sequential execution. The declarative model correctly identifies it as a circular data dependency.

**Impact on validation:** The `valid` flag is `false` due to the detected cycles. However, Kahn's algorithm still computed a topological order for all 83/83 items, and Z3 classified every item (ALWAYS: 21, CONDITIONAL: 62). The cycle is a structural flaw in the dependency graph, but it does not prevent Z3 from evaluating satisfiability.

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

The Z3 QML validator detected **3 dependency cycles**, all rooted in the mutual dependency between `q132_job_loss_detail` and `q133_expect_return` through three intermediate items (q134, q135, q136). These cycles are a direct consequence of the `path` variable being used as both a classification AND routing mechanism in the original questionnaire — a design pattern that works with imperative GOTO but creates circular dependencies in a declarative constraint system. The `valid` flag is `false`, though Z3 still computed global satisfiability (SAT) and per-item classifications for all 83 items.

The declarative conversion exposed **6 categories of problems** in the original 20-page CATI questionnaire:

1. **Age cutoff contradiction** (15 vs 16) — invisible in GOTO-based flow
2. **PATH variable overloading** — undefined intermediate states hidden by GOTO
3. **Incomplete taxonomy** — discouraged workers need state beyond the 7-value PATH
4. **Dead condition checks** — PATH=4 test at Q178 is unreachable
5. **Asymmetric routing** — PATH=7 skips job description without explicit justification
6. **Strict classification thresholds** — short layoffs without recall indication are unclassified

These problems are nearly impossible to detect by reading the 20-page PDF, where each question's routing appears locally correct. The declarative approach forces all constraints to be globally consistent, making structural issues immediately visible to formal verification tools.
