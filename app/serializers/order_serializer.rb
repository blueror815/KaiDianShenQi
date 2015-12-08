class OrderSerializer < ActiveModel::Serializer
  attributes :id, :total_charge, :retailer_id, :total_points_charge, :payment_method, :created_at, :member_id
  has_many :products
  has_many :placements
end
