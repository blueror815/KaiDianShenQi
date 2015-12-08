require 'rails_helper'

RSpec.describe PromotionsController, type: :controller do

  let(:valid_attributes) {
    FactoryGirl.build(:promotion).attributes.symbolize_keys
  }

  let(:invalid_attributes) {
    FactoryGirl.build(:promotion, offer: nil).attributes.symbolize_keys
  }

  let(:valid_session) { {} }

  describe "GET #index" do
    login_retailer

    it "assigns all promotions as @promotions" do
      promotion = Promotion.create! valid_attributes
      promotion.update_attribute(:retailer_id, subject.current_retailer.id)
      promotion.reload

      get :index, {}, valid_session
      expect(assigns(:promotions)).to eq([promotion])
    end
  end

  describe "GET #new" do
    login_retailer

    it "assigns a new promotion as @promotion" do
      get :new, {}, valid_session
      expect(assigns(:promotion)).to be_a_new(Promotion)
    end
  end

  describe "POST #create" do
    login_retailer

    context "with valid params" do
      it "creates a new Promotion" do
        expect {
          post :create, {:promotion => valid_attributes}, valid_session
        }.to change(Promotion, :count).by(1)
      end

      it "assigns a newly created promotion as @promotion" do
        post :create, {:promotion => valid_attributes}, valid_session
        expect(assigns(:promotion)).to be_a(Promotion)
        expect(assigns(:promotion)).to be_persisted
      end

      it "redirects to the created promotion" do
        post :create, {:promotion => valid_attributes}, valid_session
        expect(response).to redirect_to(promotions_path)
      end
    end

    context "with valid tags" do
      it "adds campaign tags to user" do
        expect {
          post :create, {:promotion => valid_attributes, member_types: ["first-tag", "seceond-tag"]}, valid_session
        }.to change(PromotionTag, :count).by(2)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved promotion as @promotion" do
        post :create, {:promotion => invalid_attributes}, valid_session
        expect(assigns(:promotion)).to be_a_new(Promotion)
      end

      it "re-renders the 'new' template" do
        post :create, {:promotion => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end
end
