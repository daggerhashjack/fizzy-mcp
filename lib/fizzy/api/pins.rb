# frozen_string_literal: true

module Fizzy
  module Api
    class Pins
      def initialize(client, account_slug)
        @client = client
        @account_slug = account_slug
      end

      def pin(card_number)
        @client.post("/#{@account_slug}/cards/#{card_number}/pin")
      end

      def unpin(card_number)
        @client.delete("/#{@account_slug}/cards/#{card_number}/pin")
      end

      def list
        # The Fizzy doc says GET /my/pins, but in practice that endpoint
        # only works with a session cookie. Bearer-auth callers must use
        # the account-scoped form.
        @client.get("/#{@account_slug}/my/pins")
      end
    end
  end
end
