class AddCryptedPasswordColumnToUser < ActiveRecord::Migration[5.1]
  def change
    change_table :users do |t|
      t.string :salt
      t.string :crypted_password
    end

    remove_column :users, :password_digest
  end
end
