require 'rails_helper'

RSpec.describe SmsRiskNotification, type: :model do
  context "Initial member" do
    before(:each) do
      @sms_risk_notification = FactoryGirl.create :sms_risk_notification
    end
    it {should belong_to :membership}

    it "sends retailer risk message to the member external id" do
      membership = FactoryGirl.create :membership
    
      setting = membership.retailer.setting
      setting.risk_message = 'test risk message'
      setting.save
      setting.reload
    
      member = membership.member
      member.member_external_id = '111-222-3333'
      member.save
      member.reload
      
      SMS::OneInfo.stub(:delay).and_return(SMS::OneInfo)
      SMS::OneInfo.should_receive(:send_text).with( setting.risk_message,
              member.member_external_id )
      FactoryGirl.create(:sms_risk_notification, membership: membership) 
      
    end
  end
end
