# -*- encoding: utf-8 -*-
require File.expand_path('../lib/network_executive/version', __FILE__)

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

  # gem.add_dependency             'commander',       '~> 4.1.0'
  # gem.add_dependency             'goliath',         '~> 1.0.0'
  gem.add_dependency             'activesupport',   '~> 3.2.0'
  # gem.add_dependency             'em-http-request', '~> 1.0.3'

  gem.add_runtime_dependency     'sass-rails',      '~> 3.2'

  gem.add_development_dependency 'awesome_print'
  gem.add_development_dependency 'rails',           '~> 3.2.8'
  gem.add_development_dependency 'rspec-rails',     '~> 2.11'
  gem.add_development_dependency 'fakefs',          '~> 0.4.0'
  gem.add_development_dependency 'timecop',         '~> 0.4.5'
end
