# frozen_string_literal: true

require "mcp"
require_relative "../tool_helpers"

module FizzyMcp
  module Tools
    module Pins
      module_function

      def all
        [
          MCP::Tool.define(
            name: "fizzy_pins_list",
            description: "List the authenticated user's pinned cards in this account.",
            annotations: { read_only_hint: true, destructive_hint: false, idempotent_hint: true }
          ) do |server_context:, **_args|
            ToolHelpers.with_errors { ToolHelpers.ok(server_context[:account].pins.list) }
          end,

          MCP::Tool.define(
            name: "fizzy_pins_pin",
            description: "Pin a card to your home view.",
            input_schema: {
              properties: { card_number: { type: "integer" } },
              required: ["card_number"]
            },
            annotations: { idempotent_hint: true }
          ) do |server_context:, **args|
            ToolHelpers.with_errors { ToolHelpers.ok(server_context[:account].pins.pin(args[:card_number])) }
          end,

          MCP::Tool.define(
            name: "fizzy_pins_unpin",
            description: "Unpin a card.",
            input_schema: {
              properties: { card_number: { type: "integer" } },
              required: ["card_number"]
            },
            annotations: { idempotent_hint: true }
          ) do |server_context:, **args|
            ToolHelpers.with_errors { ToolHelpers.ok(server_context[:account].pins.unpin(args[:card_number])) }
          end
        ]
      end
    end
  end
end
