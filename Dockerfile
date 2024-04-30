#マルチビルドを使用
#ビルド手順を分けて必要な生成物のみをを使用
FROM ruby:3.1.4 AS base

#本番のみ使用ーーーーーー
#本番に設定
#ENV RAILS_ENV production

#タイムゾーン設定
ENV TZ=Asia/Tokyo
#作業ディレクトリ
WORKDIR /app
#node安定版
ENV NODE_MAJOR_VERSION = 20

RUN gem update --system && gem install bundler:2.3.26

FROM base AS builder

ARG DEV_PACKAGES="build-essential curl default-mysql-client less libpq-dev locales nginx sudo vim cron"

RUN ln -sf  /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    apt-get update && apt-get upgrade -qq && \
    apt-get install -y --no-install-recommends \
    ${DEV_PACKAGES}

FROM builder AS bundle

COPY Gemfile Gemfile.lock ./
RUN bundle install

FROM builder AS main

COPY --from=bundle /usr/local/bundle /usr/local/bundle
COPY . .

#エントリーポイントの実行権限付与
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

#本番のみ使用ーーーーーー
#コンテナ間のUNIXソケット通信を可能にするため、ディレクトリを作成する
RUN mkdir -p tmp/sockets
RUN mkdir -p tmp/pids

#nginxコンテナからRaiilsのSockファイルが見えるようにしす
VOLUME /app/public
VOLUME /app/tmp