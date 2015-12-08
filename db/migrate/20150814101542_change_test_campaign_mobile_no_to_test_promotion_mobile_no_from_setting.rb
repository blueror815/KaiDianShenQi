class ChangeTestCampaignMobileNoToTestPromotionMobileNoFromSetting < ActiveRecord::Migration
  def change
    rename_column :settings, :test_campaign_contact_no, :test_promotion_contact_no
  end
end
