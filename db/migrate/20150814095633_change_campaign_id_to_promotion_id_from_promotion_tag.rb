class ChangeCampaignIdToPromotionIdFromPromotionTag < ActiveRecord::Migration
  def change
    rename_column :promotion_tags, :campaign_id, :promotion_id
  end
end
