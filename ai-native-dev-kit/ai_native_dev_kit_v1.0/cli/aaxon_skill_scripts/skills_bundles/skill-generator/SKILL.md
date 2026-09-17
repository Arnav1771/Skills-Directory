---
name: skill-generator
description: Executes the unresolved recommendations from SkillFlow by creating new skill files, applying enhancements to existing ones, keeping the catalog in sync, and maintaining the execution skip list — all with user confirmation gates before any file is written.
---

# SkillGenerator

**AAxon phase:** Post-SkillFlow (pre-Phase-02 execution)

## Purpose

Materializes unresolved SkillFlow recommendations into actual skill files. Consumes `recommendation_report.md` produced by SkillFlow and creates or patches `.claude/` skill files — generating new `SKILL.md` and `README.md` for Candidate New Skills, and inserting enhancements into existing skill files — then updates `skill_catalog.md` to keep the catalog in sync after every change. Rejected skills are written to `skillflow_skip.md` so prompt files can gate execution without being modified.

## Capabilities

- Recommendation extraction from recommendation_report.md (Skill Enhancements and Candidate New Skills)
- User-gated recommendation review with per-item accept/reject control
- Assumptions review per accepted item before any generation begins
- New SKILL.md generation from confirmed assumptions and SkillFlow evidence chain
- New README.md generation alongside every new skill
- Precision enhancement patching into existing SKILL.md at confirmed placement location
- README.md update for enhanced skills
- skill_catalog.md entry addition for new skills
- skill_catalog.md entry update for enhanced skills
- skillflow_skip.md maintenance for rejected skills
- skill_generation_report.md production as a run audit log

## Owned Responsibilities

- Candidate New Skill file creation (.claude/<skill-name>/SKILL.md and README.md)
- Skill Enhancement application to existing skill files
- Skill catalog synchronization after every creation or enhancement
- Execution skip list management via skillflow_skip.md

## Inputs

Mandatory:
    - recommendation_report.md: Produced by SkillFlow. Must contain Skill Enhancements and/or Candidate New Skills.
    - skill_catalog.md: Current skill catalog. Must be present and valid before catalog updates are made.
  Optional:
    - recommendation_summary.md: Used for cross-reference when report content is ambiguous.
    - skillflow_skip.md (prior run): Loaded to avoid overwriting existing skip decisions.

## Outputs

- .claude/<skill-name>/SKILL.md: New skill definition file (new skills only)
- .claude/<skill-name>/README.md: New or updated README for the skill
- skill_catalog.md: Updated with new entries or modified existing entries
- skillflow_skip.md: Updated with names of skills the user chose to skip
- skill_generation_report.md: Audit log of the run — created, modified, skipped, errors

## Dependencies

- SkillFlow: Produces recommendation_report.md — required upstream input
- skill-catalog-generator: Produces skill_catalog.md — required before catalog updates can be made

## Constraints

- No file is written without explicit user confirmation at the Phase 6 final review gate
- No content is generated without confirmed assumptions from the user at Phase 3
- skillflow_skip.md is only written with explicit user permission
- Does not create or modify prompt files — original prompt files are never touched
- skill_catalog.md must be present and valid; this skill does not generate the catalog from scratch

## Provenance

Auto-generated from AA's internal skill_catalog.md. This bundle captures the skill's documented contract (purpose, inputs, outputs, constraints) as a starting point for Claude API execution. It does NOT include the skill's original implementation logic/scripts (those live in the AAxon framework source, not in the catalog) — review and extend before relying on this for production output.
