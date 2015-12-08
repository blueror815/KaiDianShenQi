class Promotion < ActiveRecord::Base
  validates_presence_of :retailer_id
  validates_presence_of :offer
  validates_presence_of :expiry_date

  belongs_to :retailer
  has_many :promotion_tags, dependent: :destroy
  has_many :promotion_sms_messages, dependent: :destroy
  has_many :promoted_orders, dependent: :destroy
end
