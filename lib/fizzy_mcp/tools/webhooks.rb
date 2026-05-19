# frozen_string_literal: true

require "mcp"
require_relative "../tool_helpers"

module FizzyMcp
  module Tools
    module Webhooks
      module_function

      def all
        [
          MCP::Tool.define(
            name: "fizzy_webhooks_list",
            description: "List webhooks on a board.",
            input_schema: {
              properties: { board_id: { type: "string" } },
              required: ["board_id"]
            },
            annotations: { read_only_hint: true, idempotent_hint: true }
          ) do |server_context:, **args|
            ToolHelpers.with_errors { ToolHelpers.ok(server_context[:account].webhooks.list(args[:board_id])) }
          end,

          MCP::Tool.define(
            name: "fizzy_webhooks_get",
            description: "Get a single webhook.",
            input_schema: {
              properties: { board_id: { type: "string" }, webhook_id: { type: "string" } },
              required: %w[board_id webhook_id]
            },
            annotations: { read_only_hint: true, idempotent_hint: true }
          ) do |server_context:, **args|
            ToolHelpers.with_errors do
              ToolHelpers.ok(server_context[:account].webhooks.get(args[:board_id], args[:webhook_id]))
            end
          end,

          MCP::Tool.define(
            name: "fizzy_webhooks_create",
            description: "Create a webhook on a board pointing at a URL.",
            input_schema: {
              properties: {
                board_id: { type: "string" },
                url: { type: "string", format: "uri" },
                event_types: { type: "array", items: { type: "string" } }
              },
              required: %w[board_id url]
            }
          ) do |server_context:, **args|
            ToolHelpers.with_errors do
              ToolHelpers.ok(server_context[:account].webhooks.create(args[:board_id], url: args[:url], event_types: args[:event_types]))
            end
          end,

          MCP::Tool.define(
            name: "fizzy_webhooks_update",
            description: "Update a webhook's URL or event_types.",
            input_schema: {
              properties: {
                board_id: { type: "string" },
                webhook_id: { type: "string" },
                url: { type: "string", format: "uri" },
                event_types: { type: "array", items: { type: "string" } }
              },
              required: %w[board_id webhook_id]
            }
          ) do |server_context:, **args|
            ToolHelpers.with_errors do
              board_id = args.delete(:board_id)
              webhook_id = args.delete(:webhook_id)
              ToolHelpers.ok(server_context[:account].webhooks.update(board_id, webhook_id, args))
            end
          end,

          MCP::Tool.define(
            name: "fizzy_webhooks_delete",
            description: "Delete a webhook.",
            input_schema: {
              properties: { board_id: { type: "string" }, webhook_id: { type: "string" } },
              required: %w[board_id webhook_id]
            },
            annotations: { destructive_hint: true }
          ) do |server_context:, **args|
            ToolHelpers.with_errors do
              ToolHelpers.ok(server_context[:account].webhooks.delete(args[:board_id], args[:webhook_id]))
            end
          end,

          MCP::Tool.define(
            name: "fizzy_webhooks_activate",
            description: "Re-activate a disabled webhook (e.g. after too many failed deliveries).",
            input_schema: {
              properties: { board_id: { type: "string" }, webhook_id: { type: "string" } },
              required: %w[board_id webhook_id]
            }
          ) do |server_context:, **args|
            ToolHelpers.with_errors do
              ToolHelpers.ok(server_context[:account].webhooks.activate(args[:board_id], args[:webhook_id]))
            end
          end,

          MCP::Tool.define(
            name: "fizzy_webhooks_deliveries",
            description: "List recent delivery attempts for a webhook (success/failure history).",
            input_schema: {
              properties: { board_id: { type: "string" }, webhook_id: { type: "string" } },
              required: %w[board_id webhook_id]
            },
            annotations: { read_only_hint: true, idempotent_hint: true }
          ) do |server_context:, **args|
            ToolHelpers.with_errors do
              ToolHelpers.ok(server_context[:account].webhooks.deliveries(args[:board_id], args[:webhook_id]))
            end
          end
        ]
      end
    end
  end
end
