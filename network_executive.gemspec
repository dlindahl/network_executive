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

  gem.required_ruby_version = '>= 1.9.2'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency             'commander',     '~> 4.1.0'
  gem.add_dependency             'thin',          '~> 1.4.1'
  gem.add_dependency             'activesupport', '~> 3.2.0'

  gem.add_development_dependency 'awesome_print'
  gem.add_development_dependency 'rspec',     '~> 2.11.0'
  gem.add_development_dependency 'fakefs',    '~> 0.4.0'
end
