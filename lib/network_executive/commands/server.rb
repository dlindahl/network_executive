require 'rack/server'
require 'rack/builder'

module NetworkExecutive

  class Server < Rack::Server

    def initialize(*)
      super

      yield self if block_given?
    end

    def start
      puts "http://#{options[:Host]}:#{options[:Port]}"
      puts "=> Booting Network Executive v#{NetworkExecutive::VERSION}"
      trap(:INT) { exit }
      puts '=> Ctrl-C to shutdown server'

      super
    ensure
      puts 'Exiting'
    end

    def app
      @app ||= super.respond_to?(:to_app) ? super.to_app : super
    end

    def default_options
      rackup_file = Dir['*.ru'].first

      super.merge({
        Port:        3000,
        environment: (ENV['RACK_ENV'] || 'development').dup,
        config:      File.expand_path( rackup_file )
      })
    end

    class << self
      def start!
        new do |server|
          server.start
        end
      end
    end
  end

end