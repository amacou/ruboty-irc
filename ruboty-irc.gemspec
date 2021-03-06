# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruboty/irc/version'

Gem::Specification.new do |spec|
  spec.name          = "ruboty-irc"
  spec.version       = Ruboty::Irc::VERSION
  spec.authors       = ["masayuki_oguni"]
  spec.email         = ["masayuki_oguni.dev@gmail.com"]
  spec.summary       = "IRC adapter for Ruboty."
  spec.homepage      = "https://github.com/masayukioguni/ruboty-irc"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "ruboty"
  spec.add_dependency "zircon", ">= 0.0.8"
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
