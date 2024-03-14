class ChangeColumnNullOnReviews < ActiveRecord::Migration[7.0]
  def change
    change_column_null :reviews, :user_id, false
  end
end
