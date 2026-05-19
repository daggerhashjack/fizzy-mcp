# frozen_string_literal: true

require "mcp"
require_relative "../fizzy"
require_relative "version"
require_relative "tool_helpers"
require_relative "tools/identity"
require_relative "tools/account"
require_relative "tools/boards"
require_relative "tools/columns"
require_relative "tools/cards"
require_relative "tools/comments"
require_relative "tools/reactions"
require_relative "tools/steps"
require_relative "tools/tags"
require_relative "tools/users"
require_relative "tools/pins"
require_relative "tools/activities"
require_relative "tools/notifications"
require_relative "tools/webhooks"
require_relative "tools/exports"

module FizzyMcp
  # Builds the MCP server with every tool registered and the
  # Fizzy::Account facade wired into server_context.
  module Server
    module_function

    # Build but do not start the server.
    #
    # token  — Fizzy personal access token. Defaults to ENV.
    # slug   — Account slug like "/6206647". Defaults to FIZZY_ACCOUNT_SLUG
    #          env var, or auto-discovered from /my/identity (first account).
    # base_url — override Fizzy base URL (self-hosted instances).
    def build(token: ENV.fetch("FIZZY_ACCESS_TOKEN", nil),
              slug: ENV.fetch("FIZZY_ACCOUNT_SLUG", nil),
              base_url: ENV.fetch("FIZZY_BASE_URL", nil))
      client = Fizzy::Client.new(**{ token: token, base_url: base_url }.compact)
      slug = discover_slug(client) if slug.nil? || slug.empty?
      account = Fizzy::Account.new(slug: normalize_slug(slug), client: client)

      MCP::Server.new(
        name: "fizzy-mcp",
        title: "Fizzy",
        version: FizzyMcp::VERSION,
        instructions: instructions,
        tools: all_tools,
        server_context: { client: client, account: account }
      )
    end

    # Build the server and serve it on stdio. Blocks.
    def run_stdio(**opts)
      server = build(**opts)
      transport = MCP::Server::Transports::StdioTransport.new(server)
      transport.open
    end

    def all_tools
      Tools::Identity.all +
        Tools::Account.all +
        Tools::Boards.all +
        Tools::Columns.all +
        Tools::Cards.all +
        Tools::Comments.all +
        Tools::Reactions.all +
        Tools::Steps.all +
        Tools::Tags.all +
        Tools::Users.all +
        Tools::Pins.all +
        Tools::Activities.all +
        Tools::Notifications.all +
        Tools::Webhooks.all +
        Tools::Exports.all
    end

    def discover_slug(client)
      identity = Fizzy::Api::Identity.new(client).get
      accounts = identity["accounts"]
      raise "Fizzy identity returned no accounts" if accounts.nil? || accounts.empty?

      accounts.first["slug"]
    end

    def normalize_slug(raw)
      raw.to_s.delete_prefix("/")
    end

    def instructions
      <<~TEXT
        Tools call the Fizzy kanban API. Cards are referenced by their human-readable
        number (e.g. 42); boards, columns, users, and tags use opaque ids. To see what's
        available, start with fizzy_boards_list and fizzy_identity_get.
      TEXT
    end
  end
end
