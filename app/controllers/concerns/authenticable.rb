module Authenticable
  # Devise methods overwrites
  def current_oauth_retailer
    @current_oauth_retailer ||= Retailer.find_by(auth_token: request.headers['Authorization'])
  end


  def current_member
    @current_member = Member.find_by(auth_token: request.headers['Authorization'])
  end

  def authenticate_with_token_member!
    render json: { errors: "Not authenticated" },
           status: :unauthorized unless current_member.present?
  end


  def authenticate_with_token!
    render json: { errors: "Not authenticated" },
           status: :unauthorized unless current_oauth_retailer.present?
  end

  def ratailer_signed_in?
    current_oauth_retailer.present?
  end
end
