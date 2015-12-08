class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.references :retailer, index: true
      t.references :member, index: true
      t.integer :points, default: 0

      t.timestamps null: false
    end
    add_foreign_key :memberships, :retailers
    add_foreign_key :memberships, :members
  end
end
