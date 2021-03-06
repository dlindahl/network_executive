require 'network_executive/producer'

module NetworkExecutive
  class Station < Rails::Engine
    class LocalAffiliate
      def initialize
        EM.next_tick do
          NetworkExecutive::Producer.run!
        end
      end

      def call( env )
        if Faye::EventSource.eventsource?( env )
          Viewer.change_channel env
        else
          [ 403, nil, [] ]
        end
      end
    end
  end
end