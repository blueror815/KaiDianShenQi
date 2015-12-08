#encoding: utf-8
class Retailer < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :authentication_keys => [:user_name]

  before_create :generate_retailer_authentication_token!
  after_create :generate_profile_qr_image

  PERMISSION_MODULES = %w(Product Promotion Member)

  has_attached_file :profile_qr_image
  validates_attachment_content_type :profile_qr_image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]

  validates :user_name, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, allow_nil: true, confirmation: true
  validates :auth_token, uniqueness: true


  # statistics go here
  has_one :revenue_stat, dependent: :destroy
  has_one :sign_up_progress, dependent: :destroy

  # functionalities go here
  belongs_to :owner, foreign_key: :owner_id, class_name: 'Retailer'
  has_many :employees, foreign_key: :owner_id, class_name: 'Retailer'

  has_one :setting, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :promotions, dependent: :destroy
  has_many :permissions, dependent: :destroy
  has_many :memberships, dependent: :destroy
  has_many :members, through: :memberships, dependent: :destroy
  has_many :awards

  after_create :attach_setting, :attach_sign_up_progress, :attach_revenue_stat

  def attach_setting
    Setting.create(retailer: self,
      no_of_order_to_send_growth_sms: 3, 
      no_of_days_to_send_lapse_message: 5, 
      welcome_message: "Welcome to the community."
    )
  end

  def attach_revenue_stat
    RevenueStat.create(retailer: self,
                       new_user_revenue: 0,
                       regular_user_revenue: 0,
                       vip_user_revenue: 0
    )
  end

  def attach_sign_up_progress
    SignUpProgress.create(
        retailer: self,
        sign_up_so_far: 0,
        sign_up_goal: 100,
        refresh_sign_up_every_days: 7
    )
  end

  def add_points_to_member!(new_points, member_external_id)
    member = Member.find_by(:member_external_id => member_external_id)
    if member.nil?
      return {errors: "This member_external_id doesn't exist"}
    else
      membership = self.memberships.where(member_id: member[:id]).first_or_create

      # Add some restrictions here
      current_points = membership[:points]
      updated_points = current_points + new_points
      membership.update_attribute(:points, updated_points)

      closest_award = self.products.order(:point_value).first
      store_name = self.user_name

      # now we send text whenever a user shops at a retailer
      if closest_award.nil?
        message ="您刚刚在店家【" + store_name + "】获得" + new_points.to_s + "点积分。店家正在筹备兑换计划，敬请关注。~萌萌哒~"
      else
        point_diff = closest_award.point_value - updated_points
        if point_diff > 0
          message ="您刚刚在店家【" + store_name + "】消费并积分" + new_points.to_i.to_s + "点。再积分" + point_diff.to_i.to_s + "即可兑换"+ closest_award.title
        else
          message ="您刚刚在店家【" + store_name + "】消费并积分" + new_points.to_i.to_s + "点。已可以兑换{"+ closest_award.title + "}等赠品"
        end
      end

      SMS::OneInfo.send_text(
          message,
          member_external_id
      ).delay
      membership
    end
  end


  def can_access?(module_name, access_level)
    permissions.find_by_module_name(module_name).try(access_level)
  end

  def generate_profile_qr_image
    url = "#{Rails.application.secrets.wechat_redirect_url}/w_retailers/#{self.id}"
    client = WeixinAuthorize::Client.new(Rails.application.secrets.wechat_app_id, Rails.application.secrets.wechat_app_secret)
    wechat_url = client.authorize_url(url, "snsapi_userinfo")

    qr = RQRCode::QRCode.new( "#{wechat_url}", :size => 15, :level => :l )
    png = qr.to_img                                             # returns an instance of ChunkyPNG
    png.resize(500, 500).save("tmp/#{self.id}.png")
    self.profile_qr_image = File.new("tmp/#{self.id}.png")
    self.save
  end

  # Explicitly override the two methods to user user_name instead of email in Devise
  def email_required?
    false
  end

  def email_changed?
    false
  end
  def generate_retailer_authentication_token!
    begin
      self.auth_token = Devise.friendly_token 
    end while self.class.exists?(auth_token: self.auth_token)
  end
end
