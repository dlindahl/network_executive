describe NetworkExecutive::Components::FeedPlayer do

  let(:klass) do
    Class.new.send :include, described_class
  end

  before do
    stub_const 'MyProgram', klass
  end

  subject { MyProgram.new }

  its(:refresh) { should be_false }

  describe '#feed_url' do
    it 'should raise' do
      expect { subject.feed_url }.to raise_error NotImplementedError
    end
  end

  describe '#items' do
    it 'should raise' do
      expect { subject.items }.to raise_error NotImplementedError
    end
  end

  describe '#onload' do
    before do
      subject.define_singleton_method(:items) { [] }
    end

    its(:onload) { should include(items:[]) }
  end

  describe '#feed' do
    let(:url) { 'http://example.org/foo/bar?baz=qux' }

    before do
      u = url

      subject.define_singleton_method( :feed_url ) { u }
    end

    it 'should GET the URL' do
      stub_request(:get, url).to_return( status:200, body:{}, headers:{} )

      subject.feed
    end
  end

end