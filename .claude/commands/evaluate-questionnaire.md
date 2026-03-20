---
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, Agent
description: Convert a PDF questionnaire to QML and produce a validation analysis report
---

# Evaluate Questionnaire

Convert the PDF questionnaire at `$ARGUMENTS` to declarative QML, validate it with the Z3 validator, verify semantic equivalence, and produce a detailed analysis report.

## Input

The argument is the path to a PDF questionnaire file. If a relative path is given, resolve it relative to the working directory.

## Step 1: Read the Skill References

Read these files to understand QML syntax and conversion patterns:

- `/root/QML/QML/.claude/skills/write-qml/SKILL.md` — Core QML writing guide
- `/root/QML/QML/.claude/skills/write-qml/references/qml-full-reference.md` — Complete syntax reference
- `/root/QML/QML/.claude/skills/write-qml/references/goto-conversion-guide.md` — GOTO-to-declarative conversion patterns

## Step 2: Read the PDF — Build a Question Inventory

Read the entire PDF questionnaire. Use the Read tool with `pages` parameter, reading up to 20 pages at a time. For large PDFs, read in sequential chunks (pages 1-20, 21-40, etc.) until the entire document is covered.

**Build a complete question inventory** as you read. For EVERY question in the PDF, record:
- Question ID/number (e.g., Q101, CHECK 105, B17)
- Section it belongs to
- Question text (verbatim)
- Response options with their codes
- Skip/routing instruction (GOTO, arrow, "skip to", CHECK filter)
- Any interviewer notes or cross-check instructions

Also note:
- Survey title, source organization, number of pages
- All sections/modules and their structure
- Screening/eligibility sections that may not be representable in QML

**Count the total number of substantive questions** (excluding cover pages, interviewer visit tracking, and administrative headers). This count is your target — the QML must account for every one of them.

## Step 3: Convert to QML

Apply the conversion patterns from the skill references:
- Pattern 1: "If X, go to Y" → precondition on Y
- Pattern 2: PATH/classification variable routing → codeInit + codeBlock + preconditions
- Pattern 3: "Skip to end of section" → block-level precondition
- Pattern 4: Cross-checks → postconditions
- Pattern 5: Converging paths → OR preconditions
- Pattern 6: Intermediate filter gates → counter variables

Follow the validation checklist from SKILL.md before saving. Pay special attention to:
- Power-of-2 keys for Checkbox controls
- All variables initialized in codeInit
- Producer items before consumer items
- No unsupported Python features in code blocks (no len, sum, max, min, append)

Write the QML file to `/root/QML/QML/evaluation/`, using the PDF's base name (without the `.pdf` extension) plus `.qml`. For example, `quest25.pdf` becomes `/root/QML/QML/evaluation/quest25.qml`.

## Step 4: Validate

Run the Z3 validator at level 2:

```bash
cd /root/QML/QML/askalot_qml && uv run python /root/QML/QML/.claude/skills/write-qml/scripts/validate_qml.py <path-to-qml-file> --level 2 --json
```

If validation finds errors (exit code 2), fix the QML and re-validate. Repeat until the validator runs cleanly (exit code 0 or 1).

Also run without `--json` to get human-readable output for the report.

## Step 5: Verify Semantic Equivalence

This step is critical. Go back to your question inventory from Step 2 and verify EVERY question:

1. **Completeness check:** For each PDF question in your inventory, confirm a corresponding QML item exists. If any are missing, add them now and re-validate.

2. **Response option check:** Verify every response option and its code matches the PDF. Missing options or wrong codes break data compatibility.

3. **Skip logic check:** For each skip/GOTO/CHECK instruction in the PDF, verify the corresponding precondition exists in the QML and is logically equivalent. Pay attention to:
   - CHECK filters that gate on prior answers — these must become preconditions
   - Multi-branch skips (e.g., "If 1, go to 201; if 2, go to 205") — each target needs a precondition
   - "Skip to next section" — use block-level preconditions

4. **Produce a coverage summary:**
   ```
   PDF questions: {N}
   QML items: {M}
   Matched: {X}
   Missing (added in this step): {Y}
   Justified omissions: {Z} (list each with reason)
   ```

   **Justified omissions** are ONLY:
   - Procedural elements: interviewer visit logs, consent signatures, cover page fields
   - Dynamic roster loops where the same questions repeat N times for N household members (document which questions are templated and that they represent a per-person loop)
   - Iterative calendar/history grids that require dynamic row generation
   - TERMINATE/END paths (QML represents qualified respondents)

   Everything else must be present. If a question is missing and is not in the justified list, add it.

5. If any items were added, **re-validate** and fix until clean.

## Step 6: Write the Analysis Report

Write a Markdown analysis report to the same directory as the PDF, using the pattern `{BaseName}_Analysis.md` (e.g., `quest25_Analysis.md` stays next to `quest25.pdf`).

Follow the structure established by the existing analyses (see examples in `evaluation/statcan-questionnaires/` and `evaluation/reference-questionnaires/`):

```markdown
# {Survey Title}: Declarative Conversion Analysis

**Source:** {Organization}, {full survey name}, {page count} pages
**QML File:** `evaluation/{filename}.qml`
**Date:** {today's date YYYY-MM-DD}

## Objective

Transform the {description of source format} into a declarative QML representation, then run the Z3-based formal validator to detect structural problems hidden in the imperative version.

## Methodology

1. Full reading of the {page count}-page PDF {across all sections}
2. Question inventory: {N} substantive questions catalogued
3. Declarative QML conversion {with specific conversion approach}
4. Formal validation using the Askalot Z3 QML validator at Level 2
5. Semantic equivalence verification against PDF question inventory

## Survey Architecture Overview

{Describe the survey structure, sections, target population, administration mode}

{Table of sections/blocks with item counts}

## Semantic Equivalence

| Metric | Count |
|--------|-------|
| PDF questions (substantive) | {N} |
| QML items | {M} |
| Matched | {X} |
| Justified omissions | {Z} |

{List each justified omission with its reason}

## Validator Results

### Summary

| Metric | Value |
|--------|-------|
| Items | {N} |
| Blocks | {N} |
| Preconditions | {N} |
| Postconditions | {N} |
| Variables | {N} |
| Dependencies | {N} |
| Cycles | **{N}** |
| Connected Components | {N} |
| Structural Validity | `{true/false}` |
| Global Status | **{SAT/UNSAT}** |
| Issues | **{N}** |

### Z3 Item Classifications

| Classification | Count |
|---------------|-------|
| Precondition ALWAYS | {N} |
| Precondition CONDITIONAL | {N} |
| Precondition NEVER | {N} |
| Postcondition NONE | {N} |
| Postcondition CONSTRAINING | {N} |

{Commentary on classifications}

## Problems Exposed by Declarative Conversion

### P1: {Problem Title}

**PDF evidence:** {specific page/question references}

**Problem:** {detailed description}

**Impact:** {what this means for survey quality}

{Repeat P2, P3, ... for each problem found}

## Impact Assessment

{Compare imperative vs declarative representation}
{What would the PDF approach miss that QML catches?}

## Conclusion

{Categorize findings: structural problems, design observations, limitations}
{Total problem count and severity assessment}
```

Identify real problems — contradictions, dead code, unreachable questions, ambiguous routing, missing gates, age boundary errors, implicit assumptions. Do NOT invent problems that don't exist. Every problem must cite specific PDF page numbers and question IDs as evidence.

## Important Notes

- **Semantic equivalence is mandatory.** Every substantive question in the PDF must have a QML counterpart. Do not skip questions because they are simple or repetitive.
- For very large questionnaires (200+ pages), you must still cover every question. Read in chunks and maintain your inventory across chunks.
- The QML file should be a faithful representation of the survey logic, not a simplified version. Include all questions, all routing, all validation checks.
- If a section is genuinely not representable in QML (e.g., procedural algorithms, dynamic roster loops, TERMINATE paths), document this in the analysis under Justified Omissions rather than omitting it silently.
- CHECK filters in DHS-style questionnaires are decision points that MUST become preconditions — they are not optional.
