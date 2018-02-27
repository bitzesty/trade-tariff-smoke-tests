# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'smoke_tests/version'

Gem::Specification.new do |spec|
  spec.name          = "smoke_tests"
  spec.version       = SmokeTests::VERSION
  spec.authors       = ["bitzesty"]
  spec.email         = ["emir.ibrahimbegovic@bitzesty.com"]

  spec.summary       = 'In order to keep LIVE stable we need to have automated data scanner, which can be runned manually and automatically via CIRCLE CI.'
  spec.license       = "MIT"
  spec.homepage      = ''

  spec.files         = Dir["{lib}/**/*"] + ['Rakefile']
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib", "lib/configuration"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
end
