# frozen_string_literal: true

require "mcp"
require_relative "../tool_helpers"

module FizzyMcp
  module Tools
    module Exports
      module_function

      def all
        [
          MCP::Tool.define(
            name: "fizzy_exports_create_account",
            description: "Start an account-wide data export. Returns an export id you can poll."
          ) do |server_context:, **_args|
            ToolHelpers.with_errors { ToolHelpers.ok(server_context[:account].exports.create_account_export) }
          end,

          MCP::Tool.define(
            name: "fizzy_exports_get_account",
            description: "Check the status of an account export.",
            input_schema: {
              properties: { id: { type: "string" } },
              required: ["id"]
            },
            annotations: { read_only_hint: true, idempotent_hint: true }
          ) do |server_context:, **args|
            ToolHelpers.with_errors { ToolHelpers.ok(server_context[:account].exports.get_account_export(args[:id])) }
          end,

          MCP::Tool.define(
            name: "fizzy_exports_create_user",
            description: "Start a per-user data export.",
            input_schema: {
              properties: { user_id: { type: "string" } },
              required: ["user_id"]
            }
          ) do |server_context:, **args|
            ToolHelpers.with_errors { ToolHelpers.ok(server_context[:account].exports.create_user_export(args[:user_id])) }
          end,

          MCP::Tool.define(
            name: "fizzy_exports_get_user",
            description: "Check the status of a user export.",
            input_schema: {
              properties: { user_id: { type: "string" }, id: { type: "string" } },
              required: %w[user_id id]
            },
            annotations: { read_only_hint: true, idempotent_hint: true }
          ) do |server_context:, **args|
            ToolHelpers.with_errors { ToolHelpers.ok(server_context[:account].exports.get_user_export(args[:user_id], args[:id])) }
          end
        ]
      end
    end
  end
end
