---
name: knowledge-review
description: Facilitates a structured section-by-section review of the knowledge base with the Pod Lead, producing a validated and signed-off knowledge.md with design readiness assessment.
---

# knowledge-review

**AAxon phase:** 01-Establish-Strategy

## Purpose

Presents the accumulated knowledge base to the Pod Lead or Program Lead for structured section-by-section review, correction, and sign-off, then produces a validated knowledge.md with REVIEWED status and a design readiness assessment before the design phase begins.

## Capabilities

- Section-by-section review across seven knowledge domains and features.md
- Business completeness checklist gap analysis
- knowledge.md and features.md rewrite incorporating all corrections and additions
- Expectation priority annotation (FIRM / EXPLORATORY / NEEDS VALIDATION)
- Open item resolution with [RESOLVED: date] or [DESIGN BLOCKER] flagging
- Design Readiness Assessment with READY / RESOLVE BLOCKERS / ADDITIONAL DISCOVERY recommendation

## Owned Responsibilities

- Knowledge base validation gate before design phase
- Design readiness assessment

## Inputs

Mandatory:
    - knowledge.md: Accumulated knowledge base to review
  Optional:
    - features.md: Feature requirements for review

## Outputs

- Validated knowledge.md with STATUS: REVIEWED ✓ stamp
- Updated features.md with corrected priority signals
- Design Readiness Assessment

## Dependencies

- doc-extraction: Prior extraction step (checked for completeness, not hard required)
- code-extraction: Prior extraction step (checked for completeness, not hard required)
- meeting-extraction: Prior extraction step (checked for completeness, not hard required)

## Constraints

- Presents content in natural language, not raw markdown
- Never deletes existing entries — marks as [SUPERSEDED: date]
- Mandatory checkpoint before design-setup; design-setup warns if this skill has not been completed

## Provenance

Auto-generated from AA's internal skill_catalog.md. This bundle captures the skill's documented contract (purpose, inputs, outputs, constraints) as a starting point for Claude API execution. It does NOT include the skill's original implementation logic/scripts (those live in the AAxon framework source, not in the catalog) — review and extend before relying on this for production output.
