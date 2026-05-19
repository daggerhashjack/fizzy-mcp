# frozen_string_literal: true

require "spec_helper"

RSpec.describe Fizzy::Api::Exports do
  let(:client) { Fizzy::Client.new(token: "t", base_url: "https://app.fizzy.do") }
  let(:exports) { described_class.new(client, "6206647") }

  it "creates an account export" do
    stub_request(:post, "https://app.fizzy.do/6206647/account/exports")
      .to_return(status: 201, body: '{"id":"e1"}',
                 headers: { "Content-Type" => "application/json" })

    expect(exports.create_account_export).to eq({ "id" => "e1" })
  end

  it "gets an account export" do
    stub_request(:get, "https://app.fizzy.do/6206647/account/exports/e1")
      .to_return(status: 200, body: '{"id":"e1","status":"ready"}',
                 headers: { "Content-Type" => "application/json" })

    exports.get_account_export("e1")
  end

  it "creates a user export" do
    stub_request(:post, "https://app.fizzy.do/6206647/users/u1/data_exports")
      .to_return(status: 201, body: "")

    exports.create_user_export("u1")
  end

  it "gets a user export" do
    stub_request(:get, "https://app.fizzy.do/6206647/users/u1/data_exports/e1")
      .to_return(status: 200, body: "{}", headers: { "Content-Type" => "application/json" })

    exports.get_user_export("u1", "e1")
  end
end
