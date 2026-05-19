# frozen_string_literal: true

require_relative "fizzy/client"
require_relative "fizzy/api/identity"
require_relative "fizzy/api/account"
require_relative "fizzy/api/boards"
require_relative "fizzy/api/columns"
require_relative "fizzy/api/cards"
require_relative "fizzy/api/comments"
require_relative "fizzy/api/reactions"
require_relative "fizzy/api/steps"
require_relative "fizzy/api/tags"
require_relative "fizzy/api/users"
require_relative "fizzy/api/pins"
require_relative "fizzy/api/activities"
require_relative "fizzy/api/notifications"
require_relative "fizzy/api/webhooks"
require_relative "fizzy/api/exports"

module Fizzy
  # Convenience facade that bundles a Client with every resource module
  # for a specific account slug. Most callers want this.
  class Account
    attr_reader :client, :slug

    def initialize(slug:, client: Client.new)
      @client = client
      @slug = slug
    end

    def identity = @identity ||= Api::Identity.new(client)
    def account = @account ||= Api::Account.new(client, slug)
    def boards = @boards ||= Api::Boards.new(client, slug)
    def columns = @columns ||= Api::Columns.new(client, slug)
    def cards = @cards ||= Api::Cards.new(client, slug)
    def comments = @comments ||= Api::Comments.new(client, slug)
    def reactions = @reactions ||= Api::Reactions.new(client, slug)
    def steps = @steps ||= Api::Steps.new(client, slug)
    def tags = @tags ||= Api::Tags.new(client, slug)
    def users = @users ||= Api::Users.new(client, slug)
    def pins = @pins ||= Api::Pins.new(client, slug)
    def activities = @activities ||= Api::Activities.new(client, slug)
    def notifications = @notifications ||= Api::Notifications.new(client, slug)
    def webhooks = @webhooks ||= Api::Webhooks.new(client, slug)
    def exports = @exports ||= Api::Exports.new(client, slug)
  end
end
