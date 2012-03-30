module B56Scheduler
  class Query
    attr_reader :criteria
    def initialize
      @criteria = []
    end

    def includes_event(event, opts = {})
      @criteria << { :name => event, :includes => true }.merge(opts)
    end

    def excludes_event(event, opts = {})
      @criteria << { :name => event, :excludes => true }.merge(opts)
    end
  end
end
