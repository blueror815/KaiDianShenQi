class RetailerForMemberSerializer < ActiveModel::Serializer
  attributes :id, :user_name, :created_at, :updated_at
  has_many :products
end
