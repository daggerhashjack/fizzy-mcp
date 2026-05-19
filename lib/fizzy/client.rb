# frozen_string_literal: true

require "faraday"
require "faraday/retry"
require "json"

module Fizzy
  # HTTP client for the Fizzy API.
  #
  # Auth: Bearer token in the Authorization header. Token comes from
  # the FIZZY_ACCESS_TOKEN env var by default; pass `:token` to override.
  #
  # Base URL: https://app.fizzy.do by default; pass `:base_url` to point
  # at a self-hosted instance.
  #
  # The client is intentionally thin. Resource-specific helpers live in
  # Fizzy::Api::* and call back through #get/#post/#put/#patch/#delete.
  class Client
    DEFAULT_BASE_URL = "https://app.fizzy.do"
    USER_AGENT = "fizzy-mcp/#{begin
      require 'fizzy_mcp/version'
      FizzyMcp::VERSION
    rescue LoadError
      '0.0.0'
    end}".freeze

    class Error < StandardError
      attr_reader :status, :body

      def initialize(message, status: nil, body: nil)
        super(message)
        @status = status
        @body = body
      end
    end

    class Unauthorized < Error; end
    class Forbidden < Error; end
    class NotFound < Error; end
    class UnprocessableEntity < Error; end

    attr_reader :base_url, :token

    def initialize(token: ENV.fetch("FIZZY_ACCESS_TOKEN", nil),
                   base_url: ENV.fetch("FIZZY_BASE_URL", DEFAULT_BASE_URL))
      raise ArgumentError, "FIZZY_ACCESS_TOKEN is required" if token.nil? || token.empty?

      @token = token
      @base_url = base_url
    end

    def get(path, params: nil, headers: {})
      request(:get, path, params: params, headers: headers)
    end

    def post(path, body: nil, headers: {})
      request(:post, path, body: body, headers: headers)
    end

    def put(path, body: nil, headers: {})
      request(:put, path, body: body, headers: headers)
    end

    def patch(path, body: nil, headers: {})
      request(:patch, path, body: body, headers: headers)
    end

    def delete(path, headers: {})
      request(:delete, path, headers: headers)
    end

    private

    def request(method, path, params: nil, body: nil, headers: {})
      response = connection.public_send(method) do |req|
        req.url(path)
        req.params.update(params) if params
        if body
          req.headers["Content-Type"] = "application/json"
          req.body = body.is_a?(String) ? body : JSON.generate(body)
        end
        headers.each { |k, v| req.headers[k] = v }
      end
      handle_response(response)
    end

    def handle_response(response)
      status = response.status
      body = parse_body(response.body)

      case status
      when 200..299 then body
      when 304 then nil
      when 401 then raise Unauthorized.new("unauthorized", status: status, body: body)
      when 403 then raise Forbidden.new("forbidden", status: status, body: body)
      when 404 then raise NotFound.new("not found", status: status, body: body)
      when 422 then raise UnprocessableEntity.new(format_validation(body), status: status, body: body)
      else raise Error.new("fizzy api error: HTTP #{status}", status: status, body: body)
      end
    end

    def parse_body(raw)
      return nil if raw.nil? || raw.empty?

      JSON.parse(raw)
    rescue JSON::ParserError
      raw
    end

    def format_validation(body)
      return "validation failed" unless body.is_a?(Hash)

      body.map { |field, errors| "#{field}: #{Array(errors).join(', ')}" }.join("; ")
    end

    def connection
      @connection ||= Faraday.new(url: @base_url) do |f|
        f.headers["Authorization"] = "Bearer #{@token}"
        f.headers["Accept"] = "application/json"
        f.headers["User-Agent"] = USER_AGENT
        f.request :retry, max: 3, interval: 0.5, backoff_factor: 2,
                          exceptions: [Faraday::TimeoutError, Faraday::ConnectionFailed],
                          retry_statuses: [429, 500, 502, 503, 504]
        f.adapter Faraday.default_adapter
      end
    end
  end
end
