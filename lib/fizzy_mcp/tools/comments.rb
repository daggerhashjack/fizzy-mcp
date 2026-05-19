# frozen_string_literal: true

require "mcp"
require_relative "../tool_helpers"

module FizzyMcp
  module Tools
    module Comments
      module_function

      def all
        [
          MCP::Tool.define(
            name: "fizzy_comments_list",
            description: "List comments on a card.",
            input_schema: {
              properties: { card_number: { type: "integer" } },
              required: ["card_number"]
            },
            annotations: { read_only_hint: true, destructive_hint: false, idempotent_hint: true }
          ) do |server_context:, **args|
            ToolHelpers.with_errors { ToolHelpers.ok(server_context[:account].comments.list(args[:card_number])) }
          end,

          MCP::Tool.define(
            name: "fizzy_comments_get",
            description: "Get a single comment.",
            input_schema: {
              properties: { card_number: { type: "integer" }, comment_id: { type: "string" } },
              required: %w[card_number comment_id]
            },
            annotations: { read_only_hint: true, destructive_hint: false, idempotent_hint: true }
          ) do |server_context:, **args|
            ToolHelpers.with_errors do
              ToolHelpers.ok(server_context[:account].comments.get(args[:card_number], args[:comment_id]))
            end
          end,

          MCP::Tool.define(
            name: "fizzy_comments_create",
            description: "Post a new comment on a card. Body can be plain text or rich text HTML.",
            input_schema: {
              properties: {
                card_number: { type: "integer" },
                body: { type: "string", description: "Comment body. Supports rich text HTML." },
                created_at: { type: "string", format: "date-time" }
              },
              required: %w[card_number body]
            }
          ) do |server_context:, **args|
            ToolHelpers.with_errors do
              ToolHelpers.ok(server_context[:account].comments.create(args[:card_number],
                                                                       body: args[:body],
                                                                       created_at: args[:created_at]))
            end
          end,

          MCP::Tool.define(
            name: "fizzy_comments_update",
            description: "Edit an existing comment.",
            input_schema: {
              properties: {
                card_number: { type: "integer" },
                comment_id: { type: "string" },
                body: { type: "string" }
              },
              required: %w[card_number comment_id body]
            }
          ) do |server_context:, **args|
            ToolHelpers.with_errors do
              ToolHelpers.ok(server_context[:account].comments.update(args[:card_number], args[:comment_id], body: args[:body]))
            end
          end,

          MCP::Tool.define(
            name: "fizzy_comments_delete",
            description: "Delete a comment.",
            input_schema: {
              properties: { card_number: { type: "integer" }, comment_id: { type: "string" } },
              required: %w[card_number comment_id]
            },
            annotations: { destructive_hint: true }
          ) do |server_context:, **args|
            ToolHelpers.with_errors do
              ToolHelpers.ok(server_context[:account].comments.delete(args[:card_number], args[:comment_id]))
            end
          end
        ]
      end
    end
  end
end
