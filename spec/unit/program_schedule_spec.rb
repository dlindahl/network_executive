describe NetworkExecutive::ProgramSchedule do

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

      before do
        NetworkExecutive::Program.stub( :find_by_name ).and_return known_program
      end

      subject { described_class.new( 'known' ) }

      its(:program) { should == known_program }
    end

    context 'proxy' do
      before do
        NetworkExecutive::Program.stub( :find_by_name ).and_return true
      end

      subject { described_class.new('p').proxy }

      it 'should have a schedule proxy' do
        subject.should be_a NetworkExecutive::ProgramScheduleProxy
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

end
