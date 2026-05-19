# frozen_string_literal: true

require "mcp"
require_relative "../tool_helpers"

module FizzyMcp
  module Tools
    module Columns
      module_function

      def all
        [
          MCP::Tool.define(
            name: "fizzy_columns_list",
            description: "List columns on a board (workflow stages), in position order.",
            input_schema: {
              properties: { board_id: { type: "string" } },
              required: ["board_id"]
            },
            annotations: { read_only_hint: true, destructive_hint: false, idempotent_hint: true }
          ) do |server_context:, **args|
            ToolHelpers.with_errors { ToolHelpers.ok(server_context[:account].columns.list(args[:board_id])) }
          end,

          MCP::Tool.define(
            name: "fizzy_columns_get",
            description: "Get a single column's metadata.",
            input_schema: {
              properties: { board_id: { type: "string" }, column_id: { type: "string" } },
              required: %w[board_id column_id]
            },
            annotations: { read_only_hint: true, destructive_hint: false, idempotent_hint: true }
          ) do |server_context:, **args|
            ToolHelpers.with_errors do
              ToolHelpers.ok(server_context[:account].columns.get(args[:board_id], args[:column_id]))
            end
          end,

          MCP::Tool.define(
            name: "fizzy_columns_cards",
            description: "List cards currently triaged into a workflow column.",
            input_schema: {
              properties: { board_id: { type: "string" }, column_id: { type: "string" } },
              required: %w[board_id column_id]
            },
            annotations: { read_only_hint: true, destructive_hint: false, idempotent_hint: true }
          ) do |server_context:, **args|
            ToolHelpers.with_errors do
              ToolHelpers.ok(server_context[:account].columns.cards(args[:board_id], args[:column_id]))
            end
          end,

          MCP::Tool.define(
            name: "fizzy_columns_create",
            description: "Create a new workflow column on a board.",
            input_schema: {
              properties: {
                board_id: { type: "string" },
                name: { type: "string" },
                color: {
                  type: "string",
                  description: "var(--color-card-default), var(--color-card-1), ..., var(--color-card-8)"
                }
              },
              required: %w[board_id name]
            }
          ) do |server_context:, **args|
            ToolHelpers.with_errors do
              ToolHelpers.ok(server_context[:account].columns.create(args[:board_id], name: args[:name], color: args[:color]))
            end
          end,

          MCP::Tool.define(
            name: "fizzy_columns_update",
            description: "Rename or recolor a column.",
            input_schema: {
              properties: {
                board_id: { type: "string" },
                column_id: { type: "string" },
                name: { type: "string" },
                color: { type: "string" }
              },
              required: %w[board_id column_id]
            }
          ) do |server_context:, **args|
            ToolHelpers.with_errors do
              board_id = args.delete(:board_id)
              column_id = args.delete(:column_id)
              ToolHelpers.ok(server_context[:account].columns.update(board_id, column_id, args))
            end
          end,

          MCP::Tool.define(
            name: "fizzy_columns_delete",
            description: "Delete a workflow column.",
            input_schema: {
              properties: { board_id: { type: "string" }, column_id: { type: "string" } },
              required: %w[board_id column_id]
            },
            annotations: { destructive_hint: true }
          ) do |server_context:, **args|
            ToolHelpers.with_errors do
              ToolHelpers.ok(server_context[:account].columns.delete(args[:board_id], args[:column_id]))
            end
          end
        ]
      end
    end
  end
end
