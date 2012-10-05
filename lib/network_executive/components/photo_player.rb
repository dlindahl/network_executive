require 'net/http'

module NetworkExecutive
  module Components
    module PhotoPlayer

      def url
        NetworkExecutive::Engine.routes.url_helpers.slideshow_path
      end

      def refresh
        false
      end

      def onload
        {
          photos: photos
        }
      end

      def feed_url
        raise NotImplementedError
      end

      def photos
        []
      end

      def feed
        _url = URI.parse( feed_url )
        http = Net::HTTP.new( _url.host, _url.port )

        if _url.scheme == 'https'
          http.use_ssl     = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        end

        request  = Net::HTTP::Get.new( _url.request_uri )
        response = http.request( request )

        JSON.parse response.body
      rescue StandardError
        {}
      end

    end
  end
end