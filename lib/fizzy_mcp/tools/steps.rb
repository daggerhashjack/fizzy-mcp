# frozen_string_literal: true

require "mcp"
require_relative "../tool_helpers"

module FizzyMcp
  module Tools
    module Steps
      module_function

      def all
        [
          MCP::Tool.define(
            name: "fizzy_steps_get",
            description: "Get a single checklist step on a card.",
            input_schema: {
              properties: { card_number: { type: "integer" }, step_id: { type: "string" } },
              required: %w[card_number step_id]
            },
            annotations: { read_only_hint: true, destructive_hint: false, idempotent_hint: true }
          ) do |server_context:, **args|
            ToolHelpers.with_errors do
              ToolHelpers.ok(server_context[:account].steps.get(args[:card_number], args[:step_id]))
            end
          end,

          MCP::Tool.define(
            name: "fizzy_steps_create",
            description: "Add a checklist step to a card.",
            input_schema: {
              properties: {
                card_number: { type: "integer" },
                content: { type: "string" },
                completed: { type: "boolean" }
              },
              required: %w[card_number content]
            }
          ) do |server_context:, **args|
            ToolHelpers.with_errors do
              ToolHelpers.ok(server_context[:account].steps.create(args[:card_number], content: args[:content],
                                                                                       completed: args[:completed]))
            end
          end,

          MCP::Tool.define(
            name: "fizzy_steps_update",
            description: "Edit a step's content or completion state.",
            input_schema: {
              properties: {
                card_number: { type: "integer" },
                step_id: { type: "string" },
                content: { type: "string" },
                completed: { type: "boolean" }
              },
              required: %w[card_number step_id]
            }
          ) do |server_context:, **args|
            ToolHelpers.with_errors do
              card_number = args.delete(:card_number)
              step_id = args.delete(:step_id)
              ToolHelpers.ok(server_context[:account].steps.update(card_number, step_id, args))
            end
          end,

          MCP::Tool.define(
            name: "fizzy_steps_delete",
            description: "Delete a checklist step.",
            input_schema: {
              properties: { card_number: { type: "integer" }, step_id: { type: "string" } },
              required: %w[card_number step_id]
            },
            annotations: { destructive_hint: true }
          ) do |server_context:, **args|
            ToolHelpers.with_errors do
              ToolHelpers.ok(server_context[:account].steps.delete(args[:card_number], args[:step_id]))
            end
          end
        ]
      end
    end
  end
end
