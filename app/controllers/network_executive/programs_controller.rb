module NetworkExecutive
  class ProgramsController < NetworkExecutive::ApplicationController

    def show
      render "network_executive/programs/#{params[:program_name]}"
    end

  end
end