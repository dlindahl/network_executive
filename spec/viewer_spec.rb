describe NetworkExecutive::Viewer do

  describe '#response' do
    let(:env) { double('env').as_null_object }

    subject(:call_response) do
      described_class.new.response env
    end

    it 'should say something every second' do
      EM.should_receive( :add_periodic_timer ).with 1

      EM.run {
        call_response

        EM.stop
      }
    end

    it 'should return a streaming response' do
      EM.stub(:add_periodic_timer).and_return true

      EM.run {
        subject.last.should eq :goliath_stream_response

        EM.stop
      }
    end
  end

end