require "ostruct"
require 'pp'
require 'yaml'

require_relative 'pump'

class PumpManager

  attr_reader :pumps

  def initialize
    @pump_manager_config = pump_manager_config
    @pumps = hashes_to_openstruct(@pump_manager_config[:pumps])
    return @pumps
  end

  def pump_manager_config(file = "pumps.yaml")
    config_file = YAML.load_file(file)
    return unless config_file
    symbolise(config_file)
  end

  def make_drink(drink)
    pp "Making #{drink.name}"

    drink.ingredients.each_pair do |name, pour_duration|
      pp "Ingredient name: #{name}"
      pump_manager = @pumps.find { |pump| pump.drink.eql?(name.to_s) }

      pp "Pouring #{pour_duration}ml from #{pump_manager.name}, containing #{pump_manager.drink}"
      pump = Pump.new
      pump.pour(pump_manager.name, pour_duration)
    end
  end

  private

  # code from https://www.dribin.org/dave/blog/archives/2006/11/17/hashes_to_ostruct/
  def hashes_to_openstruct(object)
    return case object
    when Hash
      object = object.clone
      object.each do |key, value|
        object[key] = hashes_to_openstruct(value)
      end
      OpenStruct.new(object)
    when Array
      object = object.clone
      object.map! { |i| hashes_to_openstruct(i) }
    else
      object
    end
  end

  # code from https://gist.github.com/Integralist/9503099
  def symbolise(obj)
    if obj.is_a? Hash
      return obj.inject({}) do |hash, (k, v)|
        hash.tap { |h| h[k.to_sym] = symbolise(v) }
      end
    elsif obj.is_a? Array
      return obj.map { |hash| symbolise(hash) }
    end
    obj
  end
end