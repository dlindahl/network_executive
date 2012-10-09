require 'network_executive/network'

module NetworkExecutive
  class Program

    def name
      self.class.name.demodulize.underscore
    end

    def display_name
      name.titleize
    end

    def url
      ''
    end

    # Will the embedded page be responsible for keeping the content fresh?
    #
    # * `:auto` - The page will be reloaded the page every minute.
    # * `FALSE` - The page will not be reloaded
    #
    # Defaults to `:auto`
    def refresh
      :auto
    end

    # A Hash containing data to pass to the embedded page via postMessage
    # once the IFRAME has indicated that it has loaded.
    def onload
      {}
    end

    # A Hash containing data to pass to the embedded page via postMessage
    # whenever a program update is issued.
    def onupdate
      {}
    end

    # A Hash containing data to pass to the embedded page via postMessage
    # whenever a program is initially shown
    def onshow
      {
        name:    name,
        url:     url,
        onLoad:  onload,
        refresh: refresh
      }
    end

    def play( &block )
      Rails.logger.info %Q[Started playing "#{display_name}" at #{Time.current} (refresh: #{refresh})]

      defer = EM::DefaultDeferrable.new

      defer.callback( &block )

      EM.defer do
        payload = onshow.merge( event:'show:program' )
        json    = ActiveSupport::JSON.encode( payload )

        defer.succeed json
      end

      defer
    end

    def update( &block )
      return play( &block ) if refresh == :auto

      Rails.logger.info %Q[Started updating "#{display_name}" at #{Time.current}]

      defer = EM::DefaultDeferrable.new

      defer.callback( &block )

      EM.defer do
        payload = onupdate.merge( event:'update:program' )
        json    = ActiveSupport::JSON.encode( payload )

        defer.succeed json
      end

      defer
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