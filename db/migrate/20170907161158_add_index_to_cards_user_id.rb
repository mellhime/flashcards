class AddIndexToCardsUserId < ActiveRecord::Migration[5.1]
  def change
    add_index :cards, :user_id
  end
end
