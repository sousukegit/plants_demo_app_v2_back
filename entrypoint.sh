#!/bin/bash
set -e

rm -f /app/tmp/pids/server.pid

bundle exec pumactl start