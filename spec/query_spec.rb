require 'director/query'

describe Director::Query do
  subject { Director::Query.new }
  before(:each) do
    subject.includes_event('event1')
    subject.includes_event('event2')
    subject.excludes_event('event3')
  end
  its(:criteria) { should include({:name => 'event1', :includes => true}) }
  its(:criteria) { should include({:name => 'event2', :includes => true}) }
  its(:criteria) { should include({:name => 'event3', :excludes => true}) }
end
