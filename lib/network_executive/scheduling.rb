require 'active_support/concern'

require 'network_executive/channel_schedule'

module NetworkExecutive
  module Scheduling
    extend ActiveSupport::Concern

    def whats_on_at?( time )
      schedule.find { |sch| sch.whats_on? time } || OffAir.new
    end

    def whats_on?
      whats_on_at? Time.now
    end

    def schedule
      self.class.schedule
    end

    module ClassMethods
      def schedule( program = nil, options = {}, &block )
        @schedule ||= ChannelSchedule.new

        if block_given?
          @schedule.add program, options, &block
        else
          @schedule
        end
      end
    end

  end
end