module B56Scheduler
  class ConfigLoader
    def self.load_config(schedule, filename)
    end

    def initialize(schedule)
      @schedule = schedule
    end

    def load_config(config)
      config['triggers'].each do |name, trigger_config|
        @schedule.add_trigger(name, trigger_config)
      end
    end
  end
end
