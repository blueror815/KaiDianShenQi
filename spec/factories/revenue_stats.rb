FactoryGirl.define do
  factory :revenue_stat do
    retailer
    new_user_revenue 1.5
    regular_user_revenue 1.5
    vip_user_revenue 1.5
  end

end
