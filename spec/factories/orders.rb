FactoryGirl.define do
  factory :order do
    retailer
    member
    total_charge 0.0
    total_points_charge 0.0
  end
end
