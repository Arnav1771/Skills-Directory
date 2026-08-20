---
name: skill-flow
description: Analyzes completed Phase 01 initialization artifacts and the skill catalog to produce an evidence-backed recommendation plan classifying each Phase 02+ skill as Required, Recommended, Optional, or Not Recommended, with skill enhancement opportunities, confidence scores, and a minimal viable execution plan.
---

# SkillFlow

**AAxon phase:** 01-Establish-Strategy

## Purpose

Analyzes a project's completed Phase 01 initialization artifacts and the skill catalog to produce an evidence-backed recommendation plan determining which Phase 02+ skills to execute, enhance, skip, or extend — before execution begins.

## Capabilities

- Skill recommendation classification: Required, Recommended, Optional, Not Recommended
- Skill enhancement recommendation generation with specific placement guidance
- Phase assignment for each recommendation derived from catalog Phase field and dependency chains
- Coverage analysis of Phase 01 artifacts (Complete / Partial / Missing / Contradictory per artifact section)
- Confidence scoring across five factors: evidence strength, requirement coverage, catalog alignment, dependency certainty, input completeness
- Capability Classification Framework for gap resolution (Skill Enhancement vs. Candidate New Skill)
- End-to-end traceability from each recommendation to artifact evidence and requirement IDs

## Owned Responsibilities

- Phase 02+ skill execution planning
- Recommendation report and summary generation
- Skill enhancement identification against Phase 01 artifact gaps
- Capability gap classification and risk flagging

## Inputs

Mandatory:
    - catalog/skill_catalog.md: Authoritative skill catalog — sole source for all skill knowledge during recommendation analysis
    - specs/program.md: Program charter from Phase 01
    - specs/knowledge.md: Domain knowledge specification from Phase 01
    - specs/design.md: Technical design specification from Phase 01
    - specs/database.md: Database schema specification from Phase 01
    - specs/api.md: API specification from Phase 01
    - specs/ui-ux.md: UI/UX specification from Phase 01
  Optional:
    - specs/features.md: Feature requirements list for higher-precision gap mapping
    - specs/impl.md: Implementation guidance for technology-specific recommendations
    - recommendation_report.md (prior run): For planning continuity and avoiding duplication
    - recommendation_summary.md (prior run): For planning continuity
    - Additional project artifacts: Architecture decision records, prototype documents
    - Customer documents: Requirements specs, BRDs, compliance documentation
    - Meeting outputs: Stakeholder notes and transcripts for implicit requirement surfacing

## Outputs

- recommendation_report.md: Decision-support artifact with all recommendations, confidence scores, rationale, and traceability (1,000–2,000 words)
- recommendation_summary.md: Concise execution planning artifact with minimal viable execution plan and phase overview

## Dependencies

- program-charter: Provides specs/program.md
- spec-knowledge: Provides specs/knowledge.md
- spec-design: Provides specs/design.md
- spec-database: Provides specs/database.md
- spec-api: Provides specs/api.md
- spec-uiux: Provides specs/ui-ux.md

## Constraints

- All six Phase 01 artifacts must be present before execution; no partial runs permitted
- Uses skill_catalog.md exclusively for skill knowledge; never reads raw skill files during recommendation generation
- Does not create, modify, or execute skills; plans execution only
- Candidate New Skills identified as gaps are flagged in Risks & Gaps but not created (Version 1 limitation)
- Re-run required when Phase 01 artifacts are materially updated or when the catalog is refreshed with new skills
- Phase 01 skills (program-charter, spec-knowledge, spec-design, spec-database, spec-api, spec-uiux) are never included in recommendation output — their execution is assumed complete

## Provenance

Auto-generated from AA's internal skill_catalog.md. This bundle captures the skill's documented contract (purpose, inputs, outputs, constraints) as a starting point for Claude API execution. It does NOT include the skill's original implementation logic/scripts (those live in the AAxon framework source, not in the catalog) — review and extend before relying on this for production output.
