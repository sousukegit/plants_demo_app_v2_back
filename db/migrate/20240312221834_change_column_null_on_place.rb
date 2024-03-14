class ChangeColumnNullOnPlace < ActiveRecord::Migration[7.0]
  def change
    change_column_null :places, :name, false 
  end
end
