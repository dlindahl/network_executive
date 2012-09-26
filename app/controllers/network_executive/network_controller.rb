module NetworkExecutive
  class NetworkController < NetworkExecutive::ApplicationController

    def index
      @channels = NetworkExecutive::Network.channels
    end

  end
end