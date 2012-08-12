require 'network_executive/behaviors/file_system'

module NetworkExecutive

  class Application
    include Behaviors::FileSystem

    def initialize( root )
      @root = root

      build_app
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

    def self.source_root
      File.expand_path File.join( File.dirname( __FILE__ ), '..', 'templates' )
    end

  private

    def build_app
      Dir.mkdir @root unless Dir.exists? @root

      app
      config
      log
      public_directory
    end

  end

end