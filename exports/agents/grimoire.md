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
