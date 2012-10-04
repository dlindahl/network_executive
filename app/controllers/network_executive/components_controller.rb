module NetworkExecutive
  class ComponentsController < NetworkExecutive::ApplicationController

    def twitter
      program = Program.find_by_name params[:program]

      raise ProgramNotFoundError( "Could not find program #{params[:program]}") unless program

      current_time_slot = Time.now.floor( Guide::Interval.minutes )

      if stale?( last_modified:current_time_slot, etag:current_time_slot.to_i )
        @tweets = program.tweets
      end
    end

  end
end