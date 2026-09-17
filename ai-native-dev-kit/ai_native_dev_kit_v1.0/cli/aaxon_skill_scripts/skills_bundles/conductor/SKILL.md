---
name: conductor
description: Orchestrates sprint task dispatch by mapping tasks to AI Builders, enforcing HITL gates, and maintaining the live sprint board throughout the sprint week.
---

# Conductor

**AAxon phase:** 02-Data-Readiness

## Purpose

Central cross-phase sprint orchestrator that reads all planning artifacts, maps every task to the correct AI Builder and accelerator skill, sequences dispatch respecting inter-agent dependencies, holds dispatch until HITL gates are cleared, and maintains the live sprint board throughout the sprint.

## Capabilities

- Pre-flight validation of all required input files and gate status
- Task-to-builder mapping using capability matrix
- Dependency resolution and BLOCKED task flagging
- Sprint board generation with task status tracking
- Dispatch log with timestamped events
- Completion forecast calculation
- Escalation on task failure, HITL timeout, and mid-sprint spec change

## Owned Responsibilities

- Sprint task dispatch orchestration
- AI Builder coordination and load balancing
- HITL gate enforcement (never bypasses)
- Sprint board state management
- Escalation management

## Inputs

Mandatory:
    - artifacts/openspec.yaml: Sprint requirements
    - artifacts/task-breakdown.yaml: Task cluster definitions (from SpecFlow)
    - artifacts/ai-manifest.json: Component registry (from SpecFlow)
    - artifacts/policy-catalogue.yaml: Compliance rails (from PolicyCatalog)
    - artifacts/traceability-report.md: Traceability verification (from TraceGraph)
    - artifacts/sprint-scope-ranked.md: Ranked scope list (from PortfolioPrioritizer)
    - artifacts/assumption-log.md: HITL blocker status (from AssumptionTracker)
    - artifacts/decision-ledger.md: Decision audit trail (from DecisionLedger)
    - specs/tasks.md: Task inventory from prior phase
    - specs/program.md: Program charter from prior phase
  Optional:
    - artifacts/context.yaml: Enterprise context (from ContextFabric)
    - artifacts/impact-analysis.md: Spec change impact (from SpecImpactAnalyzer)
    - artifacts/rework-scope-patch.yaml: Re-queue list (from SpecImpactAnalyzer)

## Outputs

- artifacts/sprint-board.md: Live task board with builder assignments and status
- artifacts/dispatch-log.md: Append-only timestamped dispatch event log

## Dependencies

- SpecFlow: Provides task-breakdown.yaml and ai-manifest.json
- PolicyCatalog: Provides policy-catalogue.yaml
- TraceGraph: Provides traceability-report.md
- PortfolioPrioritizer: Provides sprint-scope-ranked.md
- AssumptionTracker: Provides assumption-log.md
- DecisionLedger: Provides decision-ledger.md
- ContextFabric: Provides context.yaml (optional)
- SpecImpactAnalyzer: Provides impact-analysis.md and rework-scope-patch.yaml (if spec changed)

## Constraints

- Never bypasses a HITL gate; queues and waits for POD Lead confirmation
- Requires Gate 1 (Plan Sign-off) clearance before any dispatch
- Open HITL blockers in assumption-log.md halt all dispatch
- Re-routing decisions on failed tasks are suggestions; POD Lead makes the final call

## Provenance

Auto-generated from AA's internal skill_catalog.md. This bundle captures the skill's documented contract (purpose, inputs, outputs, constraints) as a starting point for Claude API execution. It does NOT include the skill's original implementation logic/scripts (those live in the AAxon framework source, not in the catalog) — review and extend before relying on this for production output.
