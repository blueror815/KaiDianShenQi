require 'rails_helper'

RSpec.describe PromotionSmsMessage, type: :model do
  let(:promotion_sms_message) {FactoryGirl.create :promotion_sms_message}
  subject {promotion_sms_message}

  it {should validate_presence_of :promotion_id}
  it {should validate_presence_of :membership_id}

  it {should validate_uniqueness_of(:membership_id).scoped_to(:promotion_id)}

  it {should belong_to :promotion}
  it {should belong_to :membership}


  context "Test if it really send sms when creating PromotionSmsMessage" do
    it do
      expect{
        promo_sms = FactoryGirl.create :promotion_sms_message
      }.to change{PromotionSmsMessage.count}.by(1)
    end
  end
end
