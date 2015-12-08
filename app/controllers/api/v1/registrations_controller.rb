=begin
class Api::V1::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  def create
    retailer = Retailer.new(retailers_params)
    if retailer.save
      render json: retailer, status: 201, location: [:api, retailer]
    else
      render json: {errors: retailer.errors}, status: 422
    end
  end

  private
  def retailers_params
    params.require(:retailer).permit(:user_name, :password, :password_confirmation)
  end
end
=end
