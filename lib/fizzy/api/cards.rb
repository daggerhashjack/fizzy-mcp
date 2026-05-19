# frozen_string_literal: true

module Fizzy
  module Api
    class Cards
      LIST_FILTERS = %i[
        board_ids tag_ids assignee_ids creator_ids closer_ids card_ids
        column_ids indexed_by sorted_by assignment_status creation closure terms
      ].freeze

      def initialize(client, account_slug)
        @client = client
        @account_slug = account_slug
      end

      def list(**filters)
        @client.get("#{base}/cards", params: filter_params(filters))
      end

      def get(card_number)
        @client.get("#{base}/cards/#{card_number}")
      end

      def create(board_id, title:, description: nil, status: nil, tag_ids: nil,
                 created_at: nil, last_active_at: nil)
        body = { card: { title: title, description: description, status: status,
                         tag_ids: tag_ids, created_at: created_at,
                         last_active_at: last_active_at }.compact }
        @client.post("#{base}/boards/#{board_id}/cards", body: body)
      end

      def update(card_number, attrs)
        @client.put("#{base}/cards/#{card_number}", body: { card: attrs.compact })
      end

      def delete(card_number)
        @client.delete("#{base}/cards/#{card_number}")
      end

      def delete_image(card_number)
        @client.delete("#{base}/cards/#{card_number}/image")
      end

      def close(card_number)
        @client.post("#{base}/cards/#{card_number}/closure")
      end

      def reopen(card_number)
        @client.delete("#{base}/cards/#{card_number}/closure")
      end

      def not_now(card_number)
        @client.post("#{base}/cards/#{card_number}/not_now")
      end

      def triage(card_number, column_id)
        @client.post("#{base}/cards/#{card_number}/triage", body: { column_id: column_id })
      end

      def untriage(card_number)
        @client.delete("#{base}/cards/#{card_number}/triage")
      end

      def toggle_tag(card_number, tag_title)
        @client.post("#{base}/cards/#{card_number}/taggings", body: { tag_title: tag_title })
      end

      def toggle_assignment(card_number, assignee_id)
        @client.post("#{base}/cards/#{card_number}/assignments", body: { assignee_id: assignee_id })
      end

      def watch(card_number)
        @client.post("#{base}/cards/#{card_number}/watch")
      end

      def unwatch(card_number)
        @client.delete("#{base}/cards/#{card_number}/watch")
      end

      def gold(card_number)
        @client.post("#{base}/cards/#{card_number}/goldness")
      end

      def ungold(card_number)
        @client.delete("#{base}/cards/#{card_number}/goldness")
      end

      private

      def base
        "/#{@account_slug}"
      end

      def filter_params(filters)
        params = {}
        filters.each do |key, value|
          next if value.nil?

          # Faraday's NestedParamsEncoder turns array values into
          # `key[]=a&key[]=b` automatically. Don't pre-suffix the key.
          params[key.to_s] = value
        end
        params
      end
    end
  end
end
