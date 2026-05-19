# frozen_string_literal: true

require "mcp"
require_relative "../tool_helpers"

module FizzyMcp
  module Tools
    module Notifications
      module_function

      def all
        [
          MCP::Tool.define(
            name: "fizzy_notifications_list",
            description: "List notifications for the authenticated user.",
            annotations: { read_only_hint: true, idempotent_hint: true }
          ) do |server_context:, **_args|
            ToolHelpers.with_errors { ToolHelpers.ok(server_context[:account].notifications.list) }
          end,

          MCP::Tool.define(
            name: "fizzy_notifications_mark_read",
            description: "Mark a single notification as read.",
            input_schema: {
              properties: { notification_id: { type: "string" } },
              required: ["notification_id"]
            },
            annotations: { idempotent_hint: true }
          ) do |server_context:, **args|
            ToolHelpers.with_errors { ToolHelpers.ok(server_context[:account].notifications.mark_read(args[:notification_id])) }
          end,

          MCP::Tool.define(
            name: "fizzy_notifications_mark_unread",
            description: "Mark a single notification as unread.",
            input_schema: {
              properties: { notification_id: { type: "string" } },
              required: ["notification_id"]
            },
            annotations: { idempotent_hint: true }
          ) do |server_context:, **args|
            ToolHelpers.with_errors { ToolHelpers.ok(server_context[:account].notifications.mark_unread(args[:notification_id])) }
          end,

          MCP::Tool.define(
            name: "fizzy_notifications_mark_all_read",
            description: "Mark all notifications as read.",
            annotations: { idempotent_hint: true }
          ) do |server_context:, **_args|
            ToolHelpers.with_errors { ToolHelpers.ok(server_context[:account].notifications.mark_all_read) }
          end,

          MCP::Tool.define(
            name: "fizzy_notifications_settings",
            description: "Get the user's notification preferences.",
            annotations: { read_only_hint: true, idempotent_hint: true }
          ) do |server_context:, **_args|
            ToolHelpers.with_errors { ToolHelpers.ok(server_context[:account].notifications.settings) }
          end,

          MCP::Tool.define(
            name: "fizzy_notifications_update_settings",
            description: "Update the user's notification preferences.",
            input_schema: {
              properties: {
                email_enabled: { type: "boolean" },
                push_enabled: { type: "boolean" }
              }
            }
          ) do |server_context:, **args|
            ToolHelpers.with_errors { ToolHelpers.ok(server_context[:account].notifications.update_settings(args)) }
          end
        ]
      end
    end
  end
end
