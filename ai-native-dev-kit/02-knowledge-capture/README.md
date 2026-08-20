# Program Knowledge Capture — Skill Package

A coordinated suite of six skills designed to support Program Leads and Pod Leads in systematically capturing, organizing, and validating all knowledge produced during the **Initiation → Discovery → Design** phases of a software delivery program. Each skill is a discrete, triggerable unit that writes into a shared set of living documents.

---

## Architecture Overview

```
Program Kickoff
      │
      ▼
[requirements-elicitation-charter]  ← Charter + stakeholder interviews → questions list
      │
      ▼
[doc-extraction]     ← Customer-provided documents → knowledge.md, design.md, uiux.md
[code-extraction]    ← Legacy codebase → knowledge.md, design.md, api.md, database.md
[meeting-extraction] ← Meeting transcripts → knowledge.md (expectations + context)
      │
      ▼
[knowledge-review]   ← Present + validate knowledge.md with Pod/Program Lead
      │
      ▼
[design-setup]       ← Interactive to-be design session → design.md, uiux.md, api.md, database.md, impl.md
      │
      ▼
[spec-generation]    ← All design docs + features.md → specs/spec.md (epics+stories), specs/tasks.md (tasks)
```

---

## Shared Knowledge Documents

All skills read from and write to the following canonical files. These files live in the project workspace root.

| File | Purpose | Populated By |
|---|---|---|
| `knowledge.md` | Business knowledge base: program context, business rules, business workflows, as-is system, customer expectations, constraints, open items | doc-extraction, code-extraction, meeting-extraction, knowledge-review |
| `features.md` | To-be feature requirements: all capabilities and behaviors the new system must support, source-attributed and priority-tagged | meeting-extraction, doc-extraction |
| `design.md` | Technical design: as-is architecture (seed) + to-be technology stack, architecture decisions, and infrastructure | doc-extraction (seed), code-extraction (seed), meeting-extraction (to-be decisions), design-setup (authoritative) |
| `uiux.md` | UI/UX design direction: existing screens (as-is), to-be interaction model, flows, design system notes | doc-extraction (seed), design-setup (authoritative) |
| `api.md` | API surface: existing endpoints (as-is), to-be API contract, authentication model | code-extraction (seed), design-setup (authoritative) |
| `database.md` | Data model: existing schema (as-is), to-be entity model, migration considerations | code-extraction (seed), design-setup (authoritative) |
| `impl.md` | Implementation guidance: tech stack decisions, patterns, standards, scaffolding notes | design-setup (authoritative) |

> **Convention**: Sections marked `[AS-IS]` capture existing system reality. Sections marked `[TO-BE]` represent the designed target state. Never overwrite AS-IS content — append or annotate only.

---

## Skill Installation

Copy the skill folders from this package into your Claude skills directory:

```
/mnt/skills/user/
├── requirements-elicitation-charter/
│   └── SKILL.md
├── doc-extraction/
│   └── SKILL.md
├── code-extraction/
│   └── SKILL.md
├── meeting-extraction/
│   └── SKILL.md
├── knowledge-review/
│   └── SKILL.md
└── design-setup/
    └── SKILL.md
```

---

## Usage Workflow

### Step 1 — Program Initiation (requirements-elicitation-charter)

**Trigger**: "Help me prepare questions for the customer kickoff" or "We have a program charter, help me build discovery questions."

Provide the skill with any available program charter, SOW, or initial brief. It will:
- Parse the charter for known scope, objectives, and constraints
- Generate a structured question set organized by domain (business, technical, integration, UX, operations)
- Flag gaps and ambiguities that must be resolved in early customer meetings

**Output**: A ready-to-use interview question pack, saved as `questions-[date].md` if a filesystem is available.

---

### Step 2 — Document Ingestion (doc-extraction)

**Trigger**: "Extract information from this customer document" or "Parse this requirements doc and update our knowledge base."

Upload or reference any customer-provided document (Word, PDF, architecture diagrams descriptions, existing specs). The skill will:
- Summarize all relevant program knowledge → appends to `knowledge.md`
- Extract technical architecture details → seeds `design.md`
- Extract UI/UX details → seeds `uiux.md`
- Flag sections that conflict with existing knowledge

Run once per document batch. Re-run if new documents arrive.

---

### Step 3 — Code Ingestion (code-extraction)

**Trigger**: "Parse this legacy codebase" or "Extract knowledge from the existing code."

Provide legacy source files or a repository. The skill will:
- Document as-is system behavior → appends to `knowledge.md [AS-IS]`
- Extract API surface → seeds `api.md [AS-IS]`
- Extract data model → seeds `database.md [AS-IS]`
- Identify technical debt, patterns, and constraints relevant to migration

---

### Step 4 — Meeting Ingestion (meeting-extraction)

**Trigger**: "Summarize this meeting transcript" or "Extract customer expectations from this call."

Paste or upload a meeting transcript. The skill will:
- Produce a structured summary for Pod Lead and Program Lead
- Capture customer expectations, pain points, and explicit requests → appends to `knowledge.md`
- Surface open items, decisions made, and follow-ups required
- Flag contradictions with previously captured knowledge

---

### Step 5 — Knowledge Review (knowledge-review)

**Trigger**: "Review our knowledge base" or "Let's validate what we've captured so far."

The skill presents the contents of `knowledge.md` in a structured, section-by-section review format. For each section:
- Presents captured information in readable form
- Asks the Pod/Program Lead to confirm, correct, or augment
- Incorporates feedback and rewrites the affected sections

Run this before moving into the design phase to ensure the foundation is solid.

---

### Step 6 — Design Setup (design-setup)

**Trigger**: "Set up the technical design" or "Let's define the to-be architecture."

The skill reads the current state of `knowledge.md`, `design.md`, and `uiux.md`, then conducts a structured interactive session covering:
- Technology stack decisions
- System architecture pattern
- API design strategy
- Data model approach
- UI framework and design system
- Infrastructure and deployment model
- Security and compliance posture

All responses are written back into `design.md`, `uiux.md`, `api.md`, `database.md`, and `impl.md` as authoritative TO-BE content.

---

## Document Lifecycle

```
Initiation Phase
  └─ requirements-elicitation-charter → questions-[date].md

Discovery Phase (run in any order, multiple times)
  ├─ doc-extraction      → knowledge.md [AS-IS], design.md [seed], uiux.md [seed], features.md [if to-be content present]
  ├─ code-extraction     → knowledge.md [AS-IS], api.md [AS-IS], database.md [AS-IS]
  └─ meeting-extraction  → knowledge.md [business context, rules, workflows, constraints]
                           features.md [to-be feature requirements]
                           design.md   [to-be technology & architecture decisions]

Validation Phase
  └─ knowledge-review    → knowledge.md [validated], features.md [reviewed]

Design Phase
  └─ design-setup        → design.md [TO-BE authoritative], uiux.md [TO-BE],
                           api.md [TO-BE], database.md [TO-BE], impl.md [TO-BE]
```

---

## Notes for Pod Leads

- **Never edit knowledge.md manually between skill runs** — let the skills manage merges to avoid losing context.
- **Run meeting-extraction within 24 hours of each customer call** while context is fresh for validation.
- **knowledge-review is a checkpoint gate** — do not proceed to design-setup until knowledge-review is complete and signed off.
- **design-setup is destructive to TO-BE sections** — it will overwrite previous TO-BE content with the outcomes of the design session. AS-IS sections are preserved.

---

## Skill Dependencies

| Skill | Reads | Writes |
|---|---|---|
| requirements-elicitation-charter | Program charter / SOW (user-provided) | questions-[date].md |
| doc-extraction | Customer documents (user-provided), knowledge.md | knowledge.md, features.md, design.md, uiux.md |
| code-extraction | Source code (user-provided), knowledge.md | knowledge.md, api.md, database.md, design.md |
| meeting-extraction | Transcript (user-provided), knowledge.md, features.md, design.md | knowledge.md (business rules/workflows), features.md (to-be features), design.md (to-be tech decisions) |
| knowledge-review | knowledge.md, features.md | knowledge.md (validated), features.md (reviewed) |
| design-setup | knowledge.md, features.md, design.md, uiux.md | design.md, uiux.md, api.md, database.md, impl.md |
| spec-generation | knowledge.md, features.md, design.md, uiux.md, api.md, database.md, impl.md | specs/spec.md, specs/tasks.md |

---

### Step 7 — Spec Generation (spec-generation)

**Trigger**: "Generate the spec" or "Create the work breakdown" or "Build epics and tasks from the design."

Prerequisite: design-setup must be complete. design.md, uiux.md, and features.md should have TO-BE content.

The skill reads all source documents, derives a hierarchical work breakdown, and writes two delivery files:

- `specs/spec.md` — Full specification: epics, stories with acceptance criteria, business rules applied, technical notes, and dependencies
- `specs/tasks.md` — Complete task inventory: every task tagged by type, sized to 3 business days, with definition of done and source document references

Epic → Story → Task structure:
- **Epic**: Coherent deliverable slice of the system (3–8 stories). Tagged `[BUSINESS]`, `[TECHNICAL]`, `[MIGRATION]`, or `[INTEGRATION]`.
- **Story**: User-visible or system-testable outcome with acceptance criteria. Traces to a feature requirement, business rule, workflow, or NFR.
- **Task**: Single developer, 3 business days maximum. Tagged by type: `[DESIGN]` `[BACKEND]` `[FRONTEND]` `[DATA]` `[INTEGRATION]` `[TESTING]` `[INFRA]` `[DOCS]`.

Tasks blocked by unresolved design decisions are marked `[BLOCKED]` with the specific dependency noted.

