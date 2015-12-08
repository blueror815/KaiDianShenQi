class CreatePromotedOrders < ActiveRecord::Migration
  def change
    create_table :promoted_orders do |t|
      t.references :promotion, index: true
      t.references :order, index: true

      t.timestamps null: false
    end
    add_foreign_key :promoted_orders, :promotions
    add_foreign_key :promoted_orders, :orders
  end
end
