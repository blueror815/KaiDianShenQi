class Api::V1::RetailerSessionsController < ApplicationController
  respond_to :json

  def create
    user_password = params[:session][:password]
    user_name = params[:session][:user_name]

    retailer = Retailer.find_by_user_name user_name

    if user_name.present? && !retailer.nil? && retailer.valid_password?(user_password)
      sign_in retailer, store: false
      retailer.generate_retailer_authentication_token!

      retailer.save!
      render json: retailer, status: 200, location: [:api, retailer]
    else
      render json: { errors: "Invalid user_name or password" }, status: 422
    end
  end

  def destroy
    retailer = Retailer.find_by(auth_token: params[:id])
    retailer.generate_retailer_authentication_token!
    retailer.save
    head 204
  end
end
