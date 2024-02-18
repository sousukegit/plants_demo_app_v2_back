table_names = %w(
  users
)

table_names.each do |table_name|
  #まず自分の環境名のフォルダを見に行く
  #本番環境ならproduction,テストならTest、開発ならdevelopment
  path = Rails.root.join("db/seeds/#{Rails.env}/#{table_name}.rb")

  # ファイルが存在しない場合はdevelopmentディレクトリを読み込む
  path = path.sub(Rails.env, "development") unless File.exist?(path)

  puts "#{table_name}..."
  require path
end