# Represents a channel's programming line up for a given time span.
module NetworkExecutive
  # TODO: Why does this subclass Hash?
  class Lineup < Hash

    Interval = 15  # In minutes.
    Range    = 1.5 # In hours.

    def initialize( start = Time.now, stop = nil )
      self.start_time = start || Time.now
      self.stop_time  = stop  || Time.now + Range.hours

      self[:channels] = generate
    end

    def generate
      with_each_channel do |channel, lineup|
        lineup << {
          name:     channel.display_name,
          schedule: whats_on?( channel ) do |show|
            show.program_name.titleize
          end
        }
      end
    end

    def start_time=( time )
      @start_time = floor time
    end

    def start_time
      @start_time
    end

    def stop_time=( time )
      @stop_time = floor time
    end

    def stop_time
      @stop_time
    end

  private

    # Rounds the specific time to the nearest interval
    def floor( time, nearest = nil )
      nearest ||= Interval.minutes

      Time.at((time.to_f / nearest.to_i).floor * nearest.to_i)
    end

    # TODO: Decouple
    def with_each_channel
      Network.channels.each_with_object([]) do |channel, lu|
        yield channel, lu
      end
    end

    # TODO: Decouple
    def whats_on?( channel )
      channel.whats_on?( start_time, stop_time, interval:Interval ) do |show|
        yield show
      end
    end
  end
end
