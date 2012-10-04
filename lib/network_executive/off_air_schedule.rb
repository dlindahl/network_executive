# Acts as a NullObject for ProgramSchedule
module NetworkExecutive
  class OffAirSchedule < ProgramSchedule

    def initialize( options = {} )
      options[:duration] ||= 59.seconds

      super 'off_air', options
    end

    def occurrence_at( time )
      end_time = time + duration

      ProgramSchedule::Occurrence.new time, duration, end_time
    end

  end
end