describe NetworkExecutive::Viewer do
  let(:env) { {} }

  describe '.change_channel' do
    subject(:change_channel) { described_class.change_channel( 'my_channel', env ) }

    it 'should return a streaming response' do
      described_class.any_instance.should_receive(:response).with env

      NetworkExecutive::Channel.stub(:tune_in_to).and_return nil

      change_channel
    end
  end

  describe '#channel' do
    subject { described_class.new( channel:'my_channel' ).channel }

    it { should == 'my_channel' }
  end

  describe '.response' do
    subject do
      described_class.new.response env
    end

    context 'with a correct Accepts header' do
      before { env['HTTP_ACCEPT'] = 'text/event-stream' }

      it 'should return a streaming response' do
        subject.last.should eq :goliath_stream_response
      end
    end

    context 'with an incorrect Accepts header' do
      before { env['HTTP_ACCEPT'] = 'text/html' }

      it 'should response with a 406' do
        subject.should == [406,nil,nil]
      end
    end
  end

end