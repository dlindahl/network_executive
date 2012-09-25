describe NetworkExecutive do
  it { should be_a Module }

  its(:config) { should be_a NetworkExecutive::Configuration }

  describe '.configure' do
    it 'should yield the config Hash' do
      config = nil

      described_class.configure { |c| config = c }

      config.should eq described_class.config      
    end
  end
end
