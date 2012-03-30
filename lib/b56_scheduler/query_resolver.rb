module B56Scheduler
  class QueryResolver
    attr_reader :criteria
    def initialize(criteria)
      @criteria = criteria
    end

    def match?(events)
      criteria.all?{|criterion| passes?(events, criterion) }
    end

    def passes?(events, criterion)
      event = find_event(events, criterion)
      result = !event.nil? if(criterion[:includes])
      result = event.nil? if(criterion[:excludes])
      result
    end

    def find_event(events, criterion)
      events.detect do |event|
        if(criterion[:before])
          event.name == criterion[:name] &&
            event.created_at < criterion[:before]
        else
          event.name == criterion[:name]
        end
      end
    end
  end
end
