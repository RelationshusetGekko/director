module B56Scheduler
  class EventRepository
    def initialize
      @events = Hash.new{|hash, key| hash[key] = []}
      @participants = Hash.new{|hash, key| hash[key] = []}
    end

    def notify(participant_id, event)
      @events[event] << participant_id
      @participants[participant_id] << event
    end

    def search(query)
      @participants.select do |participant, events|
        query.match?(events)
      end.map{|array| array[0]}
    end
  end
end
