class ChangeQuantityToQuantityLeft < ActiveRecord::Migration
  def change
    rename_column :products, :quantity, :quantity_in_stock
  end
end
