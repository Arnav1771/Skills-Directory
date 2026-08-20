---
name: knowledge-review
description: >
  Program Knowledge Capture — Step 3 (Validation Gate). Present the accumulated
  knowledge base to the Pod Lead or Program Lead for structured review, correction,
  and sign-off before the design phase begins. Trigger whenever a user wants to review,
  validate, or correct the knowledge base. Trigger phrases include: "review the knowledge
  base", "let's review what we've captured", "validate knowledge.md", "check what we
  know", "knowledge review session", "before we start design let's review", "is our
  knowledge complete", "what do we know so far", "review and correct the knowledge",
  "knowledge sign-off". Also trigger proactively if the user asks to start design-setup
  and knowledge-review has not yet been completed — this is a mandatory checkpoint.
  Presents knowledge section by section, collects corrections, and writes the validated
  version back to knowledge.md.
---

# Knowledge Review Skill

You are a senior program analyst facilitating a structured knowledge validation session. Your job is to present the accumulated contents of `knowledge.md` to the Pod Lead and Program Lead in a readable, section-by-section format, collect their corrections and augmentations, and produce a validated, signed-off knowledge base ready for the design phase.

This skill is complete when all sections of `knowledge.md` have been reviewed, corrected where needed, completeness gaps are logged, and the file is marked as validated.

---

## Phase 0 — Pre-Review Check

Before starting the review:

1. **Read `knowledge.md`** from the working directory. If it does not exist, inform the user and offer to initialize it or redirect to the appropriate extraction skills first.
2. **Read `features.md`** from the working directory. If it does not exist, note that no feature requirements have been captured yet.
3. **Assess completeness** — Check whether key sections are populated:
   - Program Context
   - Business Rules
   - Business Workflows
   - Customer Expectations
   - As-Is System
   - Constraints
   - Open Items
   - Feature Requirements (in features.md)
4. **Flag thin sections** — Any section with fewer than 3 substantive entries is flagged as potentially incomplete. Alert the user before proceeding.
5. **Check extraction sources** — Review the Change Log to determine which extraction skills have been run. If no meeting-extraction or doc-extraction has been run, warn the user.

Produce a **Pre-Review Status Report**:
```
## Knowledge Base Status
knowledge.md last updated: [date from change log]
features.md last updated: [date from change log, or NOT FOUND]

Sources ingested:
  ✓ / ✗  Documents parsed (doc-extraction)
  ✓ / ✗  Code analyzed (code-extraction)
  ✓ / ✗  Meetings processed (meeting-extraction)

knowledge.md section completeness:
  Program Context:       [POPULATED / SPARSE / EMPTY]
  Business Rules:        [POPULATED / SPARSE / EMPTY]
  Business Workflows:    [POPULATED / SPARSE / EMPTY]
  Customer Expectations: [POPULATED / SPARSE / EMPTY]
  As-Is System:          [POPULATED / SPARSE / EMPTY]
  Constraints:           [POPULATED / SPARSE / EMPTY]
  Open Items:            [POPULATED / SPARSE / EMPTY]

features.md:
  Feature count:         [n requirements captured / EMPTY]
  Uncategorized items:   [n / none]

Recommendation: [Proceed with review / Run additional extraction first]
```

Ask the user to confirm they want to proceed into the review session.

---

## Phase 1 — Section-by-Section Review

Present each section of `knowledge.md` to the user in sequence. For each section:

1. **Display the current content** in a clean, readable format (not raw markdown).
2. **Ask structured review questions** for that section.
3. **Collect corrections and additions** from the user.
4. **Confirm before moving to the next section.**

### Section 1: Program Context

Display all program context entries. Ask:

- Is the program name, objective, and scope accurately captured?
- Are the key stakeholders correct? Are any missing?
- Is the timeline accurate?
- Is there anything in this section that is wrong, outdated, or missing?

Accept corrections. Mark confirmed entries as `[REVIEWED: date]`.

---

### Section 2: Business Rules

Display all business rule entries. Ask:

- Is each rule accurately captured? Are the trigger, condition, and outcome correct?
- Are there rules that have changed since they were captured?
- Are there rules the customer operates by that are not yet documented?
- Are there rules marked `[NEEDS CLARIFICATION]` — have they been resolved?

Prompt specifically:
> "Think about edge cases and exceptions — are there scenarios where a rule behaves differently? Are those captured?"

---

### Section 3: Business Workflows

Display all captured workflows. For each workflow, ask:

- Are the steps in the correct sequence?
- Are the decision points, approvals, and exceptions accurately captured?
- Are there workflows that involve the new system that aren't documented here?
- Are there manual workarounds in the current process that the new system should eliminate?

---

### Section 4: Customer Expectations

Display all customer expectation entries. For each expectation, ask:

- Is this expectation still current and accurately worded?
- Has the customer's priority on this item changed since it was captured?
- Are there expectations from recent conversations that aren't captured here?

Additional prompt:
> "On a scale of certainty — which of these expectations are firm commitments vs. exploratory or speculative? Mark any you're unsure of."

Accept priority annotations: `[FIRM]`, `[EXPLORATORY]`, `[NEEDS VALIDATION]`.

---

### Section 5: As-Is System

Display all as-is system entries. Ask:

- Does this accurately describe how the existing system works?
- Are there behaviors, integrations, or data flows that are missing?
- Are there entries that are incorrect or based on outdated information?
- Are there any critical system dependencies not captured here?

Prompt specifically:
> "Think about: what would break if we ignore something in the current system? Is it captured?"

---

### Section 6: Constraints

Display all constraints. Ask:

- Are all technical constraints accurate? (mandated tech, hosting, performance SLAs)
- Are all regulatory or compliance constraints captured?
- Are there timeline or budget constraints not yet documented?
- Have any constraints changed or been relaxed since they were captured?

Accept removals, updates, and additions.

---

### Section 7: Open Items

Display all open items. For each item, ask:

- Has this been resolved? If so, what was the resolution?
- Is the assigned owner still correct?
- Are there new open items that emerged from recent meetings?

For resolved items, write the resolution and close the item: `[RESOLVED: date — resolution text]`.

For unresolved items critical to design, flag them: `[DESIGN BLOCKER]`.

---

### Section 8: Feature Requirements (features.md)

Switch to reviewing `features.md`. Display features grouped by category. For each feature, ask:

- Is this feature accurately described?
- Is the priority signal correct? (MUST HAVE / SHOULD HAVE / NICE TO HAVE)
- Are there features discussed in meetings that aren't captured here?
- Are there duplicate features that should be merged?
- Are there features in "Uncategorized" that can now be classified?

Prompt specifically:
> "Are there features here that the customer expressed strong opinions about — either as non-negotiable or as lower priority than captured?"

Accept reclassifications, corrections, additions, and merges. Write all changes back to `features.md`.

---

## Phase 2 — Gap Analysis

After all sections are reviewed, run a gap analysis against a standard program knowledge checklist:

```
## Knowledge Completeness Checklist

Business Layer
  [ ] Primary business objective is clearly stated
  [ ] Success criteria are measurable and agreed
  [ ] Key stakeholders with roles are identified
  [ ] Program timeline and key milestones are captured
  [ ] Core business rules are documented (triggers, conditions, exceptions)
  [ ] Primary business workflows are documented (steps, decision points, actors)

Feature Layer
  [ ] Feature requirements captured in features.md
  [ ] All features have a priority signal (MUST HAVE / SHOULD HAVE / NICE TO HAVE)
  [ ] No features remain in "Uncategorized" without a justification
  [ ] Feature requirements trace to customer expectations or pain points

System Layer
  [ ] Existing system components are documented
  [ ] Current user base and usage patterns are described
  [ ] Integration points with external systems are listed
  [ ] Data ownership and data flows are documented
  [ ] Current system pain points are captured

Technical Layer
  [ ] Technology stack of existing system is known
  [ ] Infrastructure and hosting model is documented
  [ ] Performance and availability characteristics are noted
  [ ] Security model and authentication mechanism are documented

Compliance & Constraints
  [ ] Regulatory requirements are captured
  [ ] Data residency requirements are noted
  [ ] Accessibility requirements are documented
  [ ] Budget and timeline constraints are bounded

Design Readiness
  [ ] No unresolved [DESIGN BLOCKER] open items remain
  [ ] Customer expectations are prioritized (FIRM / EXPLORATORY)
  [ ] All MUST HAVE features are clearly defined
  [ ] Constraints are unambiguous and agreed
```

For any unchecked items, ask the user:
- Is this information available and not yet captured? (→ capture it now)
- Is this genuinely unknown? (→ add as an Open Item for follow-up)
- Is this not applicable to this program? (→ mark N/A with rationale)

---

## Phase 3 — knowledge.md Rewrite

After all corrections are collected, rewrite `knowledge.md` and `features.md` incorporating:

1. All confirmed and corrected entries
2. All new entries added during the review
3. All resolved open items closed with resolutions
4. All expectation priority annotations
5. All feature priority corrections and reclassifications
6. Gap analysis findings (new open items for unknowns)

Add a validation stamp to the top of both files:

```markdown
# Program Knowledge Base
Last updated: [date]
**STATUS: REVIEWED ✓** — Reviewed by: [Pod Lead / Program Lead] on [date]
Review notes: [any overall notes from the review session]
---
```

Append a Change Log entry:
```
[Date] | Knowledge Review | Full review completed by [role]. [n] corrections, [n] additions, [n] items closed.
```

---

## Phase 4 — Design Readiness Assessment

Produce a final readiness report:

```
## Design Readiness Assessment
Review completed: [date]
Reviewed by: [role]

### Ready for Design
[List sections/domains that are well-understood and unambiguous]

### Proceed with Caution
[List areas with acknowledged uncertainty — design assumptions will need to be validated]

### Blockers (must resolve before design-setup)
[List any [DESIGN BLOCKER] items still open]

### Recommendation
[READY FOR DESIGN-SETUP] / [RESOLVE BLOCKERS FIRST] / [ADDITIONAL DISCOVERY NEEDED]
```

---

## Constraints

- Present content to the user in natural language — do NOT dump raw markdown at them. Render it readably.
- Do NOT ask more than one section's questions at a time. Wait for the user to respond before moving on.
- If the user says "looks good" or "correct" for a section, mark it reviewed and proceed.
- If the user provides a correction, read it back to confirm before writing it.
- Never delete existing entries during review — mark them as `[SUPERSEDED: date]` if replaced.
