require 'active_support/inflector'
require 'network_executive/behaviors/terminal_output'

module NetworkExecutive
  module Behaviors
    module FileSystem

      include TerminalOutput

      def directory( source )
        say_status 'create', source

        FileUtils.cp_r "#{self.class.source_root}/#{source}", "#{root}/#{source}"
      end

      def empty_directory_with_gitkeep( source )
        path = "#{root}/#{source}"

        if Dir.exists? path
          say_status 'exists', source, :yellow
        else
          say_status 'create', source
          Dir.mkdir path
        end

        git_keep path
      end

      def git_keep( destination )
        create_file "#{destination}/.gitkeep"
      end

      def create_file( destination, data = nil, config = {} )
        if block_given?
          data = yield
        end

        File.open(destination, 'w') {|f| f.write data }
      end

      # Gets an ERB template at the relative source, executes it and makes a copy
      # at the relative destination. If the destination is not given it's assumed
      # to be equal to the source removing .tt from the filename.
      #
      # ==== Parameters
      # source<String>:: the relative path to the source root.
      # destination<String>:: the relative path to the destination root.
      # config<Hash>:: give :verbose => false to not log the status.
      #
      # ==== Examples
      #
      #   template "README", "doc/README"
      #
      #   template "doc/README"
      #
      def template( source, *args, &block )
        config      = args.last.is_a?(Hash) ? args.pop : {}
        destination = "#{root}/#{args.first}"

        source  = File.expand_path "#{self.class.source_root}/#{source}"
        context = instance_eval 'binding'

        create_file destination, nil, config do
          content = File.open(source, 'rb') { |f| f.read }
          content = ERB.new( content, nil, '-', '@output_buffer').result context
          content = block.call content if block
          content
        end
      end

    end
  end
end