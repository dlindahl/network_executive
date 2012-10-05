require 'network_executive/network'
require 'network_executive/scheduling'

module NetworkExecutive
  class Channel < EventMachine::Channel
    include Scheduling

    def name
      self.class.name.demodulize.underscore
    end

    def display_name
      name.gsub %r{_}, ' '
    end
    alias_method :to_s, :display_name

    def play( program )
      if program.occurs_at?( Time.now )
        push program.play
      else
        push program.update
      end
    end

    class << self
      def inherited( klass )
        Network.channels << klass.new
      end

      # TODO: Is this the right place for this?
      def find_by_name( name )
        Network.channels.find do |c|
          c.name == name
        end
      end
    end

  end
end