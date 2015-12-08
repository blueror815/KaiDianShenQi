class CreateAwardPoints < ActiveRecord::Migration
  def change
    create_table :award_points do |t|
      t.integer :points
      t.string :code

      t.timestamps null: false
    end
  end
end
