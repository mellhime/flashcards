class CreatePacks < ActiveRecord::Migration[5.1]
  def change
    create_table :packs do |t|
      t.boolean :current
      t.string :name
      t.integer :user_id

      t.timestamps
    end
  end
end
