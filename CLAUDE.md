# fizzy-mcp

Model Context Protocol server for Fizzy (kanban) — exposes the Fizzy REST API as MCP tools.

## Loading order at session start

Invoke these user-level skills (`~/.claude/skills/`) early. They encode doctrine the maintainer prefers — follow by default unless something specific overrides:

- **`karpathy-wiki`** — operates the `vault/` (Obsidian-based LLM Wiki). Read its CLAUDE.md and `wiki/concepts/Wiki Discipline.md` before touching any vault file.
- **`software-construction`** — line / function scale construction doctrine.
- **`software-design`** — module-scale design doctrine.
- **`software-architecture`** — system-scale structure doctrine.
- **`knowledge-decomposition`** — for drawing module boundaries and noticing time-based decomposition smells.
- **`mathematical-ux`** — if any UI work shows up (probably won't for this server, but available).
- **`design-engineering`** — same.
- **`humanize`** — whenever drafting text for a human audience: commit messages, PR descriptions, release notes, issue replies. Re-read after drafting; if it reads like a changelog or AI summary, shorten it.

Skip the `nap` skill here — that's NotAutopilot-specific.

## Wiki discipline — non-negotiable

The full rules live in `vault/wiki/concepts/Wiki Discipline.md`. Read at session start alongside `vault/CLAUDE.md`. Summary:

1. Every commit writes a `vault/log.md` line. No exceptions.
2. Every non-obvious bug-fix writes a `vault/lessons/agent-failure-modes/<slug>.md`.
3. Every durable new fact writes a wiki page.
4. Every phase ship writes an event and closes its thread.
5. Every session ends with the four-point audit.

Rule #1 is enforced by `.githooks/pre-commit`. Set per-clone with `git config core.hooksPath .githooks`.

## Project overview

Wraps the Fizzy HTTP API (docs: <https://github.com/basecamp/fizzy/tree/main/docs/api>) as MCP tools. Built in Ruby. Authenticates with Fizzy via personal access token; consumer apps (e.g. Claude Code) talk to this server over MCP and don't see the PAT directly.

Public, MIT-licensed, lives at <https://github.com/daggerhashjack/fizzy-mcp>.

## Repo layout (expected, fill in as built)

```
fizzy-mcp/
├── CLAUDE.md             # this file
├── README.md             # human-facing
├── LICENSE               # MIT
├── lib/                  # the gem
├── exe/                  # CLI / server entry point
├── spec/                 # tests
├── vault/                # Karpathy LLM Wiki (private intent — see vault/CLAUDE.md)
└── .githooks/
    └── pre-commit        # enforces vault/log.md line per commit
```

## Build / run gates (advisory until v0.1)

Once there's code, the gates that should pass before any push:

1. `bundle exec rspec` green
2. `bundle exec rubocop` clean
3. The server starts and answers `tools/list` over stdio

Will harden as the project takes shape.
