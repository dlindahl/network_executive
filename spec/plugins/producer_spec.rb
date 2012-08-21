describe NetworkExecutive::Producer do

  subject { described_class.new(nil, nil, nil, nil) }

  describe '#run' do
    before do
      NetworkExecutive::Network.stub(:programming).and_return %w{foo bar}
    end

    # TODO: Not entirely sure how best to test this...
    it 'should show the program' do
      EM.should_receive( :add_periodic_timer ).with 10

      EM.run {
        subject.run

        EM.stop
      }
    end
  end

end