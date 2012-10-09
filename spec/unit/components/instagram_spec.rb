describe NetworkExecutive::Components::InstagramPlayer do

  let(:klass) do
    Class.new do
      def name; 'foo'; end
    end.send :include, described_class
  end

  before do
    stub_const 'MyProgram', klass
  end

  subject { MyProgram.new }

  its(:url) { should == '/slideshow' }

  its(:refresh) { should be_false }

  describe '#onload' do
    it 'should include the Instagram search results' do
      subject.class.should_receive( :items ).and_return( [] )

      subject.onload.should include(:items)
    end
  end

  describe '.user_recent_media' do
    it 'should configure the search query' do
      subject.class.user_recent_media 123, count: 4

      subject.class.query.should eq [ :user_recent_media, [123, { count: 4 }] ]
    end
  end

  describe '.items' do
    let(:program) { MyProgram.new }
    let(:result) { double('result').as_null_object }

    before do
      Instagram::Client.any_instance.stub( :user_recent_media ).and_return( [ result ] )

      program.class.user_recent_media( 123 )
    end

    subject { program.class.items }

    it 'should search with the client instance' do
      Instagram::Client.any_instance
        .should_receive( :user_recent_media )
        .with( 123 )
        .and_return( [] )

      subject
    end

    it 'should build a collection with a specific format' do
      subject.first.should include(:image_url)
      subject.first.should include(:title)
      subject.first.should include(:description)
      subject.first.should include(:photographer)
      subject.first.should include(:location)
    end
  end
end