# frozen_string_literal: true

require "spec_helper"

RSpec.describe Fizzy::Api::Users do
  let(:client) { Fizzy::Client.new(token: "t", base_url: "https://app.fizzy.do") }
  let(:users) { described_class.new(client, "6206647") }

  it "lists users" do
    stub_request(:get, "https://app.fizzy.do/6206647/users")
      .to_return(status: 200, body: "[]", headers: { "Content-Type" => "application/json" })

    users.list
  end

  it "gets a user" do
    stub_request(:get, "https://app.fizzy.do/6206647/users/u1")
      .to_return(status: 200, body: '{"id":"u1"}', headers: { "Content-Type" => "application/json" })

    expect(users.get("u1")).to eq({ "id" => "u1" })
  end

  it "updates a user" do
    stub_request(:put, "https://app.fizzy.do/6206647/users/u1")
      .with(body: { user: { name: "Renamed" } }.to_json)
      .to_return(status: 204, body: "")

    users.update("u1", name: "Renamed")
  end

  it "deletes a user avatar" do
    stub_request(:delete, "https://app.fizzy.do/6206647/users/u1/avatar")
      .to_return(status: 204, body: "")

    users.delete_avatar("u1")
  end

  it "adds an email address" do
    stub_request(:post, "https://app.fizzy.do/6206647/users/u1/email_addresses")
      .with(body: { email_address: { address: "x@y.com" } }.to_json)
      .to_return(status: 201, body: "")

    users.add_email_address("u1", "x@y.com")
  end

  it "confirms an email address" do
    stub_request(:post, "https://app.fizzy.do/6206647/users/u1/email_addresses/TOK/confirmation")
      .to_return(status: 204, body: "")

    users.confirm_email_address("u1", "TOK")
  end

  it "deletes a user" do
    stub_request(:delete, "https://app.fizzy.do/6206647/users/u1").to_return(status: 204, body: "")
    users.delete("u1")
  end
end
