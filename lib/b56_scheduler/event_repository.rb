module B56Scheduler
  class EventRepository
    def initialize
      @participants = Hash.new{|hash, key| hash[key] = []}
    end

    def notify(participant_id, event_name, created_at = Time.now)
      event = Event.new
      event.name = event_name
      event.created_at = created_at
      @participants[participant_id] << event
    end

    def search(query)
      resolver = B56Scheduler::QueryResolver.new(query.criteria)
      @participants.select do |participant, events|
        resolver.match?(events)
      end.map{|array| array[0]}
    end
  end
end
