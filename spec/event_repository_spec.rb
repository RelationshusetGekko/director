require 'b56_scheduler/event_repository'

describe B56Scheduler::EventRepository do
  let(:repos) { B56Scheduler::EventRepository.new }
  let(:participant_1) { stub('Participant 1') }
  let(:participant_2) { stub('Participant 2') }
  let(:event1) { stub('New event') }
  let(:event2) { stub('Handled event') }

  context "two participants with event1 where one also has event2" do
    before(:each) do
      repos.notify(participant_1, event1)
      repos.notify(participant_1, event2)
      repos.notify(participant_2, event1)
    end

    it "finds both participants when asked for participants with the event" do
      repos.search(:with => [event1]).should have(2).items
    end

    it "finds only the participant without event2" do
      repos.search(:with => [event1], :without => [event2]).should == [participant_2]
    end
  end

  context "one participant with an event and one without" do
    before(:each) do
      repos.notify(participant_1, event2)
      repos.notify(participant_2, event1)
    end
    it "finds only the participant with the event" do
      repos.search(:with => [event1]).should == [participant_2]
    end
  end
end
