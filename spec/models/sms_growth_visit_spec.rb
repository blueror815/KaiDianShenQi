require 'rails_helper'

RSpec.describe SmsGrowthVisit, type: :model do
  let(:sms_growth_visit){FactoryGirl.create :sms_growth_visit}
  subject {sms_growth_visit}
  it {should respond_to(:visit_count)}
  it {should belong_to :membership}

  it "sends retailer growth message to the member external id" do
    membership = FactoryGirl.create :membership

    setting = membership.retailer.setting
    setting.growth_message = 'test growth message'
    setting.save
    setting.reload

    member = membership.member
    member.member_external_id = '111-222-3333'
    member.save
    member.reload
    
    SMS::OneInfo.stub(:delay).and_return(SMS::OneInfo)
    SMS::OneInfo.should_receive(:send_text).with( setting.growth_message,
            member.member_external_id )
    FactoryGirl.create(:sms_growth_visit, membership: membership) 
    
  end
end
