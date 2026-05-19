# Vault Schema — fizzy-mcp

Obsidian vault following the karpathy-wiki skill's three-layer model: `raw/` (immutable sources), `wiki/` (LLM-owned interlinked pages), this schema file.

Read `wiki/concepts/Wiki Discipline.md` alongside this file at session start. This file describes structure; the concept page describes when to write.

## Categories in `wiki/`

- `concepts/` — ideas, patterns, protocols, decisions
- `components/` — discrete technical pieces (the gem, the server entry point, individual MCP tool groups, etc.)
- `overviews/` — synthesis pages connecting multiple concepts
- `orgs/` — organizations (Basecamp, Anthropic)
- `people/` — individuals (rare for this project)
- `events/` — historical milestones (e.g. v0.1 release)

## Frontmatter

Every wiki page has:

```yaml
---
type: concept | component | overview | org | person | event
aliases: []
tags: []
sources: 0
updated: YYYY-MM-DD
related: []
---
```

## Wikilinks

`[[Page Name]]` inside the vault. Not markdown links.

## Three ops

- **Ingest:** new source → touch 5–15 pages → bump `sources` + `updated` → update `index.md` → log line.
- **Query:** read `index.md` first → pull pages → answer → file back syntheses.
- **Lint:** hunt contradictions, orphans, stale claims → report before fixing.

## Non-negotiable write rules

1. **Every commit writes a `log.md` line.** No exceptions. Ops: `init|ship|fix|refactor|doc|verify|lint|ingest`.
2. **Every non-obvious bug-fix writes a lesson** under `lessons/agent-failure-modes/<slug>.md` with What happened / Why / Signal.
3. **Every durable new fact writes a wiki page** (components, concepts, orgs).
4. **Every phase ship writes an event** and closes its thread.
5. **Every session ends with a four-point audit:** today's log entry? `index.md` complete? Threads closed? Lessons filed?

Enforced by `.githooks/pre-commit` on rule #1. Per-clone setup: `git config core.hooksPath .githooks`.

## Loading order

1. Project-root `CLAUDE.md`
2. This file
3. `preferences/*.md`
4. `index.md`
5. Task-relevant pages
6. Active `threads/*.md`
