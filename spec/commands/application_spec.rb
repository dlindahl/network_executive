require 'fakefs/spec_helpers'
require 'network_executive/commands/application'

describe NetworkExecutive::Application do
  include FakeFS::SpecHelpers

  it 'should require a path' do
    expect { described_class.new }.to raise_error( ArgumentError )
  end

  describe '#name' do
    context 'with a full path' do
      subject { described_class.new('/path/for/my/network/nbc').name }

      it { should == 'nbc' }
    end

    context 'with the current path' do
      subject { described_class.new('.').name }

      it { should == 'my_network' }
    end
  end

  describe '#build_app' do
    before do
      FakeFS::FileSystem.clone 'lib/network_executive/templates'

      described_class.any_instance.stub(:say_status).and_return nil

      described_class.new( 'test_network' ).build_app
    end

    it 'should create /app' do
      File.should exist 'test_network/app'
    end

    it 'should create /config' do
      File.should exist 'test_network/config'
    end

    it 'should create /config/test_network.rb' do
      File.read('test_network/config/test_network.rb').should match 'TestNetwork < NetworkExecutive::Network'
    end

    it 'should create /log' do
      File.should exist 'test_network/log/.gitkeep'
    end

    it 'should create /public' do
      File.should exist 'test_network/public'
    end

    it 'should create /test_network/test_network.ru' do
      File.read('test_network/test_network.ru').should match 'run TestNetwork'
    end
  end
end