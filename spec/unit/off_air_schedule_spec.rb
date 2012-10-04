describe NetworkExecutive::OffAirSchedule do

  its(:program)  { should be_a NetworkExecutive::OffAir }
  its(:duration) { should == 59.seconds }

  it 'should be subclass ProgramSchedule' do
    subject.is_a? NetworkExecutive::ProgramSchedule
  end

  describe '#occurrence_at' do
    let(:time) { Time.now.change(min:0, sec:0) }

    subject { described_class.new.occurrence_at time }

    it 'return build a ProgramSchedule Occurrence' do
      args = [
        time,
        59.seconds,
        time + 59.seconds
      ]

      NetworkExecutive::ProgramSchedule::Occurrence.should_receive(:new).with( *args )

      subject
    end
  end

end