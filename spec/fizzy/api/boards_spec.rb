# frozen_string_literal: true

require "spec_helper"

RSpec.describe Fizzy::Api::Boards do
  let(:client) { Fizzy::Client.new(token: "t", base_url: "https://app.fizzy.do") }
  let(:boards) { described_class.new(client, "6206647") }

  it "lists boards" do
    stub_request(:get, "https://app.fizzy.do/6206647/boards")
      .to_return(status: 200, body: '[{"id":"abc","name":"NotAutopilot"}]',
                 headers: { "Content-Type" => "application/json" })

    expect(boards.list).to eq([{ "id" => "abc", "name" => "NotAutopilot" }])
  end

  it "gets a board" do
    stub_request(:get, "https://app.fizzy.do/6206647/boards/abc")
      .to_return(status: 200, body: '{"id":"abc"}',
                 headers: { "Content-Type" => "application/json" })

    expect(boards.get("abc")).to eq({ "id" => "abc" })
  end

  it "creates a board with only the required name" do
    stub_request(:post, "https://app.fizzy.do/6206647/boards")
      .with(body: { board: { name: "New" } }.to_json)
      .to_return(status: 201, body: "")

    boards.create(name: "New")
  end

  it "omits nil fields when creating" do
    stub_request(:post, "https://app.fizzy.do/6206647/boards")
      .with(body: { board: { name: "N", all_access: false } }.to_json)
      .to_return(status: 201, body: "")

    boards.create(name: "N", all_access: false, auto_postpone_period_in_days: nil)
  end

  it "updates a board" do
    stub_request(:put, "https://app.fizzy.do/6206647/boards/abc")
      .with(body: { board: { name: "Renamed" } }.to_json)
      .to_return(status: 204, body: "")

    boards.update("abc", name: "Renamed")
  end

  it "deletes a board" do
    stub_request(:delete, "https://app.fizzy.do/6206647/boards/abc").to_return(status: 204, body: "")
    boards.delete("abc")
  end
end
