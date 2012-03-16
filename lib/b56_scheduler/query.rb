module B56Scheduler
  class Query
    attr_reader :included_events
    attr_reader :excluded_events

    def initialize
      @included_events = []
      @excluded_events = []
      @queries = []
    end

    def includes_event(event, opts = {})
      @included_events << event
      @queries << { :includes => event }.merge(opts)
    end

    def excludes_event(event, opts = {})
      @excluded_events << event
      @queries << { :excludes  => event }.merge(opts)
    end

    def match?(events)
      @queries.all?{|query|
        result = true
        if(query[:includes])
          event = events.detect{|event| event.name == query[:includes]}
          if(query[:before])
            result = !event.nil? && event.created_at < query[:before]
          else
            result = !event.nil?
          end
        end
        if(query[:excludes])
          event = events.detect{|event| event.name == query[:excludes]}
          result = event.nil?
        end
        result
      }
    end
  end
end
