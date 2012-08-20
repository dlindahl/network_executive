module NetworkExecutive
  class Network < Goliath::API

    use Rack::Static,
      index: 'index.html',
      urls:  [ '/index.html' ],
      root:  File.join( NetworkExecutive.root, 'public' )

    def process_sse( env )
      EM.add_periodic_timer(1) { env.stream_send("data:hello ##{rand(100)}\n\n") }

      streaming_response 200, { 'Content-Type' => 'text/event-stream' }
    end

    def response(env)
      case env['PATH_INFO']
      when '/sse'
        # run Viewer.new
        process_sse env
      else
        raise Goliath::Validation::NotFoundError
      end
    end

  end
end