class AddAvatarColumnsToCard < ActiveRecord::Migration[5.1]
  def change
    change_table :cards do |t|
      t.has_attached_file :avatar
      add_column :cards, :avatar_remote_url, :string
    end
  end
end
