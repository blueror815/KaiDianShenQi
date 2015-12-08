require 'spec_helper'

describe Api::V1::OrdersController do
  describe "POST #create" do
    context "success" do
      before do
        @retailer = FactoryGirl.create :retailer
        @product = FactoryGirl.create :product, retailer: @retailer
        api_authorization_header @retailer.auth_token
        order_param = {product_ids_with_quantities: [[@product.id, 1]], payment_method: "cash"}
        post :create, retailer_id: @retailer.id, order: order_param
      end

      it {should respond_with 201}

      it "creates order successfully" do
        expect(json_response[:order][:retailer_id]).to eq @retailer.id
        expect(approximate_eql(json_response[:order][:total_charge], @product.price, 1e-10))
      end
    end

    context "fail" do
      before do
        @retailer_fail = FactoryGirl.create :retailer
        @order_attributes_fail = FactoryGirl.attributes_for :order, retailer: @retailer_fail
        post :create, retailer_id: 9, order: @order_attributes_fail
      end

      it {should respond_with 401}
      it "return errors" do
        expect(json_response.key?(:errors)).to eql true
      end
    end

    context "create with default total_charge" do
      before do
        @retailer = FactoryGirl.create :retailer
        api_authorization_header @retailer.auth_token
        get :create, retailer_id: @retailer, order: {product_ids_with_quantities: []}
      end
      it "return 0 as total_charge" do
        expect(json_response[:order][:total_charge].to_f).to eql 0.0
      end
    end

    context "create and charge the right amount" do
      before do
        @retailer = FactoryGirl.create :retailer
        api_authorization_header @retailer.auth_token
        @product1 = FactoryGirl.create :product
        @product2 = FactoryGirl.create :product
        post :create, retailer_id: @retailer.id, order: {product_ids_with_quantities: [[@product1.id, 1], [@product2.id, 1]]}
      end
      it "return the charge correctly" do
        expect(BigDecimal.new(json_response[:order][:total_charge]) - (@product1.price + @product2.price) <= 1e-5).to eql true
        expect(json_response[:order][:products].size).to eql 2

        # This post is to guard we don't have circular validates error
        post :create, retailer_id: @retailer.id, order: {product_ids_with_quantities: [[@product1.id, 1], [@product2.id, 1]]}
      end
    end

    context "create with member info" do
      before do
        @retailer = FactoryGirl.create :retailer
        api_authorization_header @retailer.auth_token
        @product1 = FactoryGirl.create :product
        @product2 = FactoryGirl.create :product

        @member = FactoryGirl.create :member
        @membership = FactoryGirl.create :membership, member_id: @member.id
        @retailer.memberships << @membership
        post :create,
             retailer_id: @retailer.id,
             order: {
                 product_ids_with_quantities: [[@product1.id, 1], [@product2.id, 1]], member_external_id: @member.member_external_id
             }
      end
      it {respond_with 200}
      it "add a point to this member" do
        expect(json_response[:order][:payment_method]).to eq "cash"
      end
    end

    context "create with wrong member_external_id" do
      before do
        @retailer = FactoryGirl.create :retailer
        api_authorization_header @retailer.auth_token
        @product1 = FactoryGirl.create :product
        @product2 = FactoryGirl.create :product

        @member = FactoryGirl.create :member
        @membership = FactoryGirl.create :membership, member_id: @member.id
        @retailer.memberships << @membership
        post :create,
             retailer_id: @retailer.id,
             order: {
                 product_ids_with_quantities: [[@product1.id, 1], [@product2.id, 1]], member_external_id: "123"
             }
      end
      it {respond_with 422}
      it "respond errors" do
        expect(json_response[:errors]).to eql "Not a member or wrong membership id. Please register first"
      end
    end
  end

  describe "Create points order" do
    before do
      @retailer = FactoryGirl.create :retailer
      api_authorization_header @retailer.auth_token
      @product1 = FactoryGirl.create :product
      @product2 = FactoryGirl.create :product

      @member = FactoryGirl.create :member
      @membership = FactoryGirl.create :membership, :member_id => @member.id
      @retailer.memberships << @membership
      post :create_points_order,
           retailer_id: @retailer.id,
           order: {
               product_ids_with_quantities: [[@product1.id, 1], [@product2.id, 1]],
               member_external_id: @member.member_external_id,
               payment_method: "points"
           },
           format: :json
    end
    it "computes total_points_charge correctly" do
      expect(approximate_eql(json_response[:order][:total_points_charge], 6.0, 1e-10)).to be true
      expect(json_response[:order][:products].size).to eq 2
      expect(Membership.find_by(:member_id => @member.id, :retailer_id => @retailer.id).points).to eq (10 - @product1.point_value - @product2.point_value)
      expect(json_response[:order][:payment_method]).to eq "points"
    end
  end

  describe "Create points order unsuccessfully" do
    before do
      @retailer = FactoryGirl.create :retailer
      api_authorization_header @retailer.auth_token
      @product1 = FactoryGirl.create :product
      @product2 = FactoryGirl.create :product

      @member = FactoryGirl.create :member
      @membership = FactoryGirl.create :membership, :member_id => @member.id
      @membership[:points] = 5
      @retailer.memberships << @membership
      post :create_points_order,
           retailer_id: @retailer.id,
           order: {
               product_ids_with_quantities: [[@product1.id, 1], [@product2.id, 1]],
               member_external_id: @member.member_external_id,
               payment_method: "points"
           },
           format: :json
    end

    it "should abort this transaction since points are not enough" do
      expect(json_response[:errors]).to eq "Not enough points to complete this checkout"
    end
  end


  describe "Create points order without membership" do
    before do
      @retailer = FactoryGirl.create :retailer
      api_authorization_header @retailer.auth_token
      @product1 = FactoryGirl.create :product
      @product2 = FactoryGirl.create :product

      post :create_points_order,
           retailer_id: @retailer.id,
           order: {
               product_ids_with_quantities: [[@product1.id, 1], [@product2.id, 1]],
               payment_method: "points"
           },
           format: :json
    end

    it "should abort this transaction since points are not enough" do
      expect(json_response[:errors]).to eq "No member id provided. Can't checkout with points"
    end
  end



  describe "GET #index" do
    context "show orders" do
      before do
        @retailer = FactoryGirl.create :retailer
        api_authorization_header @retailer.auth_token
        4.times {FactoryGirl.create :order, retailer: @retailer}
        get :index, retailer_id: @retailer.id
      end

      it "should create 4 orders for this user" do
        expect(json_response[:orders].size).to eql 4
      end

      it {should respond_with 200}
    end

    context "show zero order when order is empty" do
      before do
        @retailer = FactoryGirl.create :retailer
        api_authorization_header @retailer.auth_token

        get :index, retailer_id: @retailer.id
      end
      it "should show 0 order for this user" do
        expect(json_response[:orders].size).to eql 0
      end

      it {should respond_with 200}
    end

  end

  describe "GET #show" do
    before do
      @retailer = FactoryGirl.create :retailer
      api_authorization_header @retailer.auth_token
      @order1 = FactoryGirl.create :order, retailer: @retailer
      @order2 = FactoryGirl.create :order, retailer: @retailer
      @order3 = FactoryGirl.create :order, retailer: @retailer
    end

    describe "show one order" do
      before do
        get :show, retailer_id: @retailer.id, id: @order1.id, format: :json
      end
      it "should retrieve the first order" do
        expect(json_response[:order][:retailer_id]).to eql @retailer.id
        expect(json_response[:order][:id]).to eql @order1.id
        expect(json_response[:order].key?(:created_at)).to be true
      end
      it {should respond_with 200}
    end

    describe "show another order" do
      before do
        get :show, retailer_id: @retailer.id, id: @order3.id, format: :json
      end
      it "should retrieve the third order" do
        expect(json_response[:order][:retailer_id]).to eql @retailer.id
        expect(json_response[:order][:id]).to eql @order3.id
      end
      it {should respond_with 200}
    end
  end
end
