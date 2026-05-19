# fizzy-mcp

An MCP server for [Fizzy](https://fizzy.do) — the kanban app from Basecamp. It exposes the Fizzy API as Model Context Protocol tools so an MCP client like Claude Code can read and manage your boards.

Not affiliated with Basecamp or 37signals.

## What's in the box

83 tools covering every Fizzy API surface as of mid-2026:

- identity, account, users
- boards (CRUD, publication, accesses)
- columns (CRUD, list cards)
- cards (CRUD plus close/reopen, triage, not_now, taggings, assignments, watch, gold)
- comments and reactions (cards and comments)
- checklist steps
- tags
- pins
- activities
- notifications and notification settings
- webhooks (CRUD plus activation and delivery history)
- data exports

If Fizzy adds endpoints, file an issue.

## Install

```bash
gem install fizzy-mcp
```

You need Ruby 3.1 or newer.

## Configure

Generate a personal access token in Fizzy: profile → API → Personal access tokens → Generate. Read or Read + Write depending on what you want to do.

Then set:

```bash
export FIZZY_ACCESS_TOKEN="..."
# optional — defaults to the first account on /my/identity
export FIZZY_ACCOUNT_SLUG="6206647"
# optional — for self-hosted Fizzy instances
export FIZZY_BASE_URL="https://app.fizzy.do"
```

The account slug is the numeric segment in Fizzy URLs (e.g. `app.fizzy.do/6206647/`). Leading slash is fine; the server strips it.

## Run

```bash
fizzy-mcp
```

That starts a stdio MCP server. Wire it into your MCP client of choice.

### Claude Code

Edit your `~/.claude.json` (or `.mcp.json`):

```json
{
  "mcpServers": {
    "fizzy": {
      "command": "fizzy-mcp",
      "env": {
        "FIZZY_ACCESS_TOKEN": "...",
        "FIZZY_ACCOUNT_SLUG": "6206647"
      }
    }
  }
}
```

Or `claude mcp add fizzy -- fizzy-mcp` and set env separately.

## Tool naming

All tools are prefixed `fizzy_` and follow `fizzy_<resource>_<action>`:

- `fizzy_boards_list`, `fizzy_boards_create`, `fizzy_boards_update`...
- `fizzy_cards_list`, `fizzy_cards_create`, `fizzy_cards_triage`, `fizzy_cards_close`...
- `fizzy_comments_create`, `fizzy_steps_update`...

Start with `fizzy_identity_get` to discover the accounts you have access to, then `fizzy_boards_list` to enumerate boards.

## Development

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

The tests stub HTTP via WebMock, so they run offline.

## License

MIT — see [LICENSE](LICENSE).
