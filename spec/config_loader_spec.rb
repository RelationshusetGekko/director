require 'b56_scheduler/config_loader'

describe B56Scheduler::ConfigLoader do
  let(:schedule) { stub('Schedule') }

  it "loads a simple config" do
    config = YAML::load_file('spec/fixtures/simple_config.yaml')
    schedule.should_receive(:add_trigger).with(
      'invitation',
      {
        'event'  => 'participant_join',
        'action' => 'send_invite'
      }
    )
    B56Scheduler::ConfigLoader.new(schedule).load_config(config)
  end

  context "with a timed config" do
    let(:config) { YAML::load_file('spec/fixtures/timed_config.yaml') }
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
      B56Scheduler::ConfigLoader.new(schedule).load_config(config)
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
      B56Scheduler::ConfigLoader.new(schedule).load_config(config)
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
      B56Scheduler::ConfigLoader.new(schedule).load_config(config)
    end
  end

end
