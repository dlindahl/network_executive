require 'network_executive/network'
require 'network_executive/scheduling'

module NetworkExecutive
  class Channel < EventMachine::Channel
    include NetworkExecutive::Scheduling

    def name
      self.class.name.demodulize.underscore
    end
    alias_method :to_s, :name

    def display_name
      name.gsub %r{_}, ' '
    end

    def play( program )
      if program.occurs_at?( Time.now.change(sec:0) )
        program.play do |msg|
          push msg
        end
      else
        program.update do |msg|
          push msg
        end
      end
    end

    def play_whats_on( &block )
      whats_on?.play( &block )
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