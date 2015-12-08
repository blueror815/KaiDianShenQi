class PromotionSmsMessage < ActiveRecord::Base
  validates_presence_of :promotion_id
  validates_presence_of :membership_id
  validates_uniqueness_of :membership_id, scope: :promotion_id

  belongs_to :promotion
  belongs_to :membership

  after_create :send_sms

  # send a promotion message to user for real here
  def send_sms
    SMS::OneInfo.send_text(self.message, self.membership.member.member_external_id).delay
  end

  def is_active?
    self.promotion.expiry_date > Time.now
  end
end
