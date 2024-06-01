class CreatePlacePlants < ActiveRecord::Migration[7.0]
  def change
    create_table :place_plants do |t|
      t.references :place, null: false, foreign_key: true
      t.references :plant, null: false, foreign_key: true
      t.timestamps
    end
  end
end
