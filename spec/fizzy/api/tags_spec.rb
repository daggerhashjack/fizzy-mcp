# frozen_string_literal: true

require "spec_helper"

RSpec.describe Fizzy::Api::Tags do
  let(:client) { Fizzy::Client.new(token: "t", base_url: "https://app.fizzy.do") }
  let(:tags) { described_class.new(client, "6206647") }

  it "lists tags" do
    stub_request(:get, "https://app.fizzy.do/6206647/tags")
      .to_return(status: 200, body: '[{"id":"t1","title":"design"}]',
                 headers: { "Content-Type" => "application/json" })

    expect(tags.list).to eq([{ "id" => "t1", "title" => "design" }])
  end
end
