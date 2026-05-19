# frozen_string_literal: true

require "mcp"
require_relative "../tool_helpers"

module FizzyMcp
  module Tools
    module Users
      module_function

      def all
        [
          MCP::Tool.define(
            name: "fizzy_users_list",
            description: "List active users in the account.",
            annotations: { read_only_hint: true, idempotent_hint: true }
          ) do |server_context:, **_args|
            ToolHelpers.with_errors { ToolHelpers.ok(server_context[:account].users.list) }
          end,

          MCP::Tool.define(
            name: "fizzy_users_get",
            description: "Get a single user record.",
            input_schema: {
              properties: { user_id: { type: "string" } },
              required: ["user_id"]
            },
            annotations: { read_only_hint: true, idempotent_hint: true }
          ) do |server_context:, **args|
            ToolHelpers.with_errors { ToolHelpers.ok(server_context[:account].users.get(args[:user_id])) }
          end,

          MCP::Tool.define(
            name: "fizzy_users_update",
            description: "Update a user's name, role, or other profile fields. Caller needs admin/owner privileges.",
            input_schema: {
              properties: {
                user_id: { type: "string" },
                name: { type: "string" },
                role: { type: "string", enum: %w[owner admin user] },
                active: { type: "boolean" }
              },
              required: ["user_id"]
            }
          ) do |server_context:, **args|
            ToolHelpers.with_errors do
              user_id = args.delete(:user_id)
              ToolHelpers.ok(server_context[:account].users.update(user_id, args))
            end
          end,

          MCP::Tool.define(
            name: "fizzy_users_delete_avatar",
            description: "Remove a user's avatar image.",
            input_schema: {
              properties: { user_id: { type: "string" } },
              required: ["user_id"]
            }
          ) do |server_context:, **args|
            ToolHelpers.with_errors { ToolHelpers.ok(server_context[:account].users.delete_avatar(args[:user_id])) }
          end,

          MCP::Tool.define(
            name: "fizzy_users_add_email_address",
            description: "Add an alternate email address to a user (requires confirmation).",
            input_schema: {
              properties: { user_id: { type: "string" }, email_address: { type: "string" } },
              required: %w[user_id email_address]
            }
          ) do |server_context:, **args|
            ToolHelpers.with_errors do
              ToolHelpers.ok(server_context[:account].users.add_email_address(args[:user_id], args[:email_address]))
            end
          end,

          MCP::Tool.define(
            name: "fizzy_users_confirm_email_address",
            description: "Confirm an alternate email address using the confirmation token from the email.",
            input_schema: {
              properties: { user_id: { type: "string" }, token: { type: "string" } },
              required: %w[user_id token]
            }
          ) do |server_context:, **args|
            ToolHelpers.with_errors do
              ToolHelpers.ok(server_context[:account].users.confirm_email_address(args[:user_id], args[:token]))
            end
          end,

          MCP::Tool.define(
            name: "fizzy_users_delete",
            description: "Remove a user from the account.",
            input_schema: {
              properties: { user_id: { type: "string" } },
              required: ["user_id"]
            },
            annotations: { destructive_hint: true }
          ) do |server_context:, **args|
            ToolHelpers.with_errors { ToolHelpers.ok(server_context[:account].users.delete(args[:user_id])) }
          end
        ]
      end
    end
  end
end
