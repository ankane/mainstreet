require_relative "lib/mainstreet/version"

Gem::Specification.new do |spec|
  spec.name          = "mainstreet"
  spec.version       = MainStreet::VERSION
  spec.summary       = "Address verification for Ruby and Rails"
  spec.homepage      = "https://github.com/ankane/mainstreet"
  spec.license       = "MIT"

  spec.author        = "Andrew Kane"
  spec.email         = "andrew@chartkick.com"

  spec.files         = Dir["*.{md,txt}", "{lib}/**/*"]
  spec.require_path  = "lib"

  spec.required_ruby_version = ">= 2.2"

  spec.add_dependency "geocoder", ">= 1.5.1"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "activerecord"
  spec.add_development_dependency "i18n"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock"
end
