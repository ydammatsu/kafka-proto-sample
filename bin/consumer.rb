# frozen_string_literal: true

require 'date'
require 'ruby-kafka'
require './pb/sample_pb'

kafka = Kafka.new(['kafka:9092'], client_id: 'consumer1')

trap('TERM') { consumer.stop }

consumer = kafka.consumer(group_id: 'group1')

begin
  consumer.subscribe('topic1')
rescue Kafka::ConnectionError
  sleep 1
  retry
end

def serealize_message(message)
  message.value
end

consumer.each_message(automatically_mark_as_processed: true) do |message|
  sample_message = Sample::TestMessage.decode(message.value)

  content = sample_message.content
  created_at = Time.at(sample_message.created_at.seconds).strftime('%Y/%m/%d %H:%M')
  puts "メッセージを受信しました => 内容: #{content}, 日時: #{created_at}"
end
