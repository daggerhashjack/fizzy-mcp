# frozen_string_literal: true

module Fizzy
  module Api
    class Columns
      def initialize(client, account_slug)
        @client = client
        @account_slug = account_slug
      end

      def list(board_id)
        @client.get("#{base}/boards/#{board_id}/columns")
      end

      def get(board_id, column_id)
        @client.get("#{base}/boards/#{board_id}/columns/#{column_id}")
      end

      def cards(board_id, column_id)
        @client.get("#{base}/boards/#{board_id}/columns/#{column_id}/cards")
      end

      def create(board_id, name:, color: nil)
        body = { column: { name: name, color: color }.compact }
        @client.post("#{base}/boards/#{board_id}/columns", body: body)
      end

      def update(board_id, column_id, attrs)
        @client.put("#{base}/boards/#{board_id}/columns/#{column_id}", body: { column: attrs.compact })
      end

      def delete(board_id, column_id)
        @client.delete("#{base}/boards/#{board_id}/columns/#{column_id}")
      end

      private

      def base
        "/#{@account_slug}"
      end
    end
  end
end
