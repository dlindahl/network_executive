module NetworkExecutive
  class LineupController < NetworkExecutive::ApplicationController

    respond_to :html, :json

    def index
      current_time_slot = Time.now.floor( Lineup::Interval.minutes )

      if stale?( last_modified:current_time_slot, etag:current_time_slot.to_i )
        @lineup = Lineup.new
      end
    end

  end
end