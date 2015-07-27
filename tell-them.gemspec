# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tell-them/version'

Gem::Specification.new do |spec|
  spec.name          = "tell-them"
  spec.version       = TellThem::Rails::VERSION
  spec.authors       = ["K M Lawrence"]
  spec.email         = ["keith@kludge.co.uk"]

  spec.summary       = %q{Adds a fixed debug button to a dev site}
  spec.description   = %q{Adds a fixed debug button to a dev site, which you can put debug information into easily}
  spec.homepage      = "https://www.github.com/KludgeKML/tell_them"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features|coffee|sass|map)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "railties", ">= 3.1"
  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "sass", "~> 0"
  spec.add_development_dependency "coffee", "~> 0"
end
