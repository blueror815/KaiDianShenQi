class Order < ActiveRecord::Base
  CASH = "cash"
  POINTS_PAYMENT_METHOD = "points"
  belongs_to :retailer, :validate => true
  belongs_to :member

  has_many :placements, dependent: :destroy
  has_many :products, through: :placements


  validates_associated :products
  validates_associated :placements

  validates :total_charge, :numericality => { :greater_than_or_equal_to => 0}, :presence => true
  validates :retailer_id, :presence => true


  # Comment this out since right now we just treat everything in stock as infinity
  #validates_with EnoughProductsValidator

  validates_with OnlyCashOrPointsOrderValidator

  after_create :attach_associated_promotion

  def attach_associated_promotion
    if self.member
      self.member.memberships.each do |membership|
        associated_promotions_messages = PromotionSmsMessage.where(membership_id: membership.id)

        associated_promotions_messages.each do |message|
          if message.is_active?
            PromotedOrder.create(promotion: message.promotion, order: self)
          end
        end
      end
    end
  end

  def set_total_charge
    self.total_charge = 0
    placements.each do |placement|
      self.total_charge += placement.product.price * placement.quantity
    end
  end

  def set_total_points_charge
    self.total_points_charge = 0
    placements.each do |placement|
      self.total_points_charge += placement.product.point_value * placement.quantity
    end
  end

  def checkout_cash(current_retailer, product_ids_with_quantities, member_external_id)
    current_retailer.orders << self
    self.payment_method = CASH
    self.build_placements(product_ids_with_quantities)
    self.set_total_charge

    if member_external_id.blank?
      self.save
      self.reload
      return self
    else
      member = Member.find_by(member_external_id: member_external_id)
      if member
        self.add_points(member)
        self.save
        self.reload
        return self
      else
        return {errors: "Not a member or wrong membership id. Please register first"}
      end
    end
  end


  def checkout_points(current_retailer, product_ids_with_quantities, member_external_id)
    current_retailer.orders << self
    self.payment_method = POINTS_PAYMENT_METHOD
    self.build_placements(product_ids_with_quantities)
    self.set_total_points_charge
    if member_external_id.blank?
      return {errors: "No member id provided. Can't checkout with points"}
    else
      member = Member.find_by(member_external_id: member_external_id)
      return {errors: "Member-id provided is not a valid member id"} if member.nil?
      membership = Membership.find_by(member_id: member.id, retailer_id: self.retailer.id)
      if membership.nil?
        return {errors: "0 membership points"}
      else
        if self.total_points_charge > membership.points
          return {errors: "Not enough points to complete this checkout"}
        else
          membership.update_attribute(:points, membership.points - self.total_points_charge)
          self.update_attribute(:member_id, member.id)
          self.save!
          self.reload
          return self
        end
      end
    end
  end

  def build_placements(product_ids_and_quantities)
    product_ids_and_quantities.each do |product_id_and_quantity|
      id, quantity = product_id_and_quantity
      self.placements.build(product_id: id, quantity: quantity)
    end
  end

  def add_points(member)
    membership = Membership.find_or_create_by(member: member, retailer: self.retailer)
    membership.update_attribute(:points, membership.points + 1)
  end
end


