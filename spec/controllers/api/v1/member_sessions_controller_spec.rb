require 'spec_helper'

describe Api::V1::MemberSessionsController do
  describe "POST #create" do
    context "when the credentials are correct" do
      before(:each) do
        @member = FactoryGirl.create :member
        @credentials = { member_external_id: @member.member_external_id, password: "123456789" }
        post :create, { session: @credentials }
      end

      it "returns the member record corresponding to the given credentials" do
        @member.reload
        expect(json_response[:member][:auth_token]).to eql @member.auth_token
      end
      it {should respond_with 200}

    end
  end
  describe "DELETE #destroy" do
    before(:each) do
      @member = FactoryGirl.create :member
      sign_in @member
      delete :destroy, id: @member.auth_token
    end
    it { should respond_with 204 }

  end
end

