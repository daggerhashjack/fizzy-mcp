# frozen_string_literal: true

module Fizzy
  module Api
    class Notifications
      def initialize(client, account_slug)
        @client = client
        @account_slug = account_slug
      end

      def list
        @client.get("#{base}/notifications")
      end

      def mark_read(notification_id)
        @client.post("#{base}/notifications/#{notification_id}/reading")
      end

      def mark_unread(notification_id)
        @client.delete("#{base}/notifications/#{notification_id}/reading")
      end

      def mark_all_read
        @client.post("#{base}/notifications/bulk_reading")
      end

      def settings
        @client.get("#{base}/notifications/settings")
      end

      def update_settings(attrs)
        @client.put("#{base}/notifications/settings", body: { settings: attrs.compact })
      end

      private

      def base
        "/#{@account_slug}"
      end
    end
  end
end
