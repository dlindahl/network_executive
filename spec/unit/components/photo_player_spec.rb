describe NetworkExecutive::Components::PhotoPlayer do

  let(:klass) do
    Class.new.send :include, described_class
  end

  before do
    stub_const 'MyProgram', klass
  end

  subject { MyProgram.new }

  its(:url) { should == '/slideshow' }

end