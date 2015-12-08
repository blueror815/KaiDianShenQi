FactoryGirl.define do
  factory :sign_up_progress do
    retailer
    sign_up_goal 100
    sign_up_so_far 0
    refresh_sign_up_every_days 7
  end

end
