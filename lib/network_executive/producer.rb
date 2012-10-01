module NetworkExecutive
  class Producer
    cattr_accessor :running

    class << self

      def run!
        # Run whatever should be on right now
        run_scheduled_programming

        now = Time.now

        next_tick = ( now.change( sec:0 ) + 1.minute ) - now

        # Wait for the next 1-minute interval
        EM.add_timer( next_tick ) do
          run_scheduled_programming

          # Setup the main 1-minute loop
          EM.add_periodic_timer( 60 ) do
            run_scheduled_programming
          end
        end
      end

      def run_scheduled_programming
        Network.channels.each do |channel|
          channel.show channel.whats_on?
        end
      end

    end
  end
end