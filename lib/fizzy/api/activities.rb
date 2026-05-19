# frozen_string_literal: true

module Fizzy
  module Api
    class Activities
      def initialize(client, account_slug)
        @client = client
        @account_slug = account_slug
      end

      def list(**filters)
        params = filters.compact.transform_keys(&:to_s)
        @client.get("/#{@account_slug}/activities", params: params)
      end
    end
  end
end
