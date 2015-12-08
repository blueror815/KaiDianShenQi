require 'rails_helper'

describe Award do
  describe Award do
    before(:all) do
      FakeWeb.allow_net_connect = true
      @retailer = FactoryGirl.create :retailer
      @membership = FactoryGirl.create :membership, retailer: @retailer
    end
    
    let(:award){ FactoryGirl.create :award, retailer: @retailer, phone_number: @membership.member.member_external_id }
    subject{award}

    it { should belong_to :retailer }
    it { should validate_presence_of :points }
    
    it "generates code automatically" do
      expect(award.code).to_not be nil
    end

    it "generates qr code image automatically" do
      expect(award.qr_code.exists?).to be true
    end

    it "generates qr code image named with award code" do
      expect(award.qr_code_file_name).to eq("#{award.code}.png")
    end

    describe "#update_membership_points" do    
      it "updates points of membership" do
        points = 10
        award =  FactoryGirl.create :award, retailer: @retailer, phone_number: @membership.member.member_external_id, points: points
        expect(@membership.points).to eq points
      end
    end

    describe "#create and then update membership points" do
      it "create membership first" do
        points = 10
        expect{
          @award = FactoryGirl.create :award, retailer: @retailer, phone_number: 1388888888, points: points
          @award.update_membership_points(1388888888)
        }.to change{Membership.count}.by(1)

        expect{
          @award = FactoryGirl.create :award, retailer: @retailer, phone_number: 1388888889, points: points
          @award.update_membership_points(1388888889)
        }.to change{Member.count}.by(1)

        expect(Member.where(member_external_id: @award.phone_number).count).to be(1)

        membership = Membership.all.select{|membership| membership.member.member_external_id == @award.phone_number && membership.retailer == @retailer }.first
        expect(membership.points).to be(10)
      end
    end

  end
end
