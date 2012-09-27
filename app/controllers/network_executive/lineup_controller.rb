module NetworkExecutive
  class LineupController < NetworkExecutive::ApplicationController

    respond_to :html, :json

    def index
      respond_with @lineup = Lineup.new
    end

  end
end