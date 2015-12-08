require 'rails_helper'

RSpec.describe Api::V1::AwardsController, type: :controller do

  let(:valid_session) { {} }

  describe "POST #add_award_point" do
    before(:each) do
      @retailer = FactoryGirl.create :retailer
      api_authorization_header @retailer.auth_token
    end

    it "creates award for the retailer" do
      expect{ 
        post :create, {points: 5}
      }.to change{
        @retailer.awards.count
      }.by 1
    end

    it "responds with error if point is not available" do
      post :create, {points: nil}
      res = JSON.parse(response.body)

      expect(res["errors"]).to_not be nil
    end

    it "does not create award if point is not avaialble" do
      expect{ 
        post :create, {points: nil}
      }.to change{
        @retailer.awards.count
      }.by 0
    end 
  end
end
