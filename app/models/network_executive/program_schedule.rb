# Example
# every :monday, play:'morning_show'
# every :day,    play:'stoplight',    for_the_first:'15mins',  of:'each hour'
# every :day,    play:'stoplight',    for_the_first:'15mins',  of:'each hour', starting_at:'11am'
# every :day,    play:'stoplight',    for_the_first:'15mins',  of:'each hour', ending_at:'11am'
# every :day,    play:'stoplight',    for_the_first:'15mins',  of:'each hour', starting_at:'10am', ending_at:'11am'
# every :day,    play:'tweets',       for_the_last: '15mins',  of:'every hour'
# every :day,    play:'sales',        for_the_first:'15mins',  of:'each hour', between:'2pm and 5pm'
# every :friday, play:'lunch_menu',   between:'11am and 13pm', commercial_free:true

module NetworkExecutive

  class ProgramSchedule
    attr_accessor :day, :program_name

    Weekdays = %w{sunday monday tuesday wednesday thursday friday saturday}
    BaseDate = { month:2, day:15, year:1978 }

    def initialize( day, options = {} )
      options.symbolize_keys!

      raise ProgramNameError unless options[:play]

      if options[:starting_at] || options[:ending_at]
        range = []
        range << ( options[:starting_at] || '12am' )
        range << ( options[:ending_at]   || '11:59pm' )
        options[:between] = range.join ' and '
      end

      self.day          = day
      self.program_name = options[:play]
      @between          = options[:between]
      @for_the_first    = options[:for_the_first]
      @for_the_last     = options[:for_the_last]
      @period           = options[:of]
      @commercial_free  = options[:commercial_free]
    end

    def day=( new_day )
      new_day = :any if new_day == :day

      @day = new_day
    end

    def include?( date )
      day_matches? date \
        and time_matches? date
    end

    def commercials?
      @commercial_free.nil? ? true : !@commercial_free
    end

    def to_s
      inspect
    end

    def inspect
      range = @between || '12am and 11:59pm'

      %Q{<#{self.class} program_name="#{program_name}" day="#{@day}" between="#{range}" for_the_first="#{@for_the_first || 'nil'}" for_the_last="#{@for_the_last || 'nil'}" commercial_free=#{!commercials?}>}
    end

  private

    def day_matches?( date )
      if day == :any
        true
      elsif day.to_s == Weekdays[date.wday]
        true
      end
    end

    def time_matches?( date )
      comparator = date.dup.change BaseDate

      validations = []

      validations << time_span.cover?( comparator ) if time_span?

      validations << pattern.cover?( comparator ) if repeating?

      validations.none? { |v| v == false }
    end

    def time_span?
      @between
    end

    def time_span
      if matches = @between.match( %r{(?<start>\d+:?\w*)\s*\S+\s*(?<stop>\d+:?\w*)} )
        # Normalize the range to an arbitrary date since we only care about Time.
        start = Time.parse( matches[:start] ).change BaseDate
        stop  = Time.parse( matches[:stop] ).change BaseDate

        start...stop
      end
    end

    def repeating?
      @for_the_first || @for_the_last
    end

    def pattern
      return TimePattern.new @period, first:@for_the_first if @for_the_first
      return TimePattern.new @period, last:@for_the_last   if @for_the_last

      raise StandardError, 'No parsable time pattern'
    end

  end

  class TimePattern
    # TODO: Add support for :period
    def initialize( period, pattern )
      @period   = period
      @boundary = pattern.keys.first
      @pattern  = parse pattern
    end

    def cover?( date )
      range = if @boundary == :first
        0...@pattern[:value]
      elsif @boundary == :last
        (60 - @pattern[:value])..59
      else
        raise ArgumentError, 'Missing a valid pattern boundary'
      end

      range.include? date.send( @pattern[:unit] )
    end

  private

    def parse( p )
      value, unit = p[@boundary].split( %r{(\d+)\s*(\w+)} )[1..-1]

      unit = case unit[0]
      when 'm' then :min
      end

      { value:value.to_i, unit:unit }
    end

  end

end
