class AddModuleNameToPermission < ActiveRecord::Migration
  def change
    add_column :permissions, :module_name, :string
  end
end
