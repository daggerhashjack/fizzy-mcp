# frozen_string_literal: true

module Fizzy
  module Api
    class Webhooks
      def initialize(client, account_slug)
        @client = client
        @account_slug = account_slug
      end

      def list(board_id)
        @client.get("#{base(board_id)}/webhooks")
      end

      def get(board_id, webhook_id)
        @client.get("#{base(board_id)}/webhooks/#{webhook_id}")
      end

      def create(board_id, name:, url:, subscribed_actions: nil)
        body = { webhook: { name: name, url: url, subscribed_actions: subscribed_actions }.compact }
        @client.post("#{base(board_id)}/webhooks", body: body)
      end

      def update(board_id, webhook_id, attrs)
        @client.patch("#{base(board_id)}/webhooks/#{webhook_id}", body: { webhook: attrs.compact })
      end

      def delete(board_id, webhook_id)
        @client.delete("#{base(board_id)}/webhooks/#{webhook_id}")
      end

      def activate(board_id, webhook_id)
        @client.post("#{base(board_id)}/webhooks/#{webhook_id}/activation")
      end

      def deliveries(board_id, webhook_id)
        @client.get("#{base(board_id)}/webhooks/#{webhook_id}/deliveries")
      end

      private

      def base(board_id)
        "/#{@account_slug}/boards/#{board_id}"
      end
    end
  end
end
