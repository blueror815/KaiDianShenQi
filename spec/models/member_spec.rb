require 'spec_helper'

describe Member do
  context "Initial member" do
    before(:each) do
      @member = FactoryGirl.create :member
    end
    it {respond_to :member_external_id}
    it {respond_to :birth_date}
    it {respond_to :gender}
    it {respond_to :address}
    it {should validate_presence_of :member_external_id}
    it {should validate_uniqueness_of :member_external_id}
    it {should have_many(:retailers).through(:memberships)}
    it {should have_many :memberships}
  end
end
