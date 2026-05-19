# Changelog

## 0.1.2 — 2026-05-19

Three real bugs caught by exercising the server against a real Fizzy
account. All three are fixed.

- `fizzy_comments_create` / `fizzy_comments_update` — the API field
  is `body`, not `content`. Tool input schema and underlying client
  both updated. The doc's wording made this look like a 422 problem
  but it surfaced as a 400.
- `fizzy_pins_list` — the documented endpoint `GET /my/pins`
  returns a 302 to a session-only path when called with a bearer
  token. The account-scoped form `/<slug>/my/pins` works. Switched.
- `fizzy_webhooks_create` — was missing the required `name` field
  and used `event_types` where Fizzy expects `subscribed_actions`.
  Both fixed.

39 distinct tools verified end-to-end against a real Fizzy account.

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
