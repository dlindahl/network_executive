describe NetworkExecutive::Viewer do
  let(:env) { {} }

  let(:viewer) { described_class.new( env ) }

  subject { viewer }

  describe '#ip' do
    subject { viewer.ip }

    context 'with a valid HTTP_X_FORWARDED_FOR header' do
      before do
        env['HTTP_X_FORWARDED_FOR'] = '255.255.255.255'
      end

      it { should == '255.255.255.255' }
    end

    context 'with an invalid HTTP_X_FORWARDED_FOR header' do
      before do
        env['HTTP_X_FORWARDED_FOR'] = ''
        env['REMOTE_ADDR'] = '10.0.0.1'
      end

      it { should == '10.0.0.1' }
    end

    context 'with a REMOTE_ADDR header' do
      before do
        env['REMOTE_ADDR'] = '255.255.255.255'
      end

      it { should == '255.255.255.255' }
    end
  end

  describe '#channel' do
    subject { viewer.channel }

    before do
      described_class.any_instance.stub( :channel_name ).and_return 'test'
    end

    context 'with a known channel' do
      it 'should find the channel' do
        NetworkExecutive::Channel.should_receive( :find_by_name ).with( 'test' ).and_return true

        subject
      end
    end

    context 'with an unknown channel' do
      it 'should raise an exception' do
        NetworkExecutive::Channel.stub(:find_by_name).and_return nil

        expect{ viewer.channel }.to raise_error NetworkExecutive::ChannelNotFoundError
      end
    end
  end

  describe '#stream' do
    subject { viewer.stream }

    it 'should be an EventSource' do
      Faye::EventSource.should_receive( :new )

      subject
    end
  end

  describe '#tune_in' do
    let(:channel) { double('channel', subscribe:true, play_whats_on:true) }
    let(:stream)  { double('stream').as_null_object }

    before do
      described_class.any_instance.stub( :ip )
      described_class.any_instance.stub( :stream ).and_return stream
      described_class.any_instance.stub( :channel ).and_return channel
    end

    subject { viewer.tune_in }

    it 'should subscribe to the channel' do
      channel.should_receive( :subscribe )

      subject
    end

    it 'should register an onclose handler' do
      subject

      stream.onclose.should_not be_nil
    end

    it 'should immediately play whatever is currently scheduled' do
      channel.should_receive( :play_whats_on ).and_yield( {} )

      stream.should_receive( :send ).with kind_of(Hash)

      subject
    end
  end

  describe '#tune_out' do
    let(:channel) { double('channel').as_null_object }
    let(:beat)    { double('heartbeat').as_null_object }
    let(:id)      { 1 }

    before do
      described_class.any_instance.stub( :id ).and_return id
      described_class.any_instance.stub( :channel ).and_return channel
      described_class.any_instance.stub( :heartbeat ).and_return beat
    end

    subject { viewer.tune_out( nil ) }

    it 'should unsubscribe from the channel' do
      channel.should_receive( :unsubscribe ).with id

      subject
    end

    it 'should cancel the heartbeat' do
      beat.should_receive :cancel

      subject
    end

    it 'should nullify the stream' do
      subject

      viewer.instance_variable_get('@stream').should be_nil
    end
  end

  describe '#response' do
    let(:stream) { double('stream') }

    subject { viewer.response }

    before do
      described_class.any_instance.stub(:stream).and_return stream
    end

    it 'should return a response for Rack' do
      stream.should_receive :rack_response

      subject
    end
  end

  describe '#channel_name' do
    before do
      env['PATH_INFO'] = '/foo/bar/baz'
    end

    subject { viewer.channel_name }

    it { should == 'baz' }
  end

  describe '#keep_alive!' do
    let(:stream) { double('stream') }

    subject { viewer.keep_alive! }

    before do
      described_class.any_instance.stub :ip
      described_class.any_instance.stub :channel
      described_class.any_instance.stub( :stream ).and_return stream

      EM.stub( :add_periodic_timer ).and_yield
    end

    it 'should send a ping' do
      stream.should_receive :ping

      subject
    end
  end

  describe '.change_channel' do
    subject { described_class.change_channel env }

    before do
      described_class.any_instance.stub :tune_in
      described_class.any_instance.stub :keep_alive!
      described_class.any_instance.stub :response
    end

    it 'should tune in to the channel' do
      viewer = double('viewer').as_null_object

      described_class.should_receive( :new ).with( env ).and_return viewer

      subject
    end

    it 'should tune in to the channel' do
      described_class.any_instance.should_receive :tune_in

      subject
    end

    it 'should keep the connection alive' do
      described_class.any_instance.should_receive :keep_alive!

      subject
    end

    it 'should return a Rack response' do
      described_class.any_instance.should_receive :response

      subject
    end
  end

end