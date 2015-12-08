class AddRetailerIdToProducts < ActiveRecord::Migration
  def change
    add_column :products, :retailer_id, :integer
    add_index :products, :retailer_id
  end
end
