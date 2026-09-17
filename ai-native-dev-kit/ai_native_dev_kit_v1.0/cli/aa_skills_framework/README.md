# aa-skills

Framework for invoking Aligned Automation's AI-native skill library via the
Claude API — with file-based I/O and explicit context/session management —
entirely from Python/CLI. No claude.ai account is required; authentication
is by API key only.

## 0. Before you start: credit visibility (read this first)

Anthropic does not expose a public API endpoint that returns your prepaid
credit balance in dollars — Console → Plans & Billing is the only
authoritative source, and it requires a human login. So `aa-skills`
maintains a **local estimate** instead:

```bash
# Right after you top up in the Console, tell the CLI what you funded:
aa-skills credits set-balance --amount 50

# Check the estimate any time:
aa-skills credits show

# Confirm the key can actually bill right now (fires one 1-token request):
aa-skills credits verify
```

Every `aa-skills invoke` call:
1. **Before invoking**, checks the local estimate against a threshold
   (default $5, override with `--credit-threshold`) and prints a warning
   banner if it's at or below that line.
2. **After the call**, prices the actual token usage from the response
   against a maintained rate table, updates the local ledger, and prints
   the new estimated balance.

This is a budgeting aid, not a balance-of-record — see the docstring in
`aa_skills/credits.py` for exactly what it can and can't guarantee, and
use `--live-credit-probe` (or `credits verify`) when you want Anthropic's
own confirmation that the key can currently bill, not just the local math.

## 1. Install

```bash
pip install -e .
export ANTHROPIC_API_KEY=sk-ant-...
aa-skills credits set-balance --amount <what you just topped up>
```

## 2. Seed the registry

```bash
aa-skills bootstrap
# Registers Anthropic's pre-built pptx/xlsx/docx/pdf skills locally.
```

Or start from the example registry (mix of pre-built + placeholder custom
entries) at `examples/aa_skill_registry.example.json` and point at it with
`--registry`.

## 3. Register a custom AA skill

```bash
aa-skills register-skill \
  --dir skills_bundles/rfp_extraction \
  --name rfp_extraction \
  --title "RFP Requirements Extraction" \
  --description "Extract obligation-tagged requirements from an RFP/SOW" \
  --output-kind html
```

This uploads the bundle via the Skills API and writes the resulting
`skill_id` into your local registry — the registry is what your team
manages centrally, analogous to the existing HTML skills registry.

## 4. Invoke a skill with a file input

```bash
aa-skills invoke \
  --skills rfp_extraction \
  --prompt "Extract requirements and flag conflicts from the attached SOW." \
  --file ./ASG_SOW.pdf \
  --session asg-proposal
```

Output files are downloaded to `./aa_skill_outputs/` and registered into
the `asg-proposal` session under a short alias (derived from the filename).

## 5. Chain a second skill using a generated file as input

```bash
aa-skills files list --session asg-proposal
# -> [asg_sow_requirements] asg_sow_requirements.html (from `rfp_extraction`): ...

aa-skills invoke \
  --skills aa_scaffold_pptx \
  --prompt "Turn the flagged requirements into a 5-slide executive summary deck." \
  --use asg_sow_requirements \
  --session asg-proposal
```

Note what did **not** happen: the requirements file's content was not
pasted back into the prompt, and the session's whole history was not
replayed. Only the file reference (mounted into the container) and a
one-line description travelled forward. This is the core context-overflow
and hallucination guardrail — see `aa_skills/context.py` for the full
rationale.

## 6. Inspect or reset session state

```bash
aa-skills session show --session asg-proposal
aa-skills session reset --session asg-proposal   # clears container + file manifest
```

Starting a genuinely new task should default to `--new-session` (or a new
`--session` name) rather than continuing an existing one — unrelated tasks
sharing a session is the most common cause of both context bloat and
answer drift over a long chain.

## Package layout

```
aa_skills/
  registry.py    # AA skill name <-> Anthropic skill_id mapping (Layer 1)
  files_api.py   # Upload/download via the Files API (Layer 2)
  client.py      # AASkillInvoker: container assembly, pause_turn handling, credit hooks (Layer 3)
  context.py     # SessionContext: file manifest, token-budget enforcement (context guardrails)
  credits.py     # Local credit-balance estimation + live key verification
  cli.py         # `aa-skills` command-line entry point (Layer 4)
examples/
  aa_skill_registry.example.json
skills_bundles/
  example_skill/SKILL.md   # template for packaging a new AAxon skill
```

## Constraints inherited from the underlying API

- Max 8 skills per request (`registry.resolve_many` raises before calling out).
- Max 30 MB per custom skill bundle upload.
- No network access and no runtime package installation inside the skill
  execution sandbox — vendor dependencies into the bundle.
- Custom skills are workspace-wide, not per-user; access control sits at
  the API-key/workspace level.
- No public API returns a dollar-denominated credit balance for a
  standard key — `aa_skills/credits.py` estimates it locally; treat the
  Console billing page as the source of truth.
