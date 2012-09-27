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
    context 'for a program that exists' do
      let(:scheduled_double) { double('program', program_name:'name') }
      let(:program_double)   { double('program') }

      it 'should play the program' do
        NetworkExecutive::Program.stub( :find_by_name ).and_return program_double

        program_double.should_receive :play
        described_class.any_instance.should_receive :push

        subject.show scheduled_double
      end
    end

    context 'for a program that does not exist' do
      it 'should raise a ProgramNotFoundError' do
        program = double('scheduled_program', program_name:'noop')

        expect{ subject.show program }.to raise_error NetworkExecutive::ProgramNotFoundError
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