class AddRetailerIdToPermission < ActiveRecord::Migration
  def change
    add_column :permissions, :retailer_id, :integer
  end
end
