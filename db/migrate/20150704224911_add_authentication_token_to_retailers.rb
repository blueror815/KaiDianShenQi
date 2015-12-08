class AddAuthenticationTokenToRetailers < ActiveRecord::Migration
  def change
    add_column :retailers, :auth_token, :string, default: ""
    add_index :retailers, :auth_token, unique: true
  end
end
