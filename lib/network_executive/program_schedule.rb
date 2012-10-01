require 'network_executive/program_schedule_proxy'

module NetworkExecutive
  class ProgramSchedule
    attr_accessor :program, :options, :proxy

    def initialize( program, options = {}, &block )
      options.symbolize_keys!

      @options = options
      @program = Program.find_by_name program

      raise ProgramNameError unless @program

      @proxy = ProgramScheduleProxy.new( options[:start_time], options[:duration], &block )
    end

    def whats_on?( time = Time.now )
      proxy.occurring_at? time
    end

    def respond_to_missing?( method_name, include_private = false )
      proxy.respond_to?( method_id ) \
        || program.respond_to?( method_id ) \
        || super
    end

    def method_missing( method_id, *args )
      if program.respond_to?( method_id )
        program.send method_id, *args
      elsif proxy.respond_to?( method_id )
        proxy.send method_id, *args
      else
        super
      end
    end

  end
end