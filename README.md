# kafka-proto-sample
Kafka の Producer と Consumer を Ruby で実装したサンプル<br>
データの送受信には ProtocolBuffers を使用する

## 環境構築
デバッグのために kcat(旧kafkacat) をインストールしておく

```
brew install kcat
```

topic のメッセージを確認する

```
kcat -b localhost:29092 -t topic1
```

proto ファイルからコードを自動生成
```
docker compose run client_base grpc_tools_ruby_protoc -I proto --ruby_out=pb  proto/sample.proto
```