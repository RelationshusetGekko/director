module B56Scheduler
  class Trigger
    attr_reader :action
    def initialize(name, on, action)
      @name, @on, @action = name, on, action
    end

    def run(event_repository, handler)
      event_repository.search(query).each do |participant_id|
        handler.call(participant_id)
        event_repository.notify(participant_id, triggered_event)
      end
    end

    def query
      query = Query.new
      query.includes_event(@on)
      query.excludes_event(triggered_event_name)
      query
    end

    def triggered_event
      event = Event.new
      event.name = triggered_event_name
      event
    end

    def triggered_event_name
      "__handled_#{@name}"
    end
  end
end
