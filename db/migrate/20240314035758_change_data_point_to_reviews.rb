class ChangeDataPointToReviews < ActiveRecord::Migration[7.0]
  def change
    change_column :reviews, :mania_point, 'integer USING CAST(mania_point AS integer)'
    change_column :reviews, :health_point, 'integer USING CAST(health_point AS integer)'
    change_column :reviews, :price_point, 'integer USING CAST(price_point AS integer)'
  end
end
