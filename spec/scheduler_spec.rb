require 'b56_scheduler'

describe B56Scheduler::Schedule do
  let(:some_event) { stub(:name => 'some_event') }
  let(:some_other_event) { stub(:name => 'some_other_event') }
  context 'with one trigger' do
    let(:handler) { stub }

    before(:each) do
      subject.add_trigger(:now, 'some_event', :some_action)
      subject.add_handler(:some_action, handler)
    end

    it "can execute an action for two participants" do
      handler.should_receive(:call).with(42)
      handler.should_receive(:call).with(43)
      subject.notify(42, some_event)
      subject.notify(43, some_event)
      subject.execute
    end

    it "only executes an action once" do
      handler.should_receive(:call).with(42)
      subject.notify(42, some_event)
      subject.execute
      subject.execute
    end
  end

  context 'with two triggers' do
    let(:handler1) { stub }
    let(:handler2) { stub }

    before(:each) do
      subject.add_trigger(:now,
                          'some_event',
                          :some_action)
      subject.add_handler(:some_action, handler1)
      subject.add_trigger(:again,
                          'some_other_event',
                          :some_other_action)
      subject.add_handler(:some_other_action, handler2)
    end

    it "can execute an action for two participants" do
      handler1.should_receive(:call).with(42)
      handler1.should_receive(:call).with(43)
      subject.notify(42, some_event)
      subject.notify(43, some_event)
      subject.execute
    end

    it "only executes an action once" do
      handler1.should_receive(:call).with(42)
      subject.notify(42, some_event)
      subject.execute
      subject.execute
    end

    it "executes two actions" do
      handler1.should_receive(:call).with(42)
      handler2.should_receive(:call).with(42)
      subject.notify(42, some_event)
      subject.notify(42, some_other_event)
      subject.execute
    end
  end
end
