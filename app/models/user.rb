class User < ApplicationRecord
    #gem bcript
    #password属性が使えて変更時保存時はpassword_digestになる
    #authenticate（）でパスワード変換して正しいパスか判定してくれる
    #入力必須バリデーションチェックが新規の時のみ有効
    has_secure_password
    
    #追加
    validates :name, presence: true,
                    length:{maximum:30, allow_blank:true}
    
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
    
end
