# frozen_string_literal: true

require_relative "lib/ip_whitelist_rack/version"

Gem::Specification.new do |spec|
  spec.name          = "ip_whitelist_rack"
  spec.version       = IpWhitelistRack::VERSION
  spec.authors       = ["duhlin"]
  spec.email         = ["ddduhlin@gmail.com"]

  spec.summary       = "Whitelist source ip for traefik."
  spec.description   = <<-DESC
    Simple http server based on Rack.

    Access to this http server is expected to be controlled by traefik BasicAuth middleware.
    This server adds the source ip of the request to a list of authorized ip. 
    This list of authorized ip can then be used to control access to other server by traefik
  DESC
  spec.homepage      = "https://github.com/duhlin/ip_whitelist_rack"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.4.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/duhlin/ip_whitelist_rack"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "rack", "~> 2.2.3"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
