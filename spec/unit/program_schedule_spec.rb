describe NetworkExecutive::ProgramSchedule do

  it 'should define an Occurrence structure' do
    occ = described_class::Occurrence.new

    occ.should respond_to(:start_time)
    occ.should respond_to(:duration)
    occ.should respond_to(:end_time)
  end

  describe '#initialize' do
    context 'with an unknown program name' do
      before do
        NetworkExecutive::Program.stub( :find_by_name ).and_return nil
      end

      it 'should raise a ProgramNameError' do
        expect{ described_class.new( 'null_prog' ) }.to raise_error NetworkExecutive::ProgramNameError
      end
    end

    context 'with a known program name' do
      let(:known_program) { double('program') }
      let(:duration) { nil }

      before do
        NetworkExecutive::Program.stub( :find_by_name ).and_return known_program
      end

      subject { described_class.new( 'known', duration:duration ) }

      it { should respond_to(:start_time) }
      its(:program) { should == known_program }

      context 'and no duration specified' do
        its(:duration) { should == 24.hours }
      end

      context 'and a duration specified' do
        let(:duration) { 35.minutes }

        its(:duration) { should == 35.minutes }
      end

    end
  end

  describe '#proxy' do
    before do
      NetworkExecutive::Program.stub( :find_by_name ).and_return true
    end

    subject { described_class.new('p').proxy }

    it 'should have a schedule proxy' do
      subject.should be_a NetworkExecutive::ProgramScheduleProxy
    end

    it 'should execute the block' do
      canary = 'alive'

      described_class.new('p'){ canary = 'dead' }.proxy

      subject

      canary.should == 'dead'
    end
  end

  describe '#start_time=' do
    before do
      NetworkExecutive::Program.stub( :find_by_name ).and_return true
    end

    it 'should reset the proxy' do
      time = Time.now

      NetworkExecutive::ProgramScheduleProxy.should_receive(:new).with( time, anything )

      described_class.new('p').start_time = time
    end
  end

  describe '#duration=' do
    before do
      NetworkExecutive::Program.stub( :find_by_name ).and_return true
    end

    it 'should reset the proxy' do
      time = 10.minutes

      NetworkExecutive::ProgramScheduleProxy.should_receive(:new).with( anything, time )

      described_class.new('p').duration = time
    end
  end

  describe '#occurs_at?' do
    before do
      NetworkExecutive::Program.stub( :find_by_name ).and_return true
    end

    subject { described_class.new('p').occurs_at? Time.now }

    it 'should delegate to its proxy' do
      NetworkExecutive::ProgramScheduleProxy.any_instance.should_receive( :occurs_at? )

      subject
    end
  end

  describe '#update' do
    let(:program) { double('program') }

    before do
      NetworkExecutive::Program.stub( :find_by_name ).and_return program
    end

    subject { described_class.new('p').update }

    it 'should delegate to its proxy' do
      program.should_receive( :update )

      subject do
        ap 'foo'
      end
    end
  end

  describe '#whats_on?' do
    before do
      Timecop.freeze

      NetworkExecutive::Program.stub( :find_by_name ).and_return double('program')
    end

    subject { described_class.new( 'p').whats_on? }

    it 'should indicate if the schedule has anything occuring at the given time' do
      NetworkExecutive::ProgramScheduleProxy.any_instance.should_receive( :occurring_at? ).with Time.now

      subject
    end
  end

  describe '#occurrence_at' do
    before do
      NetworkExecutive::Program.stub( :find_by_name ).and_return true

      NetworkExecutive::ProgramScheduleProxy
        .any_instance
        .stub(:occurrences_between)
        .and_return [ Time.now.end_of_day ]
    end

    let(:time) { Time.now.end_of_day }

    subject do
      described_class.new('p', start_time:time, duration:1.minute).occurrence_at time
    end

    it 'should build an Occurrence' do
      start_time = time.dup
      duration   = 1.minute - 1
      end_time   = start_time + duration

      subject.start_time.should eq start_time
      subject.duration.should   eq duration
      subject.end_time.should   eq end_time
    end
  end

end
