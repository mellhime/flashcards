class AddAvatarColumnsToCard < ActiveRecord::Migration[5.1]
  def change
    change_table :cards do |t|
      t.has_attached_file :image
      t.string :image_url
      t.integer :pack_id, index: true
    end
  end
end
