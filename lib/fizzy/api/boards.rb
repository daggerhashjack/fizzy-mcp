# frozen_string_literal: true

module Fizzy
  module Api
    class Boards
      def initialize(client, account_slug)
        @client = client
        @account_slug = account_slug
      end

      def list
        @client.get("#{base}/boards")
      end

      def get(board_id)
        @client.get("#{base}/boards/#{board_id}")
      end

      def create(name:, all_access: nil, auto_postpone_period_in_days: nil, public_description: nil)
        body = { board: compact(name: name, all_access: all_access,
                                auto_postpone_period_in_days: auto_postpone_period_in_days,
                                public_description: public_description) }
        @client.post("#{base}/boards", body: body)
      end

      def update(board_id, attrs)
        @client.put("#{base}/boards/#{board_id}", body: { board: compact(attrs) })
      end

      def delete(board_id)
        @client.delete("#{base}/boards/#{board_id}")
      end

      def accesses(board_id)
        @client.get("#{base}/boards/#{board_id}/accesses")
      end

      def publish(board_id)
        @client.post("#{base}/boards/#{board_id}/publication")
      end

      def unpublish(board_id)
        @client.delete("#{base}/boards/#{board_id}/publication")
      end

      private

      def base
        "/#{@account_slug}"
      end

      def compact(hash)
        hash.compact
      end
    end
  end
end
