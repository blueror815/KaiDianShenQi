class PromotionSerializer < ActiveModel::Serializer
  attributes :id, :offer, :occation, :expiry_date
  has_one :retailer
end
