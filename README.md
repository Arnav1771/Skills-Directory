# Skills-Directory

A curated repository of agent skills — reusable capabilities that can be plugged into any AI coding agent.

> **Built to spec.** These skills follow Anthropic's [**Complete Guide to Building Skills for Claude**](https://resources.anthropic.com/hubfs/The-Complete-Guide-to-Building-Skill-for-Claude.pdf?hsLang=en) — progressive disclosure (`SKILL.md` + `references/` + `scripts/` + `assets/`), kebab-case names, and trigger-rich descriptions. Each skill also ships an optional **[`manifest.yaml`](#the-manifestyaml-format-optional--recommended)** — a small discovery layer (categories, tags, icon, version, composes-with) that powers the catalog below. Read the guide before adding a skill.

## Available Skills

Browse by category. `SKILL.md` is the brain; `manifest.yaml` is the catalog card.

### 🛠 Developer & Build Tools

| Skill | What it does | Tags | Ver |
|-------|--------------|------|-----|
| **[mod](./mod/SKILL.md)** | End-to-end build/fix/ship harness — takes a repo from its current state to shipped, tested, documented, and demonstrable, all inside WSL. Reads the full codebase, runs Canary-driven tests, fixes bugs, writes versioned docs in `IMP Docs/`, publishes a showcase, and opens a PR. Invoke as `Mod:` + repo link. | `build` `test` `ship` `qa` `wsl` | 1.1.0 |
| **[grimoire](./grimoire/SKILL.md)** | Generate or modify a full app from a plain-English description and push it to a private GitHub repo (with an `IMP_DOCS/` folder), via the Grimoire / AppBuilder MCP tools or CLI. Bring-your-own-keys (GitHub + one AI provider). Say `Grimoire, build me …`. | `app-generation` `scaffolding` `github` `mcp` | 1.0.0 |
| **[code-translator](./code-translator/SKILL.md)** | Translates code between programming languages while preserving exact logical equivalence. | `translation` `porting` `languages` | 1.0.0 |
| **[claude-assassin](./claude-assassin/SKILL.md)** | Silent background daemon (Windows/macOS/Linux) that saves task state on a session limit and automatically relaunches Claude Code the moment the reset timer expires. | `session-limit` `daemon` `auto-resume` | 1.0.0 |

### 📊 Business & Data

| Skill | What it does | Tags | Ver |
|-------|--------------|------|-----|
| **[supply-chain-prober](./supply-chain-prober/SKILL.md)** | Conducts conversational supply chain interviews with non-tech users, collects structured data, and routes it to SMEs for validation before handing off to the tech team for agent building. | `interview` `supply-chain` `data-intake` | 1.0.0 |

> **Composes well:** `mod` ↔ `grimoire` ↔ `claude-assassin` — generate an app, ship/QA it, and keep long sessions alive through limits.
>
> Repo docs live in [`IMP Docs/`](./IMP%20Docs/) — [HANDOFF](./IMP%20Docs/HANDOFF.md) · [TECHSPEC](./IMP%20Docs/TECHSPEC.md) · [Update log](./IMP%20Docs/Update.md).

---

## 📦 Install & Use

Skills are portable — the same folder works in Claude Code, Claude.ai, and the API.

**Claude Code — plugin marketplace (recommended, one command)**

This repo is a [Claude Code plugin marketplace](https://code.claude.com/docs/en/plugin-marketplaces). Add it once, then install any skill by name:
```bash
/plugin marketplace add Arnav1771/Skills-Directory
/plugin install mod@skills-directory
# browse everything with:  /plugin
```
No cloning or copying — Claude Code fetches the skill and keeps it updated (`/plugin marketplace update`). The catalog is defined in [`.claude-plugin/marketplace.json`](./.claude-plugin/marketplace.json).

**Claude Code — manual (local copy)**
```bash
git clone https://github.com/Arnav1771/Skills-Directory.git
# Global (all projects):
cp -r Skills-Directory/mod ~/.claude/skills/mod
# — or project-scoped:
cp -r Skills-Directory/mod .claude/skills/mod
```
The skill loads automatically when your request matches its `description`. You can
also invoke it by name (e.g. `/mod`), or just say its trigger phrase.

**Claude.ai**
1. Zip the skill folder (e.g. `mod/`).
2. Settings → Capabilities → **Skills** → **Upload skill** → select the zip.
3. Toggle the skill on. It now activates automatically on relevant requests.

**Try it — example triggers**

| Skill | Say something like |
|-------|--------------------|
| `mod` | `Mod: https://github.com/you/your-repo.git` |
| `grimoire` | "Grimoire, build a Flask todo app with SQLite and dark mode." |
| `code-translator` | "Translate this Python file to Go, keeping logic identical." |
| `supply-chain-prober` | "Interview me about my supply chain and structure the data." |
| `claude-assassin` | (auto) fires when you hit a Claude Code session limit. |

### Works across agents

These skills follow the open [Agent Skills](https://agentskills.io) format, so the prompt-only ones run in any agent that loads skills — not just Claude. Each skill's `manifest.yaml` declares a `compat` matrix (`full` · `partial` · `na`); the full grid lives in [`IMP Docs/AGENT_COMPAT.md`](./IMP%20Docs/AGENT_COMPAT.md).

| Skill | Claude Code | Cursor · Codex · Gemini CLI · Windsurf · Roo | Notes |
|-------|:-----------:|:--------------------------------------------:|-------|
| `code-translator` | ✅ | ✅ | Prompt-only — fully portable |
| `supply-chain-prober` | ✅ | ✅ | Prompt-only — fully portable |
| `grimoire` | ✅ | ✅ | Needs MCP tools or the `grimoire` CLI |
| `mod` | ✅ | ◐ | Core pipeline portable; Canary-recorded QA is Claude-only |
| `claude-assassin` | ✅ | — | Claude Code session daemon — Claude-only by design |

---

## 🛠 The Ritual: How to Add a New Skill

### Folder Structure

Create a new folder using **kebab-case**. At minimum you need a `SKILL.md`. Add supporting files as needed — richer skills (see [`claude-assassin`](./claude-assassin/SKILL.md) and [`mod`](./mod/SKILL.md)) split detail into their own files rather than bloating `SKILL.md`.

```
my-skill-name/
├── SKILL.md              # Required — the brain of the skill (exact name, case-sensitive)
├── manifest.yaml         # Optional (recommended) — catalog metadata for discovery
├── scripts/              # Optional — executable helpers (bash, python)
├── references/           # Optional — docs loaded on demand (progressive disclosure)
├── assets/               # Optional — templates, icons, fonts used in output
├── examples/             # Optional — sample sessions, usage patterns
└── my-skill-diagram.svg  # Optional — a flowchart / infographic of the workflow
```

### The `SKILL.md` Format

The frontmatter is **required**; the body is a **recommended template — adapt it**, don't treat it as a straitjacket (per Anthropic's guide, "adapt this template for your skill").

**1. YAML Frontmatter** (required) — this is what the agent uses to decide when to trigger the skill:

```yaml
---
name: my-skill-name
description: What it does AND when to trigger it. Include the phrases users say.
---
```

**2. Title & Role Statement** — one paragraph telling the agent who it is when this skill activates.

**3. Instructions** — the actual workflow. Use whatever headings fit: sequential `### Step N:` for linear flows, or `## Phase`/topic sections for larger skills (see [`mod`](./mod/SKILL.md)). Put critical rules near the top.

**4. File Reference Table** — if you have supporting files, link them (usually at the bottom) so the agent can discover them on demand.

### The `manifest.yaml` Format (optional — recommended)

`SKILL.md` frontmatter is what the *agent* reads to trigger the skill. `manifest.yaml`
is a separate, purely human/catalog-facing metadata layer — it never changes runtime
behavior, it just lets this README (and any future skill browser) group, tag, and
cross-link skills. It's optional but recommended for every skill.

```yaml
name: my-skill-name            # kebab-case, matches the folder and SKILL.md name
description: "One-line catalog card — what it does and when to use it. No angle brackets."
categories:                    # broad buckets used to group skills in the catalog
  - developer-tools
tags:                          # free-form keywords for search/filtering
  - build
  - test
icon: Rocket                   # a Lucide icon name (https://lucide.dev/icons)
version: "1.1.0"               # quoted string; mirror SKILL.md metadata.version
composesWell:                  # other skills in this repo that pair well (by name)
  - grimoire
```

Rules: `name` must match the folder; `description` follows the same no-`<`/`>`
angle-bracket rule as `SKILL.md`; `version` is a **quoted** string; every
`composesWell` entry must be a real skill folder in this repo. Validate with
[`IMP Docs/validate_manifests.py`](./IMP%20Docs/validate_manifests.py) (`bash "IMP Docs/run_validate.sh"`).

### Guidelines

- **Keep `SKILL.md` under 500 lines** (the guide says under ~5,000 words). Move detail into `references/` and link to it — progressive disclosure keeps token usage low.
- **The `description` is the most important field.** It must state **what** the skill does **and when** to use it, include the exact trigger phrases users say, stay under 1024 characters, and contain **no XML angle brackets (`<` `>`)** — that's a security restriction on frontmatter.
- **`name` is kebab-case and matches the folder.** No spaces, no capitals, no `claude`/`anthropic` prefix (reserved).
- **No `README.md` *inside* a skill folder.** All in-skill docs go in `SKILL.md` or `references/`. This repo-level README is the only one (it's for human visitors).
- **Prefer scripts for deterministic steps.** Code is deterministic; language interpretation isn't. Add usage comments at the top of every script and test locally first.
- **Use plain language and include examples** — the skill may interact with non-technical users.

### Push & Ship

```bash
git checkout -b add-my-skill-name
git add my-skill-name/          # includes SKILL.md + optional manifest.yaml
# Add the skill to this README's category catalog (and IMP Docs/Update.md)
git commit -m "Add my-skill-name skill"
git push -u origin add-my-skill-name
gh pr create --fill        # open a PR — merges land on main via review
```

Once merged, the skill is live and available to any agent that references this repository. Record the change in [`IMP Docs/Update.md`](./IMP%20Docs/Update.md).
