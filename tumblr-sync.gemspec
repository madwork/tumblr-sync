# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'tumblr-sync/version'

Gem::Specification.new do |spec|
  spec.name          = "tumblr-sync"
  spec.version       = TumblrSync::VERSION
  spec.authors       = ["Vincent Durand"]
  spec.email         = ["vincent.durand@madwork.org"]
  spec.description   = "Synchronize pictures from a Tumblr blog, with multithreading"
  spec.summary       = "Synchronize pictures from a Tumblr blog"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", ">= 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
end
