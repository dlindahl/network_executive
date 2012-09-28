describe NetworkExecutive::Program do

  let(:klass) do
    Class.new described_class
  end

  before do
    stub_const 'MyProgram', klass
  end

  subject { MyProgram.new }

  its(:name) { should == 'my_program' }
  its(:url)  { should == '' }
  its(:live_feed) { should be_false }
  its(:onready) { should == {} }
  its(:play) { should == %q[{"name":"my_program","url":"","onReady":{},"live_feed":false}] }

  describe '#as_json' do
    subject { MyProgram.new.as_json }

    it { should include( name:'my_program' ) }
    it { should include( url: '' ) }
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