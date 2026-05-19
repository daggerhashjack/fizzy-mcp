# frozen_string_literal: true

require "spec_helper"

RSpec.describe Fizzy::Api::Notifications do
  let(:client) { Fizzy::Client.new(token: "t", base_url: "https://app.fizzy.do") }
  let(:notifications) { described_class.new(client, "6206647") }

  it "lists" do
    stub_request(:get, "https://app.fizzy.do/6206647/notifications")
      .to_return(status: 200, body: "[]", headers: { "Content-Type" => "application/json" })

    notifications.list
  end

  it "marks one read" do
    stub_request(:post, "https://app.fizzy.do/6206647/notifications/n1/reading")
      .to_return(status: 204, body: "")

    notifications.mark_read("n1")
  end

  it "marks one unread" do
    stub_request(:delete, "https://app.fizzy.do/6206647/notifications/n1/reading")
      .to_return(status: 204, body: "")

    notifications.mark_unread("n1")
  end

  it "marks all read" do
    stub_request(:post, "https://app.fizzy.do/6206647/notifications/bulk_reading")
      .to_return(status: 204, body: "")

    notifications.mark_all_read
  end

  it "gets settings" do
    stub_request(:get, "https://app.fizzy.do/6206647/notifications/settings")
      .to_return(status: 200, body: "{}", headers: { "Content-Type" => "application/json" })

    notifications.settings
  end

  it "updates settings" do
    stub_request(:put, "https://app.fizzy.do/6206647/notifications/settings")
      .with(body: { settings: { email_enabled: false } }.to_json)
      .to_return(status: 204, body: "")

    notifications.update_settings(email_enabled: false)
  end
end
