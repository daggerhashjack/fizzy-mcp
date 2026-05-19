# frozen_string_literal: true

require "spec_helper"

RSpec.describe Fizzy::Api::Cards do
  let(:client) { Fizzy::Client.new(token: "t", base_url: "https://app.fizzy.do") }
  let(:cards) { described_class.new(client, "6206647") }

  it "lists cards without filters" do
    stub_request(:get, "https://app.fizzy.do/6206647/cards")
      .to_return(status: 200, body: "[]", headers: { "Content-Type" => "application/json" })

    expect(cards.list).to eq([])
  end

  it "expands array filters as repeated [] params" do
    stub_request(:get, "https://app.fizzy.do/6206647/cards")
      .with(query: { "board_ids" => %w[a b], "indexed_by" => "all" })
      .to_return(status: 200, body: "[]", headers: { "Content-Type" => "application/json" })

    cards.list(board_ids: %w[a b], indexed_by: "all")
  end

  it "creates a card with title and description" do
    stub_request(:post, "https://app.fizzy.do/6206647/boards/B1/cards")
      .with(body: { card: { title: "T", description: "D" } }.to_json)
      .to_return(status: 201, body: "")

    cards.create("B1", title: "T", description: "D")
  end

  it "triages a card into a column" do
    stub_request(:post, "https://app.fizzy.do/6206647/cards/42/triage")
      .with(body: { column_id: "col-1" }.to_json)
      .to_return(status: 204, body: "")

    cards.triage(42, "col-1")
  end

  it "toggles a tag" do
    stub_request(:post, "https://app.fizzy.do/6206647/cards/42/taggings")
      .with(body: { tag_title: "design" }.to_json)
      .to_return(status: 204, body: "")

    cards.toggle_tag(42, "design")
  end

  it "closes a card" do
    stub_request(:post, "https://app.fizzy.do/6206647/cards/42/closure").to_return(status: 204, body: "")
    cards.close(42)
  end

  it "reopens a card" do
    stub_request(:delete, "https://app.fizzy.do/6206647/cards/42/closure").to_return(status: 204, body: "")
    cards.reopen(42)
  end
end
