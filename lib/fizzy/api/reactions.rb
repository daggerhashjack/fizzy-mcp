# frozen_string_literal: true

module Fizzy
  module Api
    class Reactions
      def initialize(client, account_slug)
        @client = client
        @account_slug = account_slug
      end

      def list_card_reactions(card_number)
        @client.get("#{base}/cards/#{card_number}/reactions")
      end

      def create_card_reaction(card_number, content:)
        @client.post("#{base}/cards/#{card_number}/reactions",
                     body: { reaction: { content: content } })
      end

      def delete_card_reaction(card_number, reaction_id)
        @client.delete("#{base}/cards/#{card_number}/reactions/#{reaction_id}")
      end

      def list_comment_reactions(card_number, comment_id)
        @client.get("#{base}/cards/#{card_number}/comments/#{comment_id}/reactions")
      end

      def create_comment_reaction(card_number, comment_id, content:)
        @client.post("#{base}/cards/#{card_number}/comments/#{comment_id}/reactions",
                     body: { reaction: { content: content } })
      end

      def delete_comment_reaction(card_number, comment_id, reaction_id)
        @client.delete("#{base}/cards/#{card_number}/comments/#{comment_id}/reactions/#{reaction_id}")
      end

      private

      def base
        "/#{@account_slug}"
      end
    end
  end
end
