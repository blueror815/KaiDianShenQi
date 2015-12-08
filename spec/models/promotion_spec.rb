require 'spec_helper'

describe Promotion do
  describe Promotion do
    let(:promotion) {FactoryGirl.create :promotion}
    subject {promotion}

    it {should validate_presence_of :retailer_id}
    it {should validate_presence_of :offer}

    it {should belong_to :retailer}
    it {should have_many :promotion_tags}
    it {should have_many :promotion_sms_messages}
    it {should have_many :promoted_orders}
  end
end
