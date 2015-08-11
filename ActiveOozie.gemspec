# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ActiveOozie/version'

Gem::Specification.new do |spec|
  spec.name          = "ActiveOozie"
  spec.version       = ActiveOozie::VERSION
  spec.authors       = ["oren mazor"]
  spec.email         = ["oren.mazor@gmail.com"]
  spec.summary       = %q{Oozie API Client}
  spec.description   = %q{Oozie API Client}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_dependency 'webhdfs'
  spec.add_dependency 'rest-client'
  spec.add_dependency 'nokogiri'
  spec.add_dependency 'byebug'
end
