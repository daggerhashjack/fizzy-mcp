# frozen_string_literal: true

require "json"
require "mcp"

module FizzyMcp
  # Shared helpers for defining MCP tools that call the Fizzy API.
  #
  # All tool blocks receive the server_context hash and a single `args`
  # hash. By convention server_context[:account] is the Fizzy::Account
  # facade (set in FizzyMcp::Server.build), so tools dispatch like
  # `account.boards.list`.
  module ToolHelpers
    module_function

    # Render any Ruby value as a single MCP text response.
    # Hashes and arrays are pretty-printed JSON; other values are
    # to_s. Returning nil from the API maps to the literal "ok".
    def ok(value)
      text = if value.nil?
               "ok"
             elsif value.is_a?(Hash) || value.is_a?(Array)
               JSON.pretty_generate(value)
             else
               value.to_s
             end
      MCP::Tool::Response.new([{ type: "text", text: text }])
    end

    # Translate Fizzy::Client errors into a structured isError response.
    # Tools wrap their body in `with_errors` to avoid duplicating this.
    def with_errors
      yield
    rescue Fizzy::Client::Unauthorized => e
      error("Fizzy auth failed (#{e.status}). Check FIZZY_ACCESS_TOKEN.", e)
    rescue Fizzy::Client::Forbidden => e
      error("Forbidden by Fizzy (#{e.status}). Token may lack write permission.", e)
    rescue Fizzy::Client::NotFound => e
      error("Not found (#{e.status}).", e)
    rescue Fizzy::Client::UnprocessableEntity => e
      error("Validation failed: #{e.message}", e)
    rescue Fizzy::Client::Error => e
      error("Fizzy API error: #{e.message}", e)
    end

    def error(message, exception = nil)
      detail = exception&.body
      text = detail ? "#{message}\n\n#{JSON.pretty_generate(detail)}" : message
      MCP::Tool::Response.new([{ type: "text", text: text }], error: true)
    end
  end
end
