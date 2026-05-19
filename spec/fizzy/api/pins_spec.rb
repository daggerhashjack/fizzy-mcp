# frozen_string_literal: true

require "spec_helper"

RSpec.describe Fizzy::Api::Pins do
  let(:client) { Fizzy::Client.new(token: "t", base_url: "https://app.fizzy.do") }
  let(:pins) { described_class.new(client, "6206647") }

  it "pins a card" do
    stub_request(:post, "https://app.fizzy.do/6206647/cards/42/pin").to_return(status: 204, body: "")
    pins.pin(42)
  end

  it "unpins a card" do
    stub_request(:delete, "https://app.fizzy.do/6206647/cards/42/pin").to_return(status: 204, body: "")
    pins.unpin(42)
  end

  it "lists pinned cards (account-scoped — bearer auth quirk)" do
    stub_request(:get, "https://app.fizzy.do/6206647/my/pins")
      .to_return(status: 200, body: "[]", headers: { "Content-Type" => "application/json" })

    expect(pins.list).to eq([])
  end
end
