10.times do |n|
    name = "user#{n}"
    email = "#{name}@example.com"
    #ffind_by(email: email, activated: true)を実行
    #find_or_initialize_byメソッド
    #オブジェクトが存在する場合→取得
    #オブジェクトが存在しない→Users.new(email:email,activated:true)
    user = User.find_or_initialize_by(email: email, activated: true)
    
    #new_recordsで戻り値を確認
    if user.new_record?
      user.name = name
      user.password = "password"
      user.save!
    end
  end
  puts ActiveRecord::Base.connection_config
  puts "users1 = #{User.find_by(id: 1)}"
  puts "users = #{User.count}"