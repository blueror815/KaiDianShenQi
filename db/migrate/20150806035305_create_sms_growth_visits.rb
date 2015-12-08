class CreateSmsGrowthVisits < ActiveRecord::Migration
  def change
    create_table :sms_growth_visits do |t|
      t.references :membership
      t.integer :visit_count

      t.timestamps null: false
    end
  end
end
