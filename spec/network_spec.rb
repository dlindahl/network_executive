describe NetworkExecutive::Network do
  include Goliath::TestHelper

  let(:err) { Proc.new { fail 'API request failed' } }

  before do
    FileUtils.mkdir_p 'public'
    File.open('public/index.html', 'w') {|f| f.write('') }

    FileUtils.mkdir_p 'public/stylesheets'
    File.open('public/test.css', 'w') {|f| f.write('') }    
  end

  it 'should respond to /' do
    with_api( described_class ) do
      get_request( { path:'/' }, err ) do |c|
        c.response_header.should include 'CONTENT_TYPE' => 'text/html'
      end
    end
  end

  it 'should respond to /index.html' do
    with_api( described_class ) do
      get_request( { path:'/index.html' }, err ) do |c|
        c.response_header.should include 'CONTENT_TYPE' => 'text/html'
      end
    end
  end

  it 'should respond to /stylesheets/test.css' do
    with_api( described_class ) do
      get_request( { path:'/stylesheets/test.css' }, err ) do |c|
        c.response_header.should include 'CONTENT_TYPE' => 'text/plain'
      end
    end
  end

  it 'should respond to /tune_in' do
    with_api( described_class ) do
      get_request( { path:'/tune_in' }, err ) do |c|
        c.response_header.should include 'CONTENT_TYPE' => 'text/event-stream'
      end
    end
  end
end