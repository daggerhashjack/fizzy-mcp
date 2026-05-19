# frozen_string_literal: true

require "spec_helper"

RSpec.describe Fizzy::Api::Columns do
  let(:client) { Fizzy::Client.new(token: "t", base_url: "https://app.fizzy.do") }
  let(:columns) { described_class.new(client, "6206647") }

  it "lists columns on a board" do
    stub_request(:get, "https://app.fizzy.do/6206647/boards/B/columns")
      .to_return(status: 200, body: "[]", headers: { "Content-Type" => "application/json" })

    expect(columns.list("B")).to eq([])
  end

  it "gets a single column" do
    stub_request(:get, "https://app.fizzy.do/6206647/boards/B/columns/C")
      .to_return(status: 200, body: '{"id":"C","name":"Doing"}',
                 headers: { "Content-Type" => "application/json" })

    expect(columns.get("B", "C")).to eq({ "id" => "C", "name" => "Doing" })
  end

  it "lists cards in a column" do
    stub_request(:get, "https://app.fizzy.do/6206647/boards/B/columns/C/cards")
      .to_return(status: 200, body: "[]", headers: { "Content-Type" => "application/json" })

    columns.cards("B", "C")
  end

  it "creates a column with name only" do
    stub_request(:post, "https://app.fizzy.do/6206647/boards/B/columns")
      .with(body: { column: { name: "Doing" } }.to_json)
      .to_return(status: 201, body: "")

    columns.create("B", name: "Doing")
  end

  it "creates a column with color" do
    stub_request(:post, "https://app.fizzy.do/6206647/boards/B/columns")
      .with(body: { column: { name: "Doing", color: "var(--color-card-4)" } }.to_json)
      .to_return(status: 201, body: "")

    columns.create("B", name: "Doing", color: "var(--color-card-4)")
  end

  it "updates a column" do
    stub_request(:put, "https://app.fizzy.do/6206647/boards/B/columns/C")
      .with(body: { column: { name: "Done" } }.to_json)
      .to_return(status: 204, body: "")

    columns.update("B", "C", name: "Done")
  end

  it "deletes a column" do
    stub_request(:delete, "https://app.fizzy.do/6206647/boards/B/columns/C")
      .to_return(status: 204, body: "")

    columns.delete("B", "C")
  end
end
