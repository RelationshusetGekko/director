module B56Scheduler
  class Query
    attr_reader :included_events
    attr_reader :excluded_events

    def initialize
      @included_events = []
      @excluded_events = []
    end

    def includes_event(event, opts = {})
      @included_events << event
    end

    def excludes_event(event, opts = {})
      @excluded_events << event
    end
  end
end
