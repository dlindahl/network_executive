describe NetworkExecutive::Network do
  include Goliath::TestHelper

  let(:err) { Proc.new { fail 'API request failed' } }

  it 'should respond to /' do
    FileUtils.mkdir_p 'public'
    File.open('public/index.html', 'w') {|f| f.write('') }

    with_api( described_class ) do
      get_request( { path:'/' }, err ) do |c|
        c.response_header.should include 'CONTENT_TYPE' => 'text/html'
      end
    end
  end

  it 'should respond to /index.html' do
    FileUtils.mkdir_p 'public'
    File.open('public/index.html', 'w') {|f| f.write('') }

    with_api( described_class ) do
      get_request( { path:'/index.html' }, err ) do |c|
        c.response_header.should include 'CONTENT_TYPE' => 'text/html'
      end
    end
  end

  it 'should respond to /stylesheets/test.css' do
    FileUtils.mkdir_p 'public/stylesheets'
    File.open('public/stylesheets/test.css', 'w') {|f| f.write('') }    

    with_api( described_class ) do
      get_request( { path:'/stylesheets/test.css' }, err ) do |c|
        c.response_header.should include 'CONTENT_TYPE' => 'text/css'
      end
    end
  end

  it 'should respond to /javascripts/test.js' do
    FileUtils.mkdir_p 'public/javascripts'
    File.open('public/javascripts/test.js', 'w') {|f| f.write('') }    

    with_api( described_class ) do
      get_request( { path:'/javascripts/test.js' }, err ) do |c|
        c.response_header.should include 'CONTENT_TYPE' => 'application/javascript'
      end
    end
  end

  it 'should respond to /tune_in/[CHANNEL_NAME]' do
    NetworkExecutive::Viewer.stub(:change_channel).and_return [200,nil,nil]
    NetworkExecutive::Viewer.should_receive( :change_channel ).with 'foo', anything()

    with_api( described_class ) do
      get_request( { path:'/tune_in/foo' }, err )
    end
  end

  describe '.tune_in_to' do
    it 'should subscribe to the channel' do
      channel_double = double('channel')

      described_class.channels.stub(:find).and_return channel_double

      channel_double.should_receive :subscribe

      described_class.tune_in_to 'my_channel', {}
    end
  end

  it 'should respond to /lineup' do
    NetworkExecutive::Lineup.should_receive( :new ).and_return double('lineup').as_null_object

    with_api( described_class ) do
      get_request( { path:'/lineup' }, err ) do |c|
        c.response_header.should include 'CONTENT_TYPE' => 'application/json'
      end
    end
  end
end