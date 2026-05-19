# frozen_string_literal: true

require "spec_helper"
require "json"

# End-to-end round trips: feed a JSON-RPC tools/call message in,
# observe that the right HTTP request goes out, and that the response
# comes back shaped as a Tool::Response.
RSpec.describe "fizzy-mcp tool round trips" do
  let(:server) { FizzyMcp::Server.build(token: "t", slug: "6206647") }

  def call_tool(name, args = {})
    req = { jsonrpc: "2.0", id: rand(1000), method: "tools/call",
            params: { name: name, arguments: args } }
    JSON.parse(server.handle_json(JSON.generate(req)))
  end

  def text_of(response)
    response.dig("result", "content", 0, "text")
  end

  describe "identity" do
    it "fizzy_identity_get returns identity payload" do
      stub_request(:get, "https://app.fizzy.do/my/identity")
        .to_return(status: 200, body: '{"accounts":[{"id":"a"}]}',
                   headers: { "Content-Type" => "application/json" })

      resp = call_tool("fizzy_identity_get")
      expect(resp.dig("result", "isError")).to be_falsey
      expect(text_of(resp)).to include('"id":')
    end
  end

  describe "boards" do
    it "fizzy_boards_create posts to the boards endpoint" do
      stub = stub_request(:post, "https://app.fizzy.do/6206647/boards")
             .with(body: { board: { name: "X" } }.to_json)
             .to_return(status: 201, body: "")

      call_tool("fizzy_boards_create", { name: "X" })
      expect(stub).to have_been_requested
    end

    it "fizzy_boards_update strips board_id from body" do
      stub = stub_request(:put, "https://app.fizzy.do/6206647/boards/B1")
             .with(body: { board: { name: "Renamed" } }.to_json)
             .to_return(status: 204, body: "")

      call_tool("fizzy_boards_update", { board_id: "B1", name: "Renamed" })
      expect(stub).to have_been_requested
    end
  end

  describe "cards" do
    it "fizzy_cards_triage posts to the right path" do
      stub = stub_request(:post, "https://app.fizzy.do/6206647/cards/42/triage")
             .with(body: { column_id: "col-1" }.to_json)
             .to_return(status: 204, body: "")

      call_tool("fizzy_cards_triage", { card_number: 42, column_id: "col-1" })
      expect(stub).to have_been_requested
    end

    it "fizzy_cards_close hits the closure endpoint" do
      stub = stub_request(:post, "https://app.fizzy.do/6206647/cards/42/closure")
             .to_return(status: 204, body: "")

      call_tool("fizzy_cards_close", { card_number: 42 })
      expect(stub).to have_been_requested
    end

    it "fizzy_cards_toggle_tag passes through" do
      stub = stub_request(:post, "https://app.fizzy.do/6206647/cards/42/taggings")
             .with(body: { tag_title: "design" }.to_json)
             .to_return(status: 204, body: "")

      call_tool("fizzy_cards_toggle_tag", { card_number: 42, tag_title: "design" })
      expect(stub).to have_been_requested
    end
  end

  describe "comments" do
    it "fizzy_comments_create posts body" do
      stub = stub_request(:post, "https://app.fizzy.do/6206647/cards/42/comments")
             .with(body: { comment: { body: "lgtm" } }.to_json)
             .to_return(status: 201, body: "")

      call_tool("fizzy_comments_create", { card_number: 42, body: "lgtm" })
      expect(stub).to have_been_requested
    end
  end

  describe "columns" do
    it "fizzy_columns_create posts" do
      stub = stub_request(:post, "https://app.fizzy.do/6206647/boards/B1/columns")
             .with(body: { column: { name: "Doing" } }.to_json)
             .to_return(status: 201, body: "")

      call_tool("fizzy_columns_create", { board_id: "B1", name: "Doing" })
      expect(stub).to have_been_requested
    end
  end

  describe "error handling" do
    it "surfaces 401 as isError true with a useful message" do
      stub_request(:get, "https://app.fizzy.do/6206647/boards")
        .to_return(status: 401, body: "")

      resp = call_tool("fizzy_boards_list")
      expect(resp.dig("result", "isError")).to be(true)
      expect(text_of(resp)).to match(/auth failed/i)
    end

    it "surfaces 404 as isError true" do
      stub_request(:get, "https://app.fizzy.do/6206647/boards/missing")
        .to_return(status: 404, body: "")

      resp = call_tool("fizzy_boards_get", { board_id: "missing" })
      expect(resp.dig("result", "isError")).to be(true)
      expect(text_of(resp)).to match(/not found/i)
    end

    it "surfaces 422 with validation detail" do
      stub_request(:post, "https://app.fizzy.do/6206647/boards")
        .to_return(status: 422, body: '{"name":["is required"]}',
                   headers: { "Content-Type" => "application/json" })

      resp = call_tool("fizzy_boards_create", { name: "" })
      expect(resp.dig("result", "isError")).to be(true)
      expect(text_of(resp)).to match(/name.*is required/i)
    end
  end

  describe "tool surface contracts" do
    it "every tool's input schema fields use snake_case" do
      FizzyMcp::Server.all_tools.each do |t|
        schema = t.input_schema_value
        next unless schema

        schema_hash = schema.respond_to?(:to_h) ? schema.to_h : schema
        props = schema_hash[:properties] || schema_hash["properties"] || {}
        props.each_key do |key|
          str = key.to_s
          expect(str).to match(/\A[a-z][a-z0-9_]*\z/),
                         "tool #{t.name_value} has non-snake_case property: #{str}"
        end
      end
    end

    it "every tool with destructive_hint or normal annotation has read_only_hint set consistently" do
      FizzyMcp::Server.all_tools.each do |t|
        annotations = t.annotations_value
        next unless annotations

        # If a tool is marked read_only it should not also be destructive.
        read_only = annotations.respond_to?(:read_only_hint) ? annotations.read_only_hint : annotations[:read_only_hint]
        destructive = annotations.respond_to?(:destructive_hint) ? annotations.destructive_hint : annotations[:destructive_hint]
        raise "tool #{t.name_value} is both read_only and destructive" if read_only && destructive
      end
    end
  end
end
