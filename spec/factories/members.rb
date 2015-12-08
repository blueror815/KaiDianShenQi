FactoryGirl.define do
  factory :member do
    member_external_id {FFaker::Identification.ssn}
    gender {FFaker::Identification.gender}
    address {FFaker::Address.street_address}
    birth_date "1988-12-12"
    password 123456789
    password_confirmation 123456789
  end
end
