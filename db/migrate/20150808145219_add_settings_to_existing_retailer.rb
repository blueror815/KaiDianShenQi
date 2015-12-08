class AddSettingsToExistingRetailer < ActiveRecord::Migration
  def change
    Retailer.all.each do |retail|
      Setting.create(retailer_id: retail.id)      
    end
  end
end
