# frozen_string_literal: true

require 'date'
require 'ruby-kafka'
require './pb/sample_pb'

kafka = Kafka.new(['kafka:9092'], client_id: 'producer1')
topic = 'topic1'

# topic が未作成の時、consumer で subscribe するときにエラーが発生するので、topic を作成しておく。
def create_topic(kafka, topic)
  kafka.create_topic(topic)
  puts 'topic を作成しました'
rescue Kafka::TopicAlreadyExists
  puts 'topic は既に存在しています'
rescue Kafka::ConnectionError
  sleep 1
  retry
end

# 引数を渡さなければ topic を作成し、引数を渡せばその値でメッセージを送信する。
if ARGV.empty?
  create_topic(kafka, topic)
else
  producer = kafka.producer
  message = Sample::TestMessage.new(content: ARGV.first, created_at: Time.now).to_proto # こんな感じのバイナリになる => "\n\x04\x12\v\b\xAD\x82\xF1\x98\x06\x10\xF0\xC0\x83z"
  producer.produce(message, topic: topic)
  producer.deliver_messages
  puts 'メッセージを送信しました'
end
