# Represents the currently scheduled programs for all channels in a Network
# for a given time range.
module NetworkExecutive
  # TODO: Why does this subclass Hash?
  # TODO: This is an ugly data structure. Refactor.
  class Guide < Hash

    Interval = 15  # In minutes.
    Range    = 1.5 # In hours.

    attr_accessor :start_time, :stop_time

    def initialize( start = nil, stop = nil )
      self.start_time = start || Time.now
      self.stop_time  = stop  || Time.now + Range.hours

      self[:channels] = generate
    end

    def generate
      with_each_channel do |channel, guide|
        programs = channel.whats_on_between? start_time, stop_time, Interval.minutes

        guide << {
          channel:  channel,
          programs: programs
        }
      end
    end

    def start_time=( time )
      @start_time = time.floor( Interval.minutes )
    end

    def stop_time=( time )
      @stop_time = time.floor( Interval.minutes )
    end

    # TODO: Add test
    def times
      @times ||= begin
        cursor = start_time.dup

        times  = []

        while cursor < stop_time do
          times << cursor

          cursor += Interval.minutes
        end

        times
      end
    end

  private

    # TODO: Decouple
    def with_each_channel
      Network.channels.each_with_object([]) do |channel, lu|
        yield channel, lu
      end
    end
  end
end
