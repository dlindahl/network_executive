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

  describe 'schedule' do
    it 'should be a ChannelSchedule' do
      channel = Class.new( MyChannel ) do
        include NetworkExecutive::Scheduling
      end

      channel.schedule.should be_a NetworkExecutive::ChannelSchedule
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
        channel.new.whats_on?.should be_nil
      end
    end

    it 'should return the most appropriate program for a given time' do
      program_c = double('program c', include?: true)

      channel.schedule.add double('program a', include?: false)
      channel.schedule.add double('program b', include?: true)
      channel.schedule.add program_c
      channel.schedule.add double('program d', include?: false)

      channel.new.whats_on?.should == program_c
    end

    it 'should return all programs scheduled for a range of times' do
      program_b = double 'program b'
      program_b.stub(:include?).and_return true, false

      program_c = double 'program c'
      program_c.stub(:include?).and_return false, true

      channel.schedule.add double('program a', include?: false)
      channel.schedule.add program_b
      channel.schedule.add program_c
      channel.schedule.add double('program d', include?: false)

      shows = channel.new.whats_on?( 1.hour.ago, 1.hour.from_now )

      shows.first[:program].should be program_b
      shows.last[:program].should be program_c
    end

    it 'should yield a block when provided a stop_time' do
      program_a = double('program a', include?: true)
      channel.schedule.add program_a

      channel.new.whats_on?( 1.hour.ago, 1.hour.from_now) do |program|
        program.should be program_a
      end
    end
  end

  describe '#with_showtimes_between' do
    let(:channel) do
      Class.new( MyChannel ) do
        include NetworkExecutive::Scheduling

        every :day, play:'my_show'
      end.new
    end

    subject do
      program_a = double 'program_a', include?: true

      channel.schedule.add program_a

      channel.with_showtimes_between( 1.hour.ago, 1.hour.from_now ) do |showtime, program|
        'block retval'
      end
    end

    it { should be_a Array }

    it 'should contain the blocks return value' do
      subject.all?{ |x| x == 'block retval' }.should be_true
    end

  end

end