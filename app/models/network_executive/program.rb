require 'multi_json'

module NetworkExecutive
  class Program

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

      # TODO: Is this the right place for this?
      def find_by_name( name )
        Network.programming.find do |p|
          p.name == name
        end
      end
    end

  end
end