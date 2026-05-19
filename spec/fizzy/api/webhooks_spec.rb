# frozen_string_literal: true

require "spec_helper"

RSpec.describe Fizzy::Api::Webhooks do
  let(:client) { Fizzy::Client.new(token: "t", base_url: "https://app.fizzy.do") }
  let(:webhooks) { described_class.new(client, "6206647") }

  it "lists webhooks" do
    stub_request(:get, "https://app.fizzy.do/6206647/boards/B/webhooks")
      .to_return(status: 200, body: "[]", headers: { "Content-Type" => "application/json" })

    webhooks.list("B")
  end

  it "gets one" do
    stub_request(:get, "https://app.fizzy.do/6206647/boards/B/webhooks/w1")
      .to_return(status: 200, body: '{"id":"w1"}', headers: { "Content-Type" => "application/json" })

    expect(webhooks.get("B", "w1")).to eq({ "id" => "w1" })
  end

  it "creates" do
    stub_request(:post, "https://app.fizzy.do/6206647/boards/B/webhooks")
      .with(body: { webhook: { name: "Hook", url: "https://example.com/hook" } }.to_json)
      .to_return(status: 201, body: "")

    webhooks.create("B", name: "Hook", url: "https://example.com/hook")
  end

  it "creates with subscribed_actions" do
    stub_request(:post, "https://app.fizzy.do/6206647/boards/B/webhooks")
      .with(body: { webhook: { name: "Prod", url: "https://x.test", subscribed_actions: %w[card_published] } }.to_json)
      .to_return(status: 201, body: "")

    webhooks.create("B", name: "Prod", url: "https://x.test", subscribed_actions: %w[card_published])
  end

  it "patches" do
    stub_request(:patch, "https://app.fizzy.do/6206647/boards/B/webhooks/w1")
      .with(body: { webhook: { url: "https://new.test" } }.to_json)
      .to_return(status: 204, body: "")

    webhooks.update("B", "w1", url: "https://new.test")
  end

  it "deletes" do
    stub_request(:delete, "https://app.fizzy.do/6206647/boards/B/webhooks/w1")
      .to_return(status: 204, body: "")

    webhooks.delete("B", "w1")
  end

  it "activates" do
    stub_request(:post, "https://app.fizzy.do/6206647/boards/B/webhooks/w1/activation")
      .to_return(status: 204, body: "")

    webhooks.activate("B", "w1")
  end

  it "lists deliveries" do
    stub_request(:get, "https://app.fizzy.do/6206647/boards/B/webhooks/w1/deliveries")
      .to_return(status: 200, body: "[]", headers: { "Content-Type" => "application/json" })

    webhooks.deliveries("B", "w1")
  end
end
