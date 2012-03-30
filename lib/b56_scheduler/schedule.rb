module B56Scheduler
  class Schedule
    def initialize(event_repository)
      @event_repository = event_repository
      @triggers = []
      @handlers = {}
    end

    def add_trigger(name, on, action)
      @triggers << Trigger.new(name, on.to_s, action.to_s)
    end

    def add_handler(action, handler)
      @handlers[action.to_s] = handler
    end

    def notify(participant_id, event)
      @event_repository.notify(participant_id, event)
    end

    def execute
      @triggers.each do |trigger|
        trigger.run(@event_repository, @handlers[trigger.action])
      end
    end
  end
end
