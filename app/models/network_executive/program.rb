require 'multi_json'

module NetworkExecutive
  class Program < Goliath::API

    def name
      self.class.name.demodulize.underscore
    end

    def url
      ''
    end

    def as_json
      {
        name: name,
        url:  url
      }
    end

    def play
      MultiJson.encode( as_json )
    end

    class << self
      def inherited( klass )
        Network.programming << klass.new
      end
    end

  end
end