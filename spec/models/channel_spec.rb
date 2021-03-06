describe NetworkExecutive::Channel do

  let(:klass) do
    Class.new described_class
  end

  before do
    stub_const 'MyChannel', klass
  end

  subject { MyChannel.new }

  its(:name)         { should == 'my_channel' }
  its(:to_s)         { should == 'my_channel' }
  its(:display_name) { should == 'my channel' }

  describe '#play' do
    let(:program_double) { double('program', occurs_at?: starting ) }

    context 'at a programs start time' do
      let(:starting) { true }

      it 'should play the program' do
        program_double.should_receive( :play ).and_yield( {} )

        described_class.any_instance.should_receive :push

        subject.play program_double
      end
    end

    context 'after a programs start time' do
      let(:starting) { false }

      it 'should update the program' do
        program_double.should_receive( :update ).and_yield( {} )

        described_class.any_instance.should_receive :push

        subject.play program_double
      end
    end
  end

  describe '#play_whats_on' do
    let(:program) { double('program') }

    it 'should ask what is on and play the program' do
      described_class.any_instance.should_receive( :whats_on? ).and_return program

      program.should_receive( :play ).and_yield( {} )

      subject.play_whats_on do |m|
        m.should == {}
      end
    end
  end

  describe '.find_by_name' do
    it 'should find a program by name' do
      NetworkExecutive::Network.channels.should_receive( :find )

      described_class.find_by_name 'foo'
    end
  end

  describe '.inherited' do
    it 'should register the channel with the Network' do
      NetworkExecutive::Network.channels.first.should be_a MyChannel
    end
  end

end