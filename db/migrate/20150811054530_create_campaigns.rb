class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
      t.references :retailer, index: true
      t.text :offer
      t.text :occation
      t.date :expiry_date

      t.timestamps null: false
    end
    add_foreign_key :campaigns, :retailers
  end
end
