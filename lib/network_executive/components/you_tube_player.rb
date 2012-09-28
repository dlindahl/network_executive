module NetworkExecutive
  module Components
    module YouTubePlayer

      def url
        NetworkExecutive::Engine.routes.url_helpers.you_tube_path
      end

      def live_feed
        true
      end

    end
  end
end