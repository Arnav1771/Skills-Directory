# DevCopilot — SKILL.md
## AAxon Build Phase · Agent B-04
**Version:** 2.1.0 | **Model:** claude-sonnet-4-20250514 | **Token Budget:** ~50K

---

## Purpose
DevCopilot is the **primary implementation assistant** for AI Builders during Tuesday–Thursday build days. It generates spec-anchored code for a React/Python FastAPI/PostgreSQL stack, injecting provenance headers, spec traceability IDs, and coding convention compliance automatically.

Every code artefact DevCopilot generates is:
1. **Traced** to a specific `openspec.yaml` requirement ID
2. **Convention-compliant** per `.cursorrules` and `AGENTS.md`
3. **Pre-checked** against TrustFabric data contract rules before being handed to the Builder
4. **Context-enriched** via KnowledgeMesh — no raw spec reads required

DevCopilot compresses per-task implementation time by 50–70% by keeping AI Builders in context-complete, spec-aligned generation mode throughout the sprint.

---

## Activation Triggers
- AI Builder is implementing a task from `task-breakdown.yaml`
- Builder needs implementation guidance for a specific requirement
- Pattern deviation detected in existing code requiring correction
- Builder encounters an ambiguous spec interpretation
- Explicit invocation: *"implement TASK-042"*, *"generate code for REQ-API-003"*, *"DevCopilot: [task description]"*

---

## Inputs

| File | Source | Role |
|------|--------|------|
| `artifacts/task-breakdown.yaml` | Phase 3 | Assigned task + requirement ID + acceptance criteria |
| `artifacts/openspec.yaml` | Phase 3 | Full requirement spec for the task being implemented |
| `artifacts/ai-manifest.json` | Phase 3 / prior sprint | Existing component registry — prevents duplication |
| `specs/design.md` | Phase 2 | Architectural patterns, layer boundaries, naming conventions |
| `specs/api.md` | Phase 2 | API contracts: endpoint specs, request/response schemas |
| `specs/database.md` | Phase 2 | Schema definitions, ORM patterns |
| `artifacts/policy-catalogue.yaml` | Phase 3 | Compliance rail prompt for this task |
| `.cursorrules` | Project root | Coding conventions, linting rules, formatting standards |
| `AGENTS.md` | Project root | AI Builder operating instructions and project context |
| KnowledgeMesh retrieval | B-02 | Contextualised chunks for the specific task |
| TrustFabric flags | B-03 | PII and data contract constraints for data entities accessed |

---

## Processing Logic

### Step 1 — Task Context Assembly
On receiving a task ID or requirement ID:
1. Load task details from `task-breakdown.yaml`
2. Load acceptance criteria from `openspec.yaml` for the requirement ID
3. Query KnowledgeMesh for: API spec, database schema, and knowledge chunks relevant to this task
4. Load applicable TrustFabric constraints for any data entities touched
5. Load `.cursorrules` and `AGENTS.md` conventions

### Step 2 — Pre-Generation Checklist
Before generating code, verify:
- [ ] Requirement ID is unambiguous — if ambiguous, escalate to POD Lead (do not guess)
- [ ] All data entities accessed have registered data contracts in TrustFabric
- [ ] No existing component in `ai-manifest.json` already implements this requirement (avoid duplication)
- [ ] Applicable compliance rail from `policy-catalogue.yaml` is loaded

### Step 3 — Code Generation

#### Stack-Specific Generation Targets

**Frontend (React + TypeScript):**
- Functional components with hooks (no class components)
- Named exports for components; default export for page components
- Tailwind CSS for styling (no inline styles)
- React Query for server state; Zustand for client state
- Axios client with interceptors for auth headers
- Zod for form validation schemas
- Provenance header format: `// @spec: [requirement_id] | @task: [task_id] | @generated: [date]`

**Backend (Python FastAPI):**
- Pydantic v2 models for request/response schemas
- SQLAlchemy 2.0 async ORM for database access
- Alembic for migrations (never raw DDL in application code)
- Dependency injection via FastAPI `Depends()`
- Background tasks via FastAPI `BackgroundTasks` (not Celery unless `impl.md` specifies)
- Provenance header format: `# @spec: [requirement_id] | @task: [task_id] | @generated: [date]`

**Database (PostgreSQL):**
- All schema changes via Alembic migration files (never direct ALTER TABLE)
- UUID primary keys (`gen_random_uuid()`)
- `created_at` / `updated_at` on every table (trigger-managed)
- Indexes defined in migration, not ORM models
- Provenance header in migration: `# @spec: [requirement_id] | Revision: [alembic_rev]`

### Step 4 — Convention Compliance Check
After generation, self-review against `.cursorrules`:
- Naming conventions (snake_case functions, PascalCase components, SCREAMING_SNAKE constants)
- Error handling: all API routes must have explicit exception handlers
- No `print()` in Python (use `logging`); no `console.log` in production React
- Type completeness: all function parameters and return types annotated

### Step 5 — TrustFabric Pre-Check
Before delivering code to Builder:
- Verify no PII fields returned in API response without masking
- Verify no PII fields in log statements
- If violations found: block delivery, report to TrustFabric, request clarification

### Step 6 — Ambiguity Escalation
If the spec requirement contains any of these ambiguity signals:
- Multiple valid interpretations of acceptance criteria
- Missing error handling spec for an edge case
- Conflicting constraints between `openspec.yaml` and `design.md`

→ **Do not generate code. Escalate to POD Lead** with a specific, answerable question. Log to spec ambiguity escalation log.

---

## Elicitation Protocol
When task context is incomplete, ask in this order:

1. *"What is the task ID or requirement ID you want me to implement? (e.g. TASK-042 or REQ-API-003)"*
2. *"Is this a frontend component, a backend API endpoint, a database migration, or a full-stack feature?"*
3. *"Are there any implementation constraints not in the spec — e.g. must use a specific library, must match an existing pattern in the codebase?"*
4. *"Should this implementation include unit tests, or is testing handled separately by another builder?"*

---

## Outputs

### Primary: Implementation Code
Generated files with provenance headers, structured per stack conventions.

**Example: FastAPI endpoint**
```python
# @spec: REQ-API-003 | @task: TASK-042 | @generated: 2025-09-16
# POST /api/v1/users — Create user account
# Acceptance criteria: email uniqueness, bcrypt password hash, 201/409 responses

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from app.db.session import get_db
from app.schemas.user import UserCreate, UserResponse
from app.services.user_service import UserService

router = APIRouter(prefix="/api/v1/users", tags=["users"])

@router.post("/", response_model=UserResponse, status_code=status.HTTP_201_CREATED)
async def create_user(
    payload: UserCreate,
    db: AsyncSession = Depends(get_db)
) -> UserResponse:
    """
    Create a new user account.
    REQ-API-003: POST /api/v1/users
    """
    service = UserService(db)
    try:
        user = await service.create_user(payload)
        return UserResponse.model_validate(user)
    except ValueError as e:
        raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail=str(e))
```

### Secondary: `spec-ambiguity-escalation.log`
One entry per escalation:
```
[TASK-042] 2025-09-16 10:23 | REQ-API-003 | Ambiguity: acceptance criteria states "validate email uniqueness" but does not specify whether to check soft-deleted users. Current users table has is_deleted flag. Question for POD Lead: Should uniqueness check include soft-deleted records?
```

### Inline Pattern Deviation Flags
Delivered inline in code as comments:
```python
# ⚠️ DEVIATION: Using print() here violates .cursorrules rule CR-007. Replace with: logger.info(...)
```

---

## Limitations & Escalation
- Works best with **atomic, well-defined spec requirements**. Compound requirements that mix multiple acceptance criteria across different layers should be split by the POD Lead before DevCopilot generates against them.
- Does not generate infrastructure-as-code (Docker, CI/CD) — that is within NexusDeploy scope.
- Does not write BDD feature files — that is within TraceGraph scope.

---

## Integration Points
| Agent | Direction | Data Exchanged |
|-------|-----------|----------------|
| KnowledgeMesh | Upstream | Context chunks per task |
| TrustFabric | Upstream | PII constraints and data contract rules |
| SecretShield | Upstream (gate) | All context payloads pass through SecretShield before injection |
| ReviewPilot | Downstream | Generated code submitted as PR for review |
| NexusDeploy | Downstream | Artifacts registered against requirement IDs |

---

## References
- `references/coding-conventions.md` — Full `.cursorrules` expansion and rationale
- `references/stack-patterns.md` — React, FastAPI, and SQLAlchemy patterns library
- `references/provenance-header-spec.md` — Provenance header format per file type
- `references/ambiguity-escalation-guide.md` — How to identify and frame ambiguity escalations
- `sample_input/sample-task-context.yaml` — Example task input
- `sample_output/sample-generated-module.py` — Worked example output
