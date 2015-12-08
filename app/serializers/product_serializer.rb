class ProductSerializer < ActiveModel::Serializer
  attributes :id, :title, :price, :description, :retailer_id, :quantity_in_stock, :point_value
end
