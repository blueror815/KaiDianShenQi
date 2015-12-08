class Award < ActiveRecord::Base

  has_attached_file :qr_code
  validates_attachment_content_type :qr_code, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  validates_presence_of :points

  belongs_to :retailer

  before_create :attach_code
  after_create :delete_junk_image

  def delete_junk_image
    File.delete("public/#{self.code}.png")
  end

  def update_membership_points(member_external_id)
    membership = self.retailer.memberships.select{|membership| membership.member.member_external_id == self.phone_number}.first
    if membership.nil?

      # create this member if he's new to our system.
      member = Member.where(member_external_id: self.phone_number).create

      # and create the membership set the points to be 0
      membership = Membership.create(member: member, retailer: self.retailer, points: 0)
    end

    membership.update_attribute(:points, (membership.points.to_i + self.points.to_i) ) if membership
  end

  def attach_code

    tag_code = 5.times.map { [*'0'..'9', *'a'..'z'].sample }.join
    tag_code = 5.times.map { [*'0'..'9', *'a'..'z'].sample }.join until Award.where(code: tag_code).count == 0
    self.code = tag_code

    client = WeixinAuthorize::Client.new(Rails.application.secrets.wechat_app_id, Rails.application.secrets.wechat_app_secret)
    wechat_url = client.authorize_url("#{Rails.application.secrets.wechat_redirect_url}/w_members/introduce?token=#{tag_code}", "snsapi_userinfo")

    # This wechat_url will be encoded into QR code, and a customer will scan it to go to a page where he can
    # enter his phone number. Then the points will be added to that phone number. Also, we need to store the pair
    # (code, membership, retailer_id)

    # puts "###############################################"
    # puts "###############################################"
    # puts wechat_url
    # puts "###############################################"
    # puts "###############################################"

    qr = RQRCode::QRCode.new( "#{wechat_url}", :size => 15, :level => :l )
    png = qr.to_img                                             # returns an instance of ChunkyPNG
    png.resize(500, 500).save("public/#{tag_code}.png")
    self.qr_code = File.new("public/#{tag_code}.png")
  end
end
