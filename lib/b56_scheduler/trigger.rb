module B56Scheduler
  class Trigger
    attr_reader :action
    def initialize(name, opts)
      @name, @on, @action = name, opts[:on].to_s, opts[:action].to_s
      @offset = opts[:offset]
    end

    def run(event_repository, handler)
      event_repository.search(query.criteria).each do |participant_id|
        handler.call(participant_id)
        event_repository.notify(participant_id, triggered_event_name)
      end
    end

    def query
      query = Query.new
      query.includes_event(@on)
      query.excludes_event(triggered_event_name)
      query
    end

    def triggered_event_name
      "__handled_#{@name}"
    end
  end
end
