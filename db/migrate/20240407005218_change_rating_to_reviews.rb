class ChangeRatingToReviews < ActiveRecord::Migration[7.0]
  def change
    change_column :reviews, :rating, :float
    change_column :reviews, :mania_point, :float
    change_column :reviews, :health_point, :float
    change_column :reviews, :price_point, :float
  end
end
