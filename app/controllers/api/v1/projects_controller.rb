class Api::V1::ProjectsController < ApplicationController

 # 下記メソッドを使用してください
  before_action :authenticate_active_user
  # before_action :authenticate_user 削除

  # 2021.12.20追記
  # 「レクチャー70.アクセストークンからcurrent_userを取得しよう」のDLファイル「user_authenticate_service.rb」に、新たにauthenticate_active_userメソッドを追加しました。まだ追加されていない方は下記メソッドを追加してください。

  # api/app/services/user_authenticate_service.rb
  # def authenticate_active_user
  #   (current_user.present? && current_user.activated?) || unauthorized_user
  # end

  def index
    render json: current_user.as_json(only:[:id,:name,:email,:created_at])

  end
end
