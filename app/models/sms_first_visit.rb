require 'sms'
class SmsFirstVisit < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :membership

  after_create :send_sms_message

  def send_sms_message
    SMS::OneInfo.send_text("welcome!!", "14721230344").delay
  end
end
