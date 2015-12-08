class HomeController < ApplicationController
  before_filter :authenticate_retailer!
  def index
    @total_members = current_owner.members.count
    @new_user_revenue = current_owner.revenue_stat.new_user_revenue
    @regular_user_revenue = current_owner.revenue_stat.regular_user_revenue
    @vip_user_revenue = current_owner.revenue_stat.vip_user_revenue
  end

  def membership_audit
    @membership_audits = Audited::Adapters::ActiveRecord::Audit.where(auditable_type: 'Membership').select{|audit| audit.auditable.retailer == current_retailer}
  end
  def product_audit
    @product_audits = Audited::Adapters::ActiveRecord::Audit.where(auditable_type: 'Product').select{|audit| audit.auditable.retailer == current_retailer}
  end
end
