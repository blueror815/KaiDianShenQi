require 'rails_helper'

RSpec.describe SmsFirstVisit, type: :model do
  context "Initial member" do
    before(:each) do
      @sms_first_visit = FactoryGirl.create :sms_first_visit
    end
    it {should belong_to :membership}
  end

end
