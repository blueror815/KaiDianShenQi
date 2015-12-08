class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.boolean :can_manage

      t.timestamps null: false
    end
  end
end
