# frozen_string_literal: true

require "spec_helper"

RSpec.describe Fizzy::Api::Identity do
  let(:client) { Fizzy::Client.new(token: "t", base_url: "https://app.fizzy.do") }
  let(:identity) { described_class.new(client) }

  it "fetches /my/identity" do
    stub_request(:get, "https://app.fizzy.do/my/identity")
      .to_return(status: 200, body: '{"accounts":[]}',
                 headers: { "Content-Type" => "application/json" })

    expect(identity.get).to eq({ "accounts" => [] })
  end

  it "patches the user's timezone" do
    stub_request(:patch, "https://app.fizzy.do/my/timezone")
      .with(body: { timezone_name: "America/New_York" }.to_json)
      .to_return(status: 204, body: "")

    identity.update_timezone("America/New_York")
  end
end
