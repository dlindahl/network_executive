describe NetworkExecutive::OffAir do
  it { should be_a NetworkExecutive::Program }

  its(:display_name) { should == 'Off Air' }

  its(:duration) { should == 15.minutes }

  its(:url) { should == '/programs/off_air' }
end