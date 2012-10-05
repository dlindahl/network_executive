describe NetworkExecutive::Components::PhotoPlayer do

  let(:klass) do
    Class.new.send :include, described_class
  end

  before do
    stub_const 'MyProgram', klass
  end

  subject { MyProgram.new }

  its(:url) { should == '/slideshow' }
  its(:refresh) { should be_false }
  its(:onload) { should include(photos:[]) }
  its(:photos) { should be_empty }

  describe '#feed_url' do
    it 'should raise' do
      expect { subject.feed_url }.to raise_error NotImplementedError
    end
  end

  describe '#feed' do
    let(:request)  { double('request').as_null_object }
    let(:response) { double('response', body:'{}') }

    before do
      Net::HTTP::Get.stub(:new).and_return request
      Net::HTTP.any_instance.stub(:request).and_return response
    end

    context 'with a HTTP feed URL' do
      before do
        subject.class.send(:define_method, :feed_url) do
          'http://example.org'
        end
      end

      it 'should not use SSL' do
        Net::HTTP.any_instance.should_receive(:use_ssl=).with( true ).never

        subject.feed
      end

      it 'should parse JSON' do
        subject.feed.should == {}
      end
    end

    context 'with a HTTPS feed URL' do
      before do
        subject.class.send(:define_method, :feed_url) do
          'https://example.org'
        end
      end

      it 'should use SSL' do
        Net::HTTP.any_instance.should_receive(:use_ssl=).with true

        subject.feed
      end

      it 'should not verify the certificate' do
        Net::HTTP.any_instance.should_receive(:verify_mode=).with 0

        subject.feed
      end

      it 'should parse JSON' do
        subject.feed.should == {}
      end
    end
  end

end