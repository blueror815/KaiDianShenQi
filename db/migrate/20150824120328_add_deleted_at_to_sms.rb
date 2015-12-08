class AddDeletedAtToSms < ActiveRecord::Migration
  def change
    add_column :sms_first_visits, :deleted_at, :datetime
    add_index :sms_first_visits, :deleted_at

    add_column :sms_growth_visits, :deleted_at, :datetime
    add_index :sms_growth_visits, :deleted_at

    add_column :sms_risk_notifications, :deleted_at, :datetime
    add_index :sms_risk_notifications, :deleted_at
  end
end
