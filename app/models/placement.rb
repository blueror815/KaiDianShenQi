class Placement < ActiveRecord::Base
  belongs_to :order, inverse_of: :placements, validate: true
  belongs_to :product, inverse_of: :placements, validate: true

  after_create :decrement_product_quantity!

  def decrement_product_quantity!
    self.product.decrement!(:quantity_in_stock, quantity)
  end
end
