require 'network_executive/behaviors/file_system'

module NetworkExecutive

  class Application
    include Behaviors::FileSystem

    attr_accessor :root, :name

    def initialize( root )
      self.root = root
    end

    def name
      @name ||= begin
        network_name = root.split('/').last unless root[-1] == '.'

        network_name || 'my_network'
      end
    end

    def app
      directory 'app'
    end

    def config
      directory 'config'
    end

    def log
      empty_directory_with_gitkeep 'log'
    end

    def public_directory
      directory 'public'
    end

    def network
      template 'config/my_network.rb', "config/#{name}.rb"
    end

    def rackup
      template 'my_network.ru', "#{name}.ru"
    end

    def build_app
      Dir.mkdir( root ) unless Dir.exists? root

      app
      config
      log
      public_directory

      network
      rackup
    end

    def self.source_root
      File.expand_path File.join( File.dirname( __FILE__ ), '..', 'templates' )
    end

  end

end