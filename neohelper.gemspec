# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'neohelper/version'

Gem::Specification.new do |spec|
  spec.name          = "neohelper"
  spec.version       = Neohelper::VERSION
  spec.authors       = ["Javad Karabi"]
  spec.email         = ["karabijavad@gmail.com"]
  spec.description   = %q{Helper functions for working with neo4j}
  spec.summary       = %q{Helper functions for working with neo4j}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
