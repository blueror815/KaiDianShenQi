FactoryGirl.define do
  factory :retailer do
    user_name {FFaker::Internet.user_name + SecureRandom.hex(4)}
    password "12345678"
    password_confirmation "12345678"
  end
end

