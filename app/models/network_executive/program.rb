require 'multi_json'

require 'network_executive/network'

module NetworkExecutive
  class Program

    def name
      self.class.name.demodulize.underscore
    end

    def url
      ''
    end

    # TRUE to disable reloading the page for every tick.
    # Defaults to FALSE
    #
    # Indicates that the embedded page will handle keeping the content
    # fresh.
    def live_feed
      false
    end

    # A Hash containing data to pass to embedded page via postMessage
    # once the IFRAME has indicated that it is ready.
    def onready
      {}
    end

    def as_json
      {
        name:      name,
        url:       url,
        onReady:   onready,
        live_feed: live_feed
      }
    end

    def play
      MultiJson.encode( as_json )
    end

    class << self
      def inherited( klass )
        Network.programming << klass.new
      end

      # TODO: Is this the right place for this?
      def find_by_name( name )
        Network.programming.find do |p|
          p.name == name
        end
      end
    end

  end
end