describe NetworkExecutive::NetworkHelper do
  describe '#network_name' do
    subject { network_name }

    it { should == 'My Network' }
  end
end