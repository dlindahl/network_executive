# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'network_executive/version'

Gem::Specification.new do |gem|
  gem.name          = "network_executive"
  gem.version       = NetworkExecutive::VERSION
  gem.authors       = ["Derek Lindahl"]
  gem.email         = ["dlindahl@customink.com"]
  gem.description   = %q{An experimental application used to drive displays hung around an office.}
  gem.summary       = gem.description
  gem.homepage      = "https://github.com/dlindahl/network_executive"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'commander', '~> 4.1.0'

  gem.add_development_dependency 'rspec',     '~> 2.11.0'
end
