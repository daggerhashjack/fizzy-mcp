# frozen_string_literal: true

require "spec_helper"

RSpec.describe Fizzy::Api::Reactions do
  let(:client) { Fizzy::Client.new(token: "t", base_url: "https://app.fizzy.do") }
  let(:reactions) { described_class.new(client, "6206647") }

  describe "card reactions" do
    it "lists" do
      stub_request(:get, "https://app.fizzy.do/6206647/cards/42/reactions")
        .to_return(status: 200, body: "[]", headers: { "Content-Type" => "application/json" })

      reactions.list_card_reactions(42)
    end

    it "creates" do
      stub_request(:post, "https://app.fizzy.do/6206647/cards/42/reactions")
        .with(body: { reaction: { content: ":+1:" } }.to_json)
        .to_return(status: 201, body: "")

      reactions.create_card_reaction(42, content: ":+1:")
    end

    it "deletes" do
      stub_request(:delete, "https://app.fizzy.do/6206647/cards/42/reactions/r1")
        .to_return(status: 204, body: "")

      reactions.delete_card_reaction(42, "r1")
    end
  end

  describe "comment reactions" do
    it "lists" do
      stub_request(:get, "https://app.fizzy.do/6206647/cards/42/comments/c1/reactions")
        .to_return(status: 200, body: "[]", headers: { "Content-Type" => "application/json" })

      reactions.list_comment_reactions(42, "c1")
    end

    it "creates" do
      stub_request(:post, "https://app.fizzy.do/6206647/cards/42/comments/c1/reactions")
        .with(body: { reaction: { content: ":sparkles:" } }.to_json)
        .to_return(status: 201, body: "")

      reactions.create_comment_reaction(42, "c1", content: ":sparkles:")
    end

    it "deletes" do
      stub_request(:delete, "https://app.fizzy.do/6206647/cards/42/comments/c1/reactions/r1")
        .to_return(status: 204, body: "")

      reactions.delete_comment_reaction(42, "c1", "r1")
    end
  end
end
