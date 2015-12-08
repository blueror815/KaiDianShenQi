class ChangeColumnNameToMembers < ActiveRecord::Migration
  def self.up
    rename_column :members, :member_id, :member_external_id
  end
  def self.down
    rename_column :members, :member_external_id, :member_id
  end
end
