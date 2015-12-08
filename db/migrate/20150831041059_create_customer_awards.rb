class CreateCustomerAwards < ActiveRecord::Migration
  def change
    create_table :customer_awards do |t|
      t.integer :award_point_id
      t.string :phone_number
      t.string :open_id

      t.timestamps null: false
    end
  end
end
