class AddClientIdToMember < ActiveRecord::Migration
  def change
    add_column :members, :client_id, :string
  end
end
