class MigrateLagecyRetailerForRevenueState < ActiveRecord::Migration
  def change
    Retailer.all.each do |ret|
      ret.attach_revenue_stat if ret.revenue_stat.nil?
    end
  end
end
