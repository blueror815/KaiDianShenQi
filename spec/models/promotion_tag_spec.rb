require 'rails_helper'

RSpec.describe PromotionTag, type: :model do
  it {should validate_presence_of :promotion_id}
  it {should belong_to :promotion}

  describe "#send_promotion_message" do
    let!(:promotion_tag){FactoryGirl.create :promotion_tag, tag: 'test-tag'}

    before do
      @member = FactoryGirl.create :member
      @membership = FactoryGirl.create :membership, member_id: @member.id
      @membership.tag_list.add("test-tag")
      @membership.save
    end

    it "sends sms to members with membership of reailer having same tag" do
      retailer = promotion_tag.promotion.retailer
      retailer.memberships.push @membership
      retailer.save!
      retailer.reload
      
      expect{ 
        promotion_tag.send_promotion_message
      }.to change{
        @membership.promotion_sms_messages.count
      }.by 1
    end

    it "does not sends sms to member without membership" do
      expect{
        promotion_tag.send_promotion_message
      }.to change{
        @membership.promotion_sms_messages.count
      }.by 0
    end

    it "doesn't send multiple sms even if user has multiple tags selected in campaign" do
      retailer = promotion_tag.promotion.retailer
      retailer.memberships.push @membership
      retailer.save!
      retailer.reload
    
      previous_promotion_sms_message = FactoryGirl.create(:promotion_sms_message, promotion: promotion_tag.promotion, membership: @membership)
      promotion_tag.promotion.reload
   
      @membership.tag_list.add("new-tag")
      @membership.save
    
      new_promotion_tag = FactoryGirl.create :promotion_tag, tag: 'test-tag', promotion: promotion_tag.promotion
      expect{
        new_promotion_tag.send_promotion_message
      }.to change{
        @membership.promotion_sms_messages.count
      }.by 0
    end
  end
end
