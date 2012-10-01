# Acts as a NullObject when there is nothing scheduled for a given channel
module NetworkExecutive
  class OffAir < NetworkExecutive::Program

    def display_name
      'Off Air'
    end

    def url
      NetworkExecutive::Engine.routes.url_helpers.program_path 'off_air'
    end

    def duration
      Lineup::Interval.minutes
    end

  end
end