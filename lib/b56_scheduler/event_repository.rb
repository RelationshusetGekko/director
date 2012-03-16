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

    # def search2(query)
    #   with_events = query.included_events
    #   participants_for_events = with_events.map{ |with_event|
    #     @events[with_event]
    #   }

    #   without_events = query.excluded_events
    #   participants_excluded = without_events.map{ |without_event|
    #     @events[without_event]
    #   }

    #   excluded = participants_excluded.inject{ |excluded_participants, excluded_participants_for_event|
    #     excluded_participants & excluded_participants_for_event
    #   } || []

    #   participants_for_events.inject{ |selected_participants, participants_for_event|
    #     selected_participants & participants_for_event
    #   } - excluded
    # end
  end
end
