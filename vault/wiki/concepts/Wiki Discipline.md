---
type: concept
aliases: [discipline, vault rules]
tags: [vault, doctrine]
sources: 0
updated: 2026-05-18
related: []
---

# Wiki Discipline

The five non-negotiable rules that keep the vault from drifting. Lifted from the karpathy-wiki skill. Read once, then enforce.

## Why this exists

I learned this on a project where Phase 2 + a Ralph loop shipped ~20 commits with only 2 log entries and 2 lessons. The vault looked current but was 80% stale. Every rule below is the correction for one way that happens.

## The five rules

1. **Every commit writes a `log.md` line.** No exceptions — autopilot, Ralph loops, "minor" commits included. Format:

   ```markdown
   ## [YYYY-MM-DD] <op> | <short>

   One sentence on what changed and why.
   ```

   Ops: `init | ship | fix | refactor | doc | verify | lint | ingest`.

   Enforced by `.githooks/pre-commit`. Bypass only when the log line for this commit was written by a prior commit in the same batch.

2. **Every non-obvious bug-fix writes a lesson.** Non-obvious = diagnosis required logs, devtools, or >5 minutes of thinking. File at `lessons/agent-failure-modes/<slug>.md` with three sections: What happened / Why / Signal. One root cause per file.

3. **Every durable new fact writes a wiki page.** New component → `wiki/components/`. New concept or pattern → `wiki/concepts/`. New third party → `wiki/orgs/`. Commit messages answer "what did you do?" — the wiki answers "what should future-you know?"

4. **Every phase ship writes an event and closes its thread.** `wiki/events/<Name> Shipped.md`. Thread goes `status: active` → `status: closed` + `closed: YYYY-MM-DD`.

5. **Every session of substantive work ends with a four-point audit.** Before declaring done:
   - Newest `log.md` entry is today?
   - Every page in `wiki/**` is listed in `index.md`?
   - Every completed thread is `status: closed`?
   - Every non-obvious bug in the last commit batch has a lesson?

   If any answer is "no", the session isn't done.

## Ralph / autopilot addendum

Modes that encourage "fix → commit → loop" cause the most drift. In these modes, each iteration writes its log line *in that iteration*, not batched at end. Each non-obvious bug writes its lesson in that iteration. The pass closes with `ship | Ralph pass N: <summary>`.

## Common mistakes

- **Adding wiki content without updating `index.md` or `log.md`.** Schema requires both.
- **Siloing a lesson when the durable fact belongs in `wiki/`.** Hoist it.
- **Using markdown links where wikilinks would do.** Prefer `[[Page Name]]`.
- **Silently rewriting a page when a source contradicts it.** Flag, don't hide.
- **Treating commit messages as the knowledge store.** Different layer, different question.
- **Bypassing `--no-verify` routinely.** If it becomes habitual, run the four-point audit.
- **Batching log entries at end of session.** The whole point is per-commit attribution.
