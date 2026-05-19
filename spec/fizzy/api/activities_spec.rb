# frozen_string_literal: true

require "spec_helper"

RSpec.describe Fizzy::Api::Activities do
  let(:client) { Fizzy::Client.new(token: "t", base_url: "https://app.fizzy.do") }
  let(:activities) { described_class.new(client, "6206647") }

  it "lists activities with no filters" do
    stub_request(:get, "https://app.fizzy.do/6206647/activities")
      .to_return(status: 200, body: "[]", headers: { "Content-Type" => "application/json" })

    activities.list
  end

  it "passes filters through" do
    stub_request(:get, "https://app.fizzy.do/6206647/activities")
      .with(query: { "board_ids" => %w[a b] })
      .to_return(status: 200, body: "[]", headers: { "Content-Type" => "application/json" })

    activities.list(board_ids: %w[a b])
  end

  it "drops nil filters" do
    stub_request(:get, "https://app.fizzy.do/6206647/activities")
      .with(query: { "start_date" => "2026-01-01" })
      .to_return(status: 200, body: "[]", headers: { "Content-Type" => "application/json" })

    activities.list(start_date: "2026-01-01", end_date: nil)
  end
end
