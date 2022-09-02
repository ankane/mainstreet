require_relative "lib/mainstreet/version"

Gem::Specification.new do |spec|
  spec.name          = "mainstreet"
  spec.version       = MainStreet::VERSION
  spec.summary       = "Address verification for Ruby and Rails"
  spec.homepage      = "https://github.com/ankane/mainstreet"
  spec.license       = "MIT"

  spec.author        = "Andrew Kane"
  spec.email         = "andrew@ankane.org"

  spec.files         = Dir["*.{md,txt}", "{lib}/**/*"]
  spec.require_path  = "lib"

  spec.required_ruby_version = ">= 2.7"

  spec.add_dependency "geocoder", ">= 1.5.1"
end
