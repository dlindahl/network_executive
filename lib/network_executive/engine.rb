module NetworkExecutive
  class Engine < Rails::Engine
    engine_name :network_executive

    isolate_namespace NetworkExecutive
  end
end