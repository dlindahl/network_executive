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
      template 'public/index.html', 'public/index.html'
    end

    def procfile
      template 'Procfile', 'Procfile'
    end

    def gitignore
      template '.gitignore', '.gitignore'
    end

    def build_app
      Dir.mkdir( root ) unless Dir.exists? root

      app
      config
      log
      public_directory

      procfile
      gitignore
    end

    def self.source_root
      File.expand_path File.join( File.dirname( __FILE__ ), '..', 'templates' )
    end

  end

end