# frozen_string_literal: true

require 'ruby-kafka'

kafka = Kafka.new(['kafka:9092'], client_id: 'consumer1')

trap('TERM') { consumer.stop }

consumer = kafka.consumer(group_id: 'group1')

begin
  consumer.subscribe('topic1')
rescue Kafka::ConnectionError
  sleep 1
  retry
end

consumer.each_message(automatically_mark_as_processed: true) do |message|
  puts "メッセージを受信しました: #{message.value}"
end
