require 'network_executive/version'
require 'network_executive/configuration'
require 'network_executive/engine'
require 'network_executive/station'

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