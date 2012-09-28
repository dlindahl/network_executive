describe NetworkExecutive::OffAirSchedule do
  
  it { should be_a NetworkExecutive::ProgramSchedule }

  its(:program_name) { should == 'off_air' }

end