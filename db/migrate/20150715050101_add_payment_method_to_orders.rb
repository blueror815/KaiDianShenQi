class AddPaymentMethodToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :payment_method, :string, default: "cash"
  end
end
