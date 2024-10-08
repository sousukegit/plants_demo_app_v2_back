# api/app/controllers/api/v1/auth_token_controller.rb
class Api::V1::AuthTokenController < ApplicationController
  include UserSessionizeService

  # 404エラーが発生した場合にヘッダーのみを返す
  rescue_from UserAuth.not_found_exception_class, with: :not_found
  # refresh_tokenのInvalidJitErrorが発生した場合はカスタムエラーを返す
  rescue_from JWT::InvalidJtiError, with: :invalid_jti

  # userのログイン情報を確認する
  before_action :authenticate, only: [:create]
  # 処理前にsessionを削除する
  before_action :delete_session, only: [:create]
  # session_userを取得、存在しない場合は401を返す
  before_action :sessionize_user, only: [:refresh, :destroy]

  # refreshログイン
  def create
    @user = login_user
    set_refresh_token_to_cookie
    render json: login_response
  end

  # リフレッシュ
  def refresh
    @user = session_user
    set_refresh_token_to_cookie
    render json: login_response
  end

  # ログアウト
  def destroy
    delete_session if session_user.forget
    cookies[session_key].nil? ?
      head(:ok) : response_500("Could not delete session")
  end

  #新規作成時のトークン作成
  #この時点でアクセストークンとリフレッシュトークンを与える

  private

   # params[:email]からアクティブなユーザーを返す
   def login_user
    #||=は変数の値が存在しない（nil）場合値を代入する演算子
     @_login_user ||= User.find_activated(auth_params[:email])
   end

   # ログインユーザーが居ない、もしくはpasswordが一致しない場合404を返す
   # ここのauthenticate(auth_params[:password])はパスワードを変換する処理
   def authenticate
     unless login_user.present? &&
            login_user.authenticate(auth_params[:password])
       raise UserAuth.not_found_exception_class
     end
   end

   # refresh_tokenをcookieにセットする
   def set_refresh_token_to_cookie
     cookies[session_key] = {
       value: refresh_token,
       expires: refresh_token_expiration,
       #本番のみTrue.HTTPSのみ受け入れるか       
       #samesite属性をnoneにしたとき,secure属性をtrueにしないと受け渡しができない　20240304
       #https://qiita.com/nakanishi03/items/dee8ae104635b2d1aff0
       secure: true,
      #  secure: Rails.env.production?,
       #クッキーにアクセスできないようにする
       http_only: true
     }
   end

   # ログイン時のデフォルトレスポンス
   def login_response
     {
       token: access_token,
       expires: access_token_expiration,
       user: @user.response_json(sub: access_token_subject)
     }
   end

   # リフレッシュトークンのインスタンス生成
   def encode_refresh_token
     @_encode_refresh_token ||= @user.encode_refresh_token
   end

   # リフレッシュトークン
   def refresh_token
     encode_refresh_token.token
   end

   # リフレッシュトークンの有効期限
   def refresh_token_expiration
     Time.at(encode_refresh_token.payload[:exp])
   end

   # アクセストークンのインスタンス生成
   def encode_access_token
     @_encode_access_token ||= @user.encode_access_token  
   end

   # アクセストークン
   def access_token
     encode_access_token.token
   end

   # アクセストークンの有効期限
   def access_token_expiration
     encode_access_token.payload[:exp]
   end

   # アクセストークンのsubjectクレーム
   def access_token_subject
     encode_access_token.payload[:sub]
   end

   # 404ヘッダーのみの返却を行う
   # Doc: https://gist.github.com/mlanett/a31c340b132ddefa9cca
   def not_found
     head(:not_found)
   end

   # decode jti != user.refresh_jti のエラー処理
   def invalid_jti
     msg = "Invalid jti for refresh token"
     render status: 401, json: { status: 401, error: msg }
   end

   def auth_params
     puts "Received data: #{params.inspect}"

     params.require(:auth).permit(:email, :password)
   end
end
