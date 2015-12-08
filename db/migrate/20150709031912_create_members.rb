class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.string :member_id
      t.string :gender
      t.string :address
      t.string :birth_date

      t.timestamps null: false
    end
  end
end
