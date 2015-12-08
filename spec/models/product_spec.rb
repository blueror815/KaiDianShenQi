require 'spec_helper'

describe Product do
  describe Product do
    let(:product) {FactoryGirl.create :product}
    subject {product}

    it {should validate_presence_of :title}
    it {should validate_numericality_of(:point_value).is_greater_than_or_equal_to(0.0)}
    it {should validate_numericality_of(:price).is_greater_than_or_equal_to(0.0) }
    it {should validate_presence_of :price}

    it {should respond_to :retailer_id}

    it {should have_many(:placements)}
    it {should have_many(:orders).through(:placements)}

    describe "audited" do
      it "stores all the changes in all attributes" do
        new_product = FactoryGirl.create :product
        expect{
          new_product.update_attribute(:price, 25)
        }.to change{
          Audited::Adapters::ActiveRecord::Audit.count
        }.by 1
      end
    end
  end
end
