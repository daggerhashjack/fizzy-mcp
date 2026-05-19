# frozen_string_literal: true

module Fizzy
  module Api
    class Steps
      def initialize(client, account_slug)
        @client = client
        @account_slug = account_slug
      end

      def get(card_number, step_id)
        @client.get("#{base}/cards/#{card_number}/steps/#{step_id}")
      end

      def create(card_number, content:, completed: nil)
        body = { step: { content: content, completed: completed }.compact }
        @client.post("#{base}/cards/#{card_number}/steps", body: body)
      end

      def update(card_number, step_id, attrs)
        @client.put("#{base}/cards/#{card_number}/steps/#{step_id}", body: { step: attrs.compact })
      end

      def delete(card_number, step_id)
        @client.delete("#{base}/cards/#{card_number}/steps/#{step_id}")
      end

      private

      def base
        "/#{@account_slug}"
      end
    end
  end
end
