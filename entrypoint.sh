#!/bin/bash
set -e
# サーバープロセスが存在しないことを確認してから削除
rm -f /app/tmp/pids/server.pid
# WARNING:createとseedはfargateの初回のみ実行

#20240421 PSG→MYSQLに変更したのでcastなどのmigrateファイルが一部通らない
#bundle exec rails db:create
#bundle exec rails db:migrate
#undle exec rails db:seed

#megrateせずsceamaの読み込みとSeedだけ行う
#bundle exec rails db:setup
#ActiveRecord::NoEnvironmentInSchemaError: がでる

#命令通り、Tasks: TOP => db:setup => db:schema:load => db:check_protected_environmentsを実行 
bundle exec rails db:setup
bundle exec rails db:schema:load
bundle exec rails db:check_protected_environments
#起動
bundle exec pumactl start
echo "Puma started"