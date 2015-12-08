module ApplicationHelper
  def format_tags tags
    tags.collect{|tag| "<div class='btn btn-mini btn-default'><span class='fa fa-tag'></span>#{tag}</div>&nbsp;"}.join("")
  end

  def current_owner
    if current_retailer && current_retailer.user_type == 'Owner'
      current_retailer
    elsif current_retailer && current_retailer.user_type == 'Employee'
      current_retailer.owner
    else
      nil
    end
  end
end
