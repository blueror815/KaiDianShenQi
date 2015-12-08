class AddStatusToAwardPoint < ActiveRecord::Migration
  def change
    add_column :award_points, :status, :string
  end
end
