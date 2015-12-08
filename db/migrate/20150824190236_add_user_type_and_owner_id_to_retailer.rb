class AddUserTypeAndOwnerIdToRetailer < ActiveRecord::Migration
  def change
    add_column :retailers, :user_type, :string, default: 'Owner'
    add_column :retailers, :owner_id, :integer
  end
end
