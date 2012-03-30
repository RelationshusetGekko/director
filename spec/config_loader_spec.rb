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
end
