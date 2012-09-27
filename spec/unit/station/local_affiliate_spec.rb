describe NetworkExecutive::Station::LocalAffiliate do
  describe '#initialize' do
    it 'should run the Producer on the next tick' do
      EM.stub( :next_tick ).and_yield

      NetworkExecutive::Producer.should_receive( :run! )

      described_class.new
    end
  end

  describe '#call' do
    before { EM.stub( :next_tick ) }

    let(:env) { double('env').as_null_object }

    subject { described_class.new.call( env ) }

    context 'with a request that accepts event streams' do
      before do
        Faye::EventSource.stub( :eventsource? ).and_return true
      end

      it 'should change the channel for the Viewer' do
        NetworkExecutive::Viewer.should_receive( :change_channel ).with env

        subject
      end
    end

    context 'with a request that does not accept event streams' do
      before do
        Faye::EventSource.stub( :eventsource? ).and_return false
      end

      it 'should return a 403' do
        subject.first.should == 403
      end
    end
  end
end