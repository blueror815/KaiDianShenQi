#require 'spec_helper'
require "rails_helper"


describe "RetailerCreateProductAndPutOrders" do
  describe "GET /retailer_create_product_and_put_orders" do
    it "build a retailer and product and checkout this product" do
      retailer_attr = FactoryGirl.attributes_for :retailer
      post "/retailers", {:retailer => retailer_attr}
      retailer_hash = json_response
      expect(response).to be_success

      # sign in
      post "/retailer_sessions", {session: {:user_name => retailer_attr[:user_name], :password => retailer_attr[:password]}}
      expect(response).to be_success

      token = json_response[:retailer][:auth_token]

      # create a product
      retailer_id = retailer_hash[:retailer][:id]
      product_attr = FactoryGirl.attributes_for :product
      product_attr_2 = FactoryGirl.attributes_for :product

      post "/retailers/#{retailer_id}/products", {product: product_attr}, {:Authorization => token}
      product_1 = json_response
      #expect(response.code).to eql
      expect(response).to have_http_status(201)

      # create another product
      post "/retailers/#{retailer_id}/products", {product: product_attr_2}, {:Authorization => token}
      product_2 = json_response

      expect(Product.count).to eql 2
      expect(response).to have_http_status(201)

      # delete the first product
      delete_url = "/retailers/#{retailer_id}/products/#{product_1[:product][:id]}"
      delete delete_url, nil, {:Authorization => token}

      expect(response).to have_http_status(204)
      expect(Product.count).to eql 1

      # create an order with the first product without membership

      # post as raw json, http://stackoverflow.com/questions/14775998/posting-raw-json-data-with-rails-3-2-11-and-rspec
      post "/retailers/#{retailer_id}/orders",
           {:order => {:retailer_id => retailer_id,
                       :product_ids_with_quantities => [[product_2[:product][:id], 1],[product_2[:product][:id], 2]]}
           }.to_json,
           { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', :Authorization => token}

      final_should = product_2[:product][:price].to_f*3
      expect(approximate_eql(json_response[:order][:total_charge], final_should, 1e-10)).to be true
      expect(json_response[:order][:products].size).to eql 2
      expect(response).to have_http_status(201)

      # create a member

      post "/members", {
                         :member => {
                             :member_external_id => 13985336501,
                             :address => "some address",
                             :gender => "male",
                             :birth_date => "1982-08-13",
                             :password => "12345678",
                             :password_confirmation => "12345678"
                         }
                     }

      member = json_response

      # post an exactly the same order again
      post "/retailers/#{retailer_id}/orders",
           {
               :order => {
                   :retailer_id => retailer_id,
                   :product_ids_with_quantities => [[product_2[:product][:id], 3]]
               }
           }.to_json,
           { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', :Authorization => token}

      expect(response).to have_http_status(201)

      # Now checkout with the member's info
      post "/retailers/#{retailer_id}/orders",
           {
               :order => {
                   :retailer_id => retailer_id,
                   :product_ids_with_quantities => [[product_2[:product][:id], 3]],
                   :member_external_id => member[:member_external_id]
               }
           }.to_json,
           { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', :Authorization => token}
      expect(response).to have_http_status(201)
    end
  end
end

