require 'network_executive/commands/server'

describe NetworkExecutive::Server do

  describe '.start!' do
    before do
      described_class.any_instance.stub(:start).and_return true
    end

    subject { described_class.start! }

    it { should be_a described_class }
  end

end