module B56Scheduler
  class Schedule
    def initialize(event_repository)
      @event_repository = event_repository
      @triggers = []
      @handlers = {}
    end

    def add_trigger(name, opts)
      @triggers << Trigger.new(name, opts)
    end

    def add_handler(action, handler)
      @handlers[action.to_s] = handler
    end

    def notify(participant_id, event_name)
      @event_repository.notify(participant_id, event_name)
    end

    def execute
      @triggers.each do |trigger|
        trigger.run(@event_repository, @handlers[trigger.action])
      end
    end
  end
end
