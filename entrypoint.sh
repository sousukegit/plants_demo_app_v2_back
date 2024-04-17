#!/bin/bash
set -e
# サーバープロセスが存在しないことを確認してから削除
rm -f /app/tmp/pids/server.pid
# WARNING:createとseedはfargateの初回のみ実行
# WARNING:タスクを個々に作って実行の方がいいかも
bundle exec rails db:create
bundle exec rails db:migrate
bundle exec rails db:seed
#起動
bundle exec pumactl start
echo "Puma started"