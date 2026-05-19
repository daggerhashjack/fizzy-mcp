# frozen_string_literal: true

require "mcp"
require_relative "../tool_helpers"

module FizzyMcp
  module Tools
    module Cards
      module_function

      def all
        [
          MCP::Tool.define(
            name: "fizzy_cards_list",
            description: "List cards across the account with optional filters. Filter arrays accept multiple values.",
            input_schema: {
              properties: {
                board_ids: { type: "array", items: { type: "string" } },
                tag_ids: { type: "array", items: { type: "string" } },
                assignee_ids: { type: "array", items: { type: "string" } },
                creator_ids: { type: "array", items: { type: "string" } },
                closer_ids: { type: "array", items: { type: "string" } },
                card_ids: { type: "array", items: { type: "string" } },
                column_ids: { type: "array", items: { type: "string" } },
                indexed_by: {
                  type: "string",
                  enum: %w[all maybe closed not_now stalled postponing_soon golden]
                },
                sorted_by: { type: "string", enum: %w[latest newest oldest] },
                assignment_status: { type: "string", enum: %w[unassigned] },
                creation: { type: "string" },
                closure: { type: "string" },
                terms: { type: "array", items: { type: "string" } }
              }
            },
            annotations: { read_only_hint: true, destructive_hint: false, idempotent_hint: true }
          ) do |server_context:, **args|
            ToolHelpers.with_errors { ToolHelpers.ok(server_context[:account].cards.list(**args)) }
          end,

          MCP::Tool.define(
            name: "fizzy_cards_get",
            description: "Get a single card by its number.",
            input_schema: {
              properties: { card_number: { type: "integer" } },
              required: ["card_number"]
            },
            annotations: { read_only_hint: true, destructive_hint: false, idempotent_hint: true }
          ) do |server_context:, **args|
            ToolHelpers.with_errors { ToolHelpers.ok(server_context[:account].cards.get(args[:card_number])) }
          end,

          MCP::Tool.define(
            name: "fizzy_cards_create",
            description: "Create a new card on a board. Title is required; everything else is optional.",
            input_schema: {
              properties: {
                board_id: { type: "string" },
                title: { type: "string" },
                description: { type: "string", description: "Plain text or HTML (rich text)." },
                status: { type: "string", enum: %w[published drafted] },
                tag_ids: { type: "array", items: { type: "string" } },
                created_at: { type: "string", format: "date-time" },
                last_active_at: { type: "string", format: "date-time" }
              },
              required: %w[board_id title]
            }
          ) do |server_context:, **args|
            ToolHelpers.with_errors do
              board_id = args.delete(:board_id)
              ToolHelpers.ok(server_context[:account].cards.create(board_id, **args))
            end
          end,

          MCP::Tool.define(
            name: "fizzy_cards_update",
            description: "Update card title, description, status, tags, or last_active_at.",
            input_schema: {
              properties: {
                card_number: { type: "integer" },
                title: { type: "string" },
                description: { type: "string" },
                status: { type: "string", enum: %w[published drafted] },
                tag_ids: { type: "array", items: { type: "string" } },
                last_active_at: { type: "string", format: "date-time" }
              },
              required: ["card_number"]
            }
          ) do |server_context:, **args|
            ToolHelpers.with_errors do
              card_number = args.delete(:card_number)
              ToolHelpers.ok(server_context[:account].cards.update(card_number, args))
            end
          end,

          MCP::Tool.define(
            name: "fizzy_cards_delete",
            description: "Delete a card. Only the creator or a board admin can delete.",
            input_schema: {
              properties: { card_number: { type: "integer" } },
              required: ["card_number"]
            },
            annotations: { destructive_hint: true }
          ) do |server_context:, **args|
            ToolHelpers.with_errors { ToolHelpers.ok(server_context[:account].cards.delete(args[:card_number])) }
          end,

          MCP::Tool.define(
            name: "fizzy_cards_close",
            description: "Close a card (move to Done).",
            input_schema: {
              properties: { card_number: { type: "integer" } },
              required: ["card_number"]
            },
            annotations: { idempotent_hint: true }
          ) do |server_context:, **args|
            ToolHelpers.with_errors { ToolHelpers.ok(server_context[:account].cards.close(args[:card_number])) }
          end,

          MCP::Tool.define(
            name: "fizzy_cards_reopen",
            description: "Reopen a closed card.",
            input_schema: {
              properties: { card_number: { type: "integer" } },
              required: ["card_number"]
            },
            annotations: { idempotent_hint: true }
          ) do |server_context:, **args|
            ToolHelpers.with_errors { ToolHelpers.ok(server_context[:account].cards.reopen(args[:card_number])) }
          end,

          MCP::Tool.define(
            name: "fizzy_cards_not_now",
            description: "Move a card to the Not Now state.",
            input_schema: {
              properties: { card_number: { type: "integer" } },
              required: ["card_number"]
            },
            annotations: { idempotent_hint: true }
          ) do |server_context:, **args|
            ToolHelpers.with_errors { ToolHelpers.ok(server_context[:account].cards.not_now(args[:card_number])) }
          end,

          MCP::Tool.define(
            name: "fizzy_cards_triage",
            description: "Move a card into a workflow column.",
            input_schema: {
              properties: {
                card_number: { type: "integer" },
                column_id: { type: "string" }
              },
              required: %w[card_number column_id]
            }
          ) do |server_context:, **args|
            ToolHelpers.with_errors do
              ToolHelpers.ok(server_context[:account].cards.triage(args[:card_number], args[:column_id]))
            end
          end,

          MCP::Tool.define(
            name: "fizzy_cards_untriage",
            description: "Send a card back to triage (out of any column).",
            input_schema: {
              properties: { card_number: { type: "integer" } },
              required: ["card_number"]
            }
          ) do |server_context:, **args|
            ToolHelpers.with_errors { ToolHelpers.ok(server_context[:account].cards.untriage(args[:card_number])) }
          end,

          MCP::Tool.define(
            name: "fizzy_cards_toggle_tag",
            description: "Toggle a tag on or off for a card. Creates the tag if it doesn't exist. Leading '#' is stripped.",
            input_schema: {
              properties: {
                card_number: { type: "integer" },
                tag_title: { type: "string" }
              },
              required: %w[card_number tag_title]
            }
          ) do |server_context:, **args|
            ToolHelpers.with_errors do
              ToolHelpers.ok(server_context[:account].cards.toggle_tag(args[:card_number], args[:tag_title]))
            end
          end,

          MCP::Tool.define(
            name: "fizzy_cards_toggle_assignment",
            description: "Toggle a user's assignment on or off for a card.",
            input_schema: {
              properties: {
                card_number: { type: "integer" },
                assignee_id: { type: "string" }
              },
              required: %w[card_number assignee_id]
            }
          ) do |server_context:, **args|
            ToolHelpers.with_errors do
              ToolHelpers.ok(server_context[:account].cards.toggle_assignment(args[:card_number], args[:assignee_id]))
            end
          end,

          MCP::Tool.define(
            name: "fizzy_cards_watch",
            description: "Subscribe to notifications for a card.",
            input_schema: {
              properties: { card_number: { type: "integer" } },
              required: ["card_number"]
            },
            annotations: { idempotent_hint: true }
          ) do |server_context:, **args|
            ToolHelpers.with_errors { ToolHelpers.ok(server_context[:account].cards.watch(args[:card_number])) }
          end,

          MCP::Tool.define(
            name: "fizzy_cards_unwatch",
            description: "Unsubscribe from notifications for a card.",
            input_schema: {
              properties: { card_number: { type: "integer" } },
              required: ["card_number"]
            },
            annotations: { idempotent_hint: true }
          ) do |server_context:, **args|
            ToolHelpers.with_errors { ToolHelpers.ok(server_context[:account].cards.unwatch(args[:card_number])) }
          end,

          MCP::Tool.define(
            name: "fizzy_cards_gold",
            description: "Mark a card as golden (starred).",
            input_schema: {
              properties: { card_number: { type: "integer" } },
              required: ["card_number"]
            },
            annotations: { idempotent_hint: true }
          ) do |server_context:, **args|
            ToolHelpers.with_errors { ToolHelpers.ok(server_context[:account].cards.gold(args[:card_number])) }
          end,

          MCP::Tool.define(
            name: "fizzy_cards_ungold",
            description: "Remove the golden status from a card.",
            input_schema: {
              properties: { card_number: { type: "integer" } },
              required: ["card_number"]
            },
            annotations: { idempotent_hint: true }
          ) do |server_context:, **args|
            ToolHelpers.with_errors { ToolHelpers.ok(server_context[:account].cards.ungold(args[:card_number])) }
          end,

          MCP::Tool.define(
            name: "fizzy_cards_delete_image",
            description: "Remove the header image from a card.",
            input_schema: {
              properties: { card_number: { type: "integer" } },
              required: ["card_number"]
            }
          ) do |server_context:, **args|
            ToolHelpers.with_errors { ToolHelpers.ok(server_context[:account].cards.delete_image(args[:card_number])) }
          end
        ]
      end
    end
  end
end
