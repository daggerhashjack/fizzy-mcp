# frozen_string_literal: true

require "mcp"
require_relative "../tool_helpers"

module FizzyMcp
  module Tools
    module Activities
      module_function

      def all
        [
          MCP::Tool.define(
            name: "fizzy_activities_list",
            description: "List recent activity for the account, optionally filtered by board or user.",
            input_schema: {
              properties: {
                board_ids: { type: "array", items: { type: "string" } },
                user_ids: { type: "array", items: { type: "string" } },
                start_date: { type: "string", format: "date" },
                end_date: { type: "string", format: "date" }
              }
            },
            annotations: { read_only_hint: true, idempotent_hint: true }
          ) do |server_context:, **args|
            ToolHelpers.with_errors { ToolHelpers.ok(server_context[:account].activities.list(**args)) }
          end
        ]
      end
    end
  end
end
