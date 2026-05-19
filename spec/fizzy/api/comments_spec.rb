# frozen_string_literal: true

require "spec_helper"

RSpec.describe Fizzy::Api::Comments do
  let(:client) { Fizzy::Client.new(token: "t", base_url: "https://app.fizzy.do") }
  let(:comments) { described_class.new(client, "6206647") }

  it "lists comments on a card" do
    stub_request(:get, "https://app.fizzy.do/6206647/cards/42/comments")
      .to_return(status: 200, body: "[]", headers: { "Content-Type" => "application/json" })

    expect(comments.list(42)).to eq([])
  end

  it "gets a single comment" do
    stub_request(:get, "https://app.fizzy.do/6206647/cards/42/comments/c1")
      .to_return(status: 200, body: '{"id":"c1"}', headers: { "Content-Type" => "application/json" })

    expect(comments.get(42, "c1")).to eq({ "id" => "c1" })
  end

  it "creates a comment" do
    stub_request(:post, "https://app.fizzy.do/6206647/cards/42/comments")
      .with(body: { comment: { content: "lgtm" } }.to_json)
      .to_return(status: 201, body: "")

    comments.create(42, content: "lgtm")
  end

  it "updates a comment" do
    stub_request(:put, "https://app.fizzy.do/6206647/cards/42/comments/c1")
      .with(body: { comment: { content: "actually nope" } }.to_json)
      .to_return(status: 204, body: "")

    comments.update(42, "c1", content: "actually nope")
  end

  it "deletes a comment" do
    stub_request(:delete, "https://app.fizzy.do/6206647/cards/42/comments/c1")
      .to_return(status: 204, body: "")

    comments.delete(42, "c1")
  end
end
