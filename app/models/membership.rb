#encoding: utf-8
require 'sms'
include SMS

class Membership < ActiveRecord::Base
  include OneInfo
  acts_as_taggable
  audited

  belongs_to :retailer, inverse_of: :memberships, validate: true
  belongs_to :member, inverse_of: :memberships, validate: true
  belongs_to :membership_type

  has_one :sms_first_visit, dependent: :destroy
  has_many :sms_growth_visits, dependent: :destroy
  has_many :sms_risk_notifications, dependent: :destroy
  has_many :promotion_sms_messages, dependent: :destroy

  validates :points, numericality: { greater_than_or_equal_to: 0}, presence: true
  validates_uniqueness_of :member_id, scope: :retailer_id

  after_create :add_sign_up

  def add_sign_up
    so_far = self.retailer.sign_up_progress.sign_up_so_far
    self.retailer.sign_up_progress.update_attribute(:sign_up_so_far, so_far + 1)
  end


  def decide_type
    # this function decide what type a membership is
    # orders in a month
    days_from_creation = (Time.now - self.created_at) / 24.hours

    # Orders in 30 days
    orders = Order.where(retailer_id: self.retailer.id, member_id: self.member.id).where("created_at > ?", 1.month.ago)

    def replace_tag(new_tag)
      ["VIP", "常客", "新注册", "沉睡"].each do |tag|
        self.tag_list.remove(tag)
      end
      self.tag_list.add(new_tag)
    end

    if orders.count >= 20
      # VIP
      replace_tag("VIP")
    elsif orders.count >=5
      #retular
      replace_tag("常客")
    elsif days_from_creation <= 3
      # new
      replace_tag("新注册")
    elsif orders.count ==0
      #inactive
      replace_tag("沉睡")
    else
      self.tag_list.remove("沉睡")
    end
    self.save
  end

  def send_first_time_msg
    if self.sms_first_visit.nil?
      self.create_sms_first_visit membership: self
    end
  end

  # every X visits gives a reward
  def send_growth_msg
    # get the latest record
    growth_visit_record = self.sms_growth_visits.order(:created_at).last

    if growth_visit_record.nil?
      previous_visit_count = 0
    else
      previous_visit_count = growth_visit_record.visit_count
    end

    order_cnt = Order.where(member_id: self.member_id).count
    # here, if the number of orders - visit_count >= X
    # meaning the user has been visiting the store more than X times since last sending growth msg
    # we send a msg
    # update a record in sms
    if ( (order_cnt - previous_visit_count) ) >= self.retailer.setting.no_of_order_to_send_growth_sms.to_i
      self.sms_growth_visits.create(visit_count: order_cnt, membership_id: self.id)
      # send here
      # update a record in sms
    end
  end

  def send_at_risk_msg
    # we send a at risk msg when
    # 1) the user hasn't have any order for self.no_of_days_to_send_lapsed_message days &&
    # 2) the user hasn't been sent any at_risk message for the same period of time

    last_visit = (Order.where(member_id: self.member_id).order(:created_at)).last

    last_visit_time = last_visit.nil? ? self.created_at.to_i : last_visit.created_at.to_i

    last_risk_notification_time = if self.sms_risk_notifications.order(:created_at).last.nil? 
        self.created_at.to_i 
      else
        self.sms_risk_notifications.order(:created_at).last.created_at.to_i
      end

    days_since_last_order = (Time.now - last_visit_time).to_i / 86400
    days_since_last_at_risk_msg = (Time.now.to_i - last_risk_notification_time) / 86400

    no_of_days_to_send_risk_msg = self.retailer.setting.no_of_days_to_send_lapse_message
    if days_since_last_order >= no_of_days_to_send_risk_msg &&
        days_since_last_at_risk_msg >= no_of_days_to_send_risk_msg
      self.sms_risk_notifications.create membership: self
    end
  end


end

