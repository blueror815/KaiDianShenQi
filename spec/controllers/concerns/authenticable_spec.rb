require 'spec_helper'

class Authentication
  include Authenticable
end

describe Authenticable do
  let(:authentication) { Authentication.new }
  subject { authentication }

  describe "#current_oauth_retailer" do
    before do
      @retailer = FactoryGirl.create :retailer
      request.headers["Authorization"] = @retailer.auth_token
      #authentication.stub(:request).and_return(request)
      allow(authentication).to receive(:request).and_return(request)
    end
    it "returns the retailer from the authorization header" do
      expect(authentication.current_oauth_retailer.auth_token).to eql @retailer.auth_token
    end
  end
end
