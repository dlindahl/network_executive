require 'ostruct'

describe NetworkExecutive::ScheduledProgram do

  it { should respond_to(:program) }
  it { should respond_to(:occurrence) }
  it { should respond_to(:remainder) }
  it { should respond_to(:portion) }

  describe '#display_name' do
    let(:program) { double('program', display_name:'foo') }

    subject { described_class.new(program).display_name }

    it { should == 'foo' }
  end

  describe '#+' do
    context 'with a mismatched program' do
      it 'should raise an ArgumentError' do
        expect { subject + double('program') }.to raise_error ArgumentError
      end
    end

    context 'with the same program type' do
      let(:end_time)   { Time.now }
      let(:program_a)  { OpenStruct.new( duration:59.seconds ) }
      let(:occurrence) { OpenStruct.new( duration:59.seconds, end_time:end_time ) }
      let(:program_b)  { OpenStruct.new( duration:59.seconds ) }

      subject do
        described_class.new( program_a, occurrence ) + program_b
      end

      before do
        program_a.stub(:occurrence).and_return double('occurrence').as_null_object
      end

      it 'should extend its duration with that of the other program' do
        subject.program.duration.should == 119.seconds
      end

      it 'should extend its occurrences duration with that of the other program' do
        subject.occurrence.duration.should == 119.seconds
      end

      it 'should extend its occurrences end time with that of the other program' do
        subject.occurrence.end_time.should == end_time + 1.minute
      end

      it 'should return itself' do
        subject.should be_a NetworkExecutive::ScheduledProgram
      end
    end
  end

end