module NetworkExecutive
  class LineupRange

    def initialize( start, stop, options = {} )
      @start, @stop, @options = start, stop, options

      @options[:interval] ||= 15
    end

    def each
      showtime = @start.dup

      while showtime < @stop
        yield showtime

        showtime += @options[:interval].minutes
      end
    end

    def each_with_object( obj )
      each do |showtime|
        yield showtime, obj
      end

      obj
    end

    # Divides a time span into segments specified by the 'interval' option
    def segments
      ( ( (@stop - @start) / 1.hour ) / @options[:interval] ).minutes.to_i
    end

  end
end