# Changelog

## 0.1.1 — 2026-05-18

Test coverage and annotation hygiene. No behavior changes worth noting.

- Adds rspec coverage for every API resource module (account, activities,
  columns, comments, exports, identity, notifications, pins, reactions,
  steps, tags, users, webhooks) plus a tool round-trip suite and a
  stdio binary integration test.
- Sets `destructive_hint: false` explicitly on every read-only tool to
  match the MCP spec — the SDK defaults destructive to true.
- 106 specs, all passing. Rubocop clean.

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
