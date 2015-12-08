class AddPointsValueToProducts < ActiveRecord::Migration
  def change
    add_column :products, :point_value, :decimal, default: 0.0
  end
end
