require 'faye/websocket'

require 'network_executive/station/local_affiliate'

module NetworkExecutive

  class Station < Rails::Engine
    endpoint Station::LocalAffiliate.new
  end

end
