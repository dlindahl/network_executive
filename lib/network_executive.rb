require 'network_executive/version'
require 'network_executive/configuration'
require 'network_executive/engine'

module NetworkExecutive

  ProgramNotFoundError = Class.new(StandardError)

  def config
    @config ||= Configuration.new
  end
  module_function :config

  def configure
    yield config
  end
  module_function :configure
end