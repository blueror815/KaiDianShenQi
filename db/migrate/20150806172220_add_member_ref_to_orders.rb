class AddMemberRefToOrders < ActiveRecord::Migration
  def change
    add_reference :orders, :member, index: true
    add_foreign_key :orders, :members
  end
end
