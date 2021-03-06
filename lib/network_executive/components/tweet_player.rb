require 'active_support/concern'

require 'twitter'

# TODO: Refactor this into a plugin. Might want to include a generator that
# creates an initializer.
module NetworkExecutive
  module Components
    module TweetPlayer
      extend ActiveSupport::Concern

      def url
        NetworkExecutive::Engine.routes.url_helpers.twitter_path
      end

      def refresh
        false
      end

      def onload
        {
          tweets: self.class.tweets[:statuses]
        }
      end

      module ClassMethods
        attr_accessor :client, :query

        def client
          @client ||= Twitter::Client.new
        end

        def configure
          yield client
        end

        def search( *args )
          @query = args
        end

        def tweets
          client.search( *query )
        end
      end

    end
  end
end