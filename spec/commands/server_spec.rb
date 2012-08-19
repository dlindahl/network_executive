require 'network_executive/commands/server'

describe NetworkExecutive::Server do

  subject { described_class.new }

  describe '.start!' do
    before do
      described_class.any_instance.stub( :start ).and_return true
    end

    subject { described_class.start! }

    it { should be_a described_class }
  end

  describe '#initialize' do
    before do
      Goliath::Rack::Builder.should_receive :build
    end

    it 'should build the app' do
      subject.api.should be_a NetworkExecutive::Network
    end

    it 'should yield' do
      described_class.new do |server|
        server.should be_a described_class
      end
    end
  end

  describe '#start' do
    it 'should run the Goliath Runner' do
      described_class.any_instance.stub( :run ).and_return true
      described_class.any_instance.stub( :exit ).and_return true

      described_class.any_instance.should_receive :run

      subject.start
    end

  end

end