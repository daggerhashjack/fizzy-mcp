# frozen_string_literal: true

require "mcp"
require_relative "../tool_helpers"

module FizzyMcp
  module Tools
    module Account
      module_function

      def all
        [
          MCP::Tool.define(
            name: "fizzy_account_settings",
            description: "Get the account-level settings.",
            annotations: { read_only_hint: true, destructive_hint: false, idempotent_hint: true }
          ) do |server_context:, **_args|
            ToolHelpers.with_errors { ToolHelpers.ok(server_context[:account].account.settings) }
          end,

          MCP::Tool.define(
            name: "fizzy_account_join_code",
            description: "Get the current join code for the account.",
            annotations: { read_only_hint: true, destructive_hint: false, idempotent_hint: true }
          ) do |server_context:, **_args|
            ToolHelpers.with_errors { ToolHelpers.ok(server_context[:account].account.join_code) }
          end,

          MCP::Tool.define(
            name: "fizzy_account_regenerate_join_code",
            description: "Generate a fresh join code, invalidating the previous one."
          ) do |server_context:, **_args|
            ToolHelpers.with_errors { ToolHelpers.ok(server_context[:account].account.regenerate_join_code) }
          end,

          MCP::Tool.define(
            name: "fizzy_account_disable_join_code",
            description: "Disable the join code (no new users can join via link)."
          ) do |server_context:, **_args|
            ToolHelpers.with_errors { ToolHelpers.ok(server_context[:account].account.disable_join_code) }
          end,

          MCP::Tool.define(
            name: "fizzy_account_reset_entropy",
            description: "Reset account entropy — rotates account-wide secrets. Use sparingly.",
            annotations: { destructive_hint: true }
          ) do |server_context:, **_args|
            ToolHelpers.with_errors { ToolHelpers.ok(server_context[:account].account.reset_account_entropy) }
          end,

          MCP::Tool.define(
            name: "fizzy_account_reset_board_entropy",
            description: "Reset entropy for a single board.",
            input_schema: {
              properties: { board_id: { type: "string" } },
              required: ["board_id"]
            },
            annotations: { destructive_hint: true }
          ) do |server_context:, **args|
            ToolHelpers.with_errors { ToolHelpers.ok(server_context[:account].account.reset_board_entropy(args[:board_id])) }
          end
        ]
      end
    end
  end
end
