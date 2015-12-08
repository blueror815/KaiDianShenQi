require 'spec_helper'

describe Api::V1::ProductsController do
  describe "POST #create" do
    before(:each) do
      retailer = FactoryGirl.create :retailer
      @product_attributes = FactoryGirl.attributes_for :product
      api_authorization_header retailer.auth_token
      post :create, {retailer_id: retailer.id, product: @product_attributes}
    end

    it "renders the json representation for the product record just created" do
      product_response = JSON.parse(response.body, symbolize_names: true)
      expect(product_response[:product][:title]).to eql @product_attributes[:title]
      expect(BigDecimal.new(product_response[:product][:quantity_in_stock])).to eql @product_attributes[:quantity_in_stock]
    end
  end

  describe "POST #create without price" do
    before(:each) do
      retailer = FactoryGirl.create :retailer
      @product_attributes = FactoryGirl.attributes_for :product
      @product_attributes.delete(:price)
      api_authorization_header retailer.auth_token
      post :create, {retailer_id: retailer.id, product: @product_attributes}
    end
    it "shouldn't create the product" do
      respond_with 422
    end
    it "gives error" do
      expect(json_response.key?(:errors)).to eql true
    end
  end
  describe "POST #create without price" do
    before(:each) do
      retailer = FactoryGirl.create :retailer
      api_authorization_header retailer.auth_token
      post :create, {retailer_id: retailer.id, product: {title: "ha", quantity: 10}}
    end
    it "shouldn't create the product" do
      respond_with 422
    end
  end

  describe "GET #index and #show when there're products" do
    before(:each) do
      @retailer = FactoryGirl.create :retailer
      @product1 = FactoryGirl.create :product, retailer_id: @retailer.id
      @product2 = FactoryGirl.create :product, retailer_id: @retailer.id
      @product3 = FactoryGirl.create :product, retailer_id: @retailer.id
      api_authorization_header @retailer.auth_token
    end
    it "show all the products belong to the retailer" do
      get :index, :retailer_id => @retailer.id, format: :json
      product_response = JSON.parse(response.body, symbolize_names: true)
      expect(product_response[:products].size).to eql 3
    end

    it "show one product belongs to the retailer" do
      get :show, :retailer_id => @retailer.id, :id => @product2.id, format: :json
      product_response = JSON.parse(response.body, symbolize_names: true)
      expect(product_response[:product][:id]).to eql @product2.id
    end

    it "show another one product belongs to the retailer" do
      get :show, :retailer_id => @retailer.id, :id => @product3.id, format: :json
      product_response = JSON.parse(response.body, symbolize_names: true)
      expect(product_response[:product][:id]).to eql @product3.id
    end
  end

  describe "GET #index and #show when there're no products" do
    before(:each) do
      @retailer = FactoryGirl.create :retailer
      api_authorization_header @retailer.auth_token
    end
    it "show no products when using index" do
      get :index, :retailer_id => @retailer.id, format: :json
      product_response = JSON.parse(response.body, symbolize_names: true)
      expect(product_response[:products].size).to eql 0
    end
  end

  describe "PATCH #update" do
    before do
      @retailer = FactoryGirl.create :retailer
      api_authorization_header @retailer.auth_token
      @product = FactoryGirl.create :product, retailer: @retailer
      @updated_product = FactoryGirl.attributes_for :product, retailer: @retailer
      patch :update, {retailer_id: @retailer.id, id: @product.id, product: @updated_product}, format: :json
    end
    it "update product successfully" do
      product_response = JSON.parse(response.body, symbolize_names: true)
      expect(product_response[:product][:title]).to eql @updated_product[:title]
    end
  end

  describe "PATCH #update uncessfully" do
    before do
      @retailer = FactoryGirl.create :retailer
      api_authorization_header @retailer.auth_token
      @product = FactoryGirl.create :product, retailer: @retailer
      @updated_product = FactoryGirl.attributes_for :product, retailer: @retailer
      @updated_product[:price] = -1 #invalid price so validates for product should fail
      patch :update, {retailer_id: @retailer.id, id: @product.id, product: @updated_product}, format: :json
    end
    it "update product unsuccessfully" do
      product_response = JSON.parse(response.body, symbolize_names: true)
      expect(product_response.key?(:errors)).to eql true
    end
  end

  describe "DELETE #destroy" do
    context "delete successfully" do
      before do
        @retailer = FactoryGirl.create :retailer
        api_authorization_header @retailer.auth_token
        @product = FactoryGirl.create :product, retailer: @retailer

        delete :destroy, {id: @product.id, retailer_id: @retailer.id}, format: :json
      end
      it {should respond_with 204}
    end
  end
end
