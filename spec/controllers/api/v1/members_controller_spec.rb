require 'spec_helper'

describe Api::V1::MembersController do
  describe "POST #create" do
    context "create successfully" do
      before do
        @member_attributes = FactoryGirl.attributes_for :member
        post :create, {member: @member_attributes}, format: :json
      end
      it {should respond_with 201}
      it "should have the same member attributes" do
        member_response = JSON.parse(response.body, symbolize_names: true)
        ['member_external_id', 'gender', 'age', 'birth_date'].each do |key|
          expect(member_response[key]).to eql @member_attributes[key]
        end
      end
    end

    context "create unsuccessfully" do
      before do
        @member_attributes = FactoryGirl.attributes_for :member
        @member_attributes[:member_external_id] = ""
        post :create, {member: @member_attributes}, format: :json
      end
      it {should respond_with 422}
    end
  end

  context "POST #show_my_retailers" do
    before do
      @retailer = FactoryGirl.create :retailer
      @member = FactoryGirl.create :member
      @membership = FactoryGirl.create :membership, retailer_id: @retailer.id, member_id: @member.id
      api_authorization_header @member.auth_token
      post :show_my_retailers, {member_external_id: @member.member_external_id}, format: :json
    end

    it "show retailers info correctly" do
      expect(json_response[:member][:member_external_id] == @member.member_external_id).to be(true)

      points_result = json_response[:member][:memberships][0][:points].to_f
      expect(((points_result - @membership.points.to_f).abs <= 1e-10)).to be(true)
    end
  end

  context "POST #associate_client_id" do
    before do
      @member = FactoryGirl.create :member
      post :associate_client_id, {member_external_id: @member.member_external_id, client_id: "blah"}, format: :json
    end
    it "associate client id correctly" do
      expect(json_response[:member][:client_id]).to eq "blah"
    end
  end

  context "POST #destroy_client_id" do
    before do
      @member = FactoryGirl.create :member
      post :destroy_client_id, {member_external_id: @member.member_external_id}, format: :json
    end
    it "delete client id correctly" do
      expect(json_response[:member][:client_id]).to eq ""
    end
  end

end
