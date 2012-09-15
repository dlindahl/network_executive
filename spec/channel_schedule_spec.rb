describe NetworkExecutive::ChannelSchedule do

  before do
    Timecop.freeze Time.now.change hour:12, min:0, sec:0
  end

  subject do
    schedule = double('schedule')

    schedule.stub(:include?).and_return false, true, false

    described_class.new [ schedule, schedule, schedule ]
  end

  describe '#add' do
    before { subject.add( 'foo' ) }

    it 'should prefix the collection' do
      subject.first.should == 'foo'
    end
  end

  describe '#find_by_showtime' do
    it 'should check if the schedule includes the given time' do
      subject.find_by_showtime( Time.now ).should == subject[1]
    end
  end

end