require "kafka"
require 'logger'

require_relative 'mixolator'

class Consumerism

  def initialize
    kafka      = Kafka.new("goemon.local:9092", client_id: "mixologist")
    @consumer  = kafka.consumer(group_id: 'barmanager')
    @mixolator = Mixolator.new
    @logger    = Logger.new(STDOUT)
    @current_time = Time.now.utc # Lazy hack to ignore old messages
  end

  def consume(topic)
    @consumer.subscribe(topic)
    @consumer.each_message do |message|
      unless message.create_time < @current_time
        @logger.info(message.value)
        @mixolator.make_drink(message.value)
      end
    end
  end

  def shutdown
    @consumer.stop
  end
end

@consumer = Consumerism.new
begin
  @consumer.consume("bar-queue")
rescue SignalException => e
  @consumer.shutdown
  puts "received Exception #{e}"
end
