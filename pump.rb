require 'rpi_gpio'
require 'prettyprint'

class Pump

  def initialize
    RPi::GPIO.set_numbering :board
  end

  FLOW_RATE = 60.0/100.0

  def pour(pump_pin, pour_duration)
    pp "Pin #{pump_pin}, durration: #{pour_duration * FLOW_RATE}"
    durration = pour_duration * FLOW_RATE
    RPi::GPIO.setup pump_pin, :as => :output # Sets up pin as output pin
    RPi::GPIO.set_high pump_pin              # Turn on pump
    sleep durration                          # Sleep for duration of pour
    RPi::GPIO.set_low pump_pin               # Turn off pump
    RPi::GPIO.clean_up pump_pin              # realases the pin for the next customer
    pp "Finished pouring #{pump_pin}"
  end
end
