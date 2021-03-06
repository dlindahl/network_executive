require 'network_executive/version'
require 'network_executive/configuration'
require 'network_executive/components'
require 'network_executive/station'
require 'network_executive/engine'

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