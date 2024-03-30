class AddUserIdRefToReviews < ActiveRecord::Migration[7.0]
  def change
     # 1. 外部キー制約を追加する新しいカラムを作成
     add_column :reviews, :new_user_id, :bigint
     add_index :reviews, :new_user_id
     # 2. 既存のデータを新しいカラムにコピー
     Review.find_each do |review|
       review.update(new_user_id: review.user_id)
     end
     # 3. 既存の user_id カラムを削除
     remove_column :reviews, :user_id
     # 新しいカラムをリネームして外部キー制約を追加
     rename_column :reviews, :new_user_id, :user_id
     add_foreign_key :reviews, :users
  end
end
