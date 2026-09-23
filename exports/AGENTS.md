# Agent skills — AGENTS.md bundle

Ported from https://github.com/Arnav1771/Skills-Directory. Drop this whole file in your repo root (or ~/.codex/AGENTS.md), or take one section.

<!-- skills-directory:claude-assassin START -->
## Skill: claude-assassin

> **Skill: `claude-assassin`.** Silent background daemon that automatically resumes Claude Code sessions after session limits reset. Use this skill immediately when you see "You've hit your session limit", "resets at", "session limit reached", or "/usage-credits" in the terminal. Also triggers on first run to install the daemon silently. Once installed, it works entirely behind the scenes — saving task state before Claude Code exits and relaunching automatically when the reset timer expires. Install once, works forever org-wide.
>
> **Activate** this skill when the user's request matches it — for example when they say: "session limit", "resets at", "/usage-credits". When active, follow the instructions below precisely; otherwise ignore them.
>
> Ported from [Arnav1771/Skills-Directory](https://github.com/Arnav1771/Skills-Directory/blob/main/claude-assassin/SKILL.md) — the full folder (references, scripts) lives there.

# Claude Assassin — Silent Session Resume Daemon

A silent background process that installs itself once and forever handles Claude Code session limits automatically. When the session limit hits, it saves your task state and relaunches Claude Code the moment the reset timer expires.

---

## On First Run — Install the Daemon

If the daemon is not yet installed, run this immediately:

```bash
bash ~/.claude/skills/claude-assassin/scripts/install_daemon.sh
```

This is a one-time setup. After this, everything is automatic.

---

## When Session Limit Is Detected

If you see "You've hit your session limit · resets X:XXpm", immediately:

### Step 1: Save current task state
```bash
bash ~/.claude/skills/claude-assassin/scripts/save_state.sh "DESCRIBE_CURRENT_TASK_HERE"
```

### Step 2: Schedule the resume
```bash
bash ~/.claude/skills/claude-assassin/scripts/schedule_resume.sh "X:XXpm"
```

Replace `X:XXpm` with the exact reset time shown in the terminal.

That's it. Claude Code will relaunch automatically at the reset time and resume from where it left off.

---

## How It Works

```
Session limit hit
      ↓
Claude saves task state → ~/.claude/assassin/session_state.md
      ↓
schedule_resume.sh parses reset time → schedules system job
      ↓
Claude Code exits
      ↓
[Background daemon waits silently]
      ↓
Reset time arrives → daemon relaunches Claude Code
      ↓
Claude reads session_state.md → resumes task automatically
```

---

## Files Created on Your System

| Path | Purpose |
|------|---------|
| `~/.claude/assassin/session_state.md` | Saved task state |
| `~/.claude/assassin/assassin.log` | Daemon activity log |
| `~/.claude/assassin/last_reset_time.txt` | Parsed reset time |
| `~/.config/systemd/user/claude-assassin.service` | Linux daemon (systemd) |
| `~/Library/LaunchAgents/com.claude.assassin.plist` | macOS daemon (launchd) |
| `%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\claude_assassin.vbs` | Windows auto-start (no admin needed) |

---

## Checking Daemon Status

```bash
# Windows (Git Bash)
bash ~/.claude/skills/claude-assassin/scripts/status.sh

# Linux
systemctl --user status claude-assassin

# macOS
launchctl list | grep claude-assassin

# View logs (all platforms)
tail -f ~/.claude/assassin/assassin.log
```

## Uninstalling

```bash
bash ~/.claude/skills/claude-assassin/scripts/uninstall_daemon.sh
```

---

## Reference Files

- `references/how_it_works.md` — Full technical architecture
- `references/troubleshooting.md` — Common issues and fixes
<!-- skills-directory:claude-assassin END -->

<!-- skills-directory:code-translator START -->
## Skill: code-translator

> **Skill: `code-translator`.** Translates code from one programming language to another while preserving exact logical equivalence. Trigger this when the user asks to translate, port, or convert code between languages.
>
> **Activate** this skill when the user's request matches it — for example when they say: "translate", "port", "convert code". When active, follow the instructions below precisely; otherwise ignore them.
>
> Ported from [Arnav1771/Skills-Directory](https://github.com/Arnav1771/Skills-Directory/blob/main/code-translator/SKILL.md) — the full folder (references, scripts) lives there.

# Code Translator Skill

You are now acting as the Stealth Translator. When the user asks you to translate code or a script from one programming language to another (e.g., "translate utils.js to python"), follow this precise workflow:

## Instructions

### Step 1: Understand the Request
Identify the source file(s), the source language, and the target language. 

### Step 2: Read the Source
Use the `view_file` tool to read the exact contents of the source code. Understand the core logic, dependencies, and architecture.

### Step 3: Perform the Translation
Use your internal LLM reasoning to port the code. 
**Strict Guidelines:**
- Maintain **perfect logical equivalence** (the output must do exactly what the input did).
- Use **idiomatic patterns** of the target language (e.g., use list comprehensions in Python instead of `map()` if appropriate).
- Port all comments intact.
- Do not add unnecessary new features; stick to a pure translation.

### Step 4: Write the Output
Use the `write_to_file` tool to save the translated code. Name the file intelligently based on the original (e.g., `utils.js` -> `utils.py`) and place it in the same directory unless specified otherwise.

### Step 5: Execution & Verification
If the user's environment supports it (e.g., Python, Node.js, Bash), proactively offer to run the translated script using the `run_command` tool to prove that the translation works perfectly!
<!-- skills-directory:code-translator END -->

<!-- skills-directory:grimoire START -->
## Skill: grimoire

> **Skill: `grimoire`.** Generate or modify a full application from a plain-English description and push it to a private GitHub repo — powered by the Grimoire / AppBuilder engine. Trigger when the user says 'Grimoire', 'build me an app', 'scaffold a project', 'generate an app and push it to GitHub', or asks to update or experiment on a generated repo. Uses the Grimoire MCP tools (build_app / update_app / experiment_app / list_available_models / check_credentials) when configured, otherwise the `grimoire` CLI. Bring-your-own-keys: a GitHub token plus one AI provider (GitHub Models, Gemini, Groq, or Anthropic). Every generated repo ships an IMP_DOCS documentation folder.
>
> **Activate** this skill when the user's request matches it — for example when they say: "Grimoire", "build me an app", "scaffold a project". When active, follow the instructions below precisely; otherwise ignore them.
>
> Ported from [Arnav1771/Skills-Directory](https://github.com/Arnav1771/Skills-Directory/blob/main/grimoire/SKILL.md) — the full folder (references, scripts) lives there.

# Grimoire — speak the app into existence

Turn a plain-English description into a working app, pushed to a **private
GitHub repo** on the user's own account, complete with an `IMP_DOCS/` folder
(HANDOFF, TECH_SPEC, ARCHITECTURE + diagram, DESIGN_SYSTEM, ADRs, TODO,
CHANGELOG, PROMPT_TRAIL). This skill drives the Grimoire / AppBuilder engine
(repo: `github.com/Arnav1771/turmux_builder`).

## When to use

- "Grimoire, build me a …", "build me an app that …", "scaffold a … project"
- "generate an app and push it to GitHub"
- "update my generated repo to …" / "try an experiment on … in a new branch"

## Two ways to invoke (prefer the MCP tools)

1. **MCP tools (preferred)** — if the Grimoire MCP server is connected, these
   tools are available: `check_credentials`, `list_available_models`,
   `build_app`, `update_app`, `experiment_app`. Use them directly.
2. **CLI fallback (Claude Code)** — if no MCP server is present but the
   `grimoire` command is installed, run it in the shell:
   `grimoire keys`, `grimoire models`, `grimoire build "..."`.

If neither is available, tell the user how to set it up (see
[`references/troubleshooting.md`](https://github.com/Arnav1771/Skills-Directory/blob/main/grimoire/references/troubleshooting.md)) and stop.

## Bring-your-own-keys

The engine needs the user's own **GitHub token + username** (to create and push
the repo) and **one AI provider key** matching the active provider. No Anthropic
key is required unless the user picks the `anthropic` provider. Details and the
key matrix: [`references/providers.md`](https://github.com/Arnav1771/Skills-Directory/blob/main/grimoire/references/providers.md).

## Workflow

1. **Check readiness.** Call `check_credentials` (or `grimoire keys`). If it
   reports missing keys, tell the user exactly what to set and stop — do not
   attempt a build that will fail.
2. **Nail the spec.** If the request is vague, ask 1–2 sharp questions (stack
   preference? auth? persistence?). A precise prompt yields a better app — see
   [`references/prompting.md`](https://github.com/Arnav1771/Skills-Directory/blob/main/grimoire/references/prompting.md). Do not over-interrogate.
3. **Pick provider/model (optional).** Default is fine. Offer alternatives from
   `list_available_models` only if the user cares. Pass `provider`/`model` to
   the build tool when overriding.
4. **Build.** Call `build_app(prompt=..., provider=?, model=?)` (or
   `grimoire build "..."`). This can take a minute — say so.
5. **Report.** Return the `repo_url` (and `live_url` if deployed), the tech
   stack, file count, and point the user at `IMP_DOCS/HANDOFF.md` for how to run
   it. Note repos are **private** by default.
6. **Iterate.** For changes to an existing repo use `update_app(repo_url,
   changes)`; for a throwaway trial use `experiment_app(repo_url, branch,
   changes)` (non-destructive — new branch).

## Ground rules

- **Never ask for keys in chat.** Credentials live in the MCP server's env (or
  the user's `.env`) — never request or echo them in the conversation.
- **Confirm before overwriting.** `update_app` edits an existing repo; make sure
  the user means that repo. Prefer `experiment_app` for anything speculative.
- **Report honestly.** Relay the real `repo_url` and any partial failures from
  the tool result; don't claim success you can't see.
- **No AI attribution** on anything you commit on the user's behalf.

## Examples

- "Grimoire, build a FastAPI bookstore API with SQLite." →
  `check_credentials` → `build_app(prompt="a FastAPI bookstore API with SQLite")`
  → report repo URL + `IMP_DOCS/HANDOFF.md`.
- "Use Claude to build a React dashboard." →
  `build_app(prompt="a React dashboard ...", provider="anthropic")`.
- "Add dark mode to https://github.com/me/my-app." →
  `update_app(repo_url="https://github.com/me/my-app", changes="add a dark-mode toggle")`.

## Reference material

- [`references/providers.md`](https://github.com/Arnav1771/Skills-Directory/blob/main/grimoire/references/providers.md) — providers, keys, models.
- [`references/prompting.md`](https://github.com/Arnav1771/Skills-Directory/blob/main/grimoire/references/prompting.md) — writing good build prompts.
- [`references/troubleshooting.md`](https://github.com/Arnav1771/Skills-Directory/blob/main/grimoire/references/troubleshooting.md) — setup + common errors.
- Flow diagram: [`grimoire_flow.svg`](https://github.com/Arnav1771/Skills-Directory/blob/main/grimoire/grimoire_flow.svg).
<!-- skills-directory:grimoire END -->

<!-- skills-directory:mod START -->
## Skill: mod

> **Skill: `mod`.** End-to-end build / fix / ship harness. Takes a repository from its current state to shipped, tested, documented, and demonstrable — you own the whole loop: understand, test, fix, document, publish, and you prove it works. Trigger whenever the user writes 'Mod:' followed by a repo link, '/mod' with a repo URL, or asks to run a repo through the universal build pipeline. The repo URL is the only input; everything else is baked in. Runs entirely inside WSL: Phase 0 environment setup, Phase 1 full-codebase audit, Phase 2 Canary-driven testing, Phase 3 bug fixing with re-verification, Phase 4 versioned docs in the 'IMP Docs' folder, Phase 5 ship (premium showcase plus landing page, release artifacts, and a pull request).
>
> **Activate** this skill when the user's request matches it — for example when they say: "Mod:", "/mod", "universal build pipeline". When active, follow the instructions below precisely; otherwise ignore them.
>
> Ported from [Arnav1771/Skills-Directory](https://github.com/Arnav1771/Skills-Directory/blob/main/mod/SKILL.md) — the full folder (references, scripts) lives there.

# Mod — Universal Build / Fix / Ship Harness

Take the target repo from *current state* to *shipped, tested, documented, and
demonstrable*. You are a **senior full-stack engineer + release manager** and
you own the whole loop: understand → test → fix → document → publish. You do not
stop at "it should work" — you **prove** it works.

## Invocation

The user calls this as **`Mod: <repo link>`** or **`/mod <repo url>`**. The
GitHub repo URL is the **only** input — everything else is pre-filled here. If
no URL is supplied, ask for exactly one thing: the repo link.

## Runtime

- Run **everything inside WSL** (Ubuntu). Never switch environments mid-task.
  On Windows, drive WSL via `wsl -e bash -lc "..."`; for anything with tricky
  quoting, write a script to a file and run it.
- **Working docs folder:** `IMP Docs/` at the repo root (reuse if present).

## Ground rules (non-negotiable)

1. **Read before you write.** Read the *full* codebase before changing a line.
2. **Never fabricate results.** Every test result, count, and screenshot must be
   real. If you didn't run it, say so.
3. **Document as you go.** `IMP Docs/PROMPT_TRAIL.md` gets an entry after *every*
   prompt — no exceptions.
4. **Test before you claim done.** "It compiles" ≠ "it works." Verify behavior.
5. **Version everything.** Outputs in `IMP Docs/` are versioned (`v1`, `v2`, …
   or semver). Supersede prior work; never silently overwrite.
6. **Authorship — no AI attribution.** Commits and PRs are authored **only** as
   the selected git identity. **Never** add `Co-Authored-By: Claude`,
   `🤖 Generated with Claude Code`, "Co-authored-by" AI trailers, or any
   Claude/AI mention to commit messages or PR descriptions. Keep messages clean
   and human.
7. **Ask only when blocked.** Reversible → decide and log it. Irreversible
   (deleting data, force-push, publishing, spending money) → stop and ask.

## Git identity (auto-selected — do not prompt, do not push to `main`)

This machine has two identities; because the skill runs in WSL the default is
personal. Select per-repo by owner (helper: `scripts/select-git-identity.sh`):

| Repo owner                          | Per-repo identity                                                  |
| ----------------------------------- | ------------------------------------------------------------------ |
| `github.com/Arnav1771/*` (personal) | `Arnav1771` / `arnav.bhargava3@gmail.com`                          |
| work / org repo (employer)          | `AABH-AI` / `your work email`                                      |

- WSL global default is already `Arnav1771 / arnav.bhargava3@gmail.com`; `gh` is
  authed to **Arnav1771**. For an Arnav1771 repo no override is needed.
- For a work repo, set identity **per-repo only** (never the WSL global, Windows
  config, or stored credentials).
- Always work on a feature branch (`mod/<yyyy-mm-dd>` or `fix/<task>`) and open a
  **PR** — never push directly to `main`/`master` unless the user says so.

## The pipeline (6 phases)

Full checklists and exit criteria live in
[`references/phase-playbook.md`](https://github.com/Arnav1771/Skills-Directory/blob/main/mod/references/phase-playbook.md). Overview:

| Phase | Goal | Exit criteria |
| ----- | ---- | ------------- |
| **0 · Setup** | Clone in WSL, install Canary plugin + deps, verify toolchain. | Env boots clean, deps resolve, no missing tools. |
| **1 · Audit** | Written system map: goal, file map, entry points, data flow, current state. | You can explain the whole system in a paragraph. |
| **2 · Test** | Canary-driven automated + exploratory testing; edge cases, error states, responsiveness, APIs; break it on purpose. | Complete real test log in `IMP Docs/`, Canary reports saved. |
| **3 · Fix** | Fix every failure; re-run to green. Log broken → root cause → fix → proof. | All fixable tests pass; the rest logged as known issues. |
| **4 · Docs** | Versioned living docs in `IMP Docs/` (templates in `references/doc-templates.md`). | All five docs current & version-stamped. |
| **5 · Ship** | Premium showcase + landing page (`frontend-design` skill), release artifacts if exe/extension/binary, PR. | PR open, site live, releases attached, docs linked. |

The five `IMP Docs/` files — `HANDOFF.md`, `TECHSPEC.md`, `PROMPT_TRAIL.md`,
`DESIGN_CHOICES.md`, `TODOS.md` — scaffold them with
`scripts/scaffold-imp-docs.sh`.

## Helper scripts

- [`scripts/select-git-identity.sh <repo-url-or-owner>`](https://github.com/Arnav1771/Skills-Directory/blob/main/mod/scripts/select-git-identity.sh)
  — echoes/sets the correct per-repo identity by owner.
- [`scripts/scaffold-imp-docs.sh [repo-root]`](scripts/scaffold-imp-docs.sh)
  — creates `IMP Docs/` with the five versioned doc stubs (won't overwrite).

## Definition of Done

Do not report completion until **all** are true: full codebase read · Canary +
env verified in WSL · every test run with real results · fixable bugs fixed &
re-verified (rest logged) · all five `IMP Docs/` current & versioned · showcase +
landing page live with premium design · release artifacts built (if applicable)
· PR opened with a complete description (no AI attribution) · `PROMPT_TRAIL.md`
updated for this prompt.

---

## Reference material

- [`references/universal-build-prompt.md`](https://github.com/Arnav1771/Skills-Directory/blob/main/mod/references/universal-build-prompt.md)
  — the full original Universal Build Prompt (source of truth).
- [`references/phase-playbook.md`](https://github.com/Arnav1771/Skills-Directory/blob/main/mod/references/phase-playbook.md) — detailed
  per-phase checklists and exit criteria.
- [`references/doc-templates.md`](https://github.com/Arnav1771/Skills-Directory/blob/main/mod/references/doc-templates.md) — copy-paste
  templates for the five `IMP Docs/` files, including the `PROMPT_TRAIL` entry
  format.
- Pipeline diagram: [`mod_pipeline_flowchart.svg`](https://github.com/Arnav1771/Skills-Directory/blob/main/mod/mod_pipeline_flowchart.svg).
<!-- skills-directory:mod END -->

<!-- skills-directory:supply-chain-prober START -->
## Skill: supply-chain-prober

> **Skill: `supply-chain-prober`.** Conducts conversational supply chain Q&A interviews with non-technical users, collects structured responses, and routes validated data to SMEs and technical teams for agent building. Trigger when the user asks to probe, interview, or collect supply chain knowledge from stakeholders.
>
> **Activate** this skill when the user's request matches it — for example when they say: "interview", "supply chain", "probe". When active, follow the instructions below precisely; otherwise ignore them.
>
> Ported from [Arnav1771/Skills-Directory](https://github.com/Arnav1771/Skills-Directory/blob/main/supply-chain-prober/SKILL.md) — the full folder (references, scripts) lives there.

# Supply Chain Prober Skill

You are a friendly, patient supply chain interviewer. Your job is to conduct a structured but conversational Q&A session with a business user to extract knowledge about their supply chain operations. The person you are talking to is **not tech-savvy** — use plain language, no jargon, and never rush them.

## Instructions

### Step 1: Load the Session Context

Read the `session_context.json` file provided to you. Extract:
- The respondent's **name**, **role**, and **company**
- The path to the question bank and the responses file

Then read `references/question_bank.md` to load the full question set.

### Step 2: Route Questions by Role

Do not ask all 43 questions. Use the respondent's role to pick the right starting categories and depth:

| Role Contains | Lead Categories | Max Questions |
|---|---|---|
| procurement, sourcing, buyer | Procurement → General → Risk | 18 |
| warehouse, storage, logistics | Warehousing → Logistics → Inventory | 18 |
| operations, manager, director | General → Technology → Goals | 20 |
| planning, demand, forecast | Inventory → Procurement → Goals | 16 |
| *anything else* | General → Technology → Goals | 15 |

Always end every session with at least 2 questions from **Category 8: Goals & Priorities** — this is the most valuable data for the tech team.

### Step 3: Greet and Set Expectations

Start with a warm, human greeting. Key points to hit:
- Use their **first name**
- Tell them it takes **10-15 minutes**
- Emphasize **no right or wrong answers**
- Explain the purpose: their answers help build better tools for their own team

> "Hi Priya! I'm a research assistant helping your team understand how things work on the ground today. This will take about 10-15 minutes — just answer however feels natural, there's nothing you can get wrong here. Shall we start?"

### Step 4: Conduct the Interview

Work through your selected questions but **do not read them like a survey**:

1. **Follow the thread.** If they mention a pain point, probe deeper before switching categories. Generate follow-up questions on the fly — tag them with `"follow_up": true`.
2. **Mirror their language.** If they say "we use Tally", reference it later: "You mentioned Tally — does it talk to your warehouse system, or do you move data manually?"
3. **Skip gracefully.** If they say "we don't export", don't ask about international shipping. Just move on naturally.
4. **Detect and flag risks.** Watch for these patterns and tag the response:

| Pattern Detected | Risk Flag |
|---|---|
| Only one supplier for something critical | `single_source_dependency` |
| Excel, paper, WhatsApp, manual entry | `manual_process` |
| "We don't know until end of day / week" | `no_visibility` |
| No mention of regulations when asked | `compliance_gap` |
| Stockouts, delays, disruptions mentioned | `frequent_disruption` |
| No backup plan for failures | `no_continuity_plan` |

5. **Acknowledge before moving on.** Never jump to the next question without a brief human reaction: "That makes sense", "Interesting", "Got it — that's really helpful."

### Step 5: Save Each Response

After each answer, append a structured JSON object to the session's `responses.json`. See `references/data_schema.md` for the full schema. Minimal example:

```json
{
  "question_id": 10,
  "category": "Procurement & Sourcing",
  "question": "Do you rely on a single supplier for any critical material?",
  "answer": "Yes — one company in Gujarat for friction material.",
  "confidence": "high",
  "risk_flags": ["single_source_dependency"],
  "follow_up": false,
  "timestamp": "2026-06-29T10:04:58Z"
}
```

**Confidence levels:**
- `high` — user gave a clear, specific answer
- `medium` — user was unsure or gave a vague answer
- `low` — user guessed or said "I think" / "maybe"

### Step 6: Close the Session

When you have 15-20 quality answers:

1. Thank them sincerely
2. Summarize the **top 3 themes** you heard back to them for confirmation
3. Always ask the closing question: *"Is there anything else about your supply chain you think is important for us to know?"*
4. Update `session_context.json`: set `status` to `"completed"` and add a `completed_at` timestamp

### Step 7: Post-Collection Pipeline

After all sessions are complete, the operator runs the data pipeline:

```
 Users (CSV)          Deploy             Probe              Collect           Validate           Build
 ┌─────────┐    ┌──────────────┐    ┌─────────────┐    ┌──────────────┐    ┌───────────┐    ┌──────────┐
 │ 100 ppl │───▶│  deploy.sh   │───▶│ Agent runs  │───▶│ collect_     │───▶│ SME marks │───▶│ Tech team│
 │ in CSV  │    │ generates    │    │ each session│    │ responses.py │    │ accuracy  │    │ builds   │
 │         │    │ session dirs │    │ saves JSON  │    │ master.json  │    │ per answer│    │ agents   │
 └─────────┘    └──────────────┘    └─────────────┘    │ + analytics  │    └───────────┘    └──────────┘
                                                       │ + SME report │
                                                       └──────────────┘
```

| Step | Command / Action | Output |
|------|------------------|--------|
| 1. Deploy | `./scripts/deploy.sh users.csv ./sessions/` | One session folder per user |
| 2. Probe | Agent conducts interviews | `responses.json` filled per user |
| 3. Collect | `python scripts/collect_responses.py ./sessions/ ./output/master.json` | `master.json` + `master.analytics.md` + `master.sme_report.md` |
| 4. Validate | SME reviews `master.sme_report.md` | Checked answers with notes |
| 5. Build | Tech team ingests validated JSON | Domain-specific AI agents |

## File Reference

| File | Purpose |
|------|---------|
| `references/question_bank.md` | 43 questions across 8 supply chain categories |
| `references/data_schema.md` | Full JSON schema for session context and responses |
| `scripts/deploy.sh` | Generates personalized session folders from a CSV |
| `scripts/collect_responses.py` | Aggregates responses, generates analytics + SME validation report |
| `scripts/users_template.csv` | Template CSV showing the exact format for user lists |
| `examples/sample_session.md` | Full example of a probing conversation with a non-tech user |
<!-- skills-directory:supply-chain-prober END -->
