# frozen_string_literal: true

require_relative "ip_whitelist_rack/version"

require "logger"
require "rack"

module IpWhitelistRack
  # main class executed using rackup
  class IpWhitelistRack
    def logger
      @logger ||= Logger.new(STDOUT).tap do |l|
        l.level = ENV.fetch("LOG_LEVEL", Logger::Error)
        l.info "Logger initialized with #{l.level}"
      end
    end

    def success(ip)
      body = "#{ip} added to whitelist"
      [
        200,
        {
          "Content-Type" => "text/html",
          "Content-Length" => body.bytesize.to_s
        },
        [body]
      ]
    end

    def call(env)
      source_ip = env["REMOTE_ADDR"]
      logger.info "Whitelisting #{source_ip}"

      success(source_ip)
    end
  end
end
