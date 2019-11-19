require "kafka"
require 'json'

class Kafkaesque

  def initialize
    @kafka = Kafka.new("172.20.6.172:9092", client_id: "mixologist")
  end

  def process(message, topic)
    producer = @kafka.producer
    producer.produce(message, topic: topic)
    producer.deliver_messages
    producer.shutdown
  end
end
