# Skills-Directory

A curated repository of agent skills — reusable capabilities that can be plugged into any AI coding agent.

> **Built to spec.** These skills follow Anthropic's [**Complete Guide to Building Skills for Claude**](https://resources.anthropic.com/hubfs/The-Complete-Guide-to-Building-Skill-for-Claude.pdf?hsLang=en) — progressive disclosure (`SKILL.md` + `references/` + `scripts/` + `assets/`), kebab-case names, and trigger-rich descriptions. Read it before adding a skill.

## Available Skills

| Skill | Description |
|-------|-------------|
| **[code-translator](./code-translator/SKILL.md)** | Translates code between 15+ programming languages while preserving exact logical equivalence. |
| **[supply-chain-prober](./supply-chain-prober/SKILL.md)** | Conducts conversational supply chain interviews with non-tech users, collects structured data, and routes it to SMEs for validation before handing off to the tech team for agent building. |
| **[claude-assassin](./claude-assassin/SKILL.md)** | Silent background daemon (Windows/macOS/Linux) that saves task state on a session limit and automatically relaunches Claude Code the moment the reset timer expires. |
| **[mod](./mod/SKILL.md)** | End-to-end build/fix/ship harness — takes a repo from its current state to shipped, tested, documented, and demonstrable, all inside WSL. Reads the full codebase, runs Canary-driven tests, fixes bugs, writes versioned docs in `IMP Docs/`, publishes a premium showcase, and opens a PR. Invoke as `Mod: <repo link>`. |

---

## 🛠 The Ritual: How to Add a New Skill

### Folder Structure

Create a new folder using **kebab-case**. At minimum you need a `SKILL.md`. Add supporting files as needed — richer skills (see [`claude-assassin`](./claude-assassin/SKILL.md) and [`mod`](./mod/SKILL.md)) split detail into their own files rather than bloating `SKILL.md`.

```
my-skill-name/
├── SKILL.md              # Required — the brain of the skill (exact name, case-sensitive)
├── scripts/              # Optional — executable helpers (bash, python)
├── references/           # Optional — docs loaded on demand (progressive disclosure)
├── assets/               # Optional — templates, icons, fonts used in output
├── examples/             # Optional — sample sessions, usage patterns
└── my-skill-diagram.svg  # Optional — a flowchart / infographic of the workflow
```

### The `SKILL.md` Format

Every skill must follow this exact structure:

**1. YAML Frontmatter** (required) — this is what the agent uses to decide when to trigger the skill:

```yaml
---
name: my-skill-name
description: What it does and when to trigger it. Be specific.
---
```

**2. Title & Role Statement** — one paragraph telling the agent who it is when this skill activates.

**3. `## Instructions` with `### Step N:` headings** — the actual workflow, broken into clear sequential steps. Keep each step focused on one action.

**4. File Reference Table** — if you have supporting files, list them at the bottom so the agent knows what's available.

### Guidelines

- **Keep `SKILL.md` under 500 lines** (the guide says under ~5,000 words). Move detail into `references/` and link to it — progressive disclosure keeps token usage low.
- **The `description` is the most important field.** It must state **what** the skill does **and when** to use it, include the exact trigger phrases users say, stay under 1024 characters, and contain **no XML angle brackets (`<` `>`)** — that's a security restriction on frontmatter.
- **`name` is kebab-case and matches the folder.** No spaces, no capitals, no `claude`/`anthropic` prefix (reserved).
- **No `README.md` *inside* a skill folder.** All in-skill docs go in `SKILL.md` or `references/`. This repo-level README is the only one (it's for human visitors).
- **Prefer scripts for deterministic steps.** Code is deterministic; language interpretation isn't. Add usage comments at the top of every script and test locally first.
- **Use plain language and include examples** — the skill may interact with non-technical users.

### Push & Ship

```bash
git add my-skill-name/
# Update this README's "Available Skills" table
git commit -m "Add my-skill-name skill"
git push
```

The skill is now live and available to any agent that references this repository.
