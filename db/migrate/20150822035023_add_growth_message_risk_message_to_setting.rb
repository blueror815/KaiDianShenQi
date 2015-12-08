class AddGrowthMessageRiskMessageToSetting < ActiveRecord::Migration
  def change
    add_column :settings, :growth_message, :text
    add_column :settings, :risk_message, :text
  end
end
