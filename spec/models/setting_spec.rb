require 'spec_helper'

describe Setting do
  describe Setting do
    let(:retailer) {FactoryGirl.create :retailer}
    subject {retailer.setting}

    it {should validate_presence_of :retailer_id}
    it {should belong_to :retailer}

  end
end
