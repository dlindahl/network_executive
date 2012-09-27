# TODO: Only load when needed (enables asset pipeline)
require 'sass-rails'

module NetworkExecutive

  class Engine < Rails::Engine
    engine_name :network_executive

    isolate_namespace NetworkExecutive

    initializer 'network_executive.eager_load_channels' do |app|
      eager_load_models_in 'channels', app
    end

    initializer 'network_executive.eager_load_programs' do |app|
      eager_load_models_in 'programs', app
    end

  private

    def eager_load_models_in( sub_path, app )
      Dir[ File.join(app.root, 'app', sub_path, '*') ].each do |c|
        require c
      end
    end

  end
end