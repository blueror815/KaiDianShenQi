class CreateRevenueStats < ActiveRecord::Migration
  def change
    create_table :revenue_stats do |t|
      t.references :retailer, index: true
      t.float :new_user_revenue
      t.float :regular_user_revenue
      t.float :vip_user_revenue

      t.timestamps null: false
    end
    add_foreign_key :revenue_stats, :retailers
  end
end
