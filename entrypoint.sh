#!/bin/bash
set -e
# サーバープロセスが存在しないことを確認してから削除
rm -f /app/tmp/pids/server.pid
bundle exec pumactl start
echo "Puma started"