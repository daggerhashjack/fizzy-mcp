# frozen_string_literal: true

module Fizzy
  module Api
    class Account
      def initialize(client, account_slug)
        @client = client
        @account_slug = account_slug
      end

      def settings
        @client.get("#{base}/settings")
      end

      def join_code
        @client.get("#{base}/join_code")
      end

      def regenerate_join_code
        @client.put("#{base}/join_code")
      end

      def disable_join_code
        @client.delete("#{base}/join_code")
      end

      def reset_account_entropy
        @client.put("#{base}/entropy")
      end

      def reset_board_entropy(board_id)
        @client.put("/#{@account_slug}/boards/#{board_id}/entropy")
      end

      private

      def base
        "/#{@account_slug}/account"
      end
    end
  end
end
