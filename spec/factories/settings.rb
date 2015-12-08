FactoryGirl.define do
  factory :setting do
    retailer
    welcome_message "MyText"
    growth_message "MyText"
    risk_message "MyText"
    no_of_order_to_send_growth_sms 3
    no_of_days_to_send_lapse_message 5
  end
end
