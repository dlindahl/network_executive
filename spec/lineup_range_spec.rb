describe NetworkExecutive::LineupRange do

  before do
    Timecop.freeze Time.now.change hour:12, min:0, sec:0
  end

  let(:start) { Time.now }

  let(:stop) { 1.5.hours.from_now }

  describe '#each' do
    subject do
      times = []

      described_class.new(start, stop).each { |st| times << st }

      times
    end

    it 'should yield a showtime for each segment' do
      subject.size.should == 6
    end

    it 'should yield the start time' do
      subject.first.should == start
    end

    it 'should yield a rounded stop time' do
      subject.last.should == stop - 15.minutes
    end
  end

  describe '#each_with_object' do
    subject do
      my_obj = []

      described_class.new( start, stop ).each_with_object( my_obj ) do |st, o|
        o << st
      end

      my_obj
    end

    it 'should yield the specified object for each segment' do
      subject.size.should == 6
    end
  end

  describe '#segments' do
    subject { described_class.new( start, stop, interval:interval).segments }

    context 'with a default interval' do
      let(:interval) { nil }

      it { should == 6 }
    end

    context 'with a half-hour interval' do
      let(:interval) { 30 }

      it { should == 3 }
    end
  end

end