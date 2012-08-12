require 'network_executive/behaviors/terminal_output'

module NetworkExecutive
  module Behaviors
    module FileSystem

      include TerminalOutput

      def directory( source )
        say_status 'create', source

        FileUtils.cp_r "#{self.class.source_root}/#{source}", "#{@root}/#{source}"
      end

      def empty_directory_with_gitkeep( source )
        say_status 'create', source

        path = "#{@root}/#{source}"

        Dir.mkdir path

        git_keep path
      end

      def git_keep( destination )
        File.open("#{destination}/.gitkeep", 'w') {|f| f.write('') }
      end

    end
  end
end