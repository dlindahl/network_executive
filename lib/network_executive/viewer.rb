require 'active_support/inflector'

module NetworkExecutive
  class Viewer < Goliath::API

    def response( env )
      unless env['HTTP_ACCEPT'] == 'text/event-stream'
        return [ 406, nil, nil ]
      end

      streaming_response 200, { 'Content-Type' => 'text/event-stream' }
    end

    def channel
      @opts[:channel]
    end

    class << self
      def change_channel( channel, env )
        viewer = Viewer.new channel:channel

        NetworkExecutive::Network.tune_in_to viewer.channel, env

        viewer.response env
      end
    end

  end
end