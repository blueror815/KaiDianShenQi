class Setting < ActiveRecord::Base
  has_attached_file :qr_image, default_url: 'qr_code.jpg'
  validates_attachment_content_type :qr_image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]

  validates_presence_of :retailer_id
  validates_uniqueness_of :retailer_id

  belongs_to :retailer
end
