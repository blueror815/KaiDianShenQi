require 'rails_helper'

RSpec.describe MembershipType, type: :model do
  it {should have_many :memberships}
end
