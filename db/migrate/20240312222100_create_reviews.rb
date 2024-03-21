class CreateReviews < ActiveRecord::Migration[7.0]
  def change
    create_table :reviews do |t|
      t.string :place_id, null: false 
      t.string :google_place_id, null: false 
      t.string :comment, null: false 
      t.boolean :price_point, null: false
      t.boolean :mania_point, null: false
      t.boolean :health_point, null: false 
      t.timestamps
    end
  end
end
