ENV['RACK_ENV']  ||= 'test'
ENV['RAILS_ENV'] ||= 'test'

require 'rubygems'
require 'bundler/setup'

require 'awesome_print'

require File.expand_path( '../dummy/config/environment.rb',  __FILE__ )

require 'rails/test_help'
require 'rspec/rails'
require 'fakefs/spec_helpers'
require 'timecop'

Rails.backtrace_cleaner.remove_silencers!

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true

  # Because of the use of Rack::Static, we need to initialize the
  # fake filesystem before NetworkExecutive is loaded.
  config.before do
    FakeFS.activate!
  end

  config.after do
    FakeFS.deactivate!

    Timecop.return

    NetworkExecutive::Network.channels.clear
    NetworkExecutive::Network.programming.clear
  end
end