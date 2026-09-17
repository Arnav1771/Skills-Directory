---
name: trust-fabric
description: Validates generated code modules against registered data contracts, blocking PII exposure and contract violations at code generation time rather than discovering them at QA.
---

# TrustFabric

**AAxon phase:** 03-Platform-Enablement (also active in 04-AI-Solution-Deployment for data governance attestation)

## Purpose

Enforces data contract governance and PII compliance at code generation time as an inline gate — validating every generated module that accesses a data entity against registered data contracts before acceptance into the sprint.

## Capabilities

- Data contract registry loading from data-contracts/*.yaml files
- Sprint data entity profiling identifying all entities accessed and checking contract registration
- Generated code validation: PII exposure, missing contract, role violation, retention breach, logging violation, unmasked display, missing encryption
- PII taxonomy enforcement across seven classification levels (IDENTITY, CONTACT, FINANCIAL, BEHAVIORAL, HEALTH, INTERNAL, NON-PII)
- Unclassified field flagging for POD Lead contract definition
- Release phase data governance attestation

## Owned Responsibilities

- Data contract governance at code generation time
- PII compliance enforcement before code acceptance
- Data governance attestation for Release gate

## Inputs

Mandatory:
    - specs/database.md: Schema definitions with all tables and fields
    - specs/api.md: API response schemas
    - artifacts/openspec.yaml: Sprint requirements with data access scope
    - artifacts/policy-catalogue.yaml: Compliance and privacy policies
    - data-contracts/*.yaml: Field-level PII classification and handling rules per entity
    - Generated code modules: Code submitted for governance review

## Outputs

- data-contract-compliance-report.md: Per-module violations, unclassified fields, compliant fields
- data-contract-violations.yaml: Machine-readable violations for PolicyCatalog and NexusDeploy
- unclassified-fields-report.md: New fields requiring POD Lead contract definition
- Release Phase attestation: Signed data governance sign-off

## Dependencies

- KnowledgeMesh: Provides data contract and schema context chunks
- DevCopilot: Upstream trigger submitting generated code for validation

## Constraints

- Cannot classify fields with no data contract definition; new entities require human contract definition before enforcement
- Does not perform runtime data sampling; classification based on schema and contract definitions only
- New fields in generated code without a contract entry block the module until POD Lead defines the contract

## Provenance

Auto-generated from AA's internal skill_catalog.md. This bundle captures the skill's documented contract (purpose, inputs, outputs, constraints) as a starting point for Claude API execution. It does NOT include the skill's original implementation logic/scripts (those live in the AAxon framework source, not in the catalog) — review and extend before relying on this for production output.
