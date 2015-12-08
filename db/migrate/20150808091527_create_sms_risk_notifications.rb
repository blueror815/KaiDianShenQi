class CreateSmsRiskNotifications < ActiveRecord::Migration
  def change
    create_table :sms_risk_notifications do |t|
      t.references :membership, index: true

      t.timestamps null: false
    end
    add_foreign_key :sms_risk_notifications, :memberships
  end
end
