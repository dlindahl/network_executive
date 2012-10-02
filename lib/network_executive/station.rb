require 'faye/websocket'

require 'network_executive/station/local_affiliate'

module NetworkExecutive

  class Station < Rails::Engine
    # endpoint Station::LocalAffiliate.new
    # endpoint Station::LocalAffiliate.new self
    # endpoint Station::LocalAffiliate
    middleware.use Station::LocalAffiliate
  end

end
