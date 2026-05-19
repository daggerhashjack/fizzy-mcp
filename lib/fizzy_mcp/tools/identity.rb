# frozen_string_literal: true

require "mcp"
require_relative "../tool_helpers"

module FizzyMcp
  module Tools
    module Identity
      module_function

      def all
        [
          MCP::Tool.define(
            name: "fizzy_identity_get",
            description: "Return the authenticated identity and the list of accounts it can access. Useful to discover account slugs.",
            annotations: { read_only_hint: true, idempotent_hint: true }
          ) do |server_context:, **_args|
            ToolHelpers.with_errors do
              client = server_context[:client]
              ToolHelpers.ok(Fizzy::Api::Identity.new(client).get)
            end
          end,

          MCP::Tool.define(
            name: "fizzy_identity_update_timezone",
            description: "Update the authenticated user's IANA timezone, e.g. 'America/New_York'.",
            input_schema: {
              properties: { timezone_name: { type: "string" } },
              required: ["timezone_name"]
            }
          ) do |server_context:, **args|
            ToolHelpers.with_errors do
              client = server_context[:client]
              ToolHelpers.ok(Fizzy::Api::Identity.new(client).update_timezone(args[:timezone_name]))
            end
          end
        ]
      end
    end
  end
end
