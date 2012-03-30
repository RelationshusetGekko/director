require 'b56_scheduler/query'

describe B56Scheduler::Query do
  subject { B56Scheduler::Query.new }
  before(:each) do
    subject.includes_event('event1')
    subject.includes_event('event2')
    subject.excludes_event('event3')
  end
  its(:criteria) { should include({:name => 'event1', :includes => true}) }
  its(:criteria) { should include({:name => 'event2', :includes => true}) }
  its(:criteria) { should include({:name => 'event3', :excludes => true}) }
end
