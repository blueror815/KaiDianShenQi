class Api::V1::AwardsController < ApplicationController
  before_action :authenticate_with_token!
  respond_to :json

  def create
    award = Award.new(points: params[:points], retailer: current_oauth_retailer)

    if award.save
      render json: {success: true, qr_code_url: award.qr_code.url}
    else
      render json: {success: false, errors: award.errors}
    end
  end
end
