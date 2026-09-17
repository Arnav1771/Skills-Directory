---
name: meeting-extraction
description: Processes customer meeting transcripts and routes extracted content to knowledge.md (business knowledge), features.md (feature requirements), and design.md (technology decisions) with conflict detection.
---

# meeting-extraction

**AAxon phase:** 01-Establish-Strategy

## Purpose

Processes meeting transcripts or call notes from customer sessions to extract structured knowledge, routing business context and rules to knowledge.md, feature requirements to features.md, and technology decisions to design.md, while flagging contradictions with existing knowledge.

## Capabilities

- Transcript intake and type classification (verbatim, AI summary, hand-written notes)
- Content classification into 13 routing categories with explicit routing rules
- Meeting brief generation for Pod Lead and Program Lead consumption
- knowledge.md update (business context, rules, workflows, as-is, expectations, constraints, open items)
- features.md update with sequentially numbered FR-n entries and priority signals
- design.md update for TO-BE technology and architecture decisions
- Post-write conflict detection with Conflict Report

## Owned Responsibilities

- Customer meeting knowledge extraction
- Feature requirement capture from customer conversations
- Meeting brief generation

## Inputs

Mandatory:
    - Meeting transcript, call notes, or meeting record: Verbatim, AI-generated, or hand-written
  Optional:
    - knowledge.md: Existing knowledge for conflict detection
    - features.md: Existing feature list for deduplication and FR number continuation
    - design.md: Existing design decisions for conflict detection

## Outputs

- Meeting brief with executive summary, business knowledge, pain points, features, decisions, open items, scope signals, risk signals, recommended actions
- Updates to knowledge.md
- Updates to features.md
- Updates to design.md

## Dependencies

- None

## Constraints

- Preserve customer voice; quote directly or paraphrase minimally
- Business rules must capture trigger, condition, and outcome precisely
- Features are capabilities, not implementation details
- Sensitive stakeholder observations go to meeting brief only, never to knowledge files

## Provenance

Auto-generated from AA's internal skill_catalog.md. This bundle captures the skill's documented contract (purpose, inputs, outputs, constraints) as a starting point for Claude API execution. It does NOT include the skill's original implementation logic/scripts (those live in the AAxon framework source, not in the catalog) — review and extend before relying on this for production output.
