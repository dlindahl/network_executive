require 'goliath'

require 'network_executive/version'

module NetworkExecutive

  class << self
    def env
      Goliath.env.to_s
    end

    def root
      @root ||= find_root_with_flag 'Procfile', Dir.pwd
    end

  private

    # Copied from Railties
    def called_from
      # Remove the line number from backtraces making sure we don't leave anything behind
      call_stack = caller.map { |p| p.sub(/:\d+.*/, '') }
      File.dirname(call_stack.detect { |p| p !~ %r[network_executive[\w.-]*/lib/network_executive] })
    end

    # Copied from Railties
    def find_root_with_flag(flag, default=nil)
      root_path = called_from

      while root_path && File.directory?(root_path) && !File.exist?("#{root_path}/#{flag}")
        parent = File.dirname(root_path)
        root_path = parent != root_path && parent
      end

      root = File.exist?("#{root_path}/#{flag}") ? root_path : default
      raise "Could not find root path for #{self}" unless root

      Pathname.new File.realpath root
    end

  end
end

require 'network_executive/network'
require 'network_executive/viewer'