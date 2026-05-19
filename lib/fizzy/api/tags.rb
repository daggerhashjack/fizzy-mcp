# frozen_string_literal: true

module Fizzy
  module Api
    class Tags
      def initialize(client, account_slug)
        @client = client
        @account_slug = account_slug
      end

      def list
        @client.get("/#{@account_slug}/tags")
      end
    end
  end
end
