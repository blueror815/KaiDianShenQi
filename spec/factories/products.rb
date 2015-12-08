FactoryGirl.define do
  factory :product do
    retailer
    title {FFaker::Product.product_name}
    price {(5 * 100)}
    description {FFaker::Product.brand}
    barcode {(rand()*10000000).to_i}
    quantity_in_stock 15
    point_value 3.0
  end
end
