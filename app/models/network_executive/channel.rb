require 'network_executive/network'
require 'network_executive/scheduling'

module NetworkExecutive
  class Channel < EventMachine::Channel
    include Scheduling

    # Example
    # every :monday, play:'morning_show'
    # every :day,    play:'stoplight',    for_the_first:'15mins',  of:'each hour', ending_at:'11am'
    # every :day,    play:'tweets',       for_the_last: '15mins',  of:'every hour'
    # every :day,    play:'sales',        for_the_first:'15mins',  of:'each hour', between:'2pm and 5pm'
    # every :friday, play:'lunch_menu',   between:'11am and 13pm', commercial_free:true

    def name
      self.class.name.demodulize.underscore
    end

    def display_name
      name.gsub %r{_}, ' '
    end
    alias_method :to_s, :display_name

    def show( scheduled_program )
      program = Program.find_by_name scheduled_program.program_name

      raise ProgramNotFoundError.new("#{scheduled_program.program_name} is not a registered channel") unless program

      push program.play
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