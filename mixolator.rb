require_relative 'bar_manager'
require_relative 'drink'
require_relative 'logging'

require 'json'

class Mixolator
  include Logging

  def initialize
    @log         = Logging::logger_for(self)
    drinks_array = Drink.new
    @drinks      = drinks_array.drinks
  end

  def start
  end

  def menu
    @drinks.each do |drink|
      @log.info(drink.name)
    end
  end

  def make_drink(message)
    payload = JSON.parse(message)
    drink = @drinks.find { |drink| drink.slug.eql?(payload['drink_name']) }

    BarManager.new(drink, payload)
  end
end
