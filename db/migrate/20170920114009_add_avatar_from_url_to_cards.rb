class AddAvatarFromUrlToCards < ActiveRecord::Migration[5.1]
  def change
    add_column :cards, :avatar_remote_url, :string
  end
end
