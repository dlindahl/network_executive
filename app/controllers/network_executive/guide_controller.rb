module NetworkExecutive
  class GuideController < NetworkExecutive::ApplicationController

    respond_to :html, :json

    def index
      current_time_slot = Time.now.floor( Guide::Interval.minutes )

      if stale?( last_modified:current_time_slot, etag:current_time_slot.to_i )
        @guide = Guide.new
      end
    end

  end
end