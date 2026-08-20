# AI Program Skills — User Guide

A suite of Claude skills for structuring, specifying, and maintaining software programs with AI collaboration. Each skill guides you through a focused elicitation session and produces a living specification file your AI pods use as a single source of truth.

---

## How It Works

You describe your program to Claude in natural language. The skills ask the right questions, infer what they can, and generate structured specification files. Those files then govern every AI-assisted coding session — no pod reinvents decisions already made in a spec.

```
You describe the program
        ↓
  program-charter   →   specs/program.md  +  folder scaffold
        ↓
  spec-knowledge    →   specs/knowledge.md   (domain entities, business rules)
        ↓
  spec-design       →   specs/design.md      (tech stack, frameworks, infra)
  spec-uiux         →   specs/ui-ux.md       (components, tokens, motion)
        ↓
  spec-database     →   specs/database.md    (schema, tables, indexes)
  spec-api          →   specs/api.md         (REST endpoints, Pydantic schemas)
```

---

## Quick Start

### Step 1 — Install the skills

Extract `spec-skills-suite.zip` into your project root. The `.claude/` folder must sit at the project root alongside `src/` and `tests/`.

```
your-project/
└── .claude/
    ├── program-charter/
    ├── spec-knowledge/
    ├── spec-design/
    ├── spec-uiux/
    ├── spec-database/
    └── spec-api/
```

### Step 2 — Initialize your program

Open a Claude chat in your project and say:

```
initialize program
```

Claude will interview you across five topic groups (Foundation, Scope, Architecture, Design, Delivery) and generate `specs/program.md` plus stub files for all other specs.

### Step 3 — Populate specs in order

Run each spec skill in the recommended sequence. Each one builds on the last.

```
spec-knowledge  →  spec-design  →  spec-uiux  →  spec-database  →  spec-api
```

To run any skill, just describe what you want to do in natural language. Examples are in the [Trigger Phrases](#trigger-phrases) section below.

---

## The Spec Files

All specification files live in `specs/`. They are the **single source of truth** for your program. AI coding sessions read the relevant spec before generating or modifying code.

| File | Skill | Purpose | Who Reads It |
|------|-------|---------|--------------|
| `specs/program.md` | `program-charter` | Program charter: goals, stakeholders, timeline, scope | Everyone |
| `specs/knowledge.md` | `spec-knowledge` | Domain entities, business rules, state machines, glossary | All pods |
| `specs/design.md` | `spec-design` | Tech stack, frameworks, libraries, infra, coding standards | Backend, Frontend |
| `specs/ui-ux.md` | `spec-uiux` | Design tokens, components, motion, accessibility | Frontend pod |
| `specs/database.md` | `spec-database` | Schema, tables/collections, indexes, migrations | Backend, Data pods |
| `specs/api.md` | `spec-api` | REST endpoints, request/response schemas, auth contract | Backend, Frontend |

> **Rule:** Code conforms to specs, not the other way around. If you need to change a technical decision, update the spec first using the skill, then update the code.

---

## Skills Reference

---

### `program-charter`

**What it does:** Runs a structured elicitation interview and produces `specs/program.md` — the foundational charter for the program. Also scaffolds the full project folder structure and creates stub spec files.

**When to use it:** Always first. No other spec should be created before `program.md` exists.

**Trigger phrases:**
```
initialize program
start a new program
create a program charter
set up a program for [description]
```

**Also accepts an existing charter** — upload a `.md` file and say "adapt this into a program charter."

**What gets created:**
```
specs/program.md        ← full charter
specs/knowledge.md      ← stub (pending)
specs/design.md         ← stub (pending)
specs/ui-ux.md          ← stub (pending)
specs/database.md       ← stub (pending)
specs/api.md            ← stub (pending)
src/
tests/
CLAUDE.md
```

**Elicitation covers:** Program name & lead, problem statement, business impact, target users, scope (in/out), KPIs, system domains, architecture decisions, NFRs, team/pod structure, user journey, design highlights, timeline, milestones, risks, stakeholders.

---

### `spec-knowledge`

**What it does:** Captures the domain knowledge layer — the business entities, rules, state machines, workflows, and glossary that all pods must understand to build correctly. This is the shared vocabulary for the program.

**When to use it:** Immediately after `program-charter`. All other specs depend on this one.

**Trigger phrases:**
```
update knowledge
review knowledge spec
add domain knowledge
capture business rules
document domain concepts
what are the business rules for [entity]
```

**Elicitation covers:**
- Core entities (name, attributes, relationships, lifecycle states)
- Business rules (numbered, traceable, grouped by entity)
- State machines (transitions, guards, triggers)
- Key workflows (step-by-step, actors, error paths)
- Constraints & compliance (regulatory, contractual)
- Glossary (canonical term definitions)

**Downstream impact:** Changes here may require updates to `design.md`, `database.md`, and `api.md`.

---

### `spec-design`

**What it does:** Defines the technical blueprint — programming language, frameworks, libraries, infrastructure, CI/CD, coding standards, security design, and observability strategy.

**When to use it:** After `spec-knowledge`. Before any coding begins or when technology decisions change.

**Trigger phrases:**
```
update design spec
review technical design
choose the tech stack
define the architecture
what libraries should we use
update specs/design.md
```

**Elicitation covers:**
- Language & runtime (backend, frontend)
- Frameworks (FastAPI, React, etc.) and key libraries per category
- Infrastructure (cloud provider, containers, CI/CD, environments)
- Coding standards (linting, formatting, naming, documentation)
- Security design (auth model, secret management, input validation)
- Observability (logging, tracing, metrics, alerting)

**Downstream impact:** Framework and ORM choices affect `database.md`; auth choices affect `api.md`.

---

### `spec-uiux`

**What it does:** Defines the design system and interaction standards shared across all features — design tokens, component library, motion system, layout grid, accessibility rules, and copy guidelines.

**When to use it:** After `spec-design`. Created once; referenced by all frontend work. Update when new component types or design decisions are introduced.

**Trigger phrases:**
```
update UI spec
define the design system
set up components
choose colors and fonts
define buttons and inputs
review UI components
define transitions
```

**Elicitation covers:**
- Design tokens (color palette, typography scale, spacing, border radius, elevation)
- Core components: Button, Input, Form, Navigation, Modal, Toast, Loading states, Empty states
- Motion system (duration scale, easing curves, standard transitions)
- Layout system (grid, breakpoints, touch targets, safe areas)
- Accessibility standards (WCAG level, focus management, ARIA patterns)
- Copy & tone guidelines

> `ui-ux.md` is **program-scoped, not feature-scoped**. It is the single design reference for every screen.

---

### `spec-database`

**What it does:** Defines the complete database schema — tables, columns, data types, constraints, indexes, relationships, migration strategy, and compliance handling. Supports both relational databases (PostgreSQL, MySQL) and document databases (MongoDB, DynamoDB, Firestore).

**When to use it:** After `spec-knowledge` and `spec-design`. Before any backend model or migration code is written.

**Trigger phrases:**
```
update database spec
define the schema
add a table
model the data
define collections
add indexes
update specs/database.md
```

**Elicitation covers:**
- Database platform (engine, hosting, ORM, migration tool)
- Schema design (derived from `knowledge.md` entities)
- Relational: tables, columns, types, constraints, foreign keys, soft delete, audit fields
- Document: JSON Schema / BSON structure per collection
- Indexes (high-frequency query patterns)
- Data retention & compliance (PII fields, GDPR erasure, encryption at rest)

**Downstream impact:** New tables trigger `api.md` review for new endpoints.

---

### `spec-api`

**What it does:** Defines the complete backend REST API — all endpoints, HTTP methods, request/response Pydantic schemas, authentication strategy, error contract, rate limits, and FastAPI implementation patterns. The spec is code-ready: schemas can be pasted directly into `src/`.

**When to use it:** After `spec-database`. Before any backend route code is written.

**Trigger phrases:**
```
update API spec
define endpoints
add an API route
document the REST API
generate FastAPI routes
define request and response schemas
update specs/api.md
```

**Elicitation covers:**
- API foundation (base URL, versioning, CORS)
- Authentication (JWT/OAuth2/API Key, token lifecycle)
- Endpoint design (derived from `knowledge.md` entities and workflows)
- Request/response conventions (pagination, date format, null handling)
- Error contract (standard error schema, HTTP status code map)
- Rate limiting strategy

**Output includes:** Full Pydantic schema definitions, FastAPI router pattern, JWT dependency injection signature, and rate limit header specification.

---

## Updating Specs

Every spec skill supports two modes automatically:

**Initialize mode** — runs the first time a spec file doesn't exist yet. Full elicitation interview.

**Review mode** — runs when the spec file already exists. Targeted gap analysis and surgical updates. Claude will:
1. Scan the existing file for gaps or stale content
2. Ask "what changed since this was last updated?"
3. Make precise edits — never rewrite sections that are still accurate
4. Append a `## Changelog` entry with the date and summary

To update any spec, simply use the same trigger phrases as initialization. The skill detects the existing file automatically.

---

## Recommended Workflow

### Starting a new program

```
1.  initialize program                    → specs/program.md + folder scaffold
2.  update knowledge                      → specs/knowledge.md
3.  update design spec                    → specs/design.md
4.  update UI spec                  ┐
5.  update database spec            ├──  can run in parallel
6.  (skip api for now if not ready) ┘
7.  update API spec                       → specs/api.md
8.  Begin pod coding sessions
```

### Adding a new feature

```
1.  review knowledge spec                 → confirm entity/rule coverage
2.  update database spec (if new tables)  → add schema changes
3.  update API spec (if new endpoints)    → add endpoint definitions
4.  Begin feature implementation
```

### Onboarding a new AI pod session

Every new Claude coding session should start with:
```
Read specs/program.md, specs/knowledge.md, and specs/[relevant-spec].md before proceeding.
```
The `CLAUDE.md` file in your project root encodes this as a standing instruction.

---

## Project Structure Reference

After full initialization, your project looks like this:

```
your-project/
├── specs/
│   ├── program.md       ← program charter
│   ├── knowledge.md     ← domain knowledge
│   ├── design.md        ← technical design
│   ├── ui-ux.md         ← UI/UX design system
│   ├── database.md      ← database schema
│   └── api.md           ← REST API contract
│
├── src/                 ← application source code
├── tests/               ← test suites (mirrors src/ structure)
│
├── CLAUDE.md            ← AI collaboration guide (auto-generated)
│
└── .claude/
    ├── program-charter/ ← skill: initialize program
    ├── spec-knowledge/  ← skill: domain knowledge
    ├── spec-design/     ← skill: technical design
    ├── spec-uiux/       ← skill: UI/UX spec
    ├── spec-database/   ← skill: database schema
    └── spec-api/        ← skill: API contract
```

Each skill folder contains:
- `SKILL.md` — the skill instructions Claude reads
- `references/` — canonical templates for generated files
- `sample_output/` — worked examples from the Mobile Checkout reference program

---

## Tips

**Let Claude infer from context.** If you've already described your stack or domain in conversation, the skill will extract what it can and confirm rather than asking redundant questions.

**Upload existing documents.** You can upload a PRD, architecture doc, or existing spec and say "use this to populate [spec name]." The skill will extract what it can and ask only for what's missing.

**Specs are living documents.** Update them whenever decisions change. Running a spec skill mid-program is normal — it's how specs stay accurate as you learn.

**Cross-spec coherence.** When a skill detects that your change in one spec has implications for another (e.g., a new entity in `knowledge.md` implies new tables and endpoints), it will tell you which specs to review next.

**Start narrow, expand.** You don't need a complete spec on day one. Initialize with what you know, mark uncertain sections with `TODO:`, and run the review mode as decisions solidify.

---

## Trigger Phrases Summary

| To do this... | Say this |
|---------------|----------|
| Start a new program | `initialize program` |
| Add / update domain knowledge | `update knowledge` or `review knowledge spec` |
| Set the tech stack and architecture | `update design spec` or `choose the tech stack` |
| Define UI components and design tokens | `update UI spec` or `define the design system` |
| Design the database schema | `update database spec` or `define the schema` |
| Define API endpoints | `update API spec` or `define endpoints` |
| Add a new entity | `update knowledge` then `update database spec` |
| Add a new API endpoint | `update API spec` — `add an API route for [description]` |
| Onboard a new AI coding session | Tell it: `read specs/program.md and specs/[relevant].md first` |
