describe NetworkExecutive::Program do

  let(:klass) do
    Class.new described_class
  end

  before do
    stub_const 'MyProgram', klass
  end

  subject { MyProgram.new }

  its(:name) { should == 'my_program' }
  its(:display_name) { should == 'My Program' }
  its(:url)  { should == '' }
  its(:refresh) { should == :auto }
  its(:onload) { should == {} }
  its(:onupdate) { should == {} }
  its(:play) { should == %q[{"name":"my_program","url":"","onLoad":{},"refresh":"auto","event":"show:program"}] }

  describe '#onshow' do
    subject { MyProgram.new.onshow }

    it { should include( name:'my_program' ) }
    it { should include( url: '' ) }
    it { should include( onLoad: {} ) }
    it { should include( refresh: :auto ) }
  end

  describe '#update' do
    context 'when #refresh is set to :auto' do
      it 'should play the program' do
        subject.stub(:refresh).and_return :auto

        subject.should_receive( :play )

        subject.update
      end
    end

    context 'when #refresh is NOT set to :auto' do
      it 'should return the contents of #onupdate' do
        subject.stub(:refresh).and_return 'zomg'

        subject.update.should == %q[{"event":"update:program"}]
      end
    end
  end

  describe '.find_by_name' do
    it 'should find a program by name' do
      NetworkExecutive::Network.programming.should_receive( :find )

      described_class.find_by_name 'foo'
    end
  end

  describe '.inherited' do
    it 'should register the program with the Network' do
      NetworkExecutive::Network.programming.first.should be_a described_class
    end
  end
end