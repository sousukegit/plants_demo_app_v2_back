class RenamePassworDigestColumnToUsers < ActiveRecord::Migration[7.0]
  def change
    rename_column :users, :passwor_digest, :password_digest
  end
end
