describe NetworkExecutive::Guide do

  let(:show) do
    show = double('show', program_name:'show 1')
  end

  let(:channel) do
    channel = double('channel', display_name:'channel a').as_null_object

    channel.stub(:whats_on_between?).and_return [ show ]

    channel
  end

  let(:channels) do
    [
      channel
    ]
  end

  before do
    Timecop.freeze Time.now.change hour:12, min:0, sec:0

    NetworkExecutive::Network.stub( :channels ).and_return channels
  end

  describe '#start_time' do
    before { described_class.any_instance.stub(:generate) }

    context 'the default value' do
      subject { described_class.new.start_time }

      it 'should default to now' do
        subject.should eq Time.now
      end
    end

    context 'an explicit value' do
      let(:start) { Time.now.change hour:11, min:47, sec:54 }

      subject { described_class.new( start ).start_time }

      it 'should be rounded' do
        subject.should eq Time.now.change hour:11, min:45, sec:0
      end
    end
  end

  describe '#stop_time' do
    before { described_class.any_instance.stub(:generate) }

    context 'the default value' do
      subject { described_class.new.stop_time }

      it 'should default to 1.5hours from now' do
        subject.should eq 1.5.hours.from_now
      end
    end

    context 'an explicit value' do
      let(:stop) { Time.now.change hour:13, min:47, sec:54 }

      subject { described_class.new( nil, stop ).stop_time }

      it 'should be rounded' do
        subject.should eq Time.now.change hour:13, min:45, sec:0
      end
    end
  end

  describe '#times' do
    it 'should start with the start time' do
      subject.times.first.should eq Time.now
    end

    it 'should contain 15 minute intervals' do
      subject.times.size.should eq 6
    end

    it 'should end with 1.5 hours after start time' do
      subject.times.last.should eq Time.now + 1.5.hours - 15.minutes
    end
  end

  describe '#channels' do
    subject { described_class.new[:channels] }

    it { should be_an Array }

    it 'should contain a channel' do
      subject.first[:channel].should == channel
    end

    it 'should contain a collection of programs' do
      subject.first[:programs].should be_an Array
    end

    it 'should ask the channel what is on' do
      args = [
        Time.now,
        (Time.now + 1.5.hours),
        15.minutes
      ]

      channels.first.should_receive(:whats_on_between?).with( *args )

      subject
    end
  end

end