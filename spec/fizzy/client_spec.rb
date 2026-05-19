# frozen_string_literal: true

require "spec_helper"

RSpec.describe Fizzy::Client do
  let(:token) { "test_token" }
  let(:client) { described_class.new(token: token, base_url: "https://app.fizzy.do") }

  describe "#initialize" do
    it "requires a token" do
      expect { described_class.new(token: nil) }.to raise_error(ArgumentError, /FIZZY_ACCESS_TOKEN/)
      expect { described_class.new(token: "") }.to raise_error(ArgumentError, /FIZZY_ACCESS_TOKEN/)
    end

    it "reads the token from ENV when not given" do
      ENV["FIZZY_ACCESS_TOKEN"] = "env_token"
      c = described_class.new
      expect(c.token).to eq("env_token")
    ensure
      ENV.delete("FIZZY_ACCESS_TOKEN")
    end
  end

  describe "#get" do
    it "sends a Bearer token and parses JSON" do
      stub_request(:get, "https://app.fizzy.do/path")
        .with(headers: { "Authorization" => "Bearer test_token", "Accept" => "application/json" })
        .to_return(status: 200, body: '{"foo":"bar"}', headers: { "Content-Type" => "application/json" })

      expect(client.get("/path")).to eq({ "foo" => "bar" })
    end

    it "raises NotFound on 404" do
      stub_request(:get, "https://app.fizzy.do/missing").to_return(status: 404, body: "")
      expect { client.get("/missing") }.to raise_error(Fizzy::Client::NotFound)
    end

    it "raises Unauthorized on 401" do
      stub_request(:get, "https://app.fizzy.do/x").to_return(status: 401, body: "")
      expect { client.get("/x") }.to raise_error(Fizzy::Client::Unauthorized)
    end

    it "raises UnprocessableEntity with formatted message on 422" do
      stub_request(:get, "https://app.fizzy.do/x")
        .to_return(status: 422, body: '{"name":["is required"]}',
                   headers: { "Content-Type" => "application/json" })

      expect { client.get("/x") }.to raise_error(Fizzy::Client::UnprocessableEntity, /name: is required/)
    end
  end

  describe "#post" do
    it "encodes the body as JSON" do
      stub_request(:post, "https://app.fizzy.do/things")
        .with(body: { board: { name: "X" } }.to_json,
              headers: { "Content-Type" => "application/json" })
        .to_return(status: 201, body: "")

      client.post("/things", body: { board: { name: "X" } })
    end
  end
end
