describe NetworkExecutive::TimeCalculations do

  before do
    Timecop.freeze Time.current.change( changes )
  end

  describe '#floor' do
    context 'with a 15-minute interval' do
      let(:interval) { 15.minutes }

      context 'and a time below a breakpoint' do
        let(:changes) { { min:13, sec:9 } }

        it 'should round the given time to the nearest interval' do
          Time.current.floor( interval ).should == Time.current.change(min:0, sec:0)
        end
      end

      context 'and a time above a breakpoint' do
        let(:changes) { { min:16, sec:9 } }

        it 'should round the given time to the nearest interval' do
          Time.current.floor( interval ).should == Time.current.change(min:15, sec:0)
        end
      end
    end

    context 'with a 30-minute interval' do
      let(:interval) { 30.minutes }

      context 'and a time below a breakpoint' do
        let(:changes) { { min:28, sec:9 } }

        it 'should round the given time to the nearest interval' do
          Time.current.floor( interval ).should == Time.current.change(min:0, sec:0)
        end
      end

      context 'and a time above a breakpoint' do
        let(:changes) { { min:33, sec:9 } }

        it 'should round the given time to the nearest interval' do
          Time.current.floor( interval ).should == Time.current.change(min:30, sec:0)
        end
      end
    end
  end

end