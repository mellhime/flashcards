class AddAvatarFromUrlToCards < ActiveRecord::Migration[5.1]
  def change
    add_column :cards, :avatar_from_url, :string
  end
end
