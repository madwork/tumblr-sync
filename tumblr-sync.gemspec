# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tumblr-sync/version'

Gem::Specification.new do |spec|
  spec.name          = "tumblr-sync"
  spec.version       = TumblrSync::VERSION
  spec.author        = "Vincent Durand"
  spec.email         = "vincent.durand@madwork.org"
  spec.description   = "Synchronize pictures from a Tumblr blog with ease and faster than ever!"
  spec.summary       = "Synchronize pictures from a Tumblr blog"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "webmock"

  spec.add_runtime_dependency "nokogiri", "~> 1.6.0"
  spec.add_runtime_dependency "mechanize", "~> 2.7.0"
  spec.add_runtime_dependency "ruby-progressbar", "~> 1.2.0"
end
