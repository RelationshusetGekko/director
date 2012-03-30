require 'yaml'

module B56Scheduler
  class ConfigLoader
    def self.load_schedule(schedule, filename)
      new(schedule).load_config(YAML::load_file(filename))
    end

    def initialize(schedule)
      @schedule = schedule
    end

    def load_config(config)
      config['triggers'].each do |name, trigger_config|
        if trigger_config['offset']
          trigger_config['offset'] = parse_time(trigger_config['offset'])
        end
        @schedule.add_trigger(name, trigger_config)
      end
    end

    def parse_time(time_string)
      md = time_string.match(/([0-9]+)\s+([a-z]+)/)
      count = md[1]
      unit = md[2]
      unit_to_i(unit) * count.to_i
    end

    def unit_to_i(unit)
    case unit
    when /month/
      30 * 24 * 60 * 60
    when /day/
      24 * 60 * 60
    when /hour/
      60 * 60
    when /minute/
      60
    end
    end
  end
end
