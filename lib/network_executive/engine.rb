# TODO: Only load when needed (enables asset pipeline)
require 'sass-rails'

module NetworkExecutive
  class Engine < Rails::Engine
    engine_name :network_executive

    isolate_namespace NetworkExecutive
  end
end