require 'network_executive/program_schedule_proxy'

module NetworkExecutive
  class ProgramSchedule
    attr_accessor :program, :start_time, :duration, :proxy

    Occurrence = Struct.new('Occurrence', :start_time, :duration, :end_time)

    def initialize( program, options = {}, &block )
      parse_options options

      @program = Program.find_by_name program

      raise ProgramNameError, %Q{"#{program}" is not a registered Program} unless @program

      @block = block
    end

    def proxy
      @proxy ||= ProgramScheduleProxy.new( start_time, duration, &@block )
    end

    def start_time=( time )
      @start_time = time

      reset_proxy!

      time
    end

    def duration=( d )
      @duration = d

      reset_proxy!

      d
    end

    def whats_on?( time = Time.current )
      proxy.occurring_at? time
    end

    def occurs_at?( time )
      proxy.occurs_at? time
    end

    def play( &block )
      program.play( &block )
    end

    def update( &block )
      program.update( &block )
    end

    # Returns the scheduled occurrence that matches the specified time
    def occurrence_at( time )
      real_duration = duration - 1

      range = [ time - real_duration, time ]

      start_time = proxy.occurrences_between( range[0], range[1] ).first
      end_time   = start_time + real_duration

      Occurrence.new start_time, real_duration, end_time
    end

    def respond_to_missing?( method_id, include_private = false )
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

  private

    def parse_options( options )
      options.symbolize_keys!

      options[:duration] ||= 24.hours

      @duration = options[:duration]

      if options[:start_time]
        if options[:start_time].is_a? String
          @start_time = Time.parse( options[:start_time] )
        else
          @start_time = options[:start_time]
        end
      end
    end

    def reset_proxy!
      @proxy = nil

      self.proxy
    end

  end
end