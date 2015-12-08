class ChangeCampaingSmsMessageToPromotionSmsMessage < ActiveRecord::Migration
  def change
    rename_table :campaign_sms_messages, :promotion_sms_messages
    rename_column :promotion_sms_messages, :campaign_id, :promotion_id
  end
end
