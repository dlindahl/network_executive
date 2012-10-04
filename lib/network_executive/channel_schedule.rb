require 'network_executive/program_schedule'
require 'network_executive/off_air_schedule'
require 'network_executive/scheduled_program'

module NetworkExecutive
  class ChannelSchedule < Array

    def add( program, options = {}, &block )
      unshift ProgramSchedule.new( program, options, &block )
    end

    def whats_on_between?( start, stop, interval )
      cursor   = start.dup
      programs = []

      until cursor > stop do
        program    = find_program_occurring_at( cursor )

        occurrence = program.occurrence_at cursor

        if repeated_off_air?( programs, program )
          program, occurrence, remainder = extend_off_air( programs, program, stop )
        else
          remainder = time_left( cursor, occurrence.end_time, stop )
        end

        portion   = remainder / (stop - start) * 100
        step      = occurrence.end_time - cursor

        programs << ScheduledProgram.new( program, occurrence, remainder, portion )

        cursor += step + 1
      end

      programs
    end

  private

    def find_program_occurring_at( time )
      find { |p| p.occurring_at? time } || OffAirSchedule.new( start_time:time )
    end

    def time_left( time, end_time, max = end_time )
      [ max, end_time ].min - time
    end

    def repeated_off_air?( programs, program )
      return unless last = programs.last

      last.program.is_a?( OffAirSchedule ) && program.is_a?( OffAirSchedule )
    end

    # Extends the previous Off Air schedule
    def extend_off_air( programs, program, stop )
      prev       = programs.pop + program
      program    = prev.program
      occurrence = prev.occurrence
      remainder  = time_left( occurrence.start_time, occurrence.end_time, stop )

      [ program, occurrence, remainder ]
    end

  end
end