module ControllerMacros
  def login_retailer
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:retailer]
      retailer = FactoryGirl.create(:retailer)
      sign_in retailer
    end
  end
end
