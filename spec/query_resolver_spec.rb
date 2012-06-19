require 'director/query'
require 'director/query_resolver'

describe Director::QueryResolver do
  let(:query) { Director::Query.new }
  let(:query_resolver) { Director::QueryResolver.new(query.criteria) }
  let(:time) { Time.now }
  let(:event1) { stub(:name => 'event1', :created_at => time) }
  let(:event2) { stub(:name => 'event2', :created_at => time) }
  let(:event3) { stub(:name => 'event3', :created_at => time) }

  it "finds an included event" do
    query.includes_event('event1')
    query_resolver.should be_match([event1])
  end

  it "skips an excluded event" do
    query.excludes_event('event1')
    query_resolver.should_not be_match([event1])
  end

  context "a query with two includes" do
    before(:each) do
      query.includes_event('event1')
      query.includes_event('event2')
    end
    it "should match a set of events" do
      query_resolver.should be_match([event1, event3, event2])
    end
    it "does not match when an event is missing" do
      query_resolver.should_not be_match([event1, event3])
    end
  end
  context "a query with an includes with time before now" do
    before(:each) do
      query.includes_event('event1', :before => time - 1)
    end
    it "does not match when an event is missing" do
      query_resolver.should_not be_match([event1])
    end
  end
  context "a query with an includes with time after now" do
    before(:each) do
      query.includes_event('event1', :before => time + 1)
    end
    it "does not match when an event is missing" do
      query_resolver.should be_match([event1])
    end
  end
  context "a query with an include and an exclude" do
    before(:each) do
      query.includes_event('event1')
      query.excludes_event('event2')
    end
    it "matches a set of events" do
      query_resolver.should be_match([event1, event3])
    end
    it "does not match a set of events" do
      query_resolver.should_not be_match([event1, event2, event3])
    end
  end
end

