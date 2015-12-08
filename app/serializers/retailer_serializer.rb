class RetailerSerializer < ActiveModel::Serializer
  embed :ids
  attributes :id, :user_name, :created_at, :updated_at, :auth_token
  has_many :products
end
