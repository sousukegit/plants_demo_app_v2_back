class EmailValidator < ActiveModel::EachValidator
    def validate_each (record,attribute,value)
        #text length
        max = 255
        #属性、メッセージ、カウント
        record.errors.add(attribute, :too_long, count:max) if value.length > max
        
        # 追加
        # format
        #-~で正規表現に対してnilが帰ってきたらエラー
        format = /\A\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*\z/
        record.errors.add(attribute, :invalid) unless format =~ value

        # 追加
        # uniqueness
        #email_activetedがtrueならすでに登録済みで認証済みのメールアドレスである
        record.errors.add(attribute, :taken) if record.email_activated?
  end

end