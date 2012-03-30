module B56Scheduler
  class Query
    def initialize
      @criteria = []
    end

    def includes_event(event, opts = {})
      @criteria << { :name => event, :includes => true }.merge(opts)
    end

    def excludes_event(event, opts = {})
      @criteria << { :name => event, :excludes => true }.merge(opts)
    end

    def match?(events)
      @criteria.all?{|criterion| passes?(events, criterion) }
    end

    private

    def passes?(events, criterion)
      result = !find_event(events, criterion).nil? if(criterion[:includes])
      result = find_event(events, criterion).nil? if(criterion[:excludes])
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
