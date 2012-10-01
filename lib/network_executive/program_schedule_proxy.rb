require 'ice_cube'

# A proxy object to IceCube::Schedule
#
# Mainly, this allows some method missing magic during block evaluation
# that simplifies the `schedule` DSL by adding new recurrence rules for
# each Rule method that is called from within the block.
module NetworkExecutive
  class ProgramScheduleProxy

    attr_accessor :start_time, :duration

    def initialize( start_time = nil, duration = nil, &block )
      start_time ||= Time.now.beginning_of_day
      duration   ||= 24.hours

      @start_time, @duration = start_time, duration

      @schedule = IceCube::Schedule.new( start_time, duration:duration.to_i )

      if block_given?
        @parsing_schedule = true

        instance_eval( &block )

        @parsing_schedule = false
      end
    end

    def to_schedule
      @schedule
    end

    def respond_to_missing?( method_id, include_private = false )
      if @parsing_schedule
        IceCube::Rule.respond_to?( method_id ) || super
      else
        @schedule.respond_to?( method_id ) || super
      end
    end

    def method_missing( method_id, *args )
      if @parsing_schedule && IceCube::Rule.respond_to?( method_id )
        IceCube::Rule.send( method_id, *args ).tap do |rule|
          @schedule.add_recurrence_rule rule
        end
      elsif @schedule.respond_to?( method_id )
        @schedule.send( method_id, *args )
      else
        super
      end
    end

  end
end