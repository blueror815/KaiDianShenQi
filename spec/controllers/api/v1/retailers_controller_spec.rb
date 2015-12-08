require 'spec_helper'


describe Api::V1::RetailersController do
  before(:each) { request.headers['Accept'] = "application/vnd.caowu.v1" }

  describe "POST #create" do
    before(:each) do
      @retailer_attributes = FactoryGirl.attributes_for :retailer
      post :create, {retailer: @retailer_attributes}, format: :json
    end

    it "create and return the id that I passed to create" do
      retailer_response = JSON.parse(response.body, symbolize_names: true)
      expect(retailer_response[:retailer][:user_name]).to eql @retailer_attributes[:user_name]

      # only return these fields
      expect(retailer_response[:retailer].keys.sort).to eql [:auth_token, :created_at, :id, :product_ids, :updated_at, :user_name]
    end
  end

  describe "POST #create fail" do
    before(:each) do
      @retailer_attributes = FactoryGirl.attributes_for :retailer
      @retailer_attributes[:user_name] = ""
      post :create, {retailer: @retailer_attributes}, format: :json
    end

    it "return errors when retailer not created succesffully" do
      retailer_response = JSON.parse(response.body, symbolize_names: true)
      expect(retailer_response.key?(:errors)).to eql true
    end
  end

  describe "GET #show" do
    before(:each) do
      @retailer = FactoryGirl.create :retailer
      api_authorization_header @retailer.auth_token
      get :show, id: @retailer.id, format: :json
    end

    it "returns the information about a reporter on a hash" do
      retailer_response = JSON.parse(response.body, symbolize_names: true)
      expect(retailer_response[:retailer][:user_name]).to eql @retailer.user_name
    end

    it "does not return password" do
      retailer_response = JSON.parse(response.body, symbolize_names: true)
      expect(retailer_response.key?(:password)).to eql false
    end

    it { should respond_with 200 }
  end


  describe "POST #create" do
    before(:each) do
      @retailer_attributes = FactoryGirl.attributes_for :retailer
      post :create, {retailer: @retailer_attributes}
    end

    it "creates a user" do
      retailer_response = JSON.parse(response.body, symbolize_names: true)
      expect(retailer_response[:retailer][:user_name]).to eql @retailer_attributes[:user_name]
    end

  end

  describe "POST #find_and_show_membership" do
    before(:each) do
      @retailer = FactoryGirl.create :retailer
      api_authorization_header @retailer.auth_token

      @member = FactoryGirl.create :member
      @membership = FactoryGirl.create :membership, {retailer_id: @retailer.id, member_id: @member.id}
      post :find_and_show_membership, {:id => @retailer.id, :member_external_id => @member.member_external_id}, format: :json
    end
    it "show membership" do
      expect(json_response[:member_id]).to eq @member.id
      expect(json_response[:retailer_id]).to eq @retailer.id
      expect(json_response[:points]).to eq 10
    end
  end

  describe "When this member_external_id doesn't exist, return error" do
    before(:each) do
      @retailer = FactoryGirl.create :retailer
      api_authorization_header @retailer.auth_token

      @member = FactoryGirl.create :member
      @membership = FactoryGirl.create :membership, {retailer_id: @retailer.id, member_id: @member.id}
      post :find_and_show_membership, {:id => @retailer.id, :member_external_id => 999}, format: :json
    end
    it {respond_with 422}
  end

  describe "When asking for progress, it shows correctl" do
    before(:each) do
      @retailer = FactoryGirl.create :retailer
      @sign_up_info = FactoryGirl.create :sign_up_progress, {retailer: @retailer}
      api_authorization_header @retailer.auth_token

      post :show_sign_up, {:id => @retailer.id}, format: :json
    end
    it {respond_with 200}
    it "should have necessary fields" do
      expect(json_response[:sign_up_so_far]).to be @sign_up_info.sign_up_so_far
      expect(json_response[:sign_up_goal]).to be @sign_up_info.sign_up_goal
    end
  end

  describe "#profile_qr_image" do
    let(:retailer){ FactoryGirl.create :retailer }
    
    it "responds with profile qr image" do
      api_authorization_header retailer.auth_token
      get :profile_qr_image
      profile_qr_image_response = JSON.parse(response.body)
      expect(profile_qr_image_response["url"]).to eq (retailer.profile_qr_image.url)
    end
  end
end
