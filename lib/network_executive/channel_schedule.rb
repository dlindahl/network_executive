require 'network_executive/program_schedule'

module NetworkExecutive
  class ChannelSchedule < Array

    def add( program, options = {}, &block )
      unshift ProgramSchedule.new( program, options, &block )
    end

  end
end