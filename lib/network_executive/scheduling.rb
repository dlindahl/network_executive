require 'active_support/concern'

module NetworkExecutive
  module Scheduling
    extend ActiveSupport::Concern

    def whats_on?( start_time = nil, stop_time = nil, options = {} )
      start_time ||= Time.now

      if stop_time
        with_showtimes_between( start_time, stop_time, options ) do |showtime, program|
          program = (block_given? ? yield(program) : program)

          { time:showtime, program:program }
        end
      else
        schedule.find_by_showtime start_time
      end
    end

    def with_showtimes_between( start, stop, options = {} )
      LineupRange.new( start, stop, options ).each_with_object([]) do |showtime, lineup|
        program = schedule.find_by_showtime showtime

        lineup << yield( showtime, program )
      end
    end

    def schedule
      self.class.schedule
    end

    module ClassMethods
      def schedule
        @schedule ||= ChannelSchedule.new
      end

      def every( date, options )
        schedule.add ProgramSchedule.new( date, options )
      end
    end

  end
end