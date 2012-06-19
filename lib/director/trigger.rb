require 'active_support/core_ext/object'

module Director
  class Trigger
    attr_reader :action
    def initialize(name, opts)
      opts.symbolize_keys!
      @name, @event, @action = name, opts[:event].to_s, opts[:action].to_s
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
      opts = {}
      if @offset
        opts = { :before => Time.now - @offset }
      end
      query.includes_event(@event, opts)
      query.excludes_event(triggered_event_name)
      query
    end

    def triggered_event_name
      "__handled_#{@name}"
    end
  end
end
