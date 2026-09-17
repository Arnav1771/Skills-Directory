---
name: requirements-elicitation-charter
description: Analyzes a program charter to identify knowledge gaps and assumptions, generating a structured question pack across eight domains for customer discovery meetings.
---

# requirements-elicitation-charter

**AAxon phase:** 01-Establish-Strategy

## Purpose

Reads a program charter or equivalent initiating document and generates a disciplined, domain-organized question pack that a Program Lead or Pod Lead can use in early customer meetings to close knowledge gaps and validate assumptions.

## Capabilities

- Charter analysis producing confirmed facts, implicit assumptions, identified gaps, and conflict flags
- Question pack generation across eight domains: business context, existing system, functional requirements, technical/integration constraints, data and migration, UI/UX, organizational/delivery, open charter issues
- Gap reference labeling (GAP-n) and intent notes per question
- Charter ambiguity flagging and recommended meeting sequence

## Owned Responsibilities

- Pre-meeting discovery question generation
- Charter gap and conflict identification

## Inputs

Mandatory:
    - Program charter, SOW, or equivalent initiating document

## Outputs

- questions-[YYYY-MM-DD].md: Domain-organized question pack with charter analysis summary and flagged ambiguities

## Dependencies

- program-charter: Charter or equivalent document must exist as input

## Constraints

- Every question must trace to a specific charter gap or assumption; no generic boilerplate
- Maximum 8–10 questions per domain; quality over volume
- Sensitive questions (budget, challenging prior decisions) flagged with [SENSITIVE] marker
- If charter is very thin (< 1 page), states this explicitly and asks whether to proceed with inference-heavy questions

## Provenance

Auto-generated from AA's internal skill_catalog.md. This bundle captures the skill's documented contract (purpose, inputs, outputs, constraints) as a starting point for Claude API execution. It does NOT include the skill's original implementation logic/scripts (those live in the AAxon framework source, not in the catalog) — review and extend before relying on this for production output.
