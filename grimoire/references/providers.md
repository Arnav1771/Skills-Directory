# Providers & keys

Grimoire is **bring-your-own-keys**. Always required: `GITHUB_TOKEN` (scope:
`repo`) and `GITHUB_USERNAME` — used to create and push the private repo to the
user's own account. Then one AI provider key, matching `AI_PROVIDER`:

| `AI_PROVIDER` | Key needed | Notes |
|---|---|---|
| `github-copilot` (default) | none beyond `GITHUB_TOKEN` | Free via GitHub Models; the GitHub token doubles as the model key. |
| `gemini` | `GEMINI_API_KEY` | Google Gemini. |
| `groq` | `GROQ_API_KEY` | Groq. |
| `anthropic` | `ANTHROPIC_API_KEY` | Direct Claude. The **only** provider needing an Anthropic key. |

`VERCEL_TOKEN` is optional — set it to auto-deploy the generated app to Vercel.

## Choosing a provider/model

Default (`github-copilot`) is a good starting point and needs no extra key. Only
override when the user asks. Anthropic models (via `provider="anthropic"`):

- `claude-sonnet-5` — balanced (default for this provider)
- `claude-opus-4-8` — most capable
- `claude-haiku-4-5` — fastest / cheapest

Call `list_available_models` (or `grimoire models`) for the full per-provider
list, including the GitHub Models catalog (GPT, Llama, Mistral, DeepSeek, etc.).

## Where keys live (never in chat)

- **MCP server:** in the server's `env` block in the client's MCP config.
- **CLI:** in the repo's `.env` (see the AppBuilder README).

Never ask the user to paste a key into the conversation, and never echo one.
