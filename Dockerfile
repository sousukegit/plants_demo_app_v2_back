FROM ruby:3.1.4 AS base

#タイムゾーン設定
ENV TZ=Asia/Tokyo
#作業ディレクトリ
WORKDIR /app

ENV NODE_MAJOR_VERSION = 20

RUN gem update --system && gem install bundler:2.3.26

FROM base AS builder

ARG DEV_PACKAGES="build-essential curl default-mysql-client less libpq-dev locales nginx sudo vim yarn nodejs cron"

RUN set -x && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo 'deb http://dl.yarnpkg.com/debian/ stable main' > /etc/apt/sources.list.d/yarn.list

RUN ln -sf  /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    apt-get update && apt-get upgrade -qq && \
    curl -fsSL https://deb.nodesource.com/setup_$NODE_MAJOR_VERSION.x | bash - && \
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

#初回のみ実行
# RUN mkdir -p tmp/sockets
# RUN mkdir -p tmp/pids

VOLUME /app/public
VOLUME /app/tmp