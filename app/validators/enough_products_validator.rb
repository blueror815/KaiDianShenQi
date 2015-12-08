class EnoughProductsValidator < ActiveModel::Validator
  def validate(record)
    record.placements.each do |placement|
      product = placement.product
      if placement.quantity > product.quantity_in_stock
        record.errors["#{product.title}"] << "Is out of stock, just #{product.quantity_in_stock} left"
      end
    end
  end
end