describe NetworkExecutive::Scheduling do
  before do
    extend NetworkExecutive::Scheduling
  end

  describe '.every' do
    it 'should schedule the program' do
      every :day, play:'my_show'

      schedule.first.should be_a NetworkExecutive::ProgramSchedule
    end
  end

end