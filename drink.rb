require 'yaml'

require_relative 'util'

class Drink

  attr_reader :drinks

  def initialize
    @drink_config = drink_config
    @drinks = Util::hashes_to_openstruct(@drink_config[:drinks])
    return @drinks
  end

  def drink_config(file = "./drinks.yaml")
    config_file = YAML.load_file(file)
    return unless config_file
    Util::symbolise(config_file)
  end
end
