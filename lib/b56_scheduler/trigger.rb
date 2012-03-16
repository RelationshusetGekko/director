module B56Scheduler
  class Trigger
    attr_reader :action
    def initialize(name, on, action)
      @name, @on, @action = name, on, action
    end

    def run(event_repository, handler)
      event_repository.search(:with=>[@on], :without => [triggered_event_name]).each do |participant_id|
        handler.call(participant_id)
        event_repository.notify(participant_id, triggered_event_name)
      end
    end

    def triggered_event_name
      "__handled_#{@name}"
    end
  end
end
