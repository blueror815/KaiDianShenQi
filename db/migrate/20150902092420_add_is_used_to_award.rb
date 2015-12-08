class AddIsUsedToAward < ActiveRecord::Migration
  def change
    add_column :awards, :is_used, :boolean, default: false
  end
end
