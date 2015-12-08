require 'spec_helper'
require 'rails_helper'

describe Membership do
  describe "membersip relations" do
    let(:membership){FactoryGirl.create :membership}
    subject {membership}
    it {should validate_numericality_of(:points).is_greater_than_or_equal_to(0)}
    it { should validate_uniqueness_of(:member_id).scoped_to(:retailer_id) }
    
    it {should respond_to :member_id}
    it {should respond_to :retailer_id}
    it {should respond_to :points}
    
    it {should belong_to :retailer }
    it {should belong_to :member }
    it {should belong_to :membership_type }

    it {should have_one :sms_first_visit }
    it {should have_many :sms_growth_visits }
    it {should have_many :promotion_sms_messages }
    
    it "has right amount" do
      expect(membership[:points]).to eq 10
    end
  end

  describe "#sms_first_visit" do
    let(:membership){ FactoryGirl.create(:membership) }
    subject {membership}

    it "increases sms first visit by 1" do
      expect(membership.sms_first_visit).to be nil
      membership.send_first_time_msg
      expect(membership.sms_first_visit).to_not be nil
    end
  end  

  describe "#sms_growth_visit" do
    context "a membership" do
      before do
        @retailer = FactoryGirl.create(:retailer)
        @member = FactoryGirl.create(:member)
        @membership = FactoryGirl.create :membership, retailer_id: @retailer.id, member_id: @member.id, points: 10
      end

      it "should not send sms when we only have 2 orders" do
        2.times {order1 = FactoryGirl.create :order, retailer_id: @retailer.id, member_id: @member.id}
        expect{
          @membership.send_growth_msg
        }.to change{@membership.sms_growth_visits.count}.by(0)
      end

      it "should send sms if we have three more orders" do
        3.times {order1 = FactoryGirl.create :order, retailer_id: @retailer.id, member_id: @member.id}
        expect{
          @membership.send_growth_msg
        }.to change{@membership.sms_growth_visits.count}.by(1)
      end

      it "should send two sms if we have 8 (3+5) orders" do
        3.times {order1 = FactoryGirl.create :order, retailer_id: @retailer.id, member_id: @member.id}
        expect{
          @membership.send_growth_msg
        }.to change{@membership.sms_growth_visits.count}.by(1)
        5.times {order1 = FactoryGirl.create :order, retailer_id: @retailer.id, member_id: @member.id}
        expect{
          @membership.send_growth_msg
        }.to change{@membership.sms_growth_visits.count}.by(1)
      end

    end
  end

  describe "#sms_at_risk" do
    context "at risk" do
      before do
        @retailer = FactoryGirl.create(:retailer)
        @retailer.setting.no_of_days_to_send_lapse_message = 30
        @member = FactoryGirl.create(:member)
        @membership = FactoryGirl.create :membership, retailer: @retailer, member: @member, points: 10
      end

      it "doesn't send out at risk email since this user never been the store before" do
        FactoryGirl.create :order, created_at: 20.days.ago
        expect{
          @membership.send_at_risk_msg
        }.to change{@membership.sms_risk_notifications.count}.by(0)
      end

      it "should send out at risk email now since a user hasn't been to store for 31 days" do
        # order now
        FactoryGirl.create :order, retailer_id: @retailer.id, member_id: @member.id
        travel_to 31.days.from_now do
          expect{
            @membership.send_at_risk_msg
          }.to change{@membership.sms_risk_notifications.count}.by(1)
        end
      end
      it "should not send out at risk email since a user hasn't been to store only for 29 days" do
        FactoryGirl.create :order, retailer_id: @retailer.id, member_id: @member.id
        travel_to 29.days.from_now do
          expect{
            @membership.send_at_risk_msg
          }.to change{@membership.sms_risk_notifications.count}.by(0)
        end
      end
    end
  end

  describe "append_member_type_tag:for_vip" do
    let!(:retailer){FactoryGirl.create(:retailer)}
    let!(:membership){FactoryGirl.create(:membership, retailer: retailer)}

    it "tags as VIP if more then 20 orders are placed by a member" do
      21.times do
        FactoryGirl.create(:order, member: membership.member, retailer: retailer)
      end

      #subject.invoke
      membership.decide_type
      expect(membership.tag_list.include?('VIP') ).to be true
    end

    it "tags as VIP if less then 20 orders are placed by a member" do
      19.times do
        FactoryGirl.create(:order, member: membership.member, retailer: retailer)
      end
      membership.decide_type
      expect(membership.tag_list.include?('VIP') ).to be false
      end
  end

  describe "append_member_type_tag:for_regular" do
    let!(:retailer){FactoryGirl.create(:retailer)}
    let!(:membership){FactoryGirl.create(:membership, retailer: retailer)}

    it "tags as Regular if more than 5 orders are placed by a member" do
      6.times do
        FactoryGirl.create(:order, member: membership.member, retailer: retailer)
      end
      membership.decide_type
      expect(membership.tag_list.include?('常客') ).to be true
    end
    it "tags as Regular if less then 5 orders are placed by a member" do
      4.times do
        FactoryGirl.create(:order, member: membership.member, retailer: retailer)
      end
      membership.decide_type
      expect(membership.tag_list.include?('常客') ).to be false
    end
  end

  describe "append_member_type_tag:for_new" do
    let!(:retailer){FactoryGirl.create(:retailer)}
    let!(:membership){FactoryGirl.create(:membership, retailer: retailer)}

    it "tags as new if membership created less then 3 days ago" do
      membership.update_attribute(:created_at, 2.days.ago)
      membership.decide_type
      expect(membership.tag_list.include?('新注册') ).to be true
    end

    it "removes new tag if member is more then 4 days old" do
      membership.tag_list.add("新注册")
      membership.update_attribute(:created_at, 4.days.ago)
      membership.save

      membership.decide_type
      expect(membership.tag_list.include?('新注册') ).to be false
    end
  end

  describe "append member type tag for inactive" do
    let!(:retailer){FactoryGirl.create(:retailer)}
    let!(:membership){FactoryGirl.create(:membership, retailer: retailer)}

    it "tags as inactive if membership created more then 3 days ago and didn't placed any order" do
      membership.update_attribute(:created_at, 4.days.ago)
      membership.decide_type
      expect(membership.tag_list.include?('沉睡') ).to be true
    end
    it "removes tag of inactive if membership created more then 3 days ago and places any order" do
      FactoryGirl.create(:order, member: membership.member, retailer: retailer)
      membership.tag_list.add("沉睡")
      membership.update_attribute(:created_at, 4.days.ago)
      membership.save
      membership.reload

      membership.decide_type
      expect(membership.tag_list.include?('沉睡') ).to be false
    end
  end
  describe "audited" do
    it "stores all the changes in all attributes" do
      new_membership = FactoryGirl.create :membership
      expect{
        new_membership.update_attribute(:points, 25)
      }.to change{
        Audited::Adapters::ActiveRecord::Audit.count
      }.by 1
    end
  end
end
