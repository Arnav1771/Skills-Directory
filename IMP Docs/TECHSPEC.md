# TECHSPEC — Skills-Directory (v3 · 2026-07-19)

> **What this doc is:** the technical specification. It describes the system's
> architecture and the *contract* every skill in this repo must satisfy. Rules:
> describe structure and interfaces (not narrative), stay authoritative on the
> skill standard, and cite the source of any external rule. Version-stamped.

## 1. Architecture overview
A **flat catalog**, not an application. Each top-level kebab-case folder is one
independent, self-contained skill. There is no runtime, no shared code, no build
graph — the "system" is the set of skill folders plus this documentation. The
consuming agent (Claude) is the runtime; the repo is a distribution source.

## 2. What a skill is (the standard)
Skills implement Anthropic's open **Agent Skills** standard — instructions
packaged as a folder, loaded via **progressive disclosure**:

| Level | Content | When loaded |
|-------|---------|-------------|
| 1 | `SKILL.md` YAML frontmatter (`name`, `description`) | always, in the system prompt |
| 2 | `SKILL.md` body | when the request matches the skill |
| 3 | Linked files (`references/`, `scripts/`, `assets/`) | on demand, as the agent needs them |

## 3. Skill folder contract
```
<skill-name>/                 # kebab-case; matches SKILL.md `name`
├── SKILL.md                  # REQUIRED — exact filename, case-sensitive
├── manifest.yaml             # optional — catalog/discovery metadata (see §4a)
├── scripts/                  # optional — executable helpers (bash/python)
├── references/               # optional — docs loaded on demand
├── assets/                   # optional — templates, icons, fonts for output
└── *.svg                     # optional — workflow diagram/infographic
```
Hard rules (from the skill-building guide):
- **No `README.md` inside a skill folder** — in-skill docs go in `SKILL.md`/`references/`.
- Folder name: kebab-case, no spaces/capitals/underscores, no `claude`/`anthropic` prefix.

## 4. `SKILL.md` frontmatter interface
```yaml
---
name: <kebab-case, matches folder>
description: <what it does AND when to trigger; includes user phrases; <1024 chars>
# optional:
metadata: { author: <name>, version: <semver> }
license: <MIT | Apache-2.0>
allowed-tools: "<space-separated tool restrictions>"
---
```
Constraints: `name` + `description` required; description **must** state *what* and
*when* and **must not** contain XML angle brackets (`<` `>`) — a frontmatter
security restriction (it appears verbatim in the system prompt).

## 4a. `manifest.yaml` interface (optional catalog metadata)
A separate, **human/catalog-facing** metadata layer. It is *not* part of the Agent
Skills runtime — Claude never reads it to decide triggering (that's `SKILL.md`
frontmatter, §4). Its sole purpose is discovery: grouping, tagging, versioning, and
cross-linking skills in the README catalog and any future skill browser. The schema
follows the convention popularized by community skill directories.
```yaml
name: <kebab-case, matches folder + SKILL.md name>
description: <one-line catalog card; same no-angle-bracket rule as SKILL.md>
categories: [<broad buckets: developer-tools | automation | testing | business | …>]
tags: [<free-form search keywords>]
icon: <Lucide icon name — https://lucide.dev/icons>
version: "<quoted string; mirrors SKILL.md metadata.version>"
composesWell: [<names of other skills in THIS repo that pair well>]
```
Constraints (enforced by `IMP Docs/validate_manifests.py`): all seven fields present;
`name` == folder; no `<`/`>` in `description`; `version` is a quoted string; every
`composesWell` entry resolves to a real skill folder. **Absence is valid** — a skill
without a `manifest.yaml` is still a complete, working skill.

The manifest also carries a `compat:` map — cross-agent portability, one key per
host (`claude-code`, `claude-ai`, `cursor`, `codex`, `copilot`, `gemini-cli`,
`windsurf`, `roo-code`) valued `full` | `partial` | `na`. Rendered and explained
in `AGENT_COMPAT.md`; `claude-code` must be `full` for every skill.

## 4b. Plugin marketplace (`.claude-plugin/marketplace.json`)
A repo-level [Claude Code marketplace](https://code.claude.com/docs/en/plugin-marketplaces)
manifest that makes every skill installable with `/plugin install
<name>@skills-directory`. Top level: `name`, `owner`, `plugins[]`. Each plugin
entry mirrors one skill: `name` (== folder), `source: "./"`, `skills:
["./<name>"]`, `strict: false` (no per-skill `plugin.json`), plus `description`,
`version`, `category`, `tags` mirrored from the manifest. Consistency (entry per
skill, skills path resolves, version/description match the manifest) is enforced
by `IMP Docs/validate_catalog.py`.

## 4c. Validation & trigger evals (repo tooling)
- `validate_manifests.py` — manifest schema/rules (§4a).
- `validate_catalog.py` — marketplace ↔ skill consistency + compat matrix.
- `eval_skills.py` + `skill_evals.yaml` — asserts each `SKILL.md` description
  still contains its intended trigger phrases (`should_trigger`), excludes other
  skills' phrases (`should_not`), and warns on cross-skill ambiguity. Matching is
  case-insensitive, word-boundary-aware, and deterministic (CI-safe).
- `run_checks.sh` runs all three. CI wiring is deferred until a `workflow`-scoped
  token exists (see `USE_CASES.md` #3).

## 5. Consumption surfaces (interfaces out)
| Surface | How the skill is installed | Invocation |
|---------|----------------------------|------------|
| Claude Code (marketplace) | `/plugin marketplace add Arnav1771/Skills-Directory` then `/plugin install <name>@skills-directory` | auto-trigger on match, or `/<name>` |
| Claude Code (manual) | copy folder to `~/.claude/skills/` (global) or `.claude/skills/` (project) | auto-trigger on match, or `/<name>` |
| Claude.ai | zip folder → Settings → Capabilities → Skills → Upload | auto-trigger on match |
| API | `container.skills` param (Messages API) / Agent SDK; requires Code Execution beta | programmatic |

## 6. Data / control flow
1. Agent loads all Level-1 descriptions at startup.
2. User request → agent matches it against descriptions → loads the winning skill's body (Level 2).
3. Body instructs the agent, optionally pointing to Level-3 files it reads/executes as needed.
4. Scripts run in the agent's environment (e.g. `mod` requires WSL); outputs feed back into the workflow.

## 7. Dependencies & build
- **None at repo level** — no package manager, lockfile, or CI. Skills are Markdown + optional scripts.
- Per-skill runtime needs are the skill's own contract (e.g. `mod` runs inside WSL and uses `git`/`gh`/Canary).

## 8. Distribution
Public GitHub repo under **Arnav1771**. Changes land on `main` via feature-branch
PRs (direct pushes to `main` are blocked). Consumers clone the repo (or download a
skill folder / ZIP) and install per §5.
