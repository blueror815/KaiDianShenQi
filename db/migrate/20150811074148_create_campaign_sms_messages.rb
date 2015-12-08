class CreateCampaignSmsMessages < ActiveRecord::Migration
  def change
    create_table :campaign_sms_messages do |t|
      t.references :campaign, index: true
      t.references :membership, index: true
      t.text :message

      t.timestamps null: false
    end
    add_foreign_key :campaign_sms_messages, :campaigns
    add_foreign_key :campaign_sms_messages, :memberships
  end
end
