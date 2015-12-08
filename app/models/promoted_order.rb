class PromotedOrder < ActiveRecord::Base
  validates_presence_of :order_id
  validates_presence_of :promotion_id

  belongs_to :promotion
  belongs_to :order
end
