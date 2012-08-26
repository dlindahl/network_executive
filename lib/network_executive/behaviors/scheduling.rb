require 'network_executive/program_schedule'

module NetworkExecutive
  module Scheduling

    def schedule
      @schedule ||= []
    end

    # maybe this create a job and store it in an array?
    # then every second, it can loop through the list and see what matches.
    # last one wins
    def every( date, options )
      schedule << ProgramSchedule.new( date, options )
    end

  end
end