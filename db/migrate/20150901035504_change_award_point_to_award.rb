class ChangeAwardPointToAward < ActiveRecord::Migration
  def change
    add_column :award_points, :retailer_id, :integer
    add_column :award_points, :phone_number, :string
    add_column :award_points, :open_id, :string
    
    rename_table :award_points, :awards
    drop_table :customer_awards
  end
end
