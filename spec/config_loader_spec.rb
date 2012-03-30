require 'b56_scheduler/config_loader'

describe B56Scheduler::ConfigLoader do
  let(:schedule) { stub('Schedule') }

  it "loads a simple config" do
    schedule.should_receive(:add_trigger).with(
      'invitation',
      {
        'event'  => 'participant_join',
        'action' => 'send_invite'
      }
    )
    B56Scheduler::ConfigLoader.load_schedule(schedule, 'spec/fixtures/simple_config.yaml')
  end

  context "with a timed config" do
    before(:each) { schedule.stub(:add_trigger) }

    it "loads the invitation" do
      schedule.should_receive(:add_trigger).with(
        'invitation',
        {
          'event'  => 'participant_join',
          'action' => 'send_invite',
          'offset' => 3600
        }
      )
      B56Scheduler::ConfigLoader.load_schedule(schedule, 'spec/fixtures/timed_config.yaml')
    end

    it "loads the reminder" do
      schedule.should_receive(:add_trigger).with(
        'reminder',
        {
          'event'  => 'participant_join',
          'action' => 'send_invite',
          'offset' => 2 * 24 * 60 * 60
        }
      )
      B56Scheduler::ConfigLoader.load_schedule(schedule, 'spec/fixtures/timed_config.yaml')
    end

    it "loads the final" do
      schedule.should_receive(:add_trigger).with(
        'final',
        {
          'event'  => 'participant_join',
          'action' => 'send_invite',
          'offset' => 2 * 30 * 24 * 60 * 60
        }
      )
      B56Scheduler::ConfigLoader.load_schedule(schedule, 'spec/fixtures/timed_config.yaml')
    end
  end

end
