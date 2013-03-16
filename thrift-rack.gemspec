# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'thrift/rack/version'

Gem::Specification.new do |spec|
  spec.name          = "thrift-rack"
  spec.version       = Thrift::Rack::VERSION
  spec.authors       = ["Andrew Bloomgarden"]
  spec.email         = ["stalkingtiger@gmail.com"]
  spec.description   = %q{A Rack-based Thrift server}
  spec.summary       = %q{A Rack-based Thrift server}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "thrift"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
