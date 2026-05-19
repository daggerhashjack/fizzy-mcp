# frozen_string_literal: true

require "mcp"
require_relative "../tool_helpers"

module FizzyMcp
  module Tools
    module Reactions
      module_function

      def all
        [
          MCP::Tool.define(
            name: "fizzy_reactions_list_card",
            description: "List reactions on a card.",
            input_schema: {
              properties: { card_number: { type: "integer" } },
              required: ["card_number"]
            },
            annotations: { read_only_hint: true, destructive_hint: false, idempotent_hint: true }
          ) do |server_context:, **args|
            ToolHelpers.with_errors do
              ToolHelpers.ok(server_context[:account].reactions.list_card_reactions(args[:card_number]))
            end
          end,

          MCP::Tool.define(
            name: "fizzy_reactions_create_card",
            description: "Add a reaction emoji to a card. Content is an emoji shortcode like ':thumbsup:'.",
            input_schema: {
              properties: { card_number: { type: "integer" }, content: { type: "string" } },
              required: %w[card_number content]
            }
          ) do |server_context:, **args|
            ToolHelpers.with_errors do
              ToolHelpers.ok(server_context[:account].reactions.create_card_reaction(args[:card_number], content: args[:content]))
            end
          end,

          MCP::Tool.define(
            name: "fizzy_reactions_delete_card",
            description: "Remove a reaction from a card.",
            input_schema: {
              properties: { card_number: { type: "integer" }, reaction_id: { type: "string" } },
              required: %w[card_number reaction_id]
            },
            annotations: { destructive_hint: true }
          ) do |server_context:, **args|
            ToolHelpers.with_errors do
              ToolHelpers.ok(server_context[:account].reactions.delete_card_reaction(args[:card_number], args[:reaction_id]))
            end
          end,

          MCP::Tool.define(
            name: "fizzy_reactions_list_comment",
            description: "List reactions on a comment.",
            input_schema: {
              properties: { card_number: { type: "integer" }, comment_id: { type: "string" } },
              required: %w[card_number comment_id]
            },
            annotations: { read_only_hint: true, destructive_hint: false, idempotent_hint: true }
          ) do |server_context:, **args|
            ToolHelpers.with_errors do
              ToolHelpers.ok(server_context[:account].reactions.list_comment_reactions(args[:card_number], args[:comment_id]))
            end
          end,

          MCP::Tool.define(
            name: "fizzy_reactions_create_comment",
            description: "Add a reaction to a comment.",
            input_schema: {
              properties: {
                card_number: { type: "integer" },
                comment_id: { type: "string" },
                content: { type: "string" }
              },
              required: %w[card_number comment_id content]
            }
          ) do |server_context:, **args|
            ToolHelpers.with_errors do
              ToolHelpers.ok(server_context[:account].reactions.create_comment_reaction(args[:card_number], args[:comment_id],
                                                                                        content: args[:content]))
            end
          end,

          MCP::Tool.define(
            name: "fizzy_reactions_delete_comment",
            description: "Remove a reaction from a comment.",
            input_schema: {
              properties: {
                card_number: { type: "integer" },
                comment_id: { type: "string" },
                reaction_id: { type: "string" }
              },
              required: %w[card_number comment_id reaction_id]
            },
            annotations: { destructive_hint: true }
          ) do |server_context:, **args|
            ToolHelpers.with_errors do
              ToolHelpers.ok(server_context[:account].reactions.delete_comment_reaction(args[:card_number], args[:comment_id],
                                                                                        args[:reaction_id]))
            end
          end
        ]
      end
    end
  end
end
