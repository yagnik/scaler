# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'scaler/version'

Gem::Specification.new do |spec|
  spec.name          = "scaler"
  spec.version       = Scaler::VERSION
  spec.authors       = ["Yagnik"]
  spec.email         = ["yagnikkhanna@gmail.com"]
  spec.description   = %q{ Scale any code across multiple ec2 instance}
  spec.summary       = %q{ Scale any code across multiple ec2 instance}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency     "thor"
  spec.add_runtime_dependency     "aws-sdk"
  spec.add_runtime_dependency     "capistrano"
  spec.add_runtime_dependency     "hashie"
  spec.add_runtime_dependency     "json"
  spec.add_runtime_dependency     "log4r"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rdoc"
end
