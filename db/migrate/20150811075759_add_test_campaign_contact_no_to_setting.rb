class AddTestCampaignContactNoToSetting < ActiveRecord::Migration
  def change
    add_column :settings, :test_campaign_contact_no, :string
  end
end
