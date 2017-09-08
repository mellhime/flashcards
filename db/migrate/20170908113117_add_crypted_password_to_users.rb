class AddCryptedPasswordToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :crypted_password, :string
  end
end
