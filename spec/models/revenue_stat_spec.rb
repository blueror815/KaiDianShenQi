require 'rails_helper'


describe RevenueStat do
  describe "it should have necessary fields" do
    let(:retailer){FactoryGirl.create :retailer}
    subject{retailer.revenue_stat}

    it {should respond_to :new_user_revenue}
    it {should respond_to :regular_user_revenue}
    it {should respond_to :vip_user_revenue}

    it {should validate_presence_of :retailer_id}
    it {should validate_uniqueness_of :retailer_id}
  end

  describe "it should compute revenue correctly" do
    before do
      @retailer = FactoryGirl.create(:retailer)

      @member1 = FactoryGirl.create(:member)
      @member2 = FactoryGirl.create(:member)

      @regular_type = FactoryGirl.create :membership_type, name: "常客"
      @vip_type = FactoryGirl.create :membership_type, name: "VIP"

      @membership1 = FactoryGirl.create :membership, retailer_id: @retailer.id, member_id: @member1.id, points: 10, membership_type: @regular_type
      @membership2= FactoryGirl.create :membership, retailer_id: @retailer.id, member_id: @member2.id, points: 25, membership_type: @vip_type
    end

    it "compute revenue correctly for vip user" do
      expect{
        @retailer.revenue_stat.compute_revenue
      }.to change{@retailer.revenue_stat.vip_user_revenue}.from(0).to(25)
    end

    it "compute revenue correctly for regular user" do
      expect{
        @retailer.revenue_stat.compute_revenue
      }.to change{@retailer.revenue_stat.regular_user_revenue}.from(0).to(10)
    end

    it "compute revenue correclty for orders too" do
      expect{
        @order1 = FactoryGirl.create :order, retailer: @retailer, member: @member1, total_points_charge: 5, total_charge:0
        @retailer.revenue_stat.compute_revenue
      }.to change{@retailer.revenue_stat.regular_user_revenue}.from(0).to(15)
    end
  end
end
