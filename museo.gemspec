# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "museo/version"

Gem::Specification.new do |spec|
  spec.name          = "museo"
  spec.version       = Museo::VERSION
  spec.authors       = ["Daniel Ma"]
  spec.email         = ["drailskid@yahoo.com"]

  spec.summary       = %(Snapshot testing for Rails views)
  spec.description   = %(Provide snapshot testing utilities for Rails views)
  spec.homepage      = "https://github.com/danielma/museo"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rails", ">= 4", "< 5.1"
  spec.add_development_dependency "appraisal"
  spec.add_development_dependency "rubocop", "~> 0.42"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "guard-minitest"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "awesome_print"
end
