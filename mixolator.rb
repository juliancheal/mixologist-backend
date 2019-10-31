require_relative 'drink'
require_relative 'pump_manager'

class Mixolator

  def initialize
    drinks_array = Drink.new
    @drinks = drinks_array.drinks
  end

  def menu
    @drinks.each do |drink|
      pp drink.name
    end
  end

  def make_drink(type)
    drink = @drinks.find { |drink| drink.slug.eql?(type) }
    pp "Drink: #{drink.name}"
    pump_manager = PumpManager.new
    pump_manager.make_drink(drink)
  end
end
