# frozen_string_literal: true

require "spec_helper"

RSpec.describe Fizzy::Api::Account do
  let(:client) { Fizzy::Client.new(token: "t", base_url: "https://app.fizzy.do") }
  let(:account) { described_class.new(client, "6206647") }

  it "fetches account settings" do
    stub_request(:get, "https://app.fizzy.do/6206647/account/settings")
      .to_return(status: 200, body: "{}", headers: { "Content-Type" => "application/json" })

    account.settings
  end

  it "fetches join code" do
    stub_request(:get, "https://app.fizzy.do/6206647/account/join_code")
      .to_return(status: 200, body: "{}", headers: { "Content-Type" => "application/json" })

    account.join_code
  end

  it "regenerates the join code" do
    stub_request(:put, "https://app.fizzy.do/6206647/account/join_code").to_return(status: 200, body: "")
    account.regenerate_join_code
  end

  it "disables the join code" do
    stub_request(:delete, "https://app.fizzy.do/6206647/account/join_code").to_return(status: 204, body: "")
    account.disable_join_code
  end

  it "resets account entropy" do
    stub_request(:put, "https://app.fizzy.do/6206647/account/entropy").to_return(status: 204, body: "")
    account.reset_account_entropy
  end

  it "resets board entropy" do
    stub_request(:put, "https://app.fizzy.do/6206647/boards/B1/entropy").to_return(status: 204, body: "")
    account.reset_board_entropy("B1")
  end
end
