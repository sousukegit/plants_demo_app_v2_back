class ChangeDataPlaceIdToReviews < ActiveRecord::Migration[7.0]
  def change
    change_column :reviews, :place_id, 'integer USING CAST(place_id AS integer)'
  end
end
