class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  layout :layout_by_resource

  include Authenticable
  include Wixin

  def layout_by_resource
    if devise_controller? && resource_name == :retailer && controller_name == "registrations" && 
      ( action_name == 'edit' || action_name == 'update' )
      "application"
    end
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

  def current_ability
    @current_ability ||= Ability.new(current_retailer)
  end

end
