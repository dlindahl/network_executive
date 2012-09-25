require 'rails/generators'

module NetworkExecutive
  class UninstallGenerator < Rails::Generators::Base
    source_root File.expand_path( '../templates', __FILE__ )

    desc 'NetworkExecutive uninstall'

    def uninstall
      say 'Uninstalling NetworkExecutive...', :magenta

      remove_file 'config/initializers/network_executive.rb'
      remove_file 'config/initializers/network_executive.rb.example'

      gsub_file 'config/routes.rb', /mount NetworkExecutive::Engine => \'\/.+\', as:\S*\'network_executive\'/, ''

      say 'Done!', :green
    end
  end
end