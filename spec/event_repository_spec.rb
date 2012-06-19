require 'director/query'
require 'director/query_resolver'
require 'director/event_repository'

describe Director::EventRepository do
  let(:repos) { Director::EventRepository.new }
  let(:participant_1) { stub('Participant 1') }
  let(:participant_2) { stub('Participant 2') }
  let(:event1) { 'event1' }
  let(:event2) { 'event2' }
  let(:event_yesterday) { 'event_yesterday' }
  let(:now) { Time.now }
  let(:yesterday) { now - (24 * 60 * 60) }
  let(:two_days_ago) { now - (2 * 24 * 60 * 60) }

  context "two participants with event1 where one also has event2" do
    before(:each) do
      repos.notify(participant_1, event1)
      repos.notify(participant_1, event2)
      repos.notify(participant_2, event1)
    end

    it "finds both participants when asked for participants with the event" do
      query = Director::Query.new
      query.includes_event(event1)
      repos.search(query.criteria).should have(2).items
    end

    it "finds only the participant without event2" do
      query = Director::Query.new
      query.includes_event(event1)
      query.excludes_event(event2)
      repos.search(query.criteria).should == [participant_2]
    end
  end

  context "one participant with an event and one without" do
    before(:each) do
      repos.notify(participant_1, event2)
      repos.notify(participant_2, event1)
    end
    it "finds only the participant with the event" do
      query = Director::Query.new
      query.includes_event(event1)
      repos.search(query.criteria).should == [participant_2]
    end
  end

  context "a participant with an event yesterday" do
    before(:each) do
      repos.notify(participant_1, event_yesterday, yesterday)
    end
    it "finds the events from yesterday" do
      query = Director::Query.new
      query.includes_event(event_yesterday, :before => now)
      repos.search(query.criteria).should == [participant_1]
    end
    it "skips the event when asked for 2 days ago" do
      query = Director::Query.new
      query.includes_event(event_yesterday, :before => two_days_ago)
      repos.search(query.criteria).should be_empty
    end
  end
end
