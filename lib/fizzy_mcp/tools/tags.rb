# frozen_string_literal: true

require "mcp"
require_relative "../tool_helpers"

module FizzyMcp
  module Tools
    module Tags
      module_function

      def all
        [
          MCP::Tool.define(
            name: "fizzy_tags_list",
            description: "List all tags in the account.",
            annotations: { read_only_hint: true, destructive_hint: false, idempotent_hint: true }
          ) do |server_context:, **_args|
            ToolHelpers.with_errors { ToolHelpers.ok(server_context[:account].tags.list) }
          end
        ]
      end
    end
  end
end
