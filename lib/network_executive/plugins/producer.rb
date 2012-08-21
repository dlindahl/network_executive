module NetworkExecutive
  class Producer
    def initialize( port, config, status, logger ); end

    # NOTE: Brain dead implementation of a mechanism to drive the client.
    def run
      programs = Network.programming.dup

      EM.add_periodic_timer(10) do
        # TODO: Refactor (demeter)
        Network.channels.first.show programs.first.name

        programs.reverse!
      end
    end
  end
end