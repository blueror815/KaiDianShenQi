class RenameCamapignToPromotion < ActiveRecord::Migration
  def change
    rename_table :campaigns, :promotions
  end
end
