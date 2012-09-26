describe NetworkExecutive::ProgramSchedule do

  describe 'without a program name' do
    it 'should raise a ProgramNameError' do
      expect{ described_class.new(:day) }.to raise_error NetworkExecutive::ProgramNameError
    end
  end

  describe 'a 24-7 program' do
    subject { described_class.new(:day, play:'my_show') }

    its(:commercials?) { should be_true }

    it 'should run at the beginning of the day' do
      Timecop.freeze Time.now.beginning_of_day

      subject.should include Time.now
    end

    it 'should run at the middle of the day' do
      Timecop.freeze Time.now.change hours:12

      subject.should include Time.now
    end

    it 'should run at the end of the day' do
      Timecop.freeze Time.now.end_of_day

      subject.should include Time.now
    end
  end

  describe 'a weekly, 24-hour program' do
    subject { described_class.new(:thursday, play:'my_show') }

    it 'should run at the beginning of Thursday' do
      Timecop.freeze Time.now.beginning_of_week + 3.days

      subject.should include Time.now
    end

    it 'should run at the middle of Thursday' do
      Timecop.freeze( (Time.now.beginning_of_week + 3.days).change hour:12 )

      subject.should include Time.now
    end

    it 'should run at the end of Thursday' do
      Timecop.freeze Time.now.end_of_week - 3.days

      subject.should include Time.now
    end

    it 'should not run on Monday' do
      Timecop.freeze Time.now.beginning_of_week

      subject.should_not include Time.now
    end
  end

  describe 'a show between 11am and 1pm' do
    describe 'continuously' do
      subject { described_class.new(:day, play:'my_show', between:'11am and 1pm') }

      it 'should run at 11am' do
        Timecop.freeze Time.now.change hour:11, min:0, sec:0

        subject.should include Time.now
      end

      it 'should run at 12pm' do
        Timecop.freeze Time.now.change hour:12

        subject.should include Time.now
      end

      it 'should run at 12:59:59pm' do
        Timecop.freeze Time.now.change hour:12, min:59, sec:59

        subject.should include Time.now
      end

      it 'should not run at 1pm' do
        Timecop.freeze Time.now.change hour:13

        subject.should_not include Time.now
      end

      it 'should not run before 11am' do
        Timecop.freeze Time.now.change hour:10, min:59, sec:59

        subject.should_not include Time.now
      end

      it 'should not run after 1pm' do
        Timecop.freeze Time.now.change hour:13, min:0, sec:1

        subject.should_not include Time.now
      end
    end

    describe 'for the first 20mins of each hour' do
      subject { described_class.new(:day, play:'my_show', between:'11am and 1pm', for_the_first: '20mins', of:'each hour') }

      it 'should run at 11am' do
        Timecop.freeze Time.now.change hour:11, min:0, sec:0

        subject.should include Time.now
      end

      it 'should run at 11:19:59am' do
        Timecop.freeze Time.now.change hour:11, min:19, sec:59

        subject.should include Time.now
      end

      it 'should not run at 11:20pm' do
        Timecop.freeze Time.now.change hour:11, min:20, sec:0

        subject.should_not include Time.now
      end

      it 'should run at 12pm' do
        Timecop.freeze Time.now.change hour:12, min:0, sec:0

        subject.should include Time.now
      end

      it 'should run at 12:19:59am' do
        Timecop.freeze Time.now.change hour:12, min:19, sec:59

        subject.should include Time.now
      end

      it 'should not run at 12:20pm' do
        Timecop.freeze Time.now.change hour:12, min:20, sec:0

        subject.should_not include Time.now
      end
    end

    describe 'the last 20mins of each hour' do
      subject { described_class.new(:day, play:'my_show', between:'11am and 1pm', for_the_last: '20mins', of:'each hour') }

      it 'should not run at 11am' do
        Timecop.freeze Time.now.change hour:11, min:0, sec:0

        subject.should_not include Time.now
      end

      it 'should run at 11:40am' do
        Timecop.freeze Time.now.change hour:11, min:40, sec:0

        subject.should include Time.now
      end

      it 'should run at 11:59:59am' do
        Timecop.freeze Time.now.change hour:11, min:59, sec:59

        subject.should include Time.now
      end

      it 'should not run at 12pm' do
        Timecop.freeze Time.now.change hour:12, min:0, sec:0

        subject.should_not include Time.now
      end

      it 'should run at 12:40pm' do
        Timecop.freeze Time.now.change hour:12, min:40, sec:0

        subject.should include Time.now
      end

      it 'should not run at 12:59:59pm' do
        Timecop.freeze Time.now.change hour:12, min:59, sec:59

        subject.should include Time.now
      end

      it 'should not run at 1pm' do
        Timecop.freeze Time.now.change hour:13, min:0, sec:0

        subject.should_not include Time.now
      end
    end
  end

  describe 'a show that runs for' do
    describe 'the first' do
      describe '15mins' do
        describe 'of each hour' do
          describe 'continuously' do
            subject { described_class.new(:day, play:'my_show', for_the_first:'15mins', of:'each hour') }

            it 'should not run at 12:59:59am' do
              Timecop.freeze Time.now.change hour:12, min:59, sec:59

              subject.should_not include Time.now
            end

            it 'should run at 1:00am' do
              Timecop.freeze Time.now.change hour:1, min:0, sec:0

              subject.should include Time.now
            end

            it 'should run at 1:14:59am' do
              Timecop.freeze Time.now.change hour:1, min:14, sec:59

              subject.should include Time.now
            end

            it 'should not run at 1:15am' do
              Timecop.freeze Time.now.change hour:1, min:15, sec:0

              subject.should_not include Time.now
            end
          end

          describe 'starting at 2pm' do
            subject { described_class.new(:day, play:'my_show', for_the_first:'15mins', of:'each hour', starting_at:'2pm') }

            it 'should not run at 1pm' do
              Timecop.freeze Time.now.change hour:13, min:0, sec:0

              subject.should_not include Time.now
            end

            it 'should run at 2pm' do
              Timecop.freeze Time.now.change hour:14, min:0, sec:0

              subject.should include Time.now
            end

            it 'should run at 2:14:59pm' do
              Timecop.freeze Time.now.change hour:14, min:14, sec:59

              subject.should include Time.now
            end

            it 'should not run at 2:15pm' do
              Timecop.freeze Time.now.change hour:14, min:15, sec:0

              subject.should_not include Time.now
            end

            it 'should not run at 10:59:59pm' do
              Timecop.freeze Time.now.change hour:22, min:59, sec:59

              subject.should_not include Time.now
            end

            it 'should run at 11pm' do
              Timecop.freeze Time.now.change hour:23, min:0, sec:0

              subject.should include Time.now
            end

            it 'should not run at 11:15pm' do
              Timecop.freeze Time.now.change hour:23, min:15, sec:0

              subject.should_not include Time.now
            end
          end

          describe 'ending at 2pm' do
            subject { described_class.new(:day, play:'my_show', for_the_first:'15mins', of:'each hour', ending_at:'2pm') }

            it 'should run at 12am' do
              Timecop.freeze Time.now.change hour:0, min:0, sec:0

              subject.should include Time.now
            end

            it 'should run at 12:14:59am' do
              Timecop.freeze Time.now.change hour:0, min:14, sec:59

              subject.should include Time.now
            end

            it 'should not run at 12:15am' do
              Timecop.freeze Time.now.change hour:0, min:15, sec:0

              subject.should_not include Time.now
            end

            it 'should run at 1am' do
              Timecop.freeze Time.now.change hour:1, min:0, sec:0

              subject.should include Time.now
            end

            it 'should not run at 2pm' do
              Timecop.freeze Time.now.change hour:14, min:0, sec:0

              subject.should_not include Time.now
            end
          end
        end

        describe 'of every hour' do
          subject { described_class.new(:day, play:'my_show', for_the_first:'15mins', of:'every hour') }

          it 'should not run at 12:59:59am' do
            Timecop.freeze Time.now.change hour:12, min:59, sec:59

            subject.should_not include Time.now
          end

          it 'should run at 1:00am' do
            Timecop.freeze Time.now.change hour:1, min:0, sec:0

            subject.should include Time.now
          end

          it 'should run at 1:14:59am' do
            Timecop.freeze Time.now.change hour:1, min:14, sec:59

            subject.should include Time.now
          end

          it 'should not run at 1:15am' do
            Timecop.freeze Time.now.change hour:1, min:15, sec:0

            subject.should_not include Time.now
          end
        end
      end
    end

    describe 'the last' do
      describe '15mins' do
        describe 'of each hour' do
          subject { described_class.new(:day, play:'my_show', for_the_last:'15mins', of:'each hour') }

          it 'should not run at 1:44:59am' do
            Timecop.freeze Time.now.change hour:1, min:44, sec:59

            subject.should_not include Time.now
          end

          it 'should run at 1:45am' do
            Timecop.freeze Time.now.change hour:1, min:45, sec:0

            subject.should include Time.now
          end

          it 'should run at 1:59:59am' do
            Timecop.freeze Time.now.change hour:1, min:59, sec:59

            subject.should include Time.now
          end

          it 'should not run at 2am' do
            Timecop.freeze Time.now.change hour:2, min:0, sec:0

            subject.should_not include Time.now
          end
        end

        describe 'of every hour' do
          subject { described_class.new(:day, play:'my_show', for_the_last:'15mins', of:'every hour') }

          it 'should not run at 1:44:59am' do
            Timecop.freeze Time.now.change hour:1, min:44, sec:59

            subject.should_not include Time.now
          end

          it 'should run at 1:45am' do
            Timecop.freeze Time.now.change hour:1, min:45, sec:0

            subject.should include Time.now
          end

          it 'should run at 1:59:59am' do
            Timecop.freeze Time.now.change hour:1, min:59, sec:59

            subject.should include Time.now
          end

          it 'should not run at 2am' do
            Timecop.freeze Time.now.change hour:2, min:0, sec:0

            subject.should_not include Time.now
          end
        end
      end
    end
  end

  describe 'a commercial-free show' do
    subject { described_class.new(:day, play:'my_show', commercial_free:true) }

    its(:commercials?) { should be_false }
  end

end
