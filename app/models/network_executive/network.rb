require 'network_executive/plugins/producer'
require 'network_executive/lineup'

module NetworkExecutive
  class Network < Goliath::API

    # TODO: Make this work
    # plugin NetworkExecutive::Producer

    use Rack::Static,
      index: 'index.html',
      urls:  [ '/index.html', '/stylesheets', '/javascripts' ],
      root:  File.join( NetworkExecutive.root, 'public' )

    # TODO: Add test
    def render( path )
      path = File.join( NetworkExecutive.root, path )

      if File.exists? path
        file = File.read path

        [ 200, {}, file ]
      else
        raise Goliath::Validation::NotFoundError
      end
    end

    def response( env )
      controller, id = env['PATH_INFO'].split('/')[1..-1]

      case controller
      when 'tune_in'
        Viewer.change_channel id, env
      when 'channels'
        render 'public/index.html'
      when 'lineup'
        [ 200, { 'Content-Type' => 'application/json' }, Lineup.new.to_json ]
      else
        raise Goliath::Validation::NotFoundError
      end
    end

    class << self
      def channels=( channel )
        self.channels << channel
      end

      def channels
        @channels ||= []
      end

      def programming=( program )
        self.programs << program
      end

      def programming
        @programs ||= []
      end

      def tune_in_to( channel_name, env )
        channel = self.channels.find do |c|
          c.name == channel_name
        end

        raise ChannelNotFound unless channel

        # TODO: Move this to the channel#tune_in
        channel.subscribe do |msg|
          env.stream_send "data: #{msg}\n\n"
        end
      end
    end

  end
end
