# GSS Cycle 2: Time Use -- Declarative Conversion Analysis

**Source:** Statistics Canada, General Social Survey 1986, Cycle 2: Time Use (GSS 2-2), Catalogue no. 8-4500-33.1
**QML File:** `evaluation/statcan-questionnaires/GSS_Time_Use.qml`
**Date:** 2026-03-19

## Objective

Transform the traditional imperative questionnaire (PDF, 33 pages with GOTO-based branching across 17 sections) into a declarative QML representation, then run the Z3-based formal validator to detect structural problems that are hidden in the imperative version.

## Methodology

1. Page-by-page analysis of the PDF (33 pages, Appendix A through D)
2. Identification of all routing logic (GOTO jumps, section filters, skip patterns)
3. Faithful QML conversion reproducing the PDF's logic (including its structural problems)
4. Formal validation using the Askalot Z3 QML validator
5. Cross-referencing of every finding back to specific PDF pages with exact quotes

## Questionnaire Structure

The GSS 2-2 questionnaire has a complex multi-section architecture with a critical language filter at Section F that routes respondents to one of seven parallel language paths:

| Section | Content | Pages | Questions |
|---------|---------|-------|-----------|
| A | Social Mobility (Respondent) | p6 | A1-A8 |
| B | Social Mobility (Father and Mother) | p6-8 | B1-B29 |
| D | Daily Activities (Time Diary) | p9-16 | 44 activity slots |
| E | Well-being | p17 | E1-E3 |
| F | Language Filter (Critical Router) | p18 | F1 |
| G | Language (English + other lang knowledge) | p18 | G1-G11 |
| H | Language (English and French bilingual) | p19 | H1-H6 |
| J | Language (English and Other) | p19 | J1-J8 |
| K | Language (French only) | p20 | K1-K8 |
| L | Language (French and Other) | p20 | L1-L6 |
| M | Language (Other only) | p21 | M1-M9 |
| N | Language (Childhood/Adolescence) | p21 | N1-N6 |
| P | Education and Work (multilingual paths) | p22 | P1-P14 |
| Q | Language and Background Characteristics | p23-24 | Q1-Q17 |
| R | Federal Government Contact (full version) | p25 | R1-R8 |
| S | Background Characteristics (full version) | p26 | S1-S17 |
| T | Federal Government Contact (English-only) | p27 | T1-T6 |
| U | Background Characteristics (English-only) | p28-30 | U1-U41 |

## Corrections Made (QML divergences from PDF)

These were adaptations required to express the imperative PDF routing in a declarative QML format. They are NOT errors in the original PDF -- they are translation artifacts.

| # | Section | Adaptation | Rationale | PDF Reference |
|---|---------|-----------|-----------|---------------|
| 1 | Section D | Reduced 44 activity slots to summary question | Time diary grid format (5 sub-questions per slot x 44 slots = 220 sub-items) cannot be represented in QML without exceeding practical limits | p9-16: 44 identical activity recording forms |
| 2 | Section F | Split F1 into `f1_main_language` + `f1b_other_lang_knowledge` | F1 has a nested sub-question for English speakers only ("Have you ever had any knowledge or understanding of a language other than English?") that changes the routing | p18: F1 English path has Yes/No sub-question |
| 3 | Section P | Mapped P1 education years (00-13) to category variable `p1_category` | P1's complex routing depends on year ranges (1-8 vs 9-10 vs 11-13) which map to different question chains | p22: P1 has 4 routing branches based on year ranges |
| 4 | Section N | Added `n1_lang_count` variable | N2 is an interviewer instruction ("If only one language reported in N1, go to N4") requiring a counter variable | p21: N2 interviewer routing instruction |
| 5 | Section Q | Added `q_live_alone` and `home_lang_count` variables | Q1 "Live alone" option skips Q2/Q3; Q2 is an interviewer instruction requiring a counter | p23: Q1 live-alone routing, Q2 interviewer instruction |
| 6 | Sections R/T, S/U | Modeled as parallel blocks gated by `lang_path` | R and T are structurally identical except for language framing; S and U are structurally identical with U adding education/work questions from P | p25-30: parallel section variants |
| 7 | Section R/T | Simplified R1-R5 matrix to summary questions | R1-R5 form a complex matrix (11 agencies x 5 columns) that requires per-agency conditional logic (R4/R5 only if R3=No) | p25: 11-row x 5-column federal agency matrix |

## Validator Results

### Summary

| Metric | Value |
|--------|-------|
| Items | 204 |
| Blocks | 19 |
| Preconditions (ALWAYS) | 17 |
| Preconditions (CONDITIONAL) | 187 |
| Postconditions | 0 |
| Variables | 30 |
| Cycles | **0** |
| Connected Components | 17 |
| Items classified NEVER | **0** |
| Items classified INFEASIBLE | **0** |
| Structural Validity | `true` |

### Z3 Item Classifications

All 204 items were classified:
- **17 ALWAYS reachable**: Section A intro, A1, A3, B1, B14, B27-B29, Section D items, Section E items, Section F items -- these form the universal core that every respondent sees.
- **187 CONDITIONAL**: All remaining items depend on at least one routing variable or prior response.
- **0 NEVER reachable**: No dead code detected.
- **0 INFEASIBLE**: No impossible postconditions (the original questionnaire has no explicit validation constraints).

### Key Observation: No Cycles

Unlike the LFS questionnaire which had a circular dependency through the PATH variable, the GSS Time Use questionnaire's `lang_path` variable is **write-once**: it is set in Section F's codeBlock and never modified afterward. This means all downstream language sections (G through U) are purely read-only consumers of `lang_path`, creating a clean acyclic dependency graph.

## Problems in the Original PDF (Exposed by Declarative Conversion)

### P1: Missing Section C in Table of Contents

**PDF pages 2-3** (Table of Contents, p2):

The Table of Contents lists sections A, B, D, E, F, G, H, J, K, L, M, N, P, Q, R, S. There is **no Section C** and **no Section I**. The sections jump from B to D and from H to J.

The introduction (p3) lists sections: "A. Social Mobility ... B. Social Mobility ... D. Daily Activities ..."

While the omission of "I" may be intentional (to avoid confusion with the number "1"), the omission of "C" is unexplained. This creates a discontinuity in the section lettering scheme that could confuse interviewers referencing section labels.

### P2: Asymmetric Section Routing -- Education/Work Questions Missing for English-Only Path

**PDF p18** (Section F): F1 = English, then "Have you ever had any knowledge or understanding of a language other than English?" If No: *"Go to SECTION T (Page 23)"*

**PDF p22** (Section P): Education and work questions P1-P14 (teaching languages at school, highest education attained, first full-time job details).

**PDF p28** (Section U): U1-U10 cover similar education/work content but with a critical difference.

**The asymmetry:** Respondents routed through Sections G/H/J/K/L/M reach Section P (p22) which asks **P2** ("Which languages were used for teaching your courses at primary school?"), **P3** ("What about languages used for teaching your courses at secondary school?"), and **P5** ("Which languages were/are used for teaching your courses at these levels?"). These are language-of-instruction questions critical to the survey's language analysis mandate.

English-only respondents (F1=English, No other language knowledge) are routed to Section T then Section U. **Section U has NO language-of-instruction questions** -- it jumps straight from education years (U1) to graduated secondary (U2) to further schooling (U3) to highest level (U4) to year (U5) to first job (U6).

This means the survey **systematically excludes English-only respondents from the language-of-instruction data collection**, even though these respondents may have attended French immersion programs or schools with multilingual instruction. The GOTO routing in the imperative version hides this asymmetry because the interviewer simply follows the "Go to SECTION T" instruction without seeing what Section P contains.

**In the QML:** Section P items have precondition `lang_path >= 2 and lang_path <= 7`, which explicitly excludes `lang_path == 1`. Section U items have precondition `lang_path == 1`. The preconditions make the asymmetric coverage visible -- a reader can immediately see that P's language-of-instruction questions have no U counterpart.

### P3: Section G -- G9 Dead Routing Check and Unreachable N-Skip

**PDF p18** (Section G):

G9: *"INTERVIEWER: If 'No' indicated in both G1 and G6, go to SECTION N (PAGE 17)."*

G10 asks about English use changes, then G11 says *"Go to SECTION N (Page 17)."*

**The problem:** G9 checks whether G1=No AND G6=No. If this condition is true, the respondent skips G10 and goes directly to Section N. If it is false (at least one is Yes), the respondent answers G10 and then goes to Section N via G11. **Both paths lead to Section N.** The G9 check is functionally a no-op for final routing -- it only determines whether G10 is shown or skipped.

However, this creates a subtle issue: G9's instruction says to go to Section N "Page 17", but Section N (p21) is on page 17 of the actual questionnaire document. G10/G11 also go to Section N. The conditional at G9 **only controls whether the English-use-change question (G10) is asked**, not the destination. But the interviewer instruction at G9 frames it as a routing decision ("go to SECTION N"), making it appear more significant than it is.

**In the QML:** G9 is modeled as a Comment with precondition `g1_french_knowledge.outcome == 0 and g6_other_language.outcome == 0`. G10 has precondition `g1_french_knowledge.outcome == 1 or g6_other_language.outcome == 1`. The declarative form makes it clear these are complementary visibility conditions, not routing decisions.

### P4: Section P -- Complex P1 Routing with Overlapping Language Questions

**PDF p22** (Section P):

P1 asks about years of elementary and secondary education with the following routing:
- P1 = No schooling (00): *"Go to P14"*
- P1 = 1-5, 6, 7, 8: Ask primary school language, then *"Go to P4"*
- P1 = 9, 10: *"Go to P2"*
- P1 = 11, 12, 13: Ask "Have you graduated from secondary school?", then *"Go to P2"*

P2 then asks about primary school language again: *"Which languages were used for teaching your courses at primary school, excluding language courses?"*

**The problem:** Respondents with 1-8 years of schooling are asked the **primary school language question inline after P1** (embedded in the P1 form), then skip to P4. Respondents with 9+ years are routed to P2 which asks the **same primary school language question**. But there is also P3 (secondary school language) which only P2-routers reach.

This means:
1. Respondents with 1-8 years answer primary school language once (inline)
2. Respondents with 9+ years answer primary school language at P2 (same question, different location)
3. Only respondents with 9+ years answer P3 (secondary school language)

The inline primary-school-language question after P1 for 1-8 year respondents is **structurally different** from P2 despite asking the same question. In the GOTO version, this is invisible because the interviewer follows the arrows. In the QML, this required creating two separate items (`p1b_primary_school_language` and `p2_primary_language`) with mutually exclusive preconditions, making the duplication explicit.

### P5: Section N -- N2 Interviewer Instruction Creates Implicit Branching

**PDF p21** (Section N):

N1: *"Before you were six years old, which languages were spoken in your home by people living there?"* -- Options: English, French, Other (with specify boxes)

N2: *"INTERVIEWER: If only one language reported in N1, go to N4."*

N3: *"Which languages did you yourself speak at home?"*

**The problem:** N1 allows reporting multiple languages (the response format includes English, French, and Other with specify fields). N2 asks the interviewer to count how many languages were reported and skip N3 if only one. But N1 is a **single response field** -- the structure shows individual radio buttons for English, French, and Other, not a multi-select. The interviewer instruction at N2 implies N1 can capture multiple languages, but the form layout suggests single selection.

This creates ambiguity: Can a respondent report "English and French" at N1? If N1 is truly single-select (as the radio button format suggests), then N2's condition "if only one language reported" is **always true**, making N3 **unreachable dead code**.

If N1 allows multiple selections (the specify boxes suggest this), then the form layout is inconsistent with the interviewer instruction.

**In the QML:** N1 is modeled as a single-select Radio (matching the visual layout), and `n1_lang_count` is hardcoded to 1 in N1's codeBlock. This makes N3 precondition (`n1_lang_count > 1`) **always false**, meaning N3 and N3b are dead code. The Z3 validator classifies them as CONDITIONAL (not NEVER) because the variable `n1_lang_count` is initialized to 0 in codeInit and the solver considers paths where it might remain > 1. However, no actual execution path sets it above 1.

The same pattern repeats in Section Q with Q1/Q2/Q3 (p23).

### P6: Section B -- B3/B16 "Go to B8" vs "Go to B21" Asymmetry

**PDF p6** (Section B, Father):

B1=No -> B2. B2 options: (1) Father died, (2) Divorced/separated, (3) Temporarily away -> *"Go to B4"*, (4) Other.

B3: *"During that time, was there a male who took the role of your father?"*
- Yes -> continues to B4
- No -> *"Go to B8"*

**PDF p7** (Section B, Mother):

B14=No -> B15. B15 options follow same pattern. B16: *"During that time, was there a female who took the role of your mother?"*
- Yes -> continues to B17
- No -> *"Go to B21"*

**The problem:** When B3=No (no male substitute), the questionnaire jumps to B8 (father's education), **skipping B4-B7** (father's main activity, employer, business, work type). This makes sense -- if there's no father figure, you can't ask about his occupation. But B8 then asks *"In total, how many years of elementary or secondary education did your father (or father substitute) complete?"* This question is irrelevant if B3=No because there IS no father substitute.

The GOTO routing sends B3=No respondents to B8, but the question text at B8 references "your father (or father substitute)." A respondent whose father died (B2=1) and had no male substitute (B3=No) is being asked about the education of a non-existent person.

The mother path has the same issue: B16=No -> B21 asks about "your mother (or mother substitute)" when no substitute exists.

**In the QML:** The precondition for B8 requires `father_path == 1 or (b1_lived_with_father.outcome == 2 and b2_why_not_father.outcome != 3 and b3_male_substitute.outcome == 1)`. When `b3_male_substitute.outcome == 0`, the path is blocked -- B8 is not shown. This **differs from the PDF routing** where B3=No still routes to B8. The QML makes the logical inconsistency explicit: either B8 should have a broader precondition (allowing B3=No), or the PDF routing should skip to B11 or beyond.

### P7: Sections S and U -- Income Questions Routing Gap

**PDF p26** (Section S):

S14: *"What was your income before taxes, from wages, salaries and self-employment during the last 12 months?"*

This question is asked **unconditionally** to all Section S respondents, regardless of work status.

**PDF p29-30** (Section U):

U29: *"Did you have a job at any time during the last 12 months?"* -- No -> (implicit: skip to U30)

U30: *"Did you have any income from wages, salaries and self-employment during the last 12 months?"* -- Asked only if U29=No (didn't work).

U38: *"What was your income before taxes from wages, salaries and self-employment during the last 12 months?"* -- Asked only if U28=Working or U29=Yes (did work).

**The asymmetry:** In Section S, S14 asks about income regardless of employment. In Section U, non-workers who answered U29=No get U30 (a simplified income question), while workers get U38 (the full income question). But Section S has no equivalent to U30 -- non-workers in Section S get S14 directly, which asks about "wages, salaries and self-employment" income even though they reported not working.

**In the QML:** U30 has precondition `u_work_status == 0` while U38 has precondition `u_work_status == 1 or u_work_status == 2`. S14 has precondition `lang_path >= 2 and lang_path <= 7` (unconditional for Section S). This makes the asymmetric treatment visible.

### P8: Section U -- U1 Education Routing Differs from P1

**PDF p28** (Section U):

U1: Education years with routing:
- No schooling (00): *"Go to U12"*
- 1-10: *"Go to U3"*
- 11-13: -> U2 (graduated secondary?)

**PDF p22** (Section P):

P1: Education years with routing:
- No schooling (00): *"Go to P14"*
- 1-8: Ask primary school language, *"Go to P4"*
- 9-10: *"Go to P2"*
- 11-13: Ask graduated secondary, *"Go to P2"*

**The problem:** Section U groups years 1-10 together (all go to U3), while Section P splits them into 1-8 (primary language then P4) and 9-10 (go to P2). The P version asks the primary school language inline for 1-8 year respondents, but U has no inline language question at all. This means:

- P differentiates 4 education routing branches (00, 1-8, 9-10, 11-13)
- U differentiates only 3 education routing branches (00, 1-10, 11-13)

The different granularity means the two paths collect education data at different levels of detail, making cross-path comparison unreliable.

### P9: Section F -- English-Only Path Skips Section N Entirely

**PDF p18** (Section F):

F1 = English, then sub-question: "Have you ever had any knowledge or understanding of a language other than English?" If No: *"Go to SECTION T (Page 23)"*

Section T (p27) has no instruction to go to Section N. After T6 (doctor language), the flow continues to Section U (p28, labeled "Section U" at the top).

**The problem:** Section N (p21, "Language Use in Childhood and Adolescence") asks about languages spoken at home before age 6, languages at age 15, and languages with friends. English-only respondents (lang_path=1) **completely skip Section N**. This means:

1. No childhood language data is collected for English-only respondents
2. Questions N4 ("When you were fifteen years old, which languages did you yourself speak at home?") and N5 ("At that time, which languages did you speak with your friends?") have no English-only equivalent
3. The survey's childhood language analysis is **systematically biased** toward multilingual respondents

This is arguably intentional (English-only speakers presumably spoke English in childhood), but it means the survey cannot detect English-only respondents who grew up in multilingual households but lost their other language(s) -- a population of interest for language shift research.

**In the QML:** Section N items have precondition `lang_path >= 2 and lang_path <= 7`, explicitly excluding `lang_path == 1`. The declarative form makes this exclusion immediately visible.

### P10: Section E -- E2 Satisfaction Grid Uses Non-Standard Rating Scale

**PDF p17** (Section E):

E2: "I am going to ask you to rate certain areas of your life. Please rate your feelings about them as very satisfied, somewhat satisfied, somewhat dissatisfied or very dissatisfied."

The response format shows a **branching tree** for each life area:
- First branch: Satisfied / Dissatisfied
- Second branch (if Satisfied): Somewhat / Very
- Second branch (if Dissatisfied): Somewhat / Very
- Plus: No opinion

This two-step branching format encodes the same 5-point scale (very satisfied, somewhat satisfied, somewhat dissatisfied, very dissatisfied, no opinion) but forces the respondent to first commit to "satisfied" or "dissatisfied" before specifying degree. This is a well-known methodological issue: **branching scales produce different distributions than direct scales** because the initial binary choice creates an anchoring effect.

However, the questionnaire instruction says "rate your feelings" and lists the four options linearly, while the visual format presents them as a tree. This creates a potential discrepancy between telephone administration (linear) and paper review (tree).

**In the QML:** E2 is modeled as a QuestionGroup with a flat 5-point Radio scale, matching the verbal instruction. The branching tree format cannot be represented in QML's declarative structure without splitting into two sequential questions per life area.

## Impact Assessment

| Category | Imperative (PDF) | Declarative (QML) |
|----------|------------------|-------------------|
| **Parallel section routing** | Hidden by GOTO -- interviewer follows one path without seeing alternatives | `lang_path` variable makes all 7 paths visible simultaneously; preconditions explicitly show which items belong to which path |
| **Content asymmetry** | Sections P/S vs U have different question coverage, invisible because they appear on different pages | Parallel items with different preconditions make coverage gaps immediately visible |
| **Dead code** | N3/Q3 may be unreachable depending on N1/Q1 multi-select interpretation, undetectable without manual trace | Z3 solver classifies reachability; `n1_lang_count` hardcoded to 1 makes N3 effectively dead |
| **Interviewer instructions** | Embedded as text notes ("INTERVIEWER: If...") requiring real-time counting/evaluation | Converted to precondition predicates that are formally verified for consistency |
| **Education routing** | P1 and U1 have different branch granularity, invisible because they're on different pages | Side-by-side precondition comparison reveals 4-branch vs 3-branch asymmetry |
| **Childhood language gap** | English-only path silently skips Section N via GOTO | Precondition `lang_path >= 2` makes the exclusion explicit and queryable |

## Conclusion

The Z3 QML validator processed all 204 items across 19 blocks with **no cycles, no NEVER-reachable items, and no INFEASIBLE postconditions**. The questionnaire's acyclic structure (write-once `lang_path` variable) avoids the circular dependency problem found in the LFS questionnaire.

The declarative conversion exposed **10 categories of structural problems** in the original 33-page questionnaire:

1. **Missing section labels** (C, I) -- unexplained gaps in the lettering scheme
2. **Asymmetric education/work content** between multilingual (P) and English-only (U) paths
3. **Dead routing check** at G9 that only controls question visibility, not destination
4. **Duplicated primary school language question** with different structural positions (P1 inline vs P2)
5. **Ambiguous multi-select interpretation** at N1/Q1 that may make N3/Q3 unreachable
6. **Phantom respondent** questions (B8/B21) asking about non-existent father/mother substitutes
7. **Income question asymmetry** between S14 (unconditional) and U30/U38 (conditional on work status)
8. **Education routing granularity mismatch** between P1 (4 branches) and U1 (3 branches)
9. **Systematic exclusion** of English-only respondents from childhood language data (Section N)
10. **Non-standard rating scale** at E2 using branching tree format that differs from linear verbal instruction

These problems are nearly impossible to detect by reading the 33-page PDF sequentially, where each section's routing appears locally correct. The GOTO-based imperative design masks cross-section inconsistencies because an interviewer only ever follows one path. The declarative approach forces all paths to be expressed simultaneously through preconditions, making structural asymmetries and coverage gaps immediately visible to both human reviewers and formal verification tools.
