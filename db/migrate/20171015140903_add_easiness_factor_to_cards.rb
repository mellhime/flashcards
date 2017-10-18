class AddEasinessFactorToCards < ActiveRecord::Migration[5.1]
  def change
    add_column :cards, :easiness_factor, :float, default: 2.5
    add_column :cards, :interval, :integer, default: 0
    rename_column :cards, :check_count, :review_status
  end
end
