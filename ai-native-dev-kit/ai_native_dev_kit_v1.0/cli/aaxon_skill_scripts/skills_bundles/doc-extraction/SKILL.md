---
name: doc-extraction
description: Parses customer-provided documents and routes structured knowledge into knowledge.md, design.md, and uiux.md with source attribution and conflict flagging.
---

# doc-extraction

**AAxon phase:** 01-Establish-Strategy

## Purpose

Parses and extracts structured knowledge from customer-provided documents into the program knowledge base, routing each piece of content to the correct knowledge file and flagging conflicts with existing entries for human resolution.

## Capabilities

- Document intake and type classification (requirements spec, architecture doc, BRD, functional spec, data dictionary, compliance doc, UI/UX specification, etc.)
- Content classification into routing categories (context, expectations, as-is system, architecture, data, API, UI, constraints, open items, to-be requirements)
- Conflict detection (direct conflict, extension, duplication, new content)
- knowledge.md update with source attribution and category tagging
- design.md update for AS-IS architectural content
- uiux.md update for AS-IS UI content
- Extraction report with conflict summary and follow-up questions

## Owned Responsibilities

- Document-sourced knowledge extraction and routing
- Conflict detection and flagging for human resolution

## Inputs

Mandatory:
    - Customer-provided document: Any of — requirements spec, architecture spec, BRD, functional spec, data dictionary, compliance doc, wireframe descriptions, PDF/Word file
  Optional:
    - knowledge.md: Existing knowledge for conflict detection
    - design.md: Existing design for conflict detection
    - uiux.md: Existing UI spec for conflict detection

## Outputs

- Updates to knowledge.md (context, expectations, as-is system, constraints, open items sections)
- Updates to design.md (AS-IS ARCHITECTURE section, if technical content found)
- Updates to uiux.md (AS-IS UI & UX section, if UI content found)
- Extraction Report with conflict summary and follow-up question recommendations

## Dependencies

- None

## Constraints

- Preserve original customer language in knowledge.md; do not paraphrase customer expectations
- Never write speculative content without [INFERRED] tag
- To-be requirements from documents go to knowledge.md [EXPECTATIONS] only; not to design files
- Documents over 50 pages: process section by section with user confirmation

## Provenance

Auto-generated from AA's internal skill_catalog.md. This bundle captures the skill's documented contract (purpose, inputs, outputs, constraints) as a starting point for Claude API execution. It does NOT include the skill's original implementation logic/scripts (those live in the AAxon framework source, not in the catalog) — review and extend before relying on this for production output.
