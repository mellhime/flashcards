class AddCountsOfChecksToCard < ActiveRecord::Migration[5.1]
  def change
    add_column :cards, :check_count, :integer, default: 0
  end
end
