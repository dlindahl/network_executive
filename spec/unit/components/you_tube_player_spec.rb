describe NetworkExecutive::Components::YouTubePlayer do

  let(:klass) do
    Class.new.send :include, described_class
  end

  before do
    stub_const 'MyProgram', klass
  end

  subject { MyProgram.new }

  its(:url) { should == '/you_tube' }

  its(:refresh) { should be_false }

end