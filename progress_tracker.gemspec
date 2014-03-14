# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'progress_tracker/version'

Gem::Specification.new do |spec|
  spec.name          = "progress_tracker"
  spec.version       = ProgressTracker::VERSION
  spec.authors       = ["Dan Cheail"]
  spec.email         = ["dan@undumb.com"]
  spec.description   = %q{A very simple API for logging and retreiving the progress of a given background task using Redis.}
  spec.summary       = %q{}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", "~> 4.0"
  spec.add_dependency "redis", "~> 3.0"
  spec.add_dependency "redis-namespace", "~> 1.3"

  spec.add_development_dependency "mock_redis"
  spec.add_development_dependency "rspec", "~> 2.14"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
