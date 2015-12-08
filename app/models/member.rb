#encoding: utf-8
require 'sms'

class Member < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :authentication_keys => [:member_external_id]

  after_initialize :assign_default_password
  before_create :generate_member_authentication_token!
  after_create :send_first_sms

  has_many :memberships, dependent: :destroy
  has_many :retailers, through: :memberships

  has_many :orders, dependent: :destroy

  validates :member_external_id, presence: true
  validates :member_external_id, uniqueness: true

  # Explicitly override the two methods to user user_name instead of email in Devise
  def email_required?
    false
  end

  def email_changed?
    false
  end

  def associate_client_id(client_id)
    self.update_attribute(:client_id, client_id)
  end

  def destroy_client_id
    self.update_attribute(:client_id, "")
  end

  def generate_member_authentication_token!
    begin
      self.auth_token = Devise.friendly_token
    end while self.class.exists?(auth_token: self.auth_token)
  end

  def assign_default_password
    # initialize password to be a random number, this will be sent to user's phone
    random_number = (rand(99999999)+10000000).to_s

    # Hard code now for testing purpose
    random_number = "123456789"

    self.password = random_number
    self.password_confirmation = random_number
  end

  def send_first_sms
    SMS::OneInfo.send_text(
      "感谢您注册快享积分!我们将适时向您推送您喜爱且同意向您发送折扣的商家，我们保证每月您收到的短信推送不超过5条", self.member_external_id
    ).delay
  end
end
