module NetworkExecutive
  class Viewer

    attr_accessor :id, :heartbeat

    def initialize( env )
      @env = env
    end

    def ip
      @ip ||= begin
        if addr = @env['HTTP_X_FORWARDED_FOR']
          (addr.split(',').grep(/\d\./).first || @env['REMOTE_ADDR']).to_s.strip
        else
          @env['REMOTE_ADDR']
        end
      end
    end

    def channel
      Channel.find_by_name( channel_name ).tap do |ch|
        raise ChannelNotFoundError unless ch
      end
    end

    def stream
      @stream ||= Faye::EventSource.new @env
    end

    def tune_in
      Rails.logger.debug "Tuning in to the #{channel} channel for #{ip} at #{Time.now}"

      self.id = channel.subscribe { |msg| stream.send msg }

      stream.onclose = method(:tune_out).to_proc
    end

    def tune_out( event )
      Rails.logger.debug "Tuning out of the #{channel} channel for #{ip} at #{Time.now}"

      channel.unsubscribe id

      heartbeat.cancel

      @stream = nil
    end

    def response
      stream.rack_response
    end

    def channel_name
      @env['PATH_INFO'].split('/').last
    end

    def keep_alive!
      self.heartbeat = EM.add_periodic_timer( 30 ) do
        stream.ping

        Rails.logger.debug "Completed PING for #{ip} on the #{channel} channel at #{Time.now}"
      end
    end

    class << self
      def change_channel( env )
        viewer = Viewer.new( env )

        viewer.tune_in
        viewer.keep_alive!

        viewer.response
      end
    end

  end
end