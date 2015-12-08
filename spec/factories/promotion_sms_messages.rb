FactoryGirl.define do
  factory :promotion_sms_message do
    promotion
    membership
    message "MyText"
  end

end
