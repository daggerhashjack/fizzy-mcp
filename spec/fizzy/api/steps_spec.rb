# frozen_string_literal: true

require "spec_helper"

RSpec.describe Fizzy::Api::Steps do
  let(:client) { Fizzy::Client.new(token: "t", base_url: "https://app.fizzy.do") }
  let(:steps) { described_class.new(client, "6206647") }

  it "gets a step" do
    stub_request(:get, "https://app.fizzy.do/6206647/cards/42/steps/s1")
      .to_return(status: 200, body: '{"id":"s1"}', headers: { "Content-Type" => "application/json" })

    expect(steps.get(42, "s1")).to eq({ "id" => "s1" })
  end

  it "creates a step" do
    stub_request(:post, "https://app.fizzy.do/6206647/cards/42/steps")
      .with(body: { step: { content: "do this" } }.to_json)
      .to_return(status: 201, body: "")

    steps.create(42, content: "do this")
  end

  it "creates a step with completed flag" do
    stub_request(:post, "https://app.fizzy.do/6206647/cards/42/steps")
      .with(body: { step: { content: "done already", completed: true } }.to_json)
      .to_return(status: 201, body: "")

    steps.create(42, content: "done already", completed: true)
  end

  it "updates a step" do
    stub_request(:put, "https://app.fizzy.do/6206647/cards/42/steps/s1")
      .with(body: { step: { completed: true } }.to_json)
      .to_return(status: 204, body: "")

    steps.update(42, "s1", completed: true)
  end

  it "deletes a step" do
    stub_request(:delete, "https://app.fizzy.do/6206647/cards/42/steps/s1")
      .to_return(status: 204, body: "")

    steps.delete(42, "s1")
  end
end
