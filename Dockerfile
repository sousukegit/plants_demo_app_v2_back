
#https://github.com/docker-library/ruby/blob/61a806938da52038916a8fd7b9b4373937bdc28f/3.1/alpine3.19/Dockerfile
FROM ruby:3.1.4-alpine

#DockerFile内で使用する変数
#appが入るARG WORKDIR
ARG WORKDIR
ARG RUNTIME_PACKAGES="nodejs tzdata postgresql-dev postgresql git" 
ARG DEV_PACKAGES="build-base curl-dev"    

#環境変数を定義（コンテナから参照可）
ENV HOME=/${WORKDIR} \
    TZ=Asia/Tokyo

#ベースイメージに対してコマンドを実行する
# ENV test（このRUN命令は確認のためなので無くても良い）
RUN echo ${HOME}

#作業ディレクトリを定義　
#コンテナ/app/rails
WORKDIR ${HOME}

#ホスト先のファイルをコンテナにコピー
#Copy　コピー元（ホスト）コピー先（コンテナ）
#コピー元（ホスト）　DockerFileがありディレクトリ以下を指定　
#コピー先（コンテナ）　今いるカレントディレクトリ（./）WORKDIRで指定したディレクトリのこと
COPY Gemfile* ./

    #apk alpine linuxのcommand
    #apk update パッケージの最新リストを取得
RUN apk update && \
    #インストールされているパッケージを最新のものにする
    apk upgrade && \
    #パッケージのインストールを実行
    #nocacheでキャッシュしない
    apk add --no-cache ${RUNTIME_PACKAGES} && \
    #--virtual　名前　でパッケージをひとまとめにする（仮想パッケージ）
    #DEV_PACKAGESは環境変数で指定したパッケージ
    apk add --virtual build-dependencies --no-cache ${DEV_PACKAGES} && \
    #Gemのインストール　j4はGemの高速化
    bundle install -j4 && \
    #パッケージを削除（bundleインストールが終わったら不要になる）
    apk del build-dependencies

    # api直下のディレクトリを指定してコンテナのカレントディレクトリにコピー
COPY . ./
    #ホストPCのブラウザからコンテナのrailsにアクセスできるようにする
    #-b バインド。外部から参照できるようにする
CMD ["rails", "server", "-b", "0.0.0.0"]