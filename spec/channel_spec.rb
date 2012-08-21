describe NetworkExecutive::Channel do

  class MyChannel < NetworkExecutive::Channel
  end

  subject { MyChannel.new }

  its(:name) { should == 'my_channel' }

  describe '#show' do
    it 'should play the program' do
      program_double = double('program')
      NetworkExecutive::Network.programming.stub( :find ).and_return program_double

      program_double.should_receive :play

      subject.show 'my_program'
    end
  end

  describe '.inherited' do
    it 'should register the channel with the Network' do
      NetworkExecutive::Network.channels.first.should be_a MyChannel
    end
  end

end