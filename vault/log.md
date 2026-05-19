# Log

Append-only. Newest at top. Format: `## [YYYY-MM-DD] <op> | <short>`.

## [2026-05-18] ship | v0.1 — full Fizzy API surface as MCP tools

83 MCP tools across 15 resource groups (identity, account, boards,
columns, cards, comments, reactions, steps, tags, users, pins,
activities, notifications, webhooks, exports). Faraday-based client
with bearer-token auth, structured error responses for the typed HTTP
exceptions (Unauthorized, Forbidden, NotFound, UnprocessableEntity).
Stdio transport via the official `mcp` gem. 27/27 rspec green,
rubocop clean. README, CHANGELOG, gemspec ready for publish.

Surprises worth noting:
- MCP Ruby SDK invokes tool blocks as `tool.call(**args, server_context: ...)`,
  so the block signature must be `do |server_context:, **args|` — not
  `|args, server_context:|` as the README example suggests. README only
  works for tools with required schema fields; empty-args tools fail.
- Tool helper methods on the surrounding module (`def account(ctx)`)
  are unreachable from inside the block — the block's `self` is the
  dynamically created tool class. Inline `server_context[:account]`.
- `MCP::Tool::Response.new(content, error: true)` — keyword is `error:`,
  not `is_error:` despite the JSON-RPC field name being `isError`.

## [2026-05-18] init | fizzy-mcp scaffolded

Created the repo at github.com/daggerhashjack/fizzy-mcp, license MIT,
language Ruby. Scaffolded the karpathy-wiki vault, wrote project-root
`CLAUDE.md` pointing future agents at the user-level skills (karpathy-wiki,
software-construction, software-design, software-architecture,
knowledge-decomposition, humanize, mathematical-ux, design-engineering;
nap explicitly skipped). No code yet — the gem skeleton is next.
