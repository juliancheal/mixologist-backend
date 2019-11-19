require 'thwait'
require 'yaml'

require_relative 'logging'
require_relative 'pump'
require_relative 'util'

class PumpManager

  attr_reader :pumps

  def initialize
    @log = Logging::logger_for(self)
    @pump_manager_config = pump_manager_config
    @pumps = Util::hashes_to_openstruct(@pump_manager_config[:pumps])
    return @pumps
  end

  def pump_manager_config(file = "pumps.yaml")
    config_file = YAML.load_file(file)
    return unless config_file
    Util::symbolise(config_file)
  end

  def make_drink(drink)
    threads = []
    mutex = Mutex.new

    @log.info("Making #{drink.name}")
    threads << Thread.new do
      drink.ingredients.each_pair do |name, pour_duration|
        @log.info("Ingredient name: #{name}")
        mutex.synchronize do
          pump_manager = @pumps.find { |pump| pump.drink.eql?(name.to_s) }

          @log.info("Pouring #{pour_duration}ml from #{pump_manager.name}, containing #{pump_manager.drink}")
          pump = Pump.new
          pump.pour(pump_manager.name, pour_duration)
        end
      end
    end
    ThWait.all_waits(threads)
  end
end
