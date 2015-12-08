class PromotionTag < ActiveRecord::Base

  validates_presence_of :promotion_id

  belongs_to :promotion

  after_create :send_promotion_message

  def send_promotion_message
    retailer = self.promotion.retailer

    existing_members = self.promotion.promotion_sms_messages.collect(&:membership)
    memberships = retailer.memberships.select{|membership| membership.tag_list.include?(self.tag)}

    new_memberships = memberships - existing_members
    new_memberships.each do |membership|
      PromotionSmsMessage.create(
          membership: membership,
          promotion: self.promotion,
          message: "#{self.promotion.offer}\n#{self.promotion.occation}"[0..160]
      )
    end
  end
end
