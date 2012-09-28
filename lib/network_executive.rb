require 'network_executive/version'
require 'network_executive/configuration'
require 'network_executive/engine'
require 'network_executive/station'

puts '============= LOAD COMPS'

begin
  require 'network_executive/components'
rescue StandardError => err
  puts 'ZOMG ERROR'
  puts err.inspect
end

puts '============= COMPS DONE'

module NetworkExecutive

  ChannelNotFoundError = Class.new(StandardError)
  ProgramNotFoundError = Class.new(StandardError)
  ProgramNameError     = Class.new(StandardError)

  def config
    @config ||= Configuration.new
  end
  module_function :config

  def configure
    yield config
  end
  module_function :configure
end