class SmsRiskNotification < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :membership

  after_create :send_sms_message

  def send_sms_message
    SMS::OneInfo.send_text(self.membership.retailer.setting.risk_message, self.membership.member.member_external_id).delay
  end
end
