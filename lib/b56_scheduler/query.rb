module B56Scheduler
  class Query
    def initialize
      @criteria = []
    end

    def includes_event(event, opts = {})
      @criteria << { :includes => event }.merge(opts)
    end

    def excludes_event(event, opts = {})
      @criteria << { :excludes  => event }.merge(opts)
    end

    def match?(events)
      @criteria.all?{|query|
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
