# frozen_string_literal: true

require "spec_helper"
require "json"
require "open3"
require "timeout"

RSpec.describe "fizzy-mcp stdio binary" do
  let(:bin) { File.expand_path("../../exe/fizzy-mcp", __dir__) }
  let(:env) { { "FIZZY_ACCESS_TOKEN" => "test", "FIZZY_ACCOUNT_SLUG" => "6206647" } }

  it "is executable" do
    expect(File.executable?(bin)).to be(true)
  end

  it "responds to initialize and tools/list over stdio" do
    Open3.popen3(env, "ruby", "-I", "lib", bin) do |stdin, stdout, stderr, wait|
      initialize_req = {
        jsonrpc: "2.0", id: 1, method: "initialize",
        params: {
          protocolVersion: "2025-03-26",
          capabilities: {},
          clientInfo: { name: "test", version: "0" }
        }
      }
      stdin.puts(JSON.generate(initialize_req))
      stdin.puts(JSON.generate({ jsonrpc: "2.0", id: 2, method: "tools/list" }))
      stdin.close

      begin
        responses = []
        Timeout.timeout(10) do
          while (line = stdout.gets)
            responses << JSON.parse(line)
            break if responses.size >= 2
          end
        end

        init = responses.find { |r| r["id"] == 1 }
        list = responses.find { |r| r["id"] == 2 }
        expect(init.dig("result", "serverInfo", "name")).to eq("fizzy-mcp")
        expect(list.dig("result", "tools").size).to be > 80
      ensure
        Process.kill("TERM", wait.pid) if wait.alive?
        wait.value
        stderr.read
      end
    end
  end

  it "fails gracefully without FIZZY_ACCESS_TOKEN" do
    _, stderr, status = Open3.capture3(
      { "FIZZY_ACCESS_TOKEN" => "" },
      "ruby", "-I", "lib", bin
    )
    expect(status.success?).to be(false)
    expect(stderr).to include("FIZZY_ACCESS_TOKEN")
  end
end
