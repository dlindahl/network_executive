describe NetworkExecutive::Components::TweetPlayer do

  let(:klass) do
    Class.new do
      def name; 'foo'; end
    end.send :include, described_class
  end

  before do
    stub_const 'MyProgram', klass
  end

  subject { MyProgram.new }

  its(:url) { should == '/twitter?program=foo' }

  its(:live_feed) { should be_true }

  describe '#tweets' do
    it 'should delegate to the class' do
      described_class.should_receive :tweets

      described_class.tweets
    end
  end

  describe '#client' do
    it 'should delegate to the class' do
      subject.class.should_receive :client

      subject.client
    end
  end

  describe '.client' do
    it 'should be a Twitter Client' do
      subject.class.client.should be_a Twitter::Client
    end
  end

  describe '.configure' do
    it 'should yield the client' do
      arg = nil

      subject.class.configure { |c| arg = c }

      arg.should eq subject.client
    end
  end

  describe '.search' do
    it 'should configure the search query' do
      subject.class.search 'search term', count: 4

      subject.class.query.should eq [ 'search term', { count: 4 }]
    end
  end

  describe '.tweets' do
    it 'should search with the client instance' do
      subject.class.search 'foo'

      Twitter::Client.any_instance.should_receive( :search ).with 'foo'

      subject.class.tweets
    end
  end
end