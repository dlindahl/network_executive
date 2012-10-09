module NetworkExecutive
  module TimeCalculations

    # Rounds the specific time to the nearest interval
    # [nearest] An interval in minutes that is not greater than an hour.
    def floor( nearest )
      nearest = nearest.to_i / 1.minute
      min     = ( self.min.to_f / nearest.to_i ).floor * nearest

      self.change min:min
    end

  end
end