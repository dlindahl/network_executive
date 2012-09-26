describe NetworkExecutive::Program do

  class MyProgram < NetworkExecutive::Program
  end

  subject { MyProgram.new }

  its(:name) { should == 'my_program' }
  its(:url)  { should == '' }
  its(:play) { should == %q[{"name":"my_program","url":""}] }

  describe '#as_json' do
    subject { MyProgram.new.as_json }

    it { should include( name:'my_program' ) }
    it { should include( url: '' ) }
  end

  describe '.inherited' do
    it 'should register the program with the Network' do
      NetworkExecutive::Network.programming.first.should be_a MyProgram
    end
  end
end