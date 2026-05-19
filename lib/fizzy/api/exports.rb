# frozen_string_literal: true

module Fizzy
  module Api
    class Exports
      def initialize(client, account_slug)
        @client = client
        @account_slug = account_slug
      end

      def create_account_export
        @client.post("#{base}/account/exports")
      end

      def get_account_export(id)
        @client.get("#{base}/account/exports/#{id}")
      end

      def create_user_export(user_id)
        @client.post("#{base}/users/#{user_id}/data_exports")
      end

      def get_user_export(user_id, id)
        @client.get("#{base}/users/#{user_id}/data_exports/#{id}")
      end

      private

      def base
        "/#{@account_slug}"
      end
    end
  end
end
