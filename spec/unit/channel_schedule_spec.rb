describe NetworkExecutive::ChannelSchedule do

  let(:time)     { Time.now.change(min:45, sec:0) }
  let(:interval) { 15.minutes }
  let(:schedule) { described_class.new }

  let(:program_schedule) do
    occ = double('occurrence').tap do |o|
      o.stub(:start_time).and_return time + interval
      o.stub(:duration).and_return 20.minutes
      o.stub(:end_time).and_return time + interval + 20.minutes - 1
    end

    double('program_schedule').tap do |ps|
      ps.stub(:occurring_at?).and_return false
      ps.stub(:occurring_at?).with( time + 15.minutes).and_return true
      ps.stub(:duration).and_return 20.minutes
      ps.stub(:occurrence_at).and_return occ
    end
  end

  describe '#add' do
    subject do
      schedule.add( 'foo', foo:'bar' )
    end

    it 'should prepend a ProgramSchedule' do
      NetworkExecutive::ProgramSchedule
        .should_receive( :new )
        .with( 'foo', { foo:'bar' } )
        .and_return( program_schedule )

      described_class.any_instance.should_receive( :unshift ).with program_schedule

      subject
    end
  end

  describe '#whats_on_between?' do
    let(:start)    { time }
    let(:stop)     { start + 1.hour }

    before do
      schedule.unshift program_schedule
    end

    subject do
      schedule.whats_on_between? start, stop, interval
    end

    it 'should start with 15-minutes of Off Air time' do
      subject.first.program.should be_a NetworkExecutive::OffAirSchedule
      subject.first.remainder.should == 15.minutes - 1
    end

    it 'should contain a scheduled program at the apporiate time' do
      subject[1].program.should eq program_schedule
      subject[1].remainder.should eq 20.minutes - 1
    end

    it 'should fill the remaining time slots of Off Air time' do
      subject.last.program.should be_a NetworkExecutive::OffAirSchedule
      subject.last.remainder.should == 25.minutes
    end
  end

end