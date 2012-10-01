describe NetworkExecutive::ChannelSchedule do

  describe '#add' do
    let(:program) { double('program_schedule').as_null_object }

    before do
      NetworkExecutive::ProgramSchedule.stub( :new ).and_return program
    end

    subject { described_class.new.add( 'foo' ) }

    it 'should prepend a ProgramSchedule' do
      NetworkExecutive::ProgramSchedule.should_receive :new

      described_class.any_instance.should_receive( :unshift ).with program

      subject
    end
  end

end