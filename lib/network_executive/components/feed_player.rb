require 'faraday'
require 'faraday_middleware'
require 'multi_xml'
require 'addressable/uri'

module NetworkExecutive
  module Components
    module FeedPlayer

      def refresh
        false
      end

      def feed_url
        raise NotImplementedError
      end

      def items
        raise NotImplementedError
      end

      def onload
        {
          items: items
        }
      end

      def feed
        furl = Addressable::URI.parse( feed_url )

        conn = connection( furl.site )

        conn.get( furl.request_uri ).body
      rescue
        puts $!.inspect

        Rails.logger.error "#{$!.class}: #{$!.message} (#{$!.backtrace.first})"
        # ...
      ensure
        {}
      end

    private

      def connection( url )
        Faraday.new( url ) do |conn|
          conn.adapter Faraday.default_adapter
          conn.response :xml,  content_type: %r{\bxml$}
          conn.response :json, content_type: %r{\bjson$}
        end
      end

    end
  end
end