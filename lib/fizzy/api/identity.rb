# frozen_string_literal: true

module Fizzy
  module Api
    class Identity
      def initialize(client)
        @client = client
      end

      def get
        @client.get("/my/identity")
      end

      def update_timezone(timezone_name)
        @client.patch("/my/timezone", body: { timezone_name: timezone_name })
      end
    end
  end
end
