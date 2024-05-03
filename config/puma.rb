# Puma can serve each request in a thread from an internal thread pool.
# The `threads` method setting takes two numbers: a minimum and maximum.
# Any libraries that use thread pools should be configured to match
# the maximum value specified for Puma. Default is set to 5 threads for minimum
# and maximum; this matches the default thread size of Active Record.
#
max_threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
min_threads_count = ENV.fetch("RAILS_MIN_THREADS") { max_threads_count }
threads min_threads_count, max_threads_count

# Specifies the `worker_timeout` threshold that Puma will use to wait before
# terminating a worker in development environments.
#
worker_timeout 3600 if ENV.fetch("RAILS_ENV", "development") == "development"


# Specifies the `environment` that Puma will run in.
# Specifies the `port` that Puma will listen on to receive requests; default is 3000.

#追加　本番環境でSokcetを待ち受け状態にする
#https://infltech.com/articles/QkaUwN
if ENV["RAILS_ENV"] == "production" then
    #ルートディレクトリを取得
    app_root = File.expand_path('..', __dir__)
    #待ち受けディレクトリを指定（nginXコンテナ共通ボリューム上）
    bind "unix://#{app_root}/tmp/sockets/puma.sock"
else
    port ENV.fetch("PORT") { 3000 }
    environment ENV.fetch("RAILS_ENV") { "development" }
end
# stdout_redirect "/var/log/puma.stdout.log", "/var/log/puma.stderr.log", true	

#environment ENV.fetch("RAILS_ENV") { "development" }
#追加　pumaで起動したとき標準出力させる
# unless ENV.fetch("RAILS_ENV", "development") == "development"
#     stdout_redirect "#{app_root}/log/puma.stdout.log", "#{app_root}/log/puma.stderr.log", true
# end
# Specifies the `pidfile` that Puma will use.
pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }

# Specifies the number of `workers` to boot in clustered mode.
# Workers are forked web server processes. If using threads and workers together
# the concurrency of the application would be max `threads` * `workers`.
# Workers do not work on JRuby or Windows (both of which do not support
# processes).
#
# workers ENV.fetch("WEB_CONCURRENCY") { 2 }

# Use the `preload_app!` method when specifying a `workers` number.
# This directive tells Puma to first boot the application and load code
# before forking the application. This takes advantage of Copy On Write
# process behavior so workers use less memory.
#
# preload_app!

# Allow puma to be restarted by `bin/rails restart` command.
plugin :tmp_restart
