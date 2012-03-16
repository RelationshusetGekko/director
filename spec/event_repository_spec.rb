require 'b56_scheduler/query'
require 'b56_scheduler/event_repository'

describe B56Scheduler::EventRepository do
  let(:repos) { B56Scheduler::EventRepository.new }
  let(:participant_1) { stub('Participant 1') }
  let(:participant_2) { stub('Participant 2') }
  let(:event1) { stub('New event') }
  let(:event2) { stub('Handled event') }
  let(:now) { Time.now }
  let(:yesterday) { now - (24 * 60 * 60) }
  let(:event_yesterday) { stub('Handled event', :created_at => yesterday) }

  context "two participants with event1 where one also has event2" do
    before(:each) do
      repos.notify(participant_1, event1)
      repos.notify(participant_1, event2)
      repos.notify(participant_2, event1)
    end

    it "finds both participants when asked for participants with the event" do
      query = B56Scheduler::Query.new
      query.includes_event(event1)
      repos.search(query).should have(2).items
    end

    it "finds only the participant without event2" do
      query = B56Scheduler::Query.new
      query.includes_event(event1)
      query.excludes_event(event2)
      repos.search(query).should == [participant_2]
    end
  end

  context "one participant with an event and one without" do
    before(:each) do
      repos.notify(participant_1, event2)
      repos.notify(participant_2, event1)
    end
    it "finds only the participant with the event" do
      query = B56Scheduler::Query.new
      query.includes_event(event1)
      repos.search(query).should == [participant_2]
    end
  end

  context "a participant with an event yesterday" do
    before(:each) do
      repos.notify(participant_1, event_yesterday)
    end
    xit "finds the events from yesterday" do
      query = B56Scheduler::Query.new
      query.includes_event(event1, :before => now)
      repos.search(query)
    end
  end
end
