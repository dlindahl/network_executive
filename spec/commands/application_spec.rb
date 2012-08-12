require 'fakefs/spec_helpers'
require 'network_executive/commands/application'

describe NetworkExecutive::Application do
  include FakeFS::SpecHelpers

  it 'should require a path' do
    expect { described_class.new }.to raise_error( ArgumentError )
  end

  describe '#new' do
    before do
      FakeFS::FileSystem.clone 'lib/network_executive/templates'

      described_class.any_instance.stub(:say_status).and_return nil

      described_class.new 'my_network'
    end

    it 'should create /app' do
      File.should exist 'my_network/app'
    end

    it 'should create /config' do
      File.should exist 'my_network/config'
    end

    it 'should create /log' do
      File.should exist 'my_network/log/.gitkeep'
    end

    it 'should create /public' do
      File.should exist 'my_network/public'
    end
  end
end