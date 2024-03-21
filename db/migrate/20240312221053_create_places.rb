class CreatePlaces < ActiveRecord::Migration[7.0]
  def change
    create_table :places do |t|
      t.string :name, null: true
      t.string :google_place_id, null: false
      t.timestamps
    end
  end
end
