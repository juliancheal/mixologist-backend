require_relative 'drink'
require_relative 'kafkaesque'
require_relative 'logging'
require_relative 'pump_manager'

class BarManager

  def initialize(drink, payload)
    @kafkaesque  = Kafkaesque.new
    mixologist = find_mixologist
    if mixologist
      payload['status'] = "allocated"
      @kafkaesque.process(payload.to_json, 'drink-status')

      pump_manager = PumpManager.new
      pump_manager.make_drink(drink)
    end
  end

  def find_mixologist
    # TODO Implement finding a mixologist robot code
    true
  end
end
