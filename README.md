# Skills-Directory

A repository for Antigravity skills.

## Available Skills

- **[code-translator](./code-translator/SKILL.md)**: Translates code from one programming language to another while preserving exact logical equivalence.

---

## 🛠 The Ritual: How to Add a New Skill

Whenever you want to add a new skill to this directory, follow these official best practices:

### 1. Folder Structure
Create a new folder using **kebab-case** (no spaces, no capital letters, no underscores).
```bash
my-awesome-skill/
├── SKILL.md         # Required
├── scripts/         # Optional (for custom logic)
└── references/      # Optional (for large docs)
```

### 2. The `SKILL.md` Frontmatter
Every skill must have a YAML block at the very top of `SKILL.md`. It must include a `name` and a `description` that clearly states **what it does** and **when to trigger it**.

```yaml
---
name: my-awesome-skill
description: Generates markdown reports from CSV data. Use this when the user asks to "build a report" or "analyze data".
---
```

### 3. The Instruction Format
Use progressive disclosure and keep the core instructions concise. Structure your markdown like this:

```markdown
# My Awesome Skill

## Instructions

### Step 1: Validate Data
Check the formatting...

### Step 2: Generate Report
Use the `scripts/generator.py` to create the output...
```

### 4. Push to Git
Once your `SKILL.md` is ready, update this `README.md` list and push to the `main` branch. The new capability will automatically be available to your agents!
