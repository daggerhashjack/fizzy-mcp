# frozen_string_literal: true

module Fizzy
  module Api
    class Comments
      def initialize(client, account_slug)
        @client = client
        @account_slug = account_slug
      end

      def list(card_number)
        @client.get("#{base}/cards/#{card_number}/comments")
      end

      def get(card_number, comment_id)
        @client.get("#{base}/cards/#{card_number}/comments/#{comment_id}")
      end

      def create(card_number, content:)
        @client.post("#{base}/cards/#{card_number}/comments",
                     body: { comment: { content: content } })
      end

      def update(card_number, comment_id, content:)
        @client.put("#{base}/cards/#{card_number}/comments/#{comment_id}",
                    body: { comment: { content: content } })
      end

      def delete(card_number, comment_id)
        @client.delete("#{base}/cards/#{card_number}/comments/#{comment_id}")
      end

      private

      def base
        "/#{@account_slug}"
      end
    end
  end
end
