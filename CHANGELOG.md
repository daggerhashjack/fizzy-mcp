# Changelog

## 0.1.0 — 2026-05-18

First release. Covers every Fizzy HTTP API endpoint we know about as 83 MCP tools:

- identity (`fizzy_identity_get`, timezone update)
- account, users, tags, pins
- boards (CRUD, publication, accesses)
- columns (CRUD, list cards in a column)
- cards (CRUD plus close, reopen, triage, not_now, taggings, assignments, watch, gold)
- comments and reactions
- checklist steps
- activities
- notifications and settings
- webhooks
- data exports

Stdio transport. Bearer token auth via `FIZZY_ACCESS_TOKEN`. Account slug from `FIZZY_ACCOUNT_SLUG` or auto-discovered.
