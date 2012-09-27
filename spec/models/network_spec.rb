describe NetworkExecutive::Network do

  it 'should maintain a collection of channels' do
    described_class.channels.should be_a Array
  end

  it 'should maintain a collection of programs' do
    described_class.programming.should be_a Array
  end

end