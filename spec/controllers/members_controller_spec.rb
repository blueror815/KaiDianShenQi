require 'rails_helper'

RSpec.describe MembersController, type: :controller do
  let(:valid_attributes) {
    FactoryGirl.build(:member).attributes.symbolize_keys
  }

  let(:invalid_attributes) {
    FactoryGirl.build(:member, member_external_id: nil).attributes.symbolize_keys
  }

  let(:valid_session) { {} }
  describe "GET #introduce" do

    let!(:award){ FactoryGirl.create :award }

    it "assigns award as @award for valid token" do
      get :introduce, {token: award.code}

      expect(assigns(:award)).to eq(award)
    end 
   
    it "assigns award as nil for invalid token" do
      get :introduce, {token: "invalidtoken"}

      expect(assigns(:award)).to eq(nil)
    end    
  end

  describe "POST #award" do
    let!(:award){ FactoryGirl.create :award }
    
     it "updates member phone number to award" do
       post :award, {phone: "9876543210", code: "333444555", award_id: award.id}

       award.reload
       expect(award.phone_number).to eq "9876543210"
       expect(award.open_id).to eq "333444555"
     end 
  end

  describe "GET #index" do
    login_retailer

    let!(:member){ FactoryGirl.create(:member) }
    let!(:membership){ FactoryGirl.create(:membership, retailer: subject.current_retailer, member: member) }

    it "assigns all retailers members as @members" do
      get :index, {}, valid_session
      expect(assigns(:members)).to eq([member])
    end

    it "does not assigns other retailers members as @members" do
      other_retailer = FactoryGirl.create(:retailer)
      other_retailer_member = FactoryGirl.create(:member)
      other_membership = FactoryGirl.create(:membership, member: member, retailer: other_retailer)

      get :index, {}, valid_session
      expect(assigns(:members)).to_not eq([member, other_retailer_member])
    end

    it "assigns all retailer tags as @tags" do
      membership.tag_list.add("test-tag")
      membership.save

      get :index, {}, valid_session
      expect(assigns(:tags)).to eq(["test-tag"])
    end
  end

  describe "GET #show" do
    login_retailer

    let!(:member){ FactoryGirl.create(:member) }
    let!(:membership){ FactoryGirl.create(:membership, retailer: subject.current_retailer, member: member) }

    it "assigns members as @member" do
      get :show, {id: member.to_param}, valid_session
      expect(assigns(:member)).to eq(member)
    end

    it "assigns all retailer tags as @tags" do
      membership.tag_list.add("test-tag")
      membership.save

      get :show, {id: member.to_param}, valid_session
      expect(assigns(:tags)).to eq(["test-tag"])
    end
  end

  describe "POST #add_tag" do
    login_retailer

    let!(:member){ FactoryGirl.create(:member) }
    let!(:membership){ FactoryGirl.create(:membership, retailer: subject.current_retailer, member: member) }

    it "adds tag to membership" do
      post :add_tag, {tag: "test-tag", id: membership.id, format: 'js'}, valid_session
      expect(membership.tag_list).to eq(["test-tag"])
    end

    it "does not add duplicate tag to membership" do
      post :add_tag, {tag: "test-tag", id: membership.id, format: 'js'}, valid_session
      expect(membership.tag_list).to eq(["test-tag"])

      post :add_tag, {tag: "test-tag", id: membership.id, format: 'js'}, valid_session
      expect(membership.tag_list).to eq(["test-tag"])
    end

    it "does not add reserved tag to membership" do
      FactoryGirl.create(:reserved_tag, name: 'Blocked Tag')

      post :add_tag, {tag: "Blocked Tag", id: membership.id, format: 'js'}, valid_session
      expect(membership.tag_list).to eq([])
    end
  end

  describe "POST #listing" do
    login_retailer

    let!(:member){ FactoryGirl.create(:member) }
    let!(:membership){ FactoryGirl.create(:membership, retailer: subject.current_retailer, member: member) }

    it "assigns all associated members of tag to @memberships" do
      membership.tag_list.add("test-tag")
      membership.save
     
      post :listing, {tag: 'test-tag'}, valid_session
      expect(assigns(:memberships)).to eq([membership]) 
    end
  end

  describe "DELETE #destroy" do
    login_retailer

    it "destroys the requested product" do
      membership = FactoryGirl.create(:membership, retailer: subject.current_retailer)
      expect {
        delete :destroy, {:id => membership.to_param}, valid_session
      }.to change(subject.current_retailer.memberships, :count).by(-1)
    end

    it "redirects to the products list" do
      membership = FactoryGirl.create(:membership, retailer: subject.current_retailer)
      delete :destroy, {:id => membership.to_param}, valid_session
      
      expect(response).to redirect_to(members_url)
    end
  end
end
