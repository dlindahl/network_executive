module NetworkExecutive
  class Producer
    def initialize( port, config, status, logger ); end

    def run
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
        if scheduled_program = channel.whats_on?
          channel.show scheduled_program
        end
      end
    end
  end
end