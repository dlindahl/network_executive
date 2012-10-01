describe NetworkExecutive::LineupEntries do

  let(:entries) { described_class.new( 1.5.hours, 15.minutes ) }

  describe '#initialize' do
    context 'with a non-Duration range argument' do
      it 'should raise an ArgumentError' do
        expect { described_class.new( 1.5, 15.minutes ) }.to raise_error ArgumentError
      end
    end

    context 'with a non-Duration interval argument' do
      it 'should raise an ArgumentError' do
        expect { described_class.new( 1.hour, 15 ) }.to raise_error ArgumentError
      end
    end
  end

  describe '#<<' do
    subject { entries.last }

    context 'with an OffAir instance' do
      let(:off_air) do
        double('off_air').tap do |oa|
          oa.stub( :duration ).and_return 15.minutes
          oa.stub( :is_a? ).with( NetworkExecutive::OffAir ).and_return true
        end
      end

      let(:current)  { off_air.clone }
      let(:previous) { off_air.clone }

      context 'and the previous entry was Off Air' do
        before do
          entries << previous << current
        end

        it 'should have a program' do
          subject.should include( program:previous )
        end

        it 'should indicate how many intervals it uses' do
          subject.should include( intervals:2 )
        end

        it 'should indicate what percentage of the total units it uses' do
          subject.should include( percentage_of_total: (2 / 6.0 * 100) )
        end
      end

      context 'and the previous entry was a real program' do
        let(:program) { double('program', duration: 15.minutes) }

        before { entries << program << current }

        it 'should have a program' do
          subject.should include( program: current )
        end

        it 'should indicate how many intervals it uses' do
          subject.should include( intervals:1 )
        end

        it 'should indicate what percentage of the total units it uses' do
          subject.should include( percentage_of_total: (1 / 6.0 * 100) )
        end
      end

      context 'and there was no previous entry' do
        before { entries << current }

        it 'should have a program' do
          subject.should include( program: current )
        end

        it 'should indicate how many intervals it uses' do
          subject.should include( intervals: 1 )
        end

        it 'should indicate what percentage of the total units it uses' do
          subject.should include( percentage_of_total: (1 / 6.0 * 100) )
        end
      end
    end

    context 'with a real program' do
      before { entries << program }

      context 'with a short duration' do
        let(:program) { double('program', duration: 15.minutes) }

        it 'should have a program' do
          subject.should include( program: program )
        end

        it 'should indicate how many intervals it uses' do
          subject.should include( intervals:1 )
        end

        it 'should indicate what percentage of the total units it uses' do
          subject.should include( percentage_of_total: (1 / 6.0 * 100) )
        end
      end

      context 'with a long duration' do
        let(:program) { double('program', duration: 1.hour) }

        it 'should have a program' do
          subject.should include( program:program )
        end

        it 'should indicate how many intervals it uses' do
          subject.should include( intervals:4 )
        end

        it 'should indicate what percentage of the total units it uses' do
          subject.should include( percentage_of_total: (4 / 6.0 * 100) )
        end
      end

      context 'with a longer-than-viewable duration' do
        let(:program) { double('program', duration: 2.hours) }

        it 'should have a program' do
          subject.should include( program:program )
        end

        it 'should indicate how many intervals it uses' do
          subject.should include( intervals:6 )
        end

        it 'should indicate what percentage of the total units it uses' do
          subject.should include( percentage_of_total: (6 / 6.0 * 100) )
        end
      end
    end
  end

  describe '#increment' do
    subject { entries.increment }

    context 'with a sparse collection' do
      before do
        entries << double('program', duration: 30.minutes)
      end

      it { should == 30.minutes }
    end

    context 'with a maxed out collection' do
      before do
        entries << double('program', duration: 3.hours)
      end

      it { should == 1.5.hours }
    end
  end

  describe '#unshift' do
    it 'should raise a NotImplementedError' do
      expect { entries.unshift 'foo' }.to raise_error NotImplementedError
    end
  end

end