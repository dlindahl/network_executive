module NetworkExecutive
  class Channel < EventMachine::Channel

    def name
      self.class.name.demodulize.underscore
    end

    def show( program_name )
      program = Network.programming.find do |p|
        p.name == program_name
      end

      # TODO: Test
      # raise ProgramNotFound unless program

      push program.play
    end

    class << self
      def inherited( klass )
        Network.channels << klass.new
      end
    end

  end
end