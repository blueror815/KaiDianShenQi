class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references :retailer, index: true
      t.decimal :total_charge

      t.timestamps null: false
    end
    add_foreign_key :orders, :retailers
  end
end
