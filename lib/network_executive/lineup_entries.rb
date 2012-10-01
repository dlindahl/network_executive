module NetworkExecutive
  class LineupEntries < Array

    def initialize( range, intervals )
      raise ArgumentError, "Expected #{range} to be a ActiveSupport::Duration"     unless range.is_a?     ActiveSupport::Duration
      raise ArgumentError, "Expected #{intervals} to be a ActiveSupport::Duration" unless intervals.is_a? ActiveSupport::Duration

      @range     = range
      @intervals = intervals
      @units     = range / @intervals.to_f
    end

    def push( program )
      if entry = build_entry( program )
        super entry
      else
        self
      end
    end
    alias_method :<<, :push

    def unshift(*)
      raise NotImplementedError
    end

    def increment
      [ last[:program].duration, @range ].min
    end

  private

    def build_entry( program )
      if continued_off_air?( program )
        extend_off_air program
      else
        generate_entry program
      end
    end

    def continued_off_air?( program )
      program.is_a?( OffAir ) && last && last[:program].is_a?( OffAir )
    end

    def extend_off_air( program )
      increment        = program.duration.seconds
      intervals        = last[:intervals] + increment / @intervals
      percent_of_total = intervals / @units * 100

      last[:intervals]           = intervals
      last[:percentage_of_total] = percent_of_total

      nil
    end

    def generate_entry( program )
      duration      = [ program.duration.seconds, @range ].min
      intervals     = duration / @intervals
      perc_of_total = intervals / @units * 100

      {
        program:             program,
        intervals:           intervals,
        percentage_of_total: perc_of_total
      }
    end

  end
end