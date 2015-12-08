class AddQuantityToPlacements < ActiveRecord::Migration
  def change
    add_column :placements, :quantity, :decimal, default: 0.0
  end
end
