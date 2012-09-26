module NetworkExecutive
  class ChannelSchedule < Array

    def add( program )
      unshift program
    end

    def find_by_showtime( time )
      find{ |p| p.include? time }
    end

  end
end