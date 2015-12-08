class AddQuantityToProducts < ActiveRecord::Migration
  def change
    add_column :products, :quantity, :decimal, :default => 0.0
  end
end
