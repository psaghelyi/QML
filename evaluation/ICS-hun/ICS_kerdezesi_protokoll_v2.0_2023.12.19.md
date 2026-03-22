# ICS Kérdezési Protokoll v2.0: Declarative Conversion Analysis

**Source:** Hungarian National Ambulance Service (OMSZ), Emergency Medical Dispatch Triage Protocol v2.0, 66 pages
**QML File:** `evaluation/ICS-hun/ICS_kerdezesi_protokoll_v2.0_2023.12.19.qml`
**Date:** 2026-03-20

## Objective

Transform the 66-page Hungarian emergency medical dispatch (EMD) triage protocol — a collection of interconnected imperative flowcharts used by telephone dispatchers — into a declarative QML representation, then run the Z3-based formal validator to detect structural problems hidden in the imperative version.

This protocol is fundamentally different from traditional survey questionnaires: it is a real-time clinical decision support tool where dispatchers follow flowchart branches to assign ambulance priority (P1–P5) and resource type (ALS/BLS). The imperative flowcharts use "first YES wins" waterfall logic, cross-page GOTO routing, and age-stratified parallel tracks — all patterns that declarative conversion can formally analyze.

## Methodology

1. Full reading of the 66-page PDF across all sections (pages 1–66)
2. Question inventory: 221 substantive decision nodes catalogued across all flowcharts
3. Declarative QML conversion with age-group unification (adult/child/infant parallel tracks merged where structurally identical)
4. Formal validation using the Askalot Z3 QML validator at Level 2
5. Semantic equivalence verification against PDF question inventory

## Survey Architecture Overview

The protocol is organized as a network of flowcharts, each occupying one page. The dispatcher enters through **Call Reception** (p1), determines the patient's age group (adult/child/infant) and event type (accident, hanging, electrocution, drowning, or medical), then follows the appropriate assessment pathway.

### Age-Stratified Parallel Tracks

The protocol maintains three parallel assessment tracks that are **structurally identical** with only patient-term substitutions (beteg→gyermek→csecsemő):

| Section | Adult | Child (1-18) | Infant (<1) |
|---------|-------|-------------|-------------|
| ABCDE Assessment | p2 | p44 | p52 |
| T-CPR I | p3-4 | p45-46 | p53-54 |
| T-CPR II (COVID) | p5-6 | p47-48 | p55-56 |
| Breathing Difficulty I | p9 | p49 | p57 |
| Breathing Difficulty II | p10 | p50 | p58 |
| Nervous System | p12 | p51 | p59 |

Sections shared across all age groups: Pain (p14-21), Fever (p22-23), Injuries (p24-32), Allergy (p34-36), Psychiatry (p33), Pregnancy (p37), Condition Overview (p60-63).

### Block Structure (33 blocks, 242 items)

| Block | Section | Items | PDF Pages |
|-------|---------|-------|-----------|
| b_initial | Call Reception | 5 | 1 |
| b_accident | Accident | 3 | 24 |
| b_mass_casualty | Mass Casualty | 5 | 25 |
| b_hanging | Hanging | 1 | 41 |
| b_electrocution | Electrocution | 2 | 42 |
| b_drowning | Drowning | 1 | 43 |
| b_abcde | ABCDE Assessment | 14 | 2/44/52 |
| b_breathing | Breathing Difficulty I+II | 19 | 9-10/49-50/57-58 |
| b_airway | Foreign Body Airway | 3 | 11 |
| b_neuro | Nervous System | 15 | 12/51/59 |
| b_stroke | Stroke/FAST | 13 | 13 |
| b_pain_routing | Pain Routing | 1 | 14 |
| b_headache | Headache | 10 | 15 |
| b_chest_pain | Chest Pain | 12 | 16 |
| b_abdominal_pain | Abdominal Pain | 14 | 17-18 |
| b_back_pain | Back Pain | 11 | 19 |
| b_limb_pain | Limb Pain | 10 | 20 |
| b_other_pain | Other Pain | 7 | 21 |
| b_injury_routing | Injury Routing | 2 | 26 |
| b_head_injury | Head Injury | 8 | 27 |
| b_chest_injury | Chest Injury | 7 | 28 |
| b_abdo_injury | Abdominal Injury | 7 | 29 |
| b_spine_injury | Spine Injury | 8 | 30 |
| b_limb_injury | Limb Injury | 10 | 31 |
| b_burns | Burns | 7 | 32 |
| b_allergy_severe | Severe Allergic Reaction | 10 | 34-35 |
| b_allergy_mild | Mild Allergic Reaction | 6 | 36 |
| b_psychiatry | Psychiatry | 7 | 33 |
| b_pregnancy | Pregnancy | 10 | 37 |
| b_birth | On-Scene Birth | 3 | 38 |
| b_fever | Fever I+II | 14 | 22-23 |
| b_seizure | Seizure | 1 | 40 |
| b_condition_overview | Condition Overview | 1 | 60-63 |

## Semantic Equivalence

| Metric | Count |
|--------|-------|
| PDF question nodes (substantive) | 221 |
| QML items | 242 |
| Matched | 221 |
| Additional items (onset/severity splits) | 21 |
| Justified omissions | 18 pages |

The QML has more items (242) than unique PDF question nodes (221) because several pain/injury/severity matrices were split into separate onset and severity Radio questions for QML's flat data model.

### Justified Omissions (Procedural Pages)

The following pages contain **step-by-step physical instructions** given to the caller, not assessment questions. They involve real-time interactive loops (compression counts, breathing checks) that cannot be represented as static survey items:

| Pages | Section | Reason |
|-------|---------|--------|
| 3-4, 45-46, 53-54 | T-CPR I (adult/child/infant) | CPR instructions with real-time compression-counting loop |
| 5-6, 47-48, 55-56 | T-CPR II COVID variant | Same as T-CPR I with PPE instructions |
| 7 | Recovery Position | Physical positioning instructions with illustrations |
| 8 | AED Operation | Defibrillator device operation steps |
| 39 | Newborn CPR | Neonatal resuscitation procedure |
| 64-65 | EpiPen Use | Auto-injector administration steps |
| 66 | Anapen Use | Auto-injector administration steps |

These 18 pages represent **procedural algorithms** — the dispatcher reads instructions aloud while the caller performs physical actions, with periodic reassessment loops ("Is the patient breathing now?"). They are not data-collection questions and have no survey-equivalent representation. The single assessment question within the seizure protocol (p40, "Has the seizure stopped?") IS included in the QML.

### Age-Group Unification

Pages 2/44/52 (ABCDE), 9-10/49-50/57-58 (Breathing), and 12/51/59 (Nervous System) are structurally identical across adult/child/infant tracks. The only differences are:
- Patient terminology (beteg→gyermek→csecsemő)
- Routing targets that lead to age-specific CPR protocols (procedural, omitted)

The QML models these as unified items with age-neutral wording. This is equivalent to the source — a dispatcher follows exactly one age track, and the QML's preconditions ensure the same linear flow.

## Validator Results

### Summary

| Metric | Value |
|--------|-------|
| Items | 242 |
| Blocks | 33 |
| Preconditions | 241 |
| Postconditions | 0 |
| Variables | 70 |
| Dependencies | 1506 |
| Cycles | **46** |
| Connected Components | 1 |
| Structural Validity | `false` (cycles) |
| Global Status | **SAT** |
| Issues | **1** (dependency cycles) |

### Z3 Item Classifications

| Classification | Count |
|---------------|-------|
| Precondition ALWAYS | 1 |
| Precondition CONDITIONAL | 241 |
| Precondition NEVER | 0 |
| Postcondition NONE | 242 |

All 242 items are reachable (no NEVER classifications). 1 item is unconditionally shown (ALWAYS), and 241 items are conditionally shown based on prior answers and routing variables. The high CONDITIONAL count reflects block-level precondition propagation: 237 of 242 items inherit preconditions from their enclosing blocks (351 block-level precondition expressions total), meaning nearly every item is gated by the dispatcher's initial routing decisions. The absence of postconditions reflects the protocol's nature — it collects observations, not constrained responses.

### Cycle Analysis

The validator detected **46 dependency cycles** across three cascading waterfall structures:

| Waterfall Location | Variable | Cycles | Items Involved |
|-------------------|----------|--------|----------------|
| ABCDE Assessment (b_abcde) | `abcde_routed` | 44 | q_abcde_04 through q_abcde_14 |
| Breathing Difficulty II (b_breathing) | `bd_stroke_route` | 1 | q_bd2_06, q_bd2_07 |
| Nervous System FAST (b_neuro) | `neuro_fast_positive` | 1 | q_neuro_05, q_neuro_06 |

## Problems Exposed by Declarative Conversion

### P1: "First YES Wins" Waterfall Encodes Implicit Clinical Priority Through Layout Order

**PDF evidence:** Pages 2, 10, 12 (and their age-equivalent pages 44, 50, 51, 52, 58, 59)

**Problem:** The ABCDE assessment flowchart (p2) implements a cascading "first YES wins" pattern. The dispatcher asks each check in sequence: breathing difficulty → unusual skin → sweating → behavior change → seizures → arm weakness → facial asymmetry → speech change → pain → injury. When a check is YES and routes to another page, the dispatcher **stops the cascade** and follows that page's protocol.

**Validator finding — 46 dependency cycles:** The QML conversion modeled this waterfall using a shared routing variable (`abcde_routed`) that each item both reads (precondition: `abcde_routed == 0`) and writes (codeBlock: `abcde_routed = 1`). The Z3 validator correctly detected 46 dependency cycles from this pattern. The same pattern produced 1 cycle in the Breathing Difficulty II exit cascade (`bd_stroke_route`) and 1 cycle in the Neuro FAST cascade (`neuro_fast_positive`).

**Are these cycles genuine source problems or conversion artifacts?**

The 46 cycles are **modeling artifacts** — they result from the choice to use a shared routing variable. An alternative cycle-free QML model is possible using direct outcome references:
```yaml
# Cycle-free alternative: reference earlier items directly
- id: q_abcde_09  # seizures
  precondition:
    - predicate: q_abcde_04.outcome == 0  # no breathing difficulty
    - predicate: q_abcde_08.outcome == 0  # no behavior change
```
This eliminates cycles because each item only references EARLIER items (forming a DAG).

**However, the cycles reveal a genuine source property — implicit priority ordering:**

The waterfall's item ordering encodes a **clinical priority decision** that is nowhere explicitly documented:
- Breathing difficulty (position 1) takes precedence over seizures (position 6)
- Seizures take precedence over arm weakness (position 7)
- Pain (position 10) takes precedence over injury (position 11)

A patient can have BOTH breathing difficulty AND seizures AND arm weakness simultaneously. The flowchart resolves this through its physical layout order — the "first YES wins" — but this ordering is:
- **Never stated as a clinical priority rule.** It's encoded only in the spatial position of boxes on the page.
- **Potentially significant.** A patient with seizures AND breathing difficulty gets routed to the breathing protocol (p9), not the seizure protocol (p40). Whether this is the correct clinical priority is a medical decision encoded implicitly in flowchart layout.
- **Not enforceable in practice.** If a dispatcher immediately recognizes seizures (dramatic visual symptom) but needs probing to detect breathing difficulty (subtle), they may mentally "route" on seizures first despite the flowchart prescribing that breathing difficulty should be checked first.

**Impact:** The waterfall design is standard practice in emergency dispatch protocols and works well with sequential human execution. But if this protocol were computerized into a decision-support system, the implicit priority ordering would need to be formalized as explicit rules. The declarative conversion makes this hidden assumption visible.

### P2: Implicit Age-Group Routing Creates Redundant Parallel Structures

**PDF evidence:** Pages 2/44/52 (ABCDE), 9-10/49-50/57-58 (Breathing), 12/51/59 (Nervous System)

**Problem:** The protocol maintains three parallel assessment tracks (adult, child, infant) that are **structurally identical**. Each track has its own flowchart that asks the same questions in the same order with the same routing logic, differing only in patient terminology.

In the 66-page paper protocol, this triplication serves a practical purpose — dispatchers can flip to the age-appropriate page and follow it without mental substitution. But it creates:
- **18 pages of redundant flowcharts** (6 unique sections × 3 age groups)
- **No formal guarantee of consistency** between parallel tracks — if one track is updated, the others may not be
- **Maintenance risk** — any change to the assessment logic must be replicated across all three versions

The declarative QML model resolves this by expressing the shared logic once with age-neutral wording, proving that the three tracks are indeed structurally equivalent.

**Impact:** The triplication is a maintenance liability. The declarative conversion proves the tracks are isomorphic and can be unified without loss of information.

### P3: Cross-Page GOTO Network Creates Implicit Priority Hierarchy

**PDF evidence:** Pages 2, 9-10, 12, 15-21, 26-32 (exit cascades on every assessment page)

**Problem:** Nearly every assessment page ends with an identical "exit cascade":
1. "Fever?" → Go to page 22
2. "Other pain?" → Go to page 14
3. "Injury?" → Go to page 26
4. If all NO → Go to page 60 (Condition Overview)

This creates a **cross-page GOTO network** where any assessment module can route to any other module. In the imperative protocol, the dispatcher follows exactly one route. But the network topology implies:
- **Fever always takes precedence over pain, which always takes precedence over injury** — this priority order is implicit in the exit cascade's fixed position, not explicitly specified
- **Circular routing is theoretically possible** — e.g., Headache (p15) → "Other pain?" → Pain routing (p14) → "Headache" → p15. The protocol relies on the dispatcher not routing back to a section they've already completed, but this constraint is never formally stated.
- **The condition overview (p60-63) is a catch-all** that lists ~50 conditions with priority assignments, but there's no gate ensuring the dispatcher has actually excluded all the specific assessment modules before reaching it.

**Impact:** The exit cascade order encodes a clinical priority decision (fever > pain > injury) that is nowhere documented as an explicit rule. In a computer-assisted system, this implicit ordering must be formalized.

### P4: Pain/Onset/Severity Matrix Has Inconsistent Priority Assignments

**PDF evidence:** Pages 15 (headache), 16 (chest pain), 17 (abdominal pain), 19 (back pain), 20 (limb pain), 21 (other pain), 27-31 (injuries)

**Problem:** Multiple assessment modules use a 3×3 matrix mapping onset time (within 24h / within 1 week / over 1 week) × pain severity (severe 8-10 / moderate 4-7 / mild 1-3) to priority level. However, the priority assignments are **not consistent across modules**:

| Module | Severe+24h | Severe+1wk | Moderate+24h | Mild+>1wk |
|--------|-----------|-----------|-------------|----------|
| Headache (p15) | P2 | P2 | P3 | P5 |
| Chest pain (p16) | P2 | P2 | P3 | P5 |
| Back pain (p19) | P3 | P3 | P4 | P5 |
| Limb pain (p20) | P3 | P3 | P4 | P5 |
| Other pain (p21) | P3 | P3 | P4 | P5 |

Headache and chest pain receive higher priority than back/limb/other pain for the same onset/severity combination. While this may be clinically intentional (head and chest symptoms have higher baseline urgency), this differential treatment is:
- **Never explicitly stated** as a design principle in the protocol
- **Not derivable** from the onset/severity axes alone — a dispatcher seeing only the back pain page has no way to know that the same severity headache would receive a higher priority

**Impact:** The declarative conversion makes these asymmetries visible by expressing all modules in a uniform structure. Whether intentional or not, the inconsistency should be documented.

### P5: Condition Overview Tables Lack Entry Gates

**PDF evidence:** Pages 60-63

**Problem:** The Condition Overview (Kórállapot Áttekintő) pages list approximately 50 conditions with direct priority/resource assignments:

- Allergic rhinitis → P5, Ügyelet/tanács
- Frostbite without pulse → P2, BLS
- Penetrating eye injury → P1, ALS
- Testicular torsion → P2, ALS/BLS
- etc.

These tables serve as the final catch-all for conditions that don't fit any specific assessment module. However:
- **No formal gate** ensures the dispatcher has exhausted all specific assessment modules before reaching these tables
- **No assessment questions** are asked — the dispatcher directly selects a condition from a list
- **Conditions overlap** with specific modules (e.g., "Hypothermia" in the condition overview overlaps with temperature assessment that could occur in multiple modules)
- **Priority assignments in the tables may conflict** with priorities computed by specific assessment modules for the same underlying condition

**Impact:** The condition overview tables function as an escape hatch for the imperative protocol. In a declarative model, they must be formally positioned AFTER all specific assessment paths have been evaluated.

### P6: Allergy Module Has Bidirectional Cross-Reference

**PDF evidence:** Pages 2 (ABCDE), 9 (Breathing), 34 (Severe Allergy)

**Problem:** The ABCDE assessment (p2) checks for unusual skin appearance and flags "ANAFILAXIA?" as a routing hint to the severe allergic reaction module (p34). Simultaneously, the breathing difficulty module (p9) also checks for unusual skin and flags anaphylaxis.

The severe allergy module (p34) starts with "Is an allergic reaction suspected?" — if NO, it routes BACK to the breathing difficulty page. This creates a potential circular reference:
- ABCDE → unusual skin → suspected anaphylaxis → Allergy (p34) → "Not allergic" → Breathing (p9) → unusual skin → suspected anaphylaxis → Allergy (p34)...

The imperative protocol relies on the dispatcher recognizing they've already assessed for allergy and not re-entering the same module. The declarative model prevents this through write-once routing variables, but the circular reference in the source represents a design ambiguity.

**Impact:** Low in practice (dispatchers wouldn't loop), but the circular reference reveals that the boundary between "breathing difficulty with skin signs" and "allergic reaction with breathing difficulty" is not crisply defined in the protocol.

## Impact Assessment

### Imperative vs. Declarative Comparison

| Aspect | Imperative (PDF Flowcharts) | Declarative (QML) |
|--------|---------------------------|-------------------|
| Waterfall mutual exclusion | Hidden by sequential execution | **Exposed as 46 dependency cycles** |
| Priority ordering | Implicit in flowchart position | Must be explicit (or cycles) |
| Age-group redundancy | 18 pages of duplicated logic | Unified into shared items |
| Exit cascade priorities | Implicit in fixed question order | Visible as precondition hierarchy |
| Cross-module routing | GOTO page references | Routing variables with preconditions |
| Condition coexistence | Handled by "first YES wins" | Formally ambiguous without priority rules |

### What the PDF Approach Misses

The imperative flowchart format hides three categories of structural issues:

1. **Mutual exclusion ambiguity** — When multiple conditions coexist (breathing difficulty + seizures + pain), the flowchart's "first YES wins" rule resolves this through execution order, but this resolution is not a clinical rule — it's a formatting artifact of the flowchart's physical layout.

2. **Consistency gaps** — The triplication of age-specific sections and the similar-but-different priority matrices across pain modules create opportunities for inconsistency that are invisible when each page is read in isolation.

3. **Implicit assumptions** — The protocol assumes sequential human execution, single-path routing, and no re-entry to completed sections. None of these constraints are formally specified, making it difficult to implement in a computer-assisted dispatch system.

## Conclusion

The conversion of this 66-page emergency dispatch triage protocol to declarative QML reveals **6 structural findings**:

| # | Finding | Severity | Source or Artifact? | Evidence |
|---|---------|----------|---------------------|----------|
| P1 | Waterfall encodes implicit clinical priority via layout order | **High** | Genuine source property (46 cycles are modeling artifact) | ABCDE cascade, p2/44/52 |
| P2 | Redundant age-parallel structures (18 pages) | Medium | Genuine source property | 6 sections × 3 age groups |
| P3 | Implicit priority hierarchy in exit cascades | Medium | Genuine source property | Every assessment module's exit |
| P4 | Inconsistent priority matrices across pain modules | Low | Genuine source property | 6 pain/injury onset×severity tables |
| P5 | Condition overview lacks formal entry gates | Low | Genuine source property | Pages 60-63 |
| P6 | Bidirectional allergy/breathing cross-reference | Low | Genuine source property | Pages 2, 9, 34 |

The most significant finding (P1) concerns the **core triage logic** — every emergency call passes through the ABCDE assessment, and the declarative conversion reveals that the waterfall's item ordering encodes implicit clinical priority decisions that are not documented as explicit rules. The 46 dependency cycles detected by the validator are modeling artifacts (from using a shared routing variable), but they highlight a genuine source property: the protocol's reliance on flowchart layout order to resolve multi-condition ambiguity.

The protocol is **globally satisfiable** (SAT) — there exist valid completion paths. For a paper-based dispatcher protocol, the implicit priority ordering works well (the human dispatcher follows the flowchart sequentially). For computerization, these implicit ordering assumptions would need explicit formalization.

**Total: 6 design observations identified. 1 high significance (implicit priority ordering in core triage), 2 medium (redundancy, implicit exit cascade hierarchy), 3 low (matrix inconsistency, missing gates, circular cross-reference).**
