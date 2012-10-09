require 'active_support/concern'

require 'instagram'

module NetworkExecutive
  module Components
    module InstagramPlayer
      extend ActiveSupport::Concern

      def url
        NetworkExecutive::Engine.routes.url_helpers.slideshow_path
      end

      def refresh
        false
      end

      def onload
        {
          items: self.class.items
        }
      end

      module ClassMethods
        attr_accessor :items, :query

        def user_recent_media( *args )
          self.query = [ :user_recent_media, args ]
        end

        def items
          Instagram.send( @query.first, *@query.last ).collect do |p|
            {
              image_url:    p.images.standard_resolution.url,
              title:        "#{p.likes.count} likes",
              description:  p.caption.text,
              photographer: p.user.full_name,
              location:     p.location.try(:name)
            }
          end
        end

      end

    end
  end
end