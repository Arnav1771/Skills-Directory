# IMP Docs templates

Copy-paste templates for the five living, versioned docs under `IMP Docs/`.
Every doc carries a version stamp (`v1`, `v2`, … or semver) at the top and is
superseded, never silently overwritten. `scripts/scaffold-imp-docs.sh` writes
these stubs.

---

## HANDOFF.md

```markdown
# HANDOFF — <project> (v1 · <date>)

## Goal
<what this task set out to do>

## Files inspected
- <path> — <role>

## Files modified
- <path> — <one-line reason>

## Current state
<runs? what works, what doesn't>

## Tests run + results
- <suite/flow> — <pass/fail/skip counts, link to Canary report>

## Known issues & limitations
- <issue> — <why it remains>

## Next exact steps
1. <numbered, actionable>
```

## TECHSPEC.md

```markdown
# TECHSPEC — <project> (v1 · <date>)

## Architecture overview
## Tech stack & dependencies
## Data flow / system design
## API contracts / interfaces
## Environment setup
## Deployment notes
```

## PROMPT_TRAIL.md

Living audit log — append after every prompt, never rewrite history.

```markdown
# PROMPT_TRAIL — <project>

### <ISO-8601 timestamp> — <one-line prompt summary>
- **Prompt:** <what the user asked>
- **Did:** <what you actually did>
- **Files touched:** <paths>
- **Result:** <real outcome — pass/fail counts, links, blockers>
```

## DESIGN_CHOICES.md

```markdown
# DESIGN_CHOICES — <project> (v1 · <date>)

## Skills / plugins used (and why)
- <skill> — <why>

## Theme system
<light/dark switcher? design tokens? type scale, spacing, color system>

## Notable architectural / UX decisions
- <decision> — <rationale, alternatives considered>
```

## TODOS.md

```markdown
# TODOS — <project> (v1 · <date>)

## Model-assigned
- [ ] <found & flagged by the build agent>

## User-assigned
- [ ] <asked for by the user>
```
