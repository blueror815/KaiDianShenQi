require 'rails_helper'

RSpec.describe SettingsController, type: :controller do
  login_retailer

  let(:valid_attributes) {
    FactoryGirl.build(:setting).attributes.symbolize_keys
  }

  let(:invalid_attributes) {
    FactoryGirl.build(:setting, retailer_id: nil).attributes.symbolize_keys
  }

  let(:valid_session) { {} }

  describe "GET #edit" do
    it "assigns the requested setting as @setting" do
      setting = subject.current_retailer.setting 
      get :edit, {:id => setting.to_param}, valid_session
      expect(assigns(:setting)).to eq(setting)
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        {welcome_message: "Welcome to CaowuLoyality"}
      }

      it "updates the requested setting" do
        setting = subject.current_retailer.setting 
        put :update, {:id => setting.to_param, :setting => new_attributes}, valid_session
        setting.reload
	expect(setting.welcome_message).to eq "Welcome to CaowuLoyality"
      end

      it "assigns the requested setting as @setting" do
        setting = subject.current_retailer.setting 
        put :update, {:id => setting.to_param, :setting => valid_attributes}, valid_session
        expect(assigns(:setting)).to eq(setting)
      end

      it "redirects to the setting" do
        setting = subject.current_retailer.setting 
        put :update, {:id => setting.to_param, :setting => valid_attributes}, valid_session
        expect(response).to redirect_to(edit_setting_path(setting))
      end
    end
  end
end
