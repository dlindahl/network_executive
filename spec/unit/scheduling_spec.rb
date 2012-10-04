describe NetworkExecutive::Scheduling do

  let(:klass) do
    Class.new do
      include NetworkExecutive::Scheduling
    end
  end

  before do
    stub_const 'MyChannel', klass
  end

  subject { MyChannel.new }

  describe '.schedule' do
    context 'with a block' do
      it 'should add a program' do
        params = [
          'program',
          kind_of(Hash)
        ]

        NetworkExecutive::ChannelSchedule.any_instance.should_receive( :add ).with( *params )

        MyChannel.schedule( 'program' ) do
          # ...
        end
      end
    end

    context 'without a block' do
      it 'should be a ChannelSchedule' do
        MyChannel.schedule.should be_a NetworkExecutive::ChannelSchedule
      end
    end
  end

  describe '#schedule' do
    it 'should be a ChannelSchedule' do
      subject.schedule.should be_a NetworkExecutive::ChannelSchedule
    end
  end

  describe '#whats_on?' do
    before { Timecop.freeze }

    it 'should return what is on right now' do
      subject.should_receive( :whats_on_at? ).with( Time.now )

      subject.whats_on?
    end
  end

  describe '#whats_on_at?' do
    context 'with nothing scheduled' do
      before do
        NetworkExecutive::ChannelSchedule.any_instance.stub(:find).and_return nil
      end

      it 'should return OffAir' do
        subject.whats_on_at?( Time.now ).should be_a NetworkExecutive::OffAir
      end
    end

    context 'with something scheduled' do
      let(:prog_1) { double('unscheduled', whats_on?: false) }
      let(:prog_2) { double('scheduled',   whats_on?: true)  }
      let(:prog_3) { double('unscheduled', whats_on?: false) }

      before do
        subject.schedule << prog_1
        subject.schedule << prog_2
        subject.schedule << prog_3
      end

      it 'should return the scheduled program' do
        subject.whats_on_at?( Time.now ).should == prog_2
      end
    end
  end

  describe '#whats_on_between?' do
    it 'should ask the ChannelSchedule what is on between two dates' do
      date_a = Time.now
      date_b = date_a + 1.5.hours

      args = [ date_a, date_b, nil ]

      NetworkExecutive::ChannelSchedule.any_instance.should_receive(:whats_on_between?).with( *args )

      subject.whats_on_between? date_a, date_b
    end
  end

end