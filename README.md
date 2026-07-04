# Skills-Directory

A curated repository of agent skills — reusable capabilities that can be plugged into any AI coding agent.

## Available Skills

| Skill | Description |
|-------|-------------|
| **[code-translator](./code-translator/SKILL.md)** | Translates code between 15+ programming languages while preserving exact logical equivalence. |
| **[supply-chain-prober](./supply-chain-prober/SKILL.md)** | Conducts conversational supply chain interviews with non-tech users, collects structured data, and routes it to SMEs for validation before handing off to the tech team for agent building. |
| **[claude-assassin](./claude-assassin/SKILL.md)** | Silent background daemon (Windows/macOS/Linux) that saves task state on a session limit and automatically relaunches Claude Code the moment the reset timer expires. |
| **[mod](./mod/SKILL.md)** | End-to-end build/fix/ship harness — takes a repo from its current state to shipped, tested, documented, and demonstrable, all inside WSL. Reads the full codebase, runs Canary-driven tests, fixes bugs, writes versioned docs in IMP Docs/, publishes a premium showcase, and opens a PR. Invoke as "Mod: <repo link>". |

---

## 🛠 The Ritual: How to Add a New Skill

### Folder Structure

Create a new folder using **kebab-case**. At minimum you need a `SKILL.md`. Add supporting files as needed.

```
my-skill-name/
├── SKILL.md              # Required — the brain of the skill
├── scripts/              # Optional — automation scripts (bash, python)
├── references/           # Optional — large docs, question banks, data
└── examples/             # Optional — sample sessions, usage patterns
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

- **Keep `SKILL.md` under 500 lines.** Move large reference material into `references/`.
- **Use plain language.** The skill may interact with non-technical users.
- **Include examples.** Drop a sample session or usage pattern in `examples/` so anyone can understand the flow.
- **Scripts should be self-documenting.** Add usage comments at the top of every script.
- **Test locally first.** Run your scripts manually before committing.

### Push & Ship

```bash
git add my-skill-name/
# Update this README's "Available Skills" table
git commit -m "Add my-skill-name skill"
git push
```

The skill is now live and available to any agent that references this repository.
