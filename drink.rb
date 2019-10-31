require "ostruct"
require 'pp'
require 'yaml'

class Drink

  attr_reader :drinks

  def initialize
    @drink_config = drink_config
    @drinks = hashes_to_openstruct(@drink_config[:drinks])
    return @drinks
  end

  def drink_config(file = "drinks.yaml")
    config_file = YAML.load_file(file)
    return unless config_file
    symbolise(config_file)
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
