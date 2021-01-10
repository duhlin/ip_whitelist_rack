# frozen_string_literal: true

require "ip_whitelist_rack"

use Rack::ShowExceptions
run IpWhitelistRack::IpWhitelistRack.new
