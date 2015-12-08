class CreateAddRetailerIdToAwardPoints < ActiveRecord::Migration
  def change
    create_table :add_retailer_id_to_award_points do |t|
      t.integer :retailer_id

      t.timestamps null: false
    end
  end
end
