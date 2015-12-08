class CreateSmsFirstVisits < ActiveRecord::Migration
  def change
    create_table :sms_first_visits do |t|
      t.references :membership
      t.timestamps null: false
    end
  end
end
