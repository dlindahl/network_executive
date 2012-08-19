require 'goliath/runner'
require 'network_executive/network'

module NetworkExecutive

  class Server < Goliath::Runner

    def initialize( argv = [], api = nil )
      super

      rack_it_up

      yield self if block_given?
    end

    def start
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
    alias_method :rack_it_up, :app

    class << self
      def start!
        new( ARGV ) do |server|
          server.start
        end
      end
    end
  end

end