# frozen_string_literal: true

require 'date'
require 'ruby-kafka'
require './pb/sample_pb'

kafka = Kafka.new(['kafka:9092'], client_id: 'producer1')
topic = 'topic1'

# topic の作成
def create_topic(kafka, topic)
  kafka.create_topic(topic)
  puts 'topic を作成しました'
rescue Kafka::TopicAlreadyExists
  puts 'topic は既に存在しています'
rescue Kafka::ConnectionError
  sleep 1
  retry
end

# topic にメッセージを送る
def send_message(kafka, topic)
  producer = kafka.producer

  # こんな感じのバイナリになる => "\n\x04\x12\v\b\xAD\x82\xF1\x98\x06\x10\xF0\xC0\x83z"
  message = Sample::TestMessage.new(content: ARGV.first, created_at: Time.now).to_proto

  producer.produce(message, topic: topic)
  producer.deliver_messages
  puts 'メッセージを送信しました'
end

# 引数を渡さなければ topic を作成し、引数を渡せばその値でメッセージを送信する。
if ARGV.empty?
  create_topic(kafka, topic)
else
  send_message(kafka, topic)
end
