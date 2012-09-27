describe NetworkExecutive::Producer do

  describe '.run!' do
    subject { described_class.run! }

    before do
      EM.stub :add_timer
    end

    it 'should immediately run any scheduled programming' do
      described_class.should_receive :run_scheduled_programming

      subject
    end

    it 'should wait for the next 1-minute interval' do
      Timecop.freeze Time.now.change( sec:59 )

      EM.should_receive( :add_timer ).with 1

      subject
    end

    it 'should run scheduled programming every minute' do
      EM.stub( :add_timer ).and_yield

      EM.should_receive( :add_periodic_timer ).with 60

      subject
    end

    it 'should run any scheduled programming at intervals' do
      described_class.should_receive( :run_scheduled_programming ).exactly(3).times

      EM.stub( :add_timer ).and_yield
      EM.stub( :add_periodic_timer ).and_yield

      subject
    end
  end

  describe '.run_scheduled_programming' do
    let(:scheduled)   { double('channel', whats_on?: true) }
    let(:unscheduled) { double('channel', whats_on?: nil) }

    before do
      NetworkExecutive::Network.stub(:channels).and_return [ scheduled, unscheduled ]
    end

    subject { described_class.run_scheduled_programming }

    it 'should show all scheduled programming' do
      scheduled.should_receive :show
      unscheduled.should_receive( :show ).never

      subject
    end
  end

end