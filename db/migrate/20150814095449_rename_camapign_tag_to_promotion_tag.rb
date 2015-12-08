class RenameCamapignTagToPromotionTag < ActiveRecord::Migration
  def change
    rename_table :campaign_tags, :promotion_tags
  end
end
