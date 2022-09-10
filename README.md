# kafka-proto-sample
Kafka の Producer と Consumer を Ruby で実装したサンプル<br>
データの送受信には ProtocolBuffers を使用する

## 環境構築
デバッグのために kcat(旧kafkacat) をインストールしておく

```
brew install kcat
```

proto ファイルからコードを自動生成
```
docker compose run client_base grpc_tools_ruby_protoc -I proto --ruby_out=pb  proto/sample.proto
```

## 動作確認手順
1. docker compose up -d
   - kafka と zookeeper が立ち上がり、"topic1" という名前の topic が生成される。
2. kcat -b localhost:29092 -t topic1
   - "topic1" という topic が作成されていることを確認する。
3. docker compose run producer bundle exec ruby bin/producer.rb テスト投稿
   - Producer からメッセージを送信する。
4. docker compose run consumer bundle exec ruby bin/consumer.rb
   - topic1 のメッセージがコンシュームされて標準出力されるこ
