# PORTABILITY — installing skills into any agent CLI (v1 · 2026-07-19)

> **What this doc is:** how a Claude-format skill in this repo is made to load in
> other agent CLIs, and exactly where each tool expects its files. Authoritative
> on the exporter/installer contract. Version-stamped.

## The problem

A skill here is a Claude **`SKILL.md`** in a folder. Only Claude Code / Claude.ai
recognize that. Other CLIs read instructions from their own locations and formats,
so copying `SKILL.md` elsewhere does nothing. This is why a raw copy into another
tool fails.

## Where each tool reads instructions

| Tool | Location | Format |
|------|----------|--------|
| **Claude Code** | `~/.claude/skills/<name>/` (global) or `.claude/skills/<name>/` (project); or the plugin marketplace | native `SKILL.md` folder |
| **Cursor** | `.cursor/rules/<name>.mdc` | markdown **+ required YAML frontmatter** (`description`, `globs`, `alwaysApply`); a plain `.md` is ignored |
| **Windsurf** | `.windsurf/rules/<name>.md` | markdown; filename = rule id; **≤ 12,000 chars** per file |
| **Gemini CLI** | `GEMINI.md` (project/cwd) or `~/.gemini/GEMINI.md` (global) | plain markdown, concatenated up the tree |
| **Codex, Aider, opencode, Copilot, Roo, Zed, Amp, Jules, Q, …** | `AGENTS.md` (repo root) or `~/.codex/AGENTS.md` | the open [AGENTS.md](https://agents.md) standard — plain markdown |

## How the port works

`scripts/export_skills.py` reads each skill's `SKILL.md` (frontmatter + body),
its `manifest.yaml` (description), and `IMP Docs/skill_evals.yaml` (trigger
phrases), then writes per-tool files under [`exports/`](../exports):

- Other tools don't auto-trigger on a description the way Claude does, so every
  export is prefixed with an **activation preamble**: *"Activate this skill when
  the user says … ; otherwise ignore."* built from the trigger phrases.
- Relative links (`references/…`, `scripts/…`) are rewritten to **absolute
  GitHub URLs**, so a single ported file stays self-contained.
- `AGENTS.md`/`GEMINI.md` exports are wrapped in
  `<!-- skills-directory:<name> START/END -->` markers so the installer can
  replace a block in place (idempotent updates).
- Windsurf exports are flagged at build time if they exceed the 12k limit.

Regenerate after editing any skill: `python3 scripts/export_skills.py`. The
`exports/` tree is committed so users can also copy a file by hand with no tools.

## The installer

`install.sh <skill|all> [--tool T] [--global|--project] [--dir PATH]` places the
right export in the right location, auto-detecting the tool from the working dir
when `--tool` is omitted. It works from a local clone (uses `exports/`) or over
the network (`curl … | bash -s -- <skill>`, fetching raw files from GitHub).

- `claude-code` copies the **whole native folder** (or points at the plugin
  marketplace / `git clone`), since Claude skills are multi-file.
- All other tools receive the single converted file.

## Limitations (honest)

- Ported skills are the `SKILL.md` body only; the linked `references/`/`scripts/`
  aren't inlined (links point back to GitHub). Skills that lean heavily on scripts
  (e.g. `mod`, `claude-assassin`) run best in their native Claude form.
- Non-Claude hosts have no Canary plugin, so `mod`'s recorded-QA phase is skipped
  there (matches the `partial` rating in [`AGENT_COMPAT.md`](./AGENT_COMPAT.md)).
- Windsurf's 12k-char cap can truncate large skills; split into references if the
  exporter warns.
