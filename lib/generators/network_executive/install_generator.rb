require 'rails/generators'

# http://guides.rubyonrails.org/generators.html
# http://rdoc.info/github/wycats/thor/master/Thor/Actions.html

module NetworkExecutive
  class InstallGenerator < Rails::Generators::Base
    desc 'NetworkExecutive installation generator'

    source_root File.expand_path( '../templates', __FILE__ )

    def install
      say 'Installing NetworkExecutive...', :magenta

      create_initializer
      mount_engine

      say 'Done!', :green
    end

  private

    def create_initializer
      if initializer
        say "You already have an initializer so I'm generating a new one at 'network_executive.rb.example' that you can review", :yellow

        @network_name = NetworkExecutive.config.name

        template 'initializer.erb', 'config/initializers/network_executive.rb.example', force:true
      else
        say 'What would you like to name your network?', :yellow

        @network_name = ask("  Press <enter> for [#{default_network_name}] >").presence || default_network_name

        NetworkExecutive.config.name = @network_name

        template 'initializer.erb', 'config/initializers/network_executive.rb'
      end
    end

    def mount_engine
      if mounted?
        say 'NetworkExecutive is already mounted, skipping routes update', :yellow
      else
        say 'Where do you want to mount NetworkExecutive?', :yellow

        mount_at = ask("  Press <enter> for [/#{default_mount_location}] >").presence || default_mount_location

        mount_at = '' if mount_at == '/'

        route "mount NetworkExecutive::Engine => '/#{mount_at}', as:'network_executive'"
      end
    end

    def mounted?
      routes =~ %r{mount NetworkExecutive::Engine}
    end

    def routes
      File.open(Rails.root.join('config/routes.rb')).try :read
    end

    def initializer
      (File.open(Rails.root.join('config/initializers/network_executive.rb')) rescue nil).try :read
    end

    def default_network_name
      NetworkExecutive.config.defaults['name']
    end

    def default_mount_location
      NetworkExecutive.config.name.gsub(' ','').underscore
    end

  end
end