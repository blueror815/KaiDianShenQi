class AddMembershipTypeIdToMembership < ActiveRecord::Migration
  def change
    add_reference :memberships, :membership_type, index: true
    add_foreign_key :memberships, :membership_types
  end
end
