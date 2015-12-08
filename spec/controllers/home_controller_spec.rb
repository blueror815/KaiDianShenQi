require 'rails_helper'

RSpec.describe HomeController, type: :controller do

  describe "GET #index" do
    login_retailer
    it "returns http success" do
      get :index
      expect(response).to have_http_status(200)
    end
  end

  
  describe "GET #membership_audit" do
    login_retailer
    it "returns http success" do
      get :membership_audit
      expect(response).to have_http_status(200)
    end

    it "containes all the membership changes" do
      membership = FactoryGirl.create :membership, retailer: subject.current_retailer
      get :membership_audit
      expect(assigns(:membership_audits)).to eq(
        Audited::Adapters::ActiveRecord::Audit.where(
          auditable_type: 'Membership'
        ).select{|audit| audit.auditable.retailer == subject.current_retailer}
      )
    end
  end

  describe "GET #membership_audit" do
    login_retailer
    it "returns http success" do
      get :product_audit
      expect(response).to have_http_status(200)
    end
    it "containes all the product changes" do
      product = FactoryGirl.create :product, retailer: subject.current_retailer
      get :product_audit
      expect(assigns(:product_audits)).to eq(
        Audited::Adapters::ActiveRecord::Audit.where(
          auditable_type: 'Product'
        ).select{|audit| audit.auditable.retailer == subject.current_retailer}
      )
    end
  end

  describe "GET #new_user_revenue" do
    login_retailer
    it "assigns award as @award for valid token" do
      FactoryGirl.create :membership, retailer: subject.current_retailer
      get :index
      expect(assigns(:total_members)).to be(1)
      expect(assigns(:new_user_revenue)).to be(0.0)
      expect(assigns(:regular_user_revenue)).to be(0.0)
      expect(assigns(:vip_user_revenue)).to be(0.0)
    end
  end
end
