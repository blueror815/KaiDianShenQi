require 'spec_helper'

describe Api::V1::RetailerSessionsController do
  describe "POST #create" do
    context "when the credentials are correct" do
      before(:each) do
        @retailer = FactoryGirl.create :retailer
        credentials = { user_name: @retailer.user_name, password: "12345678" }
        post :create, { session: credentials }
      end

      it "returns the retailer record corresponding to the given credentials" do
        @retailer.reload
        retailer_response = JSON.parse(response.body, symbolize_names: true)
        expect(retailer_response[:retailer][:auth_token]).to eql @retailer.auth_token
      end

      it {should respond_with 200}

    end
  end

    describe "DELETE #destroy" do
      before(:each) do
        @retailer = FactoryGirl.create :retailer
        sign_in @retailer
        delete :destroy, id: @retailer.auth_token
      end

      it { should respond_with 204 }

  end
end

