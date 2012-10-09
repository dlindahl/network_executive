module NetworkExecutive
  class GuideController < NetworkExecutive::ApplicationController

    respond_to :html, :json

    cattr_accessor :index_cached

    def index
      if stale_cache?
        self.class.index_cached = true

        @guide = Guide.new
      end
    end

  private

    # Only 304 if the cache is fresh *OR* we haven't cached the page yet.
    # This allows server reboots to regenerate the content in the case
    # of an error.
    #
    # NOTE: It is important to note the order of the arguments. The call to
    # Rails` `stale?` method does magical things to the response, so its
    # important that it comes last. If the custom logic indicates that the
    # page should not be cached, then we don't want the Rails method to be
    # called and magically send an unwanted 304.
    def stale_cache?
      !self.class.index_cached || stale?( caching_params )
    end

    def caching_params
      current_time_slot = Time.current.floor( Guide::Interval.minutes )

      {
        last_modified: current_time_slot,
        etag:          current_time_slot.to_i
      }
    end

  end
end