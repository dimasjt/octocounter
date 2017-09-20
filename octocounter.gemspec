# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "octocounter/version"

Gem::Specification.new do |spec|
  spec.name          = "octocounter"
  spec.version       = Octocounter::VERSION
  spec.authors       = ["Dimas J. Taniawan"]
  spec.email         = ["hello@dimasjt.com"]

  spec.summary       = "Count same content of files"
  spec.description   = spec.summary
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.executables   = ["octocounter"]
  spec.require_paths = ["lib"]

  spec.add_dependency "terminal-table"

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
