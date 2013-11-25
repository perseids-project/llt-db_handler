# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'llt/db_handler/version'

Gem::Specification.new do |spec|
  spec.name          = "llt-db_handler"
  spec.version       = LLT::DbHandler::VERSION
  spec.authors       = ["LFDM"]
  spec.email         = ["1986gh@gmail.com"]
  spec.description   = %q{LLT DB Handler}
  spec.summary       = %q{LLT DB Handler}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "simplecov", "~> 0.7"
  spec.add_development_dependency "yard"
  spec.add_dependency 'activerecord', "~> 3.2"
  spec.add_dependency "llt-core_extensions"
  spec.add_dependency "llt-constants"
  spec.add_dependency "llt-form_builder"
  spec.add_dependency "llt-helpers"
  spec.add_dependency "pg"
end
