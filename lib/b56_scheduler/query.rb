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
      @criteria.all?{|criterion|
        result = true
        if(criterion[:includes])
          event = events.detect{|event| event.name == criterion[:includes]}
          if(criterion[:before])
            result = !event.nil? && event.created_at < criterion[:before]
          else
            result = !event.nil?
          end
        end
        if(criterion[:excludes])
          event = events.detect{|event| event.name == criterion[:excludes]}
          result = event.nil?
        end
        result
      }
    end
  end
end
