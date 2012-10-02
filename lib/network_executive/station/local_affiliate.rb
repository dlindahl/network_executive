require 'network_executive/producer'

module NetworkExecutive
  class Station < Rails::Engine
    class LocalAffiliate

      def initialize( *args )
        @app = args.first

        EM.next_tick do
          NetworkExecutive::Producer.run!
        end
      end

      def call( env )
        if Faye::EventSource.eventsource?( env )

          status, headers, body = @app.call(env)

          if body.respond_to?(:close)
            puts '======================== close!'
            body.close
          else
            puts '======================== no close :('
          end


          Viewer.change_channel env
        else
          [ 403, nil, [] ]
        end
      end

    end
  end
end