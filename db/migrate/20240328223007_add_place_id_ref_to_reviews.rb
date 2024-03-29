class AddPlaceIdRefToReviews < ActiveRecord::Migration[7.0]
  def change
    # add_reference :reviews, :place, foreign_key: true
    # 1. 外部キー制約を追加する新しいカラムを作成
    add_column :reviews, :new_place_id, :bigint
    add_index :reviews, :new_place_id
    # 2. 既存のデータを新しいカラムにコピー
    Review.find_each do |review|
      review.update(new_place_id: review.place_id)
    end
    # 3. 既存の place_id カラムを削除
    remove_column :reviews, :place_id
    # 新しいカラムをリネームして外部キー制約を追加
    rename_column :reviews, :new_place_id, :place_id
    add_foreign_key :reviews, :places
  end
end
