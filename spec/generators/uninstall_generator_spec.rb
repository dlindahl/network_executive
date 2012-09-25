require 'generators/network_executive/uninstall_generator'

describe NetworkExecutive::UninstallGenerator do
  before do
    described_class.any_instance.stub(:say)
    described_class.any_instance.stub(:remove_file)
    described_class.any_instance.stub(:gsub_file)
  end

  describe '#uninstall' do
    before do
      FakeFS::FileSystem.clone File.join( Rails.root, 'config' )
    end

    subject { described_class.new.uninstall }

    it 'should remove the initializers' do
      remove_args = [
        'config/initializers/network_executive.rb',
        'config/initializers/network_executive.rb.example'
      ]

      described_class.any_instance.should_receive(:remove_file).with( remove_args[0] ).with( remove_args[1] )

      subject
    end

    it 'should unmount the engine' do
      gsub_args = [
        'config/routes.rb',
        /mount NetworkExecutive::Engine => \'\/.+\', as:\S*\'network_executive\'/, ''
      ]

      described_class.any_instance.should_receive(:gsub_file).with( *gsub_args )

      subject
    end
  end
end