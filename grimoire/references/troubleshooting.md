# Setup & troubleshooting

## No Grimoire tools and no `grimoire` command

Set up one of the two invocation paths:

**MCP server (any client)** — from the AppBuilder repo:
```bash
pip install -e ".[mcp]"
claude mcp add grimoire -- grimoire-mcp \
  -e GITHUB_TOKEN=ghp_xxx -e GITHUB_USERNAME=you -e AI_PROVIDER=github-copilot
```
(Add the provider key too, e.g. `-e ANTHROPIC_API_KEY=... -e AI_PROVIDER=anthropic`.)

**CLI (Claude Code)** — `pip install -e .` in the repo, fill `.env`, then
`grimoire build "..."`. See the repo README / `docs/GRIMOIRE.md`.

## `check_credentials` reports missing keys

Tell the user exactly which env vars to set (see `references/providers.md`) and
stop. Do not attempt a build that will fail. The check is provider-aware — only
the active provider's key is required, plus GitHub.

## Build succeeds but no live URL

`live_url` is only populated when `VERCEL_TOKEN` is set. That's expected —
report the `repo_url` and note deployment is optional.

## Build fails for a specific file

The engine skips a file it can't generate rather than failing the whole build.
Report which files came back and offer to `update_app` to fill gaps.

## Rate limits

The Anthropic and Gemini providers fall back across models on rate limits. If
all models are exhausted, retry later or switch provider.

## Repo already exists

The pusher appends a timestamp to avoid name collisions, so a second build of
the same idea creates a distinct repo. To modify the first, use `update_app`.
