require 'goliath'

module NetworkExecutive
  class Network < Goliath::API

    def response(env)
      [200, {}, "Network Response: #{Time.now}"]
    end

  end
end