

class User < ApplicationRecord
    #Token生成モジュールを追加
    include TokenGenerateService
    #バリデーション前にメールアドレスを小文字にする処理
    before_validation :downcase_email

    #gem bcript
    #password属性が使えて変更時保存時はpassword_digestになる
    #authenticate（）でパスワード変換して正しいパスか判定してくれる
    #入力必須バリデーションチェックが新規の時のみ有効
    has_secure_password

    # #1ユーザーに対して複数のレビュー
    has_many :reviews
    
    #追加
    validates :name, presence: true,
                    length:{maximum:30, allow_blank:true}
    
    validates :email, presence: true, email:true,
                    email:{allow_blank: true}

    # 追加
    #allow_nilでもhas_secure_passwordが必須入力確認してくれるのでnil
    VALID_PASSWORD_REGEX = /\A[\w\-]+\z/
    #\A     ：文字列の先頭にマッチ
    #[\w\-]　：a-z A-Z 0-9 _-
    #+      :  1文字以上繰り返す
    #/z　　　：文字列の末尾にマッチ
    validates :password, presence: true,
                        length: { minimum: 8 },
                        format: {
                        with: VALID_PASSWORD_REGEX,
                        message: :invalid_password,                        
                        },
                        allow_nil: true

        ## methods
    # class method  ###########################
    class << self
        # emailからアクティブなユーザーを返す
        def find_activated(email)
        find_by(email: email, activated: true)
        end
    end
    # class method end #########################

    # 自分以外の同じemailのアクティブなユーザーがいる場合にtrueを返す
    def email_activated?
        #自分以外のUSERを取得
        users = User.where.not(id: id)
        #その中からfind_activateでアクティブなユーザーがいるか確認する
        users.find_activated(email).present?
    end

    #リフレッシュトークンのJWT　IDを記憶する
    def remember(jti)
        update!(refresh_jti: jti)
    end

    #リフレッシュトークンのJWT　IDを削除する
    def forget()
        update!(refresh_jti: nil)
    end

    #共通のJsonレスポンス
    def response_json(payload = {})
        as_json(only:[:id, :name]).merge(payload).with_indifferent_access
      
    end

    private

    # email小文字化
    def downcase_email
        self.email.downcase! if email
    end

end
