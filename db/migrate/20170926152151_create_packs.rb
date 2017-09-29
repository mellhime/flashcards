class CreatePacks < ActiveRecord::Migration[5.1]
  def change
    create_table :packs do |t|
      t.string :name
      t.integer :user_id, index: true

      t.timestamps
    end

    add_column :users, :current_pack, :integer
  end
end
