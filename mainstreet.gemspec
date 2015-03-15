# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "mainstreet/version"

Gem::Specification.new do |spec|
  spec.name          = "mainstreet"
  spec.version       = Mainstreet::VERSION
  spec.authors       = ["Andrew Kane"]
  spec.email         = ["andrew@chartkick.com"]

  spec.summary       = "A standard US address model for Rails"
  spec.description   = "A standard US address model for Rails"
  spec.homepage      = "https://github.com/ankane/mainstreet"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "geocoder"

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "activerecord"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "smartystreets"
  spec.add_development_dependency "geocoder"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock"
end
