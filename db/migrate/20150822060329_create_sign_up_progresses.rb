class CreateSignUpProgresses < ActiveRecord::Migration
  def change
    create_table :sign_up_progresses do |t|
      t.references :retailer, index: true
      t.integer :sign_up_goal, default: 100
      t.integer :sign_up_so_far, default: 0
      t.integer :refresh_sign_up_every_days, default: 7

      t.timestamps null: false
    end
    add_foreign_key :sign_up_progresses, :retailers
  end
end
