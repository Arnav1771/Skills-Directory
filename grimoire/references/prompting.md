# Writing good build prompts

The build prompt is the spec. A precise prompt yields a coherent app; a vague
one yields a guess. When the user's request is thin, ask **1–2** sharp questions,
then build — don't interrogate.

## What a strong prompt names

- **What it is** — "a todo app", "a REST API for a bookstore", "a landing page".
- **Stack (if they care)** — "React + FastAPI", "Next.js", "Flask + SQLite".
- **Persistence** — in-memory, SQLite, Postgres, a file, none.
- **Key features** — auth, CRUD, search, dark mode, a specific endpoint set.
- **Surface** — web app, REST API, CLI, Discord bot, static site.

## Examples

Good:
- "a Flask todo app with SQLite persistence, add/complete/delete, and a dark-mode UI"
- "a FastAPI REST API for a bookstore with CRUD endpoints and Pydantic models, SQLite"
- "a React + Node/Express full-stack notes app with JWT auth and MongoDB"

Too vague (ask a question first):
- "an app" → what kind, and what should it do?
- "a website" → static marketing page, or an interactive app? any content?

## For updates

Describe the change concretely and scope it: "add a `/health` endpoint that
returns `{status: ok}`" beats "make it better". Use `experiment_app` on a new
branch for anything speculative.
