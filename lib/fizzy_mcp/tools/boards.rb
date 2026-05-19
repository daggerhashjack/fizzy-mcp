# frozen_string_literal: true

require "mcp"
require_relative "../tool_helpers"

module FizzyMcp
  module Tools
    module Boards
      module_function

      def all
        [
          MCP::Tool.define(
            name: "fizzy_boards_list",
            description: "List all boards in the account.",
            annotations: { read_only_hint: true, idempotent_hint: true }
          ) do |server_context:, **_args|
            ToolHelpers.with_errors { ToolHelpers.ok(server_context[:account].boards.list) }
          end,

          MCP::Tool.define(
            name: "fizzy_boards_get",
            description: "Get a single board by id.",
            input_schema: {
              properties: { board_id: { type: "string" } },
              required: ["board_id"]
            },
            annotations: { read_only_hint: true, idempotent_hint: true }
          ) do |server_context:, **args|
            ToolHelpers.with_errors { ToolHelpers.ok(server_context[:account].boards.get(args[:board_id])) }
          end,

          MCP::Tool.define(
            name: "fizzy_boards_create",
            description: "Create a new board in the account.",
            input_schema: {
              properties: {
                name: { type: "string" },
                all_access: { type: "boolean" },
                auto_postpone_period_in_days: { type: "integer" },
                public_description: { type: "string" }
              },
              required: ["name"]
            }
          ) do |server_context:, **args|
            ToolHelpers.with_errors do
              ToolHelpers.ok(server_context[:account].boards.create(**args))
            end
          end,

          MCP::Tool.define(
            name: "fizzy_boards_update",
            description: "Update a board's name, access, postpone period, public description, or membership.",
            input_schema: {
              properties: {
                board_id: { type: "string" },
                name: { type: "string" },
                all_access: { type: "boolean" },
                auto_postpone_period_in_days: { type: "integer" },
                public_description: { type: "string" },
                user_ids: { type: "array", items: { type: "string" } }
              },
              required: ["board_id"]
            }
          ) do |server_context:, **args|
            ToolHelpers.with_errors do
              board_id = args.delete(:board_id)
              ToolHelpers.ok(server_context[:account].boards.update(board_id, args))
            end
          end,

          MCP::Tool.define(
            name: "fizzy_boards_delete",
            description: "Delete a board.",
            input_schema: {
              properties: { board_id: { type: "string" } },
              required: ["board_id"]
            },
            annotations: { destructive_hint: true }
          ) do |server_context:, **args|
            ToolHelpers.with_errors { ToolHelpers.ok(server_context[:account].boards.delete(args[:board_id])) }
          end,

          MCP::Tool.define(
            name: "fizzy_boards_accesses",
            description: "List who has access to a board and at what involvement level.",
            input_schema: {
              properties: { board_id: { type: "string" } },
              required: ["board_id"]
            },
            annotations: { read_only_hint: true, idempotent_hint: true }
          ) do |server_context:, **args|
            ToolHelpers.with_errors { ToolHelpers.ok(server_context[:account].boards.accesses(args[:board_id])) }
          end,

          MCP::Tool.define(
            name: "fizzy_boards_publish",
            description: "Publish a board to a public URL. Idempotent — returns the existing publication if already published.",
            input_schema: {
              properties: { board_id: { type: "string" } },
              required: ["board_id"]
            },
            annotations: { idempotent_hint: true }
          ) do |server_context:, **args|
            ToolHelpers.with_errors { ToolHelpers.ok(server_context[:account].boards.publish(args[:board_id])) }
          end,

          MCP::Tool.define(
            name: "fizzy_boards_unpublish",
            description: "Unpublish a board, removing public access.",
            input_schema: {
              properties: { board_id: { type: "string" } },
              required: ["board_id"]
            }
          ) do |server_context:, **args|
            ToolHelpers.with_errors { ToolHelpers.ok(server_context[:account].boards.unpublish(args[:board_id])) }
          end
        ]
      end
    end
  end
end
