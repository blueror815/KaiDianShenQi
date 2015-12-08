class AddTotalChargeDefaultZeroToOrders < ActiveRecord::Migration
  def change
    change_column :orders, :total_charge, :decimal, default: 0.0
  end
end
