describe NetworkExecutive::Scheduling do

  describe '.every' do
    it 'should schedule the program' do
      channel = Class.new( MyChannel ) do
        include NetworkExecutive::Scheduling

        every :day, play:'my_show'
      end

      channel.schedule.first.should be_a NetworkExecutive::ProgramSchedule
    end
  end

  describe '#whats_on?' do
    let(:channel) do
      Class.new( MyChannel ) do
        include NetworkExecutive::Scheduling
      end
    end

    context 'with nothing scheduled' do
      it 'should return nil' do
        channel = Class.new( MyChannel ) do
          include NetworkExecutive::Scheduling
        end

        channel.new.whats_on?.should be_nil
      end
    end

    it 'should return the most appropriate program' do
      channel.schedule << double('program a', include?: false)
      channel.schedule << double('program b', include?: true)
      channel.schedule << double('program c', include?: true)
      channel.schedule << double('program d', include?: false)

      channel.new.whats_on?.should == channel.schedule[2]
    end
  end

end