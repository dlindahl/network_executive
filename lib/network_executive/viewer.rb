module NetworkExecutive
  class Viewer < Goliath::API

    def response( env )
      EM.add_periodic_timer(1) { env.stream_send("data:hello ##{rand(100)}\n\n") }

      streaming_response 200, { 'Content-Type' => 'text/event-stream' }
    end

  end
end