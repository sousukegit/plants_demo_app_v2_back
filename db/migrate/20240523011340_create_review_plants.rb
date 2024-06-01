class CreateReviewPlants < ActiveRecord::Migration[7.0]
  def change
    create_table :review_plants do |t|
      t.references :review, null: false, foreign_key: true
      t.references :plant, null: false, foreign_key: true
      t.timestamps
    end
  end
end
