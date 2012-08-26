require 'active_support/concern'

require 'network_executive/program_schedule'

module NetworkExecutive
  module Scheduling
    extend ActiveSupport::Concern

    def whats_on?( time = nil )
      time ||= Time.now

      self.class.schedule.reverse.find { |p| p.include? time }
    end

    module ClassMethods
      def schedule
        @schedule ||= []
      end

      def every( date, options )
        schedule << ProgramSchedule.new( date, options )
      end
    end

  end
end