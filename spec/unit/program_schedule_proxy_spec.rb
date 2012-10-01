describe NetworkExecutive::ProgramScheduleProxy do

  describe '#initialize' do

    context 'start time' do
      context 'when specified' do
        let(:time) { 1.hour.ago }

        subject { described_class.new( time ) }

        it 'should be the specified time' do
          subject.start_time.should == time
        end
      end

      context 'when unspecified' do
        it 'should default to the beginning of the day' do
          subject.start_time.should == Time.now.beginning_of_day
        end
      end
    end

    context 'duration' do
      context 'when set' do
        subject do
          described_class.new( nil, 15.minutes ).duration
        end

        it 'should have the specified duration' do
          subject.should == 15.minutes
        end
      end

      context 'when not set' do
        subject do
          described_class.new.duration
        end

        it 'should default to a full day' do
          subject.should == 24.hours
        end
      end
    end

    context 'block evaluation' do
      it 'should evaluate the block' do
        evald = false

        described_class.new { evald = true }

        evald.should be_true
      end
    end
  end

  describe '#to_schedule' do
    it 'should return the internal IceCube::Schedule instance' do
      subject.to_schedule.should be_a IceCube::Schedule
    end
  end

  describe '#respond_to_missing?' do
    context 'when parsing a schedule block' do
      # TODO: Not the best test setup in the world...
      before { subject.instance_variable_set('@parsing_schedule', true) }

      it 'should respond to anything that IceCube::Rule does' do
        subject.respond_to_missing?( :minutely ).should be_true
      end
    end

    context 'when outside a schedule parsing block' do
      it 'should respond to anything that IceCube::Rule does' do
        subject.respond_to_missing?( :all_occurrences ).should be_true
      end
    end
  end

  describe '#method_missing' do
    context 'when parsing a schedule block' do
      it 'should add a recurrence rule' do
        IceCube::Schedule.any_instance.should_receive( :add_recurrence_rule )
          .twice
          .with kind_of( IceCube::Rule )

        described_class.new do
          minutely 30
          minutely 45
        end
      end
    end

    context 'when outside a schedule parsing block' do
      it 'should attempt to forward to the schedule' do
        IceCube::Schedule.any_instance.should_receive( :all_occurrences )

        described_class.new.all_occurrences
      end
    end
  end

end