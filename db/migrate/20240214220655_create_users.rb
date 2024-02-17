class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name, null: true
      t.string :email, null: false
      t.string :passwor_digest, null: false
      t.boolean :activated, null: false, default:false
      t.boolean :admin, null: false, default:false
      

      t.timestamps
    end
  end
end
