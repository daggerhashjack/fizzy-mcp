# frozen_string_literal: true

require "spec_helper"
require "json"

RSpec.describe FizzyMcp::Server do
  let(:server) { described_class.build(token: "t", slug: "6206647") }

  describe ".all_tools" do
    it "registers every resource group" do
      names = described_class.all_tools.map(&:name_value)
      expect(names).to include(
        "fizzy_identity_get",
        "fizzy_boards_list",
        "fizzy_boards_create",
        "fizzy_columns_list",
        "fizzy_cards_list",
        "fizzy_cards_triage",
        "fizzy_comments_create",
        "fizzy_tags_list",
        "fizzy_users_list",
        "fizzy_webhooks_create"
      )
      expect(names.size).to be > 80
    end

    it "every tool name is snake_case starting with 'fizzy_'" do
      described_class.all_tools.map(&:name_value).each do |name|
        expect(name).to match(/\Afizzy_[a-z0-9_]+\z/), "bad tool name: #{name}"
      end
    end

    it "every tool has a description" do
      described_class.all_tools.each do |t|
        expect(t.description_value).to be_a(String).and(satisfy { |d| d.length > 5 })
      end
    end
  end

  describe "tools/list" do
    it "returns the registered tool set over JSON-RPC" do
      req = { jsonrpc: "2.0", id: 1, method: "tools/list" }
      resp = JSON.parse(server.handle_json(JSON.generate(req)))
      tools = resp.dig("result", "tools")
      expect(tools).to be_an(Array)
      expect(tools.size).to be > 80
    end
  end

  describe "tools/call" do
    it "wraps Fizzy API errors as isError responses" do
      stub_request(:get, "https://app.fizzy.do/my/identity")
        .to_return(status: 401, body: "")

      req = { jsonrpc: "2.0", id: 2, method: "tools/call",
              params: { name: "fizzy_identity_get", arguments: {} } }
      resp = JSON.parse(server.handle_json(JSON.generate(req)))
      expect(resp.dig("result", "isError")).to be(true)
      expect(resp.dig("result", "content", 0, "text")).to match(/auth failed/)
    end

    it "passes successful payloads through as text JSON" do
      stub_request(:get, "https://app.fizzy.do/6206647/boards")
        .to_return(status: 200, body: '[{"id":"a","name":"Demo"}]',
                   headers: { "Content-Type" => "application/json" })

      req = { jsonrpc: "2.0", id: 3, method: "tools/call",
              params: { name: "fizzy_boards_list", arguments: {} } }
      resp = JSON.parse(server.handle_json(JSON.generate(req)))
      expect(resp.dig("result", "isError")).to be_falsey
      expect(resp.dig("result", "content", 0, "text")).to include("Demo")
    end

    it "creates a card via the cards_create tool" do
      stub_request(:post, "https://app.fizzy.do/6206647/boards/B1/cards")
        .with(body: { card: { title: "Hi" } }.to_json)
        .to_return(status: 201, body: "")

      req = { jsonrpc: "2.0", id: 4, method: "tools/call",
              params: { name: "fizzy_cards_create",
                        arguments: { board_id: "B1", title: "Hi" } } }
      resp = JSON.parse(server.handle_json(JSON.generate(req)))
      expect(resp.dig("result", "isError")).to be_falsey
    end
  end
end
