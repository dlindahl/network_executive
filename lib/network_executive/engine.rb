# TODO: Only load when needed (enables asset pipeline)
require 'sass-rails'

module NetworkExecutive

  class Engine < Rails::Engine
    engine_name :network_executive

    isolate_namespace NetworkExecutive

    initializer 'network_executive.eager_load_channels' do |app|
      eager_load_models_in 'channels', app
    end

    initializer 'network_executive.eager_load_default_programs' do |app|
      eager_load_models_in 'programs', self
    end

    initializer 'network_executive.eager_load_user_programs' do |app|
      eager_load_models_in 'programs', app
    end

    initializer :assets do |app|
      app.config.assets.precompile += [
        'network_executive.js',
        'network_executive/you_tube.js',

        'network_executive.css',
        'network_executive/off_air.css',
        'network_executive/you_tube.css',
      ]
    end

  private

    def eager_load_models_in( sub_path, app )
      Dir[ File.join(app.root, 'app', sub_path, '**', '*.rb') ].each do |c|
        require c
      end
    end

  end
end