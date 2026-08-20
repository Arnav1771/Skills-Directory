---
name: decision-ledger
description: Maintains an immutable append-only audit log of all sprint scope, spec, and gate decisions with timestamps and approver attribution, queryable by requirement ID or date.
---

# DecisionLedger

**AAxon phase:** 02-Data-Readiness (invoked on-demand throughout the sprint)

## Purpose

Captures every scope, spec, and HITL gate decision made during the sprint in a structured, append-only log — timestamped, linked to requirement IDs, and attributed to a named approver — and produces official attestation records for all HITL gates.

## Capabilities

- Append-only decision entry creation with auto-incrementing IDs
- Decision types: scope-change, spec-change, defer, descope, gate-clearance, risk-acceptance, assumption-resolution
- Query by requirement ID, date range, approver, or type
- Superseded entry marking (prior decisions marked but never deleted)
- Sprint summary report generation (business-lead-ready)
- HITL gate attestation record production

## Owned Responsibilities

- Immutable sprint decision audit trail
- HITL gate attestation records
- Decision traceability by requirement ID

## Inputs

Mandatory:
    - artifacts/openspec.yaml: For REQ-ID validation
  Optional:
    - artifacts/decision-ledger.md: Prior run file for append mode
    - artifacts/impact-analysis.md: For spec change entries
    - artifacts/sprint-scope-ranked.md: For defer entries

## Outputs

- artifacts/decision-ledger.md: Append-only timestamped decision log
- artifacts/decision-summary.md: Business-lead-ready sprint decision summary

## Dependencies

- SpecImpactAnalyzer: Provides impact-analysis.md for spec change entries
- PortfolioPrioritizer: Provides sprint-scope-ranked.md for defer entries

## Constraints

- Never modifies or deletes entries; corrections are new entries that supersede prior ones
- Verbal-only decisions that bypass the system leave no trace; POD Lead must log them manually
- Append-only integrity must be enforced by POD Lead outside of DecisionLedger invocations

## Provenance

Auto-generated from AA's internal skill_catalog.md. This bundle captures the skill's documented contract (purpose, inputs, outputs, constraints) as a starting point for Claude API execution. It does NOT include the skill's original implementation logic/scripts (those live in the AAxon framework source, not in the catalog) — review and extend before relying on this for production output.
