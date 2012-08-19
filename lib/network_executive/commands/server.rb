require 'goliath/runner'
require 'network_executive/network'

module NetworkExecutive

  class Server < Goliath::Runner

    def initialize( argv = [], api = nil )
      super

      build_app

      yield self if block_given?
    end

    def start
      # TODO: Why is this different from Goliath's log calls?
      puts "http://#{address}:#{port}"
      puts "=> Booting Network Executive v#{NetworkExecutive::VERSION} (#{Goliath.env})"
      trap(:INT) { exit }
      puts '=> Ctrl-C to shutdown server'

      run
    ensure
      puts 'Exiting'
      exit
    end

    def api
      Network.new
    end

    def app
      @app ||= Goliath::Rack::Builder.build api.class, api
    end
    alias_method :build_app, :app

    class << self
      def start!
        new( ARGV ) do |server|
          server.start
        end
      end
    end
  end

end