module NetworkExecutive
  module Components
    module PhotoPlayer

      include NetworkExecutive::Components::FeedPlayer

      def url
        NetworkExecutive::Engine.routes.url_helpers.slideshow_path
      end

    end
  end
end