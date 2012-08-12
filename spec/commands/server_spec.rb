require 'network_executive/commands/server'

describe NetworkExecutive::Server do
  describe '.start!' do
    it 'should create a Server instance' do
      described_class.start!.should be_a described_class
    end
  end
end