# frozen_string_literal: true

require_relative "lib/fizzy_mcp/version"

Gem::Specification.new do |spec|
  spec.name = "fizzy-mcp"
  spec.version = FizzyMcp::VERSION
  spec.authors = ["daggerhashjack"]
  spec.email = ["jrb4209@gmail.com"]

  spec.summary = "Model Context Protocol server for Fizzy (kanban)"
  spec.description = "Exposes the Fizzy REST API as MCP tools so an MCP client " \
                     "(Claude Code, etc.) can read and manage boards, cards, " \
                     "columns, comments, and the rest of a Fizzy account."
  spec.homepage = "https://github.com/daggerhashjack/fizzy-mcp"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = Dir["lib/**/*.rb", "exe/*", "LICENSE", "README.md", "CHANGELOG.md"]
  spec.bindir = "exe"
  spec.executables = ["fizzy-mcp"]
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", "~> 2.10"
  spec.add_dependency "faraday-retry", "~> 2.2"
  spec.add_dependency "mcp", "~> 0.16"
end
