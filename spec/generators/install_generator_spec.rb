require 'generators/network_executive/install_generator'

describe NetworkExecutive::InstallGenerator do
  before do
    described_class.any_instance.stub(:say).and_return nil
    described_class.any_instance.stub(:ask).and_return nil
    described_class.any_instance.stub(:template)
  end

  describe '#install' do
    before do
      FakeFS::FileSystem.clone File.join( Rails.root, 'config' )
    end

    subject { described_class.new.install }

    describe 'initializer generation' do

      context 'with no previously existing initializer' do
        it 'should generate the initializer' do
          template_args = [
            'initializer.erb',
            'config/initializers/network_executive.rb'
          ]

          described_class.any_instance.should_receive( :template ).with( *template_args )

          subject
        end
      end

      context 'with an existing initializer' do
        before do
          init = File.join(Rails.root, 'config', 'initializers', 'network_executive.rb')

          File.open(init, 'w+') {|f| f.write('') }
        end

        after do
          File.delete File.join(Rails.root, 'config', 'initializers', 'network_executive.rb')
        end

        it 'should generate an example file' do
          template_args = [
            'initializer.erb',
            'config/initializers/network_executive.rb.example',
            force:true
          ]

          described_class.any_instance.should_receive( :template ).with( *template_args )

          subject
        end
      end

      it 'should configure the network name' do
        described_class.any_instance.stub(:ask).and_return 'Test'

        subject

        NetworkExecutive.config.name.should == 'Test'
      end
    end

    describe 'engine mounting' do
      context 'with no previous mounting' do
        before do
          init = File.join(Rails.root, 'config', 'routes.rb')

          File.open(init, 'w+') {|f| f.write('Dummy::Application.routes.draw do; end') }
        end

        context 'and the default mount location' do
          it 'should generate the route' do
            described_class.any_instance.should_receive(:route).with "mount NetworkExecutive::Engine => '/my_network', as:'network_executive'"

            subject
          end
        end

        context 'and a mount location with a leading slash' do
          it 'should generate the route' do
            described_class.any_instance.stub(:ask).and_return '/foo'

            described_class.any_instance.should_receive(:route).with "mount NetworkExecutive::Engine => '/foo', as:'network_executive'"

            subject
          end
        end

        context 'and a root mount location' do
          it 'should generate the route' do
            described_class.any_instance.stub(:ask).and_return '/'

            described_class.any_instance.should_receive(:route).with "mount NetworkExecutive::Engine => '/', as:'network_executive'"

            subject
          end
        end
      end

      context 'when already mounted' do
        it 'should not create a mounting' do
          described_class.any_instance.should_receive(:route).never

          subject
        end
      end
    end
  end

end