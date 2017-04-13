# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ghlabel/version'

Gem::Specification.new do |spec|
  spec.name          = "ghlabel"
  spec.version       = Ghlabel::VERSION
  spec.authors       = ["pcboy"]
  spec.email         = ["david.hagege@gmail.com"]

  spec.summary       = %q{A gem to set/unset labels in PRs}
  spec.description   = %q{}
  spec.homepage      = "https://github.com/pcboy/ghlabel"
  spec.license       = "WTFPL"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"

  spec.add_development_dependency "awesome_print", '~> 1.7'
  spec.add_development_dependency "looksee", '~> 4.0'
  spec.add_dependency "github_api"
  spec.add_dependency "activesupport", '~> 4.0'
  spec.add_dependency 'trollop', '~> 2.1'

end
