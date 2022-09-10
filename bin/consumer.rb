# frozen_string_literal: true

require 'date'
require 'ruby-kafka'
require './pb/sample_pb'

# docker-compose で立ち上げるときは kafka:9092、ローカルで立ち上げるときは localhost:29092 とする
kafka = Kafka.new(['kafka:9092'], client_id: 'consumer1')

trap('TERM') { consumer.stop }

consumer = kafka.consumer(group_id: 'group1')

begin
  # docker-compose.yml で depends_on を指定していても kafka の起動直後、 subscribe が失敗するときがありリトライしている
  consumer.subscribe('topic1')
rescue Kafka::ConnectionError
  sleep 1
  retry
end

consumer.each_message(automatically_mark_as_processed: true) do |message|
  sample_message = Sample::TestMessage.decode(message.value)

  content = sample_message.content
  created_at = Time.at(sample_message.created_at.seconds).strftime('%Y/%m/%d %H:%M')
  puts "メッセージを受信しました => 内容: #{content}, 日時: #{created_at}"
end
