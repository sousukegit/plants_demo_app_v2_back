# api/app/services/user_sessionize_service.rb
#リフレッシュトークンを判定
module UserSessionizeService

    # セッションユーザーが居ればtrue、存在しない場合は401を返す
    def sessionize_user
logger.debug "sessionize_user:リロードされてクッキーからユーザーのセッション情報を確認"
      session_user.present? || unauthorized_user
    end
  
    # セッションキー
    def session_key
      UserAuth.session_key
    end
  
    # セッションcookieを削除する
    def delete_session
      cookies.delete(session_key,secure: true)
    end
  
    private
  
      # cookieのtokenを取得
      def token_from_cookies
        cookies[session_key]
        
      end
  
      # refresh_tokenから有効なユーザーを取得する
      def fetch_user_from_refresh_token
        logger.debug "fetch_user_from_refresh_token:refresh_tokenから有効なユーザーを取得"
        User.from_refresh_token(token_from_cookies)
      rescue JWT::InvalidJtiError
        # jtiエラーの場合はcontrollerに処理を委任
        catch_invalid_jti
      rescue UserAuth.not_found_exception_class,
             JWT::DecodeError, JWT::EncodeError
        nil
      end
  
      # refresh_tokenのユーザーを返す
      def session_user
logger.debug "session_user:refresh_tokenのユーザーを返す"
        return nil unless token_from_cookies
        @_session_user ||= fetch_user_from_refresh_token
      end
  
      # jtiエラーの処理
      def catch_invalid_jti
        delete_session
        raise JWT::InvalidJtiError
      end
  
      # 認証エラー
      def unauthorized_user
        delete_session
        head(:unauthorized)
      end
  end
  