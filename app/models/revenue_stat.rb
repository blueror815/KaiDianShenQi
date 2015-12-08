class RevenueStat < ActiveRecord::Base
  belongs_to :retailer

  validates_presence_of :retailer_id
  validates_uniqueness_of :retailer_id

  # Only compute revenue for the reserved_tags (i.e. new, regular, vip) users
  def compute_revenue
    def compute_revenue_for_type(type)
      # Revenue should equal the points generated. i.e. it should be the amount of points in Memberships' account, plus
      # all the points in orders (since those points are redeemed)
      # sum up all the points in memberships' accounts
      points_in_accounts = self.retailer.memberships.select{|membership| membership.membership_type.name == type}
                               .map{|membership| membership.points}
                               .reduce(0){|acc, e| acc + e}

      points_in_orders = 0

      self.retailer.orders.each do |order|
        membership = Membership.find_by(member: order.member, retailer: self.retailer)
        if !membership.nil? && membership.membership_type.name == type
          points_in_orders += order.total_points_charge
        end
      end
      points_in_accounts + points_in_orders
    end

    # compute revenue for real here
    [["新注册", "new_user_revenue"], ["常客", "regular_user_revenue"], ["VIP", "vip_user_revenue"]]
        .map{|type, column_name| self.update_attribute(column_name, compute_revenue_for_type(type))}
  end
end
