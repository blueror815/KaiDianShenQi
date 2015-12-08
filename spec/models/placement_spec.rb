require 'spec_helper'

describe Placement do
  let(:placement){FactoryGirl.create :placement}
  subject {placement}
  it {should belong_to :order}
  it {should belong_to :product}
  it {should respond_to :quantity}


  describe "#decrement_product_quantity!" do
    it "decrease quantity by the placement quantity" do
      product = placement.product
      expect{placement.decrement_product_quantity!}.to change{product.quantity_in_stock}.by(-placement.quantity)
    end
  end
end
