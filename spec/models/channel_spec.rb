describe NetworkExecutive::Channel do

  let(:klass) do
    Class.new described_class
  end

  before do
    stub_const 'MyChannel', klass
  end

  subject { MyChannel.new }

  its(:name)         { should == 'my_channel' }
  its(:display_name) { should == 'my channel' }
  its(:to_s)         { should == 'my channel' }

  describe '#show' do
    let(:program_double)   { double('program') }

    it 'should play the program' do
      program_double.should_receive :play
      described_class.any_instance.should_receive :push

      subject.show program_double
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