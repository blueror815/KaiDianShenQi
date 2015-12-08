require 'spec_helper'

describe Order do
  before(:each) do
    @retailer = FactoryGirl.create :retailer
    @order = FactoryGirl.create :order, :retailer => @retailer

    product_1 = FactoryGirl.create :product, quantity_in_stock: 1, retailer: @retailer, price: 5, point_value: 2
    product_2 = FactoryGirl.create :product, quantity_in_stock: 100, retailer: @retailer, price: 1, point_value: 1

    placement_1 = FactoryGirl.build :placement, product: product_1, quantity: 1
    placement_2 = FactoryGirl.build :placement, product: product_2, quantity: 101

    @order.placements << placement_1
    @order.placements << placement_2

    @total_charge = product_1.price * placement_1.quantity + product_2.price * placement_2.quantity
    @total_points = product_1.point_value * placement_1.quantity + product_2.point_value * placement_2.quantity
  end

  describe do
    subject {@order}

    it {should belong_to :retailer}
    it {should belong_to :member}

    it {should have_many(:placements)}
    it {should have_many(:products).through(:placements)}

    it "should validates associated products" do
      @order.products.new(title: nil)
      expect(@order.save).to be false
    end

    it {should validate_presence_of :total_charge}
    it {should validate_numericality_of(:total_charge).is_greater_than_or_equal_to(0)}
    it {should validate_presence_of :retailer_id}

    it "should create a order correclty" do
      expect(@order.retailer.user_name).to eq @retailer.user_name
    end

    it {should respond_to(:total_charge)}
    it {should respond_to(:total_points_charge)}
    it {should respond_to(:retailer)}

  end

  describe "#valid?" do
    it "return error since quantity is larger than in stock" do
      #TODO when we need quantity restriction later
      #expect(@order).to_not be_valid
    end
  end
  
  
  describe "#attach_associated_promotion" do
    it "attaches a promoted order if any active promotion is available for user" do
      promotion = FactoryGirl.create(:promotion, expiry_date: 2.days.from_now)
      promotion_sms_message = FactoryGirl.create(:promotion_sms_message, promotion: promotion)

      order = FactoryGirl.create(:order, member: promotion_sms_message.membership.member)

      expect{ 
        order.attach_associated_promotion 
      }.to change{
        promotion.promoted_orders.count
      }.by 1
    end

    it "does not attaches a promoted order if any active promotion is expired" do
      promotion = FactoryGirl.create(:promotion, expiry_date: 1.days.ago)
      promotion_sms_message = FactoryGirl.create(:promotion_sms_message, promotion: promotion)

      order = FactoryGirl.create(:order, member: promotion_sms_message.membership.member)

      expect{ 
        order.attach_associated_promotion 
      }.to change{
        promotion.promoted_orders.count
      }.by 0
    end
  end

  describe "#set_total_charge" do
    it "updates total charge of product to sum of price of each placement" do
      @order.set_total_charge  
      expect(@order.total_charge).to be_within(0.0001).of( @total_charge )
    end
  end

  describe "#set_total_point_value" do
    it "updates total point value of product to sum of point of each placement" do
      @order.set_total_points_charge  
      expect(@order.total_points_charge).to be_within(0.00001).of( @total_points )
    end
  end

  describe "#checkout_cash" do
    let!(:member){ FactoryGirl.create :member }
    let!(:membership){ FactoryGirl.create :membership, retailer: @order.retailer, member: member}

    before(:each) do
      product_1 = FactoryGirl.create :product, quantity_in_stock: 5
      product_2 = FactoryGirl.create :product, quantity_in_stock: 10
      @product_ids_and_quantities = [[product_1.id, 2], [product_2.id, 3]]

      @total_charge = product_1.price * 2 + product_2.price * 3 
    end
   
    it "updates points of the member" do
      expect{
        @order.checkout_cash(@order.retailer, @product_ids_and_quantities, member.member_external_id)
        membership.reload
      }.to change{
        membership.points
      }.by 1     
    end

    it "just saves order if member_external_id is blank" do
      order = FactoryGirl.create(:order)
      order.checkout_cash(order.retailer, @product_ids_and_quantities, nil)
      expect(order.total_charge).to eq @total_charge
    end

    it "sends error message if external member id is invalid" do
      order = FactoryGirl.create(:order)
      result = order.checkout_cash(order.retailer, @product_ids_and_quantities, "invalid-external-member-id")
      expect(result[:errors]).to eq "Not a member or wrong membership id. Please register first"
    end
  end

  describe "#checkout_points" do
    let!(:member){ FactoryGirl.create :member }
    let!(:membership){ FactoryGirl.create :membership, retailer: @order.retailer, member: member, points: 1000}

    before(:each) do
      product_1 = FactoryGirl.create :product, quantity_in_stock: 5
      product_2 = FactoryGirl.create :product, quantity_in_stock: 10
      @product_ids_and_quantities = [[product_1.id, 2], [product_2.id, 3]]

      @total_points = product_1.point_value * 2 + product_2.point_value * 3
    end
   
    it "updates points of the member" do
      order = FactoryGirl.build :order, retailer: membership.retailer
      expect{
        order.checkout_points(order.retailer, @product_ids_and_quantities, member.member_external_id)
        membership.reload
      }.to change{
        membership.points
      }.by (@total_points * -1 )    
    end

    it "sends error message if external member id is blank" do
      order = FactoryGirl.create(:order)
      result = order.checkout_points(order.retailer, @product_ids_and_quantities, "")
      expect(result[:errors]).to eq "No member id provided. Can't checkout with points"
    end

    it "sends error message if external member id is invalid" do
      order = FactoryGirl.create(:order)
      result = order.checkout_points(order.retailer, @product_ids_and_quantities, "invaid-member-id")
      expect(result[:errors]).to eq "Member-id provided is not a valid member id"
    end

    it "sends error message if member does not belong to retailer" do
      retailer = FactoryGirl.create(:retailer)
      order = FactoryGirl.create(:order, retailer: membership.retailer)

      result = order.checkout_points(retailer, @product_ids_and_quantities, membership.member.member_external_id)
      expect(result[:errors]).to eq "0 membership points"
    end

    it "sends error message if member does not have sufficient points" do
      order = FactoryGirl.create(:order, retailer: membership.retailer)
      membership.update_attribute(:points, 1)
      result = order.checkout_points(order.retailer, @product_ids_and_quantities, membership.member.member_external_id)
      expect(result[:errors]).to eq "Not enough points to complete this checkout"
    end
  end

  describe "#build_placements_with_product_ids_and_quantities" do
    before(:each) do
      product_1 = FactoryGirl.create :product, quantity_in_stock: 5
      product_2 = FactoryGirl.create :product, quantity_in_stock: 10
      @product_ids_and_quantities = [[product_1.id, 2], [product_2.id, 3]]

      @order = FactoryGirl.build :order
    end

    it "builds 2 placements for the order" do
      expect{@order.build_placements(@product_ids_and_quantities)}.to change{@order.placements.size}.from(0).to(2)
    end
  end
end
