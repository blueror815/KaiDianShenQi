class CreateCampaignTags < ActiveRecord::Migration
  def change
    create_table :campaign_tags do |t|
      t.references :campaign, index: true
      t.string :tag

      t.timestamps null: false
    end
    add_foreign_key :campaign_tags, :campaigns
  end
end
