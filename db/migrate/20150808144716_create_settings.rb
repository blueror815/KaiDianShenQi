class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.references :retailer, index: true
      t.text :welcome_message
      t.integer :no_of_order_to_send_growth_sms
      t.integer :no_of_days_to_send_lapse_message

      t.timestamps null: false
    end
    add_foreign_key :settings, :retailers
  end
end
