#!/bin/bash
set -e
# サーバープロセスが存在しないことを確認してから削除
rm -f /app/tmp/pids/server.pid


#20240421 PSG→MYSQLに変更したのでcastなどのmigrateファイルが一部通らない
#migrationファイルを整理して対応
# WARNING:createとseedはfargateの初回のみ実行
# bundle exec rails db:create
# bundle exec rails db:migrate
# bundle exec rails db:seed

#起動
bundle exec pumactl start
echo "Puma started"