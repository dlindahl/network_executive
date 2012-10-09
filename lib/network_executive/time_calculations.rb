module NetworkExecutive
  module TimeCalculations

    # Rounds the specific time to the nearest interval
    def floor( nearest )
      Time.zone.at( (self.to_f / nearest.to_i).floor * nearest.to_i )
    end

  end
end