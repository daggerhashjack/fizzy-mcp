# frozen_string_literal: true

module Fizzy
  module Api
    class Users
      def initialize(client, account_slug)
        @client = client
        @account_slug = account_slug
      end

      def list
        @client.get("#{base}/users")
      end

      def get(user_id)
        @client.get("#{base}/users/#{user_id}")
      end

      def update(user_id, attrs)
        @client.put("#{base}/users/#{user_id}", body: { user: attrs.compact })
      end

      def delete_avatar(user_id)
        @client.delete("#{base}/users/#{user_id}/avatar")
      end

      def add_email_address(user_id, email_address)
        @client.post("#{base}/users/#{user_id}/email_addresses",
                     body: { email_address: { address: email_address } })
      end

      def confirm_email_address(user_id, token)
        @client.post("#{base}/users/#{user_id}/email_addresses/#{token}/confirmation")
      end

      def delete(user_id)
        @client.delete("#{base}/users/#{user_id}")
      end

      private

      def base
        "/#{@account_slug}"
      end
    end
  end
end
