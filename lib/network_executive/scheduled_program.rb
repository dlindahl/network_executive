module NetworkExecutive
  class ScheduledProgram
    attr_accessor :program, :occurrence, :remainder, :portion

    def initialize( *args )
      @program, @occurrence, @remainder, @portion = *args
    end

    def name
      program.name
    end

    # Extends this scheduled program with another program of the same type.
    def +( other_program )
      raise ArgumentError if @program.class != other_program.class

      additional_duration = other_program.duration + 1

      program.duration    += additional_duration
      occurrence.duration += additional_duration
      occurrence.end_time += additional_duration

      self
    end
  end
end
