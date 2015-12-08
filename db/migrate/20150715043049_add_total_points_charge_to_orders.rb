class AddTotalPointsChargeToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :total_points_charge, :decimal, :default => 0.0
  end
end
