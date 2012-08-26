require 'network_executive/behaviors/scheduling'

module NetworkExecutive
  class Channel < EventMachine::Channel
    extend Scheduling

    # Example
    # every :monday, play:'morning_show'
    # every :day,    play:'stoplight',    for_the_first:'15mins',  of:'each hour', ending_at:'11am'
    # every :day,    play:'tweets',       for_the_last: '15mins',  of:'every hour'
    # every :day,    play:'sales',        for_the_first:'15mins',  of:'each hour', between:'2pm and 5pm'
    # every :friday, play:'lunch_menu',   between:'11am and 13pm', commercial_free:true

    def name
      self.class.name.demodulize.underscore
    end

    def show( program_name )
      program = Network.programming.find do |p|
        p.name == program_name
      end

      # TODO: Test
      # raise ProgramNotFound unless program

      push program.play
    end

    class << self
      def inherited( klass )
        Network.channels << klass.new
      end
    end

  end
end