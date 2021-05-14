# frozen_string_literal: true

require_relative "ip_whitelist_rack/version"

require "logger"
require "rack"
require "yaml"

module IpWhitelistRack
  # main class executed using rackup
  class IpWhitelistRack
    def logger
      STDOUT.sync = true
      @logger ||= Logger.new(STDOUT).tap do |l|
        l.level = Logger::INFO
        l.info "Logger initialized with #{l.level}"
      end
    end

    def traefik_filename
      ENV.fetch("TRAEFIK_DYNAMIC_CONF_YML", "/traefik/dynamic_conf.yml")
    end

    def traefik_middleware_name
      @traefik_middleware_name ||= ENV.fetch("TRAEFIK_MIDDLEWARE_NAME", "whiteList")
    end

    def load_traefik
      @traefik ||= YAML.safe_load(File.read(traefik_filename))
    end

    def traefik_ip_list
      load_traefik.fetch("http")
                  .fetch("middlewares")
                  .fetch(traefik_middleware_name)
                  .fetch("ipWhiteList")
                  .fetch("sourceRange")
    end

    def save_traefik
      logger.debug "saving config: #{@traefik}"
      File.write(traefik_filename, YAML.dump(@traefik))
    end

    def add_to_whitelist(ip)
      if traefik_ip_list.include?(ip)
        logger.info "#{ip} already registered"
      else
        traefik_ip_list.push(ip)
        save_traefik
        logger.info "#{ip} registered"
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
      source_ip = env["HTTP_X_FORWARDED_FOR"]
      logger.info "Whitelisting #{source_ip}"
      logger.debug "env: #{env}"

      add_to_whitelist(source_ip)
      success(source_ip)
    end
  end
end
