# frozen_string_literal: true

require "ip_whitelist_rack"

run IpWhitelistRack::IpWhitelistRack.new
