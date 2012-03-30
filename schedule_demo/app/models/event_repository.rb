class EventRepository
  class << self
    def notify(participant_id, event_name)
      Event.create(:name => event_name, :participant_id => participant_id)
    end

    def search(criteria)
      hash = participants_hash(criteria)
      participant_ids = hash[:includes]
      participant_ids = participant_ids - hash[:excludes] if hash[:excludes]
      participant_ids
    end

    private

    def participants_hash(criteria)
      criteria.inject({}) do |hash, criterion|
        if criterion[:includes]
          hash = hash.merge(:includes => participants_where(criterion))
        end
        if criterion[:excludes]
          hash = hash.merge(:excludes => participants_where(criterion))
        end
        hash
      end
    end

    def participants_where(criterion)
      participants = Event.select(:participant_id).
        where(:name => criterion[:name])
      if(criterion[:before])
        participants.where('created_at < ?', criterion[:before])
      end
      participants.map(&:participant_id)
    end
  end

end
